(*===========================================================================*)
(*===========================================================================*)
(*	uberSpark staging configuration interface implementation		 *)
(*	author: amit vasudevan (amitvasudevan@acm.org)							 *)
(*===========================================================================*)
(*===========================================================================*)

open Unix
open Yojson


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

(* uberspark-manifest json node variable *)
let json_node_uberspark_manifest_var : Uberspark.Manifest.json_node_uberspark_manifest_t = {
	namespace = "uberspark/platform";
	version_min = "any";
	version_max = "any";
	actions = [];
};;



(*------------------------------------------------------------------------*)
(* configuration settings variable *)	
(*------------------------------------------------------------------------*)
let json_node_uberspark_platform_var : Uberspark.Manifest.Platform.json_node_uberspark_platform_t = {
	binary = {
	(* uobj/uobjcoll binary related configuration settings *)	
	page_size = 0x0020000;
	uobj_section_alignment = 0x00200000;
	uobj_default_section_size =  0x00200000;

	uobj_image_load_address = 0x60000000;
	uobj_image_uniform_size = true;
	uobj_image_size = 0x01000000;
	uobj_image_alignment = 0x200000;

	(* uobjcoll related configuration settings *)
	uobjcoll_image_load_address = 0x60000000;
	uobjcoll_image_hdr_section_alignment = 0x200000;
	uobjcoll_image_hdr_section_size = 0x200000;
	uobjcoll_image_section_alignment= 0x200000;
	uobjcoll_image_size = 0x02000000;

	(* bridge related configuration settings *)	
	cc_bridge_namespace = "";
	as_bridge_namespace = "";
	casm_bridge_namespace = "";
	ld_bridge_namespace = "";
	uberspark_vf_bridge_namespace = "";
	};
};;


let saved_json_node_uberspark_platform_var : Uberspark.Manifest.Platform.json_node_uberspark_platform_t = {
	binary = {
	(* uobj/uobjcoll binary related configuration settings *)	
	page_size = 0x0020000;
	uobj_section_alignment = 0x00200000;
	uobj_default_section_size =  0x00200000;

	uobj_image_load_address = 0x60000000;
	uobj_image_uniform_size = true;
	uobj_image_size = 0x1000000;
	uobj_image_alignment = 0x200000;

	(* uobjcoll related configuration settings *)
	uobjcoll_image_load_address = 0x60000000;
	uobjcoll_image_hdr_section_alignment = 0x200000;
	uobjcoll_image_hdr_section_size = 0x200000;
	uobjcoll_image_section_alignment = 0x200000;
	uobjcoll_image_size = 0x02000000;

	(* bridge related configuration settings *)	
	cc_bridge_namespace = "";
	as_bridge_namespace = "";
	casm_bridge_namespace = "";
	ld_bridge_namespace = "";
	uberspark_vf_bridge_namespace = "";
	};
};;



(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* interface definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)


