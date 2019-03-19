(* uberspark config tool: to locate hwm, libraries and headers *)
(* author: amit vasudevan (amitvasudevan@acm.org) *)

open Sys
open Unix
open Filename

open Uslog
open Usconfig
open Usosservices
open Libusmf
open Usuobjlib
open Usuobj
open Usuobjcollection

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

let banner = "uberSpark driver tool by Amit Vasudevan (amitvasudevan@acm.org)";;
let usage_msg = "Usage:";;

(*----------------------------------------------------------------------------*)
(* command line options setters *)
(*----------------------------------------------------------------------------*)
let cmdopt_invalid opt = 
	Uslog.logf log_mpf Uslog.Info "invalid option: '%s'; use -help to see available options" opt;
	ignore(exit 1);
	;;

let copt_builduobj = ref false;;

let copt_install = ref false;;

let cmdopt_uobjlist = ref "";;
let cmdopt_uobjlist_set value = cmdopt_uobjlist := value;;

let cmdopt_uobjmanifest = ref "";;
let cmdopt_uobjmanifest_set value = cmdopt_uobjmanifest := value;;

let cmdopt_loadaddr_specified = ref false;;
let cmdopt_loadaddr = ref "";;
let cmdopt_loadaddr_set 
	(value : string) = 
	cmdopt_loadaddr_specified := true;
	cmdopt_loadaddr := value;
	;;

let cmdopt_platform_specified = ref false;;
let cmdopt_platform = ref "";;
let cmdopt_platform_set 
	(value : string) = 
	cmdopt_platform_specified := true;
	cmdopt_platform := value;
	;;

let cmdopt_cpu_specified = ref false;;
let cmdopt_cpu = ref "";;
let cmdopt_cpu_set 
	(value : string) = 
	cmdopt_cpu_specified := true;
	cmdopt_cpu := value;
	;;

let cmdopt_arch_specified = ref false;;
let cmdopt_arch = ref "";;
let cmdopt_arch_set 
	(value : string) = 
	cmdopt_arch_specified := true;
	cmdopt_arch := value;
	;;

let cmdopt_info = ref false;;

let cmdopt_uobjcoll_specified = ref false;;
let cmdopt_uobjcoll = ref "";;
let cmdopt_uobjcoll_set 
	(value : string) = 
	cmdopt_uobjcoll_specified := true;
	cmdopt_uobjcoll := value;
	;;

let cmdopt_uobj_specified = ref false;;
let cmdopt_uobj = ref "";;
let cmdopt_uobj_set 
	(value : string) = 
	cmdopt_uobj_specified := true;
	cmdopt_uobj := value;
	;;

let cmdopt_get_includedir = ref false;;

let cmdopt_get_libdir = ref false;;

let cmdopt_get_libsentinels = ref false;;

let cmdopt_get_installrootdir = ref false;;

(*----------------------------------------------------------------------------*)
(* command line options *)
(*----------------------------------------------------------------------------*)

let cmdline_speclist = [
	("--builduobj", Arg.Set copt_builduobj, "Build uobj binary by compiling and linking");
	("-b", Arg.Set copt_builduobj, "Build uobj binary by compiling and linking");
	("--uobjlist", Arg.String (cmdopt_uobjlist_set), "uobj list filename with path");
	("--uobjmanifest", Arg.String (cmdopt_uobjmanifest_set), "uobj list filename with path");
	("--load-addr", Arg.String (cmdopt_loadaddr_set), "load address");
	("--install", Arg.Set copt_install, "Install uobj/uobj collection");

	("--platform", Arg.String (cmdopt_platform_set), "set hardware platform");
	("--cpu", Arg.String (cmdopt_cpu_set), "set hardware CPU type");
	("--arch", Arg.String (cmdopt_arch_set), "set hardware CPU architecture");

	("--uobjcoll", Arg.String (cmdopt_uobjcoll_set), "uobj collection name/identifier");
	("--uobj", Arg.String (cmdopt_uobj_set), "uobj name/identifier");

	("--info", Arg.Set cmdopt_info, "Get information on uberSpark, installed uobj collection, or uobj");
	("--get-includedir", Arg.Set cmdopt_get_includedir, "get uobj include directory");
	("--get-libdir", Arg.Set cmdopt_get_libdir, "get uobj library directory");
	("--get-libsentinels", Arg.Set cmdopt_get_libsentinels, "get uobj sentinels library");
	("--get-installrootdir", Arg.Set cmdopt_get_installrootdir, "get installation root directory");


	];;




