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
  type slt_codegen_info_t =
  {
    mutable f_canonical_pm_name     : string;
    mutable f_pm_sentinel_addr : int;		
    mutable f_codegen_type : string; (* direct or indirect *)	
    mutable f_pm_sentinel_addr_loc : int;
  }


  (****************************************************************************)
  (* interfaces *)
  (****************************************************************************)
  val generate_src_binhdr : 
    string ->
    string ->
    int ->
    int ->
    (string * Defs.Basedefs.section_info_t) list ->
    unit

  val generate_src_publicmethods_info : string -> string -> ((string, Uberspark_manifest.Uobj.json_node_uberspark_uobj_publicmethods_t)  Hashtbl.t) -> unit 
  val generate_src_intrauobjcoll_callees_info : string -> ((string, string list)  Hashtbl.t) -> unit
  val generate_src_interuobjcoll_callees_info : string -> ((string, string list)  Hashtbl.t) -> unit 
  val generate_src_legacy_callees_info : string -> (string, string list) Hashtbl.t -> unit 
  
  val generate_slt	: string ->
    ?output_banner: string ->	
    string ->
	  string ->
	  string ->
    slt_codegen_info_t list ->
    string ->
    (string * Defs.Basedefs.slt_indirect_xfer_table_info_t) list ->
    string ->
   bool

  val generate_linker_script : string -> int -> int -> (string * Defs.Basedefs.section_info_t) list -> unit
  val generate_top_level_include_header : string -> ((string, Uberspark_manifest.Uobj.json_node_uberspark_uobj_publicmethods_t)  Hashtbl.t) ->  unit
  

end




module Uobjcoll : sig

  (****************************************************************************)
  (* types *)
  (****************************************************************************)
type sentinel_info_t =
{
	mutable f_type          : string; 	
    mutable f_name          : string;
    mutable f_secname       : string;
	mutable f_code		    : string;
	mutable f_libcode  	    : string;	
	mutable f_sizeof_code   : int;	
	mutable f_addr          : int;
    mutable f_pm_addr       : int;
}



  (****************************************************************************)
  (* interfaces *)
  (****************************************************************************)
  val generate_sentinel_code : string ->
      ?output_banner : string ->
      sentinel_info_t list -> bool
  
  val generate_uobj_binary_image_section_mapping : string ->
    ?output_banner : string ->
    Defs.Basedefs.uobjinfo_t list -> bool

val generate_linker_script : string -> int -> int -> (string * Defs.Basedefs.section_info_t) list -> bool

end

