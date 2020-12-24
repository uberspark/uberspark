(*===========================================================================*)
(*===========================================================================*)
(* uberSpark bridge module interface implementation -- ld bridge submodule *)
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
let json_node_uberspark_bridge_ld_var: Uberspark_manifest.Bridge.Ld.json_node_uberspark_bridge_ld_t = {
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
	params_prefix_lscript = "";
	params_prefix_libdir = "";
	params_prefix_lib = "";
	params_prefix_output = "";
	cmd_generate_flat_binary = "";
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

	let rval_json_node_uberspark_bridge_ld_var = Uberspark_manifest.Bridge.Ld.json_node_uberspark_bridge_ld_to_var  
		mf_json json_node_uberspark_bridge_ld_var in

	if rval_json_node_uberspark_bridge_ld_var then begin
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
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "loading ld-bridge settings from file: %s" json_file;

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
		Uberspark_namespace.namespace_ld_bridge_namespace ^ "/" ^ bridge_ns ^ "/" ^
		Uberspark_namespace.namespace_root_mf_filename in
		(load_from_file bridge_ns_json_path)
;;


let store_to_file 
	(json_file : string)
	: bool =
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "storing ld-bridge settings to file: %s" json_file;

	Uberspark_manifest.write_to_file json_file 
		[
			(Uberspark_manifest.json_node_uberspark_manifest_var_to_jsonstr json_node_uberspark_manifest_var);
			(Uberspark_manifest.Bridge.Ld.json_node_uberspark_bridge_ld_var_to_jsonstr json_node_uberspark_bridge_ld_var);
		];

	(true)
;;


let store 
	()
	: bool =
	let retval = ref false in 
    let bridge_ns = json_node_uberspark_bridge_ld_var.json_node_bridge_hdr_var.category ^ "/" ^
		json_node_uberspark_bridge_ld_var.json_node_bridge_hdr_var.dev_environment ^ "/" ^
		json_node_uberspark_bridge_ld_var.json_node_bridge_hdr_var.arch ^ "/" ^
		json_node_uberspark_bridge_ld_var.json_node_bridge_hdr_var.cpu ^ "/" ^
		json_node_uberspark_bridge_ld_var.json_node_bridge_hdr_var.name ^ "/" ^
		json_node_uberspark_bridge_ld_var.json_node_bridge_hdr_var.version in
	let bridge_ns_json_path = (Uberspark_namespace.get_namespace_root_dir_prefix ()) ^ "/" ^ Uberspark_namespace.namespace_root ^ "/" ^
		Uberspark_namespace.namespace_ld_bridge_namespace ^ "/" ^ bridge_ns in
	let bridge_ns_json_filename = bridge_ns_json_path ^ "/" ^
		Uberspark_namespace.namespace_root_mf_filename in

	(* make the namespace directory *)
	Uberspark_osservices.mkdir ~parent:true bridge_ns_json_path (`Octal 0o0777);

	retval := store_to_file bridge_ns_json_filename;

	(* check if bridge type is container, if so store dockerfile *)
	if !retval && json_node_uberspark_bridge_ld_var.json_node_bridge_hdr_var.category = "container" then
		begin
			let input_bridge_dockerfile = json_node_uberspark_bridge_ld_var.json_node_bridge_hdr_var.container_filename in 
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

	if json_node_uberspark_bridge_ld_var.json_node_bridge_hdr_var.category = "container" then
		begin
			let bridge_ns = Uberspark_namespace.namespace_ld_bridge_namespace ^ "/" ^
				json_node_uberspark_bridge_ld_var.json_node_bridge_hdr_var.category ^ "/" ^
				json_node_uberspark_bridge_ld_var.json_node_bridge_hdr_var.dev_environment ^ "/" ^
				json_node_uberspark_bridge_ld_var.json_node_bridge_hdr_var.arch ^ "/" ^
				json_node_uberspark_bridge_ld_var.json_node_bridge_hdr_var.cpu ^ "/" ^
				json_node_uberspark_bridge_ld_var.json_node_bridge_hdr_var.name ^ "/" ^
				json_node_uberspark_bridge_ld_var.json_node_bridge_hdr_var.version in
			let bridge_container_path = (Uberspark_namespace.get_namespace_root_dir_prefix ()) ^ "/" ^ Uberspark_namespace.namespace_root ^ "/" ^ bridge_ns in

			Uberspark_logger.log "building ld-bridge: %s" bridge_ns;

			if (Container.build_image bridge_container_path bridge_ns) == 0 then begin	
				retval := true;
			end else begin
				Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not build ld-bridge!"; 
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
	?(context_path_builddir = ".")
	(lscript_filename : string)
	(binary_filename : string)
	(binary_flat_filename : string)
	(o_file_list : string list)
	(lib_dir_list : string list)
	(lib_file_list : string list)
	(lib_abs_list : string list)
	(context_path : string)
	: bool =

	let retval = ref false in
	let d_cmd = ref "" in
	let cc_includes = ref "" in

	(* add linker executable and base parameters *)
	d_cmd := json_node_uberspark_bridge_ld_var.json_node_bridge_hdr_var.executable_name;
	List.iter (fun param ->
		d_cmd := !d_cmd ^ " " ^ param ^ " ";
	) json_node_uberspark_bridge_ld_var.json_node_bridge_hdr_var.parameters;


	(* iterate over object file list and include them into linker command line *)
	List.iter (fun o_filename -> 
		d_cmd := !d_cmd ^ " " ^ o_filename;
	) o_file_list;

	(* add linker script option and filename*)
 	d_cmd := !d_cmd ^ " " ^ json_node_uberspark_bridge_ld_var.params_prefix_lscript ^ " " ^ lscript_filename;

	(* add output filename *)
	d_cmd := !d_cmd ^ " " ^ json_node_uberspark_bridge_ld_var.params_prefix_output ^ " " ^ binary_filename;

	(* iterate over lib dir list and include them into linker command line *)
	List.iter (fun lib_dir -> 
		d_cmd := !d_cmd ^ " " ^ json_node_uberspark_bridge_ld_var.params_prefix_libdir ^ " " ^ lib_dir;
	) lib_dir_list;

	(* iterate over lib file list and include them into linker command line *)
	List.iter (fun lib_file -> 
		d_cmd := !d_cmd ^ " " ^ json_node_uberspark_bridge_ld_var.params_prefix_lib ^ lib_file;
	) lib_file_list;

	(* iterate over libraries provided with absolute pathnames *)
	List.iter (fun lib_abs_filename -> 
		d_cmd := !d_cmd ^ " " ^ lib_abs_filename;
	) lib_abs_list;

	(* add flat binary output generation command *)
 	d_cmd := !d_cmd ^ " " ^ " && " ^ json_node_uberspark_bridge_ld_var.cmd_generate_flat_binary ^ " "  ^
	 		binary_filename ^ " " ^ binary_flat_filename;


	(* construct bridge namespace *)
	let bridge_ns = Uberspark_namespace.namespace_ld_bridge_namespace ^ "/" ^
		json_node_uberspark_bridge_ld_var.json_node_bridge_hdr_var.category ^ "/" ^
		json_node_uberspark_bridge_ld_var.json_node_bridge_hdr_var.dev_environment ^ "/" ^
		json_node_uberspark_bridge_ld_var.json_node_bridge_hdr_var.arch ^ "/" ^
		json_node_uberspark_bridge_ld_var.json_node_bridge_hdr_var.cpu ^ "/" ^
		json_node_uberspark_bridge_ld_var.json_node_bridge_hdr_var.name ^ "/" ^
		json_node_uberspark_bridge_ld_var.json_node_bridge_hdr_var.version in


	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "d_cmd=%s" !d_cmd;

	(* invoke the linker *)
	if json_node_uberspark_bridge_ld_var.json_node_bridge_hdr_var.category = "container" then begin
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
