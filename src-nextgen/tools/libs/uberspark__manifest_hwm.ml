(*===========================================================================*)
(*===========================================================================*)
(* 
	uberSpark hardware model (hwm) manifest interface implementation 
	 author: amit vasudevan (amitvasudevan@acm.org) 
*)
(*===========================================================================*)
(*===========================================================================*)



(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* type definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)


type json_node_uberspark_hwm_cpu_modules_spec_module_funcdecls_t =
{
	mutable fn_name : string;
};;


type json_node_uberspark_hwm_cpu_modules_spec_t =
{
	mutable path : string;
	mutable fn_decls : json_node_uberspark_hwm_cpu_modules_spec_module_funcdecls_t list;
};;


type json_node_uberspark_hwm_cpu_t = 
{

	mutable arch : string;
	mutable addressing : string;
	mutable model : string;

	mutable sources: json_node_uberspark_hwm_cpu_modules_spec_t list;

};;

type json_node_uberspark_hwm_t = 
{
	mutable cpu : json_node_uberspark_hwm_cpu_t;
	
};;

(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* interface definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)



(*--------------------------------------------------------------------------*)
(* 
	parse uberspark.hwm.cpu.xxx json nodes and populate
	cpu field of provided hwm variable
	return: true on success, false if there was an issue with type errors 
	during parsing
*)
(*--------------------------------------------------------------------------*)
let json_node_uberspark_hwm_cpu_to_var 
	?(p_only_configurable = false)
	(mf_json : Yojson.Basic.t)
	(json_node_uberspark_hwm_var : json_node_uberspark_hwm_t) 
	: bool =
	
	let retval = ref true in

	try
		let open Yojson.Basic.Util in

		if (Yojson.Basic.Util.member "uberspark.hwm.cpu.arch" mf_json) <> `Null then
			json_node_uberspark_hwm_var.cpu.arch <- (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uberspark.hwm.cpu.arch" mf_json));

		if (Yojson.Basic.Util.member "uberspark.hwm.cpu.addressing" mf_json) <> `Null then
			json_node_uberspark_hwm_var.cpu.addressing <- (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uberspark.hwm.cpu.addressing" mf_json));

		if (Yojson.Basic.Util.member "uberspark.hwm.cpu.model" mf_json) <> `Null then
			json_node_uberspark_hwm_var.cpu.model <- (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uberspark.hwm.cpu.model" mf_json));

	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval)
;;


(*--------------------------------------------------------------------------*)
(* 
	parse uberspark.hwm.xxx json nodes and populate 
	json_node_uberspark_hwm_var if they are found
	return: true on success, false if there was an issue with type errors 
	during parsing
*)
(*--------------------------------------------------------------------------*)

let json_node_uberspark_hwm_to_var 
	?(p_only_configurable = false)
	(mf_json : Yojson.Basic.t)
	(json_node_uberspark_hwm_var : json_node_uberspark_hwm_t) 
	: bool =
	
	let retval = ref false in

	(* use not p_only_configurable for fields that cannot be overlayed *)

	try
		let open Yojson.Basic.Util in

		let (l_rval1) = (json_node_uberspark_hwm_cpu_to_var ~p_only_configurable:p_only_configurable
					mf_json json_node_uberspark_hwm_var) in


		retval := l_rval1;
	
	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval)
;;



(* 
	copy constructor for uberspark.hwm.xxx nodes
	we use this to copy one json_node_uberspark_hwm_t 
	variable into another 
*)
let json_node_uberspark_hwm_var_copy 
	(output : json_node_uberspark_hwm_t )
	(input : json_node_uberspark_hwm_t )
	: unit = 

	output.cpu.arch 								<- 	input.cpu.arch				;
	output.cpu.addressing 					<- 	input.cpu.addressing				;
	output.cpu.model  				<- 	input.cpu.model 			;
	output.cpu.sources  				<- 	input.cpu.sources 			;

	()
;;


(* default json_node_uberspark_hwm_t variable definition *)
(* we use this to initialize variables of type json_node_uberspark_hwm_t *)
let json_node_uberspark_hwm_var_default_value () 
	: json_node_uberspark_hwm_t = 

	{
		cpu = {
			arch = "";
			addressing = "";
			model = "";

			sources = [];
		};
	}
;;
