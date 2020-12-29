(*===========================================================================*)
(*===========================================================================*)
(* uberSpark bridge module interface implementation -- cc bridge submodule *)
(*	 author: amit vasudevan (amitvasudevan@acm.org) *)
(*===========================================================================*)
(*===========================================================================*)


open Unix
open Yojson

(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* variables *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)

(* uberspark-manifest json node variable *)	
let json_node_uberspark_manifest_var: Uberspark_manifest.json_node_uberspark_manifest_t = {
	namespace = [ "uberspark-bridge-cc" ];
	version_min = "any";
	version_max = "any";
};;

(* uberspark-bridge-cc json node variable *)	
let json_node_uberspark_bridge_cc_var: Uberspark_manifest.Bridge.Cc.json_node_uberspark_bridge_cc_t = {
	json_node_bridge_hdr_var = { category = "";
				name = "";
				executable_name = "";
				path = "";
				dev_environment = "";
				arch = "";
				cpu = "";
				version = "";
				parameters = [];
				container_filename = "";
				namespace = "";
	};
	params_prefix_obj = "";
	params_prefix_asm = "";
	params_prefix_output = "";
	params_prefix_include = "";
	params_cclib = "";
	bridge_cmd = [];
};;



(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* interface definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)


let load_from_json
	(mf_json : Yojson.Basic.json)
	: bool =

	let retval = ref false in

	let rval_json_node_uberspark_bridge_cc_var = Uberspark_manifest.Bridge.Cc.json_node_uberspark_bridge_cc_to_var  
		mf_json json_node_uberspark_bridge_cc_var in

	if rval_json_node_uberspark_bridge_cc_var then begin
		retval := true;
	end else begin
		retval := false;
	end;

	(!retval)
;;


let load_from_file 
	(json_file : string)
	: bool =
	let retval = ref false in
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "loading cc-bridge settings from file: %s" json_file;

	let (rval, mf_json) = Uberspark_manifest.get_json_for_manifest json_file in

		if rval then begin

			let rval = Uberspark_manifest.json_node_uberspark_manifest_to_var mf_json json_node_uberspark_manifest_var in

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



let load 
	(bridge_ns : string)
	: bool =
	let bridge_ns_json_path = (Uberspark_namespace.get_namespace_root_dir_prefix ()) ^ "/" ^ Uberspark_namespace.namespace_root ^ "/" ^
		Uberspark_namespace.namespace_cc_bridge_namespace ^ "/" ^ bridge_ns ^ "/" ^
		Uberspark_namespace.namespace_root_mf_filename in
		(load_from_file bridge_ns_json_path)
;;


let store_to_file 
	(json_file : string)
	: bool =
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "storing cc-bridge settings to file: %s" json_file;

	Uberspark_manifest.write_to_file json_file 
		[
			(Uberspark_manifest.json_node_uberspark_manifest_var_to_jsonstr json_node_uberspark_manifest_var);
			(Uberspark_manifest.Bridge.Cc.json_node_uberspark_bridge_cc_var_to_jsonstr json_node_uberspark_bridge_cc_var);
		];

	(true)
;;


