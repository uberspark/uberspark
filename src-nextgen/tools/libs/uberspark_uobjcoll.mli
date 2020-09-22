(*------------------------------------------------------------------------------
	uberSpark uberobject collection verification and build interface
	author: amit vasudevan (amitvasudevan@acm.org)
------------------------------------------------------------------------------*)

val parse_manifest : string -> bool
val install_create_ns : unit -> unit

val initialize_common_operation_context :
	string ->
	Defs.Basedefs.target_def_t ->
	int ->
	bool * string

val build : string -> Defs.Basedefs.target_def_t -> int -> bool
val verify : string -> Defs.Basedefs.target_def_t -> int -> bool
