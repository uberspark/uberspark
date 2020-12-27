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
	let retval = ref false in

	try
		let open Yojson.Basic.Util in
					json_node_uberspark_sentinel_var.namespace <-  mf_json |> member "uberspark.sentinel.namespace" |> to_string;
					json_node_uberspark_sentinel_var.platform <-  mf_json |> member "uberspark.sentinel.platform" |> to_string;
					json_node_uberspark_sentinel_var.arch <- mf_json  |> member "uberspark.sentinel.arch" |> to_string;
					json_node_uberspark_sentinel_var.cpu <- mf_json  |> member "uberspark.sentinel.cpu" |> to_string;
					json_node_uberspark_sentinel_var.sizeof_code_template <- int_of_string (mf_json  |> member "uberspark.sentinel.sizeof_code_template" |> to_string);
					json_node_uberspark_sentinel_var.code_template <- mf_json  |> member "uberspark.sentinel.code_template" |> to_string;
					json_node_uberspark_sentinel_var.library_code_template <- mf_json  |> member "uberspark.sentinel.library_code_template" |> to_string;
					retval := true;

	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval)
;;





