(*------------------------------------------------------------------------------
	uberSpark uberobject collection verification and build interface implementation
	author: amit vasudevan (amitvasudevan@acm.org)
------------------------------------------------------------------------------*)

open Str

type uobjcoll_uobjinfo_t =
{
	mutable f_uobj 					: Uberspark_uobj.uobject option;
	mutable f_uobjinfo    			: Defs.Basedefs.uobjinfo_t;			
};;


type uobjcoll_uobjs_publicmethod_info_t =
{
	mutable f_uobjpminfo			: Uberspark_manifest.Uobj.uobj_publicmethods_t;
	mutable f_uobjinfo    			: Defs.Basedefs.uobjinfo_t;			
};;

type uobjcoll_sentinel_info_t =
{
	mutable f_sentinel_code			: string;
	mutable f_sentinel_libcode  	: string;	
	mutable f_sizeof_code : int;		
};;

let d_mf_filename = ref "";;
let d_path_to_mf_filename = ref "";;
let d_path_ns = ref "";;
let d_hdr: Uberspark_manifest.Uobjcoll.uobjcoll_hdr_t = {f_namespace = ""; f_platform = ""; f_arch = ""; f_cpu = ""; f_hpl = "";};;

let d_uobjcoll_uobjs_mf_node : Uberspark_manifest.Uobjcoll.uobjcoll_uobjs_t = {f_prime_uobj_ns = ""; f_templar_uobjs = []};;
let d_uobjcoll_sentinels_mf_node : Uberspark_manifest.Uobjcoll.uobjcoll_sentinels_t = {f_interuobjcoll = []; f_intrauobjcoll = []};;


let d_uobjcoll_uobjinfo_list : uobjcoll_uobjinfo_t list ref = ref [];;
let d_uobjcoll_uobjinfo_hashtbl = ((Hashtbl.create 32) : ((string, uobjcoll_uobjinfo_t)  Hashtbl.t));; 

(* association list of interuobjcoll (entry) sentinels; indexed by sentinel type *)		
let d_interuobjcoll_sentinels_list : (string * uobjcoll_sentinel_info_t) list ref = ref [];; 

(* association list of intrauobjcoll sentinels; indexed by sentinel type *)		
let d_intrauobjcoll_sentinels_list : (string * uobjcoll_sentinel_info_t) list ref = ref [];; 


let d_load_address : int ref = ref 0;;
let d_size : int ref = ref 0;;

let d_target_def: Defs.Basedefs.target_def_t = {
	f_platform = ""; 
	f_arch = ""; 
	f_cpu = "";
};;

let d_sources_asm_file_list: string list ref = ref [];;

let d_uobjs_publicmethods_hashtbl = ((Hashtbl.create 32) : ((string, uobjcoll_uobjs_publicmethod_info_t)  Hashtbl.t));; 

let d_uobjs_publicmethods_hashtbl_with_address = ((Hashtbl.create 32) : ((string, uobjcoll_uobjs_publicmethod_info_t)  Hashtbl.t));; 


(* association list of uobj binary image sections with memory map info; indexed by section name *)		
let d_memorymapped_sections_list : (string * Defs.Basedefs.section_info_t) list ref = ref [];;





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

	(* parse uobjcoll-sentinels node *)
	let rval = (Uberspark_manifest.Uobjcoll.parse_uobjcoll_sentinels mf_json d_uobjcoll_sentinels_mf_node ) in
	if (rval == false) then (false)
	else


	let dummy=0 in begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "uobj collection sentinels=(%u, %u)" 
			(List.length d_uobjcoll_sentinels_mf_node.f_interuobjcoll)
			(List.length d_uobjcoll_sentinels_mf_node.f_intrauobjcoll);
	end;


	(true)
;;


