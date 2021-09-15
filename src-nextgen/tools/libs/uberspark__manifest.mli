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

type json_node_uberspark_manifest_actions_t = 
{
	mutable targets : string list;
	mutable name : string;
	mutable category : string;

	(* if category == translation *)
	mutable input : string;
	mutable output : string;
  mutable filter : bool;
	mutable bridge_namespace: string; 
	mutable bridge_cmd : string list; 
	
	(* if category == uobjaction *)
	mutable uobj_namespace : string; 

	(* if category == uobjrtl_action *)
	mutable uobjrtl_namespace : string; 

	(* if category == loader_action *)
	mutable loader_namespace : string; 

};;


(* uberspark manifest json node type *)
type json_node_uberspark_manifest_t =
{
	mutable namespace : string;
	mutable version_min   : string;
	mutable version_max   : string;
	mutable actions : json_node_uberspark_manifest_actions_t list;
};;



(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* interface definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)

val json_list_to_string_list : Yojson.Basic.t list -> string list
val json_node_pretty_print_to_string : Yojson.Basic.t -> string
val json_node_update : string -> Yojson.Basic.t -> Yojson.Basic.t -> bool * Yojson.Basic.t



(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* submodules *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)


module Bridge : sig

  (****************************************************************************)
  (* manifest node types *)
  (****************************************************************************)

  type json_node_uberspark_bridge_target_t =
  {
    mutable input : string;
    mutable output : string;
    mutable cmd: string list;
  };;

  (* bridge-hdr json node type *)
  type json_node_uberspark_bridge_t = {
    mutable namespace : string;
    mutable category : string;
    mutable container_build_filename: string;
    mutable bridge_cmd : string list;
    mutable targets: (string * json_node_uberspark_bridge_target_t) list;
  }

  val json_node_uberspark_bridge_to_var : Yojson.Basic.t -> json_node_uberspark_bridge_t -> bool
  val json_node_uberspark_bridge_var_copy : json_node_uberspark_bridge_t -> json_node_uberspark_bridge_t -> unit
  val json_node_uberspark_bridge_var_default_value : unit -> json_node_uberspark_bridge_t


end


module Platform : sig

  (****************************************************************************)
  (* manifest node types *)
  (****************************************************************************)

type json_node_uberspark_platform_cpu_t = 
{

	mutable arch : string;
	mutable addressing : string;
	mutable model : string;
}



type json_node_uberspark_platform_bridges_t = 
{
	mutable bridge_id : string;
	mutable bridge_namespace : string;

}


  type json_node_uberspark_platform_binary_t = 
  {
    (* uobj/uobjcoll binary related configuration settings *)	
    mutable page_size : int;
    mutable uobj_section_alignment : int;
    mutable uobj_default_section_size : int;

    mutable uobj_image_load_address : int;
    mutable uobj_image_uniform_size : bool;
    mutable uobj_image_size : int;
    mutable uobj_image_alignment : int;

    (* uobjcoll related configuration settings *)
    mutable uobjcoll_image_load_address : int;
    mutable uobjcoll_image_hdr_section_alignment : int;
    mutable uobjcoll_image_hdr_section_size : int;
    mutable uobjcoll_image_section_alignment : int;
    mutable uobjcoll_image_size : int;

  }

  type json_node_uberspark_platform_t = 
  {
    mutable binary : json_node_uberspark_platform_binary_t;
   	mutable bridges : (string * json_node_uberspark_platform_bridges_t) list; 
  	mutable cpu : json_node_uberspark_platform_cpu_t;
  }

  val json_node_uberspark_platform_to_var : ?p_only_configurable:bool -> Yojson.Basic.t -> json_node_uberspark_platform_t -> bool
  val json_node_uberspark_platform_var_copy : json_node_uberspark_platform_t -> json_node_uberspark_platform_t -> unit
  val json_node_uberspark_platform_var_default_value : unit -> json_node_uberspark_platform_t


end



module Installation : sig

  (****************************************************************************)
  (* manifest node types *)
  (****************************************************************************)

  type json_node_uberspark_installation_t =
  {
    mutable root_directory : string;
    mutable default_platform : string;
  }

  val json_node_uberspark_installation_to_var : Yojson.Basic.t -> json_node_uberspark_installation_t -> bool
  val json_node_uberspark_installation_var_copy : json_node_uberspark_installation_t -> json_node_uberspark_installation_t -> unit
  val json_node_uberspark_installation_var_default_value : unit -> json_node_uberspark_installation_t

end


