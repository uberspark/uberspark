(*------------------------------------------------------------------------------
	uberSpark uberobject collection verification and build interface implementation
	author: amit vasudevan (amitvasudevan@acm.org)
------------------------------------------------------------------------------*)

open Str

type uobjcoll_uobjinfo_t =
{
	mutable f_uobj_name    : string;			
	mutable f_uobj_ns	   : string;
	mutable f_is_intrauobj : bool;
	mutable f_uobj_path	   : string;
};;


let d_mf_filename = ref "";;
let d_path_to_mf_filename = ref "";;
let d_path_ns = ref "";;
let d_hdr: Uberspark_manifest.Uobjcoll.uobjcoll_hdr_t = {f_namespace = ""; f_platform = ""; f_arch = ""; f_cpu = ""};;


(*--------------------------------------------------------------------------*)
(* parse uobjcoll manifest *)
(* uobjcoll_mf_filename = uobj collection manifest filename *)
(*--------------------------------------------------------------------------*)
let parse_manifest 
	(uobjcoll_mf_filename : string)
	: bool =


	(* store filename and uobjcoll path to filename *)
	d_mf_filename := Filename.basename uobjcoll_mf_filename;
	d_path_to_mf_filename := Filename.dirname uobjcoll_mf_filename;
	
	(* read manifest JSON *)
	let (rval, mf_json) = Uberspark_manifest.get_manifest_json uobjcoll_mf_filename in
	
	if (rval == false) then (false)
	else

	(* parse uobjcoll-hdr node *)
	let rval = (Uberspark_manifest.Uobjcoll.parse_uobjcoll_hdr mf_json d_hdr ) in
	if (rval == false) then (false)
	else

	let dummy=0 in begin
		d_path_ns := !Uberspark_namespace.namespace_root_dir  ^ "/" ^ d_hdr.f_namespace;
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "uobj collection path ns=%s" !d_path_ns;
	end;

	(* parse, load and overlay config-settings node, if one is present *)
	if (Uberspark_config.load_from_json mf_json) then begin
		Uberspark_logger.log "loaded and overlaid config-settings from uobjcoll manifest for uobjcoll build";
	end else begin
		Uberspark_logger.log "using default config for uobjcoll build";
    end;


	(true)
;;


(*--------------------------------------------------------------------------*)
(* crate uobjcoll installation namespace *)
(*--------------------------------------------------------------------------*)
let install_create_ns 
	()
	: unit =
	
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "d_path_ns=%s" !d_path_ns;
	
	(* make namespace folder if not already existing *)
	Uberspark_osservices.mkdir ~parent:true !d_path_ns (`Octal 0o0777);
;;




let build
	(uobjcoll_path_ns : string)
	(target_def : Defs.Basedefs.target_def_t)
	: bool =

	(* local variables *)
	let retval = ref false in
	let in_namespace_build = ref false in

	let dummy = 0 in begin
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "uobj collection build start...";
	end;

	(* get uobj collection absolute path *)
	let (rval, abs_uobjcoll_path) = (Uberspark_osservices.abspath uobjcoll_path_ns) in
	if(rval == false) then begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not obtain absolute path for uobjcoll: %s" abs_uobjcoll_path;
		(!retval)
	end else

	(* switch working directory to uobjcoll_path *)
	let (rval, r_prevpath, r_curpath) = (Uberspark_osservices.dir_change abs_uobjcoll_path) in
	if(rval == false) then begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not switch to uobjcoll path: %s" abs_uobjcoll_path;
		(!retval)
	end else

	let dummy = 0 in begin

	(* create _build folder *)
	Uberspark_osservices.mkdir ~parent:true Uberspark_namespace.namespace_uobjcoll_build_dir (`Octal 0o0777);

	(* check to see if we are doing an in-namespace build or an out-of-namespace build *)
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "namespace root=%s" (!Uberspark_namespace.namespace_root_dir ^ "/" ^ Uberspark_namespace.namespace_root ^ "/");
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "abs_uobjcoll_path_ns=%s" (abs_uobjcoll_path);
	
	in_namespace_build := (Uberspark_namespace.is_uobj_uobjcoll_abspath_in_namespace abs_uobjcoll_path);
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "in_namespace_build=%B" !in_namespace_build;
	end;

    (* parse uobjcoll manifest *)
	let uobjcoll_mf_filename = (abs_uobjcoll_path ^ "/" ^ Uberspark_namespace.namespace_uobjcoll_mf_filename) in
	let rval = (parse_manifest uobjcoll_mf_filename) in	
    if (rval == false) then	begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "unable to stat/parse manifest for uobjcoll: %s" uobjcoll_mf_filename;
		(!retval)
	end else

	let dummy = 0 in begin

	Uberspark_logger.log "successfully parsed uobjcoll manifest";
	end;

	(* install headers if we are doing an out-of-namespace build *)
	if not !in_namespace_build then begin
	    Uberspark_logger.log "prepping for out-of-namespace build...";
		install_create_ns ();
		(*TBD: install h_files *)
	    Uberspark_logger.log "ready for out-of-namespace build";
	end;


	let dummy = 0 in begin

	(* restore working directory *)
	ignore(Uberspark_osservices.dir_change r_prevpath);
	Uberspark_logger.log "cleaned up build workspace";
	retval := true;
	end;

	(!retval)
;;
