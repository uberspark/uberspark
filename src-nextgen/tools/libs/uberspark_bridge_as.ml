(*===========================================================================*)
(*===========================================================================*)
(* uberSpark bridge module interface implementation -- as bridge submodule *)
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
	f_manifest_node_types = [ "uberspark-bridge-as" ];
	f_uberspark_min_version = "any";
	f_uberspark_max_version = "any";
};;

(* uberspark-bridge-as json node variable *)	
let json_node_uberspark_bridge_as_var: Uberspark_manifest.Bridge.As.json_node_uberspark_bridge_as_t = {
	json_node_bridge_hdr_var = { btype = "";
				bname = "";
				execname = "";
				path = "";
				devenv = "";
				arch = "";
				cpu = "";
				version = "";
				params = [];
				container_fname = "";
				namespace = "";
	};
	params_prefix_obj = "";
	params_prefix_output = "";
	params_prefix_include = "";
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

	let rval_json_node_uberspark_bridge_as_var = Uberspark_manifest.Bridge.As.json_node_uberspark_bridge_as_to_var  
		mf_json json_node_uberspark_bridge_as_var in

	if rval_json_node_uberspark_bridge_as_var then begin
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
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "loading as-bridge settings from file: %s" json_file;

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
		Uberspark_namespace.namespace_bridge_as_bridge ^ "/" ^ bridge_ns ^ "/" ^
		Uberspark_namespace.namespace_root_mf_filename in
		(load_from_file bridge_ns_json_path)
;;


let store_to_file 
	(json_file : string)
	: bool =
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "storing as-bridge settings to file: %s" json_file;

	Uberspark_manifest.write_to_file json_file 
		[
			(Uberspark_manifest.json_node_uberspark_manifest_var_to_jsonstr json_node_uberspark_manifest_var);
			(Uberspark_manifest.Bridge.As.json_node_uberspark_bridge_as_var_to_jsonstr json_node_uberspark_bridge_as_var);
		];

	(true)
;;


let store 
	()
	: bool =
	let retval = ref false in 
    let bridge_ns = json_node_uberspark_bridge_as_var.json_node_bridge_hdr_var.btype ^ "/" ^
		json_node_uberspark_bridge_as_var.json_node_bridge_hdr_var.devenv ^ "/" ^
		json_node_uberspark_bridge_as_var.json_node_bridge_hdr_var.arch ^ "/" ^
		json_node_uberspark_bridge_as_var.json_node_bridge_hdr_var.cpu ^ "/" ^
		json_node_uberspark_bridge_as_var.json_node_bridge_hdr_var.bname ^ "/" ^
		json_node_uberspark_bridge_as_var.json_node_bridge_hdr_var.version in
	let bridge_ns_json_path = (Uberspark_namespace.get_namespace_root_dir_prefix ()) ^ "/" ^ Uberspark_namespace.namespace_root ^ "/" ^
		Uberspark_namespace.namespace_bridge_as_bridge ^ "/" ^ bridge_ns in
	let bridge_ns_json_filename = bridge_ns_json_path ^ "/" ^
		Uberspark_namespace.namespace_root_mf_filename in

	(* make the namespace directory *)
	Uberspark_osservices.mkdir ~parent:true bridge_ns_json_path (`Octal 0o0777);

	retval := store_to_file bridge_ns_json_filename;

	(* check if bridge type is container, if so store dockerfile *)
	if !retval && json_node_uberspark_bridge_as_var.json_node_bridge_hdr_var.btype = "container" then
		begin
			let input_bridge_dockerfile = json_node_uberspark_bridge_as_var.json_node_bridge_hdr_var.container_fname in 
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

	if json_node_uberspark_bridge_as_var.json_node_bridge_hdr_var.btype = "container" then
		begin
			let bridge_ns = Uberspark_namespace.namespace_bridge_as_bridge ^ "/" ^
				json_node_uberspark_bridge_as_var.json_node_bridge_hdr_var.btype ^ "/" ^
				json_node_uberspark_bridge_as_var.json_node_bridge_hdr_var.devenv ^ "/" ^
				json_node_uberspark_bridge_as_var.json_node_bridge_hdr_var.arch ^ "/" ^
				json_node_uberspark_bridge_as_var.json_node_bridge_hdr_var.cpu ^ "/" ^
				json_node_uberspark_bridge_as_var.json_node_bridge_hdr_var.bname ^ "/" ^
				json_node_uberspark_bridge_as_var.json_node_bridge_hdr_var.version in
			let bridge_container_path = (Uberspark_namespace.get_namespace_root_dir_prefix ()) ^ "/" ^ Uberspark_namespace.namespace_root ^ "/" ^ bridge_ns in

			Uberspark_logger.log "building as-bridge: %s" bridge_ns;

			if (Container.build_image bridge_container_path bridge_ns) == 0 then begin	
				retval := true;
			end else begin
				Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not build as-bridge!"; 
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
	(asm_file_list : string list)
	(include_dir_list : string list)
	(context_path : string)
	: bool =

	let retval = ref false in
	let d_cmd = ref "" in
	let as_includes = ref "" in

	(* iterate over include dir list and build include command line options *)
	List.iter (fun include_dir_name -> 
		as_includes := !as_includes ^ " " ^ json_node_uberspark_bridge_as_var.params_prefix_include ^ include_dir_name;
	) include_dir_list;

	
	(* iterate over the c source files and build command line *)
	for li = 0 to (List.length asm_file_list) - 1 do begin
		let asm_file_name = (List.nth asm_file_list li) in
		
		(* generate compile message *)
		if li == 0 then begin
			d_cmd := !d_cmd ^ "echo Compiling " ^ asm_file_name ^ "..." ^ " && ";
		end else begin
			d_cmd := !d_cmd ^ " && " ^ "echo Compiling " ^ asm_file_name ^ "..." ^ " && ";
		end;

		
		let add_d_cmd = ref "" in
			
			(* include compiler name and default params from bridge hdr *)
			add_d_cmd := !add_d_cmd ^ json_node_uberspark_bridge_as_var.json_node_bridge_hdr_var.execname ^ " ";
			List.iter (fun param ->
				add_d_cmd := !add_d_cmd ^ param ^ " ";
			) json_node_uberspark_bridge_as_var.json_node_bridge_hdr_var.params;

			(* add assembly definition since we are working with assembly files *)
			add_d_cmd := !add_d_cmd ^ " " ^ "-D__ASSEMBLY__" ^ " ";

			(* add includes *)
			add_d_cmd := !add_d_cmd ^ " " ^ !as_includes ^ " ";

			(* select output type based on input parameters *)
			if gen_obj then begin
				add_d_cmd := !add_d_cmd ^ json_node_uberspark_bridge_as_var.params_prefix_obj ^ " ";
			end else begin
				add_d_cmd := !add_d_cmd ^ json_node_uberspark_bridge_as_var.params_prefix_obj ^ " ";
			end;
			
			(* specify output filename based on output type *)
			add_d_cmd := !add_d_cmd ^ asm_file_name ^ " ";
			add_d_cmd := !add_d_cmd ^ json_node_uberspark_bridge_as_var.params_prefix_output ^ " ";

			if gen_obj then begin
				add_d_cmd := !add_d_cmd ^ asm_file_name ^ ".o" ^ " ";
			end else begin
				add_d_cmd := !add_d_cmd ^ asm_file_name ^ ".o" ^ " ";
			end;

			(* construct final compile command for c file *)
			d_cmd := !d_cmd ^ !add_d_cmd;
		
	end done;

	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "d_cmd=%s" !d_cmd;

	(* construct bridge namespace *)
	let bridge_ns = Uberspark_namespace.namespace_bridge_as_bridge ^ "/" ^
		json_node_uberspark_bridge_as_var.json_node_bridge_hdr_var.btype ^ "/" ^
		json_node_uberspark_bridge_as_var.json_node_bridge_hdr_var.devenv ^ "/" ^
		json_node_uberspark_bridge_as_var.json_node_bridge_hdr_var.arch ^ "/" ^
		json_node_uberspark_bridge_as_var.json_node_bridge_hdr_var.cpu ^ "/" ^
		json_node_uberspark_bridge_as_var.json_node_bridge_hdr_var.bname ^ "/" ^
		json_node_uberspark_bridge_as_var.json_node_bridge_hdr_var.version in

	(* invoke the compiler *)
	if json_node_uberspark_bridge_as_var.json_node_bridge_hdr_var.btype = "container" then begin
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
