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
	mutable btype : string;
	mutable bname : string;
	mutable execname: string;
	mutable devenv: string;
	mutable arch: string;
	mutable cpu: string;
	mutable version: string;
	mutable path: string;
	mutable params: string list;
	mutable container_fname: string;
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
				json_node_bridge_hdr_var.btype <-	Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "btype" json_node_bridge_hdr);
				json_node_bridge_hdr_var.bname <-	Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "bname" json_node_bridge_hdr);
				json_node_bridge_hdr_var.execname <-	Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "execname" json_node_bridge_hdr);
				json_node_bridge_hdr_var.devenv <-	Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "devenv" json_node_bridge_hdr);
				json_node_bridge_hdr_var.arch <-	Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "arch" json_node_bridge_hdr);
				json_node_bridge_hdr_var.cpu <-	Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "cpu" json_node_bridge_hdr);
				json_node_bridge_hdr_var.version <-	Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "version" json_node_bridge_hdr);
				json_node_bridge_hdr_var.path <-	Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "path" json_node_bridge_hdr);
				json_node_bridge_hdr_var.params <-	json_list_to_string_list ( Yojson.Basic.Util.to_list (Yojson.Basic.Util.member "params" json_node_bridge_hdr));
				json_node_bridge_hdr_var.container_fname <-	Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "container_fname" json_node_bridge_hdr);
				json_node_bridge_hdr_var.namespace <-	json_node_bridge_hdr_var.btype ^ "/" ^ json_node_bridge_hdr_var.devenv ^ "/" ^
										json_node_bridge_hdr_var.arch ^ "/" ^ json_node_bridge_hdr_var.cpu ^ "/" ^
										json_node_bridge_hdr_var.execname ^ "/" ^ json_node_bridge_hdr_var.version;

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

 	retstr := !retstr ^ Printf.sprintf  "\n\t\t\"btype\" : \"%s\"," json_node_bridge_hdr_var.btype; 
 	retstr := !retstr ^ Printf.sprintf  "\n\t\t\"bname\" : \"%s\"," json_node_bridge_hdr_var.bname; 
 	retstr := !retstr ^ Printf.sprintf  "\n\t\t\"execname\" : \"%s\"," json_node_bridge_hdr_var.execname; 
 	retstr := !retstr ^ Printf.sprintf  "\n\t\t\"devenv\" : \"%s\"," json_node_bridge_hdr_var.devenv; 
 	retstr := !retstr ^ Printf.sprintf  "\n\t\t\"arch\" : \"%s\"," json_node_bridge_hdr_var.arch; 
 	retstr := !retstr ^ Printf.sprintf  "\n\t\t\"cpu\" : \"%s\"," json_node_bridge_hdr_var.cpu; 
 	retstr := !retstr ^ Printf.sprintf  "\n\t\t\"version\" : \"%s\"," json_node_bridge_hdr_var.version; 
 	retstr := !retstr ^ Printf.sprintf  "\n\t\t\"path\" : \"%s\"," json_node_bridge_hdr_var.path; 
 	
	retstr := !retstr ^ Printf.sprintf  "\n\t\t\"params\" : [ ";
	for i = 0 to ((List.length json_node_bridge_hdr_var.params)-1) do
		if i == ((List.length json_node_bridge_hdr_var.params)-1) then begin
			retstr := !retstr ^ Printf.sprintf  "\"%s\"" (List.nth json_node_bridge_hdr_var.params i);
		end else begin
			retstr := !retstr ^ Printf.sprintf  "\"%s,\"" (List.nth json_node_bridge_hdr_var.params i);
		end;
	done;
	retstr := !retstr ^ Printf.sprintf  "],";


	retstr := !retstr ^ Printf.sprintf  "\n\t\t\"container_fname\" : \"%s\"," json_node_bridge_hdr_var.container_fname; 
	retstr := !retstr ^ Printf.sprintf  "\n\t\t\"namespace\" : \"%s\"" json_node_bridge_hdr_var.namespace; 


	retstr := !retstr ^ Printf.sprintf  "\n\t}";
	retstr := !retstr ^ Printf.sprintf  "\n";

	(!retstr)
;;







