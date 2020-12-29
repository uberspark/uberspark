(*===========================================================================*)
(*===========================================================================*)
(*	uberSpark uberobject verification and build interface 	             	 *)
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

type publicmethod_info_t =
{
	mutable f_uobjpminfo			: Uberspark_manifest.Uobj.json_node_uberspark_uobj_publicmethods_t;
	mutable f_uobjinfo    			: Defs.Basedefs.uobjinfo_t;			
};;


type slt_info_t = 
{
	(* intrauobjcoll canonical publicmethod name to sentinel type list mapping *)
	mutable f_intrauobjcoll_callees_sentinel_type_hashtbl : (string, string list) Hashtbl.t;

	(* intrauobjcoll canonical publicmethod sentinel name to sentinel address mapping *)
	mutable f_intrauobjcoll_callees_sentinel_address_hashtbl : (string, Defs.Basedefs.uobjcoll_sentinel_address_t)  Hashtbl.t; 

	(* indexed by canonical publicmethod name *)
	mutable f_interuobjcoll_callees_sentinel_type_hashtbl : (string, string list) Hashtbl.t;

	(* indexed by canonical publicmethod sentinel name *)
	mutable f_interuobjcoll_callees_sentinel_address_hashtbl : (string, Defs.Basedefs.uobjcoll_sentinel_address_t)  Hashtbl.t; 

	(* indexed by canonical legacy callee name *)
	mutable f_legacy_callees_sentinel_type_hashtbl : (string, string list) Hashtbl.t;

	(* indexed by canonical legacy callee sentinel name *)
	mutable f_legacy_callees_sentinel_address_hashtbl : (string, Defs.Basedefs.uobjcoll_sentinel_address_t)  Hashtbl.t; 
};;



(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* class definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)


