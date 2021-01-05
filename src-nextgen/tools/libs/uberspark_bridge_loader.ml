(*===========================================================================*)
(*===========================================================================*)
(* uberSpark bridge module interface implementation -- vf bridge submodule *)
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
	namespace = "uberspark/bridges";
	version_min = "any";
	version_max = "any";
};;

(* uberspark-bridge-cc json node variable *)	
let json_node_uberspark_bridge_loader_var: Uberspark_manifest.Bridge.json_node_uberspark_bridge_t = {
	namespace = "";
	category = "";
	container_build_filename = "";
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

	let rval_json_node_uberspark_bridge_loader_var = Uberspark_manifest.Bridge.Loader.json_node_uberspark_bridge_loader_to_var  
		mf_json json_node_uberspark_bridge_loader_var in

	if rval_json_node_uberspark_bridge_loader_var then begin
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
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "loading loader-bridge settings from file: %s" json_file;

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
	let bridge_ns_json_path = (Uberspark_namespace.get_namespace_root_dir_prefix ()) ^ "/" ^ 
		bridge_ns ^ "/" ^
		Uberspark_namespace.namespace_root_mf_filename in
		(load_from_file bridge_ns_json_path)
;;


let store_to_file 
	(json_file : string)
	: bool =
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "storing loader-bridge settings to file: %s" json_file;

	Uberspark_manifest.write_to_file json_file 
		[
			(Uberspark_manifest.json_node_uberspark_manifest_var_to_jsonstr json_node_uberspark_manifest_var);
			(Uberspark_manifest.Bridge.Loader.json_node_uberspark_bridge_loader_var_to_jsonstr json_node_uberspark_bridge_loader_var);
		];

	(true)
;;


let store 
	()
	: bool =
	let retval = ref false in 
    let bridge_ns = json_node_uberspark_bridge_loader_var.namespace in
	let bridge_ns_json_path = (Uberspark_namespace.get_namespace_root_dir_prefix ()) ^ "/" ^ bridge_ns in
	let bridge_ns_json_filename = bridge_ns_json_path ^ "/" ^ Uberspark_namespace.namespace_root_mf_filename in

	(* make the namespace directory *)
	Uberspark_osservices.mkdir ~parent:true bridge_ns_json_path (`Octal 0o0777);

	retval := store_to_file bridge_ns_json_filename;

	(* check if bridge type is container, if so store dockerfile *)
	if !retval && json_node_uberspark_bridge_loader_var.category = "container" then
		begin
			let input_bridge_dockerfile = json_node_uberspark_bridge_loader_var.container_build_filename in 
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

	if json_node_uberspark_bridge_loader_var.category = "container" then
		begin
			let bridge_ns = json_node_uberspark_bridge_loader_var.namespace in
			let bridge_container_path = (Uberspark_namespace.get_namespace_root_dir_prefix ()) ^ "/" ^ bridge_ns in

			Uberspark_logger.log "building loader-bridge: %s" bridge_ns;

			if (Container.build_image bridge_container_path bridge_ns) == 0 then begin	
				retval := true;
			end else begin
				Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not build loader-bridge!"; 
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





(*
	input is a command line string to run
	the string should basically contain all relevant commands to build the loader
*)

(*let invoke 
	?(gen_obj = true)
	?(context_path_builddir = ".")
	(dummy_arg_0 : string list)
	(dummy_arg_1 : string list)
	(b_cmd : string)
	: bool =

	let retval = ref false in
	let d_cmd = ref "" in
	
	d_cmd := b_cmd;
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "d_cmd=%s" !d_cmd;


	(* construct bridge namespace *)
	let bridge_ns = json_node_uberspark_bridge_loader_var.namespace in

	(* invoke the bridge *)
	if json_node_uberspark_bridge_loader_var.category = "container" then begin
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
;;*)

let invoke 
	?(context_path_builddir = ".")
	(bridge_parameters_assoc_list : (string * string) list)
	: bool =

	let retval = ref false in
	let d_cmd = ref "" in
	
	(* construct command line using bridge_cmd variable from bridge definition *)
	for li = 0 to (List.length json_node_uberspark_bridge_loader_var.bridge_cmd) - 1 do begin
		let b_cmd = ref "" in
		
		b_cmd := List.nth json_node_uberspark_bridge_loader_var.bridge_cmd li;

		(* iterate through bridge parameter list and substitute values *)
		List.iter (fun ( (bridge_parameter_name:string), (bridge_parameter_value:string) )  ->
			b_cmd :=  Str.global_replace (Str.regexp bridge_parameter_name) 
                bridge_parameter_value !b_cmd;
		)bridge_parameters_assoc_list;

		if li == 0 then begin
			d_cmd := !b_cmd;
		end else begin
			d_cmd := !d_cmd ^ " && " ^ !b_cmd;
		end;

	end done;

	
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "d_cmd=%s" !d_cmd;

	(* construct bridge namespace *)
	let bridge_ns = json_node_uberspark_bridge_loader_var.namespace in

	(* invoke the compiler *)
	if json_node_uberspark_bridge_loader_var.category = "container" then begin
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

