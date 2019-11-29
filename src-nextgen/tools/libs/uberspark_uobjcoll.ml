(*------------------------------------------------------------------------------
	uberSpark uberobject collection verification and build interface implementation
	author: amit vasudevan (amitvasudevan@acm.org)
------------------------------------------------------------------------------*)

open Str

type uobjcoll_uobjinfo_t =
{
	mutable f_uobj_name    			: string;			
	mutable f_uobj_ns				: string;
	mutable f_uobj_srcpath	   		: string;
	mutable f_uobj_buildpath 		: string;
	mutable f_uobj_nspath 			: string; 
	mutable f_uobj_is_incollection 	: bool;
	mutable f_uobj_is_prime 	   	: bool;
	mutable f_uobj_load_address		: int;
	mutable f_uobj_size				: int;
};;


let d_mf_filename = ref "";;
let d_path_to_mf_filename = ref "";;
let d_path_ns = ref "";;
let d_hdr: Uberspark_manifest.Uobjcoll.uobjcoll_hdr_t = {f_namespace = ""; f_platform = ""; f_arch = ""; f_cpu = ""};;

let d_uobjcoll_uobjs_mf_node : Uberspark_manifest.Uobjcoll.uobjcoll_uobjs_t = {f_prime_uobj_ns = ""; f_templar_uobjs = []};;

let d_uobjcoll_uobjinfo : uobjcoll_uobjinfo_t list ref = ref [];;

let d_load_address : int ref = ref 0;;
let d_size : int ref = ref 0;;



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

	(* parse uobjcoll-uobjs node *)
	let rval = (Uberspark_manifest.Uobjcoll.parse_uobjcoll_uobjs mf_json d_uobjcoll_uobjs_mf_node ) in
	if (rval == false) then (false)
	else

	let dummy=0 in begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "uobj collection uobjs=%u" (List.length d_uobjcoll_uobjs_mf_node.f_templar_uobjs);
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



(*--------------------------------------------------------------------------*)
(* initialize basic info for all uobjs within the collection *)
(*--------------------------------------------------------------------------*)
let initialize_uobjs_baseinfo 
	(uobjcoll_abs_path : string)
	(uobjcoll_builddir : string)
	: bool =

	let retval = ref false in

	(* if the uobjcoll has a prime uobj, add it to uobjcoll_uobjinfo first *)
	if not (d_uobjcoll_uobjs_mf_node.f_prime_uobj_ns = "") then begin
		
			let (rval, uobj_name, uobjcoll_name) = (Uberspark_namespace.get_uobj_uobjcoll_name_from_uobj_ns d_uobjcoll_uobjs_mf_node.f_prime_uobj_ns) in
			if (rval) then begin
				let uobjinfo_entry : uobjcoll_uobjinfo_t = { f_uobj_name = ""; f_uobj_ns = "";  
					f_uobj_srcpath = ""; f_uobj_buildpath = ""; f_uobj_nspath = "" ; f_uobj_is_incollection = false; 
					f_uobj_is_prime  = false; f_uobj_load_address = 0; f_uobj_size = 0;} in

				uobjinfo_entry.f_uobj_name <- uobj_name;
				uobjinfo_entry.f_uobj_ns <- d_uobjcoll_uobjs_mf_node.f_prime_uobj_ns;
				uobjinfo_entry.f_uobj_is_prime <- true;
				uobjinfo_entry.f_uobj_buildpath <- (uobjcoll_abs_path ^ "/" ^ uobjcoll_builddir ^ "/" ^ uobj_name);
				uobjinfo_entry.f_uobj_nspath <- (!Uberspark_namespace.namespace_root_dir ^ "/" ^ d_uobjcoll_uobjs_mf_node.f_prime_uobj_ns);

				if (Uberspark_namespace.is_uobj_ns_in_uobjcoll_ns d_uobjcoll_uobjs_mf_node.f_prime_uobj_ns
					d_hdr.f_namespace) then begin
					uobjinfo_entry.f_uobj_is_incollection <- true;
				end else begin
					uobjinfo_entry.f_uobj_is_incollection <- false;
				end;

				if uobjinfo_entry.f_uobj_is_incollection then begin
					uobjinfo_entry.f_uobj_srcpath <- (uobjcoll_abs_path ^ "/" ^ uobj_name);
				end else begin
					uobjinfo_entry.f_uobj_srcpath <- (!Uberspark_namespace.namespace_root_dir ^ "/" ^ d_uobjcoll_uobjs_mf_node.f_prime_uobj_ns);
				end;

				d_uobjcoll_uobjinfo := !d_uobjcoll_uobjinfo @ [ uobjinfo_entry ];

				retval := true;
			end else begin
				retval := false;
			end;

	end else begin
		(* there is no prime uobj, we still might have templars *)
		retval := true;
	end;

	if (!retval == false) then (false)
	else

	(* process templar uobjs within the collection *)
	let dummy = 0 in begin
	List.iter (fun templar_uobj_ns ->

			let (rval, uobj_name, uobjcoll_name) = (Uberspark_namespace.get_uobj_uobjcoll_name_from_uobj_ns templar_uobj_ns) in
			if (rval) then begin
				let uobjinfo_entry : uobjcoll_uobjinfo_t = { f_uobj_name = ""; f_uobj_ns = "";  
					f_uobj_srcpath = ""; f_uobj_buildpath = "";  f_uobj_nspath = "" ; f_uobj_is_incollection = false; 
					f_uobj_is_prime  = false; f_uobj_load_address = 0; f_uobj_size = 0;} in

				uobjinfo_entry.f_uobj_name <- uobj_name;
				uobjinfo_entry.f_uobj_ns <- templar_uobj_ns;
				uobjinfo_entry.f_uobj_is_prime <- false;
				uobjinfo_entry.f_uobj_buildpath <- (uobjcoll_abs_path ^ "/" ^ uobjcoll_builddir ^ "/" ^ uobj_name);
				uobjinfo_entry.f_uobj_nspath <- (!Uberspark_namespace.namespace_root_dir ^ "/" ^ templar_uobj_ns);

				if (Uberspark_namespace.is_uobj_ns_in_uobjcoll_ns templar_uobj_ns d_hdr.f_namespace) then begin
					uobjinfo_entry.f_uobj_is_incollection <- true;
				end else begin
					uobjinfo_entry.f_uobj_is_incollection <- false;
				end;

				if uobjinfo_entry.f_uobj_is_incollection then begin
					uobjinfo_entry.f_uobj_srcpath <- (uobjcoll_abs_path ^ "/" ^ uobj_name);
				end else begin
					uobjinfo_entry.f_uobj_srcpath <- (!Uberspark_namespace.namespace_root_dir ^ "/" ^ templar_uobj_ns);
				end;

				d_uobjcoll_uobjinfo := !d_uobjcoll_uobjinfo @ [ uobjinfo_entry ];

				retval := true;
			end else begin
				retval := false;
			end;

	) d_uobjcoll_uobjs_mf_node.f_templar_uobjs;
	end;

	if (!retval == false) then (false)
	else

	let dummy=0 in begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "collect_uobjinfo: total collection uobjs=%u" (List.length !d_uobjcoll_uobjinfo);
	end;

	(true)
