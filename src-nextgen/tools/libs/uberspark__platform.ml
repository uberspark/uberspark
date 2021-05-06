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

(* bridge_object variables *)
let cc_bridge : Uberspark.Bridge.bridge_object = new Uberspark.Bridge.bridge_object;;
let as_bridge : Uberspark.Bridge.bridge_object = new Uberspark.Bridge.bridge_object;;
let ld_bridge : Uberspark.Bridge.bridge_object = new Uberspark.Bridge.bridge_object;;
let casm_bridge : Uberspark.Bridge.bridge_object = new Uberspark.Bridge.bridge_object;;
let vf_bridge : Uberspark.Bridge.bridge_object = new Uberspark.Bridge.bridge_object;;
let loader_bridge : Uberspark.Bridge.bridge_object = new Uberspark.Bridge.bridge_object;;




(* manifest variable *)
let manifest_var : Uberspark.Manifest.uberspark_manifest_var_t = Uberspark.Manifest.uberspark_manifest_var_default_value ();;




(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* interface definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)

let load_from_manifest_json 
	?(p_only_configurable = false)
	(p_mf_json : Yojson.Basic.json)
	: bool =

	(Uberspark.Manifest.Platform.json_node_uberspark_platform_to_var ~p_only_configurable:p_only_configurable	
		p_mf_json manifest_var.platform)
;;



let load_from_manifest_file 
	?(p_only_configurable = false)
	(p_manifest_file_abs_path: string)
	: bool =

	let (rval, _) = 
	Uberspark.Manifest.manifest_file_to_uberspark_manifest_var ~p_only_configurable:p_only_configurable 
		p_manifest_file_abs_path manifest_var in
	(rval)
;;


let initialize_from_config () 
	: bool =
	
	let retval = ref false in

	(* handle cc-bridge *)	
	if manifest_var.platform.bridges.cc_bridge_namespace = "" then begin
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "cc_bridge is unspecified";
		(!retval)
	end else

	if not (cc_bridge#load manifest_var.platform.bridges.cc_bridge_namespace) then begin
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "unable to load cc_bridge settings!";
		(!retval)
	end else 

	let dummy = 0 in begin
		Uberspark.Logger.log "loaded cc_bridge settings";
		retval := true;
	end;

	if not (cc_bridge#build ()) then begin
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "unable to build cc_bridge!";
		(!retval)
	end else 

	let dummy = 0 in begin
		Uberspark.Logger.log "cc_bridge build success";
		retval := true;
	end;

	(* handle as-bridge *)	
	if manifest_var.platform.bridges.as_bridge_namespace = "" then begin
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "as_bridge is unspecified";
		(!retval)
	end else

	if not (as_bridge#load manifest_var.platform.bridges.as_bridge_namespace) then begin
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "unable to load as_bridge settings!";
		(!retval)
	end else 

	let dummy = 0 in begin
		Uberspark.Logger.log "loaded as_bridge settings";
		retval := true;
	end;

	if not (as_bridge#build ()) then begin
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "unable to build as_bridge!";
		(!retval)
	end else 

	let dummy = 0 in begin
		Uberspark.Logger.log "as_bridge build success";
		retval := true;
	end;


	(* handle casm as-bridge *)	
	if manifest_var.platform.bridges.casm_bridge_namespace = "" then begin
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "casm as_bridge is unspecified";
		(!retval)
	end else

	if not (casm_bridge#load manifest_var.platform.bridges.casm_bridge_namespace) then begin
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "unable to load casm as_bridge settings!";
		(!retval)
	end else 

	let dummy = 0 in begin
		Uberspark.Logger.log "loaded casm as_bridge settings";
		retval := true;
	end;

	if not (casm_bridge#build ()) then begin
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "unable to build casm as_bridge!";
		(!retval)
	end else 

	let dummy = 0 in begin
		Uberspark.Logger.log "casm as_bridge build success";
		retval := true;
	end;



	(* handle ld-bridge *)	
	if manifest_var.platform.bridges.ld_bridge_namespace = "" then begin
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "ld_bridge is unspecified";
		(!retval)
	end else

	if not (ld_bridge#load manifest_var.platform.bridges.ld_bridge_namespace) then begin
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "unable to load ld_bridge settings!";
		(!retval)
	end else 

	let dummy = 0 in begin
		Uberspark.Logger.log "loaded ld_bridge settings";
		retval := true;
	end;

	if not (ld_bridge#build ()) then begin
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "unable to build ld_bridge!";
		(!retval)
	end else 

	let dummy = 0 in begin
		Uberspark.Logger.log "ld_bridge build success";
		retval := true;
	end;


	(* handle uberspark vf-bridge *)	
	if manifest_var.platform.bridges.uberspark_vf_bridge_namespace = "" then begin
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "uberspark vf_bridge is unspecified";
		(!retval)
	end else

	if not (vf_bridge#load manifest_var.platform.bridges.uberspark_vf_bridge_namespace) then begin
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "unable to load uberspark vf_bridge settings!";
		(!retval)
	end else 

	let dummy = 0 in begin
		Uberspark.Logger.log "loaded uberspark vf_bridge settings";
		retval := true;
	end;

	if not (vf_bridge#build ()) then begin
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "unable to build uberspark vf_bridge!";
		(!retval)
	end else 

	let dummy = 0 in begin
		Uberspark.Logger.log "uberspark vf_bridge build success";
		retval := true;
	end;




	(!retval)
;;





