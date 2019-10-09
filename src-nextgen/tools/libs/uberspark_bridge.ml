(*
	uberSpark bridge module
	author: amit vasudevan (amitvasudevan@acm.org)
*)
open Unix
open Yojson

type bridge_hdr_t = {
	mutable btype : string;
	mutable execname: string;
	mutable path: string;
	mutable params: string list;
	mutable extexecname: string;
	mutable devenv: string;
	mutable arch: string;
	mutable cpu: string;
	mutable version: string;
	mutable namespace: string;
}
;;

type cc_bridge_t = { 
	mutable hdr : bridge_hdr_t;
	mutable params_prefix_to_obj: string list;
	mutable params_prefix_to_asm: string list;
	mutable params_prefix_to_output: string list;
};;


let hdr_type = ref "";;
let hdr_namespace = ref "";;
let hdr_platform = ref "";;
let hdr_arch = ref "";;
let hdr_cpu = ref "";;


let cc_bridge_settings : cc_bridge_t = {
	hdr = { btype = "";
			execname = "";
			path = "";
			params = [];
			extexecname = "";
			devenv = "";
			arch = "";
			cpu = "";
			version = "";
			namespace = "";
	};
	params_prefix_to_obj = [];
	params_prefix_to_asm = [];
	params_prefix_to_output = [];
};;


let json_list_to_string_list
	json_list = 
	
	let ret_str_list = ref [] in
		List.iter (fun (x) ->
			ret_str_list := !ret_str_list @ [ (Yojson.Basic.Util.to_string x) ];
		) json_list;

	(!ret_str_list)
;;



let load_from_file 
	(bridge_ns_json_file : string)
	: bool =
	let retval = ref false in
	Uberspark_logger.log "bridge_ns_json_file=%s" bridge_ns_json_file;

	try
		let bridge_json = Yojson.Basic.from_file bridge_ns_json_file in
		(*parse header*)
		let bridge_json_hdr = Yojson.Basic.Util.member "hdr" bridge_json in
			hdr_type := Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "type" bridge_json_hdr);
			hdr_namespace := Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "namespace" bridge_json_hdr);
			hdr_platform := Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "platform" bridge_json_hdr);
			hdr_arch := Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "arch" bridge_json_hdr);
			hdr_cpu := Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "cpu" bridge_json_hdr);
			(* TBD: sanity check header *)
		

		(* parse cc-bridge if found *)
		let cc_bridge_json = Yojson.Basic.Util.member "cc-bridge" bridge_json in
		if (cc_bridge_json <> `Null) then
			begin
				let cc_bridge_json_hdr = Yojson.Basic.Util.member "hdr" cc_bridge_json in
					cc_bridge_settings.hdr.btype <-	Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "btype" cc_bridge_json_hdr);
					cc_bridge_settings.hdr.execname <-	Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "execname" cc_bridge_json_hdr);
					cc_bridge_settings.hdr.path <-	Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "path" cc_bridge_json_hdr);
					cc_bridge_settings.hdr.params <-	json_list_to_string_list ( Yojson.Basic.Util.to_list (Yojson.Basic.Util.member "params" cc_bridge_json_hdr));
					cc_bridge_settings.hdr.extexecname <-	Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "extexecname" cc_bridge_json_hdr);
					cc_bridge_settings.hdr.devenv <-	Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "devenv" cc_bridge_json_hdr);
					cc_bridge_settings.hdr.arch <-	Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "arch" cc_bridge_json_hdr);
					cc_bridge_settings.hdr.cpu <-	Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "cpu" cc_bridge_json_hdr);
					cc_bridge_settings.hdr.version <-	Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "version" cc_bridge_json_hdr);
					cc_bridge_settings.hdr.namespace <-	Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "namespace" cc_bridge_json_hdr);

				cc_bridge_settings.params_prefix_to_obj <- json_list_to_string_list ( Yojson.Basic.Util.to_list (Yojson.Basic.Util.member "params_prefix_to_obj" cc_bridge_json));
				cc_bridge_settings.params_prefix_to_asm <- json_list_to_string_list ( Yojson.Basic.Util.to_list (Yojson.Basic.Util.member "params_prefix_to_asm" cc_bridge_json));
				cc_bridge_settings.params_prefix_to_output <- json_list_to_string_list ( Yojson.Basic.Util.to_list (Yojson.Basic.Util.member "params_prefix_to_output" cc_bridge_json));
			end
		;

		
		retval := true;							
	with Yojson.Json_error s -> 
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "%s" s;
		retval := false;
	;
					
	(!retval)
;;

let load 
	(bridge_ns : string)
	: bool =
	let bridge_ns_json_path = Uberspark_config.namespace_root ^ bridge_ns ^ "/uberspark-bridge.json" in
		(load_from_file bridge_ns_json_path)
;;