(*----------------------------------------------------------------------------*)


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




(*								
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

																
								
																
*)
																								

(*----------------------------------------------------------------------------*)
let handle_option_info () =
		let handle_option_info_error = ref false in
		Uslog.logf log_mpf Uslog.Info ">>>>>>";

		if !cmdopt_get_includedir == true then
			begin
				if !cmdopt_uobjcoll_specified == true && !cmdopt_uobj_specified == false then
					begin
						Uslog.logf log_mpf Uslog.Stdoutput "%s" 
							Usconfig.get_uberspark_config_install_prefix;
					end
				else if !cmdopt_uobjcoll_specified == true && !cmdopt_uobj_specified == true then
					begin
						Uslog.logf log_mpf Uslog.Stdoutput "%s" 
							Usconfig.get_uberspark_config_install_prefix;
					end
				else if !cmdopt_uobjcoll_specified == false && !cmdopt_uobj_specified == false then
					begin
						Uslog.logf log_mpf Uslog.Stdoutput "%s" 
							Usconfig.get_uberspark_config_install_includedir;
					end
				else
					begin
						handle_option_info_error := true;
					end
				;
			end
		;
			
		(* else if *) 	
		
		if !handle_option_info_error == true then
			begin
				Uslog.logf log_mpf Uslog.Error "invalid --info arguments";
				Arg.usage cmdline_speclist usage_msg;
				ignore(exit 1);
		  end
		;


(*			
						
		(* we need --uobj to be specified on the command line *)
		if !cmdopt_uobj_specified == false || !cmdopt_uobjcoll_specified == false then
			begin
				Uslog.logf log_mpf Uslog.Error "--uobjcoll and --uobj need to be specified!";
				Arg.usage cmdline_speclist usage_msg;
				ignore(exit 1);
			end
		;

		let uobj_basedir = Usconfig.get_uberspark_config_install_uobjcolldir ^
			"/" ^ !cmdopt_uobjcoll ^ "/" ^ !cmdopt_uobj in
		let uobj_libsentinels = !cmdopt_uobj ^ "-" ^ 
			!cmdopt_platform ^ "-" ^ !cmdopt_cpu ^ "-" ^ !cmdopt_arch in
				
		
		if !cmdopt_get_includedir == true then
			begin
				Uslog.logf log_mpf Uslog.Stdoutput "%s" Usconfig.get_uberspark_config_install_prefix;
			end
		else if !cmdopt_get_libdir == true then
			begin
				Uslog.logf log_mpf Uslog.Stdoutput "%s" uobj_basedir;
			end
		else if !cmdopt_get_libsentinels == true then
			begin
				Uslog.logf log_mpf Uslog.Stdoutput "%s" uobj_libsentinels;
			end
		else
			begin
				Uslog.logf log_mpf Uslog.Error "one of the get_xxx needs to be specified!";
				Arg.usage cmdline_speclist usage_msg;
				ignore(exit 1);
				
		  end
		;
*)
						
		()
;;

(*----------------------------------------------------------------------------*)

																												
																																																								
(*----------------------------------------------------------------------------*)
let main () =
		let uobj_id = ref 0 in
		let uobj_manifest_filename = ref "" in
		let uobj_name = ref "" in
		let uobj_mf_filename_forpreprocessing = ref "" in	
		let uobj_mf_filename_preprocessed = ref "" in  

		(* parse command line arguments *)
		Arg.parse cmdline_speclist cmdopt_invalid usage_msg;
			
		(* set debug verbosity accordingly *)
		if !cmdopt_info == true then
			begin
				Uslog.current_level := Uslog.ord Uslog.Stdoutput;
			end
		else
			begin
				Uslog.current_level := Uslog.ord Uslog.Debug;
			end
		;
		
	  (* print banner and parse command line args *)
		Uslog.logf log_mpf Uslog.Info "%s" banner;
		Uslog.logf log_mpf Uslog.Info ">>>>>>";

		(* load up default platform, cpu and arch if not specified on command line*)
		if !cmdopt_platform_specified == false then
			begin
				cmdopt_platform := Usconfig.get_uberspark_config_hw_platform_default;
			end
		;
		if !cmdopt_cpu_specified == false then
			begin
				cmdopt_cpu := Usconfig.get_uberspark_config_hw_cpu_default;
			end
		;
		if !cmdopt_arch_specified == false then
			begin
				cmdopt_arch := Usconfig.get_uberspark_config_hw_arch_default;
			end
		;

		Uslog.logf log_mpf Uslog.Info "Target platform='%s', CPU='%s', arch='%s'"
			!cmdopt_platform !cmdopt_cpu !cmdopt_arch;

		(* sanity check command line arguments *)
		if(!cmdopt_loadaddr_specified == false) then
				cmdopt_loadaddr := (Usconfig.get_default_load_addr());
		;

		(* check if information requested *)
		if !cmdopt_info == true then 
			begin
				handle_option_info ();
			end
		else
		begin
				


		(* create uobj collection *)
		Uslog.logf log_mpf Uslog.Info "Proceeding to build uobj collection using: %s..." !cmdopt_uobjlist;
		Usuobjcollection.init_build_configuration !cmdopt_uobjlist "" true;
		Usuobjcollection.collect_uobjs_with_manifest_parsing ();
		Usuobjcollection.compute_memory_map (int_of_string(!cmdopt_loadaddr));
		Uslog.logf log_mpf Uslog.Info "Built uobj collection, total uobjs=%u" !Usuobjcollection.total_uobjs;

		(* if we are building *)
		if !copt_builduobj == true then
			begin
				(* generate uobj collection info table *)
				Usuobjcollection.generate_uobjcoll_info (Usconfig.get_std_uobjcoll_info_filename ()); 
				Uslog.logf log_mpf Uslog.Info "Generated uobj collection info. table.";

				(* build uobj collection info table binary *)
				Usuobjcollection.build_uobjcoll_info_table (Usconfig.get_std_uobjcoll_info_filename ());
				Uslog.logf log_mpf Uslog.Info "Built uobj collection info. table binary.";

				(* build uobj collection by building individidual uobjs *)
				Usuobjcollection.build "" true;

				(* build final image *)
				Usuobjcollection.build_uobjcoll_binary_image (!cmdopt_uobjlist ^ ".bin")
				(Usconfig.get_std_uobjcoll_info_filename ());
		
			end
		;

		(* install uobj collection and uobjs if specified *)
		if !copt_install == true then
			begin
				Usuobjcollection.install (Usconfig.get_default_install_uobjcolldir ());
			end
		;

		end
		;

(*
		(* grab uobj manifest filename and derive uobj name *)
		uobj_manifest_filename := (Filename.basename !cmdopt_uobjmanifest);
		uobj_name := Filename.chop_extension !uobj_manifest_filename;
*)

(*
		(* check options and do the task *)
		if (!copt_builduobj == true ) then
			begin
				let uobj = new Usuobj.uobject in
					uobj#build !uobj_manifest_filename "" true	
			end
		;
*)


(*			uobj_id := (Hashtbl.find Libusmf.slab_nametoid !uobj_name);*)

(*
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

*)
			
(*							
			Usuobjlib.build !uobj_manifest_filename "" true;*)
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
