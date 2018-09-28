(* uberspark config tool: to locate hwm, libraries and headers *)
(* author: amit vasudevan (amitvasudevan@acm.org) *)

open Sys
open Unix
open Filename

open Uslog
open Libusmf

let log_mpf = "uberSpark";;

let g_install_prefix = "/usr/local";;
let g_uberspark_install_bindir = "/usr/local/bin";;
let g_uberspark_install_homedir = "/usr/local/uberspark";;
let g_uberspark_install_includedir = "/usr/local/uberspark/include";;
let g_uberspark_install_hwmdir = "/usr/local/uberspark/hwm";;
let g_uberspark_install_hwmincludedir = "/usr/local/uberspark/hwm/include";;
let g_uberspark_install_libsdir = "/usr/local/uberspark/libs";;
let g_uberspark_install_libsincludesdir = "/usr/local/uberspark/libs/include";;
let g_uberspark_install_toolsdir = "/usr/local/uberspark/tools";;

(* standard definitions *)
let g_uberspark_pp_std_defines = [ "-D"; "__XMHF_TARGET_CPU_X86__"; 
																	"-D"; "__XMHF_TARGET_CONTAINER_VMX__";
																	"-D"; "__XMHF_TARGET_PLATFORM_X86PC__";
																	"-D"; "__XMHF_TARGET_TRIAD_X86_VMX_X86PC__"
																	];;

let g_uberspark_pp_std_define_assembly = ["-D"; "__ASSEMBLY__"];;


(* external tools *)
let g_uberspark_exttool_pp = "gcc";;
let g_uberspark_exttool_cc = "gcc";;
let g_uberspark_exttool_ld = "ld";;

let copt_builduobj = ref false;;

let cmdopt_invalid opt = 
	Uslog.logf log_mpf Uslog.Info "invalid option: '%s'; use -help to see available options" opt;
	ignore(exit 1);
	;;

let cmdopt_uobjlist = ref "";;
let cmdopt_uobjlist_set value = cmdopt_uobjlist := value;;

let cmdopt_uobjmanifest = ref "";;
let cmdopt_uobjmanifest_set value = cmdopt_uobjmanifest := value;;


let file_copy input_name output_name =
	let buffer_size = 8192 in
	let buffer = Bytes.create buffer_size in
  let fd_in = openfile input_name [O_RDONLY] 0 in
  let fd_out = openfile output_name [O_WRONLY; O_CREAT; O_TRUNC] 0o666 in
  let rec copy_loop () = match read fd_in buffer 0 buffer_size with
    |  0 -> ()
    | r -> ignore (write fd_out buffer 0 r); copy_loop ()
  in
  copy_loop ();
  close fd_in;
  close fd_out;
	()
;;


(* execute a process and print its output if verbose is set to true *)
(* return the error code of the process and the output as a list of lines *)
let exec_process_withlog p_name cmdline verbose =
	let readme, writeme = Unix.pipe () in
	let pid = Unix.create_process
		p_name (Array.of_list ([p_name] @ cmdline))
    Unix.stdin writeme writeme in
  Unix.close writeme;
  let in_channel = Unix.in_channel_of_descr readme in
  let p_output = ref [] in
	let p_singleoutputline = ref "" in
	let p_exitstatus = ref 0 in
	let p_exitsignal = ref false in
  begin
    try
      while true do
				p_singleoutputline := input_line in_channel;
				if verbose then
					Uslog.logf log_mpf Uslog.Info "%s" !p_singleoutputline;
										
				p_output := p_singleoutputline :: !p_output 
	    done
    with End_of_file -> 
			match	(Unix.waitpid [] pid) with
    	| (wpid, Unix.WEXITED status) ->
        	p_exitstatus := status;
					p_exitsignal := false;
    	| (wpid, Unix.WSIGNALED signal) ->
        	p_exitsignal := true;
    	| (wpid, Unix.WSTOPPED signal) ->
        	p_exitsignal := true;
			;
			()
  end;

	Unix.close readme;
	(!p_exitstatus, !p_exitsignal, (List.rev !p_output))
;;


