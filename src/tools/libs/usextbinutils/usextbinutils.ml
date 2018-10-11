(*
	uberSpark external binary generation utilities interface
	author: amit vasudevan (amitvasudevan@acm.org)
*)

open Uslog
open Usosservices

module Usextbinutils =
	struct


	(* Uslog.logf usextbinutils_tag Uslog.Debug "hello"; *)
	
	let tool_pp = "gcc" ;;
	let usextbinutils_tag = "Usextbinutils" ;;
			
			
	let preprocess 
			pp_inputfilename pp_outputfilename pp_includedirs_list pp_defines_list =
		  (* let pp_outputfilename = 
				((Filename.basename pp_inputfilename) ^ ".upp") in *)
			let pp_cmdline = ref [] in
				pp_cmdline := !pp_cmdline @ [ "-E" ];
				pp_cmdline := !pp_cmdline @ [ "-P" ];
				List.iter (fun x -> 
						pp_cmdline := !pp_cmdline @ [ "-I" ] @ [ x ]
						) pp_includedirs_list;
				List.iter (fun x -> 
						pp_cmdline := !pp_cmdline @ [ "-D" ] @ [ x ]
						) pp_defines_list;
				pp_cmdline := !pp_cmdline @ [ pp_inputfilename ];
				pp_cmdline := !pp_cmdline @ [ "-o" ];
				pp_cmdline := !pp_cmdline @ [ pp_outputfilename ];
				let (pp_retval, _, _) =
						Usosservices.exec_process_withlog 
					tool_pp !pp_cmdline true usextbinutils_tag in
		(pp_retval, pp_outputfilename)
	;;
				
								
	let test_func () =
		(true)
	;;

	end