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
let json_node_uberspark_manifest_var: Uberspark_manifest.json_node_uberspark_manifest_t = {
	f_manifest_node_types = [ "uberspark-config" ];
	f_uberspark_min_version = "any";
	f_uberspark_max_version = "any";
};;


(*
(*------------------------------------------------------------------------*)
(* configuration header variable *)	
(*------------------------------------------------------------------------*)
let config_hdr: Uberspark_manifest.Config.config_hdr_t = {
	name = "";
};;
*)


(*------------------------------------------------------------------------*)
(* configuration settings variable *)	
(*------------------------------------------------------------------------*)
let json_node_uberspark_config_var: Uberspark_manifest.Config.json_node_uberspark_config_t = {

	(* uobj/uobjcoll binary related configuration settings *)	
	binary_page_size = 0x0020000;
	binary_uobj_section_alignment = 0x00200000;
	binary_uobj_default_section_size =  0x00200000;

	uobj_binary_image_load_address = 0x60000000;
	uobj_binary_image_uniform_size = true;
	uobj_binary_image_size = 0x1000000;
	uobj_binary_image_alignment = 0x200000;

	(* uobjcoll related configuration settings *)
	uobjcoll_binary_image_load_address = 0x60000000;
	uobjcoll_binary_image_hdr_section_alignment = 0x200000;
	uobjcoll_binary_image_hdr_section_size = 0x200000;
	uobjcoll_binary_image_section_alignment= 0x200000;


	(* bridge related configuration settings *)	
	bridge_cc_bridge = "";
	bridge_as_bridge = "";
	bridge_ld_bridge = "";
	
};;


let saved_json_node_uberspark_config_var: Uberspark_manifest.Config.json_node_uberspark_config_t = {

	(* uobj/uobjcoll binary related configuration settings *)	
	binary_page_size = 0x0020000;
	binary_uobj_section_alignment = 0x00200000;
	binary_uobj_default_section_size =  0x00200000;

	uobj_binary_image_load_address = 0x60000000;
	uobj_binary_image_uniform_size = true;
	uobj_binary_image_size = 0x1000000;
	uobj_binary_image_alignment = 0x200000;

	(* uobjcoll related configuration settings *)
	uobjcoll_binary_image_load_address = 0x60000000;
	uobjcoll_binary_image_hdr_section_alignment = 0x200000;
	uobjcoll_binary_image_hdr_section_size = 0x200000;
	uobjcoll_binary_image_section_alignment = 0x200000;


	(* bridge related configuration settings *)	
	bridge_cc_bridge = "";
	bridge_as_bridge = "";
	bridge_ld_bridge = "";
	
};;



(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* interface definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)


let settings_save 
	() 
	: unit =
	saved_json_node_uberspark_config_var.binary_page_size <- json_node_uberspark_config_var.binary_page_size;
	saved_json_node_uberspark_config_var.binary_uobj_section_alignment <- json_node_uberspark_config_var.binary_uobj_section_alignment;
	saved_json_node_uberspark_config_var.binary_uobj_default_section_size <- json_node_uberspark_config_var.binary_uobj_default_section_size;

	saved_json_node_uberspark_config_var.uobj_binary_image_load_address <- json_node_uberspark_config_var.uobj_binary_image_load_address;
	saved_json_node_uberspark_config_var.uobj_binary_image_uniform_size <- json_node_uberspark_config_var.uobj_binary_image_uniform_size;
	saved_json_node_uberspark_config_var.uobj_binary_image_size <- json_node_uberspark_config_var.uobj_binary_image_size;
	saved_json_node_uberspark_config_var.uobj_binary_image_alignment <- json_node_uberspark_config_var.uobj_binary_image_alignment;

	saved_json_node_uberspark_config_var.uobjcoll_binary_image_load_address <- json_node_uberspark_config_var.uobjcoll_binary_image_load_address;
	saved_json_node_uberspark_config_var.uobjcoll_binary_image_hdr_section_alignment <- json_node_uberspark_config_var.uobjcoll_binary_image_hdr_section_alignment;
	saved_json_node_uberspark_config_var.uobjcoll_binary_image_hdr_section_size <- json_node_uberspark_config_var.uobjcoll_binary_image_hdr_section_size;
	saved_json_node_uberspark_config_var.uobjcoll_binary_image_section_alignment <- json_node_uberspark_config_var.uobjcoll_binary_image_section_alignment;

	saved_json_node_uberspark_config_var.bridge_cc_bridge <- json_node_uberspark_config_var.bridge_cc_bridge;
	saved_json_node_uberspark_config_var.bridge_as_bridge <- json_node_uberspark_config_var.bridge_as_bridge;
	saved_json_node_uberspark_config_var.bridge_ld_bridge <- json_node_uberspark_config_var.bridge_ld_bridge;


	()
