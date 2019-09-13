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
open Usbin

open Cmdliner

let log_mpf = "uberspark";;




(* type verb = Normal | Quiet | Verbose
type copts = { debug : bool; verb : verb; prehook : string option }
*)

type g_copts = { log_level : Uslog.log_level}


let str = Printf.sprintf
let opt_str sv = function None -> "None" | Some v -> str "Some(%s)" (sv v)
let opt_str_str = opt_str (fun s -> s)
(*
let verb_str = function
  | Normal -> "normal" | Quiet -> "quiet" | Verbose -> "verbose"
*)

let pr_g_copts oc copts = 
	Printf.fprintf oc "log_level = %u\n" (Uslog.ord copts.log_level);
	();
;;

(*
let pr_copts oc copts = Printf.fprintf oc
    "debug = %B\nverbosity = %s\nprehook = %s\n"
    copts.debug (verb_str copts.verb) (opt_str_str copts.prehook)




let initialize copts repodir = Printf.printf
    "%arepodir = %s\n" pr_copts copts repodir

let initialize_new g_copts repodir = 
	Printf.printf "%arepodir = %s\n" pr_g_copts g_copts repodir;
	()
;;
*)

let record copts name email all ask_deps files = Printf.printf
    "%aname = %s\nemail = %s\nall = %B\nask-deps = %B\nfiles = %s\n"
    pr_g_copts copts (opt_str_str name) (opt_str_str email) all ask_deps
    (String.concat ", " files)






(* help sections common to all commands *)

let help_secs = [
 `S Manpage.s_common_options;
 `P "These options are common to all commands.";
 `S "MORE HELP";
 `P "Use `$(mname) $(i,COMMAND) --help' or ``$(mname) help $(i,COMMAND)' for help on a single command.";`Noblank;
 `P "E.g., `$(mname) uobj --help' or `$(mname) help uobj' for help on uobject related options.";
 `S "ISSUES"; `P "Visit https://forums.uberspark.org to discuss issues and find potential solutions.";]

(* options common to all commands *)

(* let copts debug verb prehook = { debug; verb; prehook };;
*)

let g_copts log_level = { log_level };;

(*
let copts_t =
  let docs = Manpage.s_common_options in
  let debug =
    let doc = "Give only debug output." in
    Arg.(value & flag & info ["debug"] ~docs ~doc)
  in
  let verb =
    let doc = "Suppress informational output." in
    let quiet = Quiet, Arg.info ["q"; "quiet"] ~docs ~doc in
    let doc = "Give verbose output." in
    let verbose = Verbose, Arg.info ["v"; "verbose"] ~docs ~doc in
    Arg.(last & vflag_all [Normal] [quiet; verbose])
  in
  let prehook =
    let doc = "Specify command to run before this $(mname) command." in
    Arg.(value & opt (some string) None & info ["prehook"] ~docs ~doc)
  in
  Term.(const copts $ debug $ verb $ prehook)
*)

let g_copts_t =
  let docs = Manpage.s_common_options in
  let verb =
    let doc = "Suppress all informational output." in
    let quiet = Uslog.None, Arg.info ["q"; "quiet"] ~docs ~doc in
    (*let doc = "Give verbose output." in
    Arg.(value & opt (some string) None & info ["prehook"] ~docs ~doc)
		*)
		let doc = "Give verbose output." in
    let verbose = Uslog.Debug, Arg.info ["v"; "verbose"] ~docs ~doc in
    Arg.(last & vflag_all [Uslog.Info] [quiet; verbose])
  in
  Term.(const g_copts $ verb)


(* Commands *)

