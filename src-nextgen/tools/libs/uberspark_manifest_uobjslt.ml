(*===========================================================================*)
(*===========================================================================*)
(* uberSpark uobjslt manifest interface implementation *)
(*	 author: amit vasudevan (amitvasudevan@acm.org) *)
(*===========================================================================*)
(*===========================================================================*)


(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* type definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)


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
};;


(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* interface definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)


(*--------------------------------------------------------------------------*)
(* convert json node "uberspark-uobjslt" into json_node_uberspark_uobjslt_t variable *)
(* return: *)
(* on success: true; json_node_uberspark_uobjslt fields are modified with parsed values *)
(* on failure: false; json_node_uberspark_uobjslt fields are untouched *)
(*--------------------------------------------------------------------------*)

let json_node_uberspark_uobjslt_to_var 
	(mf_json : Yojson.Basic.t)
	(json_node_uberspark_uobjslt_var : json_node_uberspark_uobjslt_t) 
	: bool =
	let retval = ref false in

	try
		let open Yojson.Basic.Util in
			let json_node_uberspark_uobjslt = mf_json |> member Uberspark_namespace.namespace_uobjslt_mf_node_type_tag in
		
			if(json_node_uberspark_uobjslt <> `Null) then
				begin

					json_node_uberspark_uobjslt_var.namespace <- json_node_uberspark_uobjslt |> member "namespace" |> to_string;
					json_node_uberspark_uobjslt_var.platform <- json_node_uberspark_uobjslt |> member "platform" |> to_string;
					json_node_uberspark_uobjslt_var.arch <- json_node_uberspark_uobjslt |> member "arch" |> to_string;
					json_node_uberspark_uobjslt_var.cpu <- json_node_uberspark_uobjslt |> member "cpu" |> to_string;
					json_node_uberspark_uobjslt_var.sizeof_addressing <- int_of_string (json_node_uberspark_uobjslt |> member "sizeof_addressing" |> to_string);
					json_node_uberspark_uobjslt_var.code_template_directxfer <- json_node_uberspark_uobjslt |> member "code_template_directxfer" |> to_string;
					json_node_uberspark_uobjslt_var.code_template_indirectxfer <- json_node_uberspark_uobjslt |> member "code_template_indirectxfer" |> to_string;
					json_node_uberspark_uobjslt_var.code_template_data_definition <- json_node_uberspark_uobjslt |> member "code_template_data_definition" |> to_string;

					retval := true;
				end
			;

	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval)
;;


