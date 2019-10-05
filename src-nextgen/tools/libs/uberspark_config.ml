(*
	uberSpark configuration module
	author: amit vasudevan (amitvasudevan@acm.org)
*)
open Unix
open Yojson

(*------------------------------------------------------------------------*)
(* environment related configuration settings *)	
(*------------------------------------------------------------------------*)
(*let env_path_seperator = ref "/";;*)
let env_home_dir = ref "HOME";;


(*------------------------------------------------------------------------*)
(* namespace related configuration settings *)	
(*------------------------------------------------------------------------*)
let namespace_root = ((Unix.getenv !env_home_dir) ^ "/");;
let namespace_default_uobj_mf_filename = "uberspark-uobj-mf.json";;
let namespace_uobj_mf_hdr_type = "uobj";;

let namespace_uobj_binhdr_src_filename = "uobj_binhdr.c";;
let namespace_uobj_publicmethods_info_src_filename = "uobj_pminfo.c";;
let namespace_uobj_intrauobjcoll_callees_info_src_filename = "uobj_intrauobjcoll_callees_info.c";;
let namespace_uobj_interuobjcoll_callees_info_src_filename = "uobj_interuobjcoll_callees_info.c";;
let namespace_uobj_linkerscript_filename = "uobj.lscript";;

let namespace_uobjslt = (namespace_root ^ "uberspark/uobjslt");;
let namespace_uobjslt_mf_hdr_type = "uobjslt";;
let namespace_uobjslt_mf_filename = "uberspark-uobjslt-mf.json";;
let namespace_uobjslt_callees_output_filename = "uobjslt-callees.S";;
let namespace_uobjslt_exitcallees_output_filename = "uobjslt-exitcallees.S";;
let namespace_uobjslt_output_symbols_filename = "uobjslt-symbols.json";;


(*------------------------------------------------------------------------*)
(* uobj/uobjcoll binary related configuration settings *)	
(*------------------------------------------------------------------------*)
let binary_page_size = ref 0x00200000;;
let binary_uobj_section_alignment = ref 0x00200000;;
let binary_uobj_default_section_size = ref 0x00200000;;

let binary_uobj_default_load_addr = ref 0x60000000;;
let binary_uobj_default_size = ref 0x01000000;;



let switch 
	(config_ns : string)
	: bool =
	let retval = ref false in
	let config_ns_json_path = namespace_root ^ config_ns ^ "/uberspark-config.json" in
	Uberspark_logger.log "config_ns_json_path=%s" config_ns_json_path;

	try
		let config_json = Yojson.Basic.from_file config_ns_json_path in
		(*parse header*)
		let config_json_hdr = Yojson.Basic.Util.member "hdr" config_json in
			let hdr_type = Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "type" config_json_hdr) in
			let hdr_namespace = Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "namespace" config_json_hdr) in
			(* TBD: sanity check header *)
		
		let config_json_from = Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "from" config_json) in
			(*TBD: sanity check from to be null *)

		let config_json_settings = 	Yojson.Basic.Util.member "settings" config_json in

			binary_page_size := int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "binary_page_size" config_json_settings));
			binary_uobj_section_alignment := int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "binary_uobj_section_alignment" config_json_settings));
			binary_uobj_default_section_size := int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "binary_uobj_default_section_size" config_json_settings));
			binary_uobj_default_load_addr := int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "binary_uobj_default_load_addr" config_json_settings));
			binary_uobj_default_size := int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "binary_uobj_default_size" config_json_settings));


		Uberspark_logger.log "binary_page_size=0x%08x" !binary_page_size;
		

		retval := true;							
	with Yojson.Json_error s -> 
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "%s" s;
		retval := false;
	;
					


	(!retval)
;;