;;


let settings_restore 
	() 
	: unit =
	json_node_uberspark_config_var.binary_page_size <- saved_json_node_uberspark_config_var.binary_page_size;
	json_node_uberspark_config_var.binary_uobj_section_alignment <- saved_json_node_uberspark_config_var.binary_uobj_section_alignment;
	json_node_uberspark_config_var.binary_uobj_default_section_size <- saved_json_node_uberspark_config_var.binary_uobj_default_section_size;

	json_node_uberspark_config_var.uobj_binary_image_load_address <- saved_json_node_uberspark_config_var.uobj_binary_image_load_address;
	json_node_uberspark_config_var.uobj_binary_image_uniform_size <- saved_json_node_uberspark_config_var.uobj_binary_image_uniform_size;
	json_node_uberspark_config_var.uobj_binary_image_size <- saved_json_node_uberspark_config_var.uobj_binary_image_size;
	json_node_uberspark_config_var.uobj_binary_image_alignment <- saved_json_node_uberspark_config_var.uobj_binary_image_alignment;

	json_node_uberspark_config_var.uobjcoll_binary_image_load_address <- saved_json_node_uberspark_config_var.uobjcoll_binary_image_load_address;
	json_node_uberspark_config_var.uobjcoll_binary_image_hdr_section_alignment <- saved_json_node_uberspark_config_var.uobjcoll_binary_image_hdr_section_alignment;
	json_node_uberspark_config_var.uobjcoll_binary_image_hdr_section_size <- saved_json_node_uberspark_config_var.uobjcoll_binary_image_hdr_section_size;
	json_node_uberspark_config_var.uobjcoll_binary_image_section_alignment <- saved_json_node_uberspark_config_var.uobjcoll_binary_image_section_alignment;

	json_node_uberspark_config_var.bridge_cc_bridge <- saved_json_node_uberspark_config_var.bridge_cc_bridge;
	json_node_uberspark_config_var.bridge_as_bridge <- saved_json_node_uberspark_config_var.bridge_as_bridge;
	json_node_uberspark_config_var.bridge_ld_bridge <- saved_json_node_uberspark_config_var.bridge_ld_bridge;


	()
;;




let load_from_json 
	(json_node : Yojson.Basic.json)
	: bool =
	let retval = ref false in

	let rval_json_node_uberspark_config_var = 
		Uberspark_manifest.Config.json_node_uberspark_config_to_var json_node json_node_uberspark_config_var in
	if rval_json_node_uberspark_config_var then begin
		retval := true;
	end else begin
		retval := false;
	end;

	(!retval)
;;


