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
	mutable code_template			: string;
	mutable library_code_template  	: string;	
	mutable sizeof_code_template : int;	
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

(* uobjcoll build directory absolute path *)
let d_builddir = ref "";;


(* manifest json node uberspark-uobjcoll var *)
let json_node_uberspark_uobjcoll_var : Uberspark_manifest.Uobjcoll.json_node_uberspark_uobjcoll_t = 
	{
		namespace = ""; platform = ""; arch = ""; cpu = ""; hpl = "";
		sentinels_intra_uobjcoll = [];
		uobjs = { master = ""; templars = [];};
		init_method = {uobj_namespace = ""; public_method = ""; sentinels = [];};
		public_methods = [];
		loaders = [];
		configdefs_verbatim = false;
		configdefs = [];
	};;



(* default manifest variable definition *)
(* we use this to initialize manifest variables *)
let uberspark_manifest_var_default_value () 
	: Uberspark_manifest.uberspark_manifest_var_t = 
	{
	manifest = {
		namespace = ""; 
		version_min = "any"; 
		version_max = "any";
	};
	uobjcoll = {
		namespace = ""; platform = ""; arch = ""; cpu = ""; hpl = "";
		sentinels_intra_uobjcoll = [];
		uobjs = { master = ""; templars = [];};
		init_method = {uobj_namespace = ""; public_method = ""; sentinels = [];};
		public_methods = [];
		loaders = [];
		configdefs_verbatim = false;
		configdefs = [];
	};
	uobj = {namespace = ""; platform = ""; arch = ""; cpu = ""; 
		sources = {source_h_files= []; source_c_files = []; source_casm_files = []; source_asm_files = [];};
		public_methods = []; intra_uobjcoll_callees = []; inter_uobjcoll_callees = [];
		legacy_callees = []; sections = []; uobjrtl = []; 
		};
	uobjrtl = {namespace = ""; platform = ""; arch = ""; cpu = ""; 
		source_c_files = []; source_casm_files = [];
		};

	sentinel ={namespace = ""; platform = ""; arch = ""; cpu = ""; 
		sizeof_code_template = 0; code_template = ""; library_code_template = "";
		}; 

	};;



(* manifest variable *)
let d_uberspark_manifest_var : Uberspark_manifest.uberspark_manifest_var_t = uberspark_manifest_var_default_value ();;

(* uobjcoll triage directory prefix *)
let d_triage_dir_prefix = ref "";;

(* staging directory prefix *)
let d_staging_dir_prefix = ref "";;

(* assoc list of uobjcoll manifest variables; maps uobjcoll namespace to uobjcoll manifest variable *)
(* TBD: revisions needed for multi-platform uobjcoll *) 
let d_uobjcoll_manifest_var_assoc_list : (string * Uberspark_manifest.uberspark_manifest_var_t) list ref = ref [];; 

(* assoc list of uobj manifest variables; maps uobj namespace to uobj manifest variable *)
let d_uobj_manifest_var_assoc_list : (string * Uberspark_manifest.uberspark_manifest_var_t) list ref = ref [];; 

(* hash table of uobjrtl manifest variables: maps uobjrtl namespace to uobjrtl manifest variable *)
let d_uobjrtl_manifest_var_hashtbl = ((Hashtbl.create 32) : ((string, Uberspark_manifest.uberspark_manifest_var_t)  Hashtbl.t));;
	
(* hash table of sentinel manifest variables: maps sentinel namespace to sentinel manifest variable *)
let d_sentinel_manifest_var_hashtbl = ((Hashtbl.create 32) : ((string, Uberspark_manifest.uberspark_manifest_var_t)  Hashtbl.t));;



(* uobjcoll namespace filesystem path *)
let d_path_ns = ref "";;

(* uobjcoll load address *)
let d_load_address : int ref = ref 0;;

(* uobjcoll size *)
let d_size : int ref = ref 0;;

(* uobjcoll target definition *)
let d_target_def: Defs.Basedefs.target_def_t = {
	platform = ""; 
	arch = ""; 
	cpu = "";
};;


(* assoc list of intrauobjcoll public_methods mapping canonical publicmethod names to Uberspark_uobj.publicmethod_info_t 
as it appears in manifest order*)
let d_uobjs_publicmethods_assoc_list_mf : (string * Uberspark_uobj.publicmethod_info_t) list ref = ref [];; 


(* uobjcoll asm file sources list *)
let d_sources_asm_file_list: string list ref = ref [];;


(* list and hashtbl of uobjs info within uobjcoll *)
let d_uobjcoll_uobjinfo_list : uobjcoll_uobjinfo_t list ref = ref [];;
let d_uobjcoll_uobjinfo_hashtbl = ((Hashtbl.create 32) : ((string, uobjcoll_uobjinfo_t)  Hashtbl.t));; 

(* hashtbl of uobjcoll sentinels mapping sentinel type to sentinel info for uobjcoll init_method sentinels *)
let d_uobjcoll_initmethod_sentinels_hashtbl = ((Hashtbl.create 32) : ((string, uobjcoll_sentinel_info_t)  Hashtbl.t));; 

(* hashtbl of uobjcoll sentinels mapping sentinel type to sentinel info for uobjcoll public_methods sentinels *)
let d_uobjcoll_publicmethods_sentinels_hashtbl = ((Hashtbl.create 32) : ((string, uobjcoll_sentinel_info_t)  Hashtbl.t));; 

(* hashtbl of uobjcoll sentinels mapping sentinel type to sentinel info for intrauobjcoll sentinels *)
let d_uobjcoll_intrauobjcoll_sentinels_hashtbl = ((Hashtbl.create 32) : ((string, uobjcoll_sentinel_info_t)  Hashtbl.t));; 

(* hashtbl of intrauobjcoll public_methods mapping canonical publicmethod names to Uberspark_uobj.publicmethod_info_t *)
let d_uobjs_publicmethods_hashtbl = ((Hashtbl.create 32) : ((string, Uberspark_uobj.publicmethod_info_t)  Hashtbl.t));; 

(* hashtbl of intrauobjcoll public_methods mapping canonical publicmethod names to Uberspark_uobj.publicmethod_info_t; with 
computed publicmethod address *)
let d_uobjs_publicmethods_hashtbl_with_address = ((Hashtbl.create 32) : ((string, Uberspark_uobj.publicmethod_info_t)  Hashtbl.t));; 

(* hashtbl of canonical init-medhod sentinel name to sentinel address mapping for uobjcoll init_method *)
let d_uobjcoll_initmethod_sentinel_address_hashtbl = ((Hashtbl.create 32) : ((string, Defs.Basedefs.uobjcoll_sentinel_address_t)  Hashtbl.t));; 


(* hashtbl of canonical public-medhod sentinel name to sentinel address mapping for uobjcoll public_methods *)
let d_uobjcoll_publicmethods_sentinel_address_hashtbl = ((Hashtbl.create 32) : ((string, Defs.Basedefs.uobjcoll_sentinel_address_t)  Hashtbl.t));; 

(* hashtbl of canonical public-medhod sentinel name to sentinel address mapping for intrauobjcoll public_methods *)
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
	let (rval, mf_json) = (Uberspark_manifest.get_json_for_manifest uobjcoll_mf_filename) in
	
	if (rval == false) then (false)
	else

	(* parse uberspark-uobjcoll node *)
	let rval = (Uberspark_manifest.Uobjcoll.json_node_uberspark_uobjcoll_to_var mf_json
			json_node_uberspark_uobjcoll_var) in

	if (rval == false) then (false)
	else



	let dummy=0 in begin
		d_path_ns := (Uberspark_namespace.get_namespace_staging_dir_prefix ())  ^ "/" ^ json_node_uberspark_uobjcoll_var.namespace;
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "uobj collection path ns=%s" !d_path_ns;
	end;

	(* parse, load and overlay config-settings node, if one is present *)
	(* TBD: reinstate with new config interface *)
	(*if (Uberspark_config.load_from_json mf_json) then begin
		Uberspark_logger.log "loaded and overlaid config-settings from uobjcoll manifest for uobjcoll build";
	end else begin
		Uberspark_logger.log "using default config for uobjcoll build";
    end;*)


	let dummy=0 in begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "uobj collection uobjs=%u" (List.length json_node_uberspark_uobjcoll_var.uobjs.templars);
	end;

	let dummy=0 in begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "intrauobjcoll sentinels=%u" 
			(List.length json_node_uberspark_uobjcoll_var.sentinels_intra_uobjcoll);
	end;

	let dummy=0 in begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "uobjcoll_public_methods sentinels=%u" 
			(List.length json_node_uberspark_uobjcoll_var.public_methods);
	end;

	(true)
;;