(*--------------------------------------------------------------------------*)
(* create uobj collection sentinels list *)
(*--------------------------------------------------------------------------*)
let create_sentinels_list	
	(sentinel_facet : string)
	(sentinel_type_list_input : string list)
	(sentinels_list_output : (string * uobjcoll_sentinel_info_t) list ref)
	: bool = 

	let retval = ref true in
	let sentinel_hdr: Uberspark_manifest.Sentinel.sentinel_hdr_t = {f_namespace = ""; f_platform = ""; f_arch = ""; f_cpu = ""; f_sizeof_code = 0;} in

	(* create sentinel list *)
	List.iter ( fun (sentinel_type: string) ->
		if !retval then begin
			let sentinel_mf_filename = (!Uberspark_namespace.namespace_root_dir ^ "/" ^ 
				Uberspark_namespace.namespace_root ^ "/" ^ Uberspark_namespace.namespace_sentinel ^ "/cpu/" ^
				d_hdr.f_arch ^ "/" ^ d_hdr.f_cpu ^ "/" ^ d_hdr.f_hpl ^ "/" ^ sentinel_facet ^ "/" ^ 
				sentinel_type ^ "/" ^ Uberspark_namespace.namespace_sentinel_mf_filename) in 
				Uberspark_logger.log ~lvl:Uberspark_logger.Debug "sentinel_mf_filename=%s" sentinel_mf_filename;
			let sentinel_info : uobjcoll_sentinel_info_t = { f_sentinel_code = ""; f_sentinel_libcode= ""; f_sizeof_code=0;} in
			
			(* read sentinel manifest JSON *)
			let (rval, mf_json) = (Uberspark_manifest.get_manifest_json sentinel_mf_filename) in
			
			if (rval == false) then begin
			retval := false;
			end;

			(* read sentinel manifest header *)
			if !retval then begin 			
				let rval =	(Uberspark_manifest.Sentinel.parse_sentinel_hdr mf_json sentinel_hdr) in

				if (rval == false) then begin
				retval := false;
				end;
			end;

			(* read sentinel code and libcode nodes *)
			if !retval then begin 			
				let (rval_code, sentinel_code) =	(Uberspark_manifest.Sentinel.parse_sentinel_code mf_json) in
				let (rval_libcode, sentinel_libcode) =	(Uberspark_manifest.Sentinel.parse_sentinel_libcode mf_json) in

				if not (rval_code && rval_libcode) then begin
					retval := false;
				end else begin
					sentinel_info.f_sentinel_code <- sentinel_code;
					sentinel_info.f_sentinel_libcode <- sentinel_libcode;
					sentinel_info.f_sizeof_code <- sentinel_hdr.f_sizeof_code;
					sentinels_list_output := !sentinels_list_output @ [ (sentinel_type, sentinel_info)];
				end;
			end;

		end;
	) sentinel_type_list_input;


	if (!retval == false) then (false)
	else

	let dummy=0 in begin
	retval := true;
	end;
	
	(!retval)
;;


(*--------------------------------------------------------------------------*)
(* parse sentinel manifest *)
(*--------------------------------------------------------------------------*)
let parse_manifest_sentinel	
	(sentinel_type : string)
	: bool * string * string = 
	
	let retval = ref false in 	
	let scode = ref "" in
	let slcode = ref "" in
	let target_def = d_target_def in	
	let sentinel_filename = (!Uberspark_namespace.namespace_root_dir ^ "/" ^ 
		Uberspark_namespace.namespace_root ^ "/" ^ Uberspark_namespace.namespace_sentinel ^ "/cpu/" ^
		target_def.f_arch ^ "/" ^ target_def.f_cpu ^ "/" ^
		Uberspark_namespace.namespace_sentinel_mf_filename) in 

	let (rval, abs_sentinel_filename) = (Uberspark_osservices.abspath sentinel_filename) in
	if(rval == true) then
	begin
		Uberspark_logger.log "reading sentinel manifest from:%s" abs_sentinel_filename;

		(* read manifest JSON *)
		let (rval, mf_json) = (Uberspark_manifest.get_manifest_json abs_sentinel_filename) in
		if(rval == true) then
		begin

			(* parse sentinel-hdr node *)
			let sentinel_hdr: Uberspark_manifest.Sentinel.sentinel_hdr_t = {f_namespace = ""; f_platform = ""; f_arch = ""; f_cpu = ""; f_sizeof_code=0;} in
			let rval =	(Uberspark_manifest.Sentinel.parse_sentinel_hdr mf_json sentinel_hdr) in
			if rval then
			begin

				(* read sentinel code and libcode nodes *)
				let (rval_code, sentinel_code) =	(Uberspark_manifest.Sentinel.parse_sentinel_code mf_json) in
				let (rval_libcode, sentinel_libcode) =	(Uberspark_manifest.Sentinel.parse_sentinel_libcode mf_json) in

				if  rval_code && rval_libcode then
					begin
						scode := sentinel_code;
						slcode := sentinel_libcode;
						retval := true;
					end;
			end;
		end;
	end;