let load 
	()
	: bool =

	let retval = ref false in
	let config_ns_json_path = (Uberspark_namespace.get_namespace_staging_dir_prefix ()) ^ "/" ^ 
		Uberspark_namespace.namespace_root ^ "/" ^ Uberspark_namespace.namespace_config ^ "/" ^ 
		Uberspark_namespace.namespace_root_mf_filename in
	Uberspark_logger.log "config_ns_json_path=%s" config_ns_json_path;

	(* grab uberspark-config json node into var *)
	let (rval, l_json_node_uberspark_manifest, json_node_uberspark_config) = 
		Uberspark_manifest.get_json_for_manifest_node_type config_ns_json_path 
		Uberspark_namespace.namespace_config_mf_node_type_tag in

		if rval then begin
				retval := load_from_json json_node_uberspark_config; 
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
		| "binary_page_size" -> settings_value := (Printf.sprintf "0x%x" json_node_uberspark_config_var.binary_page_size);
		| "binary_uobj_section_alignment" -> settings_value := (Printf.sprintf "0x%x" json_node_uberspark_config_var.binary_uobj_section_alignment);
		| "binary_uobj_default_section_size" -> settings_value := (Printf.sprintf "0x%x" json_node_uberspark_config_var.binary_uobj_default_section_size);
		| "uobj_binary_image_load_address" -> settings_value := (Printf.sprintf "0x%x"  json_node_uberspark_config_var.uobj_binary_image_load_address);
		| "uobj_binary_image_uniform_size" -> settings_value := (Printf.sprintf "%B"  json_node_uberspark_config_var.uobj_binary_image_uniform_size);
		| "uobj_binary_image_size" -> settings_value := (Printf.sprintf "0x%x"  json_node_uberspark_config_var.uobj_binary_image_size);
		| "uobj_binary_image_alignment" -> settings_value := (Printf.sprintf "0x%x"  json_node_uberspark_config_var.uobj_binary_image_alignment);
		| "uobjcoll_binary_image_load_address" -> settings_value := (Printf.sprintf "0x%x"  json_node_uberspark_config_var.uobjcoll_binary_image_load_address);
		| "uobjcoll_binary_image_hdr_section_alignment" -> settings_value := (Printf.sprintf "0x%x"  json_node_uberspark_config_var.uobjcoll_binary_image_hdr_section_alignment);
		| "uobjcoll_binary_image_hdr_section_size" -> settings_value := (Printf.sprintf "0x%x"  json_node_uberspark_config_var.uobjcoll_binary_image_hdr_section_size);
		| "uobjcoll_binary_image_section_alignment" -> settings_value := (Printf.sprintf "0x%x"  json_node_uberspark_config_var.uobjcoll_binary_image_section_alignment);
		| "bridge_cc_bridge" -> settings_value := (Printf.sprintf "%s" json_node_uberspark_config_var.bridge_cc_bridge);
		| "bridge_as_bridge" -> settings_value := (Printf.sprintf "%s" json_node_uberspark_config_var.bridge_as_bridge);
		| "bridge_ld_bridge" -> settings_value := (Printf.sprintf "%s" json_node_uberspark_config_var.bridge_ld_bridge);
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
		| "binary_page_size" -> json_node_uberspark_config_var.binary_page_size <- int_of_string setting_value;
		| "binary_uobj_section_alignment" -> json_node_uberspark_config_var.binary_uobj_section_alignment <- int_of_string setting_value;
		| "binary_uobj_default_section_size" -> json_node_uberspark_config_var.binary_uobj_default_section_size <- int_of_string setting_value;
		| "uobj_binary_image_load_address" -> json_node_uberspark_config_var.uobj_binary_image_load_address <- int_of_string setting_value;
		| "uobj_binary_image_uniform_size" -> json_node_uberspark_config_var.uobj_binary_image_uniform_size <- bool_of_string setting_value;
		| "uobj_binary_image_size" -> json_node_uberspark_config_var.uobj_binary_image_size <- int_of_string setting_value;
		| "uobj_binary_image_alignment" -> json_node_uberspark_config_var.uobj_binary_image_alignment <- int_of_string setting_value;
		| "uobjcoll_binary_image_load_address" -> json_node_uberspark_config_var.uobjcoll_binary_image_load_address <- int_of_string setting_value;
		| "uobjcoll_binary_image_hdr_section_alignment" -> json_node_uberspark_config_var.uobjcoll_binary_image_hdr_section_alignment <- int_of_string setting_value;
		| "uobjcoll_binary_image_hdr_section_size" -> json_node_uberspark_config_var.uobjcoll_binary_image_hdr_section_size <- int_of_string setting_value;
		| "uobjcoll_binary_image_section_alignment" -> json_node_uberspark_config_var.uobjcoll_binary_image_section_alignment <- int_of_string setting_value;
		| "bridge_cc_bridge" -> json_node_uberspark_config_var.bridge_cc_bridge <- setting_value;
		| "bridge_as_bridge" -> json_node_uberspark_config_var.bridge_as_bridge <- setting_value;
		| "bridge_ld_bridge" -> json_node_uberspark_config_var.bridge_ld_bridge <- setting_value;
		| _ -> retval := false;
	;
	
	!retval
