(*
	uberSpark external binary generation utilities interface
	author: amit vasudevan (amitvasudevan@acm.org)
*)

open UsOsservices

module UsExtbinutils =
	struct

	let tool_pp = "gcc" ;;
			
	let preprocess 
			pp_inputfilename pp_includedirs_list pp_defines_list =
		  let pp_outputfilename = 
				((Filename.basename pp_inputfilename) ^ ".upp") in
			let pp_cmdline = ref [] in
				pp_cmdline := !pp_cmdline @ [ "-E" ];
				pp_cmdline := !pp_cmdline @ [ "-P" ];
				pp_cmdline := !pp_cmdline @ pp_defines_list;
				pp_cmdline := !pp_cmdline @ pp_includedirs_list;
				pp_cmdline := !pp_cmdline @ [ pp_inputfilename ];
				pp_cmdline := !pp_cmdline @ [ "-o" ];
				pp_cmdline := !pp_cmdline @ [ pp_outputfilename ];
				ignore(UsOsservices.exec_process_withlog 
					tool_pp !pp_cmdline true);
		(pp_outputfilename)
	;;
				
								
	let test_func () =
		(true)
	;;

	end