(*
	uberSpark bridge module interface
	author: amit vasudevan (amitvasudevan@acm.org)
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

val dump : string -> ?bridge_exectype:string -> string -> unit

val remove : string -> unit