module Sentinel : sig


  type json_node_uberspark_sentinel_t =
  {
    mutable namespace    : string;			
    mutable platform	   : string;
    mutable arch	       : string;
    mutable cpu		   : string;
    mutable sizeof_code_template  : int;
    mutable code_template		   : string;
    mutable library_code_template	   : string;
  };;


  val json_node_uberspark_sentinel_to_var : Yojson.Basic.t -> json_node_uberspark_sentinel_t -> bool
  val json_node_uberspark_sentinel_var_copy : json_node_uberspark_sentinel_t -> json_node_uberspark_sentinel_t -> unit
  val json_node_uberspark_sentinel_var_default_value : unit -> json_node_uberspark_sentinel_t

end

module Loader : sig

type json_node_uberspark_loader_t =
{
	mutable namespace    : string;			
	mutable platform	   : string;
	mutable arch	       : string;
	mutable cpu		   : string;
	mutable bridge_namespace    : string;
	mutable bridge_cmd : string list;
};;

  val json_node_uberspark_loader_to_var : Yojson.Basic.t -> json_node_uberspark_loader_t -> bool
  val json_node_uberspark_loader_var_copy : json_node_uberspark_loader_t -> json_node_uberspark_loader_t -> unit
  val json_node_uberspark_loader_var_default_value : unit -> json_node_uberspark_loader_t

end

module Uobj : sig

  type json_node_uberspark_uobj_uobjrtl_t = 
  {
    mutable namespace: string;
  }

  type json_node_uberspark_uobj_publicmethods_t = 
  {
    mutable fn_name: string;
    mutable fn_decl_return_value : string;
    mutable fn_decl_parameters: string;
    mutable fn_decl_parameter_size : int;
    mutable fn_address : int;
  }


  type json_node_uberspark_uobj_t = 
  {
    mutable namespace: string;
    mutable platform : string;
    mutable arch: string;
    mutable cpu : string;
    mutable sources : string list;
    mutable headers : string list;
    mutable public_methods :  (string * json_node_uberspark_uobj_publicmethods_t) list;
    mutable intra_uobjcoll_callees : (string * string list) list;
    mutable inter_uobjcoll_callees : (string * string list) list;
    mutable legacy_callees : (string * string list) list;
    mutable sections : (string * Uberspark.Defs.Basedefs.section_info_t) list;
  	mutable uobjrtl : (string * json_node_uberspark_uobj_uobjrtl_t) list;
  }

  val json_node_uberspark_uobj_to_var : Yojson.Basic.t -> json_node_uberspark_uobj_t -> bool
  val json_node_uberspark_uobj_var_copy : json_node_uberspark_uobj_t -> json_node_uberspark_uobj_t -> unit
  val json_node_uberspark_uobj_var_default_value : unit -> json_node_uberspark_uobj_t

end


module Uobjcoll : sig

  type json_node_uberspark_uobjcoll_uobjs_t =
  {
    mutable master    : string;
    mutable templars  : string list;
  }


  type json_node_uberspark_uobjcoll_initmethod_sentinels_t =
  {
    mutable sentinel_type    : string;
    mutable sentinel_size	 : int;
  }


  type json_node_uberspark_uobjcoll_initmethod_t =
  {
    mutable uobj_namespace    : string;
    mutable public_method	 : string;
    mutable sentinels : json_node_uberspark_uobjcoll_initmethod_sentinels_t list;
  }


  type json_node_uberspark_uobjcoll_publicmethods_t =
  {
    mutable uobj_namespace    : string;
    mutable public_method	 : string;
    mutable sentinel_type_list : string list;
  }

  type json_node_uberspark_uobjcoll_configdefs_t =
  {
    mutable name    : string;
    mutable value	 : string;
  }



  type json_node_uberspark_uobjcoll_t =
  {
    mutable namespace    : string;			
    mutable platform	   : string;
    mutable arch	       : string;
    mutable cpu		   : string;
    mutable hpl		   : string;
    mutable sentinels_intra_uobjcoll : string list;
    mutable uobjs 		: json_node_uberspark_uobjcoll_uobjs_t;
    mutable init_method : json_node_uberspark_uobjcoll_initmethod_t;
    mutable public_methods : (string * json_node_uberspark_uobjcoll_publicmethods_t) list;
    mutable loaders : string list;
    mutable configdefs_verbatim : bool;
    mutable configdefs : (string * json_node_uberspark_uobjcoll_configdefs_t) list;
   	mutable sources : string list; (* this is not part of the manifest, but populated in the backend *)
  }



  val json_node_uberspark_uobjcoll_to_var : Yojson.Basic.t -> json_node_uberspark_uobjcoll_t -> bool
  val json_node_uberspark_uobjcoll_var_copy : json_node_uberspark_uobjcoll_t -> json_node_uberspark_uobjcoll_t -> unit
  val json_node_uberspark_uobjcoll_var_default_value : unit -> json_node_uberspark_uobjcoll_t


 
