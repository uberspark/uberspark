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
	mutable f_namespace    : string;			
	mutable f_platform	   : string;
	mutable f_arch	       : string;
	mutable f_cpu		   : string;
	mutable f_bridge_ns    : string;
	mutable f_bridge_cmd : string list;
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
			let json_node_uberspark_loader = mf_json |> member "uberspark-loader" in
				if json_node_uberspark_loader != `Null then begin
					json_node_uberspark_loader_var.f_namespace <- json_node_uberspark_loader |> member "namespace" |> to_string;
					json_node_uberspark_loader_var.f_platform <- json_node_uberspark_loader |> member "platform" |> to_string;
					json_node_uberspark_loader_var.f_arch <- json_node_uberspark_loader |> member "arch" |> to_string;
					json_node_uberspark_loader_var.f_cpu <- json_node_uberspark_loader |> member "cpu" |> to_string;
					json_node_uberspark_loader_var.f_bridge_ns <- json_node_uberspark_loader |> member "bridge_ns" |> to_string;
					json_node_uberspark_loader_var.f_bridge_cmd <- (json_list_to_string_list (json_node_uberspark_loader |> member "bridge_cmd" |> to_list));

					retval := true;
				end;

	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval)
;;

