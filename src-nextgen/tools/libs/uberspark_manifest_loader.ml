(*===========================================================================*)
(*===========================================================================*)
(* uberSpark loader manifest interface implementation *)
(*	 author: amit vasudevan (amitvasudevan@acm.org) *)
(*===========================================================================*)
(*===========================================================================*)



(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* type definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)


type json_node_uberspark_loader_t =
{
	mutable namespace    : string;			
	mutable platform	   : string;
	mutable arch	       : string;
	mutable cpu		   : string;
	mutable bridge_namespace    : string;
	mutable bridge_cmd : string list;
};;



(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* interface definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)

(*--------------------------------------------------------------------------*)
(* parse manifest json sub-node "uberspark-loader" into var *)
(* return: *)
(* on success: true; var is modified with uberspark-loader json node definition *)
(* on failure: false; var is unmodified *)
(*--------------------------------------------------------------------------*)
let json_node_uberspark_loader_to_var 
	(mf_json : Yojson.Basic.t)
	(json_node_uberspark_loader_var : json_node_uberspark_loader_t)
	: bool =

	let retval = ref true in

	try
		let open Yojson.Basic.Util in
			if (mf_json |> member "uberspark.loader.namespace") != `Null then
				json_node_uberspark_loader_var.namespace <- mf_json |> member "uberspark.loader.namespace" |> to_string;
	
			if (mf_json |> member "uberspark.loader.platform") != `Null then
				json_node_uberspark_loader_var.platform <- mf_json |> member "uberspark.loader.platform" |> to_string;
	
			if (mf_json |> member "uberspark.loader.arch") != `Null then
				json_node_uberspark_loader_var.arch <- mf_json |> member "uberspark.loader.arch" |> to_string;
	
			if (mf_json |> member "uberspark.loader.cpu") != `Null then
				json_node_uberspark_loader_var.cpu <- mf_json |> member "uberspark.loader.cpu" |> to_string;
	
			if (mf_json |> member "uberspark.loader.bridge_namespace") != `Null then
				json_node_uberspark_loader_var.bridge_namespace <- mf_json |> member "uberspark.loader.bridge_namespace" |> to_string;
	
			if (mf_json |> member "uberspark.loader.bridge_cmd") != `Null then
				json_node_uberspark_loader_var.bridge_cmd <- (json_list_to_string_list (mf_json |> member "uberspark.loader.bridge_cmd" |> to_list));

			retval := true;

	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval)
;;

