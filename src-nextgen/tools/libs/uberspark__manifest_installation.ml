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
	let retval = ref false in

	try
		let open Yojson.Basic.Util in
			let json_node_uberspark_installation = mf_json |> member Uberspark.Namespace.namespace_installation_mf_node_type_tag in
		
			if(json_node_uberspark_installation <> `Null) then
				begin

					json_node_uberspark_installation_var.root_directory <- json_node_uberspark_installation |> member "root_directory" |> to_string;
					retval := true;
				end
			;

	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval)
;;