let uberspark_build_includedirs_base () = 
  let p_output = ref [] in
		p_output := !p_output @ [ "-I" ];
		p_output := !p_output @ [ g_uberspark_install_includedir ];
		p_output := !p_output @ [ "-I" ];
		p_output := !p_output @ [ g_uberspark_install_hwmincludedir ];
		p_output := !p_output @ [ "-I" ];
		p_output := !p_output @ [ g_uberspark_install_libsincludesdir ];
		(!p_output)		
;;	

let uberspark_build_includedirs uobj_id uobj_hashtbl_includedirs = 
  let p_output = ref [] in
	let uobj_hashtbl_includedirs_list = (Hashtbl.find_all uobj_hashtbl_includedirs uobj_id) in 
		List.iter (fun x -> p_output := !p_output @ [ "-I" ] @ [ x ]) uobj_hashtbl_includedirs_list;
	(!p_output)		
;;	


let uberspark_generate_uobj_mf_forpreprocessing uobj_id uobj_manifest_filename uobj_hashtbl_includes =
  let uobj_out_manifest_filename = (uobj_manifest_filename ^ ".c") in
	let fd_in = openfile uobj_manifest_filename [O_RDONLY] 0 in
  let fd_out = openfile uobj_out_manifest_filename [O_WRONLY; O_CREAT; O_TRUNC] 0o666 in
	let uobj_hashtbl_includes_list = (Hashtbl.find_all uobj_hashtbl_includes uobj_id) in 
	let uobj_includes_str = ref "" in

		List.iter (fun x -> uobj_includes_str := !uobj_includes_str ^ "#include <" ^ x ^ ">\r\n") uobj_hashtbl_includes_list;
		uobj_includes_str := !uobj_includes_str ^ "\r\n";
		ignore(write_substring fd_out !uobj_includes_str 0 (String.length !uobj_includes_str));

	let buffer_size = 8192 in
	let buffer = Bytes.create buffer_size in
  let rec copy_loop () = match read fd_in buffer 0 buffer_size with
    |  0 -> ()
    | r -> ignore (write fd_out buffer 0 r); copy_loop ()
  in
  copy_loop ();
	
  close fd_in;
  close fd_out;
	(uobj_out_manifest_filename)
;;


let uberspark_generate_uobj_mf_preprocessed 
	uobj_id uobj_manifest_filename_forpreprocessing uobj_includedirs_list =
	  let uobj_mf_filename_preprocessed = 
			((Filename.basename uobj_manifest_filename_forpreprocessing) ^ ".pp") in
		let pp_cmdline = ref [] in
			pp_cmdline := !pp_cmdline @ [ "-E" ];
			pp_cmdline := !pp_cmdline @ [ "-P" ];
			pp_cmdline := !pp_cmdline @ g_uberspark_pp_std_defines;
			pp_cmdline := !pp_cmdline @ g_uberspark_pp_std_define_assembly;
			pp_cmdline := !pp_cmdline @ uobj_includedirs_list;
			pp_cmdline := !pp_cmdline @ [ uobj_manifest_filename_forpreprocessing ];
			pp_cmdline := !pp_cmdline @ [ "-o" ];
			pp_cmdline := !pp_cmdline @ [ uobj_mf_filename_preprocessed ];
			ignore(exec_process_withlog g_uberspark_exttool_pp !pp_cmdline true);
	(uobj_mf_filename_preprocessed)
;;



let uberspark_compile_uobj_cfile uobj_cfile_name uobj_includedirs_list = 
		let cc_cmdline = ref [] in
			cc_cmdline := !cc_cmdline @ [ "-c" ];
			cc_cmdline := !cc_cmdline @ [ "-m32" ];
			cc_cmdline := !cc_cmdline @ [ "-fno-common" ];
			cc_cmdline := !cc_cmdline @ g_uberspark_pp_std_defines;
(*			cc_cmdline := !cc_cmdline @ g_uberspark_pp_std_define_assembly; *)
			cc_cmdline := !cc_cmdline @ uobj_includedirs_list;
			cc_cmdline := !cc_cmdline @ [ uobj_cfile_name ];
			cc_cmdline := !cc_cmdline @ [ "-o" ];
			cc_cmdline := !cc_cmdline @ [ (uobj_cfile_name ^ ".o") ];
			(exec_process_withlog g_uberspark_exttool_cc !cc_cmdline true)
