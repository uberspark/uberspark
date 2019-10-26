(*
	uberSpark configuration module
	author: amit vasudevan (amitvasudevan@acm.org)
*)
open Unix
open Yojson


(*------------------------------------------------------------------------*)
(* configuration header variable *)	
(*------------------------------------------------------------------------*)
let hdr: Uberspark_manifest.Config.config_hdr_t = {
	namespace = "";
};;



(*------------------------------------------------------------------------*)
(* configuration settings record variable *)	
(*------------------------------------------------------------------------*)
let settings: Uberspark_manifest.Config.config_settings_t = {

	(* environment related settings *)
	env_home_dir = "HOME";

	(* uobj/uobjcoll binary related configuration settings *)	
	binary_page_size = 0x0020000;
	binary_uobj_section_alignment = 0x00200000;
	binary_uobj_default_section_size =  0x00200000;
	binary_uobj_default_load_addr = 0x60000000;
	binary_uobj_default_size = 0x01000000;

	(* bridge related configuration settings *)	
	bridge_cc_bridge = "";

};;



(*------------------------------------------------------------------------*)
(* header related configuration settings *)	
(*------------------------------------------------------------------------*)
let hdr_type = ref "";;
let hdr_namespace = ref "";;
let hdr_platform = ref "";;
let hdr_arch = ref "";;
let hdr_cpu = ref "";;


(*------------------------------------------------------------------------*)
(* environment related configuration settings *)	
(*------------------------------------------------------------------------*)
(*let env_path_seperator = ref "/";;*)
let env_home_dir = ref "HOME";;


(*------------------------------------------------------------------------*)
(* namespace related configuration settings *)	
(*------------------------------------------------------------------------*)
let namespace_root = ((Unix.getenv !env_home_dir) ^ "/");;
let namespace_root_mf_filename = "uberspark.json";;


let namespace_uobj_mf_filename = "uberspark-uobj.json";;
let namespace_uobj_mf_hdr_type = "uobj";;

let namespace_uobj_binhdr_src_filename = "uobj_binhdr.c";;
let namespace_uobj_publicmethods_info_src_filename = "uobj_pminfo.c";;
let namespace_uobj_intrauobjcoll_callees_info_src_filename = "uobj_intrauobjcoll_callees_info.c";;
let namespace_uobj_interuobjcoll_callees_info_src_filename = "uobj_interuobjcoll_callees_info.c";;
let namespace_uobj_linkerscript_filename = "uobj.lscript";;


let namespace_uobjcoll_mf_filename = "uberspark-uobjcoll.json";;


let namespace_uobjrtl_mf_filename = "uberspark-uobjrtl.json";;



let namespace_uobjslt = (namespace_root ^ "uberspark/uobjslt");;
let namespace_uobjslt_mf_hdr_type = "uobjslt";;
let namespace_uobjslt_mf_filename = "uberspark-uobjslt.json";;
let namespace_uobjslt_callees_output_filename = "uobjslt-callees.S";;
let namespace_uobjslt_exitcallees_output_filename = "uobjslt-exitcallees.S";;
let namespace_uobjslt_output_symbols_filename = "uobjslt-symbols.json";;


let namespace_config_mf_filename = "uberspark-config.json";;
let namespace_config_current = "uberspark/config/current";;


let namespace_bridges = "uberspark/bridges";;

let namespace_bridges_mf_filename = "uberspark-bridge.json";;
let namespace_bridges_container_filename = "uberspark-bridge.Dockerfile";;


let namespace_bridges_ar_bridge_name = "ar-bridge";;
let namespace_bridges_as_bridge_name = "as-bridge";;
let namespace_bridges_cc_bridge_name = "cc-bridge";;
let namespace_bridges_ld_bridge_name = "ld-bridge";;
let namespace_bridges_pp_bridge_name = "pp-bridge";;
let namespace_bridges_vf_bridge_name = "vf-bridge";;
let namespace_bridges_bldsys_bridge_name = "bldsys-bridge";;