end


module Uobjslt : sig

  type json_node_uberspark_uobjslt_t =
  {
    mutable namespace : string;
    mutable platform : string;
    mutable arch : string;
    mutable cpu : string;
    mutable sizeof_addressing : int;
    mutable code_template_directxfer : string;
    mutable code_template_indirectxfer : string;
    mutable code_template_data_definition : string;
  }

  val json_node_uberspark_uobjslt_to_var : Yojson.Basic.t -> json_node_uberspark_uobjslt_t -> bool
  val json_node_uberspark_uobjslt_var_copy : json_node_uberspark_uobjslt_t -> json_node_uberspark_uobjslt_t -> unit
  val json_node_uberspark_uobjslt_var_default_value : unit -> json_node_uberspark_uobjslt_t


end


module Uobjrtl : sig

type json_node_uberspark_uobjrtl_modules_spec_module_funcdecls_t =
{
	mutable fn_name : string;
}


type json_node_uberspark_uobjrtl_modules_spec_t =
{
	mutable path : string;
	mutable fn_decls : json_node_uberspark_uobjrtl_modules_spec_module_funcdecls_t list;
}


type json_node_uberspark_uobjrtl_t =
{
	mutable namespace : string;
	mutable platform : string;
	mutable arch : string;
    mutable cpu : string;
   
    mutable sources: json_node_uberspark_uobjrtl_modules_spec_t list;

}

  val json_node_uberspark_uobjrtl_to_var : Yojson.Basic.t -> json_node_uberspark_uobjrtl_t -> bool
  val json_node_uberspark_uobjrtl_var_copy : json_node_uberspark_uobjrtl_t -> json_node_uberspark_uobjrtl_t -> unit
  val json_node_uberspark_uobjrtl_var_default_value : unit -> json_node_uberspark_uobjrtl_t


end


module Hwm : sig

type json_node_uberspark_hwm_cpu_modules_spec_module_funcdecls_t =
{
	mutable fn_name : string;
}


type json_node_uberspark_hwm_cpu_modules_spec_t =
{
	mutable path : string;
	mutable fn_decls : json_node_uberspark_hwm_cpu_modules_spec_module_funcdecls_t list;
}


type json_node_uberspark_hwm_cpu_t = 
{

	mutable arch : string;
	mutable addressing : string;
	mutable model : string;

	mutable sources: json_node_uberspark_hwm_cpu_modules_spec_t list;

}

type json_node_uberspark_hwm_t = 
{
	mutable namespace : string;
  mutable cpu : json_node_uberspark_hwm_cpu_t;
	
}

  val json_node_uberspark_hwm_to_var : ?p_only_configurable:bool -> Yojson.Basic.t -> json_node_uberspark_hwm_t -> bool
  val json_node_uberspark_hwm_var_copy : json_node_uberspark_hwm_t -> json_node_uberspark_hwm_t -> unit
  val json_node_uberspark_hwm_var_default_value : unit -> json_node_uberspark_hwm_t


end



(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* type definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)

type uberspark_manifest_var_t =
{
	mutable manifest : json_node_uberspark_manifest_t;
	mutable uobjcoll : Uobjcoll.json_node_uberspark_uobjcoll_t;
  mutable uobj : Uobj.json_node_uberspark_uobj_t;
  mutable uobjrtl : Uobjrtl.json_node_uberspark_uobjrtl_t;
  mutable sentinel : Sentinel.json_node_uberspark_sentinel_t;
  mutable loader : Loader.json_node_uberspark_loader_t;
  mutable platform : Platform.json_node_uberspark_platform_t;
 	mutable bridge : Bridge.json_node_uberspark_bridge_t; 
 	mutable installation : Installation.json_node_uberspark_installation_t; 
 	mutable hwm : Hwm.json_node_uberspark_hwm_t; 
}



(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* interface definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)


val manifest_json_to_uberspark_manifest_var : ?p_only_configurable:bool -> Yojson.Basic.t -> uberspark_manifest_var_t -> bool
val manifest_file_to_uberspark_manifest_var : ?p_only_configurable:bool -> string -> uberspark_manifest_var_t -> bool * Yojson.Basic.t 
val uberspark_manifest_var_copy :  uberspark_manifest_var_t -> 
  uberspark_manifest_var_t ->
  unit
val uberspark_manifest_var_default_value : unit -> uberspark_manifest_var_t 

