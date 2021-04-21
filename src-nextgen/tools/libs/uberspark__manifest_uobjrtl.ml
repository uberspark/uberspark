(*===========================================================================*)
(*===========================================================================*)
(* uberSpark uobjrtl manifest interface implementation *)
(*	 author: amit vasudevan (amitvasudevan@acm.org) *)
(*===========================================================================*)
(*===========================================================================*)


(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* type definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)

type json_node_uberspark_uobjrtl_modules_spec_module_funcdecls_t =
{
	mutable fn_name : string;
};;


type json_node_uberspark_uobjrtl_modules_spec_t =
{
	mutable path : string;
	mutable fn_decls : json_node_uberspark_uobjrtl_modules_spec_module_funcdecls_t list;
};;


type json_node_uberspark_uobjrtl_t =
{
	mutable namespace : string;
	mutable platform : string;
	mutable arch : string;
    mutable cpu : string;
   
    mutable sources: json_node_uberspark_uobjrtl_modules_spec_t list;
};;


(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* interface definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)


(*--------------------------------------------------------------------------*)
(* convert json node "uberspark-uobjrtl" into json_node_uberspark_uobjrtl_t variable *)
(* return: *)
(* on success: true; json_node_uberspark_uobjrtl fields are modified with parsed values *)
(* on failure: false; json_node_uberspark_uobjrtl
 fields are untouched *)
(*--------------------------------------------------------------------------*)

let json_node_uberspark_uobjrtl_to_var 
	(mf_json : Yojson.Basic.t)
	(json_node_uberspark_uobjrtl_var : json_node_uberspark_uobjrtl_t) 
	: bool =
	let retval = ref true in

	try
		let open Yojson.Basic.Util in

					if (mf_json |> member "uberspark.uobjrtl.namespace") != `Null then
						json_node_uberspark_uobjrtl_var.namespace <- mf_json |> member "uberspark.uobjrtl.namespace" |> to_string;

					if (mf_json |> member "uberspark.uobjrtl.platform") != `Null then
						json_node_uberspark_uobjrtl_var.platform <- mf_json |> member "uberspark.uobjrtl.platform" |> to_string;
					
					if (mf_json |> member "uberspark.uobjrtl.arch") != `Null then
						json_node_uberspark_uobjrtl_var.arch <- mf_json |> member "uberspark.uobjrtl.arch" |> to_string;
					
					if (mf_json |> member "uberspark.uobjrtl.cpu") != `Null then
						json_node_uberspark_uobjrtl_var.cpu <- mf_json |> member "uberspark.uobjrtl.cpu" |> to_string;

					if (mf_json |> member "uberspark.uobjrtl.sources") <> `Null then
					begin
						let json_node_uberspark_uobjrtl_modules_spec_c_list =  mf_json |> member "uberspark.uobjrtl.sources" |> to_list in
						List.iter (fun x -> 
							let f_modules_spec_c_element : json_node_uberspark_uobjrtl_modules_spec_t = 
								{ path = ""; fn_decls = []; } in

							f_modules_spec_c_element.path <- x |> member "path" |> to_string;

				
							(* add to f)modules_spec list *)
							json_node_uberspark_uobjrtl_var.sources <- json_node_uberspark_uobjrtl_var.sources @ [ f_modules_spec_c_element ];
						) json_node_uberspark_uobjrtl_modules_spec_c_list;
					end;

	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval)
;;


