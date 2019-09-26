val env_path_seperator : string
val env_home_dir : string
val namespace_root : string
val namespace_default_uobj_mf_filename : string
val namespace_uobj_mf_hdr_type : string
val namespace_uobj_binhdr_src_filename : string
val namespace_uobj_publicmethods_info_src_filename : string
val namespace_uobj_intrauobjcoll_callees_info_src_filename : string
val namespace_uobj_interuobjcoll_callees_info_src_filename : string
val namespace_uobj_linkerscript_filename : string
val namespace_uobjslt : string
val namespace_uobjslt_mf_hdr_type : string
val namespace_uobjslt_mf_filename : string
val namespace_uobjslt_callees_output_filename : string
val namespace_uobjslt_exitcallees_output_filename : string
val namespace_uobjslt_output_symbols_filename : string
val binary_page_size : int ref
val binary_uobj_section_alignment : int ref
val binary_uobj_default_section_size : int ref
val binary_uobj_default_load_addr : int ref
val binary_uobj_default_size : int ref
val binary_uobj_publicmethod_max_length : int ref
val binary_uobj_max_publicmethods : int ref
val binary_uobj_namespace_max_length : int ref
val binary_uobj_max_intrauobjcoll_callees : int ref
val binary_uobj_max_interuobjcoll_callees : int ref
val def_USBINFORMAT_SECTION_TYPE_PADDING : int
val def_USBINFORMAT_SECTION_TYPE_UOBJ : int
val def_USBINFORMAT_SECTION_TYPE_UOBJCOLL_ENTRYSENTINEL : int
val def_USBINFORMAT_SECTION_TYPE_UOBJ_RESUMESENTINEL : int
val def_USBINFORMAT_SECTION_TYPE_UOBJ_CALLEESENTINEL : int
val def_USBINFORMAT_SECTION_TYPE_UOBJ_EXITCALLEESENTINEL : int
val def_USBINFORMAT_SECTION_TYPE_UOBJ_HDR : int
val def_USBINFORMAT_SECTION_TYPE_UOBJ_CODE : int
val def_USBINFORMAT_SECTION_TYPE_UOBJ_RWDATA : int
val def_USBINFORMAT_SECTION_TYPE_UOBJ_RODATA : int
val def_USBINFORMAT_SECTION_TYPE_UOBJ_USTACK : int
val def_USBINFORMAT_SECTION_TYPE_UOBJ_TSTACK : int
val def_USBINFORMAT_SECTION_TYPE_UOBJ_USTACKTOS : int
val def_USBINFORMAT_SECTION_TYPE_UOBJ_TSTACKTOS : int
val def_USBINFORMAT_SECTION_TYPE_UOBJ_DMADATA : int
(*val get_uberspark_config_install_prefix : string
val get_uberspark_config_install_rootdir : string
val get_uberspark_config_install_includedir : string
val get_uberspark_config_install_buildshimsdir : string
val get_uberspark_config_install_uobjcolldir : string
val get_uberspark_config_hw_platform_default : string
val get_uberspark_config_hw_cpu_default : string
val get_uberspark_config_hw_arch_default : string
val std_uobj_usmf_name : string
val default_uobjcoll_usmf_name : string
val std_uobj_lib_usmf_name : string
val uobj_hfilename : string
val get_uobj_hfilename : unit -> string
val std_uobjcoll_info_filename : string
val get_std_uobjcoll_info_filename : unit -> string
val std_incdirs : string list
val get_std_incdirs : unit -> string list
val sentinel_dir : string
val get_sentinel_dir : unit -> string
val default_install_uobjcolldir : string
val get_default_install_uobjcolldir : unit -> string
val std_max_sections : int
val get_std_max_sections : unit -> int
val section_name_ustack : string
val get_section_name_ustack : unit -> string
val section_name_tstack : string
val get_section_name_tstack : unit -> string
val default_load_addr : string
val get_default_load_addr : unit -> string
val default_uobjsize : string
val get_default_uobjsize : unit -> string
val default_uobjcoll_hdr_size : string
val get_default_uobjcoll_hdr_size : unit -> string
val section_size_general : int ref
val section_size_sentinel : int ref
val sentinel_types : (string * string) list
val get_sentinel_types : unit -> (string * string) list
val sentinel_prot : string
val get_sentinel_prot : unit -> string
val sentinel_size_bytes : string
val get_sentinel_size_bytes : unit -> string
val std_defines : string list
val get_std_defines : unit -> string list
val std_define_asm : string list
val get_std_define_asm : unit -> string list
val std_max_platform_cpus : int
val get_std_max_platform_cpus : unit -> int
val std_max_incldevlist_entries : int
val get_std_max_incldevlist_entries : unit -> int
val std_max_excldevlist_entries : int
val get_std_max_excldevlist_entries : unit -> int
val sizeof_uobj_tstack : int
val get_sizeof_uobj_tstack : unit -> int
val sizeof_uobj_ustack : int
val get_sizeof_uobj_ustack : unit -> int
val sizeof_uobjcoll_info_t : int
val get_sizeof_uobjcoll_info_t : unit -> int
*)