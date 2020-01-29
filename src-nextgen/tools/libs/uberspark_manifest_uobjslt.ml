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
	mutable f_namespace : string;
	mutable f_platform : string;
	mutable f_arch : string;
    mutable f_cpu : string;
    mutable f_addr_size : int;
	mutable f_code_directxfer : string;
    mutable f_code_indirectxfer : string;
    mutable f_code_addrdef : string;
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
	(json_node_uberspark_uobjslt : Yojson.Basic.t)
	(json_node_uberspark_uobjslt_var : json_node_uberspark_uobjslt_t) 
	: bool =
	let retval = ref false in

	try
		let open Yojson.Basic.Util in
			if(json_node_uberspark_uobjslt <> `Null) then
				begin

					json_node_uberspark_uobjslt_var.f_namespace <- json_node_uberspark_uobjslt |> member "namespace" |> to_string;
					json_node_uberspark_uobjslt_var.f_platform <- json_node_uberspark_uobjslt |> member "platform" |> to_string;
					json_node_uberspark_uobjslt_var.f_arch <- json_node_uberspark_uobjslt |> member "arch" |> to_string;
					json_node_uberspark_uobjslt_var.f_cpu <- json_node_uberspark_uobjslt |> member "cpu" |> to_string;
					json_node_uberspark_uobjslt_var.f_addr_size <- int_of_string (json_node_uberspark_uobjslt |> member "addr-size" |> to_string);
					json_node_uberspark_uobjslt_var.f_code_directxfer <- json_node_uberspark_uobjslt |> member "code-directxfer" |> to_string;
					json_node_uberspark_uobjslt_var.f_code_indirectxfer <- json_node_uberspark_uobjslt |> member "code-indirectxfer" |> to_string;
					json_node_uberspark_uobjslt_var.f_code_addrdef <- json_node_uberspark_uobjslt |> member "code-addrdef" |> to_string;

					retval := true;
				end
			;

	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval)
;;


