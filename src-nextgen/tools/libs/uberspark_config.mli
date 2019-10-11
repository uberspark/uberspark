(*
	uberSpark configuration module interface
	author: amit vasudevan (amitvasudevan@acm.org)
*)

(*------------------------------------------------------------------------*)
(* environment related configuration settings *)	
(*------------------------------------------------------------------------*)
(*val env_path_seperator : string ref*)
val env_home_dir : string ref

(*------------------------------------------------------------------------*)
(* namespace related configuration settings *)	
(*------------------------------------------------------------------------*)
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


val namespace_bridges : string

val namespace_bridges_ar_bridge_name : string;
val namespace_bridges_as_bridge_name : string;
val namespace_bridges_cc_bridge_name : string;
val namespace_bridges_ld_bridge_name : string;
val namespace_bridges_pp_bridge_name : string;
val namespace_bridges_vf_bridge_name : string;
val namespace_bridges_bldsys_bridge_name : string;


val namespace_bridges_ar_bridge : string
val namespace_bridges_as_bridge : string
val namespace_bridges_cc_bridge : string
val namespace_bridges_ld_bridge : string
val namespace_bridges_pp_bridge : string
val namespace_bridges_vf_bridge : string
val namespace_bridges_bldsys_bridge : string



(*------------------------------------------------------------------------*)
(* uobj/uobjcoll binary related configuration settings *)	
(*------------------------------------------------------------------------*)

val binary_page_size : int ref
val binary_uobj_section_alignment : int ref
val binary_uobj_default_section_size : int ref

val binary_uobj_default_load_addr : int ref
val binary_uobj_default_size : int ref



val load : string -> bool

val create_from_existing_ns : string -> string -> (bool * string)

val create_from_file : string -> string -> (bool * string)

val dump : string -> unit

val settings_get : string ->  (bool * string)

val settings_set : string -> string -> bool

val switch : string -> bool

val remove : string -> bool




