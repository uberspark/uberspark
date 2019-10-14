(*
	uberSpark bridge module interface
	author: amit vasudevan (amitvasudevan@acm.org)
*)

type bridge_hdr_t = {
	mutable btype : string;
	mutable execname: string;
	mutable path: string;
	mutable params: string list;
	mutable container_fname: string;
	mutable devenv: string;
	mutable arch: string;
	mutable cpu: string;
	mutable version: string;
	mutable namespace: string;
}

type cc_bridge_t = { 
	mutable hdr : bridge_hdr_t;
	mutable params_prefix_to_obj: string;
	mutable params_prefix_to_asm: string;
	mutable params_prefix_to_output: string;
}

val load_from_file : string -> bool

val store_settings_to_namespace: string list -> unit

val dump : string -> string -> unit
