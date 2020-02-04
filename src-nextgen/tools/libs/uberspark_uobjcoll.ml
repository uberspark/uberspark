(*===========================================================================*)
(*===========================================================================*)
(*	uberSpark uberobject collection verification and build interface 		 *)
(*	implementation															 *)
(*	author: amit vasudevan (amitvasudevan@acm.org)							 *)
(*===========================================================================*)
(*===========================================================================*)

open Str

(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* type definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)

type uobjcoll_uobjinfo_t =
{
	mutable f_uobj 					: Uberspark_uobj.uobject option;
	mutable f_uobjinfo    			: Defs.Basedefs.uobjinfo_t;			
};;

type uobjcoll_sentinel_info_t =
{
	mutable f_code			: string;
	mutable f_libcode  	: string;	
	mutable f_sizeof_code : int;	
	mutable f_type : string; 	
};;


(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* variable definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)

(* note: canonical public-method name = <uobj/uobjcoll namespace>__<public-method name> *)
(* note: canonical public-medhod sentinel name = <uobj/uobjcoll_namespace>__<public-method name>__<sentinel-type> *)

(* uobjcoll manifest filename *)
let d_mf_filename = ref "";;

(* uobjcoll manifest filename path *)
let d_path_to_mf_filename = ref "";;

(* uobjcoll namespace filesystem path *)
let d_path_ns = ref "";;

(* uobjcoll load address *)
let d_load_address : int ref = ref 0;;

(* uobjcoll size *)
let d_size : int ref = ref 0;;

(* uobjcoll target definition *)
let d_target_def: Defs.Basedefs.target_def_t = {
	f_platform = ""; 
	f_arch = ""; 
	f_cpu = "";
};;

(* uobjcoll asm file sources list *)
let d_sources_asm_file_list: string list ref = ref [];;

(* uobjcoll-hdr node contents as specified in the manifest *)
let d_hdr_mf: Uberspark_manifest.Uobjcoll.uobjcoll_hdr_t = {f_namespace = ""; f_platform = ""; f_arch = ""; f_cpu = ""; f_hpl = ""; };;

(* uobjcoll-uobjs node contents as specified in the manifest *)
let d_uobjcoll_uobjs_mf : Uberspark_manifest.Uobjcoll.uobjcoll_uobjs_t = {f_prime_uobj_ns = ""; f_templar_uobjs = []};;

(* list of intrauobjcoll sentinel types as specified in the manifest *)
let d_uobjcoll_intrauobjcoll_sentinels_list_mf : string list ref = ref [];;

(* assoc list of uobjcoll publicmethods indexed by canonical publicmethod name *)
let d_uobjcoll_publicmethods_assoc_list_mf : (string * Uberspark_manifest.Uobjcoll.uobjcoll_sentinels_uobjcoll_publicmethods_t) list ref = ref [];;

(* assoc list of intrauobjcoll publicmethods mapping canonical publicmethod names to Uberspark_uobj.publicmethod_info_t 
as it appears in manifest order*)
let d_uobjs_publicmethods_assoc_list_mf : (string * Uberspark_uobj.publicmethod_info_t) list ref = ref [];; 

(* list and hashtbl of uobjs info within uobjcoll *)
let d_uobjcoll_uobjinfo_list : uobjcoll_uobjinfo_t list ref = ref [];;
let d_uobjcoll_uobjinfo_hashtbl = ((Hashtbl.create 32) : ((string, uobjcoll_uobjinfo_t)  Hashtbl.t));; 

(* hashtbl of uobjcoll sentinels mapping sentinel type to sentinel info for uobjcoll publicmethods sentinels *)
let d_uobjcoll_publicmethods_sentinels_hashtbl = ((Hashtbl.create 32) : ((string, uobjcoll_sentinel_info_t)  Hashtbl.t));; 

(* hashtbl of uobjcoll sentinels mapping sentinel type to sentinel info for intrauobjcoll sentinels *)
let d_uobjcoll_intrauobjcoll_sentinels_hashtbl = ((Hashtbl.create 32) : ((string, uobjcoll_sentinel_info_t)  Hashtbl.t));; 

(* hashtbl of intrauobjcoll publicmethods mapping canonical publicmethod names to Uberspark_uobj.publicmethod_info_t *)
let d_uobjs_publicmethods_hashtbl = ((Hashtbl.create 32) : ((string, Uberspark_uobj.publicmethod_info_t)  Hashtbl.t));; 

(* hashtbl of intrauobjcoll publicmethods mapping canonical publicmethod names to Uberspark_uobj.publicmethod_info_t; with 
computed publicmethod address *)
let d_uobjs_publicmethods_hashtbl_with_address = ((Hashtbl.create 32) : ((string, Uberspark_uobj.publicmethod_info_t)  Hashtbl.t));; 

(* hashtbl of canonical public-medhod sentinel name to sentinel address mapping for uobjcoll publicmethods *)
let d_uobjcoll_publicmethods_sentinel_address_hashtbl = ((Hashtbl.create 32) : ((string, Defs.Basedefs.uobjcoll_sentinel_address_t)  Hashtbl.t));; 

(* hashtbl of canonical public-medhod sentinel name to sentinel address mapping for intrauobjcoll publicmethods *)
let d_intrauobjcoll_publicmethods_sentinel_address_hashtbl = ((Hashtbl.create 32) : ((string, Defs.Basedefs.uobjcoll_sentinel_address_t)  Hashtbl.t));; 

(* association list of uobj binary image sections with memory map info; indexed by section name *)		
let d_memorymapped_sections_list : (string * Defs.Basedefs.section_info_t) list ref = ref [];;

(* list of sentinel_info_t elements for sentinel code generation *)		
let d_sentinel_info_for_codegen_list : Uberspark_codegen.Uobjcoll.sentinel_info_t list ref = ref [];;

(* hashtbl of intruobjcoll callees sentinel types indexed by canonical publicmethod name *)
let d_intrauobjcoll_callees_sentinel_type_hashtbl = ((Hashtbl.create 32) : ((string, string list)  Hashtbl.t));;


(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* interface definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)



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
	let rval = (Uberspark_manifest.Uobjcoll.parse_uobjcoll_hdr mf_json d_hdr_mf ) in
	if (rval == false) then (false)
	else

	let dummy=0 in begin
		d_path_ns := (Uberspark_namespace.get_namespace_staging_dir_prefix ())  ^ "/" ^ d_hdr_mf.f_namespace;
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "uobj collection path ns=%s" !d_path_ns;
	end;

	(* parse, load and overlay config-settings node, if one is present *)
	(* TBD: reinstate with new config interface *)
	(*if (Uberspark_config.load_from_json mf_json) then begin
		Uberspark_logger.log "loaded and overlaid config-settings from uobjcoll manifest for uobjcoll build";
	end else begin
		Uberspark_logger.log "using default config for uobjcoll build";
    end;*)

	(* parse uobjcoll-uobjs node *)
	let rval = (Uberspark_manifest.Uobjcoll.parse_uobjcoll_uobjs mf_json d_uobjcoll_uobjs_mf ) in
	if (rval == false) then (false)
	else

	let dummy=0 in begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "uobj collection uobjs=%u" (List.length d_uobjcoll_uobjs_mf.f_templar_uobjs);
	end;

	(* parse uobjcoll-sentinels/intrauobjcoll node *)
	let rval = (Uberspark_manifest.Uobjcoll.parse_uobjcoll_sentinels_intrauobjcoll mf_json d_uobjcoll_intrauobjcoll_sentinels_list_mf) in
	if (rval == false) then (false)
	else

	let dummy=0 in begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "intrauobjcoll sentinels=%u" 
			(List.length !d_uobjcoll_intrauobjcoll_sentinels_list_mf);
	end;

	(* parse uobjcoll-sentinels/uobjcoll-publicmethods node *)
	let rval = (Uberspark_manifest.Uobjcoll.parse_uobjcoll_sentinels_uobjcoll_publicmethods mf_json d_uobjcoll_publicmethods_assoc_list_mf) in
	if (rval == false) then (false)
	else

	let dummy=0 in begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "uobjcoll_publicmethods sentinels=%u" 
			(List.length !d_uobjcoll_publicmethods_assoc_list_mf);
	end;

	(true)