;;


let uberspark_compile_uobj_cfiles uobj_cfile_list uobj_includedirs_list = 
	List.iter (fun x ->  
							Uslog.logf log_mpf Uslog.Info "Compiling: %s" x;
							let (pestatus, pesignal, poutput) = 
								(uberspark_compile_uobj_cfile x uobj_includedirs_list) in
									begin
										if (pesignal == true) || (pestatus != 0) then
											begin
													(* Uslog.logf log_mpf Uslog.Info "output lines:%u" (List.length poutput); *)
													(* List.iter (fun y -> Uslog.logf log_mpf Uslog.Info "%s" !y) poutput; *) 
													(* Uslog.logf log_mpf Uslog.Info "%s" !(List.nth poutput 0); *)
													Uslog.logf log_mpf Uslog.Error "in compiling %s!" x;
													ignore(exit 1);
											end
										else
											begin
													Uslog.logf log_mpf Uslog.Info "Compiled %s successfully" x;
											end
									end
						) uobj_cfile_list;
	()
;;

								
let uberspark_link_uobj uobj_cfile_list uobj_libdirs_list uobj_libs_list 
		uobj_linker_script uobj_bin_name = 
		let ld_cmdline = ref [] in
			ld_cmdline := !ld_cmdline @ [ "--oformat" ];
			ld_cmdline := !ld_cmdline @ [ "binary" ];
			ld_cmdline := !ld_cmdline @ [ "-T" ];
			ld_cmdline := !ld_cmdline @ [ uobj_linker_script ]; 
			List.iter (fun x -> ld_cmdline := !ld_cmdline @ [ (x^".o") ]) uobj_cfile_list; 
			ld_cmdline := !ld_cmdline @ [ "-o" ];
			ld_cmdline := !ld_cmdline @ [ uobj_bin_name ];
			List.iter (fun x -> ld_cmdline := !ld_cmdline @ [ ("-L"^x) ]) uobj_libdirs_list; 
			ld_cmdline := !ld_cmdline @ [ "--start-group" ];
			List.iter (fun x -> ld_cmdline := !ld_cmdline @ [ ("-l"^x) ]) uobj_libs_list; 
			ld_cmdline := !ld_cmdline @ [ "--end-group" ];
			let (pestatus, pesignal, poutput) = 
				(exec_process_withlog g_uberspark_exttool_ld !ld_cmdline true) in
						if (pesignal == true) || (pestatus != 0) then
							begin
									Uslog.logf log_mpf Uslog.Error "in linking uobj binary '%s'!" uobj_bin_name;
									ignore(exit 1);
							end
						else
							begin
									Uslog.logf log_mpf Uslog.Info "Linked uobj binary '%s' successfully" uobj_bin_name;
							end
						;
		()
