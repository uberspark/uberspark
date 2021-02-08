(*===========================================================================*)
(*===========================================================================*)
(*	uberSpark bridge module interface specification		 *)
(*	author: amit vasudevan (amitvasudevan@acm.org)							 *)
(*===========================================================================*)
(*===========================================================================*)


(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* type definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)



(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* general submodules *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)

module Container : sig

	val build_image : string -> string -> int
	val list_images : string -> unit 
	val run_image : ?context_path_builddir:string -> string -> string -> string -> int
    
end

module Native : sig

	val run_shell_command : ?context_path_builddir:string -> string -> string -> string -> int

end


(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* interface definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)

val dump : string -> ?bridge_exectype:string -> string -> unit
val remove : string -> unit
val bridge_parameter_to_string :
	?separator:string -> 
	?prefix:string -> 
	string list ->
	string




(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* class definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)

class bridge_object :
object

	val json_node_uberspark_manifest_var: Uberspark_manifest.json_node_uberspark_manifest_t 
	val json_node_uberspark_bridge_var: Uberspark_manifest.Bridge.json_node_uberspark_bridge_t
	
	method get_json_node_uberspark_bridge_var : Uberspark_manifest.Bridge.json_node_uberspark_bridge_t
	method load_from_json : Yojson.Basic.json ->  bool
	method load_from_file : string -> bool
	method load : string -> bool
	method store_to_file : string -> bool
	method store : unit -> bool
	method build : unit -> bool
	method invoke :
	?context_path_builddir:string -> 
	(string * string) list ->
	bool

end



(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* bridge_object variables *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
val cc_bridge : bridge_object
val as_bridge : bridge_object
val ld_bridge : bridge_object
val casm_bridge : bridge_object
val vf_bridge : bridge_object
val loader_bridge : bridge_object




(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* interface definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)

val initialize_from_config : unit -> bool
