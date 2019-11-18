(*
	uberSpark configuration module interface
	author: amit vasudevan (amitvasudevan@acm.org)
*)

val config_hdr: Uberspark_manifest.Config.config_hdr_t
val config_settings: Uberspark_manifest.Config.config_settings_t


(*
val hdr_namespace : string ref
*)



(*
(*------------------------------------------------------------------------*)
(* uobj/uobjcoll binary related configuration settings *)	
(*------------------------------------------------------------------------*)

val binary_page_size : int ref
val binary_uobj_section_alignment : int ref
val binary_uobj_default_section_size : int ref

val binary_uobj_default_load_addr : int ref
val binary_uobj_default_size : int ref


(*------------------------------------------------------------------------*)
(* bridge related configuration settings *)	
(*------------------------------------------------------------------------*)
val bridge_cc_bridge : string ref
*)



val load : string -> bool

val create_from_existing_ns : string -> string -> (bool * string)

val create_from_file : string -> string -> (bool * string)

val dump : string -> unit

val settings_get : string ->  (bool * string)

val settings_set : string -> string -> bool

val switch : string -> bool

val remove : string -> bool

val load_from_json : Yojson.Basic.json -> bool



