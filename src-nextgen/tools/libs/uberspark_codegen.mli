(****************************************************************************)
(****************************************************************************)
(* uberSpark codegen interface *)
(* author: amit vasudevan (amitvasudevan@acm.org) *)
(****************************************************************************)
(****************************************************************************)


(****************************************************************************)
(* types *)
(****************************************************************************)



(****************************************************************************)
(* interfaces *)
(****************************************************************************)
val hashtbl_keys : (int, Defs.Basedefs.section_info_t) Hashtbl.t ->  int list


(****************************************************************************)
(* submodules *)
(****************************************************************************)


module Uobj : sig

  (****************************************************************************)
  (* types *)
  (****************************************************************************)


  (****************************************************************************)
  (* interfaces *)
  (****************************************************************************)
  val generate_src_binhdr : 
    string ->
    string ->
    int ->
    int ->
    ((string, Defs.Basedefs.section_info_t)  Hashtbl.t) ->
    unit

  val generate_src_publicmethods_info : string -> string -> ((string, Uberspark_manifest.Uobj.uobj_publicmethods_t)  Hashtbl.t) -> unit 
  val generate_src_intrauobjcoll_callees_info : string -> ((string, string list)  Hashtbl.t) -> unit
  val generate_src_interuobjcoll_callees_info : string -> ((string, string list)  Hashtbl.t) -> unit 
  val generate_src_legacy_callees_info : string -> string list -> unit 
  val generate_slt : string -> ?output_banner: string -> string list -> string -> string -> string -> string -> string -> bool
  val generate_linker_script : string -> int -> int -> ((int, Defs.Basedefs.section_info_t) Hashtbl.t) -> unit


end