;;

																
let uberspark_generate_uobj_linker_script uobj_name uobj_load_addr 
	uobj_sections_list = 
	let uobj_linker_script_filename = (uobj_name ^ ".lscript") in
	let uobj_section_load_addr = ref 0 in
	let oc = open_out uobj_linker_script_filename in
		Printf.fprintf oc "\n/* autogenerated uberSpark uobj linker script */";
		Printf.fprintf oc "\n/* author: amit vasudevan (amitvasudevan@acm.org) */";
		Printf.fprintf oc "\n";
		Printf.fprintf oc "\n";
		Printf.fprintf oc "\nOUTPUT_ARCH(\"i386\")";
		Printf.fprintf oc "\n";
		Printf.fprintf oc "\nMEMORY";
		Printf.fprintf oc "\n{";

		uobj_section_load_addr := uobj_load_addr;
		
		List.iter (fun x ->
			(* new section *)
			let memregion_name = ("uobjmem_" ^ (List.nth x 0)) in
			let memregion_attrs = ( (List.nth x 1) ^ "ail") in
			let memregion_origin = !uobj_section_load_addr in
			let memregion_size =  int_of_string (List.nth x 2) in
				Printf.fprintf oc "\n %s (%s) : ORIGIN = 0x%08x, LENGTH = 0x%08x"
					memregion_name memregion_attrs memregion_origin memregion_size;
			uobj_section_load_addr := !uobj_section_load_addr + memregion_size;
			()
		)  uobj_sections_list;
				
		(* Printf.fprintf oc "\n  unaccounted (rwxai) : ORIGIN = 0, LENGTH = 0 /* see section .unaccounted at end */"; *)
		Printf.fprintf oc "\n}";
		Printf.fprintf oc "\n";
		
		
		Printf.fprintf oc "\nSECTIONS";
		Printf.fprintf oc "\n{";
		Printf.fprintf oc "\n";

		uobj_section_load_addr := uobj_load_addr;
		
		List.iter (fun x ->
			(* new section *)
			Printf.fprintf oc "\n	. = 0x%08x;" !uobj_section_load_addr;
	    Printf.fprintf oc "\n %s : {" (List.nth x 0);
			let section_size= (List.nth x 2) in
			let elem_index = ref 0 in
			elem_index := 0;
			List.iter (fun y ->
				if (!elem_index > 2) then
					begin
				    Printf.fprintf oc "\n *(%s)" y;
					end
				; 
				elem_index := !elem_index + 1;
				()
			) x;
	
			Printf.fprintf oc "\n . = %s;" section_size;
	    Printf.fprintf oc "\n	} >uobjmem_%s =0x9090" (List.nth x 0);
	    Printf.fprintf oc "\n";
			uobj_section_load_addr := !uobj_section_load_addr + 
					int_of_string(section_size);
			()
		) uobj_sections_list;


		Printf.fprintf oc "\n";
		Printf.fprintf oc "\n	/* this is to cause the link to fail if there is";
		Printf.fprintf oc "\n	* anything we didn't explicitly place.";
		Printf.fprintf oc "\n	* when this does cause link to fail, temporarily comment";
		Printf.fprintf oc "\n	* this part out to see what sections end up in the output";
		Printf.fprintf oc "\n	* which are not handled above, and handle them.";
		Printf.fprintf oc "\n	*/";
		Printf.fprintf oc "\n	/DISCARD/ : {";
		Printf.fprintf oc "\n	*(*)";
		Printf.fprintf oc "\n	}";
		Printf.fprintf oc "\n}";
		Printf.fprintf oc "\n";
																																																																																																																								
		close_out oc;
		()
;;

								
																
let uberspark_generate_uobj_hdr uobj_name uobj_load_addr 
	uobj_sections_list =
	let uobj_hdr_filename = (uobj_name ^ ".hdr.c") in
	let oc = open_out uobj_hdr_filename in
		Printf.fprintf oc "\n/* autogenerated uberSpark uobj header */";
		Printf.fprintf oc "\n/* author: amit vasudevan (amitvasudevan@acm.org) */";
		Printf.fprintf oc "\n";
		Printf.fprintf oc "\n";

		Printf.fprintf oc "\n#include <uberspark.h>";
		Printf.fprintf oc "\n";

		List.iter (fun x ->
			(* new section *)
			let section_name_var = ("__uobjsection_filler_" ^ (List.nth x 0)) in
			let section_name = (List.nth x 3) in
			  if (compare section_name ".text") <> 0 then
					begin
						Printf.fprintf oc "\n__attribute__((section (\"%s\"))) uint8_t %s[1]={ 0 };"
							section_name section_name_var;
					end
				;
			()
		)  uobj_sections_list;

		Printf.fprintf oc "\n";
		Printf.fprintf oc "\n";
			
		close_out oc;
	(uobj_hdr_filename)
;; 
																								
																																
																																																
