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


(* bridge-hdr node type *)
type bridge_hdr_t = {
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

(*(* bridge-cc node type *)
type bridge_cc_t = { 
	mutable bridge_hdr : bridge_hdr_t;
	mutable params_prefix_obj: string;
	mutable params_prefix_asm: string;
	mutable params_prefix_output: string;
	mutable params_prefix_include: string;
};;
*)

(* bridge-as node type *)
type bridge_as_t = { 
	mutable bridge_hdr : bridge_hdr_t;
	mutable params_prefix_obj: string;
	mutable params_prefix_output: string;
	mutable params_prefix_include: string;
};;

(* bridge-ld node type *)
type bridge_ld_t = { 
	mutable bridge_hdr : bridge_hdr_t;
	mutable params_prefix_lscript: string;
	mutable params_prefix_libdir: string;
	mutable params_prefix_lib: string;
	mutable params_prefix_output: string;
};;


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




(*--------------------------------------------------------------------------*)
(* parse json node "bridge-hdr" *)
(* return: *)
(* on success: true; bridge_hdr fields are modified with parsed values *)
(* on failure: false; bridge_hdr fields are untouched *)
(*--------------------------------------------------------------------------*)
let parse_bridge_hdr 
	(mf_json : Yojson.Basic.t)
	(bridge_hdr : bridge_hdr_t) 
	: bool =

	let retval = ref false in

	try
		let open Yojson.Basic.Util in
			let json_bridge_hdr = mf_json |> member "bridge-hdr" in
			if(json_bridge_hdr <> `Null) then
				begin
					bridge_hdr.btype <-	Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "btype" json_bridge_hdr);
					bridge_hdr.bname <-	Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "bname" json_bridge_hdr);
					bridge_hdr.execname <-	Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "execname" json_bridge_hdr);
					bridge_hdr.devenv <-	Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "devenv" json_bridge_hdr);
					bridge_hdr.arch <-	Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "arch" json_bridge_hdr);
					bridge_hdr.cpu <-	Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "cpu" json_bridge_hdr);
					bridge_hdr.version <-	Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "version" json_bridge_hdr);
					bridge_hdr.path <-	Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "path" json_bridge_hdr);
					bridge_hdr.params <-	json_list_to_string_list ( Yojson.Basic.Util.to_list (Yojson.Basic.Util.member "params" json_bridge_hdr));
					bridge_hdr.container_fname <-	Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "container_fname" json_bridge_hdr);
					bridge_hdr.namespace <-	bridge_hdr.btype ^ "/" ^ bridge_hdr.devenv ^ "/" ^
											bridge_hdr.arch ^ "/" ^ bridge_hdr.cpu ^ "/" ^
											bridge_hdr.execname ^ "/" ^ bridge_hdr.version;

					retval := true;
				end
			;

	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval)
;;


(*
(*--------------------------------------------------------------------------*)
(* parse json node "bridge-cc" *)
(* return: *)
(* on success: true; bridge_cc fields are modified with parsed values *)
(* on failure: false; bridge_cc fields are untouched *)
(*--------------------------------------------------------------------------*)
let parse_bridge_cc 
	(mf_json : Yojson.Basic.t)
	(bridge_cc : bridge_cc_t) 
	: bool =

	let retval = ref false in

	try
		let open Yojson.Basic.Util in
			let json_bridge_cc = mf_json |> member "bridge-cc" in
			if(json_bridge_cc <> `Null) then
				begin
					
					retval := parse_bridge_hdr json_bridge_cc bridge_cc.bridge_hdr;

					if !retval then begin
						bridge_cc.params_prefix_obj <- Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "params_prefix_obj" json_bridge_cc);
						bridge_cc.params_prefix_asm <- Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "params_prefix_asm" json_bridge_cc);
						bridge_cc.params_prefix_output <- Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "params_prefix_output" json_bridge_cc);
						bridge_cc.params_prefix_include <- Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "params_prefix_include" json_bridge_cc);
						retval := true;
					end;
					
				end
			;

	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval)
;;
*)

