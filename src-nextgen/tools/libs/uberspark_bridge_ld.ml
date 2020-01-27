(****************************************************************************)
(****************************************************************************)
(* uberSpark bridge module interface implementation -- ld bridge submodule *)
(*	 author: amit vasudevan (amitvasudevan@acm.org) *)
(****************************************************************************)
(****************************************************************************)

open Unix
open Yojson

(****************************************************************************)
(* ld-bridge data variables *)
(****************************************************************************)

(* bridge-ld uberspark header node variable *)	
let uberspark_hdr: Uberspark_manifest.hdr_t = {
	f_coss_version = "any";
	f_mftype = "bridge";
	f_uberspark_min_version = "any";
	f_uberspark_max_version = "any";
};;

(* bridge-ld node variable *)	
let bridge_ld : Uberspark_manifest.Bridge.bridge_ld_t = {
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
	params_prefix_lscript = "";
	params_prefix_libdir = "";
	params_prefix_lib = "";
	params_prefix_output = "";

};;


(****************************************************************************)
(* ld-bridge interfaces *)
(****************************************************************************)


let load_from_json
	(json_node : Yojson.Basic.json)
	: bool =

	let retval = ref false in

	let rval_uberspark_hdr = Uberspark_manifest.parse_uberspark_hdr json_node uberspark_hdr in
	let rval_bridge_ld = Uberspark_manifest.Bridge.parse_bridge_ld json_node bridge_ld in

	if rval_bridge_ld && rval_uberspark_hdr then
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
	Uberspark_logger.log "loading ld-bridge settings from file: %s" json_file;


	let (rval, bridge_ld_json) = Uberspark_manifest.get_manifest_json json_file in
	if rval then
		begin
			retval := load_from_json bridge_ld_json;
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
	let bridge_ns_json_path = (Uberspark_namespace.get_namespace_root_dir_prefix ()) ^ "/" ^ Uberspark_namespace.namespace_root ^ "/" ^
		Uberspark_namespace.namespace_bridge_ld_bridge ^ "/" ^ bridge_ns ^ "/" ^
		Uberspark_namespace.namespace_bridge_mf_filename in
		(load_from_file bridge_ns_json_path)
;;


let store_to_file 
	(json_file : string)
	: bool =
	let retval = ref false in
	Uberspark_logger.log "storing ld-bridge settings to file: %s" json_file;

	let oc = open_out json_file in

		Uberspark_manifest.write_prologue ~prologue_str:"uberSpark ld-bridge manifest" oc;
		Uberspark_manifest.write_uberspark_hdr oc uberspark_hdr;
		Uberspark_manifest.Bridge.write_bridge_ld ~continuation:false oc bridge_ld;
		Uberspark_manifest.write_epilogue oc;

	close_out oc;	

	retval := true;
	(!retval)
;;


let store 
	()
	: bool =
	let retval = ref false in 
    let bridge_ns = bridge_ld.bridge_hdr.btype ^ "/" ^
		bridge_ld.bridge_hdr.devenv ^ "/" ^
		bridge_ld.bridge_hdr.arch ^ "/" ^
		bridge_ld.bridge_hdr.cpu ^ "/" ^
		bridge_ld.bridge_hdr.bname ^ "/" ^
		bridge_ld.bridge_hdr.version in
	let bridge_ns_json_path = (Uberspark_namespace.get_namespace_root_dir_prefix ()) ^ "/" ^ Uberspark_namespace.namespace_root ^ "/" ^
		Uberspark_namespace.namespace_bridge_ld_bridge ^ "/" ^ bridge_ns in
	let bridge_ns_json_filename = bridge_ns_json_path ^ "/" ^
		Uberspark_namespace.namespace_bridge_mf_filename in

	(* make the namespace directory *)
	Uberspark_osservices.mkdir ~parent:true bridge_ns_json_path (`Octal 0o0777);

	retval := store_to_file bridge_ns_json_filename;

	(* check if bridge type is container, if so store dockerfile *)
	if !retval && bridge_ld.bridge_hdr.btype = "container" then
		begin
			let input_bridge_dockerfile = bridge_ld.bridge_hdr.container_fname in 
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

	if bridge_ld.bridge_hdr.btype = "container" then
		begin
			let bridge_ns = Uberspark_namespace.namespace_bridge_ld_bridge ^ "/" ^
				bridge_ld.bridge_hdr.btype ^ "/" ^
				bridge_ld.bridge_hdr.devenv ^ "/" ^
				bridge_ld.bridge_hdr.arch ^ "/" ^
				bridge_ld.bridge_hdr.cpu ^ "/" ^
				bridge_ld.bridge_hdr.bname ^ "/" ^
				bridge_ld.bridge_hdr.version in
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
	(output_filename : string)
	(o_file_list : string list)
	(lib_file_list : string list)
	(lib_dir_list : string list)
	(context_path : string)
	: bool =

	let retval = ref false in
	let d_cmd = ref "" in
	let cc_includes = ref "" in

	(* add linker executable and base parameters *)
	d_cmd := bridge_ld.bridge_hdr.execname;
	List.iter (fun param ->
		d_cmd := !d_cmd ^ " " ^ param ^ " ";
	) bridge_ld.bridge_hdr.params;


	(* add linker script option and filename*)
 	d_cmd := !d_cmd ^ " " ^ bridge_ld.params_prefix_lscript ^ " " ^ lscript_filename;

	(* iterate over object file list and include them into linker command line *)
	List.iter (fun o_filename -> 
		d_cmd := !d_cmd ^ " " ^ o_filename;
	) o_file_list;

	(* iterate over lib dir list and include them into linker command line *)
	List.iter (fun lib_dir -> 
		d_cmd := !d_cmd ^ " " ^ bridge_ld.params_prefix_libdir ^ " " ^ lib_dir;
	) lib_dir_list;

	(* iterate over lib file list and include them into linker command line *)
	List.iter (fun lib_file -> 
		d_cmd := !d_cmd ^ " " ^ bridge_ld.params_prefix_lib ^ lib_file;
	) lib_file_list;

	(* add output filename *)
	d_cmd := !d_cmd ^ " " ^ bridge_ld.params_prefix_output ^ " " ^ output_filename;

	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "d_cmd=%s" !d_cmd;

	(* construct bridge namespace *)
	let bridge_ns = Uberspark_namespace.namespace_bridge_ld_bridge ^ "/" ^
		bridge_ld.bridge_hdr.btype ^ "/" ^
		bridge_ld.bridge_hdr.devenv ^ "/" ^
		bridge_ld.bridge_hdr.arch ^ "/" ^
		bridge_ld.bridge_hdr.cpu ^ "/" ^
		bridge_ld.bridge_hdr.bname ^ "/" ^
		bridge_ld.bridge_hdr.version in

	(* invoke the linker *)
	if bridge_ld.bridge_hdr.btype = "container" then begin
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
