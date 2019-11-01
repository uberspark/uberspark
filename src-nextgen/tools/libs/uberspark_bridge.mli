(****************************************************************************)
(* uberSpark bridge module interface *)
(*	 author: amit vasudevan (amitvasudevan@acm.org) *)
(****************************************************************************)
(****************************************************************************)

(****************************************************************************)
(* general submodules *)
(****************************************************************************)

module Container : sig

val build_image : string -> string -> int
val list_images : string -> unit 

end

module Native : sig


end




(****************************************************************************)
(* general interfaces *)
(****************************************************************************)

val dump : string -> ?bridge_exectype:string -> string -> unit
val remove : string -> unit
val initialize_from_config : unit -> bool

(****************************************************************************)
(* bridge submodules *)
(****************************************************************************)

module Cc : sig

(*--------------------------------------------------------------------------*)
(* cc-bridge data variables *)
(*--------------------------------------------------------------------------*)
val uberspark_hdr: Uberspark_manifest.hdr_t
val bridge_cc : Uberspark_manifest.Bridge.bridge_cc_t 


(*--------------------------------------------------------------------------*)
(* cc-bridge interfaces *)
(*--------------------------------------------------------------------------*)
val load_from_json : Yojson.Basic.json ->  bool
val load_from_file : string -> bool
val load : string -> bool
val store_to_file : string -> bool
val store : unit -> bool
val build : unit -> bool
val invoke :  ?gen_obj:bool -> ?gen_asm:bool -> string list -> bool



end



