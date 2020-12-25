(*===========================================================================*)
(*===========================================================================*)
(*	uberSpark namespace interface implementation		 *)
(*	author: amit vasudevan (amitvasudevan@acm.org)							 *)
(*===========================================================================*)
(*===========================================================================*)


(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* type definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)


(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* variable definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)

(* root *)
val namespace_root : string
val namespace_root_dir_prefix : string ref
val namespace_root_mf_filename : string
val namespace_root_mf_node_type_tag : string
val namespace_root_vf_bridge_plugin : string


(* installation *)
val namespace_installation_configdir : string
val namespace_installation_mf_node_type_tag : string


(* uobjs *)
val namespace_uobj : string
val namespace_uobj_build_dir : string
val namespace_uobj_binhdr_src_filename : string
val namespace_uobj_publicmethods_info_src_filename : string
val namespace_uobj_intrauobjcoll_callees_info_src_filename : string
val namespace_uobj_interuobjcoll_callees_info_src_filename : string
val namespace_uobj_legacy_callees_info_src_filename : string
val namespace_uobj_linkerscript_filename : string
val namespace_uobj_binary_image_filename : string
val namespace_uobj_binary_flat_image_filename : string
val namespace_uobj_top_level_include_header_src_filename : string
val namespace_uobj_mf_node_type_tag : string
val namespace_uobj_cclib_filename : string


(* uobjcoll *)
val namespace_uobjcoll : string
val namespace_uobjcoll_build_dir : string
val namespace_uobjcoll_uobj_binary_image_section_mapping_src_filename : string
val namespace_uobjcoll_sentinel_definitions_src_filename : string
val namespace_uobjcoll_linkerscript_filename : string
val namespace_uobjcoll_binary_image_filename : string
val namespace_uobjcoll_binary_flat_image_filename : string

(* legacy *)
val namespace_legacy : string

(* uobjrtl *)
val namespace_uobjrtl : string
val namespace_uobjrtl_mf_node_type_tag : string


(* uobjslt *)
val namespace_uobjslt : string
val namespace_uobjslt_intrauobjcoll_callees_src_filename : string
val namespace_uobjslt_interuobjcoll_callees_src_filename : string
val namespace_uobjslt_legacy_callees_src_filename : string
val namespace_uobjslt_output_symbols_filename : string
val namespace_uobjslt_mf_node_type_tag : string

(* sentinels *)
val namespace_sentinel : string
val namespace_sentinel_mf_node_type_tag : string


(* staging *)
val namespace_staging : string
val namespace_staging_current : string
val namespace_staging_golden : string
val namespace_staging_default : string

(* config *)
val namespace_config : string
val namespace_config_mf_node_type_tag : string

(* bridges *)
val namespace_bridge : string
val namespace_bridge_container_filename : string
val namespace_bridge_container_mountpoint : string

val namespace_bridge_cc_mf_node_type_tag : string
val namespace_bridge_ld_mf_node_type_tag : string
val namespace_bridge_as_mf_node_type_tag : string
val namespace_bridge_vf_mf_node_type_tag : string
val namespace_bridge_loader_mf_node_type_tag : string

val namespace_bridge_ar_bridge_name : string
val namespace_bridge_as_bridge_name : string
val namespace_bridge_cc_bridge_name : string
val namespace_bridge_ld_bridge_name : string
val namespace_bridge_pp_bridge_name : string
val namespace_bridge_vf_bridge_name : string
val namespace_bridge_loader_bridge_name : string
val namespace_bridge_bldsys_bridge_name : string

val namespace_bridge_ar_bridge : string
val namespace_as_bridge_namespace : string
val namespace_cc_bridge_namespace : string
val namespace_ld_bridge_namespace : string
val namespace_bridge_pp_bridge : string
val namespace_bridge_vf_bridge : string
val namespace_bridge_loader_bridge : string
val namespace_bridge_bldsys_bridge : string

(* loader *)
val namespace_loader_build_dir : string
val namespace_loader_binary_image_filename : string
val namespace_loader_binary_flat_image_filename : string


(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* interface definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)

val set_namespace_root_dir_prefix : string -> unit
val get_namespace_root_dir_prefix : unit -> string
val get_namespace_staging_dir_prefix : unit -> string

val get_variable_name_prefix_from_ns : string -> string
val get_uobj_uobjcoll_name_from_uobj_namespace :  string -> (bool * string * string)
val is_uobj_uobjcoll_abspath_in_namespace : string -> bool
val is_uobj_uobjcoll_canonical_namespace : string -> bool
val is_uobj_ns_in_uobjcoll_ns : string -> string -> bool
val get_namespace_basename : string -> string

