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
	mutable f_funcname : string;
};;


type json_node_uberspark_uobjrtl_modules_spec_t =
{
	mutable f_module_path : string;
	mutable f_module_funcdecls : json_node_uberspark_uobjrtl_modules_spec_module_funcdecls_t list;
};;


type json_node_uberspark_uobjrtl_t =
{
	mutable f_namespace : string;
	mutable f_platform : string;
	mutable f_arch : string;
    mutable f_cpu : string;
   
    mutable f_modules_spec_c: json_node_uberspark_uobjrtl_modules_spec_t list;
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
	let retval = ref false in

	try
		let open Yojson.Basic.Util in
			let json_node_uberspark_uobjrtl = mf_json |> member Uberspark_namespace.namespace_uobjrtl_mf_node_type_tag in
		
			if(json_node_uberspark_uobjrtl <> `Null) then
				begin

					json_node_uberspark_uobjrtl_var.f_namespace <- json_node_uberspark_uobjrtl |> member "namespace" |> to_string;
					json_node_uberspark_uobjrtl_var.f_platform <- json_node_uberspark_uobjrtl |> member "platform" |> to_string;
					json_node_uberspark_uobjrtl_var.f_arch <- json_node_uberspark_uobjrtl |> member "arch" |> to_string;
					json_node_uberspark_uobjrtl_var.f_cpu <- json_node_uberspark_uobjrtl |> member "cpu" |> to_string;

					let json_node_uberspark_uobjrtl_modules_spec_list =  json_node_uberspark_uobjrtl |> member "modules-spec-c" |> to_list in
					List.iter (fun x -> 
						let f_modules_spec_element : json_node_uberspark_uobjrtl_modules_spec_t = 
							{ f_module_path = ""; f_module_funcdecls = []; } in

						f_modules_spec_element.f_module_path <- x |> member "module-path" |> to_string;

			
						(* add to f)modules_spec list *)
						json_node_uberspark_uobjrtl_var.f_modules_spec_c <- json_node_uberspark_uobjrtl_var.f_modules_spec_c @ [ f_modules_spec_element ];
					) json_node_uberspark_uobjrtl_modules_spec_list;



					retval := true;
				end
			;

	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval)
;;


