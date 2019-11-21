(****************************************************************************)
(****************************************************************************)
(* uberSpark manifest interface *)
(* author: amit vasudevan (amitvasudevan@acm.org) *)
(****************************************************************************)
(****************************************************************************)


(****************************************************************************)
(* manifest node types *)
(****************************************************************************)

(* uberspark generic manifest header *)
type hdr_t =
{
	mutable f_coss_version : string;			
	mutable f_mftype : string;
	mutable f_uberspark_min_version   : string;
  mutable f_uberspark_max_version : string;
}

val json_list_to_string_list : Yojson.Basic.t list -> string list
val json_node_pretty_print_to_string : Yojson.Basic.t -> string
val json_node_update : string -> Yojson.Basic.t -> Yojson.Basic.t -> bool * Yojson.Basic.t

(****************************************************************************)
(* manifest parse interfaces *)
(****************************************************************************)
val parse_uberspark_hdr : Yojson.Basic.t -> hdr_t -> bool
val get_manifest_json : ?check_header:bool -> string -> bool * Yojson.Basic.t


(****************************************************************************)
(* manifest write interfaces *)
(****************************************************************************)
val write_prologue : ?prologue_str:string -> out_channel -> bool
val write_uberspark_hdr : ?continuation:bool -> out_channel -> hdr_t -> bool
val write_epilogue : ?epilogue_str:string -> out_channel -> bool



(****************************************************************************)
(* submodules *)
(****************************************************************************)


module Bridge : sig

  (****************************************************************************)
  (* manifest node types *)
  (****************************************************************************)

  (* bridge-hdr node type *)
  type bridge_hdr_t = {
    mutable btype : string;
    mutable bname : string;
    mutable execname: string;
    mutable devenv: string;
    mutable arch: string;
    mutable cpu: string;
    mutable version: string;
    mutable path: string;
    mutable params: string list;
    mutable container_fname: string;
    mutable namespace: string;
  }

  (* bridge-cc node type *)
  type bridge_cc_t = { 
    mutable bridge_hdr : bridge_hdr_t;
    mutable params_prefix_obj: string;
    mutable params_prefix_asm: string;
    mutable params_prefix_output: string;
    mutable params_prefix_include: string;
  }

  (* bridge-as node type *)
  type bridge_as_t = { 
    mutable bridge_hdr : bridge_hdr_t;
    mutable params_prefix_obj: string;
    mutable params_prefix_output: string;
    mutable params_prefix_include: string;
  }

  (* bridge-ld node type *)
  type bridge_ld_t = { 
    mutable bridge_hdr : bridge_hdr_t;
    mutable params_prefix_lscript: string;
    mutable params_prefix_libdir: string;
    mutable params_prefix_lib: string;
    mutable params_prefix_output: string;
  }


  (****************************************************************************)
  (* manifest parse interfaces *)
  (****************************************************************************)
  val parse_bridge_hdr : Yojson.Basic.t -> bridge_hdr_t -> bool
  val parse_bridge_cc : Yojson.Basic.t -> bridge_cc_t -> bool
  val parse_bridge_as : Yojson.Basic.t -> bridge_as_t -> bool
  val parse_bridge_ld : Yojson.Basic.t -> bridge_ld_t -> bool


  (****************************************************************************)
  (* manifest write interfaces *)
  (****************************************************************************)
  val write_bridge_hdr : ?continuation:bool -> out_channel -> bridge_hdr_t -> bool
  val write_bridge_cc : ?continuation:bool -> out_channel -> bridge_cc_t -> bool
  val write_bridge_as : ?continuation:bool -> out_channel -> bridge_as_t -> bool
  val write_bridge_ld : ?continuation:bool -> out_channel -> bridge_ld_t -> bool

end