let store 
	()
	: bool =
	let retval = ref false in 
    let bridge_ns = json_node_uberspark_bridge_cc_var.json_node_bridge_hdr_var.category ^ "/" ^
		json_node_uberspark_bridge_cc_var.json_node_bridge_hdr_var.dev_environment ^ "/" ^
		json_node_uberspark_bridge_cc_var.json_node_bridge_hdr_var.arch ^ "/" ^
		json_node_uberspark_bridge_cc_var.json_node_bridge_hdr_var.cpu ^ "/" ^
		json_node_uberspark_bridge_cc_var.json_node_bridge_hdr_var.name ^ "/" ^
		json_node_uberspark_bridge_cc_var.json_node_bridge_hdr_var.version in
	let bridge_ns_json_path = (Uberspark_namespace.get_namespace_root_dir_prefix ()) ^ "/" ^ Uberspark_namespace.namespace_root ^ "/" ^
		Uberspark_namespace.namespace_cc_bridge_namespace ^ "/" ^ bridge_ns in
	let bridge_ns_json_filename = bridge_ns_json_path ^ "/" ^
		Uberspark_namespace.namespace_root_mf_filename in

	(* make the namespace directory *)
	Uberspark_osservices.mkdir ~parent:true bridge_ns_json_path (`Octal 0o0777);

	retval := store_to_file bridge_ns_json_filename;

	(* check if bridge type is container, if so store dockerfile *)
	if !retval && json_node_uberspark_bridge_cc_var.json_node_bridge_hdr_var.category = "container" then
		begin
			let input_bridge_dockerfile = json_node_uberspark_bridge_cc_var.json_node_bridge_hdr_var.container_filename in 
			let output_bridge_dockerfile = bridge_ns_json_path ^ "/uberspark-bridge.Dockerfile" in 
				Uberspark_osservices.file_copy input_bridge_dockerfile output_bridge_dockerfile;
		end
	;

	(!retval)
;;


let build 
	()
	: bool =

	let retval = ref false in

	if json_node_uberspark_bridge_cc_var.json_node_bridge_hdr_var.category = "container" then
		begin
			let bridge_ns = Uberspark_namespace.namespace_cc_bridge_namespace ^ "/" ^
				json_node_uberspark_bridge_cc_var.json_node_bridge_hdr_var.category ^ "/" ^
				json_node_uberspark_bridge_cc_var.json_node_bridge_hdr_var.dev_environment ^ "/" ^
				json_node_uberspark_bridge_cc_var.json_node_bridge_hdr_var.arch ^ "/" ^
				json_node_uberspark_bridge_cc_var.json_node_bridge_hdr_var.cpu ^ "/" ^
				json_node_uberspark_bridge_cc_var.json_node_bridge_hdr_var.name ^ "/" ^
				json_node_uberspark_bridge_cc_var.json_node_bridge_hdr_var.version in
			let bridge_container_path = (Uberspark_namespace.get_namespace_root_dir_prefix ()) ^ "/" ^ Uberspark_namespace.namespace_root ^ "/" ^ bridge_ns in

			Uberspark_logger.log "building cc-bridge: %s" bridge_ns;

			if (Container.build_image bridge_container_path bridge_ns) == 0 then begin	
				retval := true;
			end else begin
				Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not build cc-bridge!"; 
				retval := false;
			end
			;
										
		end
	else
		begin
			Uberspark_logger.log ~lvl:Uberspark_logger.Warn "ignoring build command for 'native' bridge";
			retval := true;
		end
	;

	(!retval)
;;



let invoke 
	?(gen_obj = true)
	?(context_path_builddir = ".")
	(c_file_list : string list)
	(include_dir_list : string list)
	(context_path : string)
	: bool =

	let retval = ref false in
	let d_cmd = ref "" in
	
	let bridge_input_files = ref "" in
	let bridge_include_dirs = ref "" in
	let bridge_include_dirs_with_prefix = ref "" in
	let bridge_defs = "" in
	let bridge_defs_with_prefix = "" in
	let bridge_container_mount_point = Uberspark_namespace.namespace_bridge_container_mountpoint in
	let bridge_uberspark_plugin_dir = (Uberspark_namespace.get_namespace_root_dir_prefix ()) ^ "/" ^
		Uberspark_namespace.namespace_root ^ "/" ^ Uberspark_namespace.namespace_root_vf_bridge_plugin in

	(* iterate over input file list and build a string *)
	List.iter (fun input_filename -> 
		bridge_input_files := !bridge_input_files ^ " " ^ input_filename;
	) c_file_list;


	(* iterate over include dir list and build include command line options *)
	List.iter (fun include_dir_name -> 
		bridge_include_dirs := !bridge_include_dirs ^ " " ^ include_dir_name;
		(*TBD: get include directory prefix from bridge manifest *)
		bridge_include_dirs_with_prefix := !bridge_include_dirs_with_prefix ^ " -I" ^ include_dir_name;
	) include_dir_list;

	
	(* construct command line using bridge_cmd variable from bridge definition *)
	for li = 0 to (List.length json_node_uberspark_bridge_cc_var.bridge_cmd) - 1 do begin
		let b_cmd = (List.nth json_node_uberspark_bridge_cc_var.bridge_cmd li) in

        let b_cmd_substituted_0 = Str.global_replace (Str.regexp "@@BRIDGE_INPUT_FILES@@") 
                !bridge_input_files b_cmd in
        let b_cmd_substituted_1 = Str.global_replace (Str.regexp "@@BRIDGE_INCLUDE_DIRS@@") 
                !bridge_include_dirs b_cmd_substituted_0 in
        let b_cmd_substituted_2 = Str.global_replace (Str.regexp "@@BRIDGE_INCLUDE_DIRS_WITH_PREFIX@@") 
                !bridge_include_dirs_with_prefix b_cmd_substituted_1 in
        let b_cmd_substituted_3 = Str.global_replace (Str.regexp "@@BRIDGE_DEFS@@") 
                bridge_defs b_cmd_substituted_2 in
        let b_cmd_substituted_4 = Str.global_replace (Str.regexp "@@BRIDGE_DEFS_WITH_PREFIX@@") 
                bridge_defs_with_prefix b_cmd_substituted_3 in
        let b_cmd_substituted_5 = Str.global_replace (Str.regexp "@@BRIDGE_PLUGIN_DIR@@") 
                bridge_uberspark_plugin_dir b_cmd_substituted_4 in
        let b_cmd_substituted_6 = Str.global_replace (Str.regexp "@@BRIDGE_CONTAINER_MOUNT_POINT@@") 
                bridge_container_mount_point b_cmd_substituted_5 in

		let b_cmd_substituted = b_cmd_substituted_6 in

		if li == 0 then begin
			d_cmd := b_cmd_substituted;
		end else begin
			d_cmd := !d_cmd ^ " && " ^ b_cmd_substituted;
		end;

	end done;

	
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "d_cmd=%s" !d_cmd;

	(* construct bridge namespace *)
	let bridge_ns = Uberspark_namespace.namespace_cc_bridge_namespace ^ "/" ^
		json_node_uberspark_bridge_cc_var.json_node_bridge_hdr_var.category ^ "/" ^
		json_node_uberspark_bridge_cc_var.json_node_bridge_hdr_var.dev_environment ^ "/" ^
		json_node_uberspark_bridge_cc_var.json_node_bridge_hdr_var.arch ^ "/" ^
		json_node_uberspark_bridge_cc_var.json_node_bridge_hdr_var.cpu ^ "/" ^
		json_node_uberspark_bridge_cc_var.json_node_bridge_hdr_var.name ^ "/" ^
		json_node_uberspark_bridge_cc_var.json_node_bridge_hdr_var.version in

	(* invoke the compiler *)
	if json_node_uberspark_bridge_cc_var.json_node_bridge_hdr_var.category = "container" then begin
		if ( (Container.run_image ~context_path_builddir:context_path_builddir "." !d_cmd bridge_ns) == 0 ) then begin
			retval := true;
		end else begin
			retval := false;
		end;
	end else begin
		if ( (Native.run_shell_command  ~context_path_builddir:context_path_builddir "." !d_cmd bridge_ns) == 0 ) then begin
			retval := true;
		end else begin
			retval := false;
		end;
	end;

	(!retval)
;;