let namespace_bridges_ar_bridge = namespace_bridges ^ "/" ^ namespace_bridges_ar_bridge_name;;
let namespace_bridges_as_bridge = namespace_bridges ^ "/" ^ namespace_bridges_as_bridge_name;;
let namespace_bridges_cc_bridge = namespace_bridges ^ "/" ^ namespace_bridges_cc_bridge_name;;
let namespace_bridges_ld_bridge = namespace_bridges ^ "/" ^ namespace_bridges_ld_bridge_name;;
let namespace_bridges_pp_bridge = namespace_bridges ^ "/" ^ namespace_bridges_pp_bridge_name;;
let namespace_bridges_vf_bridge = namespace_bridges ^ "/" ^ namespace_bridges_vf_bridge_name;;
let namespace_bridges_bldsys_bridge = namespace_bridges ^ "/" ^ namespace_bridges_bldsys_bridge_name;;




(*------------------------------------------------------------------------*)
(* uobj/uobjcoll binary related configuration settings *)	
(*------------------------------------------------------------------------*)
let binary_page_size = ref 0x00200000;;
let binary_uobj_section_alignment = ref 0x00200000;;
let binary_uobj_default_section_size = ref 0x00200000;;

let binary_uobj_default_load_addr = ref 0x60000000;;
let binary_uobj_default_size = ref 0x01000000;;


(*------------------------------------------------------------------------*)
(* bridge related configuration settings *)	
(*------------------------------------------------------------------------*)
let bridge_cc_bridge = ref "";;


let load_from_json 
	(json_node : Yojson.Basic.json)
	: bool =
	let retval = ref false in

	let rval_config_hdr = Uberspark_manifest.Config.parse_config_hdr json_node hdr in
	let rval_config_settings = Uberspark_manifest.Config.parse_config_settings json_node settings in

	if rval_config_hdr && rval_config_settings then
		retval := true;
	else
		retval := false;
	;

	(!retval)
;;



let load 
	(config_ns : string)
	: bool =
	let retval = ref false in
	let config_ns_json_path = namespace_root ^ config_ns ^ "/uberspark-config.json" in
	Uberspark_logger.log "config_ns_json_path=%s" config_ns_json_path;

	let (rval, config_json) = Uberspark_manifest.get_manifest_json config_ns_json_path in
	if rval then
		retval := load_from_json config_json;
	else
		retval := false;
	;
				
	(!retval)
;;





let dump 
	(output_config_filename : string)
	=

	let oc = open_out output_config_filename in
		Printf.fprintf oc "\n/* --- this file is autogenerated --- */";
		Printf.fprintf oc "\n/* uberSpark configuration file */";
		Printf.fprintf oc "\n";
		Printf.fprintf oc "\n";
		Printf.fprintf oc "\n{";
		Printf.fprintf oc "\n\t\"hdr\":{";
		Printf.fprintf oc "\n\t\t\"type\" : \"%s\"," !hdr_type;
		Printf.fprintf oc "\n\t\t\"namespace\" : \"%s\"," !hdr_namespace;
		Printf.fprintf oc "\n\t\t\"platform\" : \"%s\"," !hdr_platform;
		Printf.fprintf oc "\n\t\t\"arch\" : \"%s\"," !hdr_arch;
		Printf.fprintf oc "\n\t\t\"cpu\" : \"%s\"" !hdr_cpu;
		Printf.fprintf oc "\n\t},";
		Printf.fprintf oc "\n";
		Printf.fprintf oc "\n\t\"settings\":{";
		Printf.fprintf oc "\n\t\t\"binary_page_size\" : \"0x%x\"," !binary_page_size;
		Printf.fprintf oc "\n\t\t\"binary_uobj_section_alignment\" : \"0x%x\"," !binary_uobj_section_alignment;
		Printf.fprintf oc "\n\t\t\"binary_uobj_default_section_size\" : \"0x%x\"," !binary_uobj_default_section_size;
		Printf.fprintf oc "\n\t\t\"binary_uobj_default_load_addr\" : \"0x%x\"," !binary_uobj_default_load_addr;
		Printf.fprintf oc "\n\t\t\"binary_uobj_default_size\" : \"0x%x\"," !binary_uobj_default_size;
		Printf.fprintf oc "\n\t\t\"bridge_cc_bridge\" : \"%s\"" !bridge_cc_bridge;
		Printf.fprintf oc "\n\t}";
		Printf.fprintf oc "\n";
		Printf.fprintf oc "\n}";
	close_out oc;	


;;


