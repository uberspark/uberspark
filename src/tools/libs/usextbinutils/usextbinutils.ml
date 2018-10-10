(*
	uberSpark external binary generation utilities interface
	author: amit vasudevan (amitvasudevan@acm.org)
*)

open Uslog
open Usosservices

module Usextbinutils =
	struct

	let tool_pp = "gcc" ;;
	let usextbinutils_tag = "Usextbinutils" ;;
			
			
	let preprocess 
			pp_inputfilename pp_outputfilename pp_includedirs_list pp_defines_list =
		  (* let pp_outputfilename = 
				((Filename.basename pp_inputfilename) ^ ".upp") in *)
			let pp_cmdline = ref [] in
				pp_cmdline := !pp_cmdline @ [ "-E" ];
				pp_cmdline := !pp_cmdline @ [ "-P" ];
				pp_cmdline := !pp_cmdline @ pp_defines_list;
				pp_cmdline := !pp_cmdline @ pp_includedirs_list;
				pp_cmdline := !pp_cmdline @ [ pp_inputfilename ];
				pp_cmdline := !pp_cmdline @ [ "-o" ];
				pp_cmdline := !pp_cmdline @ [ pp_outputfilename ];
				Uslog.logf "testing" Uslog.Info "hello";

				ignore(Usosservices.exec_process_withlog 
					tool_pp !pp_cmdline true usextbinutils_tag);
		(pp_outputfilename)
	;;
				
								
	let test_func () =
		(true)
	;;

	end