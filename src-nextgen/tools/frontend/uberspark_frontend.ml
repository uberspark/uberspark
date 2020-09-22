(* uberspark config tool: to locate hwm, libraries and headers *)
(* author: amit vasudevan (amitvasudevan@acm.org) *)

open Sys
open Unix
open Filename
(*
open Uslog
open Usconfig
open Usosservices*)
(*open Libusmf
open Usuobjlib
*)
(*open Usuobj*)
(*open Usuobjcollection
open Usbin
*)

open Cmdliner
open Astring
open Uberspark

(* common manpage sections *)

let manpage_sec_common_options = [
 `S Manpage.s_common_options;
 `P "These options are common to all commands.";
]

let manpage_sec_more_help = [
 `S "MORE HELP";
 `P "Use `$(mname) $(i,COMMAND) --help' for help on a single command.";`Noblank;
 `P "E.g., `$(mname) uobj --help' for help on uobject related options.";
]

let manpage_sec_issues = [
 `S "ISSUES"; 
 `P "Visit https://forums.uberspark.org to discuss issues and find potential solutions.";
]


let help_secs = [
 `S Manpage.s_common_options;
 `P "These options are common to all commands.";
 `S "MORE HELP";
 `P "Use `$(mname) $(i,COMMAND) --help' for help on a single command.";`Noblank;
 `P "E.g., `$(mname) uobj --help' for help on uobject related options.";
 `S "ISSUES"; `P "Visit https://forums.uberspark.org to discuss issues and find potential solutions.";]


(* exit codes *)
let exits = [ 
							Term.exit_info ~doc:"on success." Cmdliner.Term.exit_status_success;
							Term.exit_info ~doc:"on general errors." 1;
							Term.exit_info ~doc:"on command line parsing errors." Cmdliner.Term.exit_status_cli_error;
							Term.exit_info ~doc:"on unexpected internal errors." Cmdliner.Term.exit_status_internal_error;
		];;

(* Commands *)

(* kicks in when uberspark uobj ... is issued *)
let cmd_uobj =
 	let action = 
	let action = [ 	"build", `Build; 
				] in
  	let doc = strf "The action to perform. $(docv) must be one of %s."
      (Arg.doc_alts_enum action) in
  	let action = Arg.enum action in
  		Arg.(required & pos 0 (some action) None & info [] ~doc ~docv:"ACTION")
	in

	let path_ns =
    let doc = "The path to the uobj sources or a uobj namespace." in
    Arg.(required & pos 1 (some string) None & info [] ~docv:"PATH or NAMESPACE" ~doc)
	in

  let doc = "Verify, build and/or manage uobjs" in
  let man =
    [
		`S Manpage.s_synopsis;
    	`P "$(mname) $(tname) $(i,ACTION) [$(i,ACTION_OPTIONS)]... [$(i,OPTIONS)]... $(i,PATH) or $(i,NAMESPACE)";
		`S Manpage.s_description;
		`P "The $(tname) command provides several actions to verify, build 
			and manage uobjs specified by $(i,PATH) or $(i,NAMESPACE).";
    	`S Manpage.s_arguments;
 		`S "ACTIONS";
    	`I ("$(b,build)",
        	"build the uobj binary.");
	 	`S "ACTION OPTIONS";
	  	`P "These options qualify the aforementioned actions.";
		`Blocks manpage_sec_common_options;
		`Blocks manpage_sec_issues;
		`S Manpage.s_exit_status;
 	] in
  Term.(ret (const Cmd_uobj.handler_uobj $ Commonopts.opts_t $ Cmd_uobj.cmd_uobj_opts_t $ action $ path_ns)),
  Term.info "uobj" ~doc ~sdocs:Manpage.s_common_options ~exits ~man



(* kicks in when uberspark uobjcoll ... is issued *)
let cmd_uobjcoll =
 	let action = 
	let action = [ 	"build", `Build; 
					"verify", `Verify;
				] in
  	let doc = strf "The action to perform. $(docv) must be one of %s."
      (Arg.doc_alts_enum action) in
  	let action = Arg.enum action in
  		Arg.(required & pos 0 (some action) None & info [] ~doc ~docv:"ACTION")
	in

	let path_ns =
    let doc = "The path to the uobj collection sources or a uobj collection namespace." in
    Arg.(required & pos 1 (some string) None & info [] ~docv:"PATH or NAMESPACE" ~doc)
	in

  let doc = "Verify, compile, build and/or manage uobj collections" in
  let man =
    [
		`S Manpage.s_synopsis;
    	`P "$(mname) $(tname) $(i,ACTION) [$(i,ACTION_OPTIONS)]... [$(i,OPTIONS)]... $(i,PATH) or $(i,NAMESPACE)";
		`S Manpage.s_description;
		`P "The $(tname) command provides several actions to verify, build 
			and manage uobj collections specified by $(i,PATH) or $(i,NAMESPACE).";
    	`S Manpage.s_arguments;
 		`S "ACTIONS";
    	`I ("$(b,build)",
        	"build the uobj collection binary.");
    	`I ("$(v,verify)",
        	"verify the uobj collection.");
	 	`S "ACTION OPTIONS";
	  	`P "These options qualify the aforementioned actions.";
		`Blocks manpage_sec_common_options;
		`Blocks manpage_sec_issues;
		`S Manpage.s_exit_status;
 	] in
  Term.(ret (const Cmd_uobjcoll.handler_uobjcoll $ Commonopts.opts_t $ Cmd_uobjcoll.cmd_uobjcoll_opts_t $ action $ path_ns)),
  Term.info "uobjcoll" ~doc ~sdocs:Manpage.s_common_options ~exits ~man



