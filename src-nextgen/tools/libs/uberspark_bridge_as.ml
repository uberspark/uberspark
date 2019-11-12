(****************************************************************************)
(****************************************************************************)
(* uberSpark bridge module interface implementation -- as bridge submodule *)
(*	 author: amit vasudevan (amitvasudevan@acm.org) *)
(****************************************************************************)
(****************************************************************************)

open Unix
open Yojson

(****************************************************************************)
(* as-bridge data variables *)
(****************************************************************************)

(* bridge-as uberspark header node variable *)	
let uberspark_hdr: Uberspark_manifest.hdr_t = {
	f_coss_version = "any";
	f_mftype = "bridge";
	f_uberspark_min_version = "any";
	f_uberspark_max_version = "any";
};;

(* bridge-as node variable *)	
let bridge_as : Uberspark_manifest.Bridge.bridge_as_t = {
	bridge_hdr = { btype = "";
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


(****************************************************************************)
(* as-bridge interfaces *)
(****************************************************************************)


let load_from_json
	(json_node : Yojson.Basic.json)
	: bool =

	let retval = ref false in

	let rval_uberspark_hdr = Uberspark_manifest.parse_uberspark_hdr json_node uberspark_hdr in
	let rval_bridge_as = Uberspark_manifest.Bridge.parse_bridge_as json_node bridge_as in

	if rval_bridge_as && rval_uberspark_hdr then
		begin
			(* TBD: sanity check input mftype and override with bridge only if permissible *)
			(* e.g., if existing mftype is top-level *)
			uberspark_hdr.f_mftype <- "bridge";
			retval := true;
		end
	else
		begin
			retval := false;
		end
	;

	(!retval)
;;


let load_from_file 
	(json_file : string)
	: bool =
	let retval = ref false in
	Uberspark_logger.log "loading as-bridge settings from file: %s" json_file;


	let (rval, bridge_as_json) = Uberspark_manifest.get_manifest_json json_file in
	if rval then
		begin
			retval := load_from_json bridge_as_json;
		end
	else
		begin
			retval := false;
		end
	;

	(!retval)
;;


let load 
	(bridge_ns : string)
	: bool =
	let bridge_ns_json_path = !Uberspark_config.namespace_root_dir ^ "/" ^ Uberspark_config.namespace_root ^ "/" ^
		Uberspark_config.namespace_bridge_as_bridge ^ "/" ^ bridge_ns ^ "/" ^
		Uberspark_config.namespace_bridge_mf_filename in
		(load_from_file bridge_ns_json_path)
;;


let store_to_file 
	(json_file : string)
	: bool =
	let retval = ref false in
	Uberspark_logger.log "storing as-bridge settings to file: %s" json_file;

	let oc = open_out json_file in

		Uberspark_manifest.write_prologue ~prologue_str:"uberSpark as-bridge manifest" oc;
		Uberspark_manifest.write_uberspark_hdr oc uberspark_hdr;
		Uberspark_manifest.Bridge.write_bridge_as ~continuation:false oc bridge_as;
		Uberspark_manifest.write_epilogue oc;

	close_out oc;	

	retval := true;
	(!retval)
;;


let store 
	()
	: bool =
	let retval = ref false in 
    let bridge_ns = bridge_as.bridge_hdr.btype ^ "/" ^
		bridge_as.bridge_hdr.devenv ^ "/" ^
		bridge_as.bridge_hdr.arch ^ "/" ^
		bridge_as.bridge_hdr.cpu ^ "/" ^
		bridge_as.bridge_hdr.bname ^ "/" ^
		bridge_as.bridge_hdr.version in
	let bridge_ns_json_path = !Uberspark_config.namespace_root_dir ^ "/" ^ Uberspark_config.namespace_root ^ "/" ^
		Uberspark_config.namespace_bridge_as_bridge ^ "/" ^ bridge_ns in
	let bridge_ns_json_filename = bridge_ns_json_path ^ "/" ^
		Uberspark_config.namespace_bridge_mf_filename in

	(* make the namespace directory *)
	Uberspark_osservices.mkdir ~parent:true bridge_ns_json_path (`Octal 0o0777);

	retval := store_to_file bridge_ns_json_filename;

	(* check if bridge type is container, if so store dockerfile *)
	if !retval && bridge_as.bridge_hdr.btype = "container" then
		begin
			let input_bridge_dockerfile = bridge_as.bridge_hdr.container_fname in 
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

	if bridge_as.bridge_hdr.btype = "container" then
		begin
			let bridge_ns = Uberspark_config.namespace_bridge_as_bridge ^ "/" ^
				bridge_as.bridge_hdr.btype ^ "/" ^
				bridge_as.bridge_hdr.devenv ^ "/" ^
				bridge_as.bridge_hdr.arch ^ "/" ^
				bridge_as.bridge_hdr.cpu ^ "/" ^
				bridge_as.bridge_hdr.bname ^ "/" ^
				bridge_as.bridge_hdr.version in
			let bridge_container_path = !Uberspark_config.namespace_root_dir ^ "/" ^ Uberspark_config.namespace_root ^ "/" ^ bridge_ns in

			Uberspark_logger.log "building as-bridge: %s" bridge_ns;

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
	(asm_file_list : string list)
	(include_dir_list : string list)
	(context_path : string)
	: bool =

	let retval = ref false in
	let d_cmd = ref "" in
	let as_includes = ref "" in

	(* iterate over include dir list and build include command line options *)
	List.iter (fun include_dir_name -> 
		as_includes := !as_includes ^ " " ^ bridge_as.params_prefix_include ^ include_dir_name;
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
			add_d_cmd := !add_d_cmd ^ bridge_as.bridge_hdr.execname ^ " ";
			List.iter (fun param ->
				add_d_cmd := !add_d_cmd ^ param ^ " ";
			) bridge_as.bridge_hdr.params;

			(* add includes *)
			add_d_cmd := !add_d_cmd ^ " " ^ !as_includes ^ " ";

			(* select output type based on input parameters *)
			if gen_obj then begin
				add_d_cmd := !add_d_cmd ^ bridge_as.params_prefix_obj ^ " ";
			end else begin
				add_d_cmd := !add_d_cmd ^ bridge_as.params_prefix_obj ^ " ";
			end;
			
			(* specify output filename based on output type *)
			add_d_cmd := !add_d_cmd ^ asm_file_name ^ " ";
			add_d_cmd := !add_d_cmd ^ bridge_as.params_prefix_output ^ " ";

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
	let bridge_ns = Uberspark_config.namespace_bridge_as_bridge ^ "/" ^
		bridge_as.bridge_hdr.btype ^ "/" ^
		bridge_as.bridge_hdr.devenv ^ "/" ^
		bridge_as.bridge_hdr.arch ^ "/" ^
		bridge_as.bridge_hdr.cpu ^ "/" ^
		bridge_as.bridge_hdr.bname ^ "/" ^
		bridge_as.bridge_hdr.version in

	(* invoke the compiler *)
	if bridge_as.bridge_hdr.btype = "container" then begin
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
