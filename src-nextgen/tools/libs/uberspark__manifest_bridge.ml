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

type json_node_uberspark_bridge_target_t =
{
	mutable input : string;
	mutable output : string;
	mutable cmd: string list;
};;


(* bridge-hdr json node type *)
type json_node_uberspark_bridge_t = {
	mutable namespace: string;
	mutable category : string;
	mutable container_build_filename: string;
	mutable bridge_cmd : string list;
	mutable targets : (string * json_node_uberspark_bridge_target_t) list;
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


(*--------------------------------------------------------------------------*)
(* parse manifest json node "uberspark.bridge.targets" into var *)
(* return: *)
(* on success: true; association list of type (string * json_node_uberspark_uobj_uobjrtl_t) *)
(* on failure: false; null list *)
(*--------------------------------------------------------------------------*)
let json_node_uberspark_bridge_targets_to_var
	(mf_json : Yojson.Basic.t)
	: bool *  ((string * json_node_uberspark_bridge_target_t) list)
=
		
	let retval = ref true in
	let bridge_targets_assoc_list : (string * json_node_uberspark_bridge_target_t) list ref = ref [] in 

	try
		let open Yojson.Basic.Util in
			let bridge_targets_json = mf_json |> member "uberspark.bridge.targets" in
				if bridge_targets_json != `Null then
					begin

						let bridge_targets_list = Yojson.Basic.Util.to_list bridge_targets_json in
							
							List.iter (fun x ->
								let f_target_element : json_node_uberspark_bridge_target_t = 
									{ input = ""; output = ""; cmd = []; } in
								
								f_target_element.input <- Yojson.Basic.Util.to_string (x |> member "input");
								f_target_element.output <- Yojson.Basic.Util.to_string (x |> member "output");
								f_target_element.cmd <- json_list_to_string_list ( Yojson.Basic.Util.to_list (Yojson.Basic.Util.member "cmd" x));
								
								let l_key = (f_target_element.input ^ "__" ^ f_target_element.output) in 
								bridge_targets_assoc_list := !bridge_targets_assoc_list @ [ (l_key, f_target_element) ];
													
								()
							) bridge_targets_list;

					end
				;
														
	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

							
	(!retval, !bridge_targets_assoc_list)
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
			let rval1 = json_node_bridge_hdr_to_var mf_json json_node_uberspark_bridge_var in
			let (rval2, json_node_uberspark_bridge_targets_var) = (json_node_uberspark_bridge_targets_to_var mf_json) in

			if rval2 then
				json_node_uberspark_bridge_var.targets <- json_node_uberspark_bridge_targets_var;

			if (Yojson.Basic.Util.member "uberspark.bridge.bridge_cmd" mf_json) <> `Null then
				json_node_uberspark_bridge_var.bridge_cmd <- json_list_to_string_list ( Yojson.Basic.Util.to_list (Yojson.Basic.Util.member "uberspark.bridge.bridge_cmd" mf_json));

			retval := true;

	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;


	(!retval)
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
	output.targets <- input.targets;

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
		targets = [];
	}
;;




