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


(*------------------------------------------------------------------------*)
(* uobj/uobjcoll binary related configuration settings *)	
(*------------------------------------------------------------------------*)

val binary_page_size : int ref
val binary_uobj_section_alignment : int ref
val binary_uobj_default_section_size : int ref

val binary_uobj_default_load_addr : int ref
val binary_uobj_default_size : int ref



val switch : string -> bool

val dump : string -> unit

val settings_set : string -> string -> bool

val settings_get : string ->  (bool * string)

val create_from_existing_ns : string -> string -> (bool * string)

val create_from_file : string -> string -> (bool * string)
