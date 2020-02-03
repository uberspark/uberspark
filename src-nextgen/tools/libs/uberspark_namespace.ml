(*===========================================================================*)
(*===========================================================================*)
(*	uberSpark namespace interface implementation		 *)
(*	author: amit vasudevan (amitvasudevan@acm.org)							 *)
(*===========================================================================*)
(*===========================================================================*)


(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* type definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)



(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* variable definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)


(* root *)
let namespace_root = "uberspark";;
let namespace_root_dir_prefix = ref "";; 
let namespace_root_mf_filename = "uberspark.json";;
let namespace_root_mf_node_type_tag = "uberspark-manifest";;




let namespace_uobj = "uobjs";;
let namespace_uobj_mf_filename = "uberspark-uobj.json";;
let namespace_uobj_mf_hdr_type = "uobj";;
let namespace_uobj_build_dir = "_build";;
let namespace_uobj_binhdr_src_filename = "uobj_binhdr.c";;
let namespace_uobj_publicmethods_info_src_filename = "uobj_pminfo.c";;
let namespace_uobj_intrauobjcoll_callees_info_src_filename = "uobj_intrauobjcoll_callees_info.c";;
let namespace_uobj_interuobjcoll_callees_info_src_filename = "uobj_interuobjcoll_callees_info.c";;
let namespace_uobj_legacy_callees_info_src_filename = "uobj_legacy_callees_info.c";;
let namespace_uobj_linkerscript_filename = "uobj.lscript";;
let namespace_uobj_binary_image_filename = "uobj.bin";;
let namespace_uobj_top_level_include_header_src_filename = "uobj.h";;


let namespace_uobjcoll = "uobjcoll";;
let namespace_uobjcoll_mf_filename = "uberspark-uobjcoll.json";;
let namespace_uobjcoll_build_dir = "_build";;
let namespace_uobjcoll_uobj_binary_image_section_mapping_src_filename = "uobjcoll_uobj_binsec_map.S";;
let namespace_uobjcoll_sentinel_definitions_src_filename = "uobjcoll_sentinels.S";;
let namespace_uobjcoll_linkerscript_filename = "uobjcoll.lscript";;
let namespace_uobjcoll_binary_image_filename = "uobjcoll.bin";;


let namespace_uobjrtl_mf_filename = "uberspark-uobjrtl.json";;

let namespace_legacy = "legacy";;


let namespace_uobjslt = "uobjslt";;
let namespace_uobjslt_intrauobjcoll_callees_src_filename = "uobjslt-intrauobjcoll-callees.S";;
let namespace_uobjslt_interuobjcoll_callees_src_filename = "uobjslt-interuobjcoll-callees.S";;
let namespace_uobjslt_legacy_callees_src_filename = "uobjslt-legacy-callees.S";;
let namespace_uobjslt_output_symbols_filename = "uobjslt-symbols.json";;
let namespace_uobjslt_mf_node_type_tag = "uberspark-uobjslt";;


let namespace_sentinel = "sentinels";;
let namespace_sentinel_mf_node_type_tag = "uberspark-sentinel";;


(* staging *)
let namespace_staging = "staging";;
let namespace_staging_current = "current";;
let namespace_staging_golden = "staging_golden";;
let namespace_staging_default = "default";;


let namespace_config = "config";;
let namespace_config_mf_filename = "uberspark-config.json";;
let namespace_config_current = "current";;
let namespace_config_default = "default";;
let namespace_config_mf_node_type_tag = "uberspark-config";;


let namespace_bridge = "bridges";;
let namespace_bridge_mf_filename = "uberspark-bridge.json";;
let namespace_bridge_container_filename = "uberspark-bridge.Dockerfile";;

let namespace_bridge_ar_bridge_name = "ar-bridge";;
let namespace_bridge_as_bridge_name = "as-bridge";;
let namespace_bridge_cc_bridge_name = "cc-bridge";;
let namespace_bridge_ld_bridge_name = "ld-bridge";;
let namespace_bridge_pp_bridge_name = "pp-bridge";;
let namespace_bridge_vf_bridge_name = "vf-bridge";;
let namespace_bridge_bldsys_bridge_name = "bldsys-bridge";;

let namespace_bridge_ar_bridge = namespace_bridge ^ "/" ^ namespace_bridge_ar_bridge_name;;
let namespace_bridge_as_bridge = namespace_bridge ^ "/" ^ namespace_bridge_as_bridge_name;;
let namespace_bridge_cc_bridge = namespace_bridge ^ "/" ^ namespace_bridge_cc_bridge_name;;
let namespace_bridge_ld_bridge = namespace_bridge ^ "/" ^ namespace_bridge_ld_bridge_name;;
let namespace_bridge_pp_bridge = namespace_bridge ^ "/" ^ namespace_bridge_pp_bridge_name;;
let namespace_bridge_vf_bridge = namespace_bridge ^ "/" ^ namespace_bridge_vf_bridge_name;;
let namespace_bridge_bldsys_bridge = namespace_bridge ^ "/" ^ namespace_bridge_bldsys_bridge_name;;



(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* interface definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)


