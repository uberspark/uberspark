(*===========================================================================*)
(*===========================================================================*)
(* uberSpark bridge as manifest interface implementation *)
(*	 author: amit vasudevan (amitvasudevan@acm.org) *)
(*===========================================================================*)
(*===========================================================================*)


(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* type definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)



(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* interface definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)


(*--------------------------------------------------------------------------*)
(* convert json node "uberspark-bridge-as" into json_node_bridge_as_t variable *)
(* return: *)
(* on suasess: true; json_node_bridge_as_var fields are modified with parsed values *)
(* on failure: false; json_node_bridge_as_var fields are untouched *)
(*--------------------------------------------------------------------------*)

let json_node_uberspark_bridge_as_to_var
	(mf_json : Yojson.Basic.t)
	(json_node_uberspark_bridge_as_var : json_node_uberspark_bridge_t) 
	: bool =
	let retval = ref false in

	try
		let open Yojson.Basic.Util in
			let rval = json_node_bridge_hdr_to_var mf_json json_node_uberspark_bridge_as_var in

				if rval then begin
					json_node_uberspark_bridge_as_var.bridge_cmd <- json_list_to_string_list ( Yojson.Basic.Util.to_list (Yojson.Basic.Util.member "uberspark.bridge.bridge_cmd" mf_json));

					retval := true;
				end;

	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;


	(!retval)
;;


(* 	retstr := !retstr ^ Printf.sprintf  "\n\t\t\" \" : \"%s\"," json_node_uberspark_bridge_as_var.; *)

(*--------------------------------------------------------------------------*)
(* convert json_node_uberspark_bridge_as_var to json string *)
(*--------------------------------------------------------------------------*)
let json_node_uberspark_bridge_as_var_to_jsonstr  
	(json_node_uberspark_bridge_as_var : json_node_uberspark_bridge_t) 
	: string =
	let retstr = ref "" in

	retstr := !retstr ^ Printf.sprintf  "\n";
	retstr := !retstr ^ (json_node_bridge_hdr_var_to_jsonstr json_node_uberspark_bridge_as_var) ;
	retstr := !retstr ^ Printf.sprintf  "\n";

	(!retstr)
;;
