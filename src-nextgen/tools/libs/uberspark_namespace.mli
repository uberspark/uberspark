(*
	uberSpark namespace module interface
	author: amit vasudevan (amitvasudevan@acm.org)
*)


(*------------------------------------------------------------------------*)
(* namespace variables *)	
(*------------------------------------------------------------------------*)
val namespace_root : string
val namespace_root_dir : string ref
val namespace_root_mf_filename : string

val namespace_uobj : string
val namespace_uobj_mf_filename : string
val namespace_uobj_mf_hdr_type : string
val namespace_uobj_build_dir : string
val namespace_uobj_binhdr_src_filename : string
val namespace_uobj_publicmethods_info_src_filename : string
val namespace_uobj_intrauobjcoll_callees_info_src_filename : string
val namespace_uobj_interuobjcoll_callees_info_src_filename : string
val namespace_uobj_legacy_callees_info_src_filename : string
val namespace_uobj_linkerscript_filename : string
val namespace_uobj_binary_image_filename : string
val namespace_uobj_top_level_include_header_src_filename : string;;


val namespace_uobjcoll : string
val namespace_uobjcoll_mf_filename : string

val namespace_uobjrtl_mf_filename : string

val namespace_legacy : string


val namespace_uobjslt : string
val namespace_uobjslt_mf_hdr_type : string
val namespace_uobjslt_mf_filename : string
val namespace_uobjslt_intrauobjcoll_callees_src_filename : string
val namespace_uobjslt_interuobjcoll_callees_src_filename : string
val namespace_uobjslt_legacy_callees_src_filename : string
val namespace_uobjslt_output_symbols_filename : string

val namespace_config : string
val namespace_config_mf_filename : string
val namespace_config_current : string
val namespace_config_default : string


val namespace_bridge : string
val namespace_bridge_mf_filename : string
val namespace_bridge_container_filename : string

val namespace_bridge_ar_bridge_name : string
val namespace_bridge_as_bridge_name : string
val namespace_bridge_cc_bridge_name : string
val namespace_bridge_ld_bridge_name : string
val namespace_bridge_pp_bridge_name : string
val namespace_bridge_vf_bridge_name : string
val namespace_bridge_bldsys_bridge_name : string


val namespace_bridge_ar_bridge : string
val namespace_bridge_as_bridge : string
val namespace_bridge_cc_bridge : string
val namespace_bridge_ld_bridge : string
val namespace_bridge_pp_bridge : string
val namespace_bridge_vf_bridge : string
val namespace_bridge_bldsys_bridge : string


(*------------------------------------------------------------------------*)
(* namespace methods *)	
(*------------------------------------------------------------------------*)

val get_uobj_uobjcoll_name_from_uobj_ns :  string -> (bool * string * string)
val is_uobj_uobjcoll_abspath_in_namespace : string -> bool

