(*
	uberSpark bridge module interface
	author: amit vasudevan (amitvasudevan@acm.org)
*)

(*
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


val cc_bridge_settings_loaded : bool ref
*)

val bridge_cc : Uberspark_manifest.Bridge.bridge_cc_t 

module Container : sig

val build_image : string -> string -> int

val list_images : string -> unit 

end

module Native : sig


end

val load_bridge_cc_from_file : string -> bool

val load_bridge_cc : string -> bool

val store_bridge_cc_to_file : string -> bool

val store_bridge_cc : unit -> bool

val build_bridge_cc : unit -> bool

val build: string list -> unit

val dump : string -> ?bridge_exectype:string -> string -> unit

val remove : string -> unit
