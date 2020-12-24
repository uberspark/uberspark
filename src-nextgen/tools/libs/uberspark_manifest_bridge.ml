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

(* bridge-hdr json node type *)
type json_node_bridge_hdr_t = {
	mutable category : string;
	mutable name : string;
	mutable executable_name: string;
	mutable dev_environment: string;
	mutable arch: string;
	mutable cpu: string;
	mutable version: string;
	mutable path: string;
	mutable parameters: string list;
	mutable container_filename: string;
	mutable namespace: string;
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
	(json_node_bridge_hdr : Yojson.Basic.t)
	(json_node_bridge_hdr_var : json_node_bridge_hdr_t) 
	: bool =
	let retval = ref false in

	try
		let open Yojson.Basic.Util in
			if(json_node_bridge_hdr <> `Null) then	begin
				json_node_bridge_hdr_var.category <-	Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "category" json_node_bridge_hdr);
				json_node_bridge_hdr_var.name <-	Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "name" json_node_bridge_hdr);
				json_node_bridge_hdr_var.executable_name <-	Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "executable_name" json_node_bridge_hdr);
				json_node_bridge_hdr_var.dev_environment <-	Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "dev_environment" json_node_bridge_hdr);
				json_node_bridge_hdr_var.arch <-	Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "arch" json_node_bridge_hdr);
				json_node_bridge_hdr_var.cpu <-	Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "cpu" json_node_bridge_hdr);
				json_node_bridge_hdr_var.version <-	Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "version" json_node_bridge_hdr);
				json_node_bridge_hdr_var.path <-	Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "path" json_node_bridge_hdr);
				json_node_bridge_hdr_var.parameters <-	json_list_to_string_list ( Yojson.Basic.Util.to_list (Yojson.Basic.Util.member "parameters" json_node_bridge_hdr));
				json_node_bridge_hdr_var.container_filename <-	Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "container_filename" json_node_bridge_hdr);
				json_node_bridge_hdr_var.namespace <-	json_node_bridge_hdr_var.category ^ "/" ^ json_node_bridge_hdr_var.dev_environment ^ "/" ^
										json_node_bridge_hdr_var.arch ^ "/" ^ json_node_bridge_hdr_var.cpu ^ "/" ^
										json_node_bridge_hdr_var.executable_name ^ "/" ^ json_node_bridge_hdr_var.version;

				retval := true;
			end;

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
	(json_node_bridge_hdr_var : json_node_bridge_hdr_t) 
	: string =
	let retstr = ref "" in

	retstr := !retstr ^ Printf.sprintf  "\n";
	retstr := !retstr ^ Printf.sprintf  "\n\t\"bridge-hdr\":{";

 	retstr := !retstr ^ Printf.sprintf  "\n\t\t\"category\" : \"%s\"," json_node_bridge_hdr_var.category; 
 	retstr := !retstr ^ Printf.sprintf  "\n\t\t\"name\" : \"%s\"," json_node_bridge_hdr_var.name; 
 	retstr := !retstr ^ Printf.sprintf  "\n\t\t\"executable_name\" : \"%s\"," json_node_bridge_hdr_var.executable_name; 
 	retstr := !retstr ^ Printf.sprintf  "\n\t\t\"dev_environment\" : \"%s\"," json_node_bridge_hdr_var.dev_environment; 
 	retstr := !retstr ^ Printf.sprintf  "\n\t\t\"arch\" : \"%s\"," json_node_bridge_hdr_var.arch; 
 	retstr := !retstr ^ Printf.sprintf  "\n\t\t\"cpu\" : \"%s\"," json_node_bridge_hdr_var.cpu; 
 	retstr := !retstr ^ Printf.sprintf  "\n\t\t\"version\" : \"%s\"," json_node_bridge_hdr_var.version; 
 	retstr := !retstr ^ Printf.sprintf  "\n\t\t\"path\" : \"%s\"," json_node_bridge_hdr_var.path; 
 	
	retstr := !retstr ^ Printf.sprintf  "\n\t\t\"parameters\" : [ ";
	for i = 0 to ((List.length json_node_bridge_hdr_var.parameters)-1) do
		if i == ((List.length json_node_bridge_hdr_var.parameters)-1) then begin
			retstr := !retstr ^ Printf.sprintf  "\"%s\"" (List.nth json_node_bridge_hdr_var.parameters i);
		end else begin
			retstr := !retstr ^ Printf.sprintf  "\"%s,\"" (List.nth json_node_bridge_hdr_var.parameters i);
		end;
	done;
	retstr := !retstr ^ Printf.sprintf  "],";


	retstr := !retstr ^ Printf.sprintf  "\n\t\t\"container_filename\" : \"%s\"," json_node_bridge_hdr_var.container_filename; 
	retstr := !retstr ^ Printf.sprintf  "\n\t\t\"namespace\" : \"%s\"" json_node_bridge_hdr_var.namespace; 


	retstr := !retstr ^ Printf.sprintf  "\n\t}";
	retstr := !retstr ^ Printf.sprintf  "\n";

	(!retstr)
;;







