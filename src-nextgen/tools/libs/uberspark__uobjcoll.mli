(*------------------------------------------------------------------------------
	uberSpark uberobject collection verification and build interface
	author: amit vasudevan (amitvasudevan@acm.org)
------------------------------------------------------------------------------*)

val parse_manifest : string -> bool
val install_create_ns : unit -> unit
val install_h_files_ns : ?context_path_builddir:string -> unit

val initialize_common_operation_context :
	string ->
	Uberspark.Defs.Basedefs.target_def_t ->
	int ->
	bool * string

val build : string -> Uberspark.Defs.Basedefs.target_def_t -> int -> bool
val verify : string -> Uberspark.Defs.Basedefs.target_def_t -> int -> bool


val process_manifest_common : ?p_in_order:bool -> string -> string list -> bool
val process_manifest : ?p_in_order:bool -> string -> string -> string list -> bool
