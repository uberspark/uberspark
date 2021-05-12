(*===========================================================================*)
(*===========================================================================*)
(* uberSpark sentinel manifest interface implementation *)
(*	 author: amit vasudevan (amitvasudevan@acm.org) *)
(*===========================================================================*)
(*===========================================================================*)


(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* type definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)


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


(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* interface definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)


(*--------------------------------------------------------------------------*)
(* convert json node "uberspark-sentinel" into json_node_uberspark_sentinel_t variable *)
(* return: *)
(* on success: true; json_node_uberspark_sentinel fields are modified with parsed values *)
(* on failure: false; json_node_uberspark_sentinel fields are untouched *)
(*--------------------------------------------------------------------------*)

let json_node_uberspark_sentinel_to_var 
	(mf_json : Yojson.Basic.t)
	(json_node_uberspark_sentinel_var : json_node_uberspark_sentinel_t) 
	: bool =
	let retval = ref true in

	try
		let open Yojson.Basic.Util in
					if (mf_json |> member "uberspark.sentinel.namespace") != `Null then
						json_node_uberspark_sentinel_var.namespace <-  mf_json |> member "uberspark.sentinel.namespace" |> to_string;

					if (mf_json |> member "uberspark.sentinel.platform") != `Null then
						json_node_uberspark_sentinel_var.platform <-  mf_json |> member "uberspark.sentinel.platform" |> to_string;
	
					if (mf_json |> member "uberspark.sentinel.arch") != `Null then
						json_node_uberspark_sentinel_var.arch <- mf_json  |> member "uberspark.sentinel.arch" |> to_string;
					
					if (mf_json |> member "uberspark.sentinel.cpu") != `Null then
						json_node_uberspark_sentinel_var.cpu <- mf_json  |> member "uberspark.sentinel.cpu" |> to_string;
	
					if (mf_json |> member "uberspark.sentinel.sizeof_code_template") != `Null then
						json_node_uberspark_sentinel_var.sizeof_code_template <- int_of_string (mf_json  |> member "uberspark.sentinel.sizeof_code_template" |> to_string);
	
					if (mf_json |> member "uberspark.sentinel.code_template") != `Null then
						json_node_uberspark_sentinel_var.code_template <- mf_json  |> member "uberspark.sentinel.code_template" |> to_string;
					
					if (mf_json |> member "uberspark.sentinel.library_code_template") != `Null then
						json_node_uberspark_sentinel_var.library_code_template <- mf_json  |> member "uberspark.sentinel.library_code_template" |> to_string;

	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval)
;;


(* 
	copy constructor for uberspark.sentinel.xxx nodes
	we use this to copy one json_node_uberspark_sentinel_t 
	variable into another 
*)
let json_node_uberspark_sentinel_var_copy 
	(output : json_node_uberspark_sentinel_t )
	(input : json_node_uberspark_sentinel_t )
	: unit = 

	output.namespace <- input.namespace; 
	output.platform <- input.platform; 
	output.arch <- input.arch; 
	output.cpu <- input.cpu; 
	output.sizeof_code_template <- input.sizeof_code_template; 
	output.code_template <- input.code_template; 
	output.library_code_template <- input.library_code_template;



	()
;;


(* default json_node_uberspark_sentinel_t variable definition *)
(* we use this to initialize variables of type json_node_uberspark_sentinel_t *)
let json_node_uberspark_sentinel_var_default_value () 
	: json_node_uberspark_sentinel_t = 

	{
		namespace = ""; platform = ""; arch = ""; cpu = ""; 
		sizeof_code_template = 0; code_template = ""; library_code_template = "";
	}
;;



