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

(* external tools *)
let g_uberspark_exttool_pp = "gcc";;

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
		write_substring fd_out !uobj_includes_str 0 (String.length !uobj_includes_str);

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
			pp_cmdline := !pp_cmdline @ uobj_includedirs_list;
			pp_cmdline := !pp_cmdline @ [ uobj_manifest_filename_forpreprocessing ];
			pp_cmdline := !pp_cmdline @ [ "-o" ];
			pp_cmdline := !pp_cmdline @ [ uobj_mf_filename_preprocessed ];
			exec_process_withlog g_uberspark_exttool_pp !pp_cmdline true;
	(uobj_mf_filename_preprocessed)
;;


    						
								
let main () =
	begin
		let i = ref 0 in
		let speclist = [
			("--builduobj", Arg.Set copt_builduobj, "Build uobj binary by compiling and linking");
			("-b", Arg.Set copt_builduobj, "Build uobj binary by compiling and linking");
			("--uobjlist", Arg.String (cmdopt_uobjlist_set), "uobj list filename with path");
			("--uobjmanifest", Arg.String (cmdopt_uobjmanifest_set), "uobj list filename with path");

			] in
		let usage_msg = "uberSpark driver tool by Amit Vasudevan (amitvasudevan@acm.org)" in
		let uobj_id = ref 0 in
		let uobj_manifest_filename = ref "" in
		let uobj_name = ref "" in

						Uslog.current_level := Uslog.ord Uslog.Info;
			Arg.parse speclist cmdopt_invalid usage_msg;
 			Uslog.logf log_mpf Uslog.Info "copt_builduobj: %b" !copt_builduobj;

 			Uslog.logf log_mpf Uslog.Info "cmdopt_uobjlist: %s" !cmdopt_uobjlist;
 			(* Uslog.logf log_mpf Uslog.Info "dirname: %s" (Filename.dirname !cmdopt_uobjlist); *)

			Libusmf.usmf_parse_uobj_list (!cmdopt_uobjlist) ((Filename.dirname !cmdopt_uobjlist) ^ "/");
			Uslog.logf log_mpf Uslog.Info "g_totalslabs=%d \n" !Libusmf.g_totalslabs;

	
			uobj_manifest_filename := (Filename.basename !cmdopt_uobjmanifest);
			uobj_name := Filename.chop_extension !uobj_manifest_filename;
			uobj_id := (Hashtbl.find Libusmf.slab_nametoid !uobj_name);

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

		Uslog.logf log_mpf Uslog.Info "proceeding to parse uobj-sources...";
		Libusmf.usmf_parse_uobj_mf_uobj_sources !uobj_id !cmdopt_uobjmanifest;
		Uslog.logf log_mpf Uslog.Info "done parsing uobj-sources...";

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

				let str_list = (Hashtbl.find_all Libusmf.slab_idtoincludedirs !uobj_id) in
					Uslog.logf log_mpf Uslog.Info "length=%u\n"  (List.length str_list);

				let str_list = (Hashtbl.find_all Libusmf.slab_idtoincludes !uobj_id) in
					Uslog.logf log_mpf Uslog.Info "length=%u\n"  (List.length str_list);

				let str_list = (Hashtbl.find_all Libusmf.slab_idtolibdirs !uobj_id) in
					Uslog.logf log_mpf Uslog.Info "length=%u\n"  (List.length str_list);

				let str_list = (Hashtbl.find_all Libusmf.slab_idtolibs !uobj_id) in
					Uslog.logf log_mpf Uslog.Info "length=%u\n"  (List.length str_list);

				let str_list = (Hashtbl.find_all Libusmf.slab_idtocfiles !uobj_id) in
					Uslog.logf log_mpf Uslog.Info "length=%u\n"  (List.length str_list);

				let str_list = (Hashtbl.find_all Libusmf.slab_idtocasmfiles !uobj_id) in
					Uslog.logf log_mpf Uslog.Info "length=%u\n"  (List.length str_list);
								
				let str_list = (Hashtbl.find_all Libusmf.slab_idtoasmfiles !uobj_id) in
					Uslog.logf log_mpf Uslog.Info "length=%u\n"  (List.length str_list);



				let tlist =  uberspark_build_includedirs_base () in 
					Uslog.logf log_mpf Uslog.Info "length=%u\n"  (List.length tlist);
					List.iter print_endline tlist;

				let tlist =  uberspark_build_includedirs !uobj_id Libusmf.slab_idtoincludedirs in 
					Uslog.logf log_mpf Uslog.Info "length=%u\n"  (List.length tlist);
					List.iter print_endline tlist;


				let uobj_mf_filename_forpreprocessing = 
					uberspark_generate_uobj_mf_forpreprocessing !uobj_id 
					!uobj_manifest_filename Libusmf.slab_idtoincludes in
						begin
							Uslog.logf log_mpf Uslog.Info "uobj_mf_filename_forpreprocessing=%s\n"
								uobj_mf_filename_forpreprocessing;
							let ilist_base =  uberspark_build_includedirs_base () in 
							let ilist =  (uberspark_build_includedirs !uobj_id Libusmf.slab_idtoincludedirs) in 
								uberspark_generate_uobj_mf_preprocessed !uobj_id
									uobj_mf_filename_forpreprocessing (ilist_base @ ilist);	
						end
						
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
			file_copy !cmdopt_uobjmanifest (!uobj_name ^ ".gsm.pp");

			Uslog.logf log_mpf Uslog.Info "uobj_name=%s, uobj_id=%u\n"  !uobj_name !uobj_id;
			Libusmf.usmf_memoffsets := false;
			Libusmf.usmf_parse_uobj_mf (Hashtbl.find Libusmf.slab_idtogsm !uobj_id) (Hashtbl.find Libusmf.slab_idtommapfile !uobj_id);
*)

		end
	;;
 
		
main ();;