let main () =
	begin
		let speclist = [
			("--builduobj", Arg.Set copt_builduobj, "Build uobj binary by compiling and linking");
			("-b", Arg.Set copt_builduobj, "Build uobj binary by compiling and linking");
			("--uobjlist", Arg.String (cmdopt_uobjlist_set), "uobj list filename with path");
			("--uobjmanifest", Arg.String (cmdopt_uobjmanifest_set), "uobj list filename with path");

			] in
		let banner = "uberSpark driver tool by Amit Vasudevan (amitvasudevan@acm.org)" in
		let usage_msg = "Usage:" in
		let uobj_id = ref 0 in
		let uobj_manifest_filename = ref "" in
		let uobj_name = ref "" in
		let uobj_mf_filename_forpreprocessing = ref "" in	
		let uobj_mf_filename_preprocessed = ref "" in  
			
			Uslog.current_level := Uslog.ord Uslog.Debug; 

			Uslog.logf log_mpf Uslog.Info "%s" banner;
			Uslog.logf log_mpf Uslog.Info ">>>>>>";
			Arg.parse speclist cmdopt_invalid usage_msg;

			Uslog.logf log_mpf Uslog.Info "Parsing uobj list using: %s..." !cmdopt_uobjlist;
			Libusmf.usmf_parse_uobj_list (!cmdopt_uobjlist) ((Filename.dirname !cmdopt_uobjlist) ^ "/");
			Uslog.logf log_mpf Uslog.Info "Parsed uobj list, total uobjs=%u" !Libusmf.g_totalslabs;

			uobj_manifest_filename := (Filename.basename !cmdopt_uobjmanifest);
			uobj_name := Filename.chop_extension !uobj_manifest_filename;
			uobj_id := (Hashtbl.find Libusmf.slab_nametoid !uobj_name);

			Uslog.logf log_mpf Uslog.Info "Parsing uobj manifest using: %s..." !cmdopt_uobjmanifest;
			Uslog.logf log_mpf Uslog.Info "uobj_name='%s', uobj_id=%u" !uobj_name !uobj_id;

			if (Libusmf.usmf_parse_uobj_mf_uobj_sources !uobj_id !cmdopt_uobjmanifest) == false then
				begin
					Uslog.logf log_mpf Uslog.Error "invalid or no uobj-sources node found within uobj manifest.";
					ignore (exit 1);
				end
			;

			Uslog.logf log_mpf Uslog.Info "Parsed uobj-sources from uobj manifest.";
			Uslog.logf log_mpf Uslog.Info "incdirs=%u, incs=%u, libdirs=%u, libs=%u"
				(List.length (Hashtbl.find_all Libusmf.slab_idtoincludedirs !uobj_id))
				(List.length (Hashtbl.find_all Libusmf.slab_idtoincludes !uobj_id))
				(List.length (Hashtbl.find_all Libusmf.slab_idtolibdirs !uobj_id))
				(List.length (Hashtbl.find_all Libusmf.slab_idtolibs !uobj_id))
				;
			Uslog.logf log_mpf Uslog.Info "cfiles=%u, casmfiles=%u, asmfiles=%u"
				(List.length (Hashtbl.find_all Libusmf.slab_idtocfiles !uobj_id))
				(List.length (Hashtbl.find_all Libusmf.slab_idtocasmfiles !uobj_id))
				(List.length (Hashtbl.find_all Libusmf.slab_idtoasmfiles !uobj_id))
				;
	
			uobj_mf_filename_forpreprocessing := 
					uberspark_generate_uobj_mf_forpreprocessing !uobj_id 
						!uobj_manifest_filename Libusmf.slab_idtoincludes;
			Uslog.logf log_mpf Uslog.Info "Generated uobj manifest file for preprocessing";
						
			uobj_mf_filename_preprocessed := 
					uberspark_generate_uobj_mf_preprocessed !uobj_id
					!uobj_mf_filename_forpreprocessing 
					(uberspark_build_includedirs_base () @ 
					(uberspark_build_includedirs !uobj_id Libusmf.slab_idtoincludedirs));	
			Uslog.logf log_mpf Uslog.Info "Pre-processed uobj manifest file";

	
			let (rval, uobj_sections_list) = 
				Libusmf.usmf_parse_uobj_mf_uobj_binary !uobj_id !uobj_mf_filename_preprocessed in
					if (rval == false) then
						begin
							Uslog.logf log_mpf Uslog.Error "invalid or no uobj-binary node found within uobj manifest.";
							ignore (exit 1);
						end
					;

			Uslog.logf log_mpf Uslog.Info "Parsed uobj-binary from uobj manifest: total sections=%u"
				(List.length uobj_sections_list);
		

				
			let uobj_hdr_cfile = uberspark_generate_uobj_hdr !uobj_name 0x80000000 
				uobj_sections_list in
				Uslog.logf log_mpf Uslog.Info "Generated uobj header file";
			
							
												
																				
			if (List.length (Hashtbl.find_all Libusmf.slab_idtocfiles !uobj_id)) > 0 then
				begin
					Uslog.logf log_mpf Uslog.Info "Proceeding to compile uobj cfiles...";
					uberspark_compile_uobj_cfiles 
						((Hashtbl.find_all Libusmf.slab_idtocfiles !uobj_id) @ [ uobj_hdr_cfile ])
						(uberspark_build_includedirs_base () @ 
						(uberspark_build_includedirs !uobj_id Libusmf.slab_idtoincludedirs));
				end
			;


			uberspark_generate_uobj_linker_script !uobj_name 0x80000000 
				uobj_sections_list;
		


			Uslog.logf log_mpf Uslog.Info "Proceeding to link uobj binary '%s'..."
				!uobj_name;
			let uobj_libdirs_list = ref [] in
			let uobj_libs_list = ref [] in
				uobj_libdirs_list := !uobj_libdirs_list @ [ g_uberspark_install_libsdir ]; 	
				uobj_libdirs_list := !uobj_libdirs_list @
								(Hashtbl.find_all Libusmf.slab_idtolibdirs !uobj_id);
				uobj_libs_list := !uobj_libs_list @
								(Hashtbl.find_all Libusmf.slab_idtolibs !uobj_id);
				uberspark_link_uobj ((Hashtbl.find_all Libusmf.slab_idtocfiles !uobj_id) @ [ uobj_hdr_cfile ])
					!uobj_libdirs_list !uobj_libs_list 
					(!uobj_name ^ ".lscript") !uobj_name;

						
			Uslog.logf log_mpf Uslog.Info "Done.\r\n";

		end
	;;
 
		