let set_namespace_root_dir_prefix
	(root_dir_prefix : string)
	: unit = 
	namespace_root_dir_prefix := root_dir_prefix;
	()
;;


let get_namespace_root_dir_prefix
	()
	: string = 
	
	(* check to see if namespace_root_dir has been populated, if not default to home directory *)
	if !namespace_root_dir_prefix = "" then begin
		namespace_root_dir_prefix := Unix.getenv "HOME";
	end;

	(* always try and return the absolute path, fall back to namespace_root_dir in case of error *)
	let (rval, rabspath) = Uberspark_osservices.abspath !namespace_root_dir_prefix in
	if (rval) then begin
		(rabspath)
	end else begin
		(!namespace_root_dir_prefix)
	end;
;;

let get_namespace_staging_dir_prefix
	()
	: string = 

	let symlink_path = 	((get_namespace_root_dir_prefix ()) ^ "/" ^ namespace_root ^ "/" ^ namespace_staging ^ 
		"/" ^ namespace_staging_current) in
	(Uberspark_osservices.readlink symlink_path)
;;



let get_variable_name_prefix_from_ns
	(ns : string)
	: string = 

	let retval = ref "" in
	if ns = "legacy" then begin
		retval := "uberspark_legacy";
	end else begin
		retval := (Str.global_replace (Str.regexp "/") "_" ns);
	end;

	(!retval)
;;



let get_uobj_uobjcoll_name_from_uobj_ns
	(uobj_ns : string)
	: (bool * string * string) =
	
	let retval = ref false in
	let uobj_name = ref "" in 
	let uobjcoll_name = ref "" in 
	
	if (Str.string_match (Str.regexp_string (namespace_root ^ "/" ^ namespace_uobj ^ "/")) uobj_ns 0) then begin
		(* this is a uobj within the uberspark uobj namespace *)
		uobj_name := Filename.basename ("/" ^ uobj_ns);
		uobjcoll_name := "";
		retval := true;
	
	end else if (Str.string_match (Str.regexp_string (namespace_root ^ "/" ^ namespace_uobjcoll ^ "/")) uobj_ns 0) then begin
		(* this is a uobj within a uobjcoll wihin the uberspark uobjcoll namespace *)
		uobj_name := Filename.basename ("/" ^ uobj_ns);
		let uobjcoll_ns = Filename.dirname ("/" ^ uobj_ns) in 
		uobjcoll_name := Filename.basename ("/" ^ uobjcoll_ns);
		retval := true;

	end else if uobj_ns = "legacy" then begin 
		(* this is legacy code namespace *)
		uobj_name := "";
		uobjcoll_name := "legacy";
		retval := true;
		
	end else begin
		(* this is an unknown namespace *)
		uobj_name := "";
		uobjcoll_name := "";
		retval := false;
	end;

	(!retval, !uobj_name, !uobjcoll_name)
;;


let is_uobj_uobjcoll_canonical_namespace
	(uobj_uobjcoll_ns : string)
	: bool =

	let retval = ref false in

	if (Str.string_match (Str.regexp_string (namespace_root ^ "/" ^ namespace_uobj ^ "/")) uobj_uobjcoll_ns 0) then begin
		(* this is a uobj within the uberspark uobj namespace *)
		retval := true;
	
	end else if (Str.string_match (Str.regexp_string (namespace_root ^ "/" ^ namespace_uobjcoll ^ "/")) uobj_uobjcoll_ns 0) then begin
		(* this is a uobj within a uobjcoll wihin the uberspark uobjcoll namespace *)
		retval := true;

	end else begin
		(* this is an unknown namespace *)
		retval := false;
	end;

	(!retval)
;;


let is_uobj_ns_in_uobjcoll_ns
	(uobj_ns : string)
	(uobjcoll_ns : string)
	: bool =

	let retval = ref false in

	if (Str.string_match (Str.regexp_string (uobjcoll_ns)) uobj_ns 0) then begin
		(* this is a uobj within the given uobjcoll namespace *)
		retval := true;
	
	end else begin
		(* this uobj does not belong to the given uobjcoll namespace *)
		retval := false;
	end;

	(!retval)
;;




let is_uobj_uobjcoll_abspath_in_namespace
	(uobj_uobjcoll_abspath : string)
	: bool =

	let retval = ref false in

	if (Str.string_match (Str.regexp_string ((get_namespace_root_dir_prefix ()) ^ "/" ^ namespace_root ^ "/" ^ namespace_uobj ^ "/")) uobj_uobjcoll_abspath 0) then begin
		(* this is a uobj within the uberspark uobj namespace *)
		retval := true;
	
	end else if (Str.string_match (Str.regexp_string ((get_namespace_root_dir_prefix ()) ^ "/" ^ namespace_root ^ "/" ^ namespace_uobjcoll ^ "/")) uobj_uobjcoll_abspath 0) then begin
		(* this is a uobj within a uobjcoll wihin the uberspark uobjcoll namespace *)
		retval := true;

	end else begin
		(* this is an unknown namespace *)
		retval := false;
	end;

	(!retval)
;;

let get_namespace_basename
	(ns : string)
	: string =

	(Filename.basename ns)
;;
