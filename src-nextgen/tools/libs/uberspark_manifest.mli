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


  (****************************************************************************)
  (* manifest parse interfaces *)
  (****************************************************************************)
  val parse_bridge_hdr : Yojson.Basic.t -> bridge_hdr_t -> bool
  val parse_bridge_cc : Yojson.Basic.t -> bridge_cc_t -> bool


  (****************************************************************************)
  (* manifest write interfaces *)
  (****************************************************************************)
  val write_bridge_hdr : ?continuation:bool -> out_channel -> bridge_hdr_t -> bool
  val write_bridge_cc : ?continuation:bool -> out_channel -> bridge_cc_t -> bool

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
    mutable binary_uobj_default_load_addr : int;
    mutable binary_uobj_default_size : int;

    (* bridge related configuration settings *)	
    mutable bridge_cc_bridge : string;

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
  val parse_uobj_sources : Yojson.Basic.t -> string list ref -> string list ref -> string list ref -> bool
  val parse_uobj_publicmethods : Yojson.Basic.t -> ((string, uobj_publicmethods_t)  Hashtbl.t) ->  bool
  val parse_uobj_intrauobjcoll_callees  : Yojson.Basic.t -> ((string, string list)  Hashtbl.t) ->  bool
  val parse_uobj_interuobjcoll_callees  : Yojson.Basic.t -> ((string, string list)  Hashtbl.t) ->  bool
  val parse_uobj_sections : Yojson.Basic.t -> ((string, Defs.Basedefs.section_info_t)  Hashtbl.t)  ->  bool



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

