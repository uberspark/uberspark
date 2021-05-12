(*===========================================================================*)
(*===========================================================================*)
(* uberSpark installation manifest interface implementation *)
(*	 author: amit vasudevan (amitvasudevan@acm.org) *)
(*===========================================================================*)
(*===========================================================================*)


(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* type definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)


type json_node_uberspark_installation_t =
{
	mutable root_directory : string;
	mutable default_platform : string;
};;


(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* interface definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)


(*--------------------------------------------------------------------------*)
(* convert json node "uberspark-installation" into json_node_uberspark_installation_t variable *)
(* return: *)
(* on success: true; json_node_uberspark_installation fields are modified with parsed values *)
(* on failure: false; json_node_uberspark_installation fields are untouched *)
(*--------------------------------------------------------------------------*)

let json_node_uberspark_installation_to_var 
	(mf_json : Yojson.Basic.t)
	(json_node_uberspark_installation_var : json_node_uberspark_installation_t) 
	: bool =
	let retval = ref true in

	try
		let open Yojson.Basic.Util in
			if (mf_json |> member "uberspark.installation.root_directory") != `Null then
				json_node_uberspark_installation_var.root_directory <- mf_json |> member "uberspark.installation.root_directory" |> to_string;

			if (mf_json |> member "uberspark.installation.default_platform") != `Null then
				json_node_uberspark_installation_var.default_platform <- mf_json |> member "uberspark.installation.default_platform" |> to_string;

			retval := true;

	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval)
;;


(* 
	copy constructor for uberspark.platform.xxx nodes
	we use this to copy one json_node_uberspark_installation_t 
	variable into another 
*)
let json_node_uberspark_installation_var_copy 
	(output : json_node_uberspark_installation_t )
	(input : json_node_uberspark_installation_t )
	: unit = 

	output.root_directory <- input.root_directory; 
	output.default_platform <- input.default_platform; 

	()
;;


(* default json_node_uberspark_installation_t variable definition *)
(* we use this to initialize variables of type json_node_uberspark_installation_t *)
let json_node_uberspark_installation_var_default_value () 
	: json_node_uberspark_installation_t = 

	{
		root_directory = "";
		default_platform = "";
	}
;;

