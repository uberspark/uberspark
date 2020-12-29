(*===========================================================================*)
(*===========================================================================*)
(* uberSpark bridge cc manifest interface implementation *)
(*	 author: amit vasudevan (amitvasudevan@acm.org) *)
(*===========================================================================*)
(*===========================================================================*)


(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* type definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)

type json_node_uberspark_bridge_cc_t = 
{
	mutable json_node_bridge_hdr_var : json_node_bridge_hdr_t;
	mutable bridge_cmd : string list;
}
;;


(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* interface definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)


(*--------------------------------------------------------------------------*)
(* convert json node "uberspark-bridge-cc" into json_node_bridge_cc_t variable *)
(* return: *)
(* on success: true; json_node_bridge_cc_var fields are modified with parsed values *)
(* on failure: false; json_node_bridge_cc_var fields are untouched *)
(*--------------------------------------------------------------------------*)

let json_node_uberspark_bridge_cc_to_var
	(mf_json : Yojson.Basic.t)
	(json_node_uberspark_bridge_cc_var : json_node_uberspark_bridge_cc_t) 
	: bool =
	let retval = ref false in

	try
		let open Yojson.Basic.Util in
			let json_node_uberspark_bridge_cc = mf_json |> member Uberspark_namespace.namespace_bridge_cc_mf_node_type_tag  in

			if(json_node_uberspark_bridge_cc <> `Null) then	begin
					let json_node_bridge_hdr = (Yojson.Basic.Util.member "bridge-hdr" json_node_uberspark_bridge_cc) in
					let rval = json_node_bridge_hdr_to_var json_node_bridge_hdr json_node_uberspark_bridge_cc_var.json_node_bridge_hdr_var in

					if rval then begin
						json_node_uberspark_bridge_cc_var.bridge_cmd <- json_list_to_string_list ( Yojson.Basic.Util.to_list (Yojson.Basic.Util.member "bridge_cmd" json_node_uberspark_bridge_cc));


						retval := true;
					end;
			end;

	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;


	(!retval)
;;


(* 	retstr := !retstr ^ Printf.sprintf  "\n\t\t\" \" : \"%s\"," json_node_uberspark_bridge_cc_var.; *)

(*--------------------------------------------------------------------------*)
(* convert json_node_uberspark_bridge_cc_var to json string *)
(*--------------------------------------------------------------------------*)
let json_node_uberspark_bridge_cc_var_to_jsonstr  
	(json_node_uberspark_bridge_cc_var : json_node_uberspark_bridge_cc_t) 
	: string =
	let retstr = ref "" in

	retstr := !retstr ^ Printf.sprintf  "\n";
	retstr := !retstr ^ Printf.sprintf  "\n\t\"uberspark-bridge-cc\":{";

	retstr := !retstr ^ (json_node_bridge_hdr_var_to_jsonstr json_node_uberspark_bridge_cc_var.json_node_bridge_hdr_var) ;

	retstr := !retstr ^ Printf.sprintf  "\n\t}";
	retstr := !retstr ^ Printf.sprintf  "\n";

	(!retstr)
;;