(*--------------------------------------------------------------------------*)
(* get sentinel info from sentinel manifest for specified sentinel type *)
(* sentinel_facet = uobjcoll_public_methods or intrauobjcoll *)
(* sentinel_type = string describing sentinel type, e.g. call *)
(*--------------------------------------------------------------------------*)
let get_sentinel_info_for_sentinel_facet_and_type
	(sentinel_facet: string)
	(sentinel_type: string)
	: (bool * uobjcoll_sentinel_info_t) = 

	let retval = ref true in 
	let sentinel_info : uobjcoll_sentinel_info_t = { code_template = ""; library_code_template= ""; sizeof_code_template=0; f_type="";} in
	let sentinel_json_var: Uberspark_manifest.Sentinel.json_node_uberspark_sentinel_t = 
		{namespace = ""; platform = ""; arch = ""; cpu = ""; sizeof_code_template = 0; code_template = ""; library_code_template = "";} in


	(* construct the path to sentinel manifest *)
	let sentinel_mf_filename = ((Uberspark_namespace.get_namespace_staging_dir_prefix ()) ^ "/" ^ 
		Uberspark_namespace.namespace_root ^ "/" ^ Uberspark_namespace.namespace_sentinel ^ "/" ^
		sentinel_facet ^ "/" ^
		json_node_uberspark_uobjcoll_var.arch ^ "/" ^ 
		sentinel_type ^ "/" ^ Uberspark_namespace.namespace_root_mf_filename) in 
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "sentinel_mf_filename=%s" sentinel_mf_filename;
	
	(* read sentinel manifest JSON *)
	let (rval, mf_json) = (Uberspark_manifest.get_json_for_manifest sentinel_mf_filename) in
	
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
		sentinel_info.code_template <- sentinel_json_var.code_template;
		sentinel_info.library_code_template <- sentinel_json_var.library_code_template;
		sentinel_info.sizeof_code_template <- sentinel_json_var.sizeof_code_template;
		sentinel_info.f_type <- sentinel_type;
	end;

	(!retval, sentinel_info)
;;



