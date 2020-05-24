(*===========================================================================*)
(*===========================================================================*)
(* uberSpark manifest interface specification *)
(*	 author: amit vasudevan (amitvasudevan@acm.org) *)
(*===========================================================================*)
(*===========================================================================*)


(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* type definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)

(* uberspark manifest json node type *)
type json_node_uberspark_manifest_t =
{
	mutable f_manifest_node_types : string list;
	mutable f_uberspark_min_version   : string;
	mutable f_uberspark_max_version   : string;
}



(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* interface definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)

val json_list_to_string_list : Yojson.Basic.t list -> string list
val json_node_pretty_print_to_string : Yojson.Basic.t -> string
val json_node_update : string -> Yojson.Basic.t -> Yojson.Basic.t -> bool * Yojson.Basic.t


val get_json_for_manifest : string -> bool * Yojson.Basic.json
val json_node_uberspark_manifest_to_var :  Yojson.Basic.t -> json_node_uberspark_manifest_t -> bool
val json_node_uberspark_manifest_var_to_jsonstr : json_node_uberspark_manifest_t -> string
val get_json_for_manifest_node_type :  string -> string -> bool * Yojson.Basic.json * Yojson.Basic.json


val write_prologue : ?prologue_str:string -> out_channel -> bool
val write_epilogue : ?epilogue_str:string -> out_channel -> bool
val write_to_file : string -> string list -> unit



(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* submodules *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)