let settings_save 
	() 
	: unit =
	saved_json_node_uberspark_platform_var.binary.page_size <- json_node_uberspark_platform_var.binary.page_size;
	saved_json_node_uberspark_platform_var.binary.uobj_section_alignment <- json_node_uberspark_platform_var.binary.uobj_section_alignment;
	saved_json_node_uberspark_platform_var.binary.uobj_default_section_size <- json_node_uberspark_platform_var.binary.uobj_default_section_size;

	saved_json_node_uberspark_platform_var.binary.uobj_image_load_address <- json_node_uberspark_platform_var.binary.uobj_image_load_address;
	saved_json_node_uberspark_platform_var.binary.uobj_image_uniform_size <- json_node_uberspark_platform_var.binary.uobj_image_uniform_size;
	saved_json_node_uberspark_platform_var.binary.uobj_image_size <- json_node_uberspark_platform_var.binary.uobj_image_size;
	saved_json_node_uberspark_platform_var.binary.uobj_image_alignment <- json_node_uberspark_platform_var.binary.uobj_image_alignment;

	saved_json_node_uberspark_platform_var.binary.uobjcoll_image_load_address <- json_node_uberspark_platform_var.binary.uobjcoll_image_load_address;
	saved_json_node_uberspark_platform_var.binary.uobjcoll_image_hdr_section_alignment <- json_node_uberspark_platform_var.binary.uobjcoll_image_hdr_section_alignment;
	saved_json_node_uberspark_platform_var.binary.uobjcoll_image_hdr_section_size <- json_node_uberspark_platform_var.binary.uobjcoll_image_hdr_section_size;
	saved_json_node_uberspark_platform_var.binary.uobjcoll_image_section_alignment <- json_node_uberspark_platform_var.binary.uobjcoll_image_section_alignment;
	saved_json_node_uberspark_platform_var.binary.uobjcoll_image_size <- json_node_uberspark_platform_var.binary.uobjcoll_image_size;

	saved_json_node_uberspark_platform_var.binary.cc_bridge_namespace <- json_node_uberspark_platform_var.binary.cc_bridge_namespace;
	saved_json_node_uberspark_platform_var.binary.as_bridge_namespace <- json_node_uberspark_platform_var.binary.as_bridge_namespace;
	saved_json_node_uberspark_platform_var.binary.casm_bridge_namespace <- json_node_uberspark_platform_var.binary.casm_bridge_namespace;
	saved_json_node_uberspark_platform_var.binary.ld_bridge_namespace <- json_node_uberspark_platform_var.binary.ld_bridge_namespace;
	saved_json_node_uberspark_platform_var.binary.uberspark_vf_bridge_namespace <- json_node_uberspark_platform_var.binary.uberspark_vf_bridge_namespace;


	()
;;


let settings_restore 
	() 
	: unit =
	json_node_uberspark_platform_var.binary.page_size <- saved_json_node_uberspark_platform_var.binary.page_size;
	json_node_uberspark_platform_var.binary.uobj_section_alignment <- saved_json_node_uberspark_platform_var.binary.uobj_section_alignment;
	json_node_uberspark_platform_var.binary.uobj_default_section_size <- saved_json_node_uberspark_platform_var.binary.uobj_default_section_size;

	json_node_uberspark_platform_var.binary.uobj_image_load_address <- saved_json_node_uberspark_platform_var.binary.uobj_image_load_address;
	json_node_uberspark_platform_var.binary.uobj_image_uniform_size <- saved_json_node_uberspark_platform_var.binary.uobj_image_uniform_size;
	json_node_uberspark_platform_var.binary.uobj_image_size <- saved_json_node_uberspark_platform_var.binary.uobj_image_size;
	json_node_uberspark_platform_var.binary.uobj_image_alignment <- saved_json_node_uberspark_platform_var.binary.uobj_image_alignment;

	json_node_uberspark_platform_var.binary.uobjcoll_image_load_address <- saved_json_node_uberspark_platform_var.binary.uobjcoll_image_load_address;
	json_node_uberspark_platform_var.binary.uobjcoll_image_hdr_section_alignment <- saved_json_node_uberspark_platform_var.binary.uobjcoll_image_hdr_section_alignment;
	json_node_uberspark_platform_var.binary.uobjcoll_image_hdr_section_size <- saved_json_node_uberspark_platform_var.binary.uobjcoll_image_hdr_section_size;
	json_node_uberspark_platform_var.binary.uobjcoll_image_section_alignment <- saved_json_node_uberspark_platform_var.binary.uobjcoll_image_section_alignment;
	json_node_uberspark_platform_var.binary.uobjcoll_image_size <- saved_json_node_uberspark_platform_var.binary.uobjcoll_image_size;

	json_node_uberspark_platform_var.binary.cc_bridge_namespace <- saved_json_node_uberspark_platform_var.binary.cc_bridge_namespace;
	json_node_uberspark_platform_var.binary.as_bridge_namespace <- saved_json_node_uberspark_platform_var.binary.as_bridge_namespace;
	json_node_uberspark_platform_var.binary.casm_bridge_namespace <- saved_json_node_uberspark_platform_var.binary.casm_bridge_namespace;
	json_node_uberspark_platform_var.binary.ld_bridge_namespace <- saved_json_node_uberspark_platform_var.binary.ld_bridge_namespace;
	json_node_uberspark_platform_var.binary.uberspark_vf_bridge_namespace <- saved_json_node_uberspark_platform_var.binary.uberspark_vf_bridge_namespace;


	()
