(****************************************************************************)
(****************************************************************************)
(* uberSpark manifest interface for bridge *)
(*	 author: amit vasudevan (amitvasudevan@acm.org) *)
(****************************************************************************)
(****************************************************************************)


(****************************************************************************)
(* manifest node types *)
(****************************************************************************)

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

(* bridge-cc node type *)
type bridge_cc_t = { 
	mutable bridge_hdr : bridge_hdr_t;
	mutable params_prefix_obj: string;
	mutable params_prefix_asm: string;
	mutable params_prefix_output: string;
	mutable params_prefix_include: string;
};;

(* bridge-as node type *)
type bridge_as_t = { 
	mutable bridge_hdr : bridge_hdr_t;
	mutable params_prefix_obj: string;
	mutable params_prefix_output: string;
	mutable params_prefix_include: string;
};;



(****************************************************************************)
(* manifest parse interfaces *)
(****************************************************************************)

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



