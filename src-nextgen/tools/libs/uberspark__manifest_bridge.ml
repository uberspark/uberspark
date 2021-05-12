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
	let retval = ref true in

	try
		let open Yojson.Basic.Util in

			if (Yojson.Basic.Util.member "uberspark.bridge.namespace" mf_json) <> `Null then
				json_node_bridge_hdr_var.namespace <-	Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uberspark.bridge.namespace" mf_json);

			if (Yojson.Basic.Util.member "uberspark.bridge.category" mf_json) <> `Null then
				json_node_bridge_hdr_var.category <-	Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uberspark.bridge.category" mf_json);

			if (Yojson.Basic.Util.member "uberspark.bridge.containter_build_filename" mf_json) <> `Null then
				json_node_bridge_hdr_var.container_build_filename <-	Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uberspark.bridge.container_build_filename" mf_json);

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


(*--------------------------------------------------------------------------*)
(* convert json node "uberspark.bridge.xxx" into json_node_bridge_t variable *)
(* return: *)
(* on suasess: true; json_node_bridge_var fields are modified with parsed values *)
(* on failure: false; json_node_bridge_var fields are untouched *)
(*--------------------------------------------------------------------------*)

let json_node_uberspark_bridge_to_var
	(mf_json : Yojson.Basic.t)
	(json_node_uberspark_bridge_var : json_node_uberspark_bridge_t) 
	: bool =
	let retval = ref false in

	try
		let open Yojson.Basic.Util in
			let rval = json_node_bridge_hdr_to_var mf_json json_node_uberspark_bridge_var in

				if rval then begin
					if (Yojson.Basic.Util.member "uberspark.bridge.bridge_cmd" mf_json) <> `Null then
						json_node_uberspark_bridge_var.bridge_cmd <- json_list_to_string_list ( Yojson.Basic.Util.to_list (Yojson.Basic.Util.member "uberspark.bridge.bridge_cmd" mf_json));

					retval := true;
				end;

	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;


	(!retval)
;;


(* 	retstr := !retstr ^ Printf.sprintf  "\n\t\t\" \" : \"%s\"," json_node_uberspark_bridge_as_var.; *)

(*--------------------------------------------------------------------------*)
(* convert json_node_uberspark_bridge_var to json string *)
(*--------------------------------------------------------------------------*)
let json_node_uberspark_bridge_var_to_jsonstr  
	(json_node_uberspark_bridge_var : json_node_uberspark_bridge_t) 
	: string =
	let retstr = ref "" in

	retstr := !retstr ^ Printf.sprintf  "\n";
	retstr := !retstr ^ (json_node_bridge_hdr_var_to_jsonstr json_node_uberspark_bridge_var) ;
	retstr := !retstr ^ Printf.sprintf  "\n";

	(!retstr)
;;


(* 
	copy constructor for uberspark.bridge.xxx nodes
	we use this to copy one json_node_uberspark_bridge_t 
	variable into another 
*)
let json_node_uberspark_bridge_var_copy 
	(output : json_node_uberspark_bridge_t )
	(input : json_node_uberspark_bridge_t )
	: unit = 

	output.namespace <- input.namespace; 
	output.category <- input.category; 
	output.container_build_filename <- input.container_build_filename ; 
	output.bridge_cmd <- input.bridge_cmd; 

	()
;;


(* default json_node_uberspark_bridge_t variable definition *)
(* we use this to initialize variables of type json_node_uberspark_bridge_t *)
let json_node_uberspark_bridge_var_default_value () 
	: json_node_uberspark_bridge_t = 

	{
		namespace = "";
		category = "";
		container_build_filename = "";
		bridge_cmd = [];
	}
;;




