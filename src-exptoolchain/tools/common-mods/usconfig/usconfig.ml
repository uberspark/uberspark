(*
	uberSpark configuration data interface
	author: amit vasudevan (amitvasudevan@acm.org)
*)
open Unix

module Usconfig =
	struct

	(*------------------------------------------------------------------------*)
	(* environment related configuration settings *)	
	(*------------------------------------------------------------------------*)
	let env_path_seperator = "/";;
	let env_home_dir = Unix.getenv "HOME";;




	(*------------------------------------------------------------------------*)
	(* namespace related configuration settings *)	
	(*------------------------------------------------------------------------*)
	let namespace_root = (env_home_dir ^ env_path_seperator ^ "uberspark");;
	let namespace_default_uobj_mf_filename = "uberspark-uobj-mf.json";;
	let namespace_uobj_mf_hdr_type = "uobj";;

	let namespace_uobjslt = (namespace_root ^ env_path_seperator ^ "uobjslt");;
	let namespace_uobjslt_mf_hdr_type = "uobjslt";;
	let namespace_uobjslt_mf_filename = "uberspark-uobjslt-mf.json";;
	let namespace_uobjslt_output_code_filename = "uobjslt-trampolinecode.S";;
	let namespace_uobjslt_output_data_filename = "uobjslt-trampolinedata.S";;


	(*------------------------------------------------------------------------*)
	(* uobj/uobjcoll binary related configuration settings *)	
	(*------------------------------------------------------------------------*)


	(*------------------------------------------------------------------------*)
	(* uberspark installation configuration information *)	
	(*------------------------------------------------------------------------*)
	let get_uberspark_config_install_prefix = 
		"@prefix@";;

	let get_uberspark_config_install_rootdir = 
		"@prefix@@ubersparkhomedir@";;

	let get_uberspark_config_install_includedir = 
		"@prefix@@ubersparkhomedir@@ubersparkincludedir@";;

	let get_uberspark_config_install_buildshimsdir = 
		"@prefix@@ubersparkhomedir@@ubersparkbuildshimsdir@";;


	let get_uberspark_config_install_uobjcolldir = 
		"@prefix@@ubersparkhomedir@@ubersparkuobjcolldir@";;


	(*------------------------------------------------------------------------*)
	(* uberspark hardware related configuration information *)	
	(*------------------------------------------------------------------------*)
	let get_uberspark_config_hw_platform_default = 
		"@uberspark_config_hw_platform_default@";;

	let get_uberspark_config_hw_cpu_default = 
		"@uberspark_config_hw_cpu_default@";;

	let get_uberspark_config_hw_arch_default = 
		"@uberspark_config_hw_arch_default@";;


	(*------------------------------------------------------------------------*)

	(* uobj manifest default filename *)
	let std_uobj_usmf_name = "UOBJ.USMF";;
	
	(* uobj collection manifest default filename *)
	let default_uobjcoll_usmf_name = "UOBJCOLL.USMF";;

	(* uobj library manifest default filename *)
	let std_uobj_lib_usmf_name = "UOBJLIB.USMF";;

	(* uobj consolidated header filename *)
	let uobj_hfilename = "uobj";;
	let get_uobj_hfilename () =	(uobj_hfilename)	;;

	(* uobj collection info default filename *)
	let std_uobjcoll_info_filename = "uobjcoll_info_table.c";;
	let get_std_uobjcoll_info_filename () =	(std_uobjcoll_info_filename)	;;

	(* standard include directories *)
	let std_incdirs = [
										"/usr/local/uberspark/include";
										"/usr/local/uberspark/hwm/include";
										"/usr/local/uberspark/libs/include";
										"."
										];;

	let get_std_incdirs () =	(std_incdirs)	;;

	(* sentinel directory *)
	let sentinel_dir = "/usr/local/uberspark/sentinels";;
	let get_sentinel_dir () = (sentinel_dir);;

	(* uobjcoll default installation directory *)
	let default_install_uobjcolldir = "/usr/local/uberspark/uobjcoll";;
	let get_default_install_uobjcolldir () = (default_install_uobjcolldir);;


	let std_max_sections = 16;;
	let get_std_max_sections () = (std_max_sections) ;;

	let section_name_ustack = "uobj_ustack";;
	let get_section_name_ustack () = (section_name_ustack);;

	let section_name_tstack = "uobj_tstack";;
	let get_section_name_tstack () = (section_name_tstack);;

	let default_load_addr = "0x60000000";;
	let get_default_load_addr () = (default_load_addr);;

	let default_uobjsize = "0x01000000";;
	let get_default_uobjsize () = (default_uobjsize);;

	let default_uobjcoll_hdr_size = "0x01000000";;
	let get_default_uobjcoll_hdr_size () = (default_uobjcoll_hdr_size);;

	(*let default_section_alignment = "0x00200000";;
	let get_default_section_alignment () = (default_section_alignment);;
	*)

	(* section alignment *)
	let section_alignment = ref 0x00200000;;
		
	(* memory page size *)
	let page_size = ref 0x00200000;;

	(* default general section size *)
	let section_size_general = ref 0x00200000;;

	(* default sentinel section size *)
	let section_size_sentinel = ref 0x00001000;;

	(*--------------------------------------------------------------------------*)
	(* stuff below needs to be in sync with include/uberspark-config.h *)
	(* also check include/uberspark.h for sentinel definitions *)
	(* and include/usbinformat.h for binary definitions *)
	(*--------------------------------------------------------------------------*)
 	let def_USBINFORMAT_SECTION_TYPE_PADDING = 0x0;;
	let def_USBINFORMAT_SECTION_TYPE_UOBJ =	0x1;;
	let def_USBINFORMAT_SECTION_TYPE_UOBJCOLL_ENTRYSENTINEL = 0x2;;
	let def_USBINFORMAT_SECTION_TYPE_UOBJ_RESUMESENTINEL = 0x3;;
	let def_USBINFORMAT_SECTION_TYPE_UOBJ_CALLEESENTINEL = 0x4;;
	let def_USBINFORMAT_SECTION_TYPE_UOBJ_EXITCALLEESENTINEL = 0x5;;
	let def_USBINFORMAT_SECTION_TYPE_UOBJ_HDR =	0x6;;
	let def_USBINFORMAT_SECTION_TYPE_UOBJ_CODE = 0x7;;
	let def_USBINFORMAT_SECTION_TYPE_UOBJ_RWDATA = 0x8;;
	let def_USBINFORMAT_SECTION_TYPE_UOBJ_RODATA = 0x9;;
	let def_USBINFORMAT_SECTION_TYPE_UOBJ_USTACK = 0xa;;
	let def_USBINFORMAT_SECTION_TYPE_UOBJ_TSTACK = 0xb;;
	let def_USBINFORMAT_SECTION_TYPE_UOBJ_USTACKTOS = 0xc;;
	let def_USBINFORMAT_SECTION_TYPE_UOBJ_TSTACKTOS = 0xd;;
	let def_USBINFORMAT_SECTION_TYPE_UOBJ_DMADATA = 0xe;;


	let sentinel_types =
    [ "call", "UOBJ_SENTINEL_TYPE_CALL"; 
		]
  ;;
	let get_sentinel_types () =	(sentinel_types)	;;

	(* sentinel protection and binary size in bytes *)
	(* TODO: figure out the best place to specify these *)
	let sentinel_prot = "rx";;
	let get_sentinel_prot () = (sentinel_prot);;

	let sentinel_size_bytes = "0x1000";;
	let get_sentinel_size_bytes () = (sentinel_size_bytes);;


	(* standard preprocessor definitions *)
	let std_defines = [ 
											"__XMHF_TARGET_CPU_X86__"; 
											"__XMHF_TARGET_CONTAINER_VMX__";
											"__XMHF_TARGET_PLATFORM_X86PC__";
											"__XMHF_TARGET_TRIAD_X86_VMX_X86PC__"
										];;

	let get_std_defines () =	(std_defines)	;;

	let std_define_asm = [
												"__ASSEMBLY__"
											];;
				
	let get_std_define_asm () =	(std_define_asm)	;;

	
	
				
	(* maximum platform CPUs *)
	(* TBD: this has to be synced with hw model defs *)
	let std_max_platform_cpus = 8;;
	let get_std_max_platform_cpus () =	(std_max_platform_cpus)	;;
									
	let std_max_incldevlist_entries = 6;;
	let get_std_max_incldevlist_entries () = (std_max_incldevlist_entries) ;;

	let std_max_excldevlist_entries = 6;;
	let get_std_max_excldevlist_entries () = (std_max_excldevlist_entries) ;;

	let sizeof_uobj_tstack = 4096;;
	let get_sizeof_uobj_tstack () = (sizeof_uobj_tstack) ;;

	let sizeof_uobj_ustack = 4096;;
	let get_sizeof_uobj_ustack () = (sizeof_uobj_ustack) ;;
 
	let sizeof_uobjcoll_info_t = 0x21000;;
	let get_sizeof_uobjcoll_info_t () = (sizeof_uobjcoll_info_t) ;;

;;
								
	end