class uobject 
	= object(self)

	(*val log_tag = "Usuobj";*)
	val d_ltag = "Usuobj";

	val d_mf_filename = ref "";
	method get_d_mf_filename = !d_mf_filename;
	method set_d_mf_filename (mf_filename : string) = 
		d_mf_filename := mf_filename;
		()
	;

	val d_path_to_mf_filename = ref "";
	method get_d_path_to_mf_filename = !d_path_to_mf_filename;
	method set_d_path_to_mf_filename (path_to_mf_filename : string) = 
		d_path_to_mf_filename := path_to_mf_filename;
		()
	;

	val d_path_ns = ref "";
	method get_d_path_ns = !d_path_ns;

	val d_builddir = ref "";
	method get_d_builddir = !d_builddir;
	method set_d_builddir (builddir : string) = 
		d_builddir := builddir;
		()
	;


	(* uobj manifest file top-level json *)
	val d_mf_json : Yojson.Basic.t ref = ref `Null;

	(* uobj manifest uberspark-uobj json node var *)
	val json_node_uberspark_uobj_var : Uberspark_manifest.Uobj.json_node_uberspark_uobj_t =
		{namespace = ""; platform = ""; arch = ""; cpu = ""; 
		sources = {source_h_files= []; source_c_files = []; source_casm_files = []; source_asm_files = [];};
		public_methods = []; intra_uobjcoll_callees = []; inter_uobjcoll_callees = [];
		legacy_callees = []; sections = []; uobjrtl = []; 
		};


	val d_mf_json_node_uberspark_uobjslt_var : Uberspark_manifest.Uobjslt.json_node_uberspark_uobjslt_t = 
		{namespace = ""; platform = ""; arch = ""; cpu = ""; sizeof_addressing=0;
		 code_template_directxfer = ""; code_template_indirectxfer = ""; code_template_data_definition = ""; };

	method get_d_publicmethods_assoc_list = json_node_uberspark_uobj_var.public_methods;



	val d_publicmethods_hashtbl = ((Hashtbl.create 32) : ((string, Uberspark_manifest.Uobj.json_node_uberspark_uobj_publicmethods_t)  Hashtbl.t)); 
	method get_d_publicmethods_hashtbl = d_publicmethods_hashtbl;

	val d_intrauobjcoll_callees_hashtbl = ((Hashtbl.create 32) : ((string, string list)  Hashtbl.t)); 
	method get_d_intrauobjcoll_callees_hashtbl = d_intrauobjcoll_callees_hashtbl;

	val d_interuobjcoll_callees_hashtbl = ((Hashtbl.create 32) : ((string, string list)  Hashtbl.t)); 
	method get_d_interuobjcoll_callees_hashtbl = d_interuobjcoll_callees_hashtbl;

	val d_legacy_callees_hashtbl = ((Hashtbl.create 32) : ((string, string list)  Hashtbl.t)); 
	method get_d_legacy_callees_hashtbl = d_legacy_callees_hashtbl;

	val d_uobjrtl_hashtbl = ((Hashtbl.create 32) : ((string, Uberspark_manifest.Uobjrtl.json_node_uberspark_uobjrtl_t)  Hashtbl.t)); 
	method get_d_uobjrtl_hashtbl = d_uobjrtl_hashtbl;



	(* association list of default uobj binary image sections; indexed by section name *)		
	val d_default_sections_list : (string * Defs.Basedefs.section_info_t) list ref = ref []; 
	method get_d_default_sections_list_ref = d_default_sections_list;
	method get_d_default_sections_list_val = !d_default_sections_list;


	(* association list of uobj public methods sections; indexed by section name *)		
	val d_publicmethods_sections_list : (string * Defs.Basedefs.section_info_t) list ref = ref []; 
	method get_d_publicmethods_sections_list_ref = d_publicmethods_sections_list;
	method get_d_publicmethods_sections_list_val = !d_publicmethods_sections_list;


	(* association list of uobj binary image sections with memory map info; indexed by section name *)		
	val d_memorymapped_sections_list : (string * Defs.Basedefs.section_info_t) list ref = ref []; 
	method get_d_memorymapped_sections_list_ref = d_memorymapped_sections_list;
	method get_d_memorymapped_sections_list_val = !d_memorymapped_sections_list;


	val d_target_def: Defs.Basedefs.target_def_t = {
		platform = ""; 
		arch = ""; 
		cpu = "";
	};
	method get_d_target_def = d_target_def;
	method set_d_target_def 
		(target_def: Defs.Basedefs.target_def_t) = 
		d_target_def.platform <- target_def.platform;
		d_target_def.arch <- target_def.arch;
		d_target_def.cpu <- target_def.cpu;
		()
	;
		


	(* uobj binary image load address *)
	val d_load_addr = ref Uberspark_config.json_node_uberspark_config_var.uobj_binary_image_load_address;
	method get_d_load_addr = !d_load_addr;
	method set_d_load_addr load_addr = (d_load_addr := load_addr);
	
	(* uobj binary image size; will be overwritten with actual size using alignment if uniform_size=false  *)
	val d_size = ref Uberspark_config.json_node_uberspark_config_var.uobj_binary_image_size; 
	method get_d_size = !d_size;
	method set_d_size size = (d_size := size);

	(* uobj binary image uniform size flag *)
	val d_uniform_size = ref Uberspark_config.json_node_uberspark_config_var.uobj_binary_image_uniform_size; 
	method get_d_uniform_size = !d_uniform_size;
	method set_d_uniform_size uniform_size = (d_uniform_size := uniform_size);

	(* uobj binary image alignment *)
	val d_alignment = ref Uberspark_config.json_node_uberspark_config_var.uobj_binary_image_alignment; 
	method get_d_alignment = !d_alignment;
	method set_d_alignment alignment = (d_alignment := alignment);


	(* uobj sentinel linkage table info  -- updated by uobjcoll build *)
	val d_slt_info : slt_info_t = {
		f_intrauobjcoll_callees_sentinel_type_hashtbl = ((Hashtbl.create 32) : ((string, string list)  Hashtbl.t));
		f_intrauobjcoll_callees_sentinel_address_hashtbl = ((Hashtbl.create 32) : ((string, Defs.Basedefs.uobjcoll_sentinel_address_t)  Hashtbl.t));
		f_interuobjcoll_callees_sentinel_type_hashtbl = ((Hashtbl.create 32) : ((string, string list)  Hashtbl.t));
		f_interuobjcoll_callees_sentinel_address_hashtbl =((Hashtbl.create 32) : ((string, Defs.Basedefs.uobjcoll_sentinel_address_t)  Hashtbl.t));
		f_legacy_callees_sentinel_type_hashtbl = ((Hashtbl.create 32) : ((string, string list)  Hashtbl.t));
		f_legacy_callees_sentinel_address_hashtbl = ((Hashtbl.create 32) : ((string, Defs.Basedefs.uobjcoll_sentinel_address_t)  Hashtbl.t));  
	};
	method get_d_slt_info = d_slt_info;
	method set_d_slt_info 
		(slt_info: slt_info_t) = 
		d_slt_info.f_intrauobjcoll_callees_sentinel_type_hashtbl <- slt_info.f_intrauobjcoll_callees_sentinel_type_hashtbl;
		d_slt_info.f_intrauobjcoll_callees_sentinel_address_hashtbl <- slt_info.f_intrauobjcoll_callees_sentinel_address_hashtbl; 
		d_slt_info.f_interuobjcoll_callees_sentinel_type_hashtbl <- slt_info.f_interuobjcoll_callees_sentinel_type_hashtbl; 
		d_slt_info.f_interuobjcoll_callees_sentinel_address_hashtbl <- slt_info.f_interuobjcoll_callees_sentinel_address_hashtbl;
		d_slt_info.f_legacy_callees_sentinel_type_hashtbl <- slt_info.f_legacy_callees_sentinel_type_hashtbl; 
		d_slt_info.f_legacy_callees_sentinel_address_hashtbl <- slt_info.f_legacy_callees_sentinel_address_hashtbl; 
		()
	;

	(* uobj slt codegen info list for interuobjcoll callees *)
	val d_interuobjcoll_callees_slt_codegen_info_list : Uberspark_codegen.Uobj.slt_codegen_info_t list ref = ref [];

	(* uobj slt codegen info list for intrauobjcoll callees *)
	val d_intrauobjcoll_callees_slt_codegen_info_list : Uberspark_codegen.Uobj.slt_codegen_info_t list ref = ref [];

	(* uobj slt codegen info list for legacy callees *)
	val d_legacy_callees_slt_codegen_info_list : Uberspark_codegen.Uobj.slt_codegen_info_t list ref = ref [];

	(* uobj slt indirect xfer table assoc list for interuobjcoll callees indexed by canonical pm sentinel name *)
	val d_interuobjcoll_callees_slt_indirect_xfer_table_assoc_list : (string * Defs.Basedefs.slt_indirect_xfer_table_info_t) list ref = ref []; 
	
	(* uobj slt indirect xfer table assoc list for intrauobjcoll callees indexed by canonical pm sentinel name *)
	val d_intrauobjcoll_callees_slt_indirect_xfer_table_assoc_list : (string * Defs.Basedefs.slt_indirect_xfer_table_info_t) list ref = ref []; 

	(* uobj slt indirect xfer table assoc list for legacy callees indexed by canonical pm sentinel name *)
	val d_legacy_callees_slt_indirect_xfer_table_assoc_list : (string * Defs.Basedefs.slt_indirect_xfer_table_info_t) list ref = ref []; 



	(*--------------------------------------------------------------------------*)
	(* parse uobj manifest *)
	(* usmf_filename = canonical uobj manifest filename *)
	(*--------------------------------------------------------------------------*)
	method parse_manifest 
		()
		: bool =

		(* read manifest JSON *)
		let (rval, mf_json) = (Uberspark_manifest.get_json_for_manifest 
			(self#get_d_path_to_mf_filename ^ "/" ^ self#get_d_mf_filename) 
			) in
		
		if (rval == false) then (false)
		else

		(* store manifest JSON *)
		let dummy = 0 in begin
		d_mf_json := mf_json;
		end;

		(* parse uberspark-uobj node *)
		let rval = (Uberspark_manifest.Uobj.json_node_uberspark_uobj_to_var mf_json
				json_node_uberspark_uobj_var) in

		if (rval == false) then (false)
		else

		let dummy = 0 in begin
		(* generate public_methods hashtable *)
		List.iter ( fun (x,y) -> 
			Hashtbl.add d_publicmethods_hashtbl x y;
		) json_node_uberspark_uobj_var.public_methods;

		(* generate intrauobjcoll-callees hashtable *)
		List.iter ( fun (x,y) -> 
			Hashtbl.add d_intrauobjcoll_callees_hashtbl x y;
		) json_node_uberspark_uobj_var.intra_uobjcoll_callees;

		(* generate interuobjcoll-callees hashtable *)
		List.iter ( fun (x,y) -> 
			Hashtbl.add d_interuobjcoll_callees_hashtbl x y;
		) json_node_uberspark_uobj_var.inter_uobjcoll_callees;

		(* generate legacy-callees hashtable *)
		List.iter ( fun (x,y) -> 
			Hashtbl.add d_legacy_callees_hashtbl x y;
		) json_node_uberspark_uobj_var.legacy_callees;
		end;


		let dummy=0 in begin
			d_path_ns := (Uberspark_namespace.get_namespace_staging_dir_prefix ())  ^ "/" ^ json_node_uberspark_uobj_var.namespace;
		end;

		let dummy = 0 in
			begin
				Uberspark_logger.log "total sources: h files=%u, c files=%u, casm files=%u, asm files=%u" 
					(List.length json_node_uberspark_uobj_var.sources.source_h_files)
					(List.length json_node_uberspark_uobj_var.sources.source_c_files)
					(List.length json_node_uberspark_uobj_var.sources.source_casm_files)
					(List.length json_node_uberspark_uobj_var.sources.source_asm_files);
			end;


		let dummy = 0 in
			begin
				Uberspark_logger.log "total public methods:%u,%u" (Hashtbl.length self#get_d_publicmethods_hashtbl)
					(List.length json_node_uberspark_uobj_var.public_methods); 
			end;

		let dummy = 0 in
			begin
				Uberspark_logger.log "list of uobj-intrauobjcoll-callees follows:";

				Hashtbl.iter (fun key value  ->
					Uberspark_logger.log "uobj=%s; callees=%u" key (List.length value);
				) self#get_d_intrauobjcoll_callees_hashtbl;
			end;

		let dummy = 0 in
			begin
				Uberspark_logger.log "total interuobjcoll callees=%u" (Hashtbl.length self#get_d_interuobjcoll_callees_hashtbl);
			end;

		let dummy = 0 in
			begin
				Uberspark_logger.log "total legacy callees=%u" (Hashtbl.length self#get_d_legacy_callees_hashtbl);
			end;


		let dummy = 0 in
		if (rval == true) then
			begin
				Uberspark_logger.log "binary sections override:%u" (List.length json_node_uberspark_uobj_var.sections);								
			end;

		(true)
	;








	(*--------------------------------------------------------------------------*)
	(* parse sentinel linkage manifest *)
	(*--------------------------------------------------------------------------*)
	method parse_manifest_slt	
		= 
		let retval = ref false in 	
		let target_def = self#get_d_target_def in	
		let uobjslt_filename = ((Uberspark_namespace.get_namespace_staging_dir_prefix ()) ^ "/" ^ Uberspark_namespace.namespace_root ^ "/" ^ Uberspark_namespace.namespace_uobjslt ^ "/" ^
			target_def.arch ^ "/" ^ target_def.cpu ^ "/" ^
			Uberspark_namespace.namespace_root_mf_filename) in 

		let (rval, abs_uobjslt_filename) = (Uberspark_osservices.abspath uobjslt_filename) in
		if(rval == true) then
		begin
			Uberspark_logger.log "reading slt manifest from:%s" abs_uobjslt_filename;

			(* read manifest JSON *)
			let (rval, mf_json) = (Uberspark_manifest.get_json_for_manifest abs_uobjslt_filename) in
			if(rval == true) then
			begin

				(* convert to var *)
				let rval =	(Uberspark_manifest.Uobjslt.json_node_uberspark_uobjslt_to_var mf_json d_mf_json_node_uberspark_uobjslt_var) in
				if rval then
				begin
					retval := true;

				end;
			end;
		end;

		(!retval)
	;


	(*--------------------------------------------------------------------------*)
	(* parse uobj uobjrtl manifests *)
	(*--------------------------------------------------------------------------*)
	method parse_uobjrtl_manifests 
		()
		: bool =
		let retval = ref true in 

		(* iterate over uobj uobjrtl manifest node *)
		List.iter ( fun ( (uobjrtl_namespace : string), (uobjrtl_entry : Uberspark_manifest.Uobj.json_node_uberspark_uobj_uobjrtl_t) ) -> 
			if !retval == true then begin
				
				(* parse each uobjrtl manifest and create a hashtable with entry as namespace *)
				(* entry will be an entry of type uobjrtl_t *)

				Uberspark_logger.log ~lvl:Uberspark_logger.Debug "uobjrtl namespace=%s" uobjrtl_entry.namespace;

				let uobjrtl_manifest_path = ((Uberspark_namespace.get_namespace_staging_dir_prefix ()) ^ "/" ^ uobjrtl_entry.namespace ^ "/" ^ Uberspark_namespace.namespace_root_mf_filename) in

				Uberspark_logger.log ~lvl:Uberspark_logger.Debug "uobjrtl manifest path=%s" uobjrtl_manifest_path;


				(* read uobjrtl manifest JSON *)
				let (rval, mf_json) = (Uberspark_manifest.get_json_for_manifest uobjrtl_manifest_path) in
				if(rval == true) then begin
					
					(* convert to var *)
					let l_uobjrtl_entry_var : Uberspark_manifest.Uobjrtl.json_node_uberspark_uobjrtl_t = {
						namespace = ""; platform = ""; arch = ""; cpu = "";	source_c_files = []; source_casm_files = [];} in
					let rval =	(Uberspark_manifest.Uobjrtl.json_node_uberspark_uobjrtl_to_var mf_json l_uobjrtl_entry_var) in
					if rval then begin
						Hashtbl.add d_uobjrtl_hashtbl uobjrtl_namespace l_uobjrtl_entry_var;						
					end else begin
						retval := false;
					end;
				end else begin
					retval := false;
				end;

			end;

		) json_node_uberspark_uobj_var.uobjrtl;


		(!retval)
	;


	(*--------------------------------------------------------------------------*)
	(* overlay uobj config settings if any *)
	(*--------------------------------------------------------------------------*)
	method overlay_config_settings 
		()
		: bool =

		(* parse, load and overlay config-settings node, if one is present *)
		if (Uberspark_config.load_from_json !d_mf_json) then begin
			(true) (* loaded and overlaid config-settings from uobj manifest *)
		end else begin
			(false) (* uobj manifest did not have config-settings specified *)
		end
	;


	(*--------------------------------------------------------------------------*)
	(* consolidate sections with memory map *)
	(* update uobj size (d_size) accordingly and return the size *)
	(*--------------------------------------------------------------------------*)
	method consolidate_sections_with_memory_map
		()
		: int  
		=

		let uobj_section_load_addr = ref 0 in
		(* TBD: we need to handle non-uniform uobj size, in which case we will only be an alignment value 
			and we need to revise uobjsize comparision to alignment comparisons
		*)
		let uobjsize = self#get_d_size in
		let uobj_load_addr = self#get_d_load_addr in

		(* clear out memory mapped sections list and set initial load address *)
		uobj_section_load_addr := self#get_d_load_addr;
		d_memorymapped_sections_list := []; 
		
		(* iterate over default sections *)
		List.iter (fun (key, (x:Defs.Basedefs.section_info_t))  ->
			(* compute and round up section size to section alignment *)
			let remainder_size = (x.usbinformat.f_size mod Uberspark_config.json_node_uberspark_config_var.binary_uobj_section_alignment) in
			let padding_size = ref 0 in
				if remainder_size > 0 then
					begin
						padding_size := Uberspark_config.json_node_uberspark_config_var.binary_uobj_section_alignment - remainder_size;
					end
				else
					begin
						padding_size := 0;
					end
				;
			let section_size = (x.usbinformat.f_size + !padding_size) in 


			d_memorymapped_sections_list := !d_memorymapped_sections_list @ [ (key, 
				{ fn_name = x.fn_name;	
					f_subsection_list = x.f_subsection_list;	
					usbinformat = { f_type=x.usbinformat.f_type; 
													f_prot=0; 
													f_size = section_size;
													f_aligned_at = Uberspark_config.json_node_uberspark_config_var.binary_uobj_section_alignment; 
													f_pad_to = Uberspark_config.json_node_uberspark_config_var.binary_uobj_section_alignment; 
													f_addr_start = !uobj_section_load_addr; 
													f_addr_file = 0;
													f_reserved = 0;
												};
				}) ];


			Uberspark_logger.log "section at address 0x%08x, size=0x%08x padding=0x%08x" !uobj_section_load_addr section_size !padding_size;

			(* if this section is for a public method, then update public_methods hashtable with address *)
			if x.usbinformat.f_type == Defs.Binformat.const_USBINFORMAT_SECTION_TYPE_UOBJ_PMINFO then begin
				let public_method = (Str.string_after x.fn_name 8) in  (* grab public method name after uobj_pm_ *)
				Uberspark_logger.log ~lvl:Uberspark_logger.Debug "section is for publicmethod: name=%s" public_method;
			    if (Hashtbl.mem self#get_d_publicmethods_hashtbl public_method) then begin
					let pm_info = (Hashtbl.find self#get_d_publicmethods_hashtbl public_method) in
						pm_info.fn_address <- !uobj_section_load_addr;
					Hashtbl.replace self#get_d_publicmethods_hashtbl public_method pm_info;
					Uberspark_logger.log ~lvl:Uberspark_logger.Debug "updated publicmethod address as 0x%08x" pm_info.fn_address;
		    	end else begin
					Uberspark_logger.log ~lvl:Uberspark_logger.Warn "unable to match public method name to section definition!";
		    	end
			    ;
			end;

			(* compute next section load address *)
			uobj_section_load_addr := !uobj_section_load_addr + section_size;

		)self#get_d_default_sections_list_val;


		(* iterate over manifest sections *)
		List.iter (fun (key, (x:Defs.Basedefs.section_info_t))  ->
			(* compute and round up section size to section alignment *)
			let remainder_size = (x.usbinformat.f_size mod Uberspark_config.json_node_uberspark_config_var.binary_uobj_section_alignment) in
			let padding_size = ref 0 in
				if remainder_size > 0 then
					begin
						padding_size := Uberspark_config.json_node_uberspark_config_var.binary_uobj_section_alignment - remainder_size;
					end
				else
					begin
						padding_size := 0;
					end
				;
			let section_size = (x.usbinformat.f_size + !padding_size) in 


			d_memorymapped_sections_list := !d_memorymapped_sections_list @ [ (key, 
				{ fn_name = x.fn_name;	
					f_subsection_list = x.f_subsection_list;	
					usbinformat = { f_type=x.usbinformat.f_type; 
													f_prot=0; 
													f_size = section_size;
													f_aligned_at = Uberspark_config.json_node_uberspark_config_var.binary_uobj_section_alignment; 
													f_pad_to = Uberspark_config.json_node_uberspark_config_var.binary_uobj_section_alignment; 
													f_addr_start = !uobj_section_load_addr; 
													f_addr_file = 0;
													f_reserved = 0;
												};
				}) ];

			Uberspark_logger.log "section at address 0x%08x, size=0x%08x padding=0x%08x" !uobj_section_load_addr section_size !padding_size;
			uobj_section_load_addr := !uobj_section_load_addr + section_size;

		)json_node_uberspark_uobj_var.sections;

		
		if (self#get_d_uniform_size) then begin
			(* uniform uobj binary image size *)
			
			(* check to see if the uobj sections fit neatly into uobj size *)
			(* if not, add a filler section to pad it to uobj size *)
			if (!uobj_section_load_addr - uobj_load_addr) > uobjsize then
				begin
					Uberspark_logger.log ~lvl:Uberspark_logger.Error "uobj total section sizes (0x%08x) span beyond uobj size (0x%08x)!" (!uobj_section_load_addr - uobj_load_addr) uobjsize;
					ignore(exit 1);
				end
			;	

			if (!uobj_section_load_addr - uobj_load_addr) < uobjsize then
				begin
					(* add padding section *)
					d_memorymapped_sections_list := !d_memorymapped_sections_list @ [ ("usuobj_padding", 
						{ fn_name = "usuobj_padding";	
							f_subsection_list = [ ];	
							usbinformat = { f_type = Defs.Basedefs.def_USBINFORMAT_SECTION_TYPE_PADDING;
															f_prot=0; 
															f_size = (uobjsize - (!uobj_section_load_addr - uobj_load_addr));
															f_aligned_at = Uberspark_config.json_node_uberspark_config_var.binary_uobj_section_alignment; 
															f_pad_to = Uberspark_config.json_node_uberspark_config_var.binary_uobj_section_alignment; 
															f_addr_start = !uobj_section_load_addr; 
															f_addr_file = 0;
															f_reserved = 0;
														};
						}) ];
				end
			;	

		end else begin
			(* uobj binary image sizes within the collection are not uniform *)
			
			if (!uobj_section_load_addr mod self#get_d_alignment) > 0 then begin
				(* uobj_section_load_addr is __not__ aligned at uobj_binary_image_alignment *)
				(* add padding section *)
				d_memorymapped_sections_list := !d_memorymapped_sections_list @ [ ("usuobj_padding", 
					{ fn_name = "uobj_padding";	
						f_subsection_list = [ ];	
						usbinformat = { f_type = Defs.Binformat.const_USBINFORMAT_SECTION_TYPE_PADDING;
										f_prot=0; 
										f_size = (self#get_d_alignment - (!uobj_section_load_addr mod self#get_d_alignment));
										f_aligned_at = Uberspark_config.json_node_uberspark_config_var.binary_uobj_section_alignment; 
										f_pad_to = Uberspark_config.json_node_uberspark_config_var.binary_uobj_section_alignment; 
										f_addr_start = !uobj_section_load_addr; 
										f_addr_file = 0;
										f_reserved = 0;
						};
					} )];

				(* update uobj size *)
				self#set_d_size ((!uobj_section_load_addr + (self#get_d_alignment - (!uobj_section_load_addr mod self#get_d_alignment))) - self#get_d_load_addr);

			end else begin
				(* uobj_section_load_addr is aligned at uobj_binary_image_alignment *)
				(* we don't need to do anything *)
			end;

		end;
					
		(self#get_d_size)
	;


	(*--------------------------------------------------------------------------*)
	(* add default uobj binary sections *)
	(*--------------------------------------------------------------------------*)
	method add_default_uobj_binary_sections	
		()
		: unit =
		
		let l_add_section (section_fn_name: string)
						(section_f_subsection_list : string list)
						(section_usbinformat_f_type : int)
						(section_usbinformat_f_prot : int)
						(section_usbinformat_f_size : int)
						(section_usbinformat_f_aligned_at : int)
						(section_usbinformat_f_pad_to : int)
						: unit =

			let l_var_sinfo : Defs.Basedefs.section_info_t = {
				fn_name = section_fn_name;	
				f_subsection_list = section_f_subsection_list;	
				usbinformat = { f_type= section_usbinformat_f_type; 
								f_prot= section_usbinformat_f_prot; 
								f_size = section_usbinformat_f_size;
								f_aligned_at = section_usbinformat_f_aligned_at; 
								f_pad_to = section_usbinformat_f_pad_to; 
								f_addr_start=0; 
								f_addr_file = 0;
								f_reserved = 0;
							};
			} in

			(* override size, alignment and padding info if specified in the manifest *)
			(* also append any extra subsections if specified in the manifest *)
			if (List.mem_assoc section_fn_name json_node_uberspark_uobj_var.sections) then begin
				let l_var_sinfo_mf : Defs.Basedefs.section_info_t = (List.assoc section_fn_name json_node_uberspark_uobj_var.sections) in
				l_var_sinfo.usbinformat.f_size <- l_var_sinfo_mf.usbinformat.f_size;
				l_var_sinfo.usbinformat.f_aligned_at <- l_var_sinfo_mf.usbinformat.f_aligned_at;
				l_var_sinfo.usbinformat.f_pad_to <- l_var_sinfo_mf.usbinformat.f_pad_to;
				l_var_sinfo.f_subsection_list <- l_var_sinfo.f_subsection_list @ l_var_sinfo_mf.f_subsection_list;
				json_node_uberspark_uobj_var.sections <- List.remove_assoc section_fn_name json_node_uberspark_uobj_var.sections;
			end;

			d_default_sections_list := !d_default_sections_list @ [ (section_fn_name, l_var_sinfo) ];

			()
		in

		(* start with uobj state save area section *)
		l_add_section "uobj_ssa" [ ".uobj_ssa" ] 
					Defs.Binformat.const_USBINFORMAT_SECTION_TYPE_UOBJ_SSA
					0 
					Uberspark_config.json_node_uberspark_config_var.binary_uobj_default_section_size
					Uberspark_config.json_node_uberspark_config_var.binary_uobj_section_alignment
					Uberspark_config.json_node_uberspark_config_var.binary_uobj_section_alignment;

		(* create sections for each public method *)
		Hashtbl.iter (fun (public_method:string) (pm_info:Uberspark_manifest.Uobj.json_node_uberspark_uobj_publicmethods_t)  ->
			let section_name = ("uobj_pm_" ^ public_method) in 

			l_add_section section_name [ "." ^ section_name ]
						Defs.Binformat.const_USBINFORMAT_SECTION_TYPE_UOBJ_PMINFO
						0 
						Uberspark_config.json_node_uberspark_config_var.binary_uobj_default_section_size
						Uberspark_config.json_node_uberspark_config_var.binary_uobj_section_alignment
						Uberspark_config.json_node_uberspark_config_var.binary_uobj_section_alignment;

		) self#get_d_publicmethods_hashtbl;
		

		(* intrauobjcoll callees slt code section *)
		l_add_section "uobj_intrauobjcoll_csltcode" [ ".uobj_intrauobjcoll_csltcode" ]
					Defs.Binformat.const_USBINFORMAT_SECTION_TYPE_UOBJ_INTRAUOBJCOLL_CSLTCODE
					0 
					Uberspark_config.json_node_uberspark_config_var.binary_uobj_default_section_size
					Uberspark_config.json_node_uberspark_config_var.binary_uobj_section_alignment
					Uberspark_config.json_node_uberspark_config_var.binary_uobj_section_alignment;

		(* intrauobjcoll callees slt data section *)
		l_add_section "uobj_intrauobjcoll_csltdata" [ ".uobj_intrauobjcoll_csltdata" ]
					Defs.Binformat.const_USBINFORMAT_SECTION_TYPE_UOBJ_INTRAUOBJCOLL_CSLTDATA
					0 
					Uberspark_config.json_node_uberspark_config_var.binary_uobj_default_section_size
					Uberspark_config.json_node_uberspark_config_var.binary_uobj_section_alignment
					Uberspark_config.json_node_uberspark_config_var.binary_uobj_section_alignment;

		(* interuobjcoll callees slt code section *)
		l_add_section "uobj_interuobjcoll_csltcode" [ ".uobj_interuobjcoll_csltcode" ]
					Defs.Binformat.const_USBINFORMAT_SECTION_TYPE_UOBJ_INTERUOBJCOLL_CSLTCODE
					0 
					Uberspark_config.json_node_uberspark_config_var.binary_uobj_default_section_size
					Uberspark_config.json_node_uberspark_config_var.binary_uobj_section_alignment
					Uberspark_config.json_node_uberspark_config_var.binary_uobj_section_alignment;

		(* interuobjcoll callees slt data section *)
		l_add_section "uobj_interuobjcoll_csltdata" [ ".uobj_interuobjcoll_csltdata" ]
					Defs.Binformat.const_USBINFORMAT_SECTION_TYPE_UOBJ_INTERUOBJCOLL_CSLTDATA
					0 
					Uberspark_config.json_node_uberspark_config_var.binary_uobj_default_section_size
					Uberspark_config.json_node_uberspark_config_var.binary_uobj_section_alignment
					Uberspark_config.json_node_uberspark_config_var.binary_uobj_section_alignment;

		(* legacy callees slt code section *)
		l_add_section "uobj_legacy_csltcode" [ ".uobj_legacy_csltcode" ]
					Defs.Binformat.const_USBINFORMAT_SECTION_TYPE_UOBJ_LEGACY_CSLTCODE
					0 
					Uberspark_config.json_node_uberspark_config_var.binary_uobj_default_section_size
					Uberspark_config.json_node_uberspark_config_var.binary_uobj_section_alignment
					Uberspark_config.json_node_uberspark_config_var.binary_uobj_section_alignment;

		(* legacy callees slt data section *)
		l_add_section "uobj_legacy_csltdata" [ ".uobj_legacy_csltdata" ]
					Defs.Binformat.const_USBINFORMAT_SECTION_TYPE_UOBJ_LEGACY_CSLTDATA 
					0 
					Uberspark_config.json_node_uberspark_config_var.binary_uobj_default_section_size
					Uberspark_config.json_node_uberspark_config_var.binary_uobj_section_alignment
					Uberspark_config.json_node_uberspark_config_var.binary_uobj_section_alignment;

		(* uobj code, data, dmadata and stack sections follow *)
		l_add_section "uobj_code" [ ".text" ]
					Defs.Basedefs.def_USBINFORMAT_SECTION_TYPE_UOBJ_CODE 
					0 
					Uberspark_config.json_node_uberspark_config_var.binary_uobj_default_section_size
					Uberspark_config.json_node_uberspark_config_var.binary_uobj_section_alignment
					Uberspark_config.json_node_uberspark_config_var.binary_uobj_section_alignment;

		l_add_section "uobj_rodata" [".rodata"]
					Defs.Basedefs.def_USBINFORMAT_SECTION_TYPE_UOBJ_RODATA
					0 
					Uberspark_config.json_node_uberspark_config_var.binary_uobj_default_section_size
					Uberspark_config.json_node_uberspark_config_var.binary_uobj_section_alignment
					Uberspark_config.json_node_uberspark_config_var.binary_uobj_section_alignment;

		l_add_section "uobj_rwdata" [".data"; ".bss"]
					Defs.Basedefs.def_USBINFORMAT_SECTION_TYPE_UOBJ_RWDATA 
					0 
					Uberspark_config.json_node_uberspark_config_var.binary_uobj_default_section_size
					Uberspark_config.json_node_uberspark_config_var.binary_uobj_section_alignment
					Uberspark_config.json_node_uberspark_config_var.binary_uobj_section_alignment;

		l_add_section "uobj_dmadata" [".dmadata"]
					Defs.Basedefs.def_USBINFORMAT_SECTION_TYPE_UOBJ_DMADATA
					0 
					Uberspark_config.json_node_uberspark_config_var.binary_uobj_default_section_size
					Uberspark_config.json_node_uberspark_config_var.binary_uobj_section_alignment
					Uberspark_config.json_node_uberspark_config_var.binary_uobj_section_alignment;

		l_add_section "uobj_ustack" [ ".ustack" ]
					Defs.Basedefs.def_USBINFORMAT_SECTION_TYPE_UOBJ_USTACK 
					0 
					Uberspark_config.json_node_uberspark_config_var.binary_uobj_default_section_size
					Uberspark_config.json_node_uberspark_config_var.binary_uobj_section_alignment
					Uberspark_config.json_node_uberspark_config_var.binary_uobj_section_alignment;

		l_add_section "uobj_tstack" [ ".tstack"; ".stack" ]
					Defs.Basedefs.def_USBINFORMAT_SECTION_TYPE_UOBJ_TSTACK 
					0 
					Uberspark_config.json_node_uberspark_config_var.binary_uobj_default_section_size
					Uberspark_config.json_node_uberspark_config_var.binary_uobj_section_alignment
					Uberspark_config.json_node_uberspark_config_var.binary_uobj_section_alignment;

		()
	;



	(*--------------------------------------------------------------------------*)
	(* prepare for slt code generation *)
	(*--------------------------------------------------------------------------*)
	method prepare_slt_codegen 
		(callees_slt_codegen_info_list : Uberspark_codegen.Uobj.slt_codegen_info_t list ref)
		(callees_slt_indirect_xfer_table_assoc_list : (string * Defs.Basedefs.slt_indirect_xfer_table_info_t) list ref) 
		(callees_sentinel_type_hashtbl : (string, string list)  Hashtbl.t)
		(callees_sentinel_address_hashtbl : (string, Defs.Basedefs.uobjcoll_sentinel_address_t)  Hashtbl.t)
		(callees_hashtbl : (string, string list)  Hashtbl.t)
		: unit =

		let slt_indirect_xfer_table_offset = ref 0 in
		
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "prepare_slt_codegen: start";
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "length of callees_sentinel_type_hashtbl=%u" (Hashtbl.length callees_sentinel_type_hashtbl);

  		Hashtbl.iter (fun (ns: string) (pm_name_list: string list)  ->
	        List.iter (fun (public_method:string) -> 
				let ns_var = (Uberspark_namespace.get_variable_name_prefix_from_ns ns) in 
				let canonical_public_method = (ns_var ^ "__" ^ public_method) in
				let callees_sentinel_type_list = Hashtbl.find callees_sentinel_type_hashtbl canonical_public_method in
				List.iter ( fun (sentinel_type: string) ->
					let canonical_pm_name_with_sentinel_suffix = (canonical_public_method ^ "__" ^ sentinel_type) in  
					let pm_sentinel_addr = ref 0 in 
					let codegen_type = ref "" in 

					if sentinel_type = "call" then begin
						if (Hashtbl.mem callees_sentinel_address_hashtbl canonical_pm_name_with_sentinel_suffix) then begin
							pm_sentinel_addr := (Hashtbl.find callees_sentinel_address_hashtbl canonical_pm_name_with_sentinel_suffix).f_pm_addr;
							codegen_type := "direct";
						end else begin
							pm_sentinel_addr := 0;
							codegen_type := "indirect";
						end;
					end else begin
						if (Hashtbl.mem callees_sentinel_address_hashtbl canonical_pm_name_with_sentinel_suffix) then begin
							pm_sentinel_addr := (Hashtbl.find callees_sentinel_address_hashtbl canonical_pm_name_with_sentinel_suffix).f_sentinel_addr;
							codegen_type := "direct";
						end else begin
							pm_sentinel_addr := 0;
							codegen_type := "indirect";
						end;
					end;

					let slt_codegen_info : Uberspark_codegen.Uobj.slt_codegen_info_t = {
						f_canonical_public_method = canonical_pm_name_with_sentinel_suffix;
						f_pm_sentinel_addr = !pm_sentinel_addr;
						f_codegen_type = !codegen_type;
						f_pm_sentinel_addr_loc = 0;
					} in


					if !codegen_type = "indirect" then begin
						let slt_indirect_xfer_table_entry : Defs.Basedefs.slt_indirect_xfer_table_info_t = {
							f_canonical_public_method = canonical_public_method;
							sentinel_type = sentinel_type;
							f_table_offset = !slt_indirect_xfer_table_offset;
							fn_address = !pm_sentinel_addr;
						} in

						callees_slt_indirect_xfer_table_assoc_list := !callees_slt_indirect_xfer_table_assoc_list @
							[ (canonical_pm_name_with_sentinel_suffix, slt_indirect_xfer_table_entry) ];

						slt_codegen_info.f_pm_sentinel_addr_loc <- !slt_indirect_xfer_table_offset;

						slt_indirect_xfer_table_offset := !slt_indirect_xfer_table_offset + d_mf_json_node_uberspark_uobjslt_var.sizeof_addressing;
					end;

					callees_slt_codegen_info_list := !callees_slt_codegen_info_list @ [ slt_codegen_info ];

					Uberspark_logger.log ~lvl:Uberspark_logger.Debug "added entry: name=%s, addr=0x%08x" 
						slt_codegen_info.f_canonical_public_method slt_codegen_info.f_pm_sentinel_addr;

					(* if sentinel type is call, then add entry with just canonical_public_method in addition *)
					if sentinel_type = "call" then begin
						let slt_codegen_info : Uberspark_codegen.Uobj.slt_codegen_info_t = {
							f_canonical_public_method = canonical_public_method;
							f_pm_sentinel_addr = !pm_sentinel_addr;
							f_codegen_type = !codegen_type;
							f_pm_sentinel_addr_loc = 0;
						} in
	

						if !codegen_type = "indirect" then begin
							let slt_indirect_xfer_table_entry : Defs.Basedefs.slt_indirect_xfer_table_info_t = {
								f_canonical_public_method = canonical_public_method;
								sentinel_type = sentinel_type;
								f_table_offset = !slt_indirect_xfer_table_offset;
								fn_address = !pm_sentinel_addr;
							} in

							callees_slt_indirect_xfer_table_assoc_list := !callees_slt_indirect_xfer_table_assoc_list @
								[ (canonical_pm_name_with_sentinel_suffix, slt_indirect_xfer_table_entry) ];

							slt_codegen_info.f_pm_sentinel_addr_loc <- !slt_indirect_xfer_table_offset;

							slt_indirect_xfer_table_offset := !slt_indirect_xfer_table_offset + d_mf_json_node_uberspark_uobjslt_var.sizeof_addressing;
						end;

						callees_slt_codegen_info_list := !callees_slt_codegen_info_list @ [ slt_codegen_info ];

						Uberspark_logger.log ~lvl:Uberspark_logger.Debug "added entry: name=%s, addr=0x%08x" 
							slt_codegen_info.f_canonical_public_method slt_codegen_info.f_pm_sentinel_addr;
					end;

				) callees_sentinel_type_list;
				
			) pm_name_list;
		) callees_hashtbl;

		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "prepare_slt_codegen: end";

		()
	;



	(*--------------------------------------------------------------------------*)
	(* prepare uobj sources *)
	(*--------------------------------------------------------------------------*)
	method prepare_sources
		()
		: unit =

		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "uobjrtl namespace staging-dir-prefix=%s" (Uberspark_namespace.get_namespace_staging_dir_prefix ());
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "uobjrtl builddir prefix=%s" self#get_d_builddir;

		(* prepare uobjrtl c sources *)
		let l_uobjrtl_sources_c_files = ref [] in 
		List.iter ( fun ( (uobjrtl_namespace : string), (json_node_uberspark_uobj_uobjrtl_var : Uberspark_manifest.Uobj.json_node_uberspark_uobj_uobjrtl_t) ) -> 
				Uberspark_logger.log ~lvl:Uberspark_logger.Debug "uobjrtl namespace=%s" json_node_uberspark_uobj_uobjrtl_var.namespace;
				let uobjrtl_info = (Hashtbl.find self#get_d_uobjrtl_hashtbl uobjrtl_namespace) in
				List.iter ( fun ( (uobjrtl_modules_spec : Uberspark_manifest.Uobjrtl.json_node_uberspark_uobjrtl_modules_spec_t) ) -> 

					let l_namespace_module_path = (uobjrtl_namespace ^ "/" ^ uobjrtl_modules_spec.path) in
					let l_src_module_path = ((Uberspark_namespace.get_namespace_staging_dir_prefix ()) ^ "/" ^ l_namespace_module_path) in
					let l_dst_module_path =  (self#get_d_builddir ^ "/" ^ l_namespace_module_path) in 
					Uberspark_logger.log ~lvl:Uberspark_logger.Debug "  module path=%s" uobjrtl_modules_spec.path;
					Uberspark_osservices.mkdir ~parent:true (self#get_d_builddir ^ "/" ^ (Filename.dirname l_namespace_module_path)) (`Octal 0o0777);
					Uberspark_osservices.cp l_src_module_path l_dst_module_path;

					l_uobjrtl_sources_c_files :=  !l_uobjrtl_sources_c_files @ [ l_namespace_module_path ];

				) uobjrtl_info.source_c_files;
		) json_node_uberspark_uobj_var.uobjrtl;


		(* prepare uobjrtl casm sources *)
		let l_uobjrtl_sources_casm_files = ref [] in 
		List.iter ( fun ( (uobjrtl_namespace : string), (json_node_uberspark_uobj_uobjrtl_var : Uberspark_manifest.Uobj.json_node_uberspark_uobj_uobjrtl_t) ) -> 
				Uberspark_logger.log ~lvl:Uberspark_logger.Debug "uobjrtl namespace=%s" json_node_uberspark_uobj_uobjrtl_var.namespace;
				let uobjrtl_info = (Hashtbl.find self#get_d_uobjrtl_hashtbl uobjrtl_namespace) in
				List.iter ( fun ( (uobjrtl_modules_spec : Uberspark_manifest.Uobjrtl.json_node_uberspark_uobjrtl_modules_spec_t) ) -> 

					let l_namespace_module_path = (uobjrtl_namespace ^ "/" ^ uobjrtl_modules_spec.path) in
					let l_src_module_path = ((Uberspark_namespace.get_namespace_staging_dir_prefix ()) ^ "/" ^ l_namespace_module_path) in
					let l_dst_module_path =  (self#get_d_builddir ^ "/" ^ l_namespace_module_path) in 
					Uberspark_logger.log ~lvl:Uberspark_logger.Debug "  module path=%s" uobjrtl_modules_spec.path;
					Uberspark_osservices.mkdir ~parent:true (self#get_d_builddir ^ "/" ^ (Filename.dirname l_namespace_module_path)) (`Octal 0o0777);
					Uberspark_osservices.cp l_src_module_path l_dst_module_path;

					l_uobjrtl_sources_casm_files :=  !l_uobjrtl_sources_casm_files @ [ l_namespace_module_path ];

				) uobjrtl_info.source_casm_files;
		) json_node_uberspark_uobj_var.uobjrtl;




		(* copy uobj c files to namespace *)
		List.iter ( fun c_filename -> 
			Uberspark_osservices.mkdir ~parent:true (self#get_d_builddir ^ "/" ^ (Filename.dirname c_filename)) (`Octal 0o0777);
			Uberspark_osservices.cp (self#get_d_path_to_mf_filename ^ "/" ^ c_filename) (self#get_d_builddir ^ "/" ^ c_filename);
		) json_node_uberspark_uobj_var.sources.source_c_files;


		(* copy uobj casm files to namespace *)
		List.iter ( fun casm_filename -> 
			Uberspark_osservices.mkdir ~parent:true (self#get_d_builddir ^ "/" ^ (Filename.dirname casm_filename)) (`Octal 0o0777);
			Uberspark_osservices.cp (self#get_d_path_to_mf_filename ^ "/" ^ casm_filename) (self#get_d_builddir ^ "/" ^ casm_filename);
		) json_node_uberspark_uobj_var.sources.source_casm_files;


		(* copy uobj asm files to namespace *)
		List.iter ( fun asm_filename -> 
			Uberspark_osservices.mkdir ~parent:true (self#get_d_builddir ^ "/" ^ (Filename.dirname asm_filename)) (`Octal 0o0777);
			Uberspark_osservices.cp (self#get_d_path_to_mf_filename ^ "/" ^ asm_filename) (self#get_d_builddir ^ "/" ^ asm_filename);
		) json_node_uberspark_uobj_var.sources.source_asm_files;


		(* generate uobj top-level include header file source *)
		Uberspark_logger.log ~crlf:false "Generating uobj top-level include header source...";
		Uberspark_codegen.Uobj.generate_top_level_include_header 
			(self#get_d_builddir ^ "/" ^ Uberspark_namespace.namespace_uobj_top_level_include_header_src_filename)
			self#get_d_publicmethods_hashtbl;
		Uberspark_logger.log ~tag:"" "[OK]";


		(* prepare slt codegen for intrauobjcoll, interuobjcoll and legacy callees *)
		self#prepare_slt_codegen d_intrauobjcoll_callees_slt_codegen_info_list 
			d_intrauobjcoll_callees_slt_indirect_xfer_table_assoc_list
			d_slt_info.f_intrauobjcoll_callees_sentinel_type_hashtbl  
			d_slt_info.f_intrauobjcoll_callees_sentinel_address_hashtbl
			self#get_d_intrauobjcoll_callees_hashtbl;

		(* generate slt for intra-uobjcoll callees *)
		let rval = (Uberspark_codegen.Uobj.generate_slt 
			(self#get_d_builddir ^ "/" ^ Uberspark_namespace.namespace_uobjslt_intrauobjcoll_callees_src_filename)
			~output_banner:"uobj sentinel linkage table for intra-uobjcoll callees" 
			d_mf_json_node_uberspark_uobjslt_var.code_template_directxfer
			d_mf_json_node_uberspark_uobjslt_var.code_template_indirectxfer
			d_mf_json_node_uberspark_uobjslt_var.code_template_data_definition
			!d_intrauobjcoll_callees_slt_codegen_info_list
			".uobj_intrauobjcoll_csltcode"
			!d_intrauobjcoll_callees_slt_indirect_xfer_table_assoc_list
			".uobj_intrauobjcoll_csltdata") in	
		if (rval == false) then
			begin
				Uberspark_logger.log ~lvl:Uberspark_logger.Error "unable to generate slt for intrauobjcoll callees!";
				ignore (exit 1);
			end
		;

		(* generate slt for interuobjcoll callees *)
		let rval = (Uberspark_codegen.Uobj.generate_slt 
			(self#get_d_builddir ^ "/" ^ Uberspark_namespace.namespace_uobjslt_interuobjcoll_callees_src_filename) 
			~output_banner:"uobj sentinel linkage table for inter-uobjcoll callees" 
			d_mf_json_node_uberspark_uobjslt_var.code_template_directxfer
			d_mf_json_node_uberspark_uobjslt_var.code_template_indirectxfer
			d_mf_json_node_uberspark_uobjslt_var.code_template_data_definition
			!d_interuobjcoll_callees_slt_codegen_info_list
			".uobj_interuobjcoll_csltcode"
			!d_interuobjcoll_callees_slt_indirect_xfer_table_assoc_list
			".uobj_interuobjcoll_csltdata") in	
		if (rval == false) then
			begin
				Uberspark_logger.log ~lvl:Uberspark_logger.Error "unable to generate slt for inter-uobjcoll callees!";
				ignore (exit 1);
			end
		;


		(* generate slt for legacy callees *)
		let rval = (Uberspark_codegen.Uobj.generate_slt 
			(self#get_d_builddir ^ "/" ^ Uberspark_namespace.namespace_uobjslt_legacy_callees_src_filename) 
			~output_banner:"uobj sentinel linkage table for legacy callees" 
			d_mf_json_node_uberspark_uobjslt_var.code_template_directxfer
			d_mf_json_node_uberspark_uobjslt_var.code_template_indirectxfer
			d_mf_json_node_uberspark_uobjslt_var.code_template_data_definition
			!d_legacy_callees_slt_codegen_info_list
			".uobj_legacy_csltcode"
			!d_legacy_callees_slt_indirect_xfer_table_assoc_list
			".uobj_legacy_csltdata") in	
		if (rval == false) then
			begin
				Uberspark_logger.log ~lvl:Uberspark_logger.Error "unable to generate slt for legacy callees!";
				ignore (exit 1);
			end
		;

		(* generate uobj binary public methods info source *)
		Uberspark_logger.log ~crlf:false "Generating uobj binary public methods info source...";
		Uberspark_codegen.Uobj.generate_src_publicmethods_info 
			(self#get_d_builddir ^ "/" ^ Uberspark_namespace.namespace_uobj_publicmethods_info_src_filename)
			(json_node_uberspark_uobj_var).namespace d_publicmethods_hashtbl;
		Uberspark_logger.log ~tag:"" "[OK]";


		(* generate uobj binary intrauobjcoll callees info source *)
		Uberspark_logger.log ~crlf:false "Generating uobj binary intrauobjcoll callees info source...";
		Uberspark_codegen.Uobj.generate_src_intrauobjcoll_callees_info 
			(self#get_d_builddir ^ "/" ^ Uberspark_namespace.namespace_uobj_intrauobjcoll_callees_info_src_filename)
			d_intrauobjcoll_callees_hashtbl;
		Uberspark_logger.log ~tag:"" "[OK]";


		(* generate uobj binary interuobjcoll callees info source *)
		Uberspark_logger.log ~crlf:false "Generating uobj binary interuobjcoll callees info source...";
		Uberspark_codegen.Uobj.generate_src_interuobjcoll_callees_info 
			(self#get_d_builddir ^ "/" ^ Uberspark_namespace.namespace_uobj_interuobjcoll_callees_info_src_filename)
			d_interuobjcoll_callees_hashtbl;
		Uberspark_logger.log ~tag:"" "[OK]";


		(* generate uobj binary legacy callees info source *)
		Uberspark_logger.log ~crlf:false "Generating uobj binary legacy callees info source...";
		Uberspark_codegen.Uobj.generate_src_legacy_callees_info 
			(self#get_d_builddir ^ "/" ^ Uberspark_namespace.namespace_uobj_legacy_callees_info_src_filename)
			self#get_d_legacy_callees_hashtbl;
		Uberspark_logger.log ~tag:"" "[OK]";


		(* generate uobj binary header source *)
		Uberspark_logger.log ~crlf:false "Generating uobj binary header source...";
		Uberspark_codegen.Uobj.generate_src_binhdr 
			(self#get_d_builddir ^ "/" ^ Uberspark_namespace.namespace_uobj_binhdr_src_filename)
			(json_node_uberspark_uobj_var).namespace self#get_d_load_addr self#get_d_size 
			self#get_d_memorymapped_sections_list_val;
		Uberspark_logger.log ~tag:"" "[OK]";


		(* generate uobj binary linker script *)
		Uberspark_logger.log ~crlf:false "Generating uobj binary linker script...";
		Uberspark_codegen.Uobj.generate_linker_script 
			(self#get_d_builddir ^ "/" ^ Uberspark_namespace.namespace_uobj_linkerscript_filename)
			self#get_d_load_addr self#get_d_size self#get_d_memorymapped_sections_list_val;
		Uberspark_logger.log ~tag:"" "[OK]";


		(* add uobjrtl c source files to the list of c sources *)
		json_node_uberspark_uobj_var.sources.source_c_files <- !l_uobjrtl_sources_c_files @ 
			json_node_uberspark_uobj_var.sources.source_c_files;

		(* add uobjrtl casm source files to the list of casm sources *)
		json_node_uberspark_uobj_var.sources.source_casm_files <- !l_uobjrtl_sources_casm_files @ 
			json_node_uberspark_uobj_var.sources.source_casm_files;

		(* add all the autogenerated C source files to the list of c sources *)
		(* TBD: this might not be needed *)
		(*json_node_uberspark_uobj_var.sources.source_c_files <-  [ 
			Uberspark_namespace.namespace_uobj_publicmethods_info_src_filename;		
			Uberspark_namespace.namespace_uobj_intrauobjcoll_callees_info_src_filename;
			Uberspark_namespace.namespace_uobj_interuobjcoll_callees_info_src_filename;
			Uberspark_namespace.namespace_uobj_legacy_callees_info_src_filename;
			Uberspark_namespace.namespace_uobj_binhdr_src_filename;
		] @ json_node_uberspark_uobj_var.sources.source_c_files;*)


		(* add all the casm, generated asm source files to the list of asm sources *)
		List.iter ( fun casm_filename -> 
			json_node_uberspark_uobj_var.sources.source_asm_files <- [ 
			(casm_filename ^ ".s")
			] @ json_node_uberspark_uobj_var.sources.source_asm_files;
		) json_node_uberspark_uobj_var.sources.source_casm_files;


		(* add all the autogenerated asm source files to the list of asm sources *)
		(* TBD: eventually this will just be casm sources *)
		json_node_uberspark_uobj_var.sources.source_asm_files <- [ 
			Uberspark_namespace.namespace_uobjslt_intrauobjcoll_callees_src_filename;
			Uberspark_namespace.namespace_uobjslt_interuobjcoll_callees_src_filename;
			Uberspark_namespace.namespace_uobjslt_legacy_callees_src_filename;
		] @ json_node_uberspark_uobj_var.sources.source_asm_files;

		()
	;




	(*--------------------------------------------------------------------------*)
	(* initialize *)
	(*--------------------------------------------------------------------------*)
	method initialize	
		?(builddir = ".")
		(uobj_mf_filename : string)
		(target_def: Defs.Basedefs.target_def_t)
		(uobj_load_address : int)
		: bool = 
	
		(* store uobj manifest filename *)
		self#set_d_mf_filename (Filename.basename uobj_mf_filename);

		(* set target definition *)
		self#set_d_target_def target_def;	

		(* set load address *)
		self#set_d_load_addr uobj_load_address;

		(* store absolute uobj path *)		
		let (rval, abs_uobj_path) = (Uberspark_osservices.abspath (Filename.dirname uobj_mf_filename)) in
		if(rval == false) then (false) (* could not obtain absolute path for uobj *)
		else
	
		let dummy = 0 in begin
		self#set_d_path_to_mf_filename abs_uobj_path;

		(* set build directory *)
		self#set_d_builddir (abs_uobj_path ^ "/" ^ builddir);

		(* debug dump the target spec and definition *)		
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "uobj target spec => %s:%s:%s" 
				(json_node_uberspark_uobj_var).platform (json_node_uberspark_uobj_var).arch (json_node_uberspark_uobj_var).cpu;
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "uobj target definition => %s:%s:%s" 
				(self#get_d_target_def).platform (self#get_d_target_def).arch (self#get_d_target_def).cpu;
		end;


		(* parse manifest *)
		let rval = (self#parse_manifest ()) in	
		if (rval == false) then	begin
			Uberspark_logger.log ~lvl:Uberspark_logger.Error "unable to stat/parse manifest for uobj!";
			(rval)
		end else

		let dummy = 0 in begin
		Uberspark_logger.log "successfully parsed uobj manifest";
		end;

		(* parse uobj slt manifest *)
		let rval = (self#parse_manifest_slt) in	
		if (rval == false) then	begin
				Uberspark_logger.log ~lvl:Uberspark_logger.Error "unable to stat/parse uobj slt manifest!";
				(rval)
		end else

		(* parse uobj uobjrtl manifests *)
		let rval = (self#parse_uobjrtl_manifests ()) in	
		if (rval == false) then	begin
				Uberspark_logger.log ~lvl:Uberspark_logger.Error "unable to stat/parse uobjrtl manifests!";
				(rval)
		end else


		let dummy=0 in begin
		(* add default uobj sections *)
		self#add_default_uobj_binary_sections ();

		(* consolidate uboj section memory map *)
		Uberspark_logger.log "Consolidating uobj section memory map...";
		self#consolidate_sections_with_memory_map ();
		Uberspark_logger.log "uobj section memory map initialized";

		(* create _build folder *)
		Uberspark_osservices.mkdir ~parent:true (self#get_d_builddir) (`Octal 0o0777);
		end;

		(true)	
	;


	(*--------------------------------------------------------------------------*)
	(* compile c files *)
	(*--------------------------------------------------------------------------*)
	method compile_c_files	
		()
		: bool = 
		
		let retval = ref false in

		(*retval := Uberspark_bridge.Cc.invoke ~gen_obj:true
			 ~context_path_builddir:Uberspark_namespace.namespace_uobj_build_dir 
			 (json_node_uberspark_uobj_var.sources.source_c_files) [ "."; (Uberspark_namespace.get_namespace_staging_dir_prefix ()) ] ".";
		*)

		retval := Uberspark_bridge.Cc.invoke 
			 ~context_path_builddir:Uberspark_namespace.namespace_uobj_build_dir 
			 (json_node_uberspark_uobj_var.sources.source_c_files) [ "."; (Uberspark_namespace.get_namespace_staging_dir_prefix ()) ] ".";
		

		(!retval)	
	;


	(*--------------------------------------------------------------------------*)
	(* compile casm files *)
	(*--------------------------------------------------------------------------*)
	method compile_casm_files	
		()
		: bool = 
		
		let retval = ref false in

		retval := Uberspark_bridge.Casm.invoke ~gen_obj:true
			 ~context_path_builddir:Uberspark_namespace.namespace_uobj_build_dir 
			 (json_node_uberspark_uobj_var.sources.source_casm_files) [ "."; (Uberspark_namespace.get_namespace_staging_dir_prefix ()) ] ".";

		(!retval)	
	;



	(*--------------------------------------------------------------------------*)
	(* compile asm files *)
	(*--------------------------------------------------------------------------*)
	method compile_asm_files	
		()
		: bool = 
		
		let retval = ref false in

		retval := Uberspark_bridge.As.invoke ~gen_obj:true
			 ~context_path_builddir:Uberspark_namespace.namespace_uobj_build_dir 
			 (json_node_uberspark_uobj_var.sources.source_asm_files) [ "."; (Uberspark_namespace.get_namespace_staging_dir_prefix ()) ] ".";

		(!retval)	
	;



	(*--------------------------------------------------------------------------*)
	(* link uobj object files into binary image *)
	(*--------------------------------------------------------------------------*)
	method link_object_files	
		()
		: bool = 
		
		let retval = ref false in
		let o_file_list =ref [] in

		(* add object files generated from c sources *)
		List.iter (fun fname ->
			o_file_list := !o_file_list @ [ fname ^ ".o"];
		) json_node_uberspark_uobj_var.sources.source_c_files;

		(* add object files generated from asm sources *)
		List.iter (fun fname ->
			o_file_list := !o_file_list @ [ fname ^ ".o"];
		) json_node_uberspark_uobj_var.sources.source_asm_files;


		retval := Uberspark_bridge.Ld.invoke 
			 ~context_path_builddir:Uberspark_namespace.namespace_uobj_build_dir 
			Uberspark_namespace.namespace_uobj_linkerscript_filename
			Uberspark_namespace.namespace_uobj_binary_image_filename
			Uberspark_namespace.namespace_uobj_binary_flat_image_filename
			("." ^ "/" ^ Uberspark_namespace.namespace_uobj_cclib_filename)
			!o_file_list
			".";

		(!retval)	
	;



	method install_create_ns 
		()
		: unit =
		
		let uobj_path_ns = self#get_d_path_ns in
		
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "d_path_ns=%s" uobj_path_ns;
		
		(* make namespace folder if not already existing *)
		Uberspark_osservices.mkdir ~parent:true uobj_path_ns (`Octal 0o0777);

		(* make namespace include folder if not already existing *)
		Uberspark_osservices.mkdir ~parent:true (uobj_path_ns ^ "/include") (`Octal 0o0777);

	;


	method install_h_files_ns 
		?(context_path_builddir = ".")
		: unit =
		
		let uobj_path_to_mf_filename = self#get_d_path_to_mf_filename in
		let uobj_path_ns = self#get_d_path_ns in
		
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "d_path_to_mf_filename=%s" uobj_path_to_mf_filename;
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "d_path_ns=%s" uobj_path_ns;
		


		(* copy h files to namespace *)
		List.iter ( fun h_filename -> 
			Uberspark_osservices.mkdir ~parent:true (uobj_path_ns ^ "/" ^ (Filename.dirname h_filename)) (`Octal 0o0777);
			Uberspark_osservices.cp (uobj_path_to_mf_filename ^ "/" ^ h_filename) (uobj_path_ns ^ "/" ^ h_filename);
		) json_node_uberspark_uobj_var.sources.source_h_files;

		(* copy top-level header to namespace *)
		Uberspark_osservices.file_copy (uobj_path_to_mf_filename ^ "/" ^ context_path_builddir ^ "/" ^ Uberspark_namespace.namespace_uobj_top_level_include_header_src_filename)
			(uobj_path_ns ^ "/include/" ^ Uberspark_namespace.namespace_uobj_top_level_include_header_src_filename);

	;


	method remove_ns 
		()
		: unit =
		
		let uobj_path_ns = self#get_d_path_ns in
		
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "d_path_ns=%s" uobj_path_ns;
		
		(* remove the path and files within *)
		Uberspark_osservices.rmdir_recurse [ uobj_path_ns ];
	;


	(* assumes initialize method has been called *)
	method prepare_namespace_for_build
		()
		: bool =

		let retval = ref false in
		let in_namespace_build = ref false in

		(* check to see if we are doing an in-namespace build or an out-of-namespace build *)
		let dummy = 0 in begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "namespace root=%s" ((Uberspark_namespace.get_namespace_staging_dir_prefix ()) ^ "/" ^ Uberspark_namespace.namespace_root ^ "/");
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "abs_uobj_path_ns=%s" (self#get_d_path_to_mf_filename);
		
		in_namespace_build := (Uberspark_namespace.is_uobj_uobjcoll_abspath_in_namespace self#get_d_path_to_mf_filename);
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "in_namespace_build=%B" !in_namespace_build;

		(* install headers if we are doing an out-of-namespace build *)
		if not !in_namespace_build then begin
			Uberspark_logger.log "prepping for out-of-namespace build...";
			self#install_create_ns ();
			self#install_h_files_ns ~context_path_builddir:Uberspark_namespace.namespace_uobj_build_dir;
			Uberspark_logger.log "ready for out-of-namespace build";
		end;

		retval := true;
		end;


		(!retval)
	;



	(* build the uobj binary image *)
	method build_image
		()
		: bool =

		let retval = ref false in

		(* switch working directory to uobj_path build folder *)
		let (rval, r_prevpath, r_curpath) = (Uberspark_osservices.dir_change (self#get_d_builddir)) in
		if(rval == false) then begin
			Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not switch to uobj path: %s" self#get_d_builddir;
			(!retval)
		end else

		(* initialize bridges *)
		(*if not (Uberspark_bridge.initialize_from_config ()) then begin
			Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not initialize bridges!";
			(!retval)
		end else
		*)

		let dummy =0 in begin
	    (*Uberspark_logger.log "initialized bridges";*)
	   	Uberspark_logger.log "proceeding to compile c files...";
		end;

		if not (self#compile_c_files ()) then begin
			Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not compile one or more uobj c files!";
			(!retval)
		end else

		let dummy = 0 in begin
		Uberspark_logger.log "compiled c files successfully!";
		Uberspark_logger.log "proceeding to compile casm files...";
		end;

		if not (self#compile_casm_files ()) then begin
			Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not compile one or more uobj casm files!";
			(!retval)
		end else

		let dummy = 0 in begin
		Uberspark_logger.log "compiled casm files successfully!";
		Uberspark_logger.log "proceeding to compile asm files...";
		end;



		if not (self#compile_asm_files ()) then begin
			Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not compile one or more uobj asm files!";
			(!retval)
		end else

		let dummy = 0 in begin
		Uberspark_logger.log "compiled asm files successfully!";
		Uberspark_logger.log "proceeding to link object files...";
		end;

		if not (self#link_object_files ()) then begin
			Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not link uobj object files!";
			(!retval)
		end else


		let dummy = 0 in begin
		Uberspark_logger.log "linked object files successfully!";

		(* restore working directory *)
		ignore(Uberspark_osservices.dir_change r_prevpath);

		Uberspark_logger.log "cleaned up build";
		retval := true;
		end;

		(!retval)
	;
	

	(* verify the uobj *)
	method verify
		()
		: bool =

		let retval = ref false in

		(* switch working directory to uobj_path build folder *)
		let (rval, r_prevpath, r_curpath) = (Uberspark_osservices.dir_change (self#get_d_builddir)) in
		if(rval == false) then begin
			Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not switch to uobj path: %s" self#get_d_builddir;
			(!retval)
		end else

		let dummy =0 in begin
	   	Uberspark_logger.log "proceeding to verify...";
		end;

		let rval = Uberspark_bridge.Vf.invoke 
			 ~context_path_builddir:Uberspark_namespace.namespace_uobj_build_dir 
			 (json_node_uberspark_uobj_var.sources.source_c_files)  
			 [ "."; (Uberspark_namespace.get_namespace_staging_dir_prefix ()) ]
			 "." in

		if (rval == false ) then begin
			Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not verify one or more uobj sources!";
			(false)
		end else

		let dummy = 0 in begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "verification successful!";

		(* restore working directory *)
		ignore(Uberspark_osservices.dir_change r_prevpath);

		Uberspark_logger.log "cleaned up verification";
		end;

		(true)
	;

end;;


(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* stand-alone interfaces that are invoked for one-short create, initialize *)
(* and perform specific operation (compile, verify, build) *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)


(* create and initialize a uobj and return uobj object if successful *)
let create_initialize
	(uobj_mf_filename : string)
	(uobj_target_def : Defs.Basedefs.target_def_t)
	(uobj_load_address : int)
	: bool * uobject option =

	(* create uobj instance and initialize *)
	let uobj:uobject = new uobject in
	let rval = (uobj#initialize ~builddir:Uberspark_namespace.namespace_uobj_build_dir 
		uobj_mf_filename uobj_target_def uobj_load_address) in	
    if (rval == false) then	begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "unable to initialize uobj!";
		(false, None)
	end else

	(* prepare uobj sources *)
	let dummy = 0 in begin
	Uberspark_logger.log "initialized uobj";
	uobj#prepare_sources ();
	Uberspark_logger.log "prepped uobj sources";
	end;

	(* prepare uobj namespace *)
	let rval = (uobj#prepare_namespace_for_build ()) in	
    if (rval == false) then	begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "unable to prepare uobj namespace!";
		(false, None)
	end else

	let dummy = 0 in begin
	Uberspark_logger.log "prepped uobj namespace";
	end;

	(* initialize bridges *)
	let l_rval = ref true in 
	let dummy = 0 in begin

	(* if uobj manifest specified config-settings node, re-initialize bridges to be sure 
	 we get uobj specific bridges if specified *)
	if (uobj#overlay_config_settings ()) then begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "initializing bridges with uobj manifest override...";
		if not (Uberspark_bridge.initialize_from_config ()) then begin
			l_rval := false;
		end;
	end else begin
		(* uobj manifest did not have any config-settings specified *)
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "initializing bridges with default config settings...";
		if not (Uberspark_bridge.initialize_from_config ()) then begin
			l_rval := false;
		end;
	end;
	end;

    if (!l_rval == false) then	begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not initialize bridges!";
		(false, None)
	end else

	(true, Some uobj)
;;


let create_initialize_and_build
	(uobj_mf_filename : string)
	(uobj_target_def : Defs.Basedefs.target_def_t)
	(uobj_load_address : int)
	: bool * uobject option =

	(* create uobj instance and initialize *)
    let (rval, uobjopt) = (create_initialize 
		uobj_mf_filename uobj_target_def uobj_load_address) in
    if (rval == false) then begin
		(false, None)
	end else

	match uobjopt with 
	| None ->
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "invalid uobj instance!";
		(false, None)

	| Some uobj ->

	(* build uobj binary image *)
	let rval = (uobj#build_image ()) in	
    if (rval == false) then	begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "unable to build uobj binary image!";
		(false, None)
	end else

	let dummy = 0 in begin
	Uberspark_logger.log "generated uobj binary image";
	end;

	(true, Some uobj)
;;


let create_initialize_and_verify
	(uobj_mf_filename : string)
	(uobj_target_def : Defs.Basedefs.target_def_t)
	(uobj_load_address : int)
	: bool * uobject option =

	(* create uobj instance and initialize *)
    let (rval, uobjopt) = (create_initialize 
		uobj_mf_filename uobj_target_def uobj_load_address) in
    if (rval == false) then begin
		(false, None)
	end else

	match uobjopt with 
	| None ->
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "invalid uobj instance!";
		(false, None)

	| Some uobj ->

	(* verify uobj binary image *)
	let rval = (uobj#verify ()) in	
    if (rval == false) then	begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "unable to verify uobj!";
		(false, None)
	end else

	let dummy = 0 in begin
	Uberspark_logger.log "uobj verification successful.";
	end;

	(true, Some uobj)
;;




(*--------------------------------------------------------------------------*)
(* FOR FUTURE EXPANSION *)
(*--------------------------------------------------------------------------*)

(*

	(* get uobj manifest json nodes *)
	let rval = (Uberspark_manifest.Uobj.get_uobj_mf_json_nodes mf_json d_uobj_mf_json_nodes) in

	if (rval == false) then (false)
	else

	(* debug *)
	(*let dummy = 0 in begin
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "mf_json=%s" (Uberspark_manifest.json_node_pretty_print_to_string mf_json);
	let (rval, new_json) = Uberspark_manifest.json_node_update "namespace" (Yojson.Basic.from_string "\"uberspark/uobjs/wohoo\"") (Yojson.Basic.Util.member "uobj-hdr" mf_json) in
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "mf_json=%s" (Uberspark_manifest.json_node_pretty_print_to_string new_json);
	d_uobj_mf_json_nodes.f_uobj_hdr <- new_json;
	self#write_manifest "auto_test.json";		
	end;*)



	val d_uobj_mf_json_nodes : Uberspark_manifest.Uobj.uobj_mf_json_nodes_t = {
		f_uberspark_hdr = `Null;
		f_uobj_hdr = `Null;
		f_uobj_sources = `Null;
		f_uobj_public_methods = `Null;
		f_uobj_intrauobjcoll_callees = `Null;
		f_uobj_interuobjcoll_callees = `Null;
		f_uobj_legacy_callees = `Null;
		f_uobj_binary = `Null;
	};


	(*--------------------------------------------------------------------------*)
	(* write uobj manifest *)
	(* uobj_mf_filename = uobj manifest filename *)
	(*--------------------------------------------------------------------------*)
	method write_manifest 
		(uobj_mf_filename : string)
		: bool =

		let oc = open_out uobj_mf_filename in
		Uberspark_manifest.Uobj.write_uobj_mf_json_nodes d_uobj_mf_json_nodes oc;
		close_out oc;	

		(true)
	;
*)