main ();;



(*
			file_copy !cmdopt_uobjmanifest (!uobj_name ^ ".gsm.pp");

			Uslog.logf log_mpf Uslog.Info "uobj_name=%s, uobj_id=%u\n"  !uobj_name !uobj_id;
			Libusmf.usmf_memoffsets := false;
			Libusmf.usmf_parse_uobj_mf (Hashtbl.find Libusmf.slab_idtogsm !uobj_id) (Hashtbl.find Libusmf.slab_idtommapfile !uobj_id);
*)


(*
			Uslog.current_level := Uslog.ord Uslog.Info;
			Uslog.logf log_mpf Uslog.Info "proceeding to execute...\n";

			let p_cmdline = ref [] in
				p_cmdline := !p_cmdline @ [ "gcc" ];
				p_cmdline := !p_cmdline @ [ "-P" ];
				p_cmdline := !p_cmdline @ [ "-E" ];
				p_cmdline := !p_cmdline @ [ "../../dat.c" ];
				p_cmdline := !p_cmdline @ [ "-o" ];
				p_cmdline := !p_cmdline @ [ "dat.i" ];
				
			let (exit_status, exit_signal, process_output) = (exec_process_withlog "gcc" !p_cmdline true) in
						Uslog.logf log_mpf Uslog.Info "Done: exit_signal=%b exit_status=%d\n" exit_signal exit_status;
*)

(*
				let str_list = (Hashtbl.find_all Libusmf.slab_idtoincludedirs !uobj_id) in
				begin
					Uslog.logf log_mpf Uslog.Info "length=%u\n"  (List.length str_list);
					while (!i < (List.length str_list)) do
						begin
							let mstr = (List.nth str_list !i) in
							Uslog.logf log_mpf Uslog.Info "i=%u --> %s" !i mstr; 
							i := !i + 1;
						end
					done;
				end
*)

(*
		Uslog.logf log_mpf Uslog.Info "proceeding to parse includes...";
			Libusmf.usmf_parse_uobj_mf_includedirs !uobj_id !cmdopt_uobjmanifest;
			Uslog.logf log_mpf Uslog.Info "includes parsed.";

			let str_list = (Hashtbl.find_all Libusmf.slab_idtoincludedirs !uobj_id) in
				begin
					Uslog.logf log_mpf Uslog.Info "length=%u\n"  (List.length str_list);
					while (!i < (List.length str_list)) do
						begin
							let include_dir_str = (List.nth str_list !i) in
							Uslog.logf log_mpf Uslog.Info "i=%u --> %s" !i include_dir_str; 
							i := !i + 1;
						end
					done;
				end
*)