;;




let load_from_json 
	(mf_json : Yojson.Basic.json)
	: bool =
	let retval = ref false in

	let rval_json_node_uberspark_platform_var = 
		Uberspark.Manifest.Platform.json_node_uberspark_platform_to_var mf_json json_node_uberspark_platform_var in
	if rval_json_node_uberspark_platform_var then begin
		retval := true;
	end else begin
		retval := false;
	end;

	(!retval)
;;


let load 
	(p_platform_namespace: string)
	: bool =

	let retval = ref false in
	let config_ns_json_path = (Uberspark.Namespace.get_namespace_staging_dir_prefix ()) ^ "/" ^ 
		p_platform_namespace ^ "/" ^ 
		Uberspark.Namespace.namespace_root_mf_filename in
	Uberspark.Logger.log "config_ns_json_path=%s" config_ns_json_path;

	(* grab uberspark-config json node into var *)
	(*let (rval, l_json_node_uberspark_manifest, json_node_uberspark_config) = 
		Uberspark.Manifest.get_json_for_manifest_node_type config_ns_json_path 
		Uberspark.Namespace.namespace_platform_mf_node_type_tag in*)

	let (rval, mf_json) = 	Uberspark.Manifest.get_json_for_manifest config_ns_json_path in

		if rval then begin

			let rval = Uberspark.Manifest.json_node_uberspark_manifest_to_var mf_json json_node_uberspark_manifest_var in

			if rval then begin
					retval := load_from_json mf_json; 
			end	else begin
					retval := false;
			end;

		end	else begin
				retval := false;
		end;

	(!retval)
;;