(*--------------------------------------------------------------------------*)
(* parse json node "bridge-as" *)
(* return: *)
(* on success: true; bridge_as fields are modified with parsed values *)
(* on failure: false; bridge_as fields are untouched *)
(*--------------------------------------------------------------------------*)
let parse_bridge_as 
	(mf_json : Yojson.Basic.t)
	(bridge_as : bridge_as_t) 
	: bool =

	let retval = ref false in

	try
		let open Yojson.Basic.Util in
			let json_bridge_as = mf_json |> member "bridge-as" in
			if(json_bridge_as <> `Null) then
				begin
					
					retval := parse_bridge_hdr json_bridge_as bridge_as.bridge_hdr;

					if !retval then begin
						bridge_as.params_prefix_obj <- Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "params_prefix_obj" json_bridge_as);
						bridge_as.params_prefix_output <- Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "params_prefix_output" json_bridge_as);
						bridge_as.params_prefix_include <- Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "params_prefix_include" json_bridge_as);
						retval := true;
					end;
					
				end
			;

	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval)
;;


(*--------------------------------------------------------------------------*)
(* parse json node "bridge-ld" *)
(* return: *)
(* on success: true; bridge_ld fields are modified with parsed values *)
(* on failure: false; bridge_ld fields are untouched *)
(*--------------------------------------------------------------------------*)
let parse_bridge_ld 
	(mf_json : Yojson.Basic.t)
	(bridge_ld : bridge_ld_t) 
	: bool =

	let retval = ref false in

	try
		let open Yojson.Basic.Util in
			let json_bridge_ld = mf_json |> member "bridge-ld" in
			if(json_bridge_ld <> `Null) then
				begin
					
					retval := parse_bridge_hdr json_bridge_ld bridge_ld.bridge_hdr;

					if !retval then begin
						bridge_ld.params_prefix_lscript <- Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "params_prefix_lscript" json_bridge_ld);
						bridge_ld.params_prefix_libdir <- Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "params_prefix_libdir" json_bridge_ld);
						bridge_ld.params_prefix_lib <- Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "params_prefix_lib" json_bridge_ld);
						bridge_ld.params_prefix_output <- Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "params_prefix_output" json_bridge_ld);
						retval := true;
					end;
					
				end
			;

	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval)
;;



(****************************************************************************)
(* manifest write interfaces *)
(****************************************************************************)

(*--------------------------------------------------------------------------*)
(* write bridge-hdr manifest node *)
(*--------------------------------------------------------------------------*)
let write_bridge_hdr 
	?(continuation = true)
	(oc : out_channel)
	(bridge_hdr : bridge_hdr_t) 
	: bool =
	let retval = ref false in

	Printf.fprintf oc "\n";
	Printf.fprintf oc "\n\t\"bridge-hdr\":{";

	Printf.fprintf oc "\n\t\t\t\"btype\" : \"%s\"," bridge_hdr.btype;
	Printf.fprintf oc "\n\t\t\t\"bname\" : \"%s\"," bridge_hdr.bname;
	Printf.fprintf oc "\n\t\t\t\"execname\" : \"%s\"," bridge_hdr.execname;
	Printf.fprintf oc "\n\t\t\t\"devenv\" : \"%s\"," bridge_hdr.devenv;
	Printf.fprintf oc "\n\t\t\t\"arch\" : \"%s\"," bridge_hdr.arch;
	Printf.fprintf oc "\n\t\t\t\"cpu\" : \"%s\"," bridge_hdr.cpu;
	Printf.fprintf oc "\n\t\t\t\"version\" : \"%s\"," bridge_hdr.version;
	Printf.fprintf oc "\n\t\t\t\"path\" : \"%s\"," bridge_hdr.path;
	Printf.fprintf oc "\n\t\t\t\"params\" : [ ";
	let index = ref 0 in
	while !index < ((List.length bridge_hdr.params)-1) do
		Printf.fprintf oc "\"%s\", " (List.nth bridge_hdr.params !index);
		index := !index + 1;
	done;
	if (List.length bridge_hdr.params) > 0 then
		Printf.fprintf oc "\"%s\" " (List.nth bridge_hdr.params ((List.length bridge_hdr.params)-1));
	Printf.fprintf oc " ],";
	Printf.fprintf oc "\n\t\t\t\"container_fname\" : \"%s\"" bridge_hdr.container_fname;

	if continuation then
		begin
			Printf.fprintf oc "\n\t},";
		end
	else
		begin
			Printf.fprintf oc "\n\t}";
		end
	;

	Printf.fprintf oc "\n";

	(!retval)
