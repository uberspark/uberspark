(*===========================================================================*)
(*===========================================================================*)
(*
	uberSpark context module implementation	             	 
	
  author: amit vasudevan (amitvasudevan@acm.org)							 
*)
(*===========================================================================*)
(*===========================================================================*)

open Str

(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* type definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)


(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* class definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)


  (*---------------------------------------------------------------------------*)
  (* class public variable definitions *)
  (*---------------------------------------------------------------------------*)
  


  (*---------------------------------------------------------------------------*)
  (* class public method definitions *)
  (*---------------------------------------------------------------------------*)




(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* variable definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)

(* manifest variable *)
let d_uberspark_manifest_var : Uberspark.Manifest.uberspark_manifest_var_t = Uberspark.Manifest.uberspark_manifest_var_default_value ();;

(* uobjcoll triage directory prefix *)
let d_triage_dir_prefix = ref "";;

(* staging directory prefix *)
let d_staging_dir_prefix = ref "";;

(* assoc list of uobjcoll manifest variables; maps uobjcoll namespace to uobjcoll manifest variable *)
(* TBD: revisions needed for multi-platform uobjcoll *) 
let d_uobjcoll_manifest_var_assoc_list : (string * Uberspark.Manifest.uberspark_manifest_var_t) list ref = ref [];; 

(* assoc list of uobj manifest variables; maps uobj namespace to uobj manifest variable *)
let d_uobj_manifest_var_assoc_list : (string * Uberspark.Manifest.uberspark_manifest_var_t) list ref = ref [];; 

(* hash table of uobjrtl manifest variables: maps uobjrtl namespace to uobjrtl manifest variable *)
let d_uobjrtl_manifest_var_hashtbl = ((Hashtbl.create 32) : ((string, Uberspark.Manifest.uberspark_manifest_var_t)  Hashtbl.t));;

(* hash table of loader manifest variables: maps loader namespace to loader manifest variable *)
let d_loader_manifest_var_hashtbl = ((Hashtbl.create 32) : ((string, Uberspark.Manifest.uberspark_manifest_var_t)  Hashtbl.t));;

(* hash table of sentinel manifest variables: maps sentinel namespace to sentinel manifest variable *)
let d_sentinel_manifest_var_hashtbl = ((Hashtbl.create 32) : ((string, Uberspark.Manifest.uberspark_manifest_var_t)  Hashtbl.t));;

(* uobjcoll load address *)
let d_load_address : int ref = ref Uberspark.Platform.manifest_var.platform.binary.uobjcoll_image_load_address;;

(* uobjcoll size *)
let d_size : int ref = ref Uberspark.Platform.manifest_var.platform.binary.uobjcoll_image_size;;

(* association list of uobj binary image sections with memory map info; indexed by section name *)		
let d_memorymapped_sections_list : (string * Uberspark.Defs.Basedefs.section_info_t) list ref = ref [];;

(* list of sentinel_info_t elements for sentinel code generation *)		
let d_sentinel_info_for_codegen_list : Uberspark.Codegen.Uobjcoll.sentinel_info_t list ref = ref [];;




(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* interface definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)