let settings_get 
	(setting_name : string)
	: (bool * string) =

	let retstatus = ref true in
	let settings_value = ref "" in
	match setting_name with
		| "page_size" -> settings_value := (Printf.sprintf "0x%x" json_node_uberspark_platform_var.binary.page_size);
		| "uobj_section_alignment" -> settings_value := (Printf.sprintf "0x%x" json_node_uberspark_platform_var.binary.uobj_section_alignment);
		| "uobj_default_section_size" -> settings_value := (Printf.sprintf "0x%x" json_node_uberspark_platform_var.binary.uobj_default_section_size);
		| "uobj_image_load_address" -> settings_value := (Printf.sprintf "0x%x"  json_node_uberspark_platform_var.binary.uobj_image_load_address);
		| "uobj_image_uniform_size" -> settings_value := (Printf.sprintf "%B"  json_node_uberspark_platform_var.binary.uobj_image_uniform_size);
		| "uobj_image_size" -> settings_value := (Printf.sprintf "0x%x"  json_node_uberspark_platform_var.binary.uobj_image_size);
		| "uobj_image_alignment" -> settings_value := (Printf.sprintf "0x%x"  json_node_uberspark_platform_var.binary.uobj_image_alignment);
		| "uobjcoll_image_load_address" -> settings_value := (Printf.sprintf "0x%x"  json_node_uberspark_platform_var.binary.uobjcoll_image_load_address);
		| "uobjcoll_image_hdr_section_alignment" -> settings_value := (Printf.sprintf "0x%x"  json_node_uberspark_platform_var.binary.uobjcoll_image_hdr_section_alignment);
		| "uobjcoll_image_hdr_section_size" -> settings_value := (Printf.sprintf "0x%x"  json_node_uberspark_platform_var.binary.uobjcoll_image_hdr_section_size);
		| "uobjcoll_image_section_alignment" -> settings_value := (Printf.sprintf "0x%x"  json_node_uberspark_platform_var.binary.uobjcoll_image_section_alignment);
		| "uobjcoll_image_size" -> settings_value := (Printf.sprintf "0x%x"  json_node_uberspark_platform_var.binary.uobjcoll_image_size);
		| "cc_bridge_namespace" -> settings_value := (Printf.sprintf "%s" json_node_uberspark_platform_var.binary.cc_bridge_namespace);
		| "as_bridge_namespace" -> settings_value := (Printf.sprintf "%s" json_node_uberspark_platform_var.binary.as_bridge_namespace);
		| "casm_bridge_namespace" -> settings_value := (Printf.sprintf "%s" json_node_uberspark_platform_var.binary.casm_bridge_namespace);
		| "ld_bridge_namespace" -> settings_value := (Printf.sprintf "%s" json_node_uberspark_platform_var.binary.ld_bridge_namespace);
		| "uberspark_vf_bridge_namespace" -> settings_value := (Printf.sprintf "%s" json_node_uberspark_platform_var.binary.uberspark_vf_bridge_namespace);
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
		| "page_size" -> json_node_uberspark_platform_var.binary.page_size <- int_of_string setting_value;
		| "uobj_section_alignment" -> json_node_uberspark_platform_var.binary.uobj_section_alignment <- int_of_string setting_value;
		| "uobj_default_section_size" -> json_node_uberspark_platform_var.binary.uobj_default_section_size <- int_of_string setting_value;
		| "uobj_image_load_address" -> json_node_uberspark_platform_var.binary.uobj_image_load_address <- int_of_string setting_value;
		| "uobj_image_uniform_size" -> json_node_uberspark_platform_var.binary.uobj_image_uniform_size <- bool_of_string setting_value;
		| "uobj_image_size" -> json_node_uberspark_platform_var.binary.uobj_image_size <- int_of_string setting_value;
		| "uobj_image_alignment" -> json_node_uberspark_platform_var.binary.uobj_image_alignment <- int_of_string setting_value;
		| "uobjcoll_image_load_address" -> json_node_uberspark_platform_var.binary.uobjcoll_image_load_address <- int_of_string setting_value;
		| "uobjcoll_image_hdr_section_alignment" -> json_node_uberspark_platform_var.binary.uobjcoll_image_hdr_section_alignment <- int_of_string setting_value;
		| "uobjcoll_image_hdr_section_size" -> json_node_uberspark_platform_var.binary.uobjcoll_image_hdr_section_size <- int_of_string setting_value;
		| "uobjcoll_image_section_alignment" -> json_node_uberspark_platform_var.binary.uobjcoll_image_section_alignment <- int_of_string setting_value;
		| "uobjcoll_image_size" -> json_node_uberspark_platform_var.binary.uobjcoll_image_size <- int_of_string setting_value;
		| "cc_bridge_namespace" -> json_node_uberspark_platform_var.binary.cc_bridge_namespace <- setting_value;
		| "as_bridge_namespace" -> json_node_uberspark_platform_var.binary.as_bridge_namespace <- setting_value;
		| "casm_bridge_namespace" -> json_node_uberspark_platform_var.binary.casm_bridge_namespace <- setting_value;
		| "ld_bridge_namespace" -> json_node_uberspark_platform_var.binary.ld_bridge_namespace <- setting_value;
		| "uberspark_vf_bridge_namespace" -> json_node_uberspark_platform_var.binary.uberspark_vf_bridge_namespace <- setting_value;
		| _ -> retval := false;
	;
	
	!retval
;;




let dump_to_file 
	(output_config_filename : string)
	=

	Uberspark.Manifest.write_to_file output_config_filename 
		[
			(Uberspark.Manifest.json_node_uberspark_manifest_var_to_jsonstr json_node_uberspark_manifest_var);
			(Uberspark.Manifest.Platform.json_node_uberspark_platform_var_to_jsonstr json_node_uberspark_platform_var);
		];
