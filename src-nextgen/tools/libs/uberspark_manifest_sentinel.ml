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
	mutable f_namespace    : string;			
	mutable f_platform	   : string;
	mutable f_arch	       : string;
	mutable f_cpu		   : string;
	mutable f_sizeof_code  : int;
	mutable f_code		   : string;
	mutable f_libcode	   : string;
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
			let json_node_uberspark_sentinel = mf_json |> member Uberspark_namespace.namespace_sentinel_mf_node_type_tag in
			if(json_node_uberspark_sentinel <> `Null) then
				begin
					json_node_uberspark_sentinel_var.f_namespace <- json_node_uberspark_sentinel |> member "namespace" |> to_string;
					json_node_uberspark_sentinel_var.f_platform <- json_node_uberspark_sentinel |> member "platform" |> to_string;
					json_node_uberspark_sentinel_var.f_arch <- json_node_uberspark_sentinel |> member "arch" |> to_string;
					json_node_uberspark_sentinel_var.f_cpu <- json_node_uberspark_sentinel |> member "cpu" |> to_string;
					json_node_uberspark_sentinel_var.f_sizeof_code <- int_of_string (json_node_uberspark_sentinel |> member "sizeof-code" |> to_string);
					json_node_uberspark_sentinel_var.f_code <- json_node_uberspark_sentinel |> member "code" |> to_string;
					json_node_uberspark_sentinel_var.f_libcode <- json_node_uberspark_sentinel |> member "libcode" |> to_string;
					retval := true;
				end
			;

	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval)
;;