;;



(*--------------------------------------------------------------------------*)
(* compute load address and size for all uobjs within the collection *)
(*--------------------------------------------------------------------------*)
let compute_uobjs_load_address_and_size
	()
	: unit = 
	
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "%s: d_load_address=0x%08x" __LOC__ !d_load_address;

	let curr_load_address = ref 0 in
	curr_load_address := !d_load_address;

	List.iter ( fun (uobjinfo_entry : uobjcoll_uobjinfo_t) -> 
		uobjinfo_entry.f_uobj_load_address <- !curr_load_address;
	)!d_uobjcoll_uobjinfo;

;;



(*--------------------------------------------------------------------------*)
(* prepare uobjcoll namespace for build *)
(*--------------------------------------------------------------------------*)
let prepare_namespace_for_build
	(abs_uobjcoll_path : string)
	: bool =

	(* local variables *)
	let retval = ref false in
	let in_namespace_build = ref false in
	let uobjcoll_canonical_namespace = d_hdr.f_namespace in
	let uobjcoll_canonical_namespace_path = (!Uberspark_namespace.namespace_root_dir ^ "/" ^ uobjcoll_canonical_namespace) in

	(* determine if we are doing an in-namespace build or an out-of-namespace build *)
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "namespace root=%s" (!Uberspark_namespace.namespace_root_dir ^ "/" ^ Uberspark_namespace.namespace_root ^ "/");
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "abs_uobjcoll_path_ns=%s" (abs_uobjcoll_path);
	in_namespace_build := (Uberspark_namespace.is_uobj_uobjcoll_abspath_in_namespace abs_uobjcoll_path);
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "in_namespace_build=%B" !in_namespace_build;

	(* if we are doing an out-of-namespace build, then create canonical namespace and copy uobjcoll uobjs headers*)
	if not !in_namespace_build then begin
	    Uberspark_logger.log "prepping for out-of-namespace build...";
		(* create uobjcoll canonical namespace *)
		install_create_ns ();

		(* copy all intra uobjs include headers to uobjcoll canonical namespace *)
		(* TBS: only copy headers listed in the uobj manifest *)
		List.iter ( fun (uobjinfo_entry : uobjcoll_uobjinfo_t) -> 
			if uobjinfo_entry.f_uobj_is_incollection then begin
				Uberspark_osservices.mkdir ~parent:true (uobjcoll_canonical_namespace_path ^ "/" ^ uobjinfo_entry.f_uobj_name ^ "/include") (`Octal 0o0777);
				Uberspark_osservices.cp ~recurse:true ~force:true (abs_uobjcoll_path ^ "/" ^ uobjinfo_entry.f_uobj_name ^ "/include/*") 
					(uobjcoll_canonical_namespace_path ^ "/" ^ uobjinfo_entry.f_uobj_name ^ "/include/.")	
			end;
		)!d_uobjcoll_uobjinfo;
	end;

	retval := true;
	(!retval)
;;




let build
	(uobjcoll_path_ns : string)
	(target_def : Defs.Basedefs.target_def_t)
	(uobjcoll_load_address : int)
	: bool =

	(* local variables *)
	let retval = ref false in
	let in_namespace_build = ref false in

	let dummy = 0 in begin
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "uobj collection build start...";
	
	(* store global initialization variables *)
	d_load_address := uobjcoll_load_address;
	
	end;


	(* get uobj collection absolute path *)
	let (rval, abs_uobjcoll_path) = (Uberspark_osservices.abspath uobjcoll_path_ns) in
	if(rval == false) then begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not obtain absolute path for uobjcoll: %s" abs_uobjcoll_path;
		(!retval)
	end else


    (* parse uobjcoll manifest *)
	let uobjcoll_mf_filename = (abs_uobjcoll_path ^ "/" ^ Uberspark_namespace.namespace_uobjcoll_mf_filename) in
	let rval = (parse_manifest uobjcoll_mf_filename) in	
    if (rval == false) then	begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "unable to stat/parse manifest for uobjcoll: %s" uobjcoll_mf_filename;
		(!retval)
	end else


    (* collect uobj collection uobj info *)
	let rval = (initialize_uobjs_baseinfo abs_uobjcoll_path Uberspark_namespace.namespace_uobjcoll_build_dir) in	
    if (rval == false) then	begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "unable to collect uobj information for uobj collection!";
		(!retval)
	end else

	let dummy = 0 in begin
	Uberspark_logger.log "successfully collect uobj information";

	(* compute uobj load addresses and sizes *)
	compute_uobjs_load_address_and_size ();
	Uberspark_logger.log "computed uobj load address and size for uobjs within collection";

	end;

	(* setup collection uobj build workspace *)
	let rval = (prepare_namespace_for_build abs_uobjcoll_path) in	
    if (rval == false) then	begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "unable to prepare uobjcoll canonical build namespace!";
		(!retval)
	end else

	let dummy = 0 in begin
	Uberspark_logger.log "uobjcoll canonical build namespace ready";
	end;

	(* switch working directory to uobjcoll source path *)
	let (rval, r_prevpath, r_curpath) = (Uberspark_osservices.dir_change abs_uobjcoll_path) in
	if(rval == false) then begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not switch to uobjcoll source directory: %s" abs_uobjcoll_path;
		(!retval)
	end else


	(* create _build folder *)
	let dummy = 0 in begin
	Uberspark_osservices.mkdir ~parent:true Uberspark_namespace.namespace_uobjcoll_build_dir (`Octal 0o0777);
	end;


	(* prep uobj sources within _build folder *)
	let dummy = 0 in begin
	List.iter ( fun (uobjinfo_entry : uobjcoll_uobjinfo_t) -> 
	    (*if uobjinfo_entry.f_uobj_is_incollection then begin
			Uberspark_logger.log ~lvl:Uberspark_logger.Debug "uobj in collection: copying from '%s' to '%s'" uobjinfo_entry.f_uobj_srcpath uobjinfo_entry.f_uobj_buildpath;
		end else begin
			Uberspark_logger.log ~lvl:Uberspark_logger.Debug "uobj out of collection; copying from '%s' to '%s'" uobjinfo_entry.f_uobj_srcpath uobjinfo_entry.f_uobj_buildpath;
		end;*)
		Uberspark_osservices.mkdir ~parent:true uobjinfo_entry.f_uobj_buildpath (`Octal 0o0777);
		Uberspark_osservices.cp ~recurse:true ~force:true (uobjinfo_entry.f_uobj_srcpath ^ "/*") 
			(uobjinfo_entry.f_uobj_buildpath ^ "/.")	

	)!d_uobjcoll_uobjinfo;
	end;



	(* restore working directory *)
	let dummy = 0 in begin
	ignore(Uberspark_osservices.dir_change r_prevpath);
	Uberspark_logger.log "cleaned up build workspace";
	retval := true;
	end;

	(!retval)
;;