;;




let dump_to_file 
	(output_config_filename : string)
	=

	let oc = open_out output_config_filename in

(*Uberspark_manifest.write_prologue ~prologue_str:"uberSpark config manifest" oc;
		Uberspark_manifest.write_uberspark_hdr oc uberspark_hdr;
		Uberspark_manifest.Config.write_config_hdr oc config_hdr;
		Uberspark_manifest.Config.write_json_node_uberspark_config_var ~continuation:false oc json_node_uberspark_config_var;
		Uberspark_manifest.write_epilogue oc;
*)
	close_out oc;	
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

	let output_config_dir = ((Uberspark_namespace.get_namespace_staging_dir_prefix ()) ^ "/" ^ Uberspark_namespace.namespace_root ^ "/" ^ Uberspark_namespace.namespace_config) in
	let output_config_json_pathname = output_config_dir ^ "/" ^ Uberspark_namespace.namespace_config_mf_filename in


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
*)

(*
let create_from_existing_ns
	(input_config_name : string)
	(output_config_name : string)
	: (bool * string) =
	
	let retval = ref false in
	let reterrmsg = ref "" in

	let output_config_dir = (!Uberspark_namespace.namespace_root_dir ^ "/" ^ Uberspark_namespace.namespace_root ^ "/" ^ Uberspark_namespace.namespace_config ^ "/" ^ output_config_name) in
	let output_config_json_pathname = output_config_dir ^ "/" ^ Uberspark_namespace.namespace_config_mf_filename in

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
	let config_ns_path = !Uberspark_namespace.namespace_root_dir ^ "/" ^ Uberspark_namespace.namespace_root ^ "/" ^ Uberspark_namespace.namespace_config ^ "/" ^ config_name in 
	let config_ns_current_path = !Uberspark_namespace.namespace_root_dir ^ "/" ^ Uberspark_namespace.namespace_root ^ "/" ^ Uberspark_namespace.namespace_config ^ "/" ^ Uberspark_namespace.namespace_config_current in
	let config_ns_json_path = config_ns_path ^ "/" ^ Uberspark_namespace.namespace_config_mf_filename in

	Uberspark_osservices.file_remove config_ns_current_path;
	Uberspark_osservices.symlink true config_ns_path config_ns_current_path;
	
	load Uberspark_namespace.namespace_config_current;

	(!retval)
;;
*)

(*
let remove 
	(config_name : string)
	: bool =
	let retval = ref false in
	
	if (config_name <> Uberspark_namespace.namespace_config_default) then 
		begin
			let config_ns_path = !Uberspark_namespace.namespace_root_dir ^ "/" ^ Uberspark_namespace.namespace_root ^ "/" ^ Uberspark_namespace.namespace_config ^ "/" ^ config_name in 
			let config_ns_json_path = config_ns_path ^ "/" ^ Uberspark_namespace.namespace_config_mf_filename in
			
			Uberspark_osservices.file_remove config_ns_json_path;
			Uberspark_osservices.rmdir config_ns_path;

			(* check if we removed the current config, if so reload the default *)
			if config_hdr.name = config_name then
				ignore(switch Uberspark_namespace.namespace_config_default);
			;

			retval := true;
		end 
	;

	(!retval)
;;
*)