;;



(*--------------------------------------------------------------------------*)
(* get sentinel info from sentinel manifest for specified sentinel type *)
(* sentinel_facet = uobjcoll_publicmethods or intrauobjcoll *)
(* sentinel_type = string describing sentinel type, e.g. call *)
(*--------------------------------------------------------------------------*)
let get_sentinel_info_for_sentinel_facet_and_type
	(sentinel_facet: string)
	(sentinel_type: string)
	: (bool * uobjcoll_sentinel_info_t) = 

	let retval = ref true in 
	let sentinel_info : uobjcoll_sentinel_info_t = { f_code = ""; f_libcode= ""; f_sizeof_code=0; f_type="";} in
	let sentinel_json_var: Uberspark_manifest.Sentinel.json_node_uberspark_sentinel_t = 
		{f_namespace = ""; f_platform = ""; f_arch = ""; f_cpu = ""; f_sizeof_code = 0; f_code = ""; f_libcode = "";} in


	let sentinel_mf_filename = ((Uberspark_namespace.get_namespace_staging_dir_prefix ()) ^ "/" ^ 
		Uberspark_namespace.namespace_root ^ "/" ^ Uberspark_namespace.namespace_sentinel ^ "/cpu/" ^
		d_hdr_mf.f_arch ^ "/" ^ d_hdr_mf.f_cpu ^ "/" ^ d_hdr_mf.f_hpl ^ "/" ^ sentinel_facet ^ "/" ^ 
		sentinel_type ^ "/" ^ Uberspark_namespace.namespace_root_mf_filename) in 
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "sentinel_mf_filename=%s" sentinel_mf_filename;
	
	(* read sentinel manifest JSON *)
	let (rval, _, mf_json) = (Uberspark_manifest.get_json_for_manifest_node_type sentinel_mf_filename Uberspark_namespace.namespace_sentinel_mf_node_type_tag) in
	
	if (rval == false) then begin
	retval := false;
	end;

	(* convert to variable *)
	if !retval then begin 			
		let rval =	(Uberspark_manifest.Sentinel.json_node_uberspark_sentinel_to_var mf_json sentinel_json_var) in

		if (rval == false) then begin
		retval := false;
		end;
	end;

	(* populate sentinel_info fields *)
	if !retval then begin 			
		sentinel_info.f_code <- sentinel_json_var.f_code;
		sentinel_info.f_libcode <- sentinel_json_var.f_libcode;
		sentinel_info.f_sizeof_code <- sentinel_json_var.f_sizeof_code;
		sentinel_info.f_type <- sentinel_type;
	end;

	(!retval, sentinel_info)
;;