(!retval, !scode, !slcode)
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
				let uobjinfo_entry : uobjcoll_uobjinfo_t = { f_uobj = None; 
					f_uobjinfo = { f_uobj_name = ""; f_uobj_ns = "";  
					f_uobj_srcpath = ""; f_uobj_buildpath = ""; f_uobj_nspath = "" ; f_uobj_is_incollection = false; 
					f_uobj_is_prime  = false; f_uobj_load_address = 0; f_uobj_size = 0;}; } in

				uobjinfo_entry.f_uobj <- Some new Uberspark_uobj.uobject;
				uobjinfo_entry.f_uobjinfo.f_uobj_name <- uobj_name;
				uobjinfo_entry.f_uobjinfo.f_uobj_ns <- d_uobjcoll_uobjs_mf_node.f_prime_uobj_ns;
				uobjinfo_entry.f_uobjinfo.f_uobj_is_prime <- true;
				uobjinfo_entry.f_uobjinfo.f_uobj_buildpath <- (uobjcoll_abs_path ^ "/" ^ uobjcoll_builddir ^ "/" ^ uobj_name);
				uobjinfo_entry.f_uobjinfo.f_uobj_nspath <- (!Uberspark_namespace.namespace_root_dir ^ "/" ^ d_uobjcoll_uobjs_mf_node.f_prime_uobj_ns);

				if (Uberspark_namespace.is_uobj_ns_in_uobjcoll_ns d_uobjcoll_uobjs_mf_node.f_prime_uobj_ns
					d_hdr.f_namespace) then begin
					uobjinfo_entry.f_uobjinfo.f_uobj_is_incollection <- true;
				end else begin
					uobjinfo_entry.f_uobjinfo.f_uobj_is_incollection <- false;
				end;

				if uobjinfo_entry.f_uobjinfo.f_uobj_is_incollection then begin
					uobjinfo_entry.f_uobjinfo.f_uobj_srcpath <- (uobjcoll_abs_path ^ "/" ^ uobj_name);
				end else begin
					uobjinfo_entry.f_uobjinfo.f_uobj_srcpath <- (!Uberspark_namespace.namespace_root_dir ^ "/" ^ d_uobjcoll_uobjs_mf_node.f_prime_uobj_ns);
				end;

				d_uobjcoll_uobjinfo_list := !d_uobjcoll_uobjinfo_list @ [ uobjinfo_entry ];

			    if (Hashtbl.mem d_uobjcoll_uobjinfo_hashtbl d_uobjcoll_uobjs_mf_node.f_prime_uobj_ns) then begin
					(* there is already another uobj with the same ns within the collection, so bail out *)
					Uberspark_logger.log ~lvl:Uberspark_logger.Error "multiple uobjs with same namespace!";
					retval := false;
		    	end else begin
					Hashtbl.add d_uobjcoll_uobjinfo_hashtbl d_uobjcoll_uobjs_mf_node.f_prime_uobj_ns uobjinfo_entry;
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
				uobjinfo_entry.f_uobjinfo.f_uobj_nspath <- (!Uberspark_namespace.namespace_root_dir ^ "/" ^ templar_uobj_ns);

				if (Uberspark_namespace.is_uobj_ns_in_uobjcoll_ns templar_uobj_ns d_hdr.f_namespace) then begin
					uobjinfo_entry.f_uobjinfo.f_uobj_is_incollection <- true;
				end else begin
					uobjinfo_entry.f_uobjinfo.f_uobj_is_incollection <- false;
				end;

				if uobjinfo_entry.f_uobjinfo.f_uobj_is_incollection then begin
					uobjinfo_entry.f_uobjinfo.f_uobj_srcpath <- (uobjcoll_abs_path ^ "/" ^ uobj_name);
				end else begin
					uobjinfo_entry.f_uobjinfo.f_uobj_srcpath <- (!Uberspark_namespace.namespace_root_dir ^ "/" ^ templar_uobj_ns);
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

	) d_uobjcoll_uobjs_mf_node.f_templar_uobjs;
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
					(uobjinfo_entry.f_uobjinfo.f_uobj_buildpath ^ "/" ^ Uberspark_namespace.namespace_uobj_mf_filename) 
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
				let key = (".section_" ^ uobjinfo_entry.f_uobjinfo.f_uobj_name) in
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
	List.iter ( fun ( (sentinel_type:string), (sentinel_info: uobjcoll_sentinel_info_t)) ->
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "sentinel type=%s, size=0x%08x" sentinel_type sentinel_info.f_sizeof_code;
	
		Hashtbl.iter (fun (pm_name:string) (pm_info:uobjcoll_uobjs_publicmethod_info_t)  ->
			Uberspark_logger.log ~lvl:Uberspark_logger.Debug "pm_name=%s" pm_name;
			let key = (".section_interuobjcoll_sentinel_" ^ pm_name) in 
			let section_size = 	sentinel_info.f_sizeof_code + (Uberspark_config.config_settings.uobjcoll_binary_image_section_alignment - 
				(sentinel_info.f_sizeof_code mod Uberspark_config.config_settings.uobjcoll_binary_image_section_alignment)) in

			d_memorymapped_sections_list := !d_memorymapped_sections_list @ [ (key, 
				{ f_name = key;	
					f_subsection_list = [];	
					usbinformat = { f_type=Defs.Binformat.const_USBINFORMAT_SECTION_TYPE_INTERUOBJCOLL_SENTINEL; 
									f_prot=0; 
									f_size = section_size;
									f_aligned_at = Uberspark_config.config_settings.uobjcoll_binary_image_section_alignment; 
									f_pad_to = Uberspark_config.config_settings.uobjcoll_binary_image_section_alignment; 
									f_addr_start = !uobjcoll_section_load_addr; 
									f_addr_file = 0;
									f_reserved = 0;
								};
				}) ];

			Uberspark_logger.log ~lvl:Uberspark_logger.Debug "added section for interuobjcoll sentinel '%s' at 0x%08x, size=%08x..." 
				key !uobjcoll_section_load_addr section_size;

			uobjcoll_section_load_addr := !uobjcoll_section_load_addr + section_size; 

		) d_uobjs_publicmethods_hashtbl;

	) !d_interuobjcoll_sentinels_list;


	(* add intra-uobjcoll sentinel sections *)
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "proceeding to add intra-uobjcoll sentinel sections...";
	List.iter ( fun ( (sentinel_type:string), (sentinel_info: uobjcoll_sentinel_info_t)) ->
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "sentinel type=%s, size=0x%08x" sentinel_type sentinel_info.f_sizeof_code;
	
		Hashtbl.iter (fun (pm_name:string) (pm_info:uobjcoll_uobjs_publicmethod_info_t)  ->
			Uberspark_logger.log ~lvl:Uberspark_logger.Debug "pm_name=%s" pm_name;
			let key = (".section_intrauobjcoll_sentinel_" ^ pm_name) in 
			let section_size = 	sentinel_info.f_sizeof_code + (Uberspark_config.config_settings.uobjcoll_binary_image_section_alignment - 
				(sentinel_info.f_sizeof_code mod Uberspark_config.config_settings.uobjcoll_binary_image_section_alignment)) in

			d_memorymapped_sections_list := !d_memorymapped_sections_list @ [ (key, 
				{ f_name = key;	
					f_subsection_list = [];	
					usbinformat = { f_type=Defs.Binformat.const_USBINFORMAT_SECTION_TYPE_INTERUOBJCOLL_SENTINEL; 
									f_prot=0; 
									f_size = section_size;
									f_aligned_at = Uberspark_config.config_settings.uobjcoll_binary_image_section_alignment; 
									f_pad_to = Uberspark_config.config_settings.uobjcoll_binary_image_section_alignment; 
									f_addr_start = !uobjcoll_section_load_addr; 
									f_addr_file = 0;
									f_reserved = 0;
								};
				}) ];

			Uberspark_logger.log ~lvl:Uberspark_logger.Debug "added section for intrauobjcoll sentinel '%s' at 0x%08x, size=%08x..." 
				key !uobjcoll_section_load_addr section_size;

			uobjcoll_section_load_addr := !uobjcoll_section_load_addr + section_size; 

		) d_uobjs_publicmethods_hashtbl;

	) !d_intrauobjcoll_sentinels_list;


	(* iterate over all the uobjs and add a section for each *)
	List.iter ( fun (uobjinfo_entry : uobjcoll_uobjinfo_t) -> 
		match uobjinfo_entry.f_uobj with 
			| None ->
				uobjinfo_status := false;
				Uberspark_logger.log ~lvl:Uberspark_logger.Error "invalid uobj!";

			| Some uobj ->
				Uberspark_logger.log "adding section for uobj '%s' at 0x%08x, size=%08x..." uobjinfo_entry.f_uobjinfo.f_uobj_name 
					!uobjcoll_section_load_addr uobj#get_d_size;

				let key = (".section_" ^ uobjinfo_entry.f_uobjinfo.f_uobj_name)	in 
				d_memorymapped_sections_list := !d_memorymapped_sections_list @ [ (key, 
					{ f_name = key;	
						f_subsection_list = [];	
						usbinformat = { f_type=Defs.Binformat.const_USBINFORMAT_SECTION_TYPE_UOBJ; 
										f_prot=0; 
										f_size = uobj#get_d_size;
										f_aligned_at = Uberspark_config.config_settings.binary_uobj_section_alignment; 
										f_pad_to = Uberspark_config.config_settings.binary_uobj_section_alignment; 
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
(* create uobj collection public method info hashtable *)
(* note: these are for uobjs that are part of this collection *)
(*--------------------------------------------------------------------------*)
let create_uobjs_publicmethods_hashtbl
	(publicmethods_hashtbl : ((string, uobjcoll_uobjs_publicmethod_info_t)  Hashtbl.t))
	: unit =

	(* iterate over all uobjs within uobjinfo list *)
	List.iter ( fun (uobjinfo_entry : uobjcoll_uobjinfo_t) -> 
		match uobjinfo_entry.f_uobj with 
			| None ->
				Uberspark_logger.log ~lvl:Uberspark_logger.Error "invalid uobj!";

			| Some uobj ->

				Uberspark_logger.log ~lvl:Uberspark_logger.Debug "adding public method info for uobj '%s', total public methods=%u" 
					uobjinfo_entry.f_uobjinfo.f_uobj_name (Hashtbl.length uobj#get_d_publicmethods_hashtbl);
				
				Hashtbl.iter (fun (pm_name:string) (pm_info:Uberspark_manifest.Uobj.uobj_publicmethods_t)  ->
					let htbl_key = uobjinfo_entry.f_uobjinfo.f_uobj_ns in 
					let htbl_key_pm_name = ((Uberspark_namespace.get_variable_name_prefix_from_ns htbl_key) ^ "__" ^ pm_name) in
					Hashtbl.add publicmethods_hashtbl htbl_key_pm_name { f_uobjpminfo = pm_info;
						f_uobjinfo = uobjinfo_entry.f_uobjinfo;}
				) uobj#get_d_publicmethods_hashtbl;

		;

	)!d_uobjcoll_uobjinfo_list;

	(* dump uobjs publc methods hashtable *)
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "uobjcoll uobjs publicmethods hashtbl dump follows:"; 
	Hashtbl.iter (fun (canonical_pm_name:string) (entry:uobjcoll_uobjs_publicmethod_info_t)  ->
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "canonical pm_name=%s; pm_name=%s, pm_addr=0x%08x" 
			canonical_pm_name entry.f_uobjpminfo.f_name entry.f_uobjpminfo.f_addr; 
	) publicmethods_hashtbl;



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
			(!d_sources_asm_file_list) [ "."; !Uberspark_namespace.namespace_root_dir ] ".";

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
	d_hdr.f_arch <- d_target_def.f_arch;
	d_hdr.f_cpu <- d_target_def.f_cpu;
	d_hdr.f_platform <- d_target_def.f_platform;
	end;

    (* create intra uobjcoll sentinels list *)
	let rval = (create_sentinels_list "intrauobjcoll" d_uobjcoll_sentinels_mf_node.f_intrauobjcoll d_intrauobjcoll_sentinels_list) in	
    if (rval == false) then	begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "unable to create sentinels list for intra-uobjcoll sentinels!";
		(!retval)
	end else

	let dummy = 0 in begin
	Uberspark_logger.log "created intra-uobjcoll sentinel list, total sentinels=%u" (List.length !d_intrauobjcoll_sentinels_list);
	end;

    (* create inter uobjcoll sentinels list *)
	let rval = (create_sentinels_list "interuobjcoll" d_uobjcoll_sentinels_mf_node.f_interuobjcoll d_interuobjcoll_sentinels_list) in	
    if (rval == false) then	begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "unable to create sentinels list for inter-uobjcoll sentinels!";
		(!retval)
	end else

	let dummy = 0 in begin
	Uberspark_logger.log "created inter-uobjcoll sentinel list, total sentinels=%u" (List.length !d_interuobjcoll_sentinels_list);
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

	(* create uobj collection uobjs public methods hashtable *)
	let dummy = 0 in begin
	create_uobjs_publicmethods_hashtbl d_uobjs_publicmethods_hashtbl;
	Uberspark_logger.log "created uobj collection uobjs public methods hashtable";
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

	(* create uobj collection uobjs public methods hashtable with address *)
	let dummy = 0 in begin
	create_uobjs_publicmethods_hashtbl d_uobjs_publicmethods_hashtbl_with_address;
	Uberspark_logger.log "created uobj collection uobjs public methods hashtable with address";
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
					uobj#prepare_sources ();

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
	let uobjinfo_list : Defs.Basedefs.uobjinfo_t list ref = ref [] in
	List.iter ( fun (uobjinfo_entry : uobjcoll_uobjinfo_t) -> 
		uobjinfo_list := !uobjinfo_list @ [ uobjinfo_entry.f_uobjinfo ];
	)!d_uobjcoll_uobjinfo_list;
	retval := Uberspark_codegen.Uobjcoll.generate_linker_script	
		(Uberspark_namespace.namespace_uobjcoll_linkerscript_filename)
		 !uobjinfo_list !d_load_address !d_size;
	end;

	if(!retval == false) then begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not generate uobjcoll linker script!";
		(!retval)
	end else


	let dummy = 0 in begin
	(* add all the autogenerated asm source files to the list of asm sources *)
	(* TBD: eventually this will just be casm sources *)
	d_sources_asm_file_list := [ 
		Uberspark_namespace.namespace_uobjcoll_uobj_binary_image_section_mapping_src_filename		
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