let create_from_existing_ns
	(input_config_ns : string)
	(output_config_ns : string)
	: (bool * string) =
	let retval = ref false in
	let reterrmsg = ref "" in

	let output_config_dir = (namespace_root ^ output_config_ns) in
	let output_config_json_pathname = output_config_dir ^ "/uberspark-config.json" in

	(* load the input config ns *)
	load input_config_ns;

	(* change namespace field *)
	hdr_namespace := output_config_ns;

	(* make the output config directory *)
	Uberspark_osservices.mkdir ~parent:true output_config_dir (`Octal 0o0777);

	retval := true;
	reterrmsg := "";
	(* dump the config namespace *)
	dump output_config_json_pathname;

	(!retval, !reterrmsg)
;;


let create_from_file
	(input_config_json_pathname : string)
	(output_config_ns : string)
	: (bool * string) =
	let retval = ref false in
	let reterrmsg = ref "" in

	let output_config_dir = (namespace_root ^ output_config_ns) in
	let output_config_json_pathname = output_config_dir ^ "/uberspark-config.json" in


	try
		let config_json = Yojson.Basic.from_file input_config_json_pathname in
		
		retval := load_from_json config_json;

	with Yojson.Json_error s -> 
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "%s" s;
		retval := false;
	;
					

	Uberspark_osservices.mkdir ~parent:true output_config_dir (`Octal 0o0777);

	dump output_config_json_pathname;

	(!retval, !reterrmsg)
;;


let settings_get 
	(setting_name : string)
	: (bool * string) =

	let retstatus = ref true in
	let settings_value = ref "" in
	match setting_name with
		| "binary_page_size" -> settings_value := (Printf.sprintf "0x%x" !binary_page_size);
		| "binary_uobj_section_alignment" -> settings_value := (Printf.sprintf "0x%x" !binary_uobj_section_alignment);
		| "binary_uobj_default_section_size" -> settings_value := (Printf.sprintf "0x%x" !binary_uobj_default_section_size);
		| "binary_uobj_default_load_addr" -> settings_value := (Printf.sprintf "0x%x"  !binary_uobj_default_load_addr);
		| "binary_uobj_default_size" -> settings_value := (Printf.sprintf "0x%x" !binary_uobj_default_size);
		| "bridge_cc_bridge" -> settings_value := (Printf.sprintf "%s" !bridge_cc_bridge);
		| _ -> retstatus := false;
	;
	
	(!retstatus, !settings_value)
;;


let settings_set 
	(setting_name : string)
	(setting_value : string)
	: bool =

	let retval = ref true in
	match setting_name with
		| "binary_page_size" -> binary_page_size := int_of_string setting_value;
		| "binary_uobj_section_alignment" -> binary_uobj_section_alignment := int_of_string setting_value;
		| "binary_uobj_default_section_size" -> binary_uobj_default_section_size := int_of_string setting_value;
		| "binary_uobj_default_load_addr" -> binary_uobj_default_load_addr := int_of_string setting_value;
		| "binary_uobj_default_size" -> binary_uobj_default_size := int_of_string setting_value;
		| "bridge_cc_bridge" -> bridge_cc_bridge := setting_value;
		| _ -> retval := false;
	;
	
	!retval
;;


let switch 
	(config_ns : string)
	: bool =
	let retval = ref true in
	let config_ns_path = namespace_root ^ config_ns in 
	let config_ns_current_path = namespace_root ^ "uberspark/config/current" in
	let config_ns_json_path = config_ns_path ^ "/uberspark-config.json" in

	Uberspark_osservices.file_remove config_ns_current_path;
	Uberspark_osservices.symlink true config_ns_path config_ns_current_path;
	load "uberspark/config/current";

	(!retval)
;;


let remove 
	(config_ns : string)
	: bool =
	let retval = ref false in
	
	if (config_ns <> "uberspark/config/default") then 
		begin
			let config_ns_path = namespace_root ^ config_ns in 
			let config_ns_json_path = config_ns_path ^ "/uberspark-config.json" in
			
			Uberspark_osservices.file_remove config_ns_json_path;
			Uberspark_osservices.rmdir config_ns_path;

			(* check if we removed the current config, if so reload the default *)
			if !hdr_namespace = config_ns then
				ignore(switch "uberspark/config/default");
			;

			retval := true;
		end 
	;

	(!retval)
;;