module Bridge : sig

  (****************************************************************************)
  (* manifest node types *)
  (****************************************************************************)

  (* bridge-hdr json node type *)
  type json_node_bridge_hdr_t = {
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

  val json_node_bridge_hdr_to_var : Yojson.Basic.t -> json_node_bridge_hdr_t -> bool
  val json_node_bridge_hdr_var_to_jsonstr  : json_node_bridge_hdr_t -> string



  (****************************************************************************)
  (* submodules *)
  (****************************************************************************)
  module Cc : sig
    type json_node_uberspark_bridge_cc_t = 
    {
      mutable json_node_bridge_hdr_var : json_node_bridge_hdr_t;
      mutable params_prefix_obj: string;
      mutable params_prefix_asm: string;
      mutable params_prefix_output: string;
      mutable params_prefix_include: string;
    }

    val json_node_uberspark_bridge_cc_to_var : Yojson.Basic.t -> json_node_uberspark_bridge_cc_t -> bool
    val json_node_uberspark_bridge_cc_var_to_jsonstr : json_node_uberspark_bridge_cc_t -> string

  end

  module Ld : sig
    type json_node_uberspark_bridge_ld_t = 
    {
      mutable json_node_bridge_hdr_var : json_node_bridge_hdr_t;
      mutable params_prefix_lscript: string;
      mutable params_prefix_libdir: string;
      mutable params_prefix_lib: string;
      mutable params_prefix_output: string;
    }

    val json_node_uberspark_bridge_ld_to_var : Yojson.Basic.t -> json_node_uberspark_bridge_ld_t -> bool
    val json_node_uberspark_bridge_ld_var_to_jsonstr : json_node_uberspark_bridge_ld_t -> string

  end

  module As : sig
    type json_node_uberspark_bridge_as_t = 
    {
      mutable json_node_bridge_hdr_var : json_node_bridge_hdr_t;
      mutable params_prefix_obj : string;
      mutable params_prefix_output : string;
      mutable params_prefix_include : string;
    }

    val json_node_uberspark_bridge_as_to_var : Yojson.Basic.t -> json_node_uberspark_bridge_as_t -> bool
    val json_node_uberspark_bridge_as_var_to_jsonstr : json_node_uberspark_bridge_as_t -> string


  end

end


module Config : sig

  (****************************************************************************)
  (* manifest node types *)
  (****************************************************************************)

  type json_node_uberspark_config_t = 
  {
    (* uobj/uobjcoll binary related configuration settings *)	
    mutable binary_page_size : int;
    mutable binary_uobj_section_alignment : int;
    mutable binary_uobj_default_section_size : int;

    mutable uobj_binary_image_load_address : int;
    mutable uobj_binary_image_uniform_size : bool;
    mutable uobj_binary_image_size : int;
    mutable uobj_binary_image_alignment : int;

    (* uobjcoll related configuration settings *)
    mutable uobjcoll_binary_image_load_address : int;
    mutable uobjcoll_binary_image_hdr_section_alignment : int;
    mutable uobjcoll_binary_image_hdr_section_size : int;
    mutable uobjcoll_binary_image_section_alignment : int;

    (* bridge related configuration settings *)	
    mutable bridge_cc_bridge : string;
    mutable bridge_as_bridge : string;
    mutable bridge_ld_bridge : string;
  }

  val json_node_uberspark_config_to_var : Yojson.Basic.t -> json_node_uberspark_config_t -> bool
  val json_node_uberspark_config_var_to_jsonstr : json_node_uberspark_config_t -> string

end


module Sentinel : sig


  type json_node_uberspark_sentinel_t =
  {
    mutable f_namespace    : string;			
    mutable f_platform	   : string;
    mutable f_arch	       : string;
    mutable f_cpu		   : string;
    mutable f_sizeof_code  : int;
    mutable f_code		   : string;
    mutable f_libcode	   : string;
  };;


  val json_node_uberspark_sentinel_to_var : Yojson.Basic.t -> json_node_uberspark_sentinel_t -> bool

end


module Uobj : sig

  type json_node_uberspark_uobj_uobjrtl_t = 
  {
    mutable f_namespace: string;
  }

  type json_node_uberspark_uobj_sources_t = 
  {
    mutable f_h_files: string list;
    mutable f_c_files: string list;
    mutable f_casm_files: string list;
    mutable f_asm_files : string list;
  }

  type json_node_uberspark_uobj_publicmethods_t = 
  {
    mutable f_name: string;
    mutable f_retvaldecl : string;
    mutable f_paramdecl: string;
    mutable f_paramdwords : int;
    mutable f_addr : int;
  }

  type json_node_uberspark_uobj_t = 
  {
    mutable f_namespace: string;
    mutable f_platform : string;
    mutable f_arch: string;
    mutable f_cpu : string;
    mutable f_sources : json_node_uberspark_uobj_sources_t;
    mutable f_publicmethods :  (string * json_node_uberspark_uobj_publicmethods_t) list;
    mutable f_intrauobjcoll_callees : (string * string list) list;
    mutable f_interuobjcoll_callees : (string * string list) list;
    mutable f_legacy_callees : (string * string list) list;
    mutable f_sections : (string * Defs.Basedefs.section_info_t) list;
  	mutable f_uobjrtl : (string * json_node_uberspark_uobj_uobjrtl_t) list;
  }


  val json_node_uberspark_uobj_sources_to_var : Yojson.Basic.t -> json_node_uberspark_uobj_sources_t -> bool
  val json_node_uberspark_uobj_publicmethods_to_var :  Yojson.Basic.t ->  bool *  ((string * json_node_uberspark_uobj_publicmethods_t) list)
  val json_node_uberspark_uobj_intrauobjcoll_callees_to_var :  Yojson.Basic.t -> bool *  ((string * string list) list)
  val json_node_uberspark_uobj_interuobjcoll_callees_to_var :  Yojson.Basic.t -> bool *  ((string * string list) list)
  val json_node_uberspark_uobj_legacy_callees_to_var : Yojson.Basic.t -> bool *  ((string * string list) list)
  val json_node_uberspark_uobj_sections_to_var :  Yojson.Basic.t -> bool *  ((string * Defs.Basedefs.section_info_t) list)
  val json_node_uberspark_uobj_uobjrtl_to_var : Yojson.Basic.t -> bool *  ((string * json_node_uberspark_uobj_uobjrtl_t) list)
  val json_node_uberspark_uobj_to_var : Yojson.Basic.t -> json_node_uberspark_uobj_t -> bool


end


module Uobjcoll : sig

  type json_node_uberspark_uobjcoll_uobjs_t =
  {
    mutable f_master    : string;
    mutable f_templars  : string list;
  }

  type json_node_uberspark_uobjcoll_publicmethods_t =
  {
    mutable f_uobj_ns    : string;
    mutable f_pm_name	 : string;
    mutable f_sentinel_type_list : string list;
  }

  type json_node_uberspark_uobjcoll_t =
  {
    mutable f_namespace    : string;			
    mutable f_platform	   : string;
    mutable f_arch	       : string;
    mutable f_cpu		   : string;
    mutable f_hpl		   : string;
    mutable f_sentinels_intrauobjcoll : string list;
    mutable f_uobjs 		: json_node_uberspark_uobjcoll_uobjs_t;
    mutable f_publicmethods : (string * json_node_uberspark_uobjcoll_publicmethods_t) list;
  }

  val json_node_uberspark_uobjcoll_uobjs_to_var : Yojson.Basic.t -> json_node_uberspark_uobjcoll_uobjs_t -> bool
  val json_node_uberspark_uobjcoll_publicmethods_to_var : Yojson.Basic.t -> bool * ((string * json_node_uberspark_uobjcoll_publicmethods_t) list)
  val json_node_uberspark_uobjcoll_to_var : Yojson.Basic.t -> json_node_uberspark_uobjcoll_t -> bool

 
end


module Uobjslt : sig

  type json_node_uberspark_uobjslt_t =
  {
    mutable f_namespace : string;
    mutable f_platform : string;
    mutable f_arch : string;
    mutable f_cpu : string;
    mutable f_addr_size : int;
    mutable f_code_directxfer : string;
    mutable f_code_indirectxfer : string;
    mutable f_code_addrdef : string;
  }

  val json_node_uberspark_uobjslt_to_var : Yojson.Basic.t -> json_node_uberspark_uobjslt_t -> bool


end


module Uobjrtl : sig

type json_node_uberspark_uobjrtl_modules_spec_module_funcdecls_t =
{
	mutable f_funcname : string;
}


type json_node_uberspark_uobjrtl_modules_spec_t =
{
	mutable f_module_path : string;
	mutable f_module_funcdecls : json_node_uberspark_uobjrtl_modules_spec_module_funcdecls_t list;
}


type json_node_uberspark_uobjrtl_t =
{
	mutable f_namespace : string;
	mutable f_platform : string;
	mutable f_arch : string;
    mutable f_cpu : string;
   
    mutable f_modules_spec: json_node_uberspark_uobjrtl_modules_spec_t list;
}

  val json_node_uberspark_uobjrtl_to_var : Yojson.Basic.t -> json_node_uberspark_uobjrtl_t -> bool


end

