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

type json_node_uberspark_bridge_as_t = 
{
	mutable json_node_bridge_hdr_var : json_node_bridge_hdr_t;
	mutable params_prefix_obj : string;
	mutable params_prefix_output : string;
	mutable params_prefix_include : string;
}
;;


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
	(json_node_uberspark_bridge_as : Yojson.Basic.t)
	(json_node_uberspark_bridge_as_var : json_node_uberspark_bridge_as_t) 
	: bool =
	let retval = ref false in

	try
		let open Yojson.Basic.Util in
			if(json_node_uberspark_bridge_as <> `Null) then	begin
					let json_node_bridge_hdr = (Yojson.Basic.Util.member "bridge-hdr" json_node_uberspark_bridge_as) in
					let rval = json_node_bridge_hdr_to_var json_node_bridge_hdr json_node_uberspark_bridge_as_var.json_node_bridge_hdr_var in

					if rval then begin
						json_node_uberspark_bridge_as_var.params_prefix_obj <- Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "params_prefix_obj" json_node_uberspark_bridge_as);
						json_node_uberspark_bridge_as_var.params_prefix_output <- Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "params_prefix_output" json_node_uberspark_bridge_as);
						json_node_uberspark_bridge_as_var.params_prefix_include <- Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "params_prefix_include" json_node_uberspark_bridge_as);

						retval := true;
					end;
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
	(json_node_uberspark_bridge_as_var : json_node_uberspark_bridge_as_t) 
	: string =
	let retstr = ref "" in

	retstr := !retstr ^ Printf.sprintf  "\n";
	retstr := !retstr ^ Printf.sprintf  "\n\t\"uberspark-bridge-as\":{";

	retstr := !retstr ^ (json_node_bridge_hdr_var_to_jsonstr json_node_uberspark_bridge_as_var.json_node_bridge_hdr_var) ^ ",";
	retstr := !retstr ^ Printf.sprintf  "\n\t\t\"params_prefix_obj\" : \"%s\"," json_node_uberspark_bridge_as_var.params_prefix_obj;
	retstr := !retstr ^ Printf.sprintf  "\n\t\t\"params_prefix_output\" : \"%s\"," json_node_uberspark_bridge_as_var.params_prefix_output;
	retstr := !retstr ^ Printf.sprintf  "\n\t\t\"params_prefix_include\" : \"%s\"" json_node_uberspark_bridge_as_var.params_prefix_include;

	retstr := !retstr ^ Printf.sprintf  "\n\t}";
	retstr := !retstr ^ Printf.sprintf  "\n";

	(!retstr)
;;