(*--------------------------------------------------------------------------*)
(* create uobj collection uobjcoll_public_methods and intrauobjcoll sentinels hashtbl *)
(*--------------------------------------------------------------------------*)
let create_uobjcoll_publicmethods_intrauobjcoll_sentinels_hashtbl
	()
	: bool = 

	let retval = ref true in 

	(* iterate over uobjcoll init_method sentinel list and add sentinel info to 
		d_uobjcoll_initmethod_sentinels_hashtbl *)
	List.iter ( fun (sentinel_entry: Uberspark_manifest.Uobjcoll.json_node_uberspark_uobjcoll_initmethod_sentinels_t) -> 
		
		if !retval then begin
			let (rval, sinfo) = (get_sentinel_info_for_sentinel_facet_and_type "init-uobjcoll" sentinel_entry.sentinel_type) in
			if (rval == false) then begin
				retval := false;
			end else begin
				Uberspark_logger.log ~lvl:Uberspark_logger.Debug "initmethod_sentinels_hashtbl: adding key=%s" sentinel_entry.sentinel_type; 

				(*override sizeof_code_template if sentinel_size was specified within manifest *)
				if sentinel_entry.sentinel_size > 0 then begin
					sinfo.sizeof_code_template <- sentinel_entry.sentinel_size;
					Uberspark_logger.log ~lvl:Uberspark_logger.Debug "updating sentinel sizeof_code_template with manifest value = 0x%08x" sentinel_entry.sentinel_size; 
				end;

				
				Hashtbl.add d_uobjcoll_initmethod_sentinels_hashtbl sentinel_entry.sentinel_type sinfo;
			end;
		end;
	) json_node_uberspark_uobjcoll_var.init_method.sentinels;


	(* iterate over uobjcoll_public_methods sentinel list and build sentinel type to sentinel facet hashtbl *)
	let sentinel_type_to_sentinel_facet = ((Hashtbl.create 32) : ((string, string)  Hashtbl.t)) in 
	List.iter ( fun ( (canonical_public_method:string), (pm_sentinel_info: Uberspark_manifest.Uobjcoll.json_node_uberspark_uobjcoll_publicmethods_t)) -> 
		List.iter ( fun (sentinel_type: string) -> 
			if not (Hashtbl.mem sentinel_type_to_sentinel_facet sentinel_type) then begin
				Hashtbl.add sentinel_type_to_sentinel_facet sentinel_type "inter-uobjcoll";
			end;
		) pm_sentinel_info.sentinel_type_list;
	) json_node_uberspark_uobjcoll_var.public_methods;
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "create_sentinels_hashtbl: total unique uobjcoll_public_methods sentinels=%u" 
		(Hashtbl.length sentinel_type_to_sentinel_facet);


	(* now iterate over the uobjcoll_public_methods sentinel type to sentinel facet hashtbl, get the corresponding 
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
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "create_sentinels_hashtbl: total unique uobjcoll_public_methods sentinels=%u" 
		(Hashtbl.length d_uobjcoll_publicmethods_sentinels_hashtbl);


	(* iterate over intrauobjcoll sentinel list and build sentinel type to sentinel facet hashtbl *)
	let sentinel_type_to_sentinel_facet = ((Hashtbl.create 32) : ((string, string)  Hashtbl.t)) in 
	List.iter ( fun (sentinel_type: string) -> 
		if not (Hashtbl.mem sentinel_type_to_sentinel_facet sentinel_type) then begin
			Hashtbl.add sentinel_type_to_sentinel_facet sentinel_type "intra-uobjcoll";
		end;
	) json_node_uberspark_uobjcoll_var.sentinels_intra_uobjcoll;

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
	if not (json_node_uberspark_uobjcoll_var.uobjs.master = "") then begin
		
			let (rval, uobj_name, uobjcoll_name) = (Uberspark_namespace.get_uobj_uobjcoll_name_from_uobj_namespace json_node_uberspark_uobjcoll_var.uobjs.master) in
			if (rval) then begin
				let uobjinfo_entry : uobjcoll_uobjinfo_t = { f_uobj = None; 
					f_uobjinfo = { f_uobj_name = ""; uobj_namespace = "";  
					f_uobj_srcpath = ""; f_uobj_buildpath = ""; f_uobj_nspath = "" ; f_uobj_is_incollection = false; 
					f_uobj_is_prime  = false; f_uobj_load_address = 0; f_uobj_size = 0;}; } in

				uobjinfo_entry.f_uobj <- Some new Uberspark_uobj.uobject;
				uobjinfo_entry.f_uobjinfo.f_uobj_name <- uobj_name;
				uobjinfo_entry.f_uobjinfo.uobj_namespace <- json_node_uberspark_uobjcoll_var.uobjs.master;
				uobjinfo_entry.f_uobjinfo.f_uobj_is_prime <- true;
				uobjinfo_entry.f_uobjinfo.f_uobj_buildpath <- (uobjcoll_abs_path ^ "/" ^ uobjcoll_builddir ^ "/" ^ uobj_name);
				uobjinfo_entry.f_uobjinfo.f_uobj_nspath <- ((Uberspark_namespace.get_namespace_staging_dir_prefix ()) ^ "/" ^ json_node_uberspark_uobjcoll_var.uobjs.master);

				if (Uberspark_namespace.is_uobj_ns_in_uobjcoll_ns json_node_uberspark_uobjcoll_var.uobjs.master
					json_node_uberspark_uobjcoll_var.namespace) then begin
					uobjinfo_entry.f_uobjinfo.f_uobj_is_incollection <- true;
				end else begin
					uobjinfo_entry.f_uobjinfo.f_uobj_is_incollection <- false;
				end;

				if uobjinfo_entry.f_uobjinfo.f_uobj_is_incollection then begin
					uobjinfo_entry.f_uobjinfo.f_uobj_srcpath <- (uobjcoll_abs_path ^ "/" ^ uobj_name);
				end else begin
					uobjinfo_entry.f_uobjinfo.f_uobj_srcpath <- ((Uberspark_namespace.get_namespace_staging_dir_prefix ()) ^ "/" ^ json_node_uberspark_uobjcoll_var.uobjs.master);
				end;

				d_uobjcoll_uobjinfo_list := !d_uobjcoll_uobjinfo_list @ [ uobjinfo_entry ];

			    if (Hashtbl.mem d_uobjcoll_uobjinfo_hashtbl json_node_uberspark_uobjcoll_var.uobjs.master) then begin
					(* there is already another uobj with the same ns within the collection, so bail out *)
					Uberspark_logger.log ~lvl:Uberspark_logger.Error "multiple uobjs with same namespace!";
					retval := false;
		    	end else begin
					Hashtbl.add d_uobjcoll_uobjinfo_hashtbl json_node_uberspark_uobjcoll_var.uobjs.master uobjinfo_entry;
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
	List.iter (fun templar_uobj_namespace ->

			let (rval, uobj_name, uobjcoll_name) = (Uberspark_namespace.get_uobj_uobjcoll_name_from_uobj_namespace templar_uobj_namespace) in
			if (rval) && !retval then begin
				let uobjinfo_entry : uobjcoll_uobjinfo_t = { f_uobj = None; 
					f_uobjinfo = { f_uobj_name = ""; uobj_namespace = "";  
					f_uobj_srcpath = ""; f_uobj_buildpath = ""; f_uobj_nspath = "" ; f_uobj_is_incollection = false; 
					f_uobj_is_prime  = false; f_uobj_load_address = 0; f_uobj_size = 0;}; } in

				uobjinfo_entry.f_uobj <- Some new Uberspark_uobj.uobject;
				uobjinfo_entry.f_uobjinfo.f_uobj_name <- uobj_name;
				uobjinfo_entry.f_uobjinfo.uobj_namespace <- templar_uobj_namespace;
				uobjinfo_entry.f_uobjinfo.f_uobj_is_prime <- false;
				uobjinfo_entry.f_uobjinfo.f_uobj_buildpath <- (uobjcoll_abs_path ^ "/" ^ uobjcoll_builddir ^ "/" ^ uobj_name);
				uobjinfo_entry.f_uobjinfo.f_uobj_nspath <- ((Uberspark_namespace.get_namespace_staging_dir_prefix ()) ^ "/" ^ templar_uobj_namespace);

				if (Uberspark_namespace.is_uobj_ns_in_uobjcoll_ns templar_uobj_namespace json_node_uberspark_uobjcoll_var.namespace) then begin
					uobjinfo_entry.f_uobjinfo.f_uobj_is_incollection <- true;
				end else begin
					uobjinfo_entry.f_uobjinfo.f_uobj_is_incollection <- false;
				end;

				if uobjinfo_entry.f_uobjinfo.f_uobj_is_incollection then begin
					uobjinfo_entry.f_uobjinfo.f_uobj_srcpath <- (uobjcoll_abs_path ^ "/" ^ uobj_name);
				end else begin
					uobjinfo_entry.f_uobjinfo.f_uobj_srcpath <- ((Uberspark_namespace.get_namespace_staging_dir_prefix ()) ^ "/" ^ templar_uobj_namespace);
				end;

				d_uobjcoll_uobjinfo_list := !d_uobjcoll_uobjinfo_list @ [ uobjinfo_entry ];

			    if (Hashtbl.mem d_uobjcoll_uobjinfo_hashtbl templar_uobj_namespace) then begin
					(* there is already another uobj with the same ns within the collection, so bail out *)
					Uberspark_logger.log ~lvl:Uberspark_logger.Error "multiple uobjs with same namespace!";
					retval := false;
		    	end else begin
					Hashtbl.add d_uobjcoll_uobjinfo_hashtbl templar_uobj_namespace uobjinfo_entry;
		    	end;

			end else begin
				retval := false;
			end;

	) json_node_uberspark_uobjcoll_var.uobjs.templars;
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
	: bool = 

	let retval = ref true in 

	List.iter ( fun (uobjinfo_entry : uobjcoll_uobjinfo_t) -> 
		
		if(!retval) then begin
			match uobjinfo_entry.f_uobj with 
				| None ->
					Uberspark_logger.log ~lvl:Uberspark_logger.Error "invalid uobj!";
					retval := false;

				| Some uobj ->
					Uberspark_logger.log "initializing uobj '%s'..." uobjinfo_entry.f_uobjinfo.f_uobj_name;
					let rval = (uobj#initialize ~builddir:Uberspark_namespace.namespace_uobj_build_dir 
						(uobjinfo_entry.f_uobjinfo.f_uobj_buildpath ^ "/" ^ Uberspark_namespace.namespace_root_mf_filename) 
						d_target_def 0) in
					
					if (rval) then begin
						Uberspark_logger.log "uobj '%s' successfully initialized; size=0x%08x" uobjinfo_entry.f_uobjinfo.f_uobj_name 
							uobj#get_d_size;
					end else begin
						Uberspark_logger.log "unable to initialize uobj '%s'" uobjinfo_entry.f_uobjinfo.f_uobj_name;
						retval := false;
					end;
			;
		end;

	)!d_uobjcoll_uobjinfo_list;

	(!retval)
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


	(* add init-uobjcoll sentinels *)
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "proceeding to add init-uobjcoll sentinel sections...";
	List.iter ( fun (sentinel_entry: Uberspark_manifest.Uobjcoll.json_node_uberspark_uobjcoll_initmethod_sentinels_t) ->

		let sentinel_type = sentinel_entry.sentinel_type in

		(* add section *)
		let canonical_public_method = (Uberspark_namespace.get_variable_name_prefix_from_ns json_node_uberspark_uobjcoll_var.init_method.uobj_namespace) ^ "__" ^ json_node_uberspark_uobjcoll_var.init_method.public_method in
		let sentinel_name = (canonical_public_method ^ "__" ^ sentinel_type) in 
		let key = (".section_uobjcoll_initmethod_sentinel__" ^ sentinel_name) in 
		let sentinel_info = Hashtbl.find d_uobjcoll_initmethod_sentinels_hashtbl sentinel_type in
		(*let section_size = 	sentinel_info.sizeof_code_template + (Uberspark_config.json_node_uberspark_config_var.uobjcoll_binary_image_section_alignment - 
			(sentinel_info.sizeof_code_template mod Uberspark_config.json_node_uberspark_config_var.uobjcoll_binary_image_section_alignment)) in
		*)

		let section_top_addr = 	ref 0 in
		section_top_addr := sentinel_info.sizeof_code_template + !uobjcoll_section_load_addr;
		if (!section_top_addr mod Uberspark_config.json_node_uberspark_config_var.uobjcoll_binary_image_section_alignment) > 0 then begin
			section_top_addr := !section_top_addr +  (Uberspark_config.json_node_uberspark_config_var.uobjcoll_binary_image_section_alignment - 
			(!section_top_addr mod Uberspark_config.json_node_uberspark_config_var.uobjcoll_binary_image_section_alignment));
		end;

		let section_size = !section_top_addr - !uobjcoll_section_load_addr in

		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "sentinel type=%s, original size=0x%08x, adjusted size=0x%08x" sentinel_info.f_type sentinel_info.sizeof_code_template section_size;

		d_memorymapped_sections_list := !d_memorymapped_sections_list @ [ (key, 
			{ fn_name = key;	
				f_subsection_list = [ key; ];	
				usbinformat = { f_type=Defs.Binformat.const_USBINFORMAT_SECTION_TYPE_UOBJCOLL_INITMETHOD_SENTINEL; 
								f_prot=0; 
								f_size = section_size;
								f_aligned_at = Uberspark_config.json_node_uberspark_config_var.uobjcoll_binary_image_section_alignment; 
								f_pad_to = Uberspark_config.json_node_uberspark_config_var.uobjcoll_binary_image_section_alignment; 
								f_addr_start = !uobjcoll_section_load_addr; 
								f_addr_file = 0;
								f_reserved = 0;
							};
			}) ];

		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "added section for uobjcoll_init_method sentinel '%s' at 0x%08x, size=%08x..." 
			key !uobjcoll_section_load_addr section_size;

		(* update next section address *)
		uobjcoll_section_load_addr := !uobjcoll_section_load_addr + section_size; 
	
	) json_node_uberspark_uobjcoll_var.init_method.sentinels;



	(* add inter-uobjcoll entry point sentinels *)
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "proceeding to add inter-uobjcoll sentinel sections...";
	
	List.iter ( fun ( (public_method:string), (pm_sentinel_info:Uberspark_manifest.Uobjcoll.json_node_uberspark_uobjcoll_publicmethods_t))  ->
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "public_method=%s" public_method;
		
		List.iter ( fun (sentinel_type:string) ->
		
			(* add section *)
			let sentinel_name = public_method ^ "__" ^ sentinel_type in 
			let key = (".section_uobjcoll_publicmethod_sentinel__" ^ sentinel_name) in 
			let sentinel_info = Hashtbl.find d_uobjcoll_publicmethods_sentinels_hashtbl sentinel_type in
			let section_size = 	sentinel_info.sizeof_code_template + (Uberspark_config.json_node_uberspark_config_var.uobjcoll_binary_image_section_alignment - 
				(sentinel_info.sizeof_code_template mod Uberspark_config.json_node_uberspark_config_var.uobjcoll_binary_image_section_alignment)) in

			Uberspark_logger.log ~lvl:Uberspark_logger.Debug "sentinel type=%s, size=0x%08x" sentinel_info.f_type sentinel_info.sizeof_code_template;

			d_memorymapped_sections_list := !d_memorymapped_sections_list @ [ (key, 
				{ fn_name = key;	
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

			Uberspark_logger.log ~lvl:Uberspark_logger.Debug "added section for uobjcoll_public_methods sentinel '%s' at 0x%08x, size=%08x..." 
				key !uobjcoll_section_load_addr section_size;


			(* update next section address *)
			uobjcoll_section_load_addr := !uobjcoll_section_load_addr + section_size; 
		
		) pm_sentinel_info.sentinel_type_list;

	) json_node_uberspark_uobjcoll_var.public_methods;


	(* add intra-uobjcoll sentinel sections *)
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "proceeding to add intra-uobjcoll sentinel sections...";
	
	List.iter (fun ((public_method:string) ,(pm_info:Uberspark_uobj.publicmethod_info_t))  ->
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "public_method=%s" public_method;

		List.iter ( fun (sentinel_type:string) ->

			(* add section *)
			let sentinel_name = public_method ^ "__" ^ sentinel_type in 
			let key = (".section_intrauobjcoll_publicmethod_sentinel__" ^ sentinel_name) in 
			let sentinel_info = Hashtbl.find d_uobjcoll_intrauobjcoll_sentinels_hashtbl sentinel_type in
			let section_size = 	sentinel_info.sizeof_code_template + (Uberspark_config.json_node_uberspark_config_var.uobjcoll_binary_image_section_alignment - 
				(sentinel_info.sizeof_code_template mod Uberspark_config.json_node_uberspark_config_var.uobjcoll_binary_image_section_alignment)) in

			Uberspark_logger.log ~lvl:Uberspark_logger.Debug "sentinel type=%s, size=0x%08x" sentinel_info.f_type sentinel_info.sizeof_code_template;

			d_memorymapped_sections_list := !d_memorymapped_sections_list @ [ (key, 
				{ fn_name = key;	
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

		) json_node_uberspark_uobjcoll_var.sentinels_intra_uobjcoll;

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
					{ fn_name = key;	
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

				List.iter (fun ((public_method:string), (throw_away:Uberspark_manifest.Uobj.json_node_uberspark_uobj_publicmethods_t))  ->
					let assoc_key = uobjinfo_entry.f_uobjinfo.uobj_namespace in 
					let assoc_key_public_method = ((Uberspark_namespace.get_variable_name_prefix_from_ns assoc_key) ^ "__" ^ public_method) in
					let pm_info : Uberspark_manifest.Uobj.json_node_uberspark_uobj_publicmethods_t = (Hashtbl.find publicmethods_hashtbl public_method) in
					publicmethods_list := !publicmethods_list @ [ (assoc_key_public_method, { f_uobjpminfo = pm_info;
						f_uobjinfo = uobjinfo_entry.f_uobjinfo;}) ];
				) uobj#get_d_publicmethods_assoc_list;

		;

	)!d_uobjcoll_uobjinfo_list;

	(* dump uobjs publc methods association list *)
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "uobjcoll uobjs public_methods assoc list dump follows:"; 
	List.iter (fun ((canonical_public_method:string), (entry:Uberspark_uobj.publicmethod_info_t))  ->
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "canonical public_method=%s; public_method=%s, pm_addr=0x%08x" 
			canonical_public_method entry.f_uobjpminfo.fn_name entry.f_uobjpminfo.fn_address; 
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
				
				Hashtbl.iter (fun (public_method:string) (pm_info:Uberspark_manifest.Uobj.json_node_uberspark_uobj_publicmethods_t)  ->
					let htbl_key = uobjinfo_entry.f_uobjinfo.uobj_namespace in 
					let htbl_key_public_method = ((Uberspark_namespace.get_variable_name_prefix_from_ns htbl_key) ^ "__" ^ public_method) in
					Hashtbl.add publicmethods_hashtbl htbl_key_public_method { f_uobjpminfo = pm_info;
						f_uobjinfo = uobjinfo_entry.f_uobjinfo;}
				) uobj#get_d_publicmethods_hashtbl;

		;

	)!d_uobjcoll_uobjinfo_list;

	(* dump uobjs publc methods hashtable *)
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "uobjcoll uobjs public_methods hashtbl dump follows:"; 
	Hashtbl.iter (fun (canonical_public_method:string) (entry:Uberspark_uobj.publicmethod_info_t)  ->
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "canonical public_method=%s; public_method=%s, pm_addr=0x%08x" 
			canonical_public_method entry.f_uobjpminfo.fn_name entry.f_uobjpminfo.fn_address; 
	) publicmethods_hashtbl;



	()
;;



(*--------------------------------------------------------------------------*)
(* prepare list of sentinels for uobjcoll sentinel code generation *)
(*--------------------------------------------------------------------------*)
let prepare_for_uobjcoll_sentinel_codegen
	()
	: unit = 

	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "prepare_for_uobjcoll_sentinel_codegen: uobjcoll_init_method=%s:%s" 
		json_node_uberspark_uobjcoll_var.init_method.uobj_namespace
		json_node_uberspark_uobjcoll_var.init_method.public_method;

	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "prepare_for_uobjcoll_sentinel_codegen: uobjcoll_public_methods public_methods=%u" 
		(List.length json_node_uberspark_uobjcoll_var.public_methods);

	(* add uobjcoll_init_method sentinels *)
	List.iter ( fun (sentinel_entry: Uberspark_manifest.Uobjcoll.json_node_uberspark_uobjcoll_initmethod_sentinels_t) ->

		let sentinel_type = sentinel_entry.sentinel_type in
		let canonical_public_method = (Uberspark_namespace.get_variable_name_prefix_from_ns json_node_uberspark_uobjcoll_var.init_method.uobj_namespace) ^ "__" ^ json_node_uberspark_uobjcoll_var.init_method.public_method in
		let sentinel_info : uobjcoll_sentinel_info_t = Hashtbl.find d_uobjcoll_initmethod_sentinels_hashtbl sentinel_type in
		let pm_info : Uberspark_uobj.publicmethod_info_t = Hashtbl.find d_uobjs_publicmethods_hashtbl_with_address canonical_public_method in
		let codegen_sinfo_entry : Uberspark_codegen.Uobjcoll.sentinel_info_t = { 
			f_type= sentinel_type;
			fn_name = canonical_public_method ^ "__" ^ sentinel_type; 
			f_secname = ".section_uobjcoll_initmethod_sentinel__" ^ (canonical_public_method ^ "__" ^ sentinel_type);
			code_template = sentinel_info.code_template ; 
			library_code_template= sentinel_info.library_code_template ; 
			sizeof_code_template= sentinel_info.sizeof_code_template ; 
			fn_address= (Hashtbl.find d_uobjcoll_initmethod_sentinel_address_hashtbl (canonical_public_method ^ "__" ^ sentinel_type)).f_sentinel_addr; 
			f_pm_addr = pm_info.f_uobjpminfo.fn_address;
		} in 

		d_sentinel_info_for_codegen_list := !d_sentinel_info_for_codegen_list @ [ codegen_sinfo_entry ] ;
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "uobjcoll_init_method; added sentinel type %s for public-method %s" sentinel_type canonical_public_method;

	) json_node_uberspark_uobjcoll_var.init_method.sentinels; 


	(* add uobjcoll_public_methods public_methods sentinels *)
	List.iter ( fun ((canonical_public_method:string), (pm_sentinel_info:Uberspark_manifest.Uobjcoll.json_node_uberspark_uobjcoll_publicmethods_t)) ->
		List.iter ( fun (sentinel_type:string) ->

			let sentinel_info : uobjcoll_sentinel_info_t = Hashtbl.find d_uobjcoll_publicmethods_sentinels_hashtbl sentinel_type in
			let pm_info : Uberspark_uobj.publicmethod_info_t = Hashtbl.find d_uobjs_publicmethods_hashtbl_with_address canonical_public_method in
			let codegen_sinfo_entry : Uberspark_codegen.Uobjcoll.sentinel_info_t = { 
				f_type= sentinel_type;
				fn_name = canonical_public_method ^ "__" ^ sentinel_type; 
				f_secname = ".section_uobjcoll_publicmethod_sentinel__" ^ (canonical_public_method ^ "__" ^ sentinel_type);
				code_template = sentinel_info.code_template ; 
				library_code_template= sentinel_info.library_code_template ; 
				sizeof_code_template= sentinel_info.sizeof_code_template ; 
				fn_address= (Hashtbl.find d_uobjcoll_publicmethods_sentinel_address_hashtbl (canonical_public_method ^ "__" ^ sentinel_type)).f_sentinel_addr; 
				f_pm_addr = pm_info.f_uobjpminfo.fn_address;
			} in 

			d_sentinel_info_for_codegen_list := !d_sentinel_info_for_codegen_list @ [ codegen_sinfo_entry ] ;
			Uberspark_logger.log ~lvl:Uberspark_logger.Debug "uobjcoll_public_methods; added sentinel type %s for public-method %s" sentinel_type canonical_public_method;

		) pm_sentinel_info.sentinel_type_list; 
	) json_node_uberspark_uobjcoll_var.public_methods;


	(* add intrauobjcoll public_methods sentinels *)
	List.iter ( fun ((canonical_public_method:string), (throwaway:Uberspark_uobj.publicmethod_info_t)) ->
		List.iter ( fun (sentinel_type:string) ->

			let sentinel_info : uobjcoll_sentinel_info_t = Hashtbl.find d_uobjcoll_publicmethods_sentinels_hashtbl sentinel_type in
			let pm_info : Uberspark_uobj.publicmethod_info_t = Hashtbl.find d_uobjs_publicmethods_hashtbl_with_address canonical_public_method in
			let codegen_sinfo_entry : Uberspark_codegen.Uobjcoll.sentinel_info_t = { 
				f_type= sentinel_type;
				fn_name = canonical_public_method ^ "__" ^ sentinel_type; 
				f_secname = ".section_intrauobjcoll_publicmethod_sentinel__" ^ (canonical_public_method ^ "__" ^ sentinel_type);
				code_template = sentinel_info.code_template ; 
				library_code_template= sentinel_info.library_code_template ; 
				sizeof_code_template= sentinel_info.sizeof_code_template ; 
				fn_address= (Hashtbl.find d_intrauobjcoll_publicmethods_sentinel_address_hashtbl (canonical_public_method ^ "__" ^ sentinel_type)).f_sentinel_addr; 
				f_pm_addr = pm_info.f_uobjpminfo.fn_address;
			} in 

			d_sentinel_info_for_codegen_list := !d_sentinel_info_for_codegen_list @ [ codegen_sinfo_entry ] ;
			Uberspark_logger.log ~lvl:Uberspark_logger.Debug "intrauobjcoll; added sentinel type %s for public-method %s" sentinel_type canonical_public_method;

		) json_node_uberspark_uobjcoll_var.sentinels_intra_uobjcoll; 
	) !d_uobjs_publicmethods_assoc_list_mf;



	(* debug: dump all the sentinels in codegen list *)
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "dump of list of sentinels for codegen follows:";
	List.iter ( fun (codegen_sinfo_entry : Uberspark_codegen.Uobjcoll.sentinel_info_t) ->
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "name=%s, addr=0x%08x, pm_addr=0x%08x" 
			codegen_sinfo_entry.fn_name codegen_sinfo_entry.fn_address codegen_sinfo_entry.f_pm_addr;
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

	List.iter ( fun ( (canonical_public_method:string), (pm_info: Uberspark_uobj.publicmethod_info_t)) ->
		Hashtbl.add d_intrauobjcoll_callees_sentinel_type_hashtbl canonical_public_method json_node_uberspark_uobjcoll_var.sentinels_intra_uobjcoll;
	) !d_uobjs_publicmethods_assoc_list_mf;

	()
;;



(*--------------------------------------------------------------------------*)
(* setup contents of uobjcoll init_method seninel address hashtbl *)
(*--------------------------------------------------------------------------*)
let setup_uobjcoll_initmethod_sentinel_address_hashtbl
	()
	: unit = 

	let canonical_public_method = (Uberspark_namespace.get_variable_name_prefix_from_ns json_node_uberspark_uobjcoll_var.init_method.uobj_namespace) ^ "__" ^ json_node_uberspark_uobjcoll_var.init_method.public_method in
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "init_method canonical_public_method=%s" canonical_public_method;

	List.iter ( fun (sentinel_entry: Uberspark_manifest.Uobjcoll.json_node_uberspark_uobjcoll_initmethod_sentinels_t) ->

		let sentinel_type = sentinel_entry.sentinel_type in
		let canonical_pm_sentinel_name = (canonical_public_method ^ "__" ^ sentinel_type) in 
		let key = (".section_uobjcoll_initmethod_sentinel__" ^ canonical_pm_sentinel_name) in 

		(* grab section information for this sentinel *)
		let section_info = (List.assoc key !d_memorymapped_sections_list) in
		(* grab sentinel address *)
		let sentinel_addr = section_info.usbinformat.f_addr_start in
		let pm_info : Uberspark_uobj.publicmethod_info_t = Hashtbl.find d_uobjs_publicmethods_hashtbl_with_address canonical_public_method in
		(*grab public method address *)
		let pm_addr = pm_info.f_uobjpminfo.fn_address in


		(* add entry into d_uobjcoll_initmethod_sentinel_address_hashtbl *)
		let sentinel_addr_info : Defs.Basedefs.uobjcoll_sentinel_address_t = {
			f_pm_addr = pm_addr;
			f_sentinel_addr = sentinel_addr;
		} in 
		if (Hashtbl.mem d_uobjcoll_initmethod_sentinel_address_hashtbl canonical_pm_sentinel_name) then begin
			Hashtbl.replace d_uobjcoll_initmethod_sentinel_address_hashtbl canonical_pm_sentinel_name sentinel_addr_info;
		end else begin
			Hashtbl.add d_uobjcoll_initmethod_sentinel_address_hashtbl canonical_pm_sentinel_name sentinel_addr_info;
		end;

	) json_node_uberspark_uobjcoll_var.init_method.sentinels;

	()
;;


(*--------------------------------------------------------------------------*)
(* setup contents of uobjcoll public_methods seninel address hashtbl *)
(*--------------------------------------------------------------------------*)
let setup_uobjcoll_publicmethods_sentinel_address_hashtbl
	()
	: unit = 

	List.iter ( fun ( (canonical_public_method:string), (pm_sentinel_info:Uberspark_manifest.Uobjcoll.json_node_uberspark_uobjcoll_publicmethods_t))  ->
		List.iter ( fun (sentinel_type:string) ->
			let canonical_pm_sentinel_name = (canonical_public_method ^ "__" ^ sentinel_type) in 
			let key = (".section_uobjcoll_publicmethod_sentinel__" ^ canonical_pm_sentinel_name) in 

			(* grab section information for this sentinel *)
			let section_info = (List.assoc key !d_memorymapped_sections_list) in
			(* grab sentinel address *)
			let sentinel_addr = section_info.usbinformat.f_addr_start in
			let pm_info : Uberspark_uobj.publicmethod_info_t = Hashtbl.find d_uobjs_publicmethods_hashtbl_with_address canonical_public_method in
			(*grab public method address *)
			let pm_addr = pm_info.f_uobjpminfo.fn_address in


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

		) pm_sentinel_info.sentinel_type_list;
	) json_node_uberspark_uobjcoll_var.public_methods;

	()
;;



(*--------------------------------------------------------------------------*)
(* setup contents of intrauobjcoll public_methods seninel address hashtbl *)
(*--------------------------------------------------------------------------*)
let setup_intrauobjcoll_publicmethods_sentinel_address_hashtbl
	()
	: unit = 

	List.iter (fun ((canonical_public_method:string) ,(throwaway:Uberspark_uobj.publicmethod_info_t))  ->
		List.iter ( fun (sentinel_type:string) ->
			let canonical_pm_sentinel_name = (canonical_public_method ^ "__" ^ sentinel_type) in 
			let key = (".section_intrauobjcoll_publicmethod_sentinel__" ^ canonical_pm_sentinel_name) in 

			(* grab section information for this sentinel *)
			let section_info = (List.assoc key !d_memorymapped_sections_list) in
			(* grab sentinel address *)
			let sentinel_addr = section_info.usbinformat.f_addr_start in
			let pm_info : Uberspark_uobj.publicmethod_info_t = Hashtbl.find d_uobjs_publicmethods_hashtbl_with_address canonical_public_method in
			(*grab public method address *)
			let pm_addr = pm_info.f_uobjpminfo.fn_address in


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

		) json_node_uberspark_uobjcoll_var.sentinels_intra_uobjcoll;
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
	let uobjcoll_canonical_namespace = json_node_uberspark_uobjcoll_var.namespace in
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
(* install uobjcoll headers to namespace *)
(*--------------------------------------------------------------------------*)
let install_h_files_ns 
	?(context_path_builddir = ".")
	: unit =
	
	let uobjcoll_path_to_mf_filename = !d_path_to_mf_filename in
	let uobjcoll_path_ns = !d_path_ns in
	
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "d_path_to_mf_filename=%s" uobjcoll_path_to_mf_filename;
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "d_path_ns=%s" uobjcoll_path_ns;
	
	(* create namespace include folder if not already present *)
	Uberspark_osservices.mkdir ~parent:true (uobjcoll_path_ns ^ "/include") (`Octal 0o0777);


	(* TBD: copy h files to namespace by using uobjcoll manifest if specified *)
	(*List.iter ( fun h_filename -> 
		Uberspark_osservices.mkdir ~parent:true (uobj_path_ns ^ "/" ^ (Filename.dirname h_filename)) (`Octal 0o0777);
		Uberspark_osservices.cp (uobj_path_to_mf_filename ^ "/" ^ h_filename) (uobj_path_ns ^ "/" ^ h_filename);
	) json_node_uberspark_uobj_var.sources.source_h_files;
	*)

	(* copy top-level header to namespace *)
	Uberspark_osservices.file_copy (uobjcoll_path_to_mf_filename ^ "/" ^ context_path_builddir ^ "/" ^ Uberspark_namespace.namespace_uobjcoll_top_level_include_header_src_filename)
		(uobjcoll_path_ns ^ "/include/" ^ Uberspark_namespace.namespace_uobjcoll_top_level_include_header_src_filename);

;;


(*--------------------------------------------------------------------------*)
(* compile asm files *)
(*--------------------------------------------------------------------------*)
let compile_asm_files	
	()
	: bool = 
	
	let retval = ref false in

	retval := Uberspark_bridge.as_bridge#invoke 
				~context_path_builddir:Uberspark_namespace.namespace_uobjcoll_build_dir 
				[
					("@@BRIDGE_INPUT_FILES@@", (Uberspark_bridge.bridge_parameter_to_string !d_sources_asm_file_list));
					("@@BRIDGE_SOURCE_FILES@@", (Uberspark_bridge.bridge_parameter_to_string !d_sources_asm_file_list));
					("@@BRIDGE_INCLUDE_DIRS@@", (Uberspark_bridge.bridge_parameter_to_string [ "."; (Uberspark_namespace.get_namespace_staging_dir_prefix ()) ]));
					("@@BRIDGE_INCLUDE_DIRS_WITH_PREFIX@@", (Uberspark_bridge.bridge_parameter_to_string ~prefix:"-I " [ "."; (Uberspark_namespace.get_namespace_staging_dir_prefix ()) ]));
					("@@BRIDGE_COMPILEDEFS@@", (Uberspark_bridge.bridge_parameter_to_string [ "__ASSEMBLY__" ]));
					("@@BRIDGE_COMPILEDEFS_WITH_PREFIX@@", (Uberspark_bridge.bridge_parameter_to_string ~prefix:"-D " [ "__ASSEMBLY__" ]));
					("@@BRIDGE_DEFS@@", (Uberspark_bridge.bridge_parameter_to_string [ "__ASSEMBLY__" ]));
					("@@BRIDGE_DEFS_WITH_PREFIX@@", (Uberspark_bridge.bridge_parameter_to_string ~prefix:"-D " [ "__ASSEMBLY__" ]));
					("@@BRIDGE_PLUGIN_DIR@@", ((Uberspark_namespace.get_namespace_root_dir_prefix ()) ^ "/" ^
					Uberspark_namespace.namespace_root ^ "/" ^ Uberspark_namespace.namespace_root_vf_bridge_plugin));
					("@@BRIDGE_CONTAINER_MOUNT_POINT@@", Uberspark_namespace.namespace_bridge_container_mountpoint);
				];


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


(*	retval := Uberspark_bridge.ld_bridge#invoke 
		~context_path_builddir:Uberspark_namespace.namespace_uobjcoll_build_dir 
		Uberspark_namespace.namespace_uobjcoll_linkerscript_filename
		Uberspark_namespace.namespace_uobjcoll_binary_image_filename
		Uberspark_namespace.namespace_uobjcoll_binary_flat_image_filename
		""
		!o_file_list
		".";
*)

	retval := Uberspark_bridge.ld_bridge#invoke 
				~context_path_builddir:Uberspark_namespace.namespace_uobjcoll_build_dir 
				[
					("@@BRIDGE_INPUT_FILES@@", (Uberspark_bridge.bridge_parameter_to_string !o_file_list));
					("@@BRIDGE_SOURCE_FILES@@", (Uberspark_bridge.bridge_parameter_to_string !o_file_list));
					("@@BRIDGE_INCLUDE_DIRS@@", "");
					("@@BRIDGE_INCLUDE_DIRS_WITH_PREFIX@@", "");
					("@@BRIDGE_COMPILEDEFS@@", "");
					("@@BRIDGE_COMPILEDEFS_WITH_PREFIX@@", "");
					("@@BRIDGE_DEFS@@", "");
					("@@BRIDGE_DEFS_WITH_PREFIX@@", "");
					("@@BRIDGE_PLUGIN_DIR@@", ((Uberspark_namespace.get_namespace_root_dir_prefix ()) ^ "/" ^
					Uberspark_namespace.namespace_root ^ "/" ^ Uberspark_namespace.namespace_root_vf_bridge_plugin));
					("@@BRIDGE_CONTAINER_MOUNT_POINT@@", Uberspark_namespace.namespace_bridge_container_mountpoint);
					("@@BRIDGE_LSCRIPT_FILENAME@@", Uberspark_namespace.namespace_uobjcoll_linkerscript_filename);
					("@@BRIDGE_BINARY_FILENAME@@", Uberspark_namespace.namespace_uobjcoll_binary_image_filename);
					("@@BRIDGE_BINARY_FLAT_FILENAME@@", Uberspark_namespace.namespace_uobjcoll_binary_flat_image_filename);
					("@@BRIDGE_CCLIB_FILENAME@@", "");

				];



	(!retval)	
;;


(*--------------------------------------------------------------------------*)
(* initialize common operation context for verify, compile and build *)
(* operations *)
(*--------------------------------------------------------------------------*)
let initialize_common_operation_context
	(uobjcoll_path_ns : string)
	(target_def : Defs.Basedefs.target_def_t)
	(uobjcoll_load_address : int)
	: bool * string =

	(* local variables *)
	let retval = ref false in
	let in_namespace_build = ref false in
	let r_prevpath_result = ref "" in 

	let dummy = 0 in begin
	
	(* store global initialization variables *)
	d_load_address := uobjcoll_load_address;
	d_target_def.platform <- target_def.platform;
	d_target_def.cpu <- target_def.cpu;
	d_target_def.arch <- target_def.arch;
	
	end;


	(* get uobj collection absolute path *)
	let (rval, abs_uobjcoll_path) = (Uberspark_osservices.abspath uobjcoll_path_ns) in
	if(rval == false) then begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not obtain absolute path for uobjcoll: %s" abs_uobjcoll_path;
		(!retval, !r_prevpath_result)
	end else

	(* switch working directory to uobjcoll source path *)
	let (rval, r_prevpath, r_curpath) = (Uberspark_osservices.dir_change abs_uobjcoll_path) in
	if(rval == false) then begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not switch to uobjcoll source directory: %s" abs_uobjcoll_path;
		(!retval, !r_prevpath_result)
	end else

	(* create _build folder and store the absolute path of build folder*)
	let dummy = 0 in begin
	Uberspark_osservices.mkdir ~parent:true Uberspark_namespace.namespace_uobjcoll_build_dir (`Octal 0o0777);
	d_builddir := (abs_uobjcoll_path ^ "/" ^ Uberspark_namespace.namespace_uobjcoll_build_dir);
	end;

	(* switch working directory to uobjcoll _build folder *)
	let (rval, r_prevpath, r_curpath) = (Uberspark_osservices.dir_change (abs_uobjcoll_path ^ "/" ^ Uberspark_namespace.namespace_uobjcoll_build_dir)) in
	if(rval == false) then begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not switch to uobjcoll build folder: %s" 
			(abs_uobjcoll_path ^ "/" ^ Uberspark_namespace.namespace_uobjcoll_build_dir);
		(!retval, !r_prevpath_result)
	end else




    (* parse uobjcoll manifest *)
	let uobjcoll_mf_filename = (abs_uobjcoll_path ^ "/" ^ Uberspark_namespace.namespace_root_mf_filename) in
	let rval = (parse_manifest uobjcoll_mf_filename) in	
    if (rval == false) then	begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "unable to stat/parse manifest for uobjcoll: %s" uobjcoll_mf_filename;
		(!retval, !r_prevpath_result)
	end else

	(* sanity check platform, cpu, arch override *)
	(* TBD: if manifest says generic, we need a command line override *)
	(* TBD: at the very least we need an arch override if uobjcoll says generic arch *)
	let dummy = 0 in begin
	json_node_uberspark_uobjcoll_var.arch <- d_target_def.arch;
	json_node_uberspark_uobjcoll_var.cpu <- d_target_def.cpu;
	json_node_uberspark_uobjcoll_var.platform <- d_target_def.platform;
	end;

	(*create uobjcoll_public_methods and intrauobjcoll sentinels hashtbl *)
	let rval = (create_uobjcoll_publicmethods_intrauobjcoll_sentinels_hashtbl ()) in 

	if(rval == false) then begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not create uobj collection sentinels hashtbl!";
		(false, !r_prevpath_result)
	end else
	
	let dummy = 0 in begin
	Uberspark_logger.log "created uobj collection uobjcoll_public_methods and intrauobjcoll sentinels hashtbl";
	end;


	(* initialize uobj collection bridges *)
	let rval = (Uberspark_bridge.initialize_from_config ()) in	
    if (rval == false) then	begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "unable to initialize uobj collection bridges!";
		(!retval, !r_prevpath_result)
	end else


    (* collect uobj collection uobj info *)
	let rval = (initialize_uobjs_baseinfo abs_uobjcoll_path Uberspark_namespace.namespace_uobjcoll_build_dir) in	
    if (rval == false) then	begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "unable to collect uobj information for uobj collection!";
		(!retval, !r_prevpath_result)
	end else

	let dummy = 0 in begin
	Uberspark_logger.log "successfully collected uobj information";
	end;

	(* setup uobj collection canonical namespace for build *)
	let rval = (prepare_namespace_for_build abs_uobjcoll_path) in	
    if (rval == false) then	begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "unable to prepare uobjcoll canonical build namespace!";
		(!retval, !r_prevpath_result)
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
	let rval = (initialize_uobjs_within_uobjinfo_list ()) in	
    if (rval == false) then	begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "unable to initialize uobjs!";
		(!retval, !r_prevpath_result)
	end else



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
		(false, !r_prevpath_result)
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

	(* generate and install uobjcoll headers *)
	Uberspark_logger.log ~crlf:false "Generating uobjcoll top-level include header source...";
	Uberspark_codegen.Uobjcoll.generate_top_level_include_header 
			(!d_builddir ^ "/" ^ Uberspark_namespace.namespace_uobjcoll_top_level_include_header_src_filename)
			json_node_uberspark_uobjcoll_var.configdefs_verbatim
			json_node_uberspark_uobjcoll_var.configdefs;
	Uberspark_logger.log ~tag:"" "[OK]";
	install_h_files_ns ~context_path_builddir:Uberspark_namespace.namespace_uobjcoll_build_dir;


	(* create sentinel address hashtbls for uobjcoll, intrauobjcoll, interuobjcoll and legacy public_methods *)
	(* TBD: interuobjcoll and legacy *)
	let dummy = 0 in begin
	setup_uobjcoll_initmethod_sentinel_address_hashtbl ();
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
		(false, !r_prevpath_result)
	end else

	let dummy = 0 in begin
	Uberspark_logger.log "generated source for  uobj collection sentinel definitions";
	end;

	(* setup intrauobjcoll callees sentinel type hashtbl *)
	let dummy = 0 in begin
	setup_intrauobjcoll_callees_sentinel_type_hashtbl ();
	Uberspark_logger.log "setup intrauobjcoll callees sentinel type hashtbl";
	end;

	let dummy = 0 in begin
	(* add sentinel definitions source file to list of asm sources *)
	(* TBD: eventually this will just be casm sources *)
	d_sources_asm_file_list := [ 
		Uberspark_namespace.namespace_uobjcoll_sentinel_definitions_src_filename
	] @ !d_sources_asm_file_list;
	end;

	(* store return path which the caller can use to change back to *)
	r_prevpath_result := r_prevpath;

	(true, !r_prevpath_result)
;;



let verify
	(uobjcoll_path_ns : string)
	(target_def : Defs.Basedefs.target_def_t)
	(uobjcoll_load_address : int)
	: bool =

	(* local variables *)
	let retval = ref false in
	
	let dummy = 0 in begin
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "uobj collection verification start...";
	end;

	(* initialize common operation context *)
	let (rval, r_prevpath) = (initialize_common_operation_context
						uobjcoll_path_ns target_def uobjcoll_load_address) in
	if(rval == false) then begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not initialize common operation context";
		(!retval)
	end else

	(* verify all uobjs *)
	let dummy = 0 in begin
	retval := true;
	List.iter ( fun (uobjinfo_entry : uobjcoll_uobjinfo_t) -> 
		Uberspark_logger.log "Verifying uobj '%s'..." uobjinfo_entry.f_uobjinfo.f_uobj_name;

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

					if !retval &&  not (uobj#verify ()) then begin
						retval := false;
					end;

					if !retval then begin					
						Uberspark_logger.log "Successfully verified uobj '%s'" uobjinfo_entry.f_uobjinfo.f_uobj_name;
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
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not verify uobj(s)!";
		(!retval)
	end else


	let dummy = 0 in begin
	Uberspark_logger.log "verified uobjcoll successfully";
	end;


	(* restore working directory *)
	let dummy = 0 in begin
	ignore(Uberspark_osservices.dir_change r_prevpath);
	Uberspark_logger.log "cleaned up operation workspace";
	retval := true;
	end;

	(!retval)
;;





let build
	(uobjcoll_path_ns : string)
	(target_def : Defs.Basedefs.target_def_t)
	(uobjcoll_load_address : int)
	: bool =

	(* local variables *)
	let retval = ref false in
	
	let dummy = 0 in begin
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "uobj collection build start...";
	end;

	(* initialize common operation context *)
	let (rval, r_prevpath) = (initialize_common_operation_context
						uobjcoll_path_ns target_def uobjcoll_load_address) in
	if(rval == false) then begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not initialize common operation context";
		(!retval)
	end else

	(* build uobjcoll loaders *)
	let dummy = 0 in begin
		retval := true;
		List.iter ( fun (loader_ns: string) ->
			if (!retval == true) then begin
				Uberspark_logger.log ~lvl:Uberspark_logger.Debug "building loader: '%s'..." loader_ns;
				let (rval, uobjcoll_loader) = Uberspark_loader.create_initialize_and_build loader_ns in
				if(rval == false) then begin
					Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not build loader";
					retval := false;
				end else begin
					let loader_binary_src_dir = (Uberspark_namespace.get_namespace_staging_dir_prefix ()) ^ "/" ^
												loader_ns ^ "/" ^ 
												Uberspark_namespace.namespace_loader_build_dir in
					let loader_binary_dst_dir =  !d_path_to_mf_filename ^ "/" ^
										Uberspark_namespace.namespace_uobjcoll_build_dir ^ "/" ^ 
										loader_ns ^ "/" ^ Uberspark_namespace.namespace_loader_build_dir in
					Uberspark_logger.log ~lvl:Uberspark_logger.Debug "loader_binary_src_dir=%s" loader_binary_src_dir;
					Uberspark_logger.log ~lvl:Uberspark_logger.Debug "loader_binary_dst_dir=%s" loader_binary_dst_dir;
					Uberspark_osservices.mkdir ~parent:true (loader_ns ^ "/" ^ 
												Uberspark_namespace.namespace_loader_build_dir) (`Octal 0o0777);

					Uberspark_osservices.cp (loader_binary_src_dir ^ "/" ^ Uberspark_namespace.namespace_loader_binary_image_filename)
											(loader_binary_dst_dir ^ "/" ^ Uberspark_namespace.namespace_loader_binary_image_filename);

					Uberspark_osservices.cp (loader_binary_src_dir ^ "/" ^ Uberspark_namespace.namespace_loader_binary_flat_image_filename)
											(loader_binary_dst_dir ^ "/" ^ Uberspark_namespace.namespace_loader_binary_flat_image_filename);

				end;
			end else begin
				Uberspark_logger.log ~lvl:Uberspark_logger.Debug "skipping loader: '%s'..." loader_ns;
			end;
		)json_node_uberspark_uobjcoll_var.loaders;
	end;
    
	if(!retval == false) then begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not build loader(s)!";
		(!retval)
	end else


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


(*--------------------------------------------------------------------------*)
(* parse all uobjs and create uobj namespace to uobj manifest variable association list *)
(*--------------------------------------------------------------------------*)
let create_uobj_manifest_var_assoc_list
	()
	: bool =
	let rval = ref true in 

	List.iter (fun l_uobj_namespace ->
		if !rval then begin
			Uberspark_logger.log ~lvl:Uberspark_logger.Debug ~crlf:false "scanning uobj: %s..." l_uobj_namespace;

			(* read manifest file into manifest variable *)
			let abspath_mf_filename = (!d_triage_dir_prefix ^ "/" ^ l_uobj_namespace ^ "/" ^ Uberspark_namespace.namespace_root_mf_filename) in 
			let l_uberspark_manifest_var : Uberspark_manifest.uberspark_manifest_var_t = uberspark_manifest_var_default_value () in

			rval := Uberspark_manifest.manifest_file_to_uberspark_manifest_var abspath_mf_filename l_uberspark_manifest_var;

			if !rval then begin
				d_uobj_manifest_var_assoc_list := !d_uobj_manifest_var_assoc_list @ [ (l_uobj_namespace, l_uberspark_manifest_var) ];
				Uberspark_logger.log ~tag:"" "[OK]";
			end;
		end;

	) d_uberspark_manifest_var.uobjcoll.uobjs.templars;


	(true)
;;

(*--------------------------------------------------------------------------*)
(* create uobjrtl to manifest variable hashtbl *)
(*--------------------------------------------------------------------------*)
let create_uobjrtl_manifest_var_hashtbl
	()
	: bool =
	let retval = ref true in 

	(* go over all the uobjs and collect uobjrtls *)
	List.iter ( fun ( (l_uobj_ns:string), (l_uberspark_manifest_var:Uberspark_manifest.uberspark_manifest_var_t) ) -> 

		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "collecting uobjrtl for uobj: %s..." l_uobj_ns;

		(* iterate over uobj uobjrtls *)
		List.iter ( fun ( (uobjrtl_namespace : string), (uobjrtl_entry : Uberspark_manifest.Uobj.json_node_uberspark_uobj_uobjrtl_t) ) -> 
			if !retval == true then begin
				
				(* parse each uobjrtl manifest and create a hashtable with entry as namespace *)
				(* entry will be an entry of type uobjrtl_t *)

				Uberspark_logger.log ~lvl:Uberspark_logger.Debug "uobjrtl namespace=%s" uobjrtl_entry.namespace;

				let abspath_mf_filename = ((Uberspark_namespace.get_namespace_staging_dir_prefix ()) ^ "/" ^ uobjrtl_entry.namespace ^ "/" ^ Uberspark_namespace.namespace_root_mf_filename) in

				Uberspark_logger.log ~lvl:Uberspark_logger.Debug "uobjrtl manifest path=%s" abspath_mf_filename;

				let l_uobjrtl_manifest_var : Uberspark_manifest.uberspark_manifest_var_t = uberspark_manifest_var_default_value () in

				retval := Uberspark_manifest.manifest_file_to_uberspark_manifest_var abspath_mf_filename l_uobjrtl_manifest_var;

				if !retval then begin
					Hashtbl.add d_uobjrtl_manifest_var_hashtbl uobjrtl_namespace l_uobjrtl_manifest_var;						
					Uberspark_logger.log ~lvl:Uberspark_logger.Debug "collected uobjrtl successfully!";
				end;

			end;

		) l_uberspark_manifest_var.uobj.uobjrtl;

	) !d_uobj_manifest_var_assoc_list;

	(!retval)
;;



(*--------------------------------------------------------------------------*)
(* create sentinel namespace to manifest variable hashtbl *)
(*--------------------------------------------------------------------------*)
let create_sentinel_manifest_var_hashtbl
	()
	: bool =
	let retval = ref true in 


	(* iterate over uobjcoll init_method sentinel list *)
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "collecting init_method sentinels...";
	List.iter ( fun (sentinel_entry: Uberspark_manifest.Uobjcoll.json_node_uberspark_uobjcoll_initmethod_sentinels_t) -> 
		
		if !retval then begin
			let l_sentinel_namespace = "uberspark/sentinels/init-uobjcoll/" ^ 
				d_uberspark_manifest_var.uobjcoll.arch ^ "/" ^ sentinel_entry.sentinel_type in
			let l_abspath_mf_filename = ((Uberspark_namespace.get_namespace_staging_dir_prefix ()) ^ "/" ^ l_sentinel_namespace ^ "/" ^ Uberspark_namespace.namespace_root_mf_filename) in

			Uberspark_logger.log ~lvl:Uberspark_logger.Debug "proceeding to read sentinel manifest from: %s" l_abspath_mf_filename;

			let l_sentinel_manifest_var : Uberspark_manifest.uberspark_manifest_var_t = uberspark_manifest_var_default_value () in

			retval := Uberspark_manifest.manifest_file_to_uberspark_manifest_var l_abspath_mf_filename l_sentinel_manifest_var;

			if !retval then begin
				Hashtbl.add d_sentinel_manifest_var_hashtbl l_sentinel_namespace l_sentinel_manifest_var;						
				Uberspark_logger.log ~lvl:Uberspark_logger.Debug "collected sentinel info successfully!";
			end;
		end;
	) d_uberspark_manifest_var.uobjcoll.init_method.sentinels;

	if !retval then begin
	
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "collecting public_method sentinels...";
		(* iterate over uobjcoll_public_methods sentinel list *)
		List.iter ( fun ( (canonical_public_method:string), (pm_info: Uberspark_manifest.Uobjcoll.json_node_uberspark_uobjcoll_publicmethods_t)) -> 
			List.iter ( fun (sentinel_type: string) -> 

				if !retval then begin
					let l_sentinel_namespace = "uberspark/sentinels/inter-uobjcoll/" ^ 
						d_uberspark_manifest_var.uobjcoll.arch ^ "/" ^ sentinel_type in
					let l_abspath_mf_filename = ((Uberspark_namespace.get_namespace_staging_dir_prefix ()) ^ "/" ^ l_sentinel_namespace ^ "/" ^ Uberspark_namespace.namespace_root_mf_filename) in

					Uberspark_logger.log ~lvl:Uberspark_logger.Debug "proceeding to read sentinel manifest from: %s" l_abspath_mf_filename;

					let l_sentinel_manifest_var : Uberspark_manifest.uberspark_manifest_var_t = uberspark_manifest_var_default_value () in

					retval := Uberspark_manifest.manifest_file_to_uberspark_manifest_var l_abspath_mf_filename l_sentinel_manifest_var;

					if !retval then begin
						Hashtbl.add d_sentinel_manifest_var_hashtbl l_sentinel_namespace l_sentinel_manifest_var;						
						Uberspark_logger.log ~lvl:Uberspark_logger.Debug "collected sentinel info successfully!";
					end;
				end;

		
			) pm_info.sentinel_type_list;
		) d_uberspark_manifest_var.uobjcoll.public_methods;
	end;

	(!retval)
;;



let process_manifest_common
	(p_uobjcoll_ns : string)
	: bool =

	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "process_manifest_common (p_uobjcoll_ns=%s)..." p_uobjcoll_ns;

	(* get current working directory *)
	let l_cwd = Uberspark_osservices.getcurdir() in

	(* get the absolute path of the current working directory *)
	let (rval, l_cwd_abs) = (Uberspark_osservices.abspath l_cwd) in

	(* bail out on error *)
	if (rval == false) then begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not get absolute path of current working directory!";
		(false) 
	end else

	(* announce working directory and store in triage dir prefix*)
	let l_dummy=0 in begin
	d_triage_dir_prefix := l_cwd_abs;
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "current working directory: %s" !d_triage_dir_prefix;
	end;

	(* announce staging directory and store in staging dir prefix*)
	let l_dummy=0 in begin
	d_staging_dir_prefix := Uberspark_namespace.get_namespace_staging_dir_prefix ();
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "staging directory: %s" !d_staging_dir_prefix;
	end;

	(* read manifest file into manifest variable *)
	let abspath_mf_filename = (!d_triage_dir_prefix ^ "/" ^ p_uobjcoll_ns ^ "/" ^ Uberspark_namespace.namespace_root_mf_filename) in 
	let rval = Uberspark_manifest.manifest_file_to_uberspark_manifest_var abspath_mf_filename d_uberspark_manifest_var in

	(* bail out on error *)
  	if (rval == false) then
    	(false)
  	else

	let l_dummy=0 in begin
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "read manifest file into JSON object";
	end;

	(* sanity check we are an uobjcoll manifest and bail out on error*)
	if (d_uberspark_manifest_var.manifest.namespace <> Uberspark_namespace.namespace_uobjcoll_mf_node_type_tag) then
		(false)
	else

	(* create uobjcoll manifest variables assoc list *)
	(* TBD: revisions needed for multi-platform uobjcoll *) 
	let l_dummy=0 in begin
	d_uobjcoll_manifest_var_assoc_list := [ (p_uobjcoll_ns, d_uberspark_manifest_var) ];
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "created uobjcoll manifest variable assoc list...";
	end;

	(* iterate through all uobjcolls *)
	let retval = ref true in 
	List.iter ( fun ( (l_uobjcoll_ns:string), (l_uberspark_manifest_var:Uberspark_manifest.uberspark_manifest_var_t) ) -> 
		
		if (!retval) then begin
			Uberspark_logger.log ~lvl:Uberspark_logger.Info "processing uobjcoll: %s..." l_uobjcoll_ns;

			(* parse all uobjs and create uobj namespace to uobj manifest variable association list *)
			let l_dummy=0 in begin
			retval := create_uobj_manifest_var_assoc_list ();
			end;

			if (!retval) == false then
				()
			else
			
			(* create uobjrtl to manifest variable hashtbl *)
			let l_dummy=0 in begin
			retval := create_uobjrtl_manifest_var_hashtbl ();
			end;

			if (!retval) == false then
				()
			else

			(* create sentinel namespace to manifest variable hashtbl *)
			let l_dummy=0 in begin
			retval := create_sentinel_manifest_var_hashtbl ();
			end;

			if (!retval) == false then
				()
			else

			let l_dummy=0 in begin
			Uberspark_logger.log ~lvl:Uberspark_logger.Debug "uobjcoll processed successfully!";
			end;
		end;

		()
	)!d_uobjcoll_manifest_var_assoc_list;

	(!retval)
;;







let process_manifest
	(abspath_cwd : string)
	(abspath_mf_filename : string)
	: bool =

	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "processing uobjcoll manifest...";

	(* read manifest file into manifest variable *)
	let rval = Uberspark_manifest.manifest_file_to_uberspark_manifest_var abspath_mf_filename d_uberspark_manifest_var in

	(* bail out on error *)
  	if (rval == false) then
    	(false)
  	else

	let l_dummy=0 in begin
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "read manifest file into JSON object";
	end;

	(* sanity check we are an uobjcoll manifest and bail out on error*)
	if (d_uberspark_manifest_var.manifest.namespace <> Uberspark_namespace.namespace_uobjcoll_mf_node_type_tag) then
		(false)
	else

	(* create triage folder *)
	let dummy = 0 in begin
	Uberspark_osservices.mkdir ~parent:true Uberspark_namespace.namespace_uobjcoll_triage_dir (`Octal 0o0777);
	end;

	(* create uobjcoll namespace folder within triage *)
	(* TBD: sanity check uobjcoll namespace prefix *)
	let l_abspath_uobjcoll_triage_dir = (abspath_cwd ^ "/" ^ Uberspark_namespace.namespace_uobjcoll_triage_dir) in 
	let l_abspath_uobjcoll_triage_dir_uobjcoll_ns = (l_abspath_uobjcoll_triage_dir ^ "/" ^ d_uberspark_manifest_var.uobjcoll.namespace) in
	begin
	Uberspark_osservices.mkdir ~parent:true l_abspath_uobjcoll_triage_dir_uobjcoll_ns (`Octal 0o0777);
	end;

	(* sanity check we have canonical uobjcoll sources folder organization *)
	if ( not (Uberspark_osservices.is_dir (abspath_cwd ^ "/install")) ||
		 not (Uberspark_osservices.is_dir (abspath_cwd ^ "/uobjs")) ||
		not (Uberspark_osservices.is_dir (abspath_cwd ^ "/include")) ||
		not (Uberspark_osservices.is_dir (abspath_cwd ^ "/docs")) ) then
		(false)
	else

	(* copy over uobjcoll sources folder structure  into uobjcoll triage dir with uobjcoll namespace prefix *)
	let dummy = 0 in begin
		Uberspark_osservices.cp ~recurse:true (abspath_cwd ^ "/install") (l_abspath_uobjcoll_triage_dir_uobjcoll_ns ^ "/.");
		Uberspark_osservices.cp ~recurse:true (abspath_cwd ^ "/uobjs") (l_abspath_uobjcoll_triage_dir_uobjcoll_ns ^ "/.");
		Uberspark_osservices.cp ~recurse:true (abspath_cwd ^ "/include") (l_abspath_uobjcoll_triage_dir_uobjcoll_ns ^ "/.");
		Uberspark_osservices.cp ~recurse:true (abspath_cwd ^ "/docs") (l_abspath_uobjcoll_triage_dir_uobjcoll_ns ^ "/.");
		Uberspark_osservices.cp ~recurse:false abspath_mf_filename (l_abspath_uobjcoll_triage_dir_uobjcoll_ns ^ "/.");
	end;

	(* change working directory to triage *)
	let (rval, _, _) = (Uberspark_osservices.dir_change l_abspath_uobjcoll_triage_dir) in
	if(rval == false) then begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not switch to uobjcoll triage folder";
		(false)
	end else

	(* copy over uobjcoll sources folder structure  into uobjcoll triage dir with uobjcoll namespace prefix *)
	let dummy = 0 in begin
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "switched operating context to: %s" l_abspath_uobjcoll_triage_dir;
	end;

	(* invoke common manifest processing logic *)
	(process_manifest_common (d_uberspark_manifest_var.uobjcoll.namespace))
;;