module Config : sig

  (****************************************************************************)
  (* manifest node types *)
  (****************************************************************************)

  (* config-hdr node type *)
  type config_hdr_t =
  {
      mutable name   : string;			
  }

  (* config-settings node type *)
  type config_settings_t = 
  {

    (* uobj/uobjcoll binary related configuration settings *)	
    mutable binary_page_size : int;
    mutable binary_uobj_section_alignment : int;
    mutable binary_uobj_default_section_size : int;
 
    mutable uobj_binary_image_load_address : int;
    mutable uobj_binary_image_uniform_size : bool;
    mutable uobj_binary_image_size : int;
    mutable uobj_binary_image_alignment : int;

    (* bridge related configuration settings *)	
    mutable bridge_cc_bridge : string;
    mutable bridge_as_bridge : string;
    mutable bridge_ld_bridge : string;

  }


  (****************************************************************************)
  (* manifest parse interfaces *)
  (****************************************************************************)
  val parse_config_hdr : Yojson.Basic.t -> config_hdr_t -> bool
  val parse_config_settings : Yojson.Basic.t -> config_settings_t -> bool


  (****************************************************************************)
  (* manifest write interfaces *)
  (****************************************************************************)
  val write_config_hdr : ?continuation:bool -> out_channel -> config_hdr_t -> bool
  val write_config_settings : ?continuation:bool -> out_channel -> config_settings_t -> bool


end


module Uobj : sig
 type uobj_mf_json_nodes_t =
  {
    mutable f_uberspark_hdr					: Yojson.Basic.t;			
    mutable f_uobj_hdr   					: Yojson.Basic.t;
    mutable f_uobj_sources       			: Yojson.Basic.t;
    mutable f_uobj_publicmethods		   	: Yojson.Basic.t;
    mutable f_uobj_intrauobjcoll_callees    : Yojson.Basic.t;
    mutable f_uobj_interuobjcoll_callees	: Yojson.Basic.t;
    mutable f_uobj_legacy_callees		   	: Yojson.Basic.t;
    mutable f_uobj_binary		   			: Yojson.Basic.t;
  }


 
  type uobj_hdr_t =
    {
      mutable f_namespace    : string;			
      mutable f_platform	   : string;
      mutable f_arch	       : string;
      mutable f_cpu				   : string;
    }

  type uobj_publicmethods_t = 
  {
    f_name: string;
    f_retvaldecl : string;
    f_paramdecl: string;
    f_paramdwords : int;
  }


  val parse_uobj_hdr : Yojson.Basic.t -> uobj_hdr_t -> bool
  val parse_uobj_sources : Yojson.Basic.t -> string list ref -> string list ref -> string list ref -> string list ref -> bool
  val parse_uobj_publicmethods : Yojson.Basic.t -> ((string, uobj_publicmethods_t)  Hashtbl.t) ->  bool
  val parse_uobj_intrauobjcoll_callees  : Yojson.Basic.t -> ((string, string list)  Hashtbl.t) ->  bool
  val parse_uobj_interuobjcoll_callees  : Yojson.Basic.t -> ((string, string list)  Hashtbl.t) ->  bool
  val parse_uobj_legacy_callees : Yojson.Basic.t -> (string, string list) Hashtbl.t -> bool
  val parse_uobj_sections: Yojson.Basic.t -> (string * Defs.Basedefs.section_info_t) list ref -> bool



end



module Uobjcoll : sig
  type uobjcoll_hdr_t =
    {
      mutable f_namespace    : string;			
      mutable f_platform	   : string;
      mutable f_arch	       : string;
      mutable f_cpu				   : string;
    }

  type uobjcoll_uobjs_t =
  {
    mutable f_prime_uobj_ns    : string;
    mutable f_templar_uobjs    : string list;
  }


  val parse_uobjcoll_hdr : Yojson.Basic.t -> uobjcoll_hdr_t -> bool
  val parse_uobjcoll_uobjs : Yojson.Basic.t -> uobjcoll_uobjs_t -> bool

end




module Uobjslt : sig
  type uobjslt_hdr_t =
    {
      mutable f_namespace    : string;			
      mutable f_platform	   : string;
      mutable f_arch	       : string;
      mutable f_cpu				   : string;
    }


  val parse_uobjslt_hdr : Yojson.Basic.t -> uobjslt_hdr_t -> bool
  val parse_uobjslt_trampolinecode : Yojson.Basic.t -> bool * string
  val parse_uobjslt_trampolinedata : Yojson.Basic.t -> bool * string
end

