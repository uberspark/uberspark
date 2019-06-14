(*
	uberSpark external binary generation utilities interface
	author: amit vasudevan (amitvasudevan@acm.org)
*)

open Uslog
open Usosservices

module Usextbinutils =
	struct

	let tool_pp = "gcc" ;;
	let tool_cc = "gcc" ;;
	let tool_ld = "ld" ;;
	let tool_ar = "ar" ;;
	let tool_objcopy = "objcopy" ;;
		
	let usextbinutils_tag = "Usextbinutils" ;;
			
			
	let preprocess 
			pp_inputfilename pp_outputfilename pp_includedirs_list pp_defines_list =
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
				
			
	let compile_cfile cc_inputfilename cc_outputfilename cc_includedirs_list
		cc_defines_list =  
			let cc_cmdline = ref [] in
				cc_cmdline := !cc_cmdline @ [ "-c" ];
				cc_cmdline := !cc_cmdline @ [ "-m32" ];
				cc_cmdline := !cc_cmdline @ [ "-fno-common" ];
				List.iter (fun x -> 
						cc_cmdline := !cc_cmdline @ [ "-I" ] @ [ x ]
						) cc_includedirs_list;
				List.iter (fun x -> 
						cc_cmdline := !cc_cmdline @ [ "-D" ] @ [ x ]
						) cc_defines_list;
				cc_cmdline := !cc_cmdline @ [ cc_inputfilename ];
				cc_cmdline := !cc_cmdline @ [ "-o" ];
				cc_cmdline := !cc_cmdline @ [ cc_outputfilename ];
				let (cc_pestatus, cc_pesignal, _) =
						Usosservices.exec_process_withlog 
					tool_cc !cc_cmdline true usextbinutils_tag in
				(cc_pestatus, cc_pesignal, cc_outputfilename)
	;;


	let link_uobj uobj_ofile_list uobj_libdirs_list uobj_libs_list 
			uobj_linker_script uobj_bin_name = 
			let ld_cmdline = ref [] in
				ld_cmdline := !ld_cmdline @ [ "--oformat" ];
				ld_cmdline := !ld_cmdline @ [ "elf32-i386" ];
				ld_cmdline := !ld_cmdline @ [ "-T" ];
				ld_cmdline := !ld_cmdline @ [ uobj_linker_script ]; 
				List.iter (fun x -> ld_cmdline := !ld_cmdline @ [ (x^".o") ]) uobj_ofile_list; 
				ld_cmdline := !ld_cmdline @ [ "-o" ];
				ld_cmdline := !ld_cmdline @ [ uobj_bin_name ];
				List.iter (fun x -> ld_cmdline := !ld_cmdline @ [ ("-L"^x) ]) uobj_libdirs_list; 
				ld_cmdline := !ld_cmdline @ [ "--start-group" ];
				List.iter (fun x -> ld_cmdline := !ld_cmdline @ [ ("-l"^x) ]) uobj_libs_list; 
				ld_cmdline := !ld_cmdline @ [ "--end-group" ];
				let (ld_pestatus, ld_pesignal, _) = 
						Usosservices.exec_process_withlog 
						tool_ld !ld_cmdline true usextbinutils_tag in
				(ld_pestatus, ld_pesignal) 
	;;


	let mkbin uobj_input_filename uobj_output_filename = 
			let objcopy_cmdline = ref [] in
				objcopy_cmdline := !objcopy_cmdline @ [ "-I" ];
				objcopy_cmdline := !objcopy_cmdline @ [ "elf32-i386" ];
				objcopy_cmdline := !objcopy_cmdline @ [ "-O" ];
				objcopy_cmdline := !objcopy_cmdline @ [ "binary" ];
				objcopy_cmdline := !objcopy_cmdline @ [ uobj_input_filename ];
				objcopy_cmdline := !objcopy_cmdline @ [ uobj_output_filename ];
				let (objcopy_pestatus, objcopy_pesignal, _) = 
						Usosservices.exec_process_withlog 
						tool_objcopy !objcopy_cmdline true usextbinutils_tag in
				(objcopy_pestatus, objcopy_pesignal) 
	;;



	let mklib lib_ofile_list lib_name = 
			let ar_cmdline = ref [] in
				ar_cmdline := !ar_cmdline @ [ "-rcs" ];
				ar_cmdline := !ar_cmdline @ [ lib_name ]; 
				List.iter (fun x -> ar_cmdline := !ar_cmdline @ [ (x^".o") ]) lib_ofile_list; 
				let (ar_pestatus, ar_pesignal, _) = 
						Usosservices.exec_process_withlog 
						tool_ar !ar_cmdline true usextbinutils_tag in
				(ar_pestatus, ar_pesignal) 
	;;


																							
	let test_func () =
		(true)
	;;

	end