;;

(*
(*--------------------------------------------------------------------------*)
(* write bridge-cc manifest node *)
(*--------------------------------------------------------------------------*)
let write_bridge_cc 
	?(continuation = true)
	(oc : out_channel)
	(bridge_cc : bridge_cc_t) 
	: bool =
	let retval = ref false in

	Printf.fprintf oc "\n";
	Printf.fprintf oc "\n\t\"bridge-cc\":{";

	write_bridge_hdr oc bridge_cc.bridge_hdr;

	Printf.fprintf oc "\n\t\t\"params_prefix_obj\" : \"%s\"," bridge_cc.params_prefix_obj;
	Printf.fprintf oc "\n\t\t\"params_prefix_asm\" : \"%s\"," bridge_cc.params_prefix_asm;
	Printf.fprintf oc "\n\t\t\"params_prefix_output\" : \"%s\"," bridge_cc.params_prefix_output;
	Printf.fprintf oc "\n\t\t\"params_prefix_include\" : \"%s\"" bridge_cc.params_prefix_include;

	if continuation then
		begin
			Printf.fprintf oc "\n\t},";
		end
	else
		begin
			Printf.fprintf oc "\n\t}";
		end
	;

	Printf.fprintf oc "\n";

	(!retval)
;;
*)

(*--------------------------------------------------------------------------*)
(* write bridge-as manifest node *)
(*--------------------------------------------------------------------------*)
let write_bridge_as 
	?(continuation = true)
	(oc : out_channel)
	(bridge_as : bridge_as_t) 
	: bool =
	let retval = ref false in

	Printf.fprintf oc "\n";
	Printf.fprintf oc "\n\t\"bridge-as\":{";

	write_bridge_hdr oc bridge_as.bridge_hdr;

	Printf.fprintf oc "\n\t\t\"params_prefix_obj\" : \"%s\"," bridge_as.params_prefix_obj;
	Printf.fprintf oc "\n\t\t\"params_prefix_output\" : \"%s\"," bridge_as.params_prefix_output;
	Printf.fprintf oc "\n\t\t\"params_prefix_include\" : \"%s\"" bridge_as.params_prefix_include;

	if continuation then
		begin
			Printf.fprintf oc "\n\t},";
		end
	else
		begin
			Printf.fprintf oc "\n\t}";
		end
	;

	Printf.fprintf oc "\n";

	(!retval)
;;


(*--------------------------------------------------------------------------*)
(* write bridge-ld manifest node *)
(*--------------------------------------------------------------------------*)
let write_bridge_ld 
	?(continuation = true)
	(oc : out_channel)
	(bridge_ld : bridge_ld_t) 
	: bool =
	let retval = ref false in

	Printf.fprintf oc "\n";
	Printf.fprintf oc "\n\t\"bridge-ld\":{";

	write_bridge_hdr oc bridge_ld.bridge_hdr;

	Printf.fprintf oc "\n\t\t\"params_prefix_lscript\" : \"%s\"," bridge_ld.params_prefix_lscript;
	Printf.fprintf oc "\n\t\t\"params_prefix_libdir\" : \"%s\"," bridge_ld.params_prefix_libdir;
	Printf.fprintf oc "\n\t\t\"params_prefix_lib\" : \"%s\"," bridge_ld.params_prefix_lib;
	Printf.fprintf oc "\n\t\t\"params_prefix_output\" : \"%s\"" bridge_ld.params_prefix_output;

	if continuation then
		begin
			Printf.fprintf oc "\n\t},";
		end
	else
		begin
			Printf.fprintf oc "\n\t}";
		end
	;

	Printf.fprintf oc "\n";

	(!retval)
;;