;;







(*---------------------------------------------------------------------------*)
(* FOR FUTURE EXPANSION *)
(*---------------------------------------------------------------------------*)


(*
let create_from_file
	(input_config_json_pathname : string)
	(output_config_name : string)
	: (bool * string) =
	
	let retval = ref false in
	let reterrmsg = ref "" in

	let output_config_dir = ((Uberspark.Namespace.get_namespace_staging_dir_prefix ()) ^ "/" ^ Uberspark.Namespace.namespace_root ^ "/" ^ Uberspark.Namespace.namespace_platform) in
	let output_config_json_pathname = output_config_dir ^ "/" ^ Uberspark.Namespace.namespace_platform_mf_filename in


	try
		let config_json = Yojson.Basic.from_file input_config_json_pathname in
		
		retval := load_from_json config_json;

	with Yojson.Json_error s -> 
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "%s" s;
		retval := false;
	;
					

	Uberspark_osservices.mkdir ~parent:true output_config_dir (`Octal 0o0777);

	dump output_config_json_pathname;

	(!retval, !reterrmsg)
;;
*)

(*
let create_from_existing_ns
	(input_config_name : string)
	(output_config_name : string)
	: (bool * string) =
	
	let retval = ref false in
	let reterrmsg = ref "" in

	let output_config_dir = (!Uberspark.Namespace.namespace_root_dir ^ "/" ^ Uberspark.Namespace.namespace_root ^ "/" ^ Uberspark.Namespace.namespace_platform ^ "/" ^ output_config_name) in
	let output_config_json_pathname = output_config_dir ^ "/" ^ Uberspark.Namespace.namespace_platform_mf_filename in

	(* load the input config *)
	load input_config_name;

	(* change name field within config header *)
	config_hdr.name <- output_config_name;

	(* make the output config directory *)
	Uberspark_osservices.mkdir ~parent:true output_config_dir (`Octal 0o0777);

	retval := true;
	reterrmsg := "";
	
	(* dump the config namespace *)
	dump output_config_json_pathname;

	(!retval, !reterrmsg)
;;
*)

(*
let switch 
	(config_name : string)
	: bool =
	
	let retval = ref true in
	let config_ns_path = !Uberspark.Namespace.namespace_root_dir ^ "/" ^ Uberspark.Namespace.namespace_root ^ "/" ^ Uberspark.Namespace.namespace_platform ^ "/" ^ config_name in 
	let config_ns_current_path = !Uberspark.Namespace.namespace_root_dir ^ "/" ^ Uberspark.Namespace.namespace_root ^ "/" ^ Uberspark.Namespace.namespace_platform ^ "/" ^ Uberspark.Namespace.namespace_platform_current in
	let config_ns_json_path = config_ns_path ^ "/" ^ Uberspark.Namespace.namespace_platform_mf_filename in

	Uberspark_osservices.file_remove config_ns_current_path;
	Uberspark_osservices.symlink true config_ns_path config_ns_current_path;
	
	load Uberspark.Namespace.namespace_platform_current;

	(!retval)
;;
*)

(*
let remove 
	(config_name : string)
	: bool =
	let retval = ref false in
	
	if (config_name <> Uberspark.Namespace.namespace_platform_default) then 
		begin
			let config_ns_path = !Uberspark.Namespace.namespace_root_dir ^ "/" ^ Uberspark.Namespace.namespace_root ^ "/" ^ Uberspark.Namespace.namespace_platform ^ "/" ^ config_name in 
			let config_ns_json_path = config_ns_path ^ "/" ^ Uberspark.Namespace.namespace_platform_mf_filename in
			
			Uberspark_osservices.file_remove config_ns_json_path;
			Uberspark_osservices.rmdir config_ns_path;

			(* check if we removed the current config, if so reload the default *)
			if config_hdr.name = config_name then
				ignore(switch Uberspark.Namespace.namespace_platform_default);
			;

			retval := true;
		end 
	;

	(!retval)
;;
*)