(* kicks in when uberspark config ... is issued *)
let cmd_bridges =
	let action = 
	let action = [ 	"config", `Config;
					"create", `Create; 
					"dump", `Dump; 
					"remove", `Remove;
				] in
  	let doc = strf "The action to perform. $(docv) must be one of %s."
      (Arg.doc_alts_enum action) in
  	let action = Arg.enum action in
  		Arg.(required & pos 0 (some action) None & info [] ~doc ~docv:"ACTION")
	in

	let path_ns =
    let doc = "The bridge namespace uri." in
    Arg.(value & pos 1 (some string) None & info [] ~docv:"PATH or NAMESPACE" ~doc)
	in
  
  let doc = "Manage uberspark bridges" in
  let man =
    [
		`S Manpage.s_synopsis;
    	`P "$(mname) $(tname) $(i,ACTION) [$(i,ACTION_OPTIONS)]... [$(i,OPTIONS)]...  [$(i, PATH) or $(i,NAMESPACE)]";
		`S Manpage.s_description;
     	`P "The $(tname) command provides several actions to manage the
	 		uberspark code bridge settings, optionally qualified by $(i,PATH) or $(i,NAMESPACE).";
    	`S Manpage.s_arguments;
 		`S "ACTIONS";
    	`I ("$(b,config)",
        	"configure a bridge specified by the $(i,NAMESPACE) argument; only valid for bridges backed by containers. 
			Uses the following action options: $(b,-ar), $(b,-as), $(b,-cc), $(b,-ld), $(b,-pp), $(b,-vf), and $(b,--build)");
    	`I ("$(b,create)",
        	"create a new bridge namespaces from a file $(i,PATH) argument.
			Uses the following action options: $(b,-ar), $(b,-as), $(b,-cc), $(b,-ld), $(b,-pp), $(b,-vf), and $(b,--bare)");
    	`I ("$(b,dump)",
        	"store a bridge configuration specified by the $(i,NAMESPACE) argument to the specified output directory. 
			Uses the following action options: $(b,-ar), $(b,-as), $(b,-cc), $(b,-ld), $(b,-pp), $(b,-vf), $(b,--bridge-exectype), and $(b,--output-directory)");
     	`I ("$(b,remove)",
        	"remove a bridge configuration namespace specified by the $(i,NAMESPACE) argument.
			Uses the following action options: $(b,-ar), $(b,-as), $(b,-cc), $(b,-ld), $(b,-pp), $(b,-vf), and $(b,--bridge-exectype)");
	 	`S "ACTION OPTIONS";
	  	`P "These options qualify the aforementioned actions.";
		`Blocks manpage_sec_common_options;
		`Blocks manpage_sec_issues;
		`S Manpage.s_exit_status;
	] in
  Term.(ret (const Cmd_bridge.handler_bridge $ Commonopts.opts_t $ Cmd_bridge.cmd_bridge_opts_t $ action $ path_ns )),
  Term.info "bridge" ~doc ~sdocs:Manpage.s_common_options ~exits ~man




  


(* kicks in when uberspark staging ... is issued *)
let cmd_staging =
	let action = 
	let action = [ 	"create", `Create; 
					"switch", `Switch; 
					"list", `List;
					"remove", `Remove;
					"config-set", `Config_set;
					"config-get", `Config_get;
				] in
  	let doc = strf "The action to perform. $(docv) must be one of %s."
      (Arg.doc_alts_enum action) in
  	let action = Arg.enum action in
  		Arg.(required & pos 0 (some action) None & info [] ~doc ~docv:"ACTION")
	in

	let path_ns =
    let doc = "The staging namespace." in
    Arg.(value & pos 1 (some string) None & info [] ~docv:"NAMESPACE" ~doc)
	in
  
  let doc = "Manage uberspark staging" in
  let man =
    [
		`S Manpage.s_synopsis;
    	`P "$(mname) $(tname) $(i,ACTION) [$(i,ACTION_OPTIONS)]... [$(i,OPTIONS)]... [$(i,NAMESPACE)]";
		`S Manpage.s_description;
     	`P "The $(tname) command provides several actions to manage the
	 		uberspark staging settings, optionally qualified by $(i,NAMESPACE).";
    	`S Manpage.s_arguments;

 		`S "ACTIONS";
    	`I ("$(b,create)",
        	"create a new staging with a name specified via the $(i,NAMESPACE) argument.
			Uses the following action options: $(b,--from-existing)");
     	`I ("$(b,switch)",
        	"switch to a staging specified by the $(i,NAMESPACE) argument.");
     	`I ("$(b,list)",
        	"print a list of all available stagings.");
     	`I ("$(b,remove)",
        	"Remove a staging specified by the $(i,NAMESPACE) argument.");
    	`I ("$(b,config-set)",
        	"change configuration settings within the current staging. 
			Uses the following action options: $(b,--setting-name), $(b,--setting-value), and $(b,--from-file)");
    	`I ("$(b,config-get)",
        	"dump configuration settings within the current staging. 
			Uses the following action options: $(b,--setting-name), $(b,--setting-value), and $(b,--to-file)");

	 	`S "ACTION OPTIONS";
	  	`P "These options qualify the aforementioned actions.";
		`Blocks manpage_sec_common_options;
		`Blocks manpage_sec_issues;
		`S Manpage.s_exit_status;
	] in
  Term.(ret (const Cmd_staging.handler_staging $ Commonopts.opts_t $ Cmd_staging.cmd_staging_opts_t $ action $ path_ns )),
  Term.info "staging" ~doc ~sdocs:Manpage.s_common_options ~exits ~man






(* kicks in when user just issues uberspark without any parameters *)
let cmd_default =
  let doc = "enforcing verifiable object abstractions for commodity system software stacks" in
  let sdocs = Manpage.s_common_options in
  let man = [
	`S Manpage.s_synopsis;
    `P "$(mname) [$(i,COMMAND)...] [$(i,OPTIONS)]... ";
	`S Manpage.s_commands;
	`Blocks manpage_sec_common_options;
	`Blocks manpage_sec_more_help;
	`Blocks manpage_sec_issues;
	`S Manpage.s_exit_status;
  ] in
  Term.(ret (const (fun _ -> `Help (`Pager, None)) $ Commonopts.opts_t)),
  Term.info "uberspark" ~version:"6.0.0" ~doc ~sdocs ~exits ~man

(* additional commands *)	
let cmd_additions = [cmd_uobj; cmd_uobjcoll; cmd_staging; cmd_bridges]


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
	Uberspark.Logger.logf log_mpf Uberspark.Logger.Info "invalid option: '%s'; use -help to see available options" opt;
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
									Uberspark.Logger.logf log_mpf Uberspark.Logger.Error "in linking uobj binary '%s'!" uobj_bin_name;
									ignore(exit 1);
							end
						else
							begin
									Uberspark.Logger.logf log_mpf Uberspark.Logger.Info "Linked uobj binary '%s' successfully" uobj_bin_name;
							end
						;
		()
;;

																
								
																
*)
																								

(*----------------------------------------------------------------------------*)
let handle_option_info () =
		let handle_option_info_error = ref false in
		Uberspark.Logger.logf log_mpf Uberspark.Logger.Info ">>>>>>";

		if !cmdopt_get_includedir == true then
			begin
				if !cmdopt_uobjcoll_specified == true && !cmdopt_uobj_specified == false then
					begin
						Uberspark.Logger.logf log_mpf Uberspark.Logger.Stdoutput "%s" 
							Usconfig.get_uberspark_config_install_prefix;
					end
				else if !cmdopt_uobjcoll_specified == true && !cmdopt_uobj_specified == true then
					begin
						Uberspark.Logger.logf log_mpf Uberspark.Logger.Stdoutput "%s" 
							Usconfig.get_uberspark_config_install_prefix;
					end
				else if !cmdopt_uobjcoll_specified == false && !cmdopt_uobj_specified == false then
					begin
						Uberspark.Logger.logf log_mpf Uberspark.Logger.Stdoutput "%s" 
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
				Uberspark.Logger.logf log_mpf Uberspark.Logger.Stdoutput "%s" 
					(Usconfig.get_uberspark_config_install_uobjcolldir ^	"/" ^ 
					!cmdopt_uobjcoll ^ "/" ^ !cmdopt_uobj);
			end
			
		else if !cmdopt_get_libsentinels == true then
			begin
				Uberspark.Logger.logf log_mpf Uberspark.Logger.Stdoutput "%s" 
					(!cmdopt_uobj ^ "-" ^ 	!cmdopt_platform ^ "-" ^ !cmdopt_cpu ^ 
					"-" ^ !cmdopt_arch);
			end
		
		else if !cmdopt_get_installrootdir == true then
			begin
				Uberspark.Logger.logf log_mpf Uberspark.Logger.Stdoutput "%s" 
					Usconfig.get_uberspark_config_install_rootdir;
			end

		else if !cmdopt_get_buildshimsdir == true then
			begin
				Uberspark.Logger.logf log_mpf Uberspark.Logger.Stdoutput "%s" 
					Usconfig.get_uberspark_config_install_buildshimsdir;
			end
		
		;
		
		
		if !handle_option_info_error == true then
			begin
				Uberspark.Logger.logf log_mpf Uberspark.Logger.Error "invalid --info arguments";
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
				Uberspark.Logger.current_level := Uberspark.Logger.ord Uberspark.Logger.Stdoutput;
			end
		else
			begin
				Uberspark.Logger.current_level := Uberspark.Logger.ord Uberspark.Logger.Debug;
			end
		;
		
	  (* print banner and parse command line args *)
		Uberspark.Logger.logf log_mpf Uberspark.Logger.Info "%s" banner;
		Uberspark.Logger.logf log_mpf Uberspark.Logger.Info ">>>>>>";

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

		Uberspark.Logger.logf log_mpf Uberspark.Logger.Info "Target platform='%s', CPU='%s', arch='%s'"
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

		Uberspark.Logger.logf log_mpf Uberspark.Logger.Info "setting page size...";

		(* setup page size *)
		if !cmdopt_page_size_specified == true then
			begin
				Usconfig.page_size := (int_of_string(!cmdopt_page_size));
			end
		;


		(* create uobj collection *)
		Uberspark.Logger.logf log_mpf Uberspark.Logger.Info "Proceeding to initialize uobj collection using: %s..." !cmdopt_uobjcollmf;
		Usuobjcollection.init_build_configuration !cmdopt_uobjcollmf "" true;
		Usuobjcollection.collect_uobjs_with_manifest_parsing ();
		Usuobjcollection.compute_memory_map (int_of_string(!cmdopt_loadaddr)) (int_of_string(!cmdopt_uobjsize));
		Uberspark.Logger.logf log_mpf Uberspark.Logger.Info "Initialized uobj collection, total uobjs=%u" !Usuobjcollection.total_uobjs;

	


		(* if we are building *)
		if !copt_builduobj == true then
			begin
				Uberspark.Logger.logf log_mpf Uberspark.Logger.Info "Proceeding to compile uobj collection...";
				Usuobjcollection.compile "" true;
				Uberspark.Logger.logf log_mpf Uberspark.Logger.Info "Successfully compiled uobj collection.";
				Uberspark.Logger.logf log_mpf Uberspark.Logger.Info "Collection binary filename: %s" !Usuobjcollection.o_binary_image_filename;
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
				let uobj = new Uberspark.Uobj.uobject in
					uobj#build !uobj_manifest_filename "" true	
			end
		;
*)


(*			uobj_id := (Hashtbl.find Libusmf.slab_nametoid !uobj_name);*)

(*
			Uberspark.Logger.logf log_mpf Uberspark.Logger.Info "Parsing uobj manifest using: %s..." !cmdopt_uobjmanifest;
			Uberspark.Logger.logf log_mpf Uberspark.Logger.Info "uobj_name='%s', uobj_id=%u" !uobj_name !uobj_id;

			if (Libusmf.usmf_parse_uobj_mf_uobj_sources !uobj_id !cmdopt_uobjmanifest) == false then
				begin
					Uberspark.Logger.logf log_mpf Uberspark.Logger.Error "invalid or no uobj-sources node found within uobj manifest.";
					ignore (exit 1);
				end
			;

			Uberspark.Logger.logf log_mpf Uberspark.Logger.Info "Parsed uobj-sources from uobj manifest.";
			Uberspark.Logger.logf log_mpf Uberspark.Logger.Info "incdirs=%u, incs=%u, libdirs=%u, libs=%u"
				(List.length (Hashtbl.find_all Libusmf.slab_idtoincludedirs !uobj_id))
				(List.length (Hashtbl.find_all Libusmf.slab_idtoincludes !uobj_id))
				(List.length (Hashtbl.find_all Libusmf.slab_idtolibdirs !uobj_id))
				(List.length (Hashtbl.find_all Libusmf.slab_idtolibs !uobj_id))
				;
			Uberspark.Logger.logf log_mpf Uberspark.Logger.Info "cfiles=%u, casmfiles=%u, asmfiles=%u"
				(List.length (Hashtbl.find_all Libusmf.slab_idtocfiles !uobj_id))
				(List.length (Hashtbl.find_all Libusmf.slab_idtocasmfiles !uobj_id))
				(List.length (Hashtbl.find_all Libusmf.slab_idtoasmfiles !uobj_id))
				;
	
			uobj_mf_filename_forpreprocessing := 
					uberspark_generate_uobj_mf_forpreprocessing !uobj_id 
						!uobj_manifest_filename Libusmf.slab_idtoincludes;
			Uberspark.Logger.logf log_mpf Uberspark.Logger.Info "Generated uobj manifest file for preprocessing";
						
			uobj_mf_filename_preprocessed := 
					uberspark_generate_uobj_mf_preprocessed !uobj_id
					!uobj_mf_filename_forpreprocessing 
					(uberspark_build_includedirs_base () @ 
					(uberspark_build_includedirs !uobj_id Libusmf.slab_idtoincludedirs));	
			Uberspark.Logger.logf log_mpf Uberspark.Logger.Info "Pre-processed uobj manifest file";

	
			let (rval, uobj_sections_list) = 
				Libusmf.usmf_parse_uobj_mf_uobj_binary !uobj_id !uobj_mf_filename_preprocessed in
					if (rval == false) then
						begin
							Uberspark.Logger.logf log_mpf Uberspark.Logger.Error "invalid or no uobj-binary node found within uobj manifest.";
							ignore (exit 1);
						end
					;

			Uberspark.Logger.logf log_mpf Uberspark.Logger.Info "Parsed uobj-binary from uobj manifest: total sections=%u"
				(List.length uobj_sections_list);
		

				
			let uobj_hdr_cfile = uberspark_generate_uobj_hdr !uobj_name 0x80000000 
				uobj_sections_list in
				Uberspark.Logger.logf log_mpf Uberspark.Logger.Info "Generated uobj header file";
			
							
												
																				
			if (List.length (Hashtbl.find_all Libusmf.slab_idtocfiles !uobj_id)) > 0 then
				begin
					Uberspark.Logger.logf log_mpf Uberspark.Logger.Info "Proceeding to compile uobj cfiles...";
					uberspark_compile_uobj_cfiles 
						((Hashtbl.find_all Libusmf.slab_idtocfiles !uobj_id) @ [ uobj_hdr_cfile ])
						(uberspark_build_includedirs_base () @ 
						(uberspark_build_includedirs !uobj_id Libusmf.slab_idtoincludedirs));
				end
			;


			uberspark_generate_uobj_linker_script !uobj_name 0x80000000 
				uobj_sections_list;
		


			Uberspark.Logger.logf log_mpf Uberspark.Logger.Info "Proceeding to link uobj binary '%s'..."
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

			Uberspark.Logger.logf log_mpf Uberspark.Logger.Info "uobj_name=%s, uobj_id=%u\n"  !uobj_name !uobj_id;
			Libusmf.usmf_memoffsets := false;
			Libusmf.usmf_parse_uobj_mf (Hashtbl.find Libusmf.slab_idtogsm !uobj_id) (Hashtbl.find Libusmf.slab_idtommapfile !uobj_id);
*)


(*
			Uberspark.Logger.current_level := Uberspark.Logger.ord Uberspark.Logger.Info;
			Uberspark.Logger.logf log_mpf Uberspark.Logger.Info "proceeding to execute...\n";

			let p_cmdline = ref [] in
				p_cmdline := !p_cmdline @ [ "gcc" ];
				p_cmdline := !p_cmdline @ [ "-P" ];
				p_cmdline := !p_cmdline @ [ "-E" ];
				p_cmdline := !p_cmdline @ [ "../../dat.c" ];
				p_cmdline := !p_cmdline @ [ "-o" ];
				p_cmdline := !p_cmdline @ [ "dat.i" ];
				
			let (exit_status, exit_signal, process_output) = (exec_process_withlog "gcc" !p_cmdline true) in
						Uberspark.Logger.logf log_mpf Uberspark.Logger.Info "Done: exit_signal=%b exit_status=%d\n" exit_signal exit_status;
*)

(*
				let str_list = (Hashtbl.find_all Libusmf.slab_idtoincludedirs !uobj_id) in
				begin
					Uberspark.Logger.logf log_mpf Uberspark.Logger.Info "length=%u\n"  (List.length str_list);
					while (!i < (List.length str_list)) do
						begin
							let mstr = (List.nth str_list !i) in
							Uberspark.Logger.logf log_mpf Uberspark.Logger.Info "i=%u --> %s" !i mstr; 
							i := !i + 1;
						end
					done;
				end
*)

(*
		Uberspark.Logger.logf log_mpf Uberspark.Logger.Info "proceeding to parse includes...";
			Libusmf.usmf_parse_uobj_mf_includedirs !uobj_id !cmdopt_uobjmanifest;
			Uberspark.Logger.logf log_mpf Uberspark.Logger.Info "includes parsed.";

			let str_list = (Hashtbl.find_all Libusmf.slab_idtoincludedirs !uobj_id) in
				begin
					Uberspark.Logger.logf log_mpf Uberspark.Logger.Info "length=%u\n"  (List.length str_list);
					while (!i < (List.length str_list)) do
						begin
							let include_dir_str = (List.nth str_list !i) in
							Uberspark.Logger.logf log_mpf Uberspark.Logger.Info "i=%u --> %s" !i include_dir_str; 
							i := !i + 1;
						end
					done;
				end
*)
*)