(*
let initialize_cmd =
  let repodir =
    let doc = "Run the program in repository directory $(docv)." in
    Arg.(value & opt file Filename.current_dir_name & info ["repodir"]
           ~docv:"DIR" ~doc)
  in
  let doc = "make the current directory a repository" in
  let exits = Term.default_exits in
  let man = [
    `S Manpage.s_description;
    `P "Turns the current directory into a Darcs repository. Any
       existing files and subdirectories become ...";
    `Blocks help_secs; ]
  in
  Term.(const initialize $ copts_t $ repodir),
  Term.info "initialize" ~doc ~sdocs:Manpage.s_common_options ~exits ~man
*)

(* kicks in when uberspark uobj ... is issued *)
let cmd_uobj =
  let build =
    let doc = "Build the uobj binary." in
    Arg.(value & flag & info ["b"; "build"] ~doc)
  in
  let path =
    let doc = "The path to the uobj sources or a uobj namespace. Omitting the path defaults to the current working directory." in
    Arg.(value & pos 0 (some string) None & info [] ~docv:"PATH or NAMESPACE" ~doc)
  in
  let doc = "verify, build and/or manage uobjs" in
  let exits = Term.default_exits in
  let man =
    [`S Manpage.s_description;
     `P "Verify, build and manage (install, remove, and query) uobj specified by $(i,PATH) or $(i,NAMESPACE).";
     `Blocks help_secs; ]
  in
  Term.(const Cmd_uobj.handler_uobj $ g_copts_t $ build $ path),
  Term.info "uobj" ~doc ~sdocs:Manpage.s_common_options ~exits ~man

(* kicks in when uberspark --help or uberspark help --help is issued *)
let cmd_help =
  let topic =
    let doc = "The topic to get help on. `topics' lists the topics." in
    Arg.(value & pos 0 (some string) None & info [] ~docv:"TOPIC" ~doc)
  in
  let doc = "display help about uberspark and uberspark commands" in
  let exits = Term.default_exits in
  let man =
    [`S Manpage.s_description;
     `P "Prints help about uberspark commands and other subjects...";
     `Blocks help_secs; ]
  in
  Term.(ret (const Cmd_help.handler_help $ g_copts_t $ Arg.man_format $ Term.choice_names $topic)),
  Term.info "help" ~doc ~exits ~man

(* kicks in when user just issues uberspark without any parameters *)
let cmd_default =
  let doc = "enforcing verifiable object abstractions for commodity system software stacks" in
  let sdocs = Manpage.s_common_options in
  let exits = Term.default_exits in
  let man = help_secs in
  Term.(ret (const (fun _ -> `Help (`Pager, None)) $ g_copts_t)),
  Term.info "uberspark" ~version:"5.1" ~doc ~sdocs ~exits ~man

(* all our additional commands *)	
let cmd_additions = [cmd_uobj; cmd_help]


(*----------------------------------------------------------------------------*)
let main () =
	Term.(exit @@ eval_choice cmd_default cmd_additions);
		()
	;;

main ();;


(*
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

let cmdopt_uobjcollmf = ref "";;
let cmdopt_uobjcollmf_set value = cmdopt_uobjcollmf := value;;

let cmdopt_uobjmf = ref "";;
let cmdopt_uobjmf_set value = cmdopt_uobjmf := value;;

let cmdopt_loadaddr_specified = ref false;;
let cmdopt_loadaddr = ref "";;
let cmdopt_loadaddr_set 
	(value : string) = 
	cmdopt_loadaddr_specified := true;
	cmdopt_loadaddr := value;
	;;

let cmdopt_uobjsize_specified = ref false;;
let cmdopt_uobjsize = ref "";;
let cmdopt_uobjsize_set 
	(value : string) = 
	cmdopt_uobjsize_specified := true;
	cmdopt_uobjsize := value;
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


let cmdopt_section_alignment_specified = ref false;;
let cmdopt_section_alignment = ref "";;
let cmdopt_section_alignment_set 
	(value : string) = 
	cmdopt_section_alignment_specified := true;
	cmdopt_section_alignment := value;
	;;

(* page size *)
let cmdopt_page_size_specified = ref false;;
let cmdopt_page_size = ref "";;
let cmdopt_page_size_set 
	(value : string) = 
	cmdopt_page_size_specified := true;
	cmdopt_page_size := value;
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

let cmdopt_get_buildshimsdir = ref false;;


(*----------------------------------------------------------------------------*)
(* command line options *)
(*----------------------------------------------------------------------------*)

let cmdline_speclist = [
	("--builduobj", Arg.Set copt_builduobj, "Build uobj binary by compiling and linking");
	("-b", Arg.Set copt_builduobj, "Build uobj binary by compiling and linking");
	
	("--uobjcollmf", Arg.String (cmdopt_uobjcollmf_set), "uobj collection manifest filename");
	("--uobjmf", Arg.String (cmdopt_uobjmf_set), "uobj manifest filename");
	
	("--load-addr", Arg.String (cmdopt_loadaddr_set), "load address");
	("--uobjsize", Arg.String (cmdopt_uobjsize_set), "uobj size (in bytes)");
	("--install", Arg.Set copt_install, "Install uobj/uobj collection");

	("--platform", Arg.String (cmdopt_platform_set), "set hardware platform");
	("--cpu", Arg.String (cmdopt_cpu_set), "set hardware CPU type");
	("--arch", Arg.String (cmdopt_arch_set), "set hardware CPU architecture");

	("--section-alignment", Arg.String (cmdopt_section_alignment_set), "set section alignment (4K, 2M or 4M)");
	("--page-size", Arg.String (cmdopt_page_size_set), "set page size (4K or 2M)");

	("--uobjcoll", Arg.String (cmdopt_uobjcoll_set), "uobj collection name/identifier");
	("--uobj", Arg.String (cmdopt_uobj_set), "uobj name/identifier");

	("--info", Arg.Set cmdopt_info, "Get information on uberSpark, installed uobj collection, or uobj");
	("--get-includedir", Arg.Set cmdopt_get_includedir, "get uobj include directory");
	("--get-libdir", Arg.Set cmdopt_get_libdir, "get uobj library directory");
	("--get-libsentinels", Arg.Set cmdopt_get_libsentinels, "get uobj sentinels library");
	("--get-installrootdir", Arg.Set cmdopt_get_installrootdir, "get installation root directory");
	("--get-buildshimsdir", Arg.Set cmdopt_get_buildshimsdir, "get installation build shims directory");


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
			
		else if !cmdopt_get_libdir == true then
			begin
				Uslog.logf log_mpf Uslog.Stdoutput "%s" 
					(Usconfig.get_uberspark_config_install_uobjcolldir ^	"/" ^ 
					!cmdopt_uobjcoll ^ "/" ^ !cmdopt_uobj);
			end
			
		else if !cmdopt_get_libsentinels == true then
			begin
				Uslog.logf log_mpf Uslog.Stdoutput "%s" 
					(!cmdopt_uobj ^ "-" ^ 	!cmdopt_platform ^ "-" ^ !cmdopt_cpu ^ 
					"-" ^ !cmdopt_arch);
			end
		
		else if !cmdopt_get_installrootdir == true then
			begin
				Uslog.logf log_mpf Uslog.Stdoutput "%s" 
					Usconfig.get_uberspark_config_install_rootdir;
			end

		else if !cmdopt_get_buildshimsdir == true then
			begin
				Uslog.logf log_mpf Uslog.Stdoutput "%s" 
					Usconfig.get_uberspark_config_install_buildshimsdir;
			end
		
		;
		
		
		if !handle_option_info_error == true then
			begin
				Uslog.logf log_mpf Uslog.Error "invalid --info arguments";
				Arg.usage cmdline_speclist usage_msg;
				ignore(exit 1);
		  end
		;

						
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

		(* sanity check uobj size command line argument *)
		if(!cmdopt_uobjsize_specified == false) then
				cmdopt_uobjsize := (Usconfig.get_default_uobjsize());
		;


		(* setup defaults *)
		if (String.compare !cmdopt_uobjcollmf "") == 0 then
			begin
				cmdopt_uobjcollmf := Usconfig.default_uobjcoll_usmf_name;
			end
		;


		(* check if information requested *)
		if !cmdopt_info == true then 
			begin
				handle_option_info ();
			end
		else
		begin
				

		(* setup section alignment *)
		if !cmdopt_section_alignment_specified == true then
			begin
				Usconfig.section_alignment := int_of_string(!cmdopt_section_alignment);
			end
		;

		Uslog.logf log_mpf Uslog.Info "setting page size...";

		(* setup page size *)
		if !cmdopt_page_size_specified == true then
			begin
				Usconfig.page_size := (int_of_string(!cmdopt_page_size));
			end
		;


		(* create uobj collection *)
		Uslog.logf log_mpf Uslog.Info "Proceeding to initialize uobj collection using: %s..." !cmdopt_uobjcollmf;
		Usuobjcollection.init_build_configuration !cmdopt_uobjcollmf "" true;
		Usuobjcollection.collect_uobjs_with_manifest_parsing ();
		Usuobjcollection.compute_memory_map (int_of_string(!cmdopt_loadaddr)) (int_of_string(!cmdopt_uobjsize));
		Uslog.logf log_mpf Uslog.Info "Initialized uobj collection, total uobjs=%u" !Usuobjcollection.total_uobjs;

	


		(* if we are building *)
		if !copt_builduobj == true then
			begin
				Uslog.logf log_mpf Uslog.Info "Proceeding to compile uobj collection...";
				Usuobjcollection.compile "" true;
				Uslog.logf log_mpf Uslog.Info "Successfully compiled uobj collection.";
				Uslog.logf log_mpf Uslog.Info "Collection binary filename: %s" !Usuobjcollection.o_binary_image_filename;
				Usbin.generate_uobjcoll_bin_image (!Usuobjcollection.o_binary_image_filename);		
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
*)