(*--------------------------------------------------------------------------*)
(* create uobj collection uobjcoll_publicmethods and intrauobjcoll sentinels hashtbl *)
(*--------------------------------------------------------------------------*)
let create_uobjcoll_publicmethods_intrauobjcoll_sentinels_hashtbl
	()
	: bool = 

	let retval = ref true in 

	(* iterate over uobjcoll_publicmethods sentinel list and build sentinel type to sentinel facet hashtbl *)
	let sentinel_type_to_sentinel_facet = ((Hashtbl.create 32) : ((string, string)  Hashtbl.t)) in 
	List.iter ( fun ( (canonical_pm_name:string), (pm_sentinel_info: Uberspark_manifest.Uobjcoll.uobjcoll_sentinels_uobjcoll_publicmethods_t)) -> 
		List.iter ( fun (sentinel_type: string) -> 
			if not (Hashtbl.mem sentinel_type_to_sentinel_facet sentinel_type) then begin
				Hashtbl.add sentinel_type_to_sentinel_facet sentinel_type "interuobjcoll";
			end;
		) pm_sentinel_info.f_sentinel_type_list;
	) !d_uobjcoll_publicmethods_assoc_list_mf;
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "create_sentinels_hashtbl: total unique uobjcoll_publicmethods sentinels=%u" 
		(Hashtbl.length sentinel_type_to_sentinel_facet);


	(* now iterate over the uobjcoll_publicmethods sentinel type to sentinel facet hashtbl, get the corresponding 
	sentinel info and add it to d_uobjcoll_publicmethods_sentinels_hashtbl *)
	Hashtbl.iter (fun (sentinel_type:string) (sentinel_facet:string)  ->
		if !retval then begin
			let (rval, sinfo) = (get_sentinel_info_for_sentinel_facet_and_type sentinel_facet sentinel_type) in
			if (rval == false) then begin
				retval := false;
			end else begin
				Uberspark_logger.log ~lvl:Uberspark_logger.Debug "create_sentinels_hashtbl: adding key=%s" sentinel_type; 
				Hashtbl.add d_uobjcoll_publicmethods_sentinels_hashtbl sentinel_type sinfo;
			end;
		end;
	)sentinel_type_to_sentinel_facet;

	if (!retval == false) then (false)
	else

	let dummy=0 in begin
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "create_sentinels_hashtbl: total unique uobjcoll_publicmethods sentinels=%u" 
		(Hashtbl.length d_uobjcoll_publicmethods_sentinels_hashtbl);


	(* iterate over intrauobjcoll sentinel list and build sentinel type to sentinel facet hashtbl *)
	let sentinel_type_to_sentinel_facet = ((Hashtbl.create 32) : ((string, string)  Hashtbl.t)) in 
	List.iter ( fun (sentinel_type: string) -> 
		if not (Hashtbl.mem sentinel_type_to_sentinel_facet sentinel_type) then begin
			Hashtbl.add sentinel_type_to_sentinel_facet sentinel_type "intrauobjcoll";
		end;
	) !d_uobjcoll_intrauobjcoll_sentinels_list_mf;

	(* now iterate over the intrauobjcoll sentinel type to sentinel facet hashtbl, get the corresponding 
	sentinel info and add it to d_uobjcoll_sentinels_hashtbl *)
	Hashtbl.iter (fun (sentinel_type:string) (sentinel_facet:string)  ->
		if !retval then begin
			let (rval, sinfo) = (get_sentinel_info_for_sentinel_facet_and_type sentinel_facet sentinel_type ) in
			if (rval == false) then begin
				retval := false;
			end else begin
				Uberspark_logger.log ~lvl:Uberspark_logger.Debug "create_sentinels_hashtbl: adding key=%s" sentinel_type; 
				Hashtbl.add d_uobjcoll_intrauobjcoll_sentinels_hashtbl sentinel_type sinfo;
			end;
		end;
	)sentinel_type_to_sentinel_facet;
	end;

	if (!retval == false) then (false)
	else

	let dummy=0 in begin
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "create_sentinels_hashtbl: total unique intrauobjcoll sentinels=%u" 
		(Hashtbl.length d_uobjcoll_intrauobjcoll_sentinels_hashtbl);
	end;

	(!retval)
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
	if not (d_uobjcoll_uobjs_mf.f_prime_uobj_ns = "") then begin
		
			let (rval, uobj_name, uobjcoll_name) = (Uberspark_namespace.get_uobj_uobjcoll_name_from_uobj_ns d_uobjcoll_uobjs_mf.f_prime_uobj_ns) in
			if (rval) then begin
				let uobjinfo_entry : uobjcoll_uobjinfo_t = { f_uobj = None; 
					f_uobjinfo = { f_uobj_name = ""; f_uobj_ns = "";  
					f_uobj_srcpath = ""; f_uobj_buildpath = ""; f_uobj_nspath = "" ; f_uobj_is_incollection = false; 
					f_uobj_is_prime  = false; f_uobj_load_address = 0; f_uobj_size = 0;}; } in

				uobjinfo_entry.f_uobj <- Some new Uberspark_uobj.uobject;
				uobjinfo_entry.f_uobjinfo.f_uobj_name <- uobj_name;
				uobjinfo_entry.f_uobjinfo.f_uobj_ns <- d_uobjcoll_uobjs_mf.f_prime_uobj_ns;
				uobjinfo_entry.f_uobjinfo.f_uobj_is_prime <- true;
				uobjinfo_entry.f_uobjinfo.f_uobj_buildpath <- (uobjcoll_abs_path ^ "/" ^ uobjcoll_builddir ^ "/" ^ uobj_name);
				uobjinfo_entry.f_uobjinfo.f_uobj_nspath <- ((Uberspark_namespace.get_namespace_staging_dir_prefix ()) ^ "/" ^ d_uobjcoll_uobjs_mf.f_prime_uobj_ns);

				if (Uberspark_namespace.is_uobj_ns_in_uobjcoll_ns d_uobjcoll_uobjs_mf.f_prime_uobj_ns
					d_hdr_mf.f_namespace) then begin
					uobjinfo_entry.f_uobjinfo.f_uobj_is_incollection <- true;
				end else begin
					uobjinfo_entry.f_uobjinfo.f_uobj_is_incollection <- false;
				end;

				if uobjinfo_entry.f_uobjinfo.f_uobj_is_incollection then begin
					uobjinfo_entry.f_uobjinfo.f_uobj_srcpath <- (uobjcoll_abs_path ^ "/" ^ uobj_name);
				end else begin
					uobjinfo_entry.f_uobjinfo.f_uobj_srcpath <- ((Uberspark_namespace.get_namespace_staging_dir_prefix ()) ^ "/" ^ d_uobjcoll_uobjs_mf.f_prime_uobj_ns);
				end;

				d_uobjcoll_uobjinfo_list := !d_uobjcoll_uobjinfo_list @ [ uobjinfo_entry ];

			    if (Hashtbl.mem d_uobjcoll_uobjinfo_hashtbl d_uobjcoll_uobjs_mf.f_prime_uobj_ns) then begin
					(* there is already another uobj with the same ns within the collection, so bail out *)
					Uberspark_logger.log ~lvl:Uberspark_logger.Error "multiple uobjs with same namespace!";
					retval := false;
		    	end else begin
					Hashtbl.add d_uobjcoll_uobjinfo_hashtbl d_uobjcoll_uobjs_mf.f_prime_uobj_ns uobjinfo_entry;
					retval := true;
		    	end;

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
			if (rval) && !retval then begin
				let uobjinfo_entry : uobjcoll_uobjinfo_t = { f_uobj = None; 
					f_uobjinfo = { f_uobj_name = ""; f_uobj_ns = "";  
					f_uobj_srcpath = ""; f_uobj_buildpath = ""; f_uobj_nspath = "" ; f_uobj_is_incollection = false; 
					f_uobj_is_prime  = false; f_uobj_load_address = 0; f_uobj_size = 0;}; } in

				uobjinfo_entry.f_uobj <- Some new Uberspark_uobj.uobject;
				uobjinfo_entry.f_uobjinfo.f_uobj_name <- uobj_name;
				uobjinfo_entry.f_uobjinfo.f_uobj_ns <- templar_uobj_ns;
				uobjinfo_entry.f_uobjinfo.f_uobj_is_prime <- false;
				uobjinfo_entry.f_uobjinfo.f_uobj_buildpath <- (uobjcoll_abs_path ^ "/" ^ uobjcoll_builddir ^ "/" ^ uobj_name);
				uobjinfo_entry.f_uobjinfo.f_uobj_nspath <- ((Uberspark_namespace.get_namespace_staging_dir_prefix ()) ^ "/" ^ templar_uobj_ns);

				if (Uberspark_namespace.is_uobj_ns_in_uobjcoll_ns templar_uobj_ns d_hdr_mf.f_namespace) then begin
					uobjinfo_entry.f_uobjinfo.f_uobj_is_incollection <- true;
				end else begin
					uobjinfo_entry.f_uobjinfo.f_uobj_is_incollection <- false;
				end;

				if uobjinfo_entry.f_uobjinfo.f_uobj_is_incollection then begin
					uobjinfo_entry.f_uobjinfo.f_uobj_srcpath <- (uobjcoll_abs_path ^ "/" ^ uobj_name);
				end else begin
					uobjinfo_entry.f_uobjinfo.f_uobj_srcpath <- ((Uberspark_namespace.get_namespace_staging_dir_prefix ()) ^ "/" ^ templar_uobj_ns);
				end;

				d_uobjcoll_uobjinfo_list := !d_uobjcoll_uobjinfo_list @ [ uobjinfo_entry ];

			    if (Hashtbl.mem d_uobjcoll_uobjinfo_hashtbl templar_uobj_ns) then begin
					(* there is already another uobj with the same ns within the collection, so bail out *)
					Uberspark_logger.log ~lvl:Uberspark_logger.Error "multiple uobjs with same namespace!";
					retval := false;
		    	end else begin
					Hashtbl.add d_uobjcoll_uobjinfo_hashtbl templar_uobj_ns uobjinfo_entry;
		    	end;

			end else begin
				retval := false;
			end;

	) d_uobjcoll_uobjs_mf.f_templar_uobjs;
	end;

	if (!retval == false) then (false)
	else

	let dummy=0 in begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "collect_uobjinfo: total collection uobjs=%u" (List.length !d_uobjcoll_uobjinfo_list);
	end;

	(true)
;;


(*--------------------------------------------------------------------------*)
(* initialize uobjs within uobjinfo list *)
(*--------------------------------------------------------------------------*)
let initialize_uobjs_within_uobjinfo_list
	()
	: unit = 

	List.iter ( fun (uobjinfo_entry : uobjcoll_uobjinfo_t) -> 
		match uobjinfo_entry.f_uobj with 
			| None ->
				Uberspark_logger.log ~lvl:Uberspark_logger.Error "invalid uobj!";

			| Some uobj ->
				Uberspark_logger.log "initializing uobj '%s'..." uobjinfo_entry.f_uobjinfo.f_uobj_name;
				let rval = (uobj#initialize ~builddir:Uberspark_namespace.namespace_uobj_build_dir 
					(uobjinfo_entry.f_uobjinfo.f_uobj_buildpath ^ "/" ^ Uberspark_namespace.namespace_root_mf_filename) 
					d_target_def 0) in
				Uberspark_logger.log "uobj '%s' successfully initialized; size=0x%08x" uobjinfo_entry.f_uobjinfo.f_uobj_name 
					uobj#get_d_size;
		;

	)!d_uobjcoll_uobjinfo_list;

;;



(*--------------------------------------------------------------------------*)
(* compute uobjs section memory map within uobjinfo list *)
(*--------------------------------------------------------------------------*)
let compute_uobjs_section_memory_map_within_uobjinfo_list
	()
	: unit = 

	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "%s: total d_memorymapped_sections_list elements=%u" __LOC__ 
		(List.length !d_memorymapped_sections_list);


	List.iter ( fun (uobjinfo_entry : uobjcoll_uobjinfo_t) -> 
		match uobjinfo_entry.f_uobj with 
			| None ->
				Uberspark_logger.log ~lvl:Uberspark_logger.Error "invalid uobj!";

			| Some uobj ->
				let key = (".section_uobj_" ^ uobjinfo_entry.f_uobjinfo.f_uobj_name) in
				let section_info : Defs.Basedefs.section_info_t = (List.assoc key !d_memorymapped_sections_list) in
				let uobj_load_address = section_info.usbinformat.f_addr_start in 
				Uberspark_logger.log "computing memory-map for uobj '%s' at load-address=0x%08x..." 
					uobjinfo_entry.f_uobjinfo.f_uobj_name uobj_load_address;
				uobj#set_d_load_addr uobj_load_address;
				ignore(uobj#consolidate_sections_with_memory_map ());
	)!d_uobjcoll_uobjinfo_list;

	()
;;





(*--------------------------------------------------------------------------*)
(* consolidate uobjcoll sections with memory map *)
(* update uobj size (d_size) accordingly and return the size *)
(*--------------------------------------------------------------------------*)
let consolidate_sections_with_memory_map
	()
	: (bool * int)  
	=

	let uobjinfo_status = ref true in 
	let uobjcoll_section_load_addr = ref 0 in

	(* clear out memory mapped sections list and set initial section load address *)
	uobjcoll_section_load_addr := !d_load_address;
	d_memorymapped_sections_list := []; 

	(* add inter-uobjcoll entry point sentinels *)
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "proceeding to add inter-uobjcoll sentinel sections...";
	
	List.iter ( fun ( (pm_name:string), (pm_sentinel_info:Uberspark_manifest.Uobjcoll.uobjcoll_sentinels_uobjcoll_publicmethods_t))  ->
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "pm_name=%s" pm_name;
		
		List.iter ( fun (sentinel_type:string) ->
		
			(* add section *)
			let sentinel_name = pm_name ^ "__" ^ sentinel_type in 
			let key = (".section_uobjcoll_publicmethod_sentinel_" ^ sentinel_name) in 
			let sentinel_info = Hashtbl.find d_uobjcoll_publicmethods_sentinels_hashtbl sentinel_type in
			let section_size = 	sentinel_info.f_sizeof_code + (Uberspark_config.json_node_uberspark_config_var.uobjcoll_binary_image_section_alignment - 
				(sentinel_info.f_sizeof_code mod Uberspark_config.json_node_uberspark_config_var.uobjcoll_binary_image_section_alignment)) in

			Uberspark_logger.log ~lvl:Uberspark_logger.Debug "sentinel type=%s, size=0x%08x" sentinel_info.f_type sentinel_info.f_sizeof_code;

			d_memorymapped_sections_list := !d_memorymapped_sections_list @ [ (key, 
				{ f_name = key;	
					f_subsection_list = [ key; ];	
					usbinformat = { f_type=Defs.Binformat.const_USBINFORMAT_SECTION_TYPE_UOBJCOLL_PUBLICMETHODS_SENTINEL; 
									f_prot=0; 
									f_size = section_size;
									f_aligned_at = Uberspark_config.json_node_uberspark_config_var.uobjcoll_binary_image_section_alignment; 
									f_pad_to = Uberspark_config.json_node_uberspark_config_var.uobjcoll_binary_image_section_alignment; 
									f_addr_start = !uobjcoll_section_load_addr; 
									f_addr_file = 0;
									f_reserved = 0;
								};
				}) ];

			Uberspark_logger.log ~lvl:Uberspark_logger.Debug "added section for uobjcoll_publicmethods sentinel '%s' at 0x%08x, size=%08x..." 
				key !uobjcoll_section_load_addr section_size;


			(* update next section address *)
			uobjcoll_section_load_addr := !uobjcoll_section_load_addr + section_size; 
		
		) pm_sentinel_info.f_sentinel_type_list;

	) !d_uobjcoll_publicmethods_assoc_list_mf;


	(* add intra-uobjcoll sentinel sections *)
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "proceeding to add intra-uobjcoll sentinel sections...";
	
	List.iter (fun ((pm_name:string) ,(pm_info:Uberspark_uobj.publicmethod_info_t))  ->
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "pm_name=%s" pm_name;

		List.iter ( fun (sentinel_type:string) ->

			(* add section *)
			let sentinel_name = pm_name ^ "__" ^ sentinel_type in 
			let key = (".section_intrauobjcoll_publicmethod_sentinel_" ^ sentinel_name) in 
			let sentinel_info = Hashtbl.find d_uobjcoll_intrauobjcoll_sentinels_hashtbl sentinel_type in
			let section_size = 	sentinel_info.f_sizeof_code + (Uberspark_config.json_node_uberspark_config_var.uobjcoll_binary_image_section_alignment - 
				(sentinel_info.f_sizeof_code mod Uberspark_config.json_node_uberspark_config_var.uobjcoll_binary_image_section_alignment)) in

			Uberspark_logger.log ~lvl:Uberspark_logger.Debug "sentinel type=%s, size=0x%08x" sentinel_info.f_type sentinel_info.f_sizeof_code;

			d_memorymapped_sections_list := !d_memorymapped_sections_list @ [ (key, 
				{ f_name = key;	
					f_subsection_list = [];	
					usbinformat = { f_type=Defs.Binformat.const_USBINFORMAT_SECTION_TYPE_INTRAUOBJCOLL_SENTINEL; 
									f_prot=0; 
									f_size = section_size;
									f_aligned_at = Uberspark_config.json_node_uberspark_config_var.uobjcoll_binary_image_section_alignment; 
									f_pad_to = Uberspark_config.json_node_uberspark_config_var.uobjcoll_binary_image_section_alignment; 
									f_addr_start = !uobjcoll_section_load_addr; 
									f_addr_file = 0;
									f_reserved = 0;
								};
				}) ];

			Uberspark_logger.log ~lvl:Uberspark_logger.Debug "added section for intrauobjcoll sentinel '%s' at 0x%08x, size=%08x..." 
				key !uobjcoll_section_load_addr section_size;

			(* update next section address *)
			uobjcoll_section_load_addr := !uobjcoll_section_load_addr + section_size; 

		) !d_uobjcoll_intrauobjcoll_sentinels_list_mf;

	) !d_uobjs_publicmethods_assoc_list_mf;



	(* iterate over all the uobjs and add a section for each *)
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "proceeding to add uobj sections...";
	List.iter ( fun (uobjinfo_entry : uobjcoll_uobjinfo_t) -> 
		match uobjinfo_entry.f_uobj with 
			| None ->
				uobjinfo_status := false;
				Uberspark_logger.log ~lvl:Uberspark_logger.Error "invalid uobj!";

			| Some uobj ->
				Uberspark_logger.log "adding section for uobj '%s' at 0x%08x, size=%08x..." uobjinfo_entry.f_uobjinfo.f_uobj_name 
					!uobjcoll_section_load_addr uobj#get_d_size;

				let key = (".section_uobj_" ^ uobjinfo_entry.f_uobjinfo.f_uobj_name)	in 
				d_memorymapped_sections_list := !d_memorymapped_sections_list @ [ (key, 
					{ f_name = key;	
						f_subsection_list = [ key;];	
						usbinformat = { f_type=Defs.Binformat.const_USBINFORMAT_SECTION_TYPE_UOBJ; 
										f_prot=0; 
										f_size = uobj#get_d_size;
										f_aligned_at = Uberspark_config.json_node_uberspark_config_var.binary_uobj_section_alignment; 
										f_pad_to = Uberspark_config.json_node_uberspark_config_var.binary_uobj_section_alignment; 
										f_addr_start = !uobjcoll_section_load_addr; 
										f_addr_file = 0;
										f_reserved = 0;
									};
					}) ];



				uobjcoll_section_load_addr := !uobjcoll_section_load_addr + uobj#get_d_size; 
		;

	)!d_uobjcoll_uobjinfo_list;


	(* update uobjcoll size *)
	d_size := !uobjcoll_section_load_addr -  !d_load_address;

	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "%s: d_load_address=0x%08x, d_size=0x%08x" __LOC__ !d_load_address !d_size;

	(!uobjinfo_status, !d_size)
;;







(*--------------------------------------------------------------------------*)
(* create uobj collection public methods association list in mf order *)
(* note: these are for uobjs that are part of this collection *)
(*--------------------------------------------------------------------------*)
let create_uobjs_publicmethods_list_mforder
	(publicmethods_list : (string * Uberspark_uobj.publicmethod_info_t) list ref)
	: unit =

	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "create_uobjs_publicmethods_list_mforder [START]"; 

	(* iterate over all uobjs within uobjinfo list *)
	List.iter ( fun (uobjinfo_entry : uobjcoll_uobjinfo_t) -> 
		match uobjinfo_entry.f_uobj with 
			| None ->
				Uberspark_logger.log ~lvl:Uberspark_logger.Error "invalid uobj!";

			| Some uobj ->

				Uberspark_logger.log ~lvl:Uberspark_logger.Debug "adding public method info for uobj '%s', total public methods=%u" 
					uobjinfo_entry.f_uobjinfo.f_uobj_name (List.length uobj#get_d_publicmethods_assoc_list);
				
				let publicmethods_hashtbl = uobj#get_d_publicmethods_hashtbl in

				List.iter (fun ((pm_name:string), (throw_away:Uberspark_manifest.Uobj.json_node_uberspark_uobj_publicmethods_t))  ->
					let assoc_key = uobjinfo_entry.f_uobjinfo.f_uobj_ns in 
					let assoc_key_pm_name = ((Uberspark_namespace.get_variable_name_prefix_from_ns assoc_key) ^ "__" ^ pm_name) in
					let pm_info : Uberspark_manifest.Uobj.json_node_uberspark_uobj_publicmethods_t = (Hashtbl.find publicmethods_hashtbl pm_name) in
					publicmethods_list := !publicmethods_list @ [ (assoc_key_pm_name, { f_uobjpminfo = pm_info;
						f_uobjinfo = uobjinfo_entry.f_uobjinfo;}) ];
				) uobj#get_d_publicmethods_assoc_list;

		;

	)!d_uobjcoll_uobjinfo_list;

	(* dump uobjs publc methods association list *)
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "uobjcoll uobjs publicmethods assoc list dump follows:"; 
	List.iter (fun ((canonical_pm_name:string), (entry:Uberspark_uobj.publicmethod_info_t))  ->
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "canonical pm_name=%s; pm_name=%s, pm_addr=0x%08x" 
			canonical_pm_name entry.f_uobjpminfo.f_name entry.f_uobjpminfo.f_addr; 
	) !publicmethods_list;

	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "create_uobjs_publicmethods_list_mforder [END]"; 

	()
;;



(*--------------------------------------------------------------------------*)
(* create uobj collection public method info hashtable *)
(* note: these are for uobjs that are part of this collection *)
(*--------------------------------------------------------------------------*)
let create_uobjs_publicmethods_hashtbl
	(publicmethods_hashtbl : ((string, Uberspark_uobj.publicmethod_info_t)  Hashtbl.t))
	: unit =

	(* iterate over all uobjs within uobjinfo list *)
	List.iter ( fun (uobjinfo_entry : uobjcoll_uobjinfo_t) -> 
		match uobjinfo_entry.f_uobj with 
			| None ->
				Uberspark_logger.log ~lvl:Uberspark_logger.Error "invalid uobj!";

			| Some uobj ->

				Uberspark_logger.log ~lvl:Uberspark_logger.Debug "adding public method info for uobj '%s', total public methods=%u" 
					uobjinfo_entry.f_uobjinfo.f_uobj_name (Hashtbl.length uobj#get_d_publicmethods_hashtbl);
				
				Hashtbl.iter (fun (pm_name:string) (pm_info:Uberspark_manifest.Uobj.json_node_uberspark_uobj_publicmethods_t)  ->
					let htbl_key = uobjinfo_entry.f_uobjinfo.f_uobj_ns in 
					let htbl_key_pm_name = ((Uberspark_namespace.get_variable_name_prefix_from_ns htbl_key) ^ "__" ^ pm_name) in
					Hashtbl.add publicmethods_hashtbl htbl_key_pm_name { f_uobjpminfo = pm_info;
						f_uobjinfo = uobjinfo_entry.f_uobjinfo;}
				) uobj#get_d_publicmethods_hashtbl;

		;

	)!d_uobjcoll_uobjinfo_list;

	(* dump uobjs publc methods hashtable *)
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "uobjcoll uobjs publicmethods hashtbl dump follows:"; 
	Hashtbl.iter (fun (canonical_pm_name:string) (entry:Uberspark_uobj.publicmethod_info_t)  ->
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "canonical pm_name=%s; pm_name=%s, pm_addr=0x%08x" 
			canonical_pm_name entry.f_uobjpminfo.f_name entry.f_uobjpminfo.f_addr; 
	) publicmethods_hashtbl;



	()
;;



(*--------------------------------------------------------------------------*)
(* prepare list of sentinels for uobjcoll sentinel code generation *)
(*--------------------------------------------------------------------------*)
let prepare_for_uobjcoll_sentinel_codegen
	()
	: unit = 

	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "prepare_for_uobjcoll_sentinel_codegen: uobjcoll_publicmethods publicmethods=%u" 
		(List.length !d_uobjcoll_publicmethods_assoc_list_mf);

	(* add uobjcoll_publicmethods publicmethods sentinels *)
	List.iter ( fun ((canonical_pm_name:string), (pm_sentinel_info:Uberspark_manifest.Uobjcoll.uobjcoll_sentinels_uobjcoll_publicmethods_t)) ->
		List.iter ( fun (sentinel_type:string) ->

			let sentinel_info : uobjcoll_sentinel_info_t = Hashtbl.find d_uobjcoll_publicmethods_sentinels_hashtbl sentinel_type in
			let pm_info : Uberspark_uobj.publicmethod_info_t = Hashtbl.find d_uobjs_publicmethods_hashtbl_with_address canonical_pm_name in
			let codegen_sinfo_entry : Uberspark_codegen.Uobjcoll.sentinel_info_t = { 
				f_type= sentinel_type;
				f_name = canonical_pm_name ^ "__" ^ sentinel_type; 
				f_secname = ".section_uobjcoll_publicmethods_sentinel__" ^ (canonical_pm_name ^ "__" ^ sentinel_type);
				f_code = sentinel_info.f_code ; 
				f_libcode= sentinel_info.f_libcode ; 
				f_sizeof_code= sentinel_info.f_sizeof_code ; 
				f_addr= (Hashtbl.find d_uobjcoll_publicmethods_sentinel_address_hashtbl (canonical_pm_name ^ "__" ^ sentinel_type)).f_sentinel_addr; 
				f_pm_addr = pm_info.f_uobjpminfo.f_addr;
			} in 

			d_sentinel_info_for_codegen_list := !d_sentinel_info_for_codegen_list @ [ codegen_sinfo_entry ] ;
			Uberspark_logger.log ~lvl:Uberspark_logger.Debug "uobjcoll_publicmethods; added sentinel type %s for public-method %s" sentinel_type canonical_pm_name;

		) pm_sentinel_info.f_sentinel_type_list; 
	) !d_uobjcoll_publicmethods_assoc_list_mf;


	(* add intrauobjcoll publicmethods sentinels *)
	List.iter ( fun ((canonical_pm_name:string), (throwaway:Uberspark_uobj.publicmethod_info_t)) ->
		List.iter ( fun (sentinel_type:string) ->

			let sentinel_info : uobjcoll_sentinel_info_t = Hashtbl.find d_uobjcoll_publicmethods_sentinels_hashtbl sentinel_type in
			let pm_info : Uberspark_uobj.publicmethod_info_t = Hashtbl.find d_uobjs_publicmethods_hashtbl_with_address canonical_pm_name in
			let codegen_sinfo_entry : Uberspark_codegen.Uobjcoll.sentinel_info_t = { 
				f_type= sentinel_type;
				f_name = canonical_pm_name ^ "__" ^ sentinel_type; 
				f_secname = ".section_intrauobjcoll_sentinel__" ^ (canonical_pm_name ^ "__" ^ sentinel_type);
				f_code = sentinel_info.f_code ; 
				f_libcode= sentinel_info.f_libcode ; 
				f_sizeof_code= sentinel_info.f_sizeof_code ; 
				f_addr= (Hashtbl.find d_intrauobjcoll_publicmethods_sentinel_address_hashtbl (canonical_pm_name ^ "__" ^ sentinel_type)).f_sentinel_addr; 
				f_pm_addr = pm_info.f_uobjpminfo.f_addr;
			} in 

			d_sentinel_info_for_codegen_list := !d_sentinel_info_for_codegen_list @ [ codegen_sinfo_entry ] ;
			Uberspark_logger.log ~lvl:Uberspark_logger.Debug "intrauobjcoll; added sentinel type %s for public-method %s" sentinel_type canonical_pm_name;

		) !d_uobjcoll_intrauobjcoll_sentinels_list_mf; 
	) !d_uobjs_publicmethods_assoc_list_mf;



	(* debug: dump all the sentinels in codegen list *)
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "dump of list of sentinels for codegen follows:";
	List.iter ( fun (codegen_sinfo_entry : Uberspark_codegen.Uobjcoll.sentinel_info_t) ->
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "name=%s, addr=0x%08x, pm_addr=0x%08x" 
			codegen_sinfo_entry.f_name codegen_sinfo_entry.f_addr codegen_sinfo_entry.f_pm_addr;
	) !d_sentinel_info_for_codegen_list;
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "dumped list of sentinels for codegen";

	()
;;



(*--------------------------------------------------------------------------*)
(* setup contents of intrauobjcoll callees sentinel type hashtbl *)
(*--------------------------------------------------------------------------*)
let setup_intrauobjcoll_callees_sentinel_type_hashtbl
	()
	: unit = 

	List.iter ( fun ( (canonical_pm_name:string), (pm_info: Uberspark_uobj.publicmethod_info_t)) ->
		Hashtbl.add d_intrauobjcoll_callees_sentinel_type_hashtbl canonical_pm_name !d_uobjcoll_intrauobjcoll_sentinels_list_mf;
	) !d_uobjs_publicmethods_assoc_list_mf;

	()
;;


(*--------------------------------------------------------------------------*)
(* setup contents of uobjcoll publicmethods seninel address hashtbl *)
(*--------------------------------------------------------------------------*)
let setup_uobjcoll_publicmethods_sentinel_address_hashtbl
	()
	: unit = 

	List.iter ( fun ( (canonical_pm_name:string), (pm_sentinel_info:Uberspark_manifest.Uobjcoll.uobjcoll_sentinels_uobjcoll_publicmethods_t))  ->
		List.iter ( fun (sentinel_type:string) ->
			let canonical_pm_sentinel_name = (canonical_pm_name ^ "__" ^ sentinel_type) in 
			let key = (".section_uobjcoll_publicmethod_sentinel_" ^ canonical_pm_sentinel_name) in 

			(* grab section information for this sentinel *)
			let section_info = (List.assoc key !d_memorymapped_sections_list) in
			(* grab sentinel address *)
			let sentinel_addr = section_info.usbinformat.f_addr_start in
			let pm_info : Uberspark_uobj.publicmethod_info_t = Hashtbl.find d_uobjs_publicmethods_hashtbl_with_address canonical_pm_name in
			(*grab public method address *)
			let pm_addr = pm_info.f_uobjpminfo.f_addr in


			(* add entry into d_uobjcoll_publicmethods_sentinel_address_hashtbl *)
			let sentinel_addr_info : Defs.Basedefs.uobjcoll_sentinel_address_t = {
				f_pm_addr = pm_addr;
				f_sentinel_addr = sentinel_addr;
			} in 
			if (Hashtbl.mem d_uobjcoll_publicmethods_sentinel_address_hashtbl canonical_pm_sentinel_name) then begin
				Hashtbl.replace d_uobjcoll_publicmethods_sentinel_address_hashtbl canonical_pm_sentinel_name sentinel_addr_info;
			end else begin
				Hashtbl.add d_uobjcoll_publicmethods_sentinel_address_hashtbl canonical_pm_sentinel_name sentinel_addr_info;
			end;

		) pm_sentinel_info.f_sentinel_type_list;
	) !d_uobjcoll_publicmethods_assoc_list_mf;

	()
;;



(*--------------------------------------------------------------------------*)
(* setup contents of intrauobjcoll publicmethods seninel address hashtbl *)
(*--------------------------------------------------------------------------*)
let setup_intrauobjcoll_publicmethods_sentinel_address_hashtbl
	()
	: unit = 

	List.iter (fun ((canonical_pm_name:string) ,(throwaway:Uberspark_uobj.publicmethod_info_t))  ->
		List.iter ( fun (sentinel_type:string) ->
			let canonical_pm_sentinel_name = (canonical_pm_name ^ "__" ^ sentinel_type) in 
			let key = (".section_intrauobjcoll_publicmethod_sentinel_" ^ canonical_pm_sentinel_name) in 

			(* grab section information for this sentinel *)
			let section_info = (List.assoc key !d_memorymapped_sections_list) in
			(* grab sentinel address *)
			let sentinel_addr = section_info.usbinformat.f_addr_start in
			let pm_info : Uberspark_uobj.publicmethod_info_t = Hashtbl.find d_uobjs_publicmethods_hashtbl_with_address canonical_pm_name in
			(*grab public method address *)
			let pm_addr = pm_info.f_uobjpminfo.f_addr in


			(* add entry into d_intrauobjcoll_publicmethods_sentinel_address_hashtbl *)
			let sentinel_addr_info : Defs.Basedefs.uobjcoll_sentinel_address_t = {
				f_pm_addr = pm_addr;
				f_sentinel_addr = sentinel_addr;
			} in 
			if (Hashtbl.mem d_intrauobjcoll_publicmethods_sentinel_address_hashtbl canonical_pm_sentinel_name) then begin
				Hashtbl.replace d_intrauobjcoll_publicmethods_sentinel_address_hashtbl canonical_pm_sentinel_name sentinel_addr_info;
			end else begin
				Hashtbl.add d_intrauobjcoll_publicmethods_sentinel_address_hashtbl canonical_pm_sentinel_name sentinel_addr_info;
			end;

		) !d_uobjcoll_intrauobjcoll_sentinels_list_mf;
	) !d_uobjs_publicmethods_assoc_list_mf;

	()
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
	let uobjcoll_canonical_namespace = d_hdr_mf.f_namespace in
	let uobjcoll_canonical_namespace_path = ((Uberspark_namespace.get_namespace_staging_dir_prefix ()) ^ "/" ^ uobjcoll_canonical_namespace) in

	(* determine if we are doing an in-namespace build or an out-of-namespace build *)
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "namespace root=%s" ((Uberspark_namespace.get_namespace_staging_dir_prefix ()) ^ "/" ^ Uberspark_namespace.namespace_root ^ "/");
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
			if uobjinfo_entry.f_uobjinfo.f_uobj_is_incollection then begin
				Uberspark_osservices.mkdir ~parent:true (uobjcoll_canonical_namespace_path ^ "/" ^ uobjinfo_entry.f_uobjinfo.f_uobj_name ^ "/include") (`Octal 0o0777);
				Uberspark_osservices.cp ~recurse:true ~force:true (abs_uobjcoll_path ^ "/" ^ uobjinfo_entry.f_uobjinfo.f_uobj_name ^ "/include/*") 
					(uobjcoll_canonical_namespace_path ^ "/" ^ uobjinfo_entry.f_uobjinfo.f_uobj_name ^ "/include/.")	
			end;
		)!d_uobjcoll_uobjinfo_list;
	end;

	retval := true;
	(!retval)
;;


(*--------------------------------------------------------------------------*)
(* compile asm files *)
(*--------------------------------------------------------------------------*)
let compile_asm_files	
	()
	: bool = 
	
	let retval = ref false in

	retval := Uberspark_bridge.As.invoke ~gen_obj:true
			~context_path_builddir:Uberspark_namespace.namespace_uobjcoll_build_dir 
			(!d_sources_asm_file_list) [ "."; (Uberspark_namespace.get_namespace_staging_dir_prefix ()) ] ".";

	(!retval)	
;;



(*--------------------------------------------------------------------------*)
(* link uobjcoll binary image *)
(*--------------------------------------------------------------------------*)
let link_binary_image	
	()
	: bool = 
	
	let retval = ref false in
	let o_file_list =ref [] in

	(* add object files generated from c sources *)
	(*List.iter (fun fname ->
		o_file_list := !o_file_list @ [ fname ^ ".o"];
	) !d_sources_c_file_list;
	*)

	(* add object files generated from asm sources *)
	List.iter (fun fname ->
		o_file_list := !o_file_list @ [ fname ^ ".o"];
	) !d_sources_asm_file_list;


	retval := Uberspark_bridge.Ld.invoke 
			~context_path_builddir:Uberspark_namespace.namespace_uobjcoll_build_dir 
		Uberspark_namespace.namespace_uobjcoll_linkerscript_filename
		Uberspark_namespace.namespace_uobjcoll_binary_image_filename
		!o_file_list
		[ ] [ ]	".";

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
	d_target_def.f_platform <- target_def.f_platform;
	d_target_def.f_cpu <- target_def.f_cpu;
	d_target_def.f_arch <- target_def.f_arch;
	
	end;


	(* get uobj collection absolute path *)
	let (rval, abs_uobjcoll_path) = (Uberspark_osservices.abspath uobjcoll_path_ns) in
	if(rval == false) then begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not obtain absolute path for uobjcoll: %s" abs_uobjcoll_path;
		(!retval)
	end else

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

	(* switch working directory to uobjcoll _build folder *)
	let (rval, r_prevpath, r_curpath) = (Uberspark_osservices.dir_change (abs_uobjcoll_path ^ "/" ^ Uberspark_namespace.namespace_uobjcoll_build_dir)) in
	if(rval == false) then begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not switch to uobjcoll build folder: %s" 
			(abs_uobjcoll_path ^ "/" ^ Uberspark_namespace.namespace_uobjcoll_build_dir);
		(!retval)
	end else

    (* parse uobjcoll manifest *)
	let uobjcoll_mf_filename = (abs_uobjcoll_path ^ "/" ^ Uberspark_namespace.namespace_uobjcoll_mf_filename) in
	let rval = (parse_manifest uobjcoll_mf_filename) in	
    if (rval == false) then	begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "unable to stat/parse manifest for uobjcoll: %s" uobjcoll_mf_filename;
		(!retval)
	end else

	(* sanity check platform, cpu, arch override *)
	(* TBD: if manifest says generic, we need a command line override *)
	let dummy = 0 in begin
	d_hdr_mf.f_arch <- d_target_def.f_arch;
	d_hdr_mf.f_cpu <- d_target_def.f_cpu;
	d_hdr_mf.f_platform <- d_target_def.f_platform;
	end;

	(*create uobjcoll_publicmethods and intrauobjcoll sentinels hashtbl *)
	let rval = (create_uobjcoll_publicmethods_intrauobjcoll_sentinels_hashtbl ()) in 

	if(rval == false) then begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not create uobj collection sentinels hashtbl!";
		(false)
	end else
	
	let dummy = 0 in begin
	Uberspark_logger.log "created uobj collection uobjcoll_publicmethods and intrauobjcoll sentinels hashtbl";
	end;


	(* initialize uobj collection bridges *)
	let rval = (Uberspark_bridge.initialize_from_config ()) in	
    if (rval == false) then	begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "unable to initialize uobj collection bridges!";
		(!retval)
	end else


    (* collect uobj collection uobj info *)
	let rval = (initialize_uobjs_baseinfo abs_uobjcoll_path Uberspark_namespace.namespace_uobjcoll_build_dir) in	
    if (rval == false) then	begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "unable to collect uobj information for uobj collection!";
		(!retval)
	end else

	let dummy = 0 in begin
	Uberspark_logger.log "successfully collected uobj information";
	end;

	(* setup uobj collection canonical namespace for build *)
	let rval = (prepare_namespace_for_build abs_uobjcoll_path) in	
    if (rval == false) then	begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "unable to prepare uobjcoll canonical build namespace!";
		(!retval)
	end else

	let dummy = 0 in begin
	Uberspark_logger.log "uobjcoll canonical build namespace ready";
	end;

	(* provision all uobj sources within uobjcoll _build folder *)
	let dummy = 0 in begin
	List.iter ( fun (uobjinfo_entry : uobjcoll_uobjinfo_t) -> 

		Uberspark_osservices.mkdir ~parent:true uobjinfo_entry.f_uobjinfo.f_uobj_buildpath (`Octal 0o0777);
		Uberspark_osservices.cp ~recurse:true ~force:true (uobjinfo_entry.f_uobjinfo.f_uobj_srcpath ^ "/*") 
			(uobjinfo_entry.f_uobjinfo.f_uobj_buildpath ^ "/.")	

	)!d_uobjcoll_uobjinfo_list;
	end;


	(* initialize uobjs within uobj collection *)
	(* after this, we all the uobj manifests parsed, build folders created, 
		public methods populated based on load address of 0 for every uobj
		uobj size is available for every uobj
	*)
	let dummy = 0 in begin
	initialize_uobjs_within_uobjinfo_list ();
	Uberspark_logger.log "initialized uobjs within collection";
	end;

	(* create uobj collection uobjs public methods hashtable and association list *)
	let dummy = 0 in begin
	create_uobjs_publicmethods_hashtbl d_uobjs_publicmethods_hashtbl;
	create_uobjs_publicmethods_list_mforder d_uobjs_publicmethods_assoc_list_mf;
	Uberspark_logger.log "created uobj collection uobjs public methods hashtable and association list";
	end;

	(* create uobjcoll memory map *)
	let (rval, uobjcoll_size) = (consolidate_sections_with_memory_map ()) in 

	if(rval == false) then begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not create uobj collection memory map!";
		(false)
	end else

	(* store uobj collection computed size *)
	let dummy = 0 in begin
	d_size := uobjcoll_size;
	Uberspark_logger.log "consolidated uobj collection sections, total size=0x%08x" !d_size;
	end;

	(* compute uobj section memory map for all uobjs based on uobjcoll memory map *)
	let dummy = 0 in begin
	compute_uobjs_section_memory_map_within_uobjinfo_list ();
	Uberspark_logger.log "computed uobj section memory map for all uobjs within collection";
	end;

	(* create uobj collection uobjs public methods hashtable and association list with address *)
	let dummy = 0 in begin
	create_uobjs_publicmethods_hashtbl d_uobjs_publicmethods_hashtbl_with_address;
	Uberspark_logger.log "created uobj collection uobjs public methods hashtable and association list with address";
	end;

	(* create sentinel address hashtbls for uobjcoll, intrauobjcoll, interuobjcoll and legacy publicmethods *)
	(* TBD: interuobjcoll and legacy *)
	let dummy = 0 in begin
	setup_uobjcoll_publicmethods_sentinel_address_hashtbl ();
	setup_intrauobjcoll_publicmethods_sentinel_address_hashtbl ();
	Uberspark_logger.log "created sentinel address hashtbls";
	end;

	(* prepare inputs for sentinel code generation *)
	let dummy = 0 in begin
	prepare_for_uobjcoll_sentinel_codegen ();
	Uberspark_logger.log "prepared inputs for sentinel code generation";
	end;

	(* generate uobj collection sentinel code *)
	let rval = (Uberspark_codegen.Uobjcoll.generate_sentinel_code 
		Uberspark_namespace.namespace_uobjcoll_sentinel_definitions_src_filename
		!d_sentinel_info_for_codegen_list
		) in 
	
	if(rval == false) then begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not generate source for uobj collection sentinel definitions!";
		(false)
	end else

	let dummy = 0 in begin
	Uberspark_logger.log "generated source for  uobj collection sentinel definitions";
	end;

	(* setup intrauobjcoll callees sentinel type hashtbl *)
	let dummy = 0 in begin
	setup_intrauobjcoll_callees_sentinel_type_hashtbl ();
	Uberspark_logger.log "setup intrauobjcoll callees sentinel type hashtbl";
	end;


	(* build all uobjs *)
	let dummy = 0 in begin
	retval := true;
	List.iter ( fun (uobjinfo_entry : uobjcoll_uobjinfo_t) -> 
		Uberspark_logger.log "Building uobj '%s'..." uobjinfo_entry.f_uobjinfo.f_uobj_name;

		match uobjinfo_entry.f_uobj with 
			| None ->
				Uberspark_logger.log ~lvl:Uberspark_logger.Error "invalid uobj!";
				retval := false;

			| Some uobj ->
				begin
					let uobj_bridges_override = ref false in

					let uobj_slt_info : Uberspark_uobj.slt_info_t = {
						f_intrauobjcoll_callees_sentinel_type_hashtbl = d_intrauobjcoll_callees_sentinel_type_hashtbl;
						f_intrauobjcoll_callees_sentinel_address_hashtbl = d_intrauobjcoll_publicmethods_sentinel_address_hashtbl;
						f_interuobjcoll_callees_sentinel_type_hashtbl = ((Hashtbl.create 32) : ((string, string list)  Hashtbl.t));
						f_interuobjcoll_callees_sentinel_address_hashtbl =((Hashtbl.create 32) : ((string, Defs.Basedefs.uobjcoll_sentinel_address_t)  Hashtbl.t));
						f_legacy_callees_sentinel_type_hashtbl = ((Hashtbl.create 32) : ((string, string list)  Hashtbl.t));
						f_legacy_callees_sentinel_address_hashtbl = ((Hashtbl.create 32) : ((string, Defs.Basedefs.uobjcoll_sentinel_address_t)  Hashtbl.t));  
					} in
					uobj#set_d_slt_info uobj_slt_info;
					Uberspark_logger.log ~lvl:Uberspark_logger.Debug "setup uobj sentinel linkage table information";
					
					uobj#prepare_sources ();
					Uberspark_logger.log ~lvl:Uberspark_logger.Debug "prepared uobj sources";

					if !retval &&  not (uobj#prepare_namespace_for_build ()) then begin
						retval := false;
					end;

					if (uobj#overlay_config_settings ()) then begin
						Uberspark_logger.log ~lvl:Uberspark_logger.Debug "initializing bridges with uobj manifest override...";
						(* save current config settings *)
						Uberspark_config.settings_save ();

						if not (Uberspark_bridge.initialize_from_config ()) then begin
							Uberspark_logger.log ~lvl:Uberspark_logger.Error "Could not build uobj specific bridges!";
							retval := false;
						end;
						
						uobj_bridges_override := true;
					end else begin
						(* uobj manifest did not have any config-settings specified, so use the collection default *)
						Uberspark_logger.log ~lvl:Uberspark_logger.Debug "using uobj collection default bridges...";
						retval := true
					end;

					if !retval &&  not (uobj#build_image ()) then begin
						retval := false;
					end;

					if !retval then begin					
						Uberspark_logger.log "Successfully built uobj '%s'" uobjinfo_entry.f_uobjinfo.f_uobj_name;
					end;

					(* restore config settings if we saved them*)
					if !uobj_bridges_override then begin
						Uberspark_config.settings_restore ();
						(* reload bridges *)
						if not (Uberspark_bridge.initialize_from_config ()) then begin
							Uberspark_logger.log ~lvl:Uberspark_logger.Error "Could not build uobjcoll bridges during config restoration!";
							retval := false;
						end;

					end;
				end
		;


	)!d_uobjcoll_uobjinfo_list;
	end;

	if(!retval == false) then begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not build uobj(s)!";
		(!retval)
	end else

	(* generate uobj binary image section mapping source *)
	let dummy = 0 in begin
	let uobjinfo_list : Defs.Basedefs.uobjinfo_t list ref = ref [] in
	List.iter ( fun (uobjinfo_entry : uobjcoll_uobjinfo_t) -> 
		uobjinfo_list := !uobjinfo_list @ [ uobjinfo_entry.f_uobjinfo ];
	)!d_uobjcoll_uobjinfo_list;
	retval := Uberspark_codegen.Uobjcoll.generate_uobj_binary_image_section_mapping	
		(Uberspark_namespace.namespace_uobjcoll_uobj_binary_image_section_mapping_src_filename)
		 !uobjinfo_list;
	end;

	if(!retval == false) then begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not generate uobj binary image section mapping source!";
		(!retval)
	end else


	(* generate uobjcoll linker script *)
	let dummy = 0 in begin
(*	let uobjinfo_list : Defs.Basedefs.uobjinfo_t list ref = ref [] in
	List.iter ( fun (uobjinfo_entry : uobjcoll_uobjinfo_t) -> 
		uobjinfo_list := !uobjinfo_list @ [ uobjinfo_entry.f_uobjinfo ];
	)!d_uobjcoll_uobjinfo_list;
*)
(*	retval := Uberspark_codegen.Uobjcoll.generate_linker_script	
		(Uberspark_namespace.namespace_uobjcoll_linkerscript_filename)
		 !uobjinfo_list !d_load_address !d_size;
*)
	retval := Uberspark_codegen.Uobjcoll.generate_linker_script	
		Uberspark_namespace.namespace_uobjcoll_linkerscript_filename 
		!d_load_address !d_size !d_memorymapped_sections_list;
	end;

	if(!retval == false) then begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not generate uobjcoll linker script!";
		(!retval)
	end else


	let dummy = 0 in begin
	(* add all the autogenerated asm source files to the list of asm sources *)
	(* TBD: eventually this will just be casm sources *)
	d_sources_asm_file_list := [ 
		Uberspark_namespace.namespace_uobjcoll_uobj_binary_image_section_mapping_src_filename;		
		Uberspark_namespace.namespace_uobjcoll_sentinel_definitions_src_filename
	] @ !d_sources_asm_file_list;
	end;
	

	if not (compile_asm_files ()) then begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not compile one or more uobjcoll asm files!";
		(!retval)
	end else

	let dummy = 0 in begin
	Uberspark_logger.log "built uobjcoll uobj binary image section map source";
	end;

	if not (link_binary_image ()) then begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not link uobjcoll binary image!";
		(!retval)
	end else

	let dummy = 0 in begin
	Uberspark_logger.log "built uobjcoll binary image successfully";
	end;


	(* restore working directory *)
	let dummy = 0 in begin
	ignore(Uberspark_osservices.dir_change r_prevpath);
	Uberspark_logger.log "cleaned up build workspace";
	retval := true;
	end;

	(!retval)
;;
