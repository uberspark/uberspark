(*===========================================================================*)
(*===========================================================================*)
(* uberSpark bridge manifest common interface implementation *)
(*	 author: amit vasudevan (amitvasudevan@acm.org) *)
(*===========================================================================*)
(*===========================================================================*)



(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* type definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)

(* TBD
	category
	container_build_filename
	namespace

*)

(* bridge-hdr json node type *)
type json_node_uberspark_bridge_t = {
	mutable namespace: string;
	mutable category : string;
	mutable container_build_filename: string;
	mutable bridge_cmd : string list;
}
;;

(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* interface definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)


(*--------------------------------------------------------------------------*)
(* convert json node "bridge-hdr" into json_node_bridge_hdr_t variable *)
(* return: *)
(* on success: true; json_node_bridge_hdr_var fields are modified with parsed values *)
(* on failure: false; json_node_bridge_hdr_var fields are untouched *)
(*--------------------------------------------------------------------------*)

let json_node_bridge_hdr_to_var
	(mf_json : Yojson.Basic.t)
	(json_node_bridge_hdr_var : json_node_uberspark_bridge_t) 
	: bool =
	let retval = ref false in

	try
		let open Yojson.Basic.Util in
			json_node_bridge_hdr_var.namespace <-	Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uberspark.bridge.namespace" mf_json);
			json_node_bridge_hdr_var.category <-	Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uberspark.bridge.category" mf_json);
			json_node_bridge_hdr_var.container_build_filename <-	Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uberspark.bridge.container_build_filename" mf_json);

			retval := true;

	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;


	(!retval)
;;



(* 	retstr := !retstr ^ Printf.sprintf  "\n\t\t\" \" : \"%s\"," json_node_uberspark_bridge_cc_var.; *)

(*--------------------------------------------------------------------------*)
(* convert json_node_bridge_hdr_var to json string *)
(*--------------------------------------------------------------------------*)
let json_node_bridge_hdr_var_to_jsonstr  
	(json_node_bridge_hdr_var : json_node_uberspark_bridge_t) 
	: string =
	let retstr = ref "" in

	retstr := !retstr ^ Printf.sprintf  "\n";
 	retstr := !retstr ^ Printf.sprintf  "\n\t\"uberspark.bridge.namespace\" : \"%s\"," json_node_bridge_hdr_var.namespace; 
 	retstr := !retstr ^ Printf.sprintf  "\n\t\"uberspark.bridge.category\" : \"%s\"," json_node_bridge_hdr_var.category; 
 	retstr := !retstr ^ Printf.sprintf  "\n\t\"uberspark.bridge.container_build_filename\" : \"%s\"," json_node_bridge_hdr_var.container_build_filename; 
	retstr := !retstr ^ Printf.sprintf  "\n";

	(!retstr)
;;