(*--------------------------------------------------------------------------*)
(* parse all uobjs and create uobj namespace to uobj manifest variable association list *)
(*--------------------------------------------------------------------------*)
let create_uobj_manifest_var_assoc_list
	()
	: bool =
	let rval = ref true in 

	List.iter (fun l_uobj_namespace ->
		if !rval then begin
			Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug ~crlf:false "scanning uobj: %s..." l_uobj_namespace;

			(* read manifest file into manifest variable *)
			let abspath_mf_filename = (!d_triage_dir_prefix ^ "/" ^ l_uobj_namespace ^ "/" ^ Uberspark.Namespace.namespace_root_mf_filename) in 
			let l_uberspark_manifest_var : Uberspark.Manifest.uberspark_manifest_var_t = Uberspark.Manifest.uberspark_manifest_var_default_value () in

			rval := Uberspark.Manifest.manifest_file_to_uberspark_manifest_var abspath_mf_filename l_uberspark_manifest_var;

			if !rval then begin
				d_uobj_manifest_var_assoc_list := !d_uobj_manifest_var_assoc_list @ [ (l_uobj_namespace, l_uberspark_manifest_var) ];
				Uberspark.Logger.log ~tag:"" "[OK]";
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
	List.iter ( fun ( (l_uobj_ns:string), (l_uberspark_manifest_var:Uberspark.Manifest.uberspark_manifest_var_t) ) -> 

		Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "collecting uobjrtl for uobj: %s..." l_uobj_ns;

		(* iterate over uobj uobjrtls *)
		List.iter ( fun ( (uobjrtl_namespace : string), (uobjrtl_entry : Uberspark.Manifest.Uobj.json_node_uberspark_uobj_uobjrtl_t) ) -> 
			if !retval == true then begin
				
				(* parse each uobjrtl manifest and create a hashtable with entry as namespace *)
				(* entry will be an entry of type uobjrtl_t *)

				Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "uobjrtl namespace=%s" uobjrtl_entry.namespace;

				let abspath_mf_filename = ((Uberspark.Namespace.get_namespace_staging_dir_prefix ()) ^ "/" ^ uobjrtl_entry.namespace ^ "/" ^ Uberspark.Namespace.namespace_root_mf_filename) in

				Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "uobjrtl manifest path=%s" abspath_mf_filename;

				let l_uobjrtl_manifest_var : Uberspark.Manifest.uberspark_manifest_var_t = Uberspark.Manifest.uberspark_manifest_var_default_value () in

				retval := Uberspark.Manifest.manifest_file_to_uberspark_manifest_var abspath_mf_filename l_uobjrtl_manifest_var;

				Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "uobjrtl manifest sources=%u" (List.length l_uobjrtl_manifest_var.uobjrtl.sources);
				if !retval then begin
					Hashtbl.add d_uobjrtl_manifest_var_hashtbl uobjrtl_namespace l_uobjrtl_manifest_var;						
					Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "collected uobjrtl successfully!";
				end;

			end;

		) l_uberspark_manifest_var.uobj.uobjrtl;

	) !d_uobj_manifest_var_assoc_list;

	(!retval)
;;


(*--------------------------------------------------------------------------*)
(* create loader to manifest variable hashtbl *)
(*--------------------------------------------------------------------------*)
let create_loader_manifest_var_hashtbl
	()
	: bool =
	let l_retval = ref true in 

	(* go over uobjcoll loaders *)
	List.iter (fun l_loader_namespace ->
		if !l_retval then begin
			Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug ~crlf:false "scanning loader: %s..." l_loader_namespace;

			(* read manifest file into manifest variable *)
			let abspath_mf_filename = ((Uberspark.Namespace.get_namespace_staging_dir_prefix ()) ^ "/" ^ l_loader_namespace ^ "/" ^ Uberspark.Namespace.namespace_root_mf_filename) in
			let l_uberspark_manifest_var : Uberspark.Manifest.uberspark_manifest_var_t = Uberspark.Manifest.uberspark_manifest_var_default_value () in

			Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "loader manifest path=%s" abspath_mf_filename;

			l_retval := Uberspark.Manifest.manifest_file_to_uberspark_manifest_var abspath_mf_filename l_uberspark_manifest_var;

			if !l_retval then begin
				Hashtbl.remove d_loader_manifest_var_hashtbl l_loader_namespace;						
				Hashtbl.add d_loader_manifest_var_hashtbl l_loader_namespace l_uberspark_manifest_var;						
				Uberspark.Logger.log ~tag:"" "[OK]";
			end;
		end;

	) d_uberspark_manifest_var.uobjcoll.loaders;

	(!l_retval)
;;



(*--------------------------------------------------------------------------*)
(* create sentinel namespace to manifest variable hashtbl *)
(*--------------------------------------------------------------------------*)
let create_sentinel_manifest_var_hashtbl
	()
	: bool =
	let retval = ref true in 


	(* iterate over uobjcoll init_method sentinel list *)
	Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "collecting init_method sentinels...";
	List.iter ( fun (sentinel_entry: Uberspark.Manifest.Uobjcoll.json_node_uberspark_uobjcoll_initmethod_sentinels_t) -> 
		
		if !retval then begin
			let l_sentinel_namespace = "uberspark/sentinels/init/" ^ 
				d_uberspark_manifest_var.uobjcoll.arch ^ "/" ^ sentinel_entry.sentinel_type in
			let l_abspath_mf_filename = ((Uberspark.Namespace.get_namespace_staging_dir_prefix ()) ^ "/" ^ l_sentinel_namespace ^ "/" ^ Uberspark.Namespace.namespace_root_mf_filename) in

			Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "proceeding to read sentinel manifest from: %s" l_abspath_mf_filename;

			let l_sentinel_manifest_var : Uberspark.Manifest.uberspark_manifest_var_t = Uberspark.Manifest.uberspark_manifest_var_default_value () in

			retval := Uberspark.Manifest.manifest_file_to_uberspark_manifest_var l_abspath_mf_filename l_sentinel_manifest_var;

			if !retval then begin
				Hashtbl.add d_sentinel_manifest_var_hashtbl l_sentinel_namespace l_sentinel_manifest_var;						
				Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "collected sentinel info successfully!";
			end;
		end;
	) d_uberspark_manifest_var.uobjcoll.init_method.sentinels;

	if !retval then begin
	
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "collecting public_method sentinels...";
		(* iterate over uobjcoll_public_methods sentinel list *)
		List.iter ( fun ( (canonical_public_method:string), (pm_info: Uberspark.Manifest.Uobjcoll.json_node_uberspark_uobjcoll_publicmethods_t)) -> 
			List.iter ( fun (sentinel_type: string) -> 

				if !retval then begin
					let l_sentinel_namespace = "uberspark/sentinels/pmethod/" ^ 
						d_uberspark_manifest_var.uobjcoll.arch ^ "/" ^ sentinel_type in
					let l_abspath_mf_filename = ((Uberspark.Namespace.get_namespace_staging_dir_prefix ()) ^ "/" ^ l_sentinel_namespace ^ "/" ^ Uberspark.Namespace.namespace_root_mf_filename) in

					Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "proceeding to read sentinel manifest from: %s" l_abspath_mf_filename;

					let l_sentinel_manifest_var : Uberspark.Manifest.uberspark_manifest_var_t = Uberspark.Manifest.uberspark_manifest_var_default_value () in

					retval := Uberspark.Manifest.manifest_file_to_uberspark_manifest_var l_abspath_mf_filename l_sentinel_manifest_var;

					if !retval then begin
						Hashtbl.add d_sentinel_manifest_var_hashtbl l_sentinel_namespace l_sentinel_manifest_var;						
						Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "collected sentinel info successfully!";
					end;
				end;

		
			) pm_info.sentinel_type_list;
		) d_uberspark_manifest_var.uobjcoll.public_methods;
	end;

	(!retval)
;;


(*--------------------------------------------------------------------------*)
(* iterate through uobjrtl list and copy uobjrtl sources to triage area *)
(*--------------------------------------------------------------------------*)
let copy_uobjrtl_to_triage
	()
	: bool =
	let retval = ref true in 

	(* iterate through all the uobjrtls *)
	Hashtbl.iter (fun (l_uobjrtl_ns : string) (l_uberspark_manifest_var : Uberspark.Manifest.uberspark_manifest_var_t)  ->
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "copying uobjrtl: %s" l_uobjrtl_ns;

		(* create uobjcoll namespace folder within triage *)
		(* TBD: sanity check uobjrtl namespace *)
		let l_abspath_uobjrtl_triage_dir = (!d_triage_dir_prefix ^ "/" ^ l_uobjrtl_ns) in
		Uberspark.Osservices.mkdir ~parent:true l_abspath_uobjrtl_triage_dir (`Octal 0o0777);

		(* copy over uobjrtl sources folder structure into uobjrtl triage dir *)
		let l_uobjrtl_src_dir = (!d_staging_dir_prefix ^ "/" ^ l_uobjrtl_ns ^ "/.") in
		let l_uobjrtl_dst_dir = (l_abspath_uobjrtl_triage_dir ^ "/.") in
		Uberspark.Osservices.cp ~recurse:true l_uobjrtl_src_dir l_uobjrtl_dst_dir;

	) d_uobjrtl_manifest_var_hashtbl;


	(!retval)
;;


(*--------------------------------------------------------------------------*)
(* iterate through loader list and copy loader sources to triage area *)
(*--------------------------------------------------------------------------*)
let copy_loaders_to_triage
	()
	: bool =
	let l_retval = ref true in 

	(* iterate through all the loaders *)
	Hashtbl.iter (fun (l_loader_ns : string) (l_uberspark_manifest_var : Uberspark.Manifest.uberspark_manifest_var_t)  ->
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "copying loader: %s" l_loader_ns;

		(* create loader namespace folder within triage *)
		(* TBD: sanity check loader namespace *)
		let l_abspath_loader_triage_dir = (!d_triage_dir_prefix ^ "/" ^ l_loader_ns) in
		Uberspark.Osservices.mkdir ~parent:true l_abspath_loader_triage_dir (`Octal 0o0777);

		(* copy over loader sources folder structure into uobjrtl triage dir *)
		let l_loader_src_dir = (!d_staging_dir_prefix ^ "/" ^ l_loader_ns ^ "/.") in
		let l_loader_dst_dir = (l_abspath_loader_triage_dir ^ "/.") in
		Uberspark.Osservices.cp ~recurse:true l_loader_src_dir l_loader_dst_dir;

	) d_loader_manifest_var_hashtbl;

	(!l_retval)
;;


(*--------------------------------------------------------------------------*)
(* sanity check init_method and public_method entries *)
(*--------------------------------------------------------------------------*)
let sanity_check_uobjcoll_method_entries
	()
	: bool =
	let retval = ref false in 

	Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "sanity checking init_method public method reference...";
	(* sanity check init_method to ensure public method is specified within a uobj *)
	if (List.mem_assoc d_uberspark_manifest_var.uobjcoll.init_method.uobj_namespace !d_uobj_manifest_var_assoc_list) then begin
		let l_uberspark_manifest_var : Uberspark.Manifest.uberspark_manifest_var_t = (List.assoc d_uberspark_manifest_var.uobjcoll.init_method.uobj_namespace !d_uobj_manifest_var_assoc_list) in
		if (List.mem_assoc d_uberspark_manifest_var.uobjcoll.init_method.public_method l_uberspark_manifest_var.uobj.public_methods) then begin
			retval := true;
		end;
	end;

	if !retval then begin
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "init_method public method reference check passed";
		retval := false;

		Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "sanity checking public_method names...";
		(* sanity check public_method to ensure public method is specified within a uobj *)
		List.iter ( fun ( (canonical_public_method:string), (pm_info: Uberspark.Manifest.Uobjcoll.json_node_uberspark_uobjcoll_publicmethods_t)) -> 
			if (List.mem_assoc pm_info.uobj_namespace !d_uobj_manifest_var_assoc_list) then begin
				let l_uberspark_manifest_var : Uberspark.Manifest.uberspark_manifest_var_t = (List.assoc pm_info.uobj_namespace !d_uobj_manifest_var_assoc_list) in
				if (List.mem_assoc pm_info.public_method l_uberspark_manifest_var.uobj.public_methods) then begin
					retval := true;
				end;
			end;

		) d_uberspark_manifest_var.uobjcoll.public_methods;

	end;

	(!retval)
;;


(*--------------------------------------------------------------------------*)
(* generate sentinels for uobjcoll methods *)
(*--------------------------------------------------------------------------*)
let generate_sentinels_for_uobjcoll_methods
	()
	: bool =
	let retval = ref true in 

	(* generate sentinels for init_method *)
	Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "generating sentinels for init_method...";
	List.iter ( fun (sentinel_entry: Uberspark.Manifest.Uobjcoll.json_node_uberspark_uobjcoll_initmethod_sentinels_t) -> 
		
		if !retval then begin
			let l_sentinel_namespace = "uberspark/sentinels/init/" ^ 
				d_uberspark_manifest_var.uobjcoll.arch ^ "/" ^ sentinel_entry.sentinel_type in

			if (Hashtbl.mem d_sentinel_manifest_var_hashtbl l_sentinel_namespace) then begin

				let sentinel_namespace_varname = (Uberspark.Namespace.get_variable_name_prefix_from_ns l_sentinel_namespace) in 
				let canonical_public_method = (Uberspark.Namespace.get_variable_name_prefix_from_ns d_uberspark_manifest_var.uobjcoll.init_method.uobj_namespace) ^ "___" ^ d_uberspark_manifest_var.uobjcoll.init_method.public_method in
				let l_sentinel_manifest_var : Uberspark.Manifest.uberspark_manifest_var_t = Hashtbl.find d_sentinel_manifest_var_hashtbl l_sentinel_namespace in
				let codegen_sinfo_entry : Uberspark.Codegen.Uobjcoll.sentinel_info_t = { 
					f_type= l_sentinel_namespace;
					fn_name = canonical_public_method ^ "___" ^ sentinel_namespace_varname; 
					f_secname = (canonical_public_method ^ "___" ^ sentinel_namespace_varname);
					code_template = l_sentinel_manifest_var.sentinel.code_template ; 
					library_code_template= l_sentinel_manifest_var.sentinel.library_code_template ; 
					sizeof_code_template= l_sentinel_manifest_var.sentinel.sizeof_code_template ; 
					fn_address= 0; 
					f_pm_addr = 0; 
					f_method_name = d_uberspark_manifest_var.uobjcoll.init_method.public_method;
				} in 

				d_sentinel_info_for_codegen_list := !d_sentinel_info_for_codegen_list @ [ codegen_sinfo_entry ] ;
				Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "uobjcoll_init_method; added sentinel %s for public-method %s" l_sentinel_namespace canonical_public_method;

			end else begin
				(* could not find sentinel entry *)
				retval := false;
			end;

		end;
	) d_uberspark_manifest_var.uobjcoll.init_method.sentinels;


	if !retval then begin
		(* generate sentinels for uobjcoll public_methods *)
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "generating sentinels for uobjcoll public_methods...";

		List.iter ( fun ( (canonical_public_method:string), (pm_info: Uberspark.Manifest.Uobjcoll.json_node_uberspark_uobjcoll_publicmethods_t)) -> 
			List.iter ( fun (sentinel_type: string) -> 

				if !retval then begin
					let l_sentinel_namespace = "uberspark/sentinels/pmethod/" ^ 
						d_uberspark_manifest_var.uobjcoll.arch ^ "/" ^ sentinel_type in

					if (Hashtbl.mem d_sentinel_manifest_var_hashtbl l_sentinel_namespace) then begin

						let sentinel_namespace_varname = (Uberspark.Namespace.get_variable_name_prefix_from_ns l_sentinel_namespace) in 
						let canonical_public_method = (Uberspark.Namespace.get_variable_name_prefix_from_ns pm_info.uobj_namespace) ^ "___" ^ pm_info.public_method in
						let l_sentinel_manifest_var : Uberspark.Manifest.uberspark_manifest_var_t = Hashtbl.find d_sentinel_manifest_var_hashtbl l_sentinel_namespace in
						let codegen_sinfo_entry : Uberspark.Codegen.Uobjcoll.sentinel_info_t = { 
							f_type= l_sentinel_namespace;
							fn_name = canonical_public_method ^ "___" ^ sentinel_namespace_varname; 
							f_secname = (canonical_public_method ^ "___" ^ sentinel_namespace_varname);
							code_template = l_sentinel_manifest_var.sentinel.code_template ; 
							library_code_template= l_sentinel_manifest_var.sentinel.library_code_template ; 
							sizeof_code_template= l_sentinel_manifest_var.sentinel.sizeof_code_template ; 
							fn_address= 0; 
							f_pm_addr = 0; 
							f_method_name = d_uberspark_manifest_var.uobjcoll.init_method.public_method;
						} in 

						d_sentinel_info_for_codegen_list := !d_sentinel_info_for_codegen_list @ [ codegen_sinfo_entry ] ;
						Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "uobjcoll public method; added sentinel %s for public-method %s" l_sentinel_namespace canonical_public_method;

					end else begin
						(* could not find sentinel entry *)
						retval := false;
					end;

				end;
		
			) pm_info.sentinel_type_list;
		) d_uberspark_manifest_var.uobjcoll.public_methods;

	end;

	if !retval then begin
		(* generate the sentinels filename within the main uobjcoll triage folder *)
		retval := Uberspark.Codegen.Uobjcoll.generate_sentinel_code 
			(!d_triage_dir_prefix ^ "/" ^ d_uberspark_manifest_var.uobjcoll.namespace ^ "/" ^ Uberspark.Namespace.namespace_uobjcoll_sentinel_definitions_src_filename)
			!d_sentinel_info_for_codegen_list;

		if !retval then begin
			d_uberspark_manifest_var.uobjcoll.sources <- d_uberspark_manifest_var.uobjcoll.sources @ [ Uberspark.Namespace.namespace_uobjcoll_sentinel_definitions_src_filename; ];
			Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "generated uobjcoll sentinels source";
		end else begin
			Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "could not generate source for uobj collection sentinel definitions!";
		end;
	end;

	(!retval)
;;



(*--------------------------------------------------------------------------*)
(* generate uobjcoll header file *)
(*--------------------------------------------------------------------------*)
let generate_uobjcoll_header_file
	()
	: bool =
	let retval = ref true in 

	Uberspark.Logger.log ~crlf:false "Generating uobjcoll top-level include header source...";
	Uberspark.Codegen.Uobjcoll.generate_top_level_include_header 
			(!d_triage_dir_prefix ^ "/" ^ d_uberspark_manifest_var.uobjcoll.namespace ^ "/include/" ^ Uberspark.Namespace.namespace_uobjcoll_top_level_include_header_src_filename)
			d_uberspark_manifest_var.uobjcoll.configdefs_verbatim
			d_uberspark_manifest_var.uobjcoll.configdefs;
	Uberspark.Logger.log ~tag:"" "[OK]";

	(!retval)
;;


(*--------------------------------------------------------------------------*)
(* generate header files for uobjs *)
(*--------------------------------------------------------------------------*)
let generate_header_files_for_uobjs
	()
	: bool =
	let retval = ref true in 

	Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "Generating header file for uobjs...";
	(* go over all the uobjs and collect uobjrtls *)
	List.iter ( fun ( (l_uobj_ns:string), (l_uberspark_manifest_var:Uberspark.Manifest.uberspark_manifest_var_t) ) -> 

		Uberspark.Logger.log ~crlf:false "Generating header file for uobj: %s..." l_uobj_ns;
		Uberspark.Codegen.Uobj.generate_header_file 
			(!d_triage_dir_prefix ^ "/" ^ l_uobj_ns ^ "/include/" ^ Uberspark.Namespace.namespace_uobj_top_level_include_header_src_filename)
			l_uberspark_manifest_var.uobj.public_methods;
		Uberspark.Logger.log ~tag:"" "[OK]";

	) !d_uobj_manifest_var_assoc_list;


	(!retval)
;;


(*--------------------------------------------------------------------------*)
(* generate uobjcoll section info *)
(*--------------------------------------------------------------------------*)
let generate_uobjcoll_section_info
	()
	: bool =
	let retval = ref true in 
	let uobjcoll_section_load_addr = ref 0 in

	(* clear out memory mapped sections list and set initial section load address *)
	uobjcoll_section_load_addr := !d_load_address;
	d_memorymapped_sections_list := []; 

	Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "Generating uobjcoll section information...";

	(*
		init_method sentinel sections
		public_method sentinel sections
		forall uobjs include general uobj sections; .text, .data, .bss, .rodata
		stack section
		forall uobjs other uobj sections 
	*)

	List.iter ( fun (sentinel_entry: Uberspark.Manifest.Uobjcoll.json_node_uberspark_uobjcoll_initmethod_sentinels_t) -> 
		
		if !retval then begin
			let l_sentinel_namespace = "uberspark/sentinels/init/" ^ 
				d_uberspark_manifest_var.uobjcoll.arch ^ "/" ^ sentinel_entry.sentinel_type in

			if (Hashtbl.mem d_sentinel_manifest_var_hashtbl l_sentinel_namespace) then begin

				let sentinel_namespace_varname = (Uberspark.Namespace.get_variable_name_prefix_from_ns l_sentinel_namespace) in 
				let canonical_public_method = (Uberspark.Namespace.get_variable_name_prefix_from_ns d_uberspark_manifest_var.uobjcoll.init_method.uobj_namespace) ^ "___" ^ d_uberspark_manifest_var.uobjcoll.init_method.public_method in
				let l_sentinel_manifest_var : Uberspark.Manifest.uberspark_manifest_var_t = Hashtbl.find d_sentinel_manifest_var_hashtbl l_sentinel_namespace in
				
				let section_top_addr = 	ref 0 in
				Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "sentinel_entry.sentinel_size=%u sizeof_code_template=%u" sentinel_entry.sentinel_size l_sentinel_manifest_var.sentinel.sizeof_code_template;
				if sentinel_entry.sentinel_size > 0 then begin
					section_top_addr := sentinel_entry.sentinel_size;
				end else begin
					section_top_addr := l_sentinel_manifest_var.sentinel.sizeof_code_template;
				end;
				section_top_addr := !section_top_addr + !uobjcoll_section_load_addr;
				if (!section_top_addr mod Uberspark.Platform.manifest_var.platform.binary.uobjcoll_image_section_alignment) > 0 then begin
					section_top_addr := !section_top_addr +  (Uberspark.Platform.manifest_var.platform.binary.uobjcoll_image_section_alignment - 
					(!section_top_addr mod Uberspark.Platform.manifest_var.platform.binary.uobjcoll_image_section_alignment));
				end;

				let section_size = !section_top_addr - !uobjcoll_section_load_addr in

				Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "sentinel type=%s, original size=0x%08x, adjusted size=0x%08x" sentinel_entry.sentinel_type l_sentinel_manifest_var.sentinel.sizeof_code_template section_size;

				d_memorymapped_sections_list := !d_memorymapped_sections_list @ [ ((canonical_public_method ^ "___" ^ sentinel_namespace_varname), 
					{ fn_name = (canonical_public_method ^ "___" ^ sentinel_namespace_varname);	
						f_subsection_list = [ (canonical_public_method ^ "___" ^ sentinel_namespace_varname); ];	
						usbinformat = { f_type=Uberspark.Defs.Binformat.const_USBINFORMAT_SECTION_TYPE_UOBJCOLL_INITMETHOD_SENTINEL; 
										f_prot=0; 
										f_size = section_size;
										f_aligned_at = Uberspark.Platform.manifest_var.platform.binary.uobjcoll_image_section_alignment; 
										f_pad_to = Uberspark.Platform.manifest_var.platform.binary.uobjcoll_image_section_alignment; 
										f_addr_start = !uobjcoll_section_load_addr; 
										f_addr_file = 0;
										f_reserved = 0;
									};
					}) ];

				Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "added section for uobjcoll_init_method sentinel '%s' at 0x%08x, size=%08x..." 
					(canonical_public_method ^ "___" ^ sentinel_namespace_varname) !uobjcoll_section_load_addr section_size;

				(* update next section address *)
				uobjcoll_section_load_addr := !uobjcoll_section_load_addr + section_size; 

			end else begin
				(* could not find sentinel entry *)
				retval := false;
			end;

		end;
	) d_uberspark_manifest_var.uobjcoll.init_method.sentinels;


	if !retval then begin

		List.iter ( fun ( (canonical_public_method:string), (pm_info: Uberspark.Manifest.Uobjcoll.json_node_uberspark_uobjcoll_publicmethods_t)) -> 
			List.iter ( fun (sentinel_type: string) -> 

				if !retval then begin
					let l_sentinel_namespace = "uberspark/sentinels/pmethod/" ^ 
						d_uberspark_manifest_var.uobjcoll.arch ^ "/" ^ sentinel_type in

					if (Hashtbl.mem d_sentinel_manifest_var_hashtbl l_sentinel_namespace) then begin

						let sentinel_namespace_varname = (Uberspark.Namespace.get_variable_name_prefix_from_ns l_sentinel_namespace) in 
						let canonical_public_method = (Uberspark.Namespace.get_variable_name_prefix_from_ns pm_info.uobj_namespace) ^ "___" ^ pm_info.public_method in
						let l_sentinel_manifest_var : Uberspark.Manifest.uberspark_manifest_var_t = Hashtbl.find d_sentinel_manifest_var_hashtbl l_sentinel_namespace in

						let section_top_addr = 	ref 0 in
						(*Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "sentinel_entry.sentinel_size=%u sizeof_code_template=%u" sentinel_entry.sentinel_size l_sentinel_manifest_var.sentinel.sizeof_code_template;
						if sentinel_entry.sentinel_size > 0 then begin
							section_top_addr := sentinel_entry.sentinel_size;
						end else begin
							section_top_addr := l_sentinel_manifest_var.sentinel.sizeof_code_template;
						end;*)
						section_top_addr := l_sentinel_manifest_var.sentinel.sizeof_code_template;

						section_top_addr := !section_top_addr + !uobjcoll_section_load_addr;
						if (!section_top_addr mod Uberspark.Platform.manifest_var.platform.binary.uobjcoll_image_section_alignment) > 0 then begin
							section_top_addr := !section_top_addr +  (Uberspark.Platform.manifest_var.platform.binary.uobjcoll_image_section_alignment - 
							(!section_top_addr mod Uberspark.Platform.manifest_var.platform.binary.uobjcoll_image_section_alignment));
						end;

						let section_size = !section_top_addr - !uobjcoll_section_load_addr in

						Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "sentinel type=%s, original size=0x%08x, adjusted size=0x%08x" sentinel_type l_sentinel_manifest_var.sentinel.sizeof_code_template section_size;

						d_memorymapped_sections_list := !d_memorymapped_sections_list @ [ ((canonical_public_method ^ "___" ^ sentinel_namespace_varname), 
							{ fn_name = (canonical_public_method ^ "___" ^ sentinel_namespace_varname);	
								f_subsection_list = [ (canonical_public_method ^ "___" ^ sentinel_namespace_varname); ];	
								usbinformat = { f_type=Uberspark.Defs.Binformat.const_USBINFORMAT_SECTION_TYPE_UOBJCOLL_PUBLICMETHODS_SENTINEL; 
												f_prot=0; 
												f_size = section_size;
												f_aligned_at = Uberspark.Platform.manifest_var.platform.binary.uobjcoll_image_section_alignment; 
												f_pad_to = Uberspark.Platform.manifest_var.platform.binary.uobjcoll_image_section_alignment; 
												f_addr_start = !uobjcoll_section_load_addr; 
												f_addr_file = 0;
												f_reserved = 0;
											};
							}) ];

						Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "added section for uobjcoll public_method sentinel '%s' at 0x%08x, size=%08x..." 
							(canonical_public_method ^ "___" ^ sentinel_namespace_varname) !uobjcoll_section_load_addr section_size;

						(* update next section address *)
						uobjcoll_section_load_addr := !uobjcoll_section_load_addr + section_size; 

					end else begin
						(* could not find sentinel entry *)
						retval := false;
					end;

				end;
		
			) pm_info.sentinel_type_list;
		) d_uberspark_manifest_var.uobjcoll.public_methods;

	end;


	if !retval then begin
		let section_top_addr = 	ref 0 in
		section_top_addr := Uberspark.Platform.manifest_var.platform.binary.uobj_image_size;

		section_top_addr := !section_top_addr + !uobjcoll_section_load_addr;
		if (!section_top_addr mod Uberspark.Platform.manifest_var.platform.binary.uobjcoll_image_section_alignment) > 0 then begin
			section_top_addr := !section_top_addr +  (Uberspark.Platform.manifest_var.platform.binary.uobjcoll_image_section_alignment - 
			(!section_top_addr mod Uberspark.Platform.manifest_var.platform.binary.uobjcoll_image_section_alignment));
		end;

		let section_size = !section_top_addr - !uobjcoll_section_load_addr in

		Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "uobjs, original size=0x%08x, adjusted size=0x%08x" Uberspark.Platform.manifest_var.platform.binary.uobj_image_size section_size;

		let uobjcoll_namespace_varname = (Uberspark.Namespace.get_variable_name_prefix_from_ns d_uberspark_manifest_var.uobjcoll.namespace) in 
		d_memorymapped_sections_list := !d_memorymapped_sections_list @ [ ((uobjcoll_namespace_varname ^ "__uobjs"), 
			{ fn_name = (uobjcoll_namespace_varname ^ "__uobjs");	
				f_subsection_list = [ ".hdrdata"; ".text";  ".data"; ".rodata"; ".bss"; ".stack"; ".dmadata"; ];	
				usbinformat = { f_type=Uberspark.Defs.Binformat.const_USBINFORMAT_SECTION_TYPE_UOBJ; 
								f_prot=0; 
								f_size = section_size;
								f_aligned_at = Uberspark.Platform.manifest_var.platform.binary.uobjcoll_image_section_alignment; 
								f_pad_to = Uberspark.Platform.manifest_var.platform.binary.uobjcoll_image_section_alignment; 
								f_addr_start = !uobjcoll_section_load_addr; 
								f_addr_file = 0;
								f_reserved = 0;
							};
			}) ];

		Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "added section for uobjs at 0x%08x, size=%08x..." 
			!uobjcoll_section_load_addr section_size;

		(* update next section address *)
		uobjcoll_section_load_addr := !uobjcoll_section_load_addr + section_size; 

	end;


	if !retval then begin
	(* go over all the uobjs and collect uobjrtls *)
		List.iter ( fun ( (l_uobj_ns:string), (l_uberspark_manifest_var:Uberspark.Manifest.uberspark_manifest_var_t) ) -> 

			Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "Gathering section info for uobj: %s..." l_uobj_ns;

			List.iter ( fun ( (l_section_name:string), (l_section_info:Uberspark.Defs.Basedefs.section_info_t) ) -> 

				let section_top_addr = 	ref 0 in
				section_top_addr := l_section_info.usbinformat.f_size;

				section_top_addr := !section_top_addr + !uobjcoll_section_load_addr;
				if (!section_top_addr mod Uberspark.Platform.manifest_var.platform.binary.uobjcoll_image_section_alignment) > 0 then begin
					section_top_addr := !section_top_addr +  (Uberspark.Platform.manifest_var.platform.binary.uobjcoll_image_section_alignment - 
					(!section_top_addr mod Uberspark.Platform.manifest_var.platform.binary.uobjcoll_image_section_alignment));
				end;

				let section_size = !section_top_addr - !uobjcoll_section_load_addr in

				Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "section: original size=0x%08x, adjusted size=0x%08x" l_section_info.usbinformat.f_size section_size;

				d_memorymapped_sections_list := !d_memorymapped_sections_list @ [ ((l_section_info.fn_name), 
					{ fn_name = l_section_info.fn_name;	
						f_subsection_list = l_section_info.f_subsection_list;	
						usbinformat = { f_type=l_section_info.usbinformat.f_type; 
										f_prot=l_section_info.usbinformat.f_prot; 
										f_size = section_size;
										f_aligned_at = l_section_info.usbinformat.f_aligned_at; 
										f_pad_to = l_section_info.usbinformat.f_pad_to; 
										f_addr_start = !uobjcoll_section_load_addr; 
										f_addr_file = 0;
										f_reserved = 0;
									};
					}) ];

				Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "added section for uobj at 0x%08x, size=%08x..." 
					!uobjcoll_section_load_addr section_size;

				(* update next section address *)
				uobjcoll_section_load_addr := !uobjcoll_section_load_addr + section_size; 


			) l_uberspark_manifest_var.uobj.sections;

		) !d_uobj_manifest_var_assoc_list;


	end;


	(* update uobjcoll size *)
	d_size := !uobjcoll_section_load_addr -  !d_load_address;

	Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "%s: d_load_address=0x%08x, d_size=0x%08x" __LOC__ !d_load_address !d_size;

	(!retval)
;;



(*--------------------------------------------------------------------------*)
(* generate uobjcoll linker script *)
(*--------------------------------------------------------------------------*)
let generate_uobjcoll_linker_script
	()
	: bool =
	let retval = ref true in 

	Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "Generating uobjcoll linker script: load_address=0x%08x, size=0x%08x..." !d_load_address !d_size;

	retval := Uberspark.Codegen.Uobjcoll.generate_linker_script	
		(!d_triage_dir_prefix ^ "/" ^ d_uberspark_manifest_var.uobjcoll.namespace ^ "/" ^ Uberspark.Namespace.namespace_uobjcoll_linkerscript_filename) 
		!d_load_address !d_size !d_memorymapped_sections_list;

	(!retval)
;;


(*--------------------------------------------------------------------------*)
(* initialize uobjcoll sources *)
(*--------------------------------------------------------------------------*)
(* TBD: add uobj and uobjrtl sources to uobjcoll sources *)
(* this will be used to generate the final object file list *)
(* note: uobj and uobjrtl sources are added with uberspark/uobjcoll/uobjs/xx/ and uberspark/uobjrtl 
	prefix
	while uobjcoll generated sources are just added without any prefix
	this way when we do source parsing in actions for uobjcoll, we will negate anything that 
	starts from uberspark since we don;t want to compile that
	however, when we generate output list for .os we will take all the sources, replace with .o
	and add the mount point prefix

*)
let initialize_uobjcoll_sources
	()
	: bool =
	let l_retval = ref true in 

	Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "initialize_uobjcoll_sources: starting...";
	Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "len(d_uobjrtl_manifest_var_hashtbl)=%u";
		(Hashtbl.length d_uobjrtl_manifest_var_hashtbl);
	Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "len(d_uobj_manifest_var_assoc_list)=%u";
		(List.length !d_uobj_manifest_var_assoc_list);

	(* iterate through uobjrtl hashtbl and add all uobjrtl sources with uobjrtl namespace prefix *)
	Hashtbl.iter (fun (l_uobjrtl_ns : string) (l_uobjrtl_manifest_var : Uberspark.Manifest.uberspark_manifest_var_t)  ->

		Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "Adding %u sources from uobjrtl:%s"
			(List.length l_uobjrtl_manifest_var.uobjrtl.sources) l_uobjrtl_ns;

		List.iter ( fun (l_source_file : Uberspark.Manifest.Uobjrtl.json_node_uberspark_uobjrtl_modules_spec_t) ->
			d_uberspark_manifest_var.uobjcoll.sources <- d_uberspark_manifest_var.uobjcoll.sources @ [ l_uobjrtl_ns ^ "/" ^ l_source_file.path; ];
		) l_uobjrtl_manifest_var.uobjrtl.sources;

	) d_uobjrtl_manifest_var_hashtbl;

	(* iterate through uobj assoc list and add all uobj sources with uobj namespace prefix *)
	List.iter ( fun ( (l_uobj_ns:string), (l_uobj_manifest_var:Uberspark.Manifest.uberspark_manifest_var_t) ) -> 

		Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "Adding %u sources from uob:%s"
			(List.length l_uobj_manifest_var.uobj.sources) l_uobj_ns;

		List.iter ( fun (l_source_file : string) ->
			d_uberspark_manifest_var.uobjcoll.sources <- d_uberspark_manifest_var.uobjcoll.sources @ [ l_uobj_ns ^ "/" ^ l_source_file; ];
		) l_uobj_manifest_var.uobj.sources;

	) !d_uobj_manifest_var_assoc_list;

	Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "initialize_uobjcoll_sources: end (l_retval=%b)" !l_retval;

	(!l_retval)
;;






let process_uobjcoll_manifest
	?(p_in_order = true) 
	(p_uobjcoll_ns : string)
	(p_targets : string list)
	: bool =

	Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "process_manifest_common (p_uobjcoll_ns=%s)..." p_uobjcoll_ns;

	(* get current working directory *)
	let l_cwd = Uberspark.Osservices.getcurdir() in

	(* get the absolute path of the current working directory *)
	let (rval, l_cwd_abs) = (Uberspark.Osservices.abspath l_cwd) in

	(* bail out on error *)
	if (rval == false) then begin
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "could not get absolute path of current working directory!";
		(false) 
	end else

	(* announce working directory and store in triage dir prefix*)
	let l_dummy=0 in begin
	d_triage_dir_prefix := l_cwd_abs;
	Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "current working directory: %s" !d_triage_dir_prefix;
	end;

	(* announce staging directory and store in staging dir prefix*)
	let l_dummy=0 in begin
	d_staging_dir_prefix := Uberspark.Namespace.get_namespace_staging_dir_prefix ();
	Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "staging directory: %s" !d_staging_dir_prefix;
	end;

	(* read manifest file into manifest variable *)
	let abspath_mf_filename = (!d_triage_dir_prefix ^ "/" ^ p_uobjcoll_ns ^ "/" ^ Uberspark.Namespace.namespace_root_mf_filename) in 
	let rval = Uberspark.Manifest.manifest_file_to_uberspark_manifest_var abspath_mf_filename d_uberspark_manifest_var in

	(* bail out on error *)
  	if (rval == false) then
    	(false)
  	else

	let l_dummy=0 in begin
	Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "read manifest file into JSON object";
	end;

	(* sanity check we are an uobjcoll manifest and bail out on error*)
  (* TBD: add support for multi-platform uobjcoll *)
	if (d_uberspark_manifest_var.manifest.namespace <> Uberspark.Namespace.namespace_uobjcoll_mf_node_type_tag) then
		(false)
	else

	(* create uobjcoll manifest variables assoc list *)
	(* TBD: revisions needed for multi-platform uobjcoll *) 
	let l_dummy=0 in begin
	d_uobjcoll_manifest_var_assoc_list := [ (p_uobjcoll_ns, d_uberspark_manifest_var) ];
	Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "created uobjcoll manifest variable assoc list...";
	end;


	(* iterate through all uobjcolls *)
	let retval = ref true in 
	List.iter ( fun ( (l_uobjcoll_ns:string), (l_uberspark_manifest_var:Uberspark.Manifest.uberspark_manifest_var_t) ) -> 
		
		if (!retval) then begin
			Uberspark.Logger.log ~lvl:Uberspark.Logger.Info "processing uobjcoll: %s..." l_uobjcoll_ns;

      (* debug dump uobjcoll platform and load platform configuration *)
      let l_dummy=0 in begin
      Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "uobjcoll platform: %s" l_uberspark_manifest_var.uobjcoll.platform;
      retval := Uberspark.Platform.load_from_manifest_file (!d_staging_dir_prefix ^ "/" ^ l_uberspark_manifest_var.uobjcoll.platform);
      end;

			if (!retval) == false then
				()
			else

      (* announce that we successfully loaded the platform definitions *)
    	(* and set default uobjcoll size and load address *)
      let l_dummy=0 in begin
      Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "read uobjcoll platform definitions";
      d_load_address := Uberspark.Platform.manifest_var.platform.binary.uobjcoll_image_load_address;
      d_size := Uberspark.Platform.manifest_var.platform.binary.uobjcoll_image_size;
      end;

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


			(* create loader to manifest variable hashtbl *)
			let l_dummy=0 in begin
			retval := create_loader_manifest_var_hashtbl ();
			end;

			if (!retval) == false then
				()
			else


			(* initialize uobjcoll sources *)
			let l_dummy=0 in begin
			retval := initialize_uobjcoll_sources ();
			end;

			if (!retval) == false then
				()
			else

			(* sanity check init_method and public_method entries *)
			let l_dummy=0 in begin
			retval := sanity_check_uobjcoll_method_entries ();
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


			(* iterate through uobjrtl list and copy uobjrtl sources to triage area *)
			let l_dummy=0 in begin
			retval := copy_uobjrtl_to_triage ();
			end;

			if (!retval) == false then
				()
			else

			(* iterate through loader list and copy loader sources to triage area *)
			let l_dummy=0 in begin
			retval := copy_loaders_to_triage ();
			end;

			if (!retval) == false then
				()
			else


			(* generate sentinels for uobjcoll methods *)
			let l_dummy=0 in begin
			retval := generate_sentinels_for_uobjcoll_methods ();
			end;

			if (!retval) == false then
				()
			else


			(* generate uobjcoll header file *)
			let l_dummy=0 in begin
			retval := generate_uobjcoll_header_file ();
			end;

			if (!retval) == false then
				()
			else

			(* generate header files for uobjs *)
			let l_dummy=0 in begin
			retval := generate_header_files_for_uobjs ();
			end;

			if (!retval) == false then
				()
			else

			(* generate uobjcoll section info *)
			let l_dummy=0 in begin
			retval := generate_uobjcoll_section_info ();
			end;

			if (!retval) == false then
				()
			else

			(* generate uobjcoll linker script *)
			let l_dummy=0 in begin
			retval := generate_uobjcoll_linker_script ();
			end;

			if (!retval) == false then
				()
			else

			(* initialize actions *)
			let l_dummy=0 in begin
			retval := (Uberspark.Actions.initialize 
				d_uberspark_manifest_var
				!d_uobj_manifest_var_assoc_list
				d_uobjrtl_manifest_var_hashtbl
				d_loader_manifest_var_hashtbl
				!d_triage_dir_prefix
				!d_staging_dir_prefix);
				
			end;

			if (!retval) == false then
				()
			else


			(* process actions *)
			let l_dummy=0 in begin
			retval := Uberspark.Actions.process_actions ~p_in_order:p_in_order p_targets;
			end;

			if (!retval) == false then
				()
			else

			let l_dummy=0 in begin
			Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "uobjcoll processed successfully!";
			end;
		end;

		()
	)!d_uobjcoll_manifest_var_assoc_list;

	(!retval)
;;









(*--------------------------------------------------------------------------*)
(* 
  initialize operating context
*)
(*--------------------------------------------------------------------------*)

let initialize
	?(p_log_level = (Uberspark.Logger.ord Info)) 
  ?(p_print_banner = true)
	(p_banner : string list)
  : unit =

  (* set console log level *)
  Uberspark.Logger.current_level := p_log_level;

  (* turn on exception stack backtrace dump *)
  Printexc.record_backtrace true;

  (* print banner *)
  if p_print_banner then begin
    List.iter ( fun (p_str : string) ->
      Uberspark.Logger.log "%s" p_str;    
    ) p_banner;
  end;

  let mf_json_node_uberspark_installation_var : Uberspark.Manifest.Installation.json_node_uberspark_installation_t = 
		  {root_directory = ""; default_platform = "";} in

  (* setup namespace root directory *)
  (* we open the installation manifest to figure out the root directory *)
  let installation_manifest_filename = Uberspark.Namespace.namespace_installation_configdir ^ "/" ^
        Uberspark.Namespace.namespace_root_mf_filename in
  let (rval, mf_json) = (Uberspark.Manifest.get_json_for_manifest installation_manifest_filename ) in
    if(rval == true) then	begin
      (* convert to var *)
      let rval =	(Uberspark.Manifest.Installation.json_node_uberspark_installation_to_var mf_json mf_json_node_uberspark_installation_var) in
        if rval then begin
          Uberspark.Namespace.set_namespace_root_dir_prefix mf_json_node_uberspark_installation_var.root_directory;

        end else begin
          Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "Malformed installation configuration manifest at: %s" installation_manifest_filename;
          ignore (exit 1);
        end;

    end else begin
      Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "Could not load installation configuration manifest from: %s" installation_manifest_filename;
      ignore (exit 1);
    end;
  
  
  Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "namespace root dir prefix=%s" (Uberspark.Namespace.get_namespace_root_dir_prefix ());
  Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "staging dir prefix=%s" (Uberspark.Namespace.get_namespace_staging_dir_prefix ());
  Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "default platform=%s" (mf_json_node_uberspark_installation_var.default_platform);
 
  Uberspark.Logger.log ~crlf:false "Loading current configuration...";
  if not (Uberspark.Platform.load_from_manifest_file (!d_staging_dir_prefix ^ "/" ^ mf_json_node_uberspark_installation_var.default_platform)) then 
    begin
      Uberspark.Logger.log ~tag:"" "[ERROR - exiting]";
      ignore ( exit 1);
    end
  ;

  Uberspark.Logger.log ~tag:"" "[OK]";

  ()
;;
