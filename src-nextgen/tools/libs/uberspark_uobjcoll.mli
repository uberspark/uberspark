(*------------------------------------------------------------------------------
	uberSpark uberobject collection verification and build interface
	author: amit vasudevan (amitvasudevan@acm.org)
------------------------------------------------------------------------------*)

val parse_manifest : string -> bool
val install_create_ns : unit -> unit
val build : string -> Defs.Basedefs.target_def_t -> int -> bool
