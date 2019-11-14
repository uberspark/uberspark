(*------------------------------------------------------------------------------
	uberSpark uberobject verification and build interface
	author: amit vasudevan (amitvasudevan@acm.org)
------------------------------------------------------------------------------*)

open Str

		

class uobject 
	= object(self)

	(*val log_tag = "Usuobj";*)
	val d_ltag = "Usuobj";

	val d_mf_filename = ref "";
	method get_d_mf_filename = !d_mf_filename;

	val d_path_to_mf_filename = ref "";
	method get_d_path_to_mf_filename = !d_path_to_mf_filename;

	val d_path_ns = ref "";
	method get_d_path_ns = !d_path_ns;

	val d_hdr: Uberspark_manifest.Uobj.uobj_hdr_t = {f_namespace = ""; f_platform = ""; f_arch = ""; f_cpu = ""};
	method get_d_hdr = d_hdr;


	val d_sources_h_file_list: string list ref = ref [];
	method get_d_sources_h_file_list = !d_sources_h_file_list;

	val d_sources_c_file_list: string list ref = ref [];
	method get_d_sources_c_file_list = !d_sources_c_file_list;

	val d_sources_casm_file_list: string list ref = ref [];
	method get_d_sources_casm_file_list = !d_sources_casm_file_list;

	val d_sources_asm_file_list: string list ref = ref [];
	method get_d_sources_asm_file_list = !d_sources_asm_file_list;

	val d_publicmethods_hashtbl = ((Hashtbl.create 32) : ((string, Uberspark_manifest.Uobj.uobj_publicmethods_t)  Hashtbl.t)); 
	method get_d_publicmethods_hashtbl = d_publicmethods_hashtbl;

	val d_intrauobjcoll_callees_hashtbl = ((Hashtbl.create 32) : ((string, string list)  Hashtbl.t)); 
	method get_d_intrauobjcoll_callees_hashtbl = d_intrauobjcoll_callees_hashtbl;

	val d_interuobjcoll_callees_hashtbl = ((Hashtbl.create 32) : ((string, string list)  Hashtbl.t)); 
	method get_d_interuobjcoll_callees_hashtbl = d_interuobjcoll_callees_hashtbl;

	val d_legacy_callees_list : string list ref = ref [];
	method get_d_legacy_callees_list = !d_legacy_callees_list;

	(* association list of uobj binary image sections as parsed from uobj manifest; indexed by section name *)		
	val d_sections_list : (string * Defs.Basedefs.section_info_t) list ref = ref []; 
	method get_d_sections_list_ref = d_sections_list;
	method get_d_sections_list_val = !d_sections_list;

	(* hashtbl of uobj sections as parsed from uobj manifest; indexed by section name *)		
	val d_sections_hashtbl = ((Hashtbl.create 32) : ((string, Defs.Basedefs.section_info_t)  Hashtbl.t)); 
	method get_d_sections_hashtbl = d_sections_hashtbl;

	(* hashtbl of uobj sections with memory map info; indexed by section name *)
	val d_sections_memory_map_hashtbl = ((Hashtbl.create 32) : ((string, Defs.Basedefs.section_info_t)  Hashtbl.t)); 
	method get_d_sections_memory_map_hashtbl = (d_sections_memory_map_hashtbl);

	(* hashtbl of uobj sections with memory map info; indexed by section virtual address*)
	val d_sections_memory_map_hashtbl_byorigin = ((Hashtbl.create 32) : ((int, Defs.Basedefs.section_info_t)  Hashtbl.t)); 
	method get_d_sections_memory_map_hashtbl_byorigin = (d_sections_memory_map_hashtbl_byorigin);


	val d_target_def: Defs.Basedefs.target_def_t = {
		f_platform = ""; 
		f_arch = ""; 
		f_cpu = "";
	};
	method get_d_target_def = d_target_def;
	method set_d_target_def 
		(target_def: Defs.Basedefs.target_def_t) = 
		d_target_def.f_platform <- target_def.f_platform;
		d_target_def.f_arch <- target_def.f_arch;
		d_target_def.f_cpu <- target_def.f_cpu;
		()
	;
		
	val d_slt_trampolinecode : string ref = ref "";
	method get_d_slt_trampolinecode = !d_slt_trampolinecode;
	method set_d_slt_trampolinecode (trampolinecode : string)= 
		d_slt_trampolinecode := trampolinecode;
		()
	;

	val d_slt_trampolinedata : string ref = ref "";
	method get_d_slt_trampolinedata = !d_slt_trampolinedata;
	method set_d_slt_trampolinedata (trampolinedata : string)= 
		d_slt_trampolinedata := trampolinedata;
		()
	;

	(* uobj binary image load address *)
	val d_load_addr = ref Uberspark_config.config_settings.uobj_binary_image_load_address;
	method get_d_load_addr = !d_load_addr;
	method set_d_load_addr load_addr = (d_load_addr := load_addr);
	
	(* uobj binary image size; will be overwritten with actual size using alignment if uniform_size=false  *)
	val d_size = ref Uberspark_config.config_settings.uobj_binary_image_size; 
	method get_d_size = !d_size;
	method set_d_size size = (d_size := size);

	(* uobj binary image uniform size flag *)
	val d_uniform_size = ref Uberspark_config.config_settings.uobj_binary_image_uniform_size; 
	method get_d_uniform_size = !d_uniform_size;
	method set_d_uniform_size uniform_size = (d_uniform_size := uniform_size);

	(* uobj binary image alignment *)
	val d_alignment = ref Uberspark_config.config_settings.uobj_binary_image_alignment; 
	method get_d_alignment = !d_alignment;
	method set_d_alignment alignment = (d_alignment := alignment);

	(* uobj context path build folder *)
	val d_context_path_builddir = ref ".";
	method get_d_context_path_builddir = !d_context_path_builddir;
	method set_d_context_path_builddir context_path = (d_context_path_builddir := context_path);



	(*--------------------------------------------------------------------------*)
	(* parse uobj manifest *)
	(* usmf_filename = canonical uobj manifest filename *)
	(* keep_temp_files = true if temporary files need to be preserved *)
	(*--------------------------------------------------------------------------*)
	method parse_manifest 
		(uobj_mf_filename : string)
		(keep_temp_files : bool) 
		: bool =
		
		(* store filename and uobj path to filename *)
		d_mf_filename := Filename.basename uobj_mf_filename;
		d_path_to_mf_filename := Filename.dirname uobj_mf_filename;
		
		(* read manifest JSON *)
		let (rval, mf_json) = Uberspark_manifest.get_manifest_json self#get_d_mf_filename in
		
		if (rval == false) then (false)
		else

		(* parse uobj-hdr node *)
		let rval = (Uberspark_manifest.Uobj.parse_uobj_hdr mf_json d_hdr ) in
		if (rval == false) then (false)
		else

		let dummy=0 in begin
			d_path_ns := !Uberspark_config.namespace_root_dir  ^ "/" ^ d_hdr.f_namespace;
		end;

		(* parse uobj-sources node *)
		let rval = (Uberspark_manifest.Uobj.parse_uobj_sources mf_json
				d_sources_h_file_list d_sources_c_file_list d_sources_casm_file_list d_sources_asm_file_list) in

		if (rval == false) then (false)
		else
		let dummy = 0 in
			begin
				Uberspark_logger.log "total sources: h files=%u, c files=%u, casm files=%u, asm files=%u" 
					(List.length self#get_d_sources_h_file_list)
					(List.length self#get_d_sources_c_file_list)
					(List.length self#get_d_sources_casm_file_list)
					(List.length self#get_d_sources_asm_file_list);
			end;


		(* parse uobj-publicmethods node *)
		let rval = (Uberspark_manifest.Uobj.parse_uobj_publicmethods mf_json d_publicmethods_hashtbl) in

		if (rval == false) then (false)
		else
		let dummy = 0 in
			begin
				Uberspark_logger.log "total public methods:%u" (Hashtbl.length self#get_d_publicmethods_hashtbl); 
			end;

		(* parse uobj-intrauobjcoll-callees node *)
		let rval = (Uberspark_manifest.Uobj.parse_uobj_intrauobjcoll_callees mf_json d_intrauobjcoll_callees_hashtbl) in

		if (rval == false) then (false)
		else
		let dummy = 0 in
			begin
				Uberspark_logger.log "list of uobj-intrauobjcoll-callees follows:";

				Hashtbl.iter (fun key value  ->
					Uberspark_logger.log "uobj=%s; callees=%u" key (List.length value);
				) self#get_d_intrauobjcoll_callees_hashtbl;
			end;

		(* parse uobj-interuobjcoll-callees node *)
		let rval = (Uberspark_manifest.Uobj.parse_uobj_interuobjcoll_callees mf_json d_interuobjcoll_callees_hashtbl) in

		if (rval == false) then (false)
		else
		let dummy = 0 in
			begin
				Uberspark_logger.log "total interuobjcoll callees=%u" (Hashtbl.length self#get_d_interuobjcoll_callees_hashtbl);
			end;

		(* parse uobj-legacy-callees node *)
		let rval = (Uberspark_manifest.Uobj.parse_uobj_legacy_callees mf_json d_legacy_callees_list) in

		if (rval == false) then (false)
		else
		let dummy = 0 in
			begin
				Uberspark_logger.log "total legacy callees=%u" (List.length self#get_d_legacy_callees_list);
			end;


		(* parse uobj-binary/uobj-sections node *)
		let rval = (Uberspark_manifest.Uobj.parse_uobj_sections mf_json self#get_d_sections_list_ref) in

		if (rval == false) then (false)
		else
		let dummy = 0 in
		if (rval == true) then
			begin
				Uberspark_logger.log "binary sections override:%u" (List.length self#get_d_sections_list_val);								
			end;

		(true)
	;




		



	(*--------------------------------------------------------------------------*)
	(* parse sentinel linkage manifest *)
	(*--------------------------------------------------------------------------*)
	method parse_manifest_slt	
		(*(fn_list: string list)*)
			= 
			let retval = ref false in 	
			let target_def = 	self#get_d_target_def in	
			let uobjslt_filename = (!Uberspark_config.namespace_root_dir ^ "/" ^ Uberspark_config.namespace_root ^ "/" ^ Uberspark_config.namespace_uobjslt ^ "/" ^
				target_def.f_arch ^ "/" ^ target_def.f_cpu ^ "/" ^
				Uberspark_config.namespace_uobjslt_mf_filename) in 

			let (rval, abs_uobjslt_filename) = (Uberspark_osservices.abspath uobjslt_filename) in
			if(rval == true) then
			begin
				(*Uberspark_logger.log ~lvl:Uberspark_logger.Debug "fn_list length=%u" (List.length fn_list);*)
				Uberspark_logger.log "reading slt manifest from:%s" abs_uobjslt_filename;

				(* read manifest JSON *)
				let (rval, mf_json) = (Uberspark_manifest.get_manifest_json abs_uobjslt_filename) in
				if(rval == true) then
				begin

					(* parse uobjslt-hdr node *)
					let uobjslt_hdr: Uberspark_manifest.Uobjslt.uobjslt_hdr_t = {f_namespace = ""; f_platform = ""; f_arch = ""; f_cpu = ""} in
					let rval =	(Uberspark_manifest.Uobjslt.parse_uobjslt_hdr mf_json uobjslt_hdr) in
					if rval then
					begin

						(* read trampoline code and data *)
						let (rval_tcode, tcode) =	(Uberspark_manifest.Uobjslt.parse_uobjslt_trampolinecode mf_json) in
						let (rval_tdata, tdata) =	(Uberspark_manifest.Uobjslt.parse_uobjslt_trampolinedata mf_json) in

						if  rval_tcode && rval_tdata then
							begin
								self#set_d_slt_trampolinecode tcode;
								self#set_d_slt_trampolinedata tdata;
								retval := true;
								(*Uberspark_logger.log "code=%s" (uobjslt_trampolinecode_json |> to_string);								
								Uberspark_logger.log "data=%s" (uobjslt_trampolinedata_json |> to_string);*)								
							end;

					end;
				end;
			end;



	(!retval)
	;




	(*--------------------------------------------------------------------------*)
	(* consolidate sections with memory map *)
	(* uobj_load_addr = load address of uobj *)
	(*--------------------------------------------------------------------------*)
	method consolidate_sections_with_memory_map
		()
		: unit  
		=

		let uobj_section_load_addr = ref 0 in
		let uobjsize = self#get_d_size in
		let uobj_load_addr = self#get_d_load_addr in
		(*self#set_d_load_addr uobj_load_addr;*)
		uobj_section_load_addr := self#get_d_load_addr;

		(* iterate over all the sections *)
		Hashtbl.iter (fun key (x:Defs.Basedefs.section_info_t)  ->
			(* compute and round up section size to section alignment *)
			let remainder_size = (x.usbinformat.f_size mod Uberspark_config.config_settings.binary_uobj_section_alignment) in
			let padding_size = ref 0 in
				if remainder_size > 0 then
					begin
						padding_size := Uberspark_config.config_settings.binary_uobj_section_alignment - remainder_size;
					end
				else
					begin
						padding_size := 0;
					end
				;
			let section_size = (x.usbinformat.f_size + !padding_size) in 


			Hashtbl.add d_sections_memory_map_hashtbl key 
				{ f_name = x.f_name;	
					f_subsection_list = x.f_subsection_list;	
					usbinformat = { f_type=x.usbinformat.f_type; 
													f_prot=0; 
													f_size = section_size;
													f_aligned_at = Uberspark_config.config_settings.binary_uobj_section_alignment; 
													f_pad_to = Uberspark_config.config_settings.binary_uobj_section_alignment; 
													f_addr_start = !uobj_section_load_addr; 
													f_addr_file = 0;
													f_reserved = 0;
												};
				};
			Hashtbl.add d_sections_memory_map_hashtbl_byorigin !uobj_section_load_addr 
				{ f_name = x.f_name;	
					f_subsection_list = x.f_subsection_list;	
					usbinformat = { f_type=x.usbinformat.f_type; 
													f_prot=0; 
													f_size = section_size;
													f_aligned_at = Uberspark_config.config_settings.binary_uobj_section_alignment; 
													f_pad_to = Uberspark_config.config_settings.binary_uobj_section_alignment; 
													f_addr_start = !uobj_section_load_addr; 
													f_addr_file = 0;
													f_reserved = 0;
											};
				};

			Uberspark_logger.log "section at address 0x%08x, size=0x%08x padding=0x%08x" !uobj_section_load_addr section_size !padding_size;
			uobj_section_load_addr := !uobj_section_load_addr + section_size;
		)  self#get_d_sections_hashtbl;

		
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
					Hashtbl.add d_sections_memory_map_hashtbl "usuobj_padding" 
						{ f_name = "usuobj_padding";	
							f_subsection_list = [ ];	
							usbinformat = { f_type = Defs.Basedefs.def_USBINFORMAT_SECTION_TYPE_PADDING;
															f_prot=0; 
															f_size = (uobjsize - (!uobj_section_load_addr - uobj_load_addr));
															f_aligned_at = Uberspark_config.config_settings.binary_uobj_section_alignment; 
															f_pad_to = Uberspark_config.config_settings.binary_uobj_section_alignment; 
															f_addr_start = !uobj_section_load_addr; 
															f_addr_file = 0;
															f_reserved = 0;
														};
						};
					Hashtbl.add d_sections_memory_map_hashtbl_byorigin !uobj_section_load_addr 
						{ f_name = "usuobj_padding";	
							f_subsection_list = [ ];	
							usbinformat = { f_type = Defs.Basedefs.def_USBINFORMAT_SECTION_TYPE_PADDING;
															f_prot=0; 
															f_size = (uobjsize - (!uobj_section_load_addr - uobj_load_addr));
															f_aligned_at = Uberspark_config.config_settings.binary_uobj_section_alignment; 
															f_pad_to = Uberspark_config.config_settings.binary_uobj_section_alignment; 
															f_addr_start = !uobj_section_load_addr; 
															f_addr_file = 0;
															f_reserved = 0;
														};
						};
				end
			;	

		end else begin
			(* uobj binary image sizes within the collection are not uniform *)
			
			if (!uobj_section_load_addr mod self#get_d_alignment) > 0 then begin
				(* uobj_section_load_addr is __not__ aligned at uobj_binary_image_alignment *)
				(* add padding section *)
				Hashtbl.add d_sections_memory_map_hashtbl "uobj_padding" 
					{ f_name = "uobj_padding";	
						f_subsection_list = [ ];	
						usbinformat = { f_type = Defs.Binformat.const_USBINFORMAT_SECTION_TYPE_PADDING;
										f_prot=0; 
										f_size = (self#get_d_alignment - (!uobj_section_load_addr mod self#get_d_alignment));
										f_aligned_at = Uberspark_config.config_settings.binary_uobj_section_alignment; 
										f_pad_to = Uberspark_config.config_settings.binary_uobj_section_alignment; 
										f_addr_start = !uobj_section_load_addr; 
										f_addr_file = 0;
										f_reserved = 0;
						};
					};
				Hashtbl.add d_sections_memory_map_hashtbl_byorigin !uobj_section_load_addr 
					{ f_name = "uobj_padding";	
						f_subsection_list = [ ];	
						usbinformat = { f_type = Defs.Basedefs.def_USBINFORMAT_SECTION_TYPE_PADDING;
										f_prot=0; 
										f_size = (self#get_d_alignment - (!uobj_section_load_addr mod self#get_d_alignment));
										f_aligned_at = Uberspark_config.config_settings.binary_uobj_section_alignment; 
										f_pad_to = Uberspark_config.config_settings.binary_uobj_section_alignment; 
										f_addr_start = !uobj_section_load_addr; 
										f_addr_file = 0;
										f_reserved = 0;
						};
					};

				(* update uobj size *)
				self#set_d_size ((!uobj_section_load_addr + (self#get_d_alignment - (!uobj_section_load_addr mod self#get_d_alignment))) - self#get_d_load_addr);

			end else begin
				(* uobj_section_load_addr is aligned at uobj_binary_image_alignment *)
				(* we don't need to do anything *)
			end;

		end;

					
		()
	;



	(*--------------------------------------------------------------------------*)
	(* initialize *)
	(*--------------------------------------------------------------------------*)
	method initialize	
		?(context_path_builddir = ".")
		(target_def: Defs.Basedefs.target_def_t)
		(uobj_load_address : int)
		= 
	
		(* set target definition *)
		self#set_d_target_def target_def;	

		(* set build directory *)
		self#set_d_context_path_builddir context_path_builddir;

		(* set load address *)
		self#set_d_load_addr uobj_load_address;

		(* debug dump the target spec and definition *)		
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "uobj target spec => %s:%s:%s" 
				(self#get_d_hdr).f_platform (self#get_d_hdr).f_arch (self#get_d_hdr).f_cpu;
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "uobj target definition => %s:%s:%s" 
				(self#get_d_target_def).f_platform (self#get_d_target_def).f_arch (self#get_d_target_def).f_cpu;

		(* add default uobj sections *)
		Hashtbl.add d_sections_hashtbl "uobj_binhdr" {
			f_name = "uobj_binhdr";	
			f_subsection_list = [ ".uobj_binhdr"; ".uobj_binhdr_section_info" ];	
			usbinformat = { f_type= Defs.Binformat.const_USBINFORMAT_SECTION_TYPE_UOBJ_SSA; 
							f_prot=0; 
							f_size = Uberspark_config.config_settings.binary_uobj_default_section_size;
							f_aligned_at = Uberspark_config.config_settings.binary_uobj_section_alignment; 
							f_pad_to = Uberspark_config.config_settings.binary_uobj_section_alignment; 
							f_addr_start=0; 
							f_addr_file = 0;
							f_reserved = 0;
						};
		};


		Hashtbl.add d_sections_hashtbl "uobj_ssa" {
			f_name = "uobj_ssa";	
			f_subsection_list = [ ".uobj_ssa" ];	
			usbinformat = { f_type= Defs.Binformat.const_USBINFORMAT_SECTION_TYPE_UOBJ_SSA; 
							f_prot=0; 
							f_size = Uberspark_config.config_settings.binary_uobj_default_section_size;
							f_aligned_at = Uberspark_config.config_settings.binary_uobj_section_alignment; 
							f_pad_to = Uberspark_config.config_settings.binary_uobj_section_alignment; 
							f_addr_start=0; 
							f_addr_file = 0;
							f_reserved = 0;
						};
		};

		Hashtbl.add d_sections_hashtbl "uobj_pminfo" {
			f_name = "uobj_pminfo";	
			f_subsection_list = [ ".uobj_pminfo_hdr"; ".uobj_pminfo" ];	
			usbinformat = { f_type= Defs.Binformat.const_USBINFORMAT_SECTION_TYPE_UOBJ_PMINFO; 
							f_prot=0; 
							f_size = Uberspark_config.config_settings.binary_uobj_default_section_size;
							f_aligned_at = Uberspark_config.config_settings.binary_uobj_section_alignment; 
							f_pad_to = Uberspark_config.config_settings.binary_uobj_section_alignment; 
							f_addr_start=0; 
							f_addr_file = 0;
							f_reserved = 0;
						};
		};

		Hashtbl.add d_sections_hashtbl "uobj_intrauobjcoll_cinfo" {
			f_name = "uobj_intrauobjcoll_cinfo";	
			f_subsection_list = [ ".uobj_intrauobjcoll_cinfo_hdr"; ".uobj_intrauobjcoll_cinfo" ];	
			usbinformat = { f_type= Defs.Binformat.const_USBINFORMAT_SECTION_TYPE_UOBJ_INTRAUOBJCOLL_CINFO; 
							f_prot=0; 
							f_size = Uberspark_config.config_settings.binary_uobj_default_section_size;
							f_aligned_at = Uberspark_config.config_settings.binary_uobj_section_alignment; 
							f_pad_to = Uberspark_config.config_settings.binary_uobj_section_alignment; 
							f_addr_start=0; 
							f_addr_file = 0;
							f_reserved = 0;
						};
		};

		Hashtbl.add d_sections_hashtbl "uobj_intrauobjcoll_csltcode" {
			f_name = "uobj_intrauobjcoll_csltcode";	
			f_subsection_list = [ ".uobj_intrauobjcoll_csltcode" ];	
			usbinformat = { f_type= Defs.Binformat.const_USBINFORMAT_SECTION_TYPE_UOBJ_INTRAUOBJCOLL_CSLTCODE; 
							f_prot=0; 
							f_size = Uberspark_config.config_settings.binary_uobj_default_section_size;
							f_aligned_at = Uberspark_config.config_settings.binary_uobj_section_alignment; 
							f_pad_to = Uberspark_config.config_settings.binary_uobj_section_alignment; 
							f_addr_start=0; 
							f_addr_file = 0;
							f_reserved = 0;
						};
		};

		Hashtbl.add d_sections_hashtbl "uobj_intrauobjcoll_csltdata" {
			f_name = "uobj_intrauobjcoll_csltdata";	
			f_subsection_list = [ ".uobj_intrauobjcoll_csltdata" ];	
			usbinformat = { f_type= Defs.Binformat.const_USBINFORMAT_SECTION_TYPE_UOBJ_INTRAUOBJCOLL_CSLTDATA; 
							f_prot=0; 
							f_size = Uberspark_config.config_settings.binary_uobj_default_section_size;
							f_aligned_at = Uberspark_config.config_settings.binary_uobj_section_alignment; 
							f_pad_to = Uberspark_config.config_settings.binary_uobj_section_alignment; 
							f_addr_start=0; 
							f_addr_file = 0;
							f_reserved = 0;
						};
		};

		Hashtbl.add d_sections_hashtbl "uobj_interuobjcoll_cinfo" {
			f_name = "uobj_interuobjcoll_cinfo";	
			f_subsection_list = [ ".uobj_interuobjcoll_cinfo" ];	
			usbinformat = { f_type= Defs.Binformat.const_USBINFORMAT_SECTION_TYPE_UOBJ_INTERUOBJCOLL_CINFO; 
							f_prot=0; 
							f_size = Uberspark_config.config_settings.binary_uobj_default_section_size;
							f_aligned_at = Uberspark_config.config_settings.binary_uobj_section_alignment; 
							f_pad_to = Uberspark_config.config_settings.binary_uobj_section_alignment; 
							f_addr_start=0; 
							f_addr_file = 0;
							f_reserved = 0;
						};
		};

		Hashtbl.add d_sections_hashtbl "uobj_interuobjcoll_csltcode" {
			f_name = "uobj_interuobjcoll_csltcode";	
			f_subsection_list = [ ".uobj_interuobjcoll_csltcode" ];	
			usbinformat = { f_type= Defs.Binformat.const_USBINFORMAT_SECTION_TYPE_UOBJ_INTERUOBJCOLL_CSLTCODE; 
							f_prot=0; 
							f_size = Uberspark_config.config_settings.binary_uobj_default_section_size;
							f_aligned_at = Uberspark_config.config_settings.binary_uobj_section_alignment; 
							f_pad_to = Uberspark_config.config_settings.binary_uobj_section_alignment; 
							f_addr_start=0; 
							f_addr_file = 0;
							f_reserved = 0;
						};
		};

		Hashtbl.add d_sections_hashtbl "uobj_interuobjcoll_csltdata" {
			f_name = "uobj_interuobjcoll_csltdata";	
			f_subsection_list = [ ".uobj_interuobjcoll_csltdata" ];	
			usbinformat = { f_type= Defs.Binformat.const_USBINFORMAT_SECTION_TYPE_UOBJ_INTERUOBJCOLL_CSLTDATA; 
							f_prot=0; 
							f_size = Uberspark_config.config_settings.binary_uobj_default_section_size;
							f_aligned_at = Uberspark_config.config_settings.binary_uobj_section_alignment; 
							f_pad_to = Uberspark_config.config_settings.binary_uobj_section_alignment; 
							f_addr_start=0; 
							f_addr_file = 0;
							f_reserved = 0;
						};
		};

		Hashtbl.add d_sections_hashtbl "uobj_legacy_cinfo" {
			f_name = "uobj_legacy_cinfo";	
			f_subsection_list = [ ".uobj_legacy_cinfo" ];	
			usbinformat = { f_type= Defs.Binformat.const_USBINFORMAT_SECTION_TYPE_UOBJ_LEGACY_CINFO; 
							f_prot=0; 
							f_size = Uberspark_config.config_settings.binary_uobj_default_section_size;
							f_aligned_at = Uberspark_config.config_settings.binary_uobj_section_alignment; 
							f_pad_to = Uberspark_config.config_settings.binary_uobj_section_alignment; 
							f_addr_start=0; 
							f_addr_file = 0;
							f_reserved = 0;
						};
		};


		Hashtbl.add d_sections_hashtbl "uobj_legacy_csltcode" {
			f_name = "uobj_legacy_csltcode";	
			f_subsection_list = [ ".uobj_legacy_csltcode" ];	
			usbinformat = { f_type= Defs.Binformat.const_USBINFORMAT_SECTION_TYPE_UOBJ_LEGACY_CSLTCODE; 
							f_prot=0; 
							f_size = Uberspark_config.config_settings.binary_uobj_default_section_size;
							f_aligned_at = Uberspark_config.config_settings.binary_uobj_section_alignment; 
							f_pad_to = Uberspark_config.config_settings.binary_uobj_section_alignment; 
							f_addr_start=0; 
							f_addr_file = 0;
							f_reserved = 0;
						};
		};

		Hashtbl.add d_sections_hashtbl "uobj_legacy_csltdata" {
			f_name = "uobj_legacy_csltdata";	
			f_subsection_list = [ ".uobj_legacy_csltdata" ];	
			usbinformat = { f_type= Defs.Binformat.const_USBINFORMAT_SECTION_TYPE_UOBJ_LEGACY_CSLTDATA; 
							f_prot=0; 
							f_size = Uberspark_config.config_settings.binary_uobj_default_section_size;
							f_aligned_at = Uberspark_config.config_settings.binary_uobj_section_alignment; 
							f_pad_to = Uberspark_config.config_settings.binary_uobj_section_alignment; 
							f_addr_start=0; 
							f_addr_file = 0;
							f_reserved = 0;
						};
		};


		Hashtbl.add d_sections_hashtbl "uobj_code" 
			{ f_name = "uobj_code";	
				f_subsection_list = [ ".text" ];	
				usbinformat = { f_type=Defs.Basedefs.def_USBINFORMAT_SECTION_TYPE_UOBJ_CODE; 
												f_prot=0; 
												f_size = Uberspark_config.config_settings.binary_uobj_default_section_size;
												f_aligned_at = Uberspark_config.config_settings.binary_uobj_section_alignment; 
												f_pad_to = Uberspark_config.config_settings.binary_uobj_section_alignment; 
												f_addr_start=0; 
												f_addr_file = 0;
												f_reserved = 0;
											};
			};

		Hashtbl.add d_sections_hashtbl "uobj_rodata" 
			{ f_name = "uobj_rodata";	
				f_subsection_list = [".rodata"];	
				usbinformat = { f_type=Defs.Basedefs.def_USBINFORMAT_SECTION_TYPE_UOBJ_RODATA; 
												f_prot=0; 
												f_size = Uberspark_config.config_settings.binary_uobj_default_section_size;
												f_aligned_at = Uberspark_config.config_settings.binary_uobj_section_alignment; 
												f_pad_to = Uberspark_config.config_settings.binary_uobj_section_alignment;
												f_addr_start=0; 
												f_addr_file = 0;
												f_reserved = 0;
											};
			};

		Hashtbl.add d_sections_hashtbl "uobj_rwdata" 
			{ f_name = "uobj_rwdata";	
				f_subsection_list = [".data"; ".bss"];	
				usbinformat = { f_type=Defs.Basedefs.def_USBINFORMAT_SECTION_TYPE_UOBJ_RWDATA; 
												f_prot=0; 
												f_size = Uberspark_config.config_settings.binary_uobj_default_section_size;
												f_aligned_at = Uberspark_config.config_settings.binary_uobj_section_alignment; 
												f_pad_to = Uberspark_config.config_settings.binary_uobj_section_alignment;
												f_addr_start=0; 
												f_addr_file = 0;
												f_reserved = 0;
											};
			};

		Hashtbl.add d_sections_hashtbl "uobj_dmadata" 
			{ f_name = "uobj_dmadata";	
				f_subsection_list = [".dmadata"];	
				usbinformat = { f_type=Defs.Basedefs.def_USBINFORMAT_SECTION_TYPE_UOBJ_DMADATA;
												f_prot=0; 
												f_size = Uberspark_config.config_settings.binary_uobj_default_section_size;
												f_aligned_at = Uberspark_config.config_settings.binary_uobj_section_alignment; 
												f_pad_to = Uberspark_config.config_settings.binary_uobj_section_alignment;
												f_addr_start=0; 
												f_addr_file = 0;
												f_reserved = 0;
											};
			};


		Hashtbl.add d_sections_hashtbl "uobj_ustack" 
			{ f_name = "uobj_ustack";	
				f_subsection_list = [ ".ustack" ];	
				usbinformat = { f_type=Defs.Basedefs.def_USBINFORMAT_SECTION_TYPE_UOBJ_USTACK; 
												f_prot=0; 
												f_size = Uberspark_config.config_settings.binary_uobj_default_section_size;
												f_aligned_at = Uberspark_config.config_settings.binary_uobj_section_alignment;
												f_pad_to = Uberspark_config.config_settings.binary_uobj_section_alignment; 
												f_addr_start=0; 
												f_addr_file = 0;
												f_reserved = 0;
											};
			};

		Hashtbl.add d_sections_hashtbl "uobj_tstack" 
			{ f_name = "uobj_tstack";	
				f_subsection_list = [ ".tstack"; ".stack" ];	
				usbinformat = { f_type=Defs.Basedefs.def_USBINFORMAT_SECTION_TYPE_UOBJ_TSTACK; 
												f_prot=0; 
												f_size = Uberspark_config.config_settings.binary_uobj_default_section_size;
												f_aligned_at = Uberspark_config.config_settings.binary_uobj_section_alignment;
												f_pad_to = Uberspark_config.config_settings.binary_uobj_section_alignment; 
												f_addr_start=0; 
												f_addr_file = 0;
												f_reserved = 0;
											};
			};



		(* consolidate uboj section memory map *)
		Uberspark_logger.log "Consolidating uobj section memory map...";
		self#consolidate_sections_with_memory_map ();
		Uberspark_logger.log "uobj section memory map initialized";


		(* parse uobj slt manifest *)
		let rval = (self#parse_manifest_slt) in	
		if (rval == false) then
			begin
				Uberspark_logger.log ~lvl:Uberspark_logger.Error "unable to stat/parse uobj slt manifest!";
				ignore (exit 1);
			end
		;

		(* generate slt for intra-uobjcoll callees *)
		let callees_list = ref [] in 
		Hashtbl.iter (fun key value  ->
			callees_list := !callees_list @ value;
		) self#get_d_intrauobjcoll_callees_hashtbl;
		Uberspark_logger.log "total intra-uobjcoll callees=%u" (List.length !callees_list);

		let rval = (Uberspark_codegen.Uobj.generate_slt 
			(self#get_d_context_path_builddir ^ "/" ^ Uberspark_config.namespace_uobjslt_intrauobjcoll_callees_src_filename)
			~output_banner:"uobj sentinel linkage table for intra-uobjcoll callees" !callees_list 
			self#get_d_slt_trampolinedata "intrauobjcoll_csltdata" ".uobj_intrauobjcoll_csltdata"
			self#get_d_slt_trampolinecode ".uobj_intrauobjcoll_csltcode" ) in	
		if (rval == false) then
			begin
				Uberspark_logger.log ~lvl:Uberspark_logger.Error "unable to generate slt for intra-uobjcoll callees!";
				ignore (exit 1);
			end
		;


		(* generate slt for interuobjcoll callees *)
		let interuobjcoll_callees_list = ref [] in
		Hashtbl.iter (fun key value ->
			interuobjcoll_callees_list := !interuobjcoll_callees_list @ value;
		)self#get_d_interuobjcoll_callees_hashtbl;
		Uberspark_logger.log "total interuobjcoll callees=%u" (List.length !interuobjcoll_callees_list);

		let rval = (Uberspark_codegen.Uobj.generate_slt 
			(self#get_d_context_path_builddir ^ "/" ^ Uberspark_config.namespace_uobjslt_interuobjcoll_callees_src_filename) 
			~output_banner:"uobj sentinel linkage table for inter-uobjcoll callees" !interuobjcoll_callees_list 
			self#get_d_slt_trampolinedata "interuobjcoll_csltdata" ".uobj_interauobjcoll_csltdata"
			self#get_d_slt_trampolinecode ".uobj_interauobjcoll_csltcode" ) in	
		if (rval == false) then
			begin
				Uberspark_logger.log ~lvl:Uberspark_logger.Error "unable to generate slt for inter-uobjcoll callees!";
				ignore (exit 1);
			end
		;
		
		(* generate slt for legacy callees *)
		let legacy_callees_list = ref [] in
		List.iter (fun value ->
			legacy_callees_list := !legacy_callees_list @ [ value ];
		) self#get_d_legacy_callees_list;
		Uberspark_logger.log "total legacy callees=%u" (List.length !legacy_callees_list);

		let rval = (Uberspark_codegen.Uobj.generate_slt 
			(self#get_d_context_path_builddir ^ "/" ^ Uberspark_config.namespace_uobjslt_legacy_callees_src_filename) 
			~output_banner:"uobj sentinel linkage table for legacy callees" !legacy_callees_list 
			self#get_d_slt_trampolinedata "legacy_csltdata" ".uobj_legacy_csltdata"
			self#get_d_slt_trampolinecode ".uobj_legacy_csltcode" ) in	
		if (rval == false) then
			begin
				Uberspark_logger.log ~lvl:Uberspark_logger.Error "unable to generate slt for legacy callees!";
				ignore (exit 1);
			end
		;


		(* generate uobj binary public methods info source *)
		Uberspark_logger.log ~crlf:false "Generating uobj binary public methods info source...";
		Uberspark_codegen.Uobj.generate_src_publicmethods_info 
			(self#get_d_context_path_builddir ^ "/" ^ Uberspark_config.namespace_uobj_publicmethods_info_src_filename)
			(self#get_d_hdr).f_namespace d_publicmethods_hashtbl;
		Uberspark_logger.log ~tag:"" "[OK]";


		(* generate uobj binary intrauobjcoll callees info source *)
		Uberspark_logger.log ~crlf:false "Generating uobj binary intrauobjcoll callees info source...";
		Uberspark_codegen.Uobj.generate_src_intrauobjcoll_callees_info 
			(self#get_d_context_path_builddir ^ "/" ^ Uberspark_config.namespace_uobj_intrauobjcoll_callees_info_src_filename)
			d_intrauobjcoll_callees_hashtbl;
		Uberspark_logger.log ~tag:"" "[OK]";


		(* generate uobj binary interuobjcoll callees info source *)
		Uberspark_logger.log ~crlf:false "Generating uobj binary interuobjcoll callees info source...";
		Uberspark_codegen.Uobj.generate_src_interuobjcoll_callees_info 
			(self#get_d_context_path_builddir ^ "/" ^ Uberspark_config.namespace_uobj_interuobjcoll_callees_info_src_filename)
			d_interuobjcoll_callees_hashtbl;
		Uberspark_logger.log ~tag:"" "[OK]";


		(* generate uobj binary legacy callees info source *)
		Uberspark_logger.log ~crlf:false "Generating uobj binary legacy callees info source...";
		Uberspark_codegen.Uobj.generate_src_legacy_callees_info 
			(self#get_d_context_path_builddir ^ "/" ^ Uberspark_config.namespace_uobj_legacy_callees_info_src_filename)
			self#get_d_legacy_callees_list;
		Uberspark_logger.log ~tag:"" "[OK]";


		(* generate uobj binary header source *)
		Uberspark_logger.log ~crlf:false "Generating uobj binary header source...";
		Uberspark_codegen.Uobj.generate_src_binhdr 
			(self#get_d_context_path_builddir ^ "/" ^ Uberspark_config.namespace_uobj_binhdr_src_filename)
			(self#get_d_hdr).f_namespace self#get_d_load_addr self#get_d_size 
			d_sections_hashtbl;
		Uberspark_logger.log ~tag:"" "[OK]";


		(* generate uobj binary linker script *)
		Uberspark_logger.log ~crlf:false "Generating uobj binary linker script...";
		Uberspark_codegen.Uobj.generate_linker_script 
			(self#get_d_context_path_builddir ^ "/" ^ Uberspark_config.namespace_uobj_linkerscript_filename)
			self#get_d_load_addr self#get_d_size self#get_d_sections_memory_map_hashtbl_byorigin;
		Uberspark_logger.log ~tag:"" "[OK]";


		(* add all the autogenerated C source files to the list of c sources *)
		d_sources_c_file_list := [ 
			Uberspark_config.namespace_uobj_publicmethods_info_src_filename;		
			Uberspark_config.namespace_uobj_intrauobjcoll_callees_info_src_filename;
			Uberspark_config.namespace_uobj_interuobjcoll_callees_info_src_filename;
			Uberspark_config.namespace_uobj_legacy_callees_info_src_filename;
			Uberspark_config.namespace_uobj_binhdr_src_filename;
		] @ !d_sources_c_file_list;


		(* add all the autogenerated asm source files to the list of asm sources *)
		(* TBD: eventually this will just be casm sources *)
		d_sources_asm_file_list := [ 
			Uberspark_config.namespace_uobjslt_intrauobjcoll_callees_src_filename;
			Uberspark_config.namespace_uobjslt_interuobjcoll_callees_src_filename;
			Uberspark_config.namespace_uobjslt_legacy_callees_src_filename;
		] @ !d_sources_asm_file_list;


		()	
	;


	(*--------------------------------------------------------------------------*)
	(* compile c files *)
	(*--------------------------------------------------------------------------*)
	method compile_c_files	
		()
		: bool = 
		
		let retval = ref false in

		retval := Uberspark_bridge.Cc.invoke ~gen_obj:true
			 ~context_path_builddir:Uberspark_config.namespace_uobj_build_dir 
			 (self#get_d_sources_c_file_list) [ "."; !Uberspark_config.namespace_root_dir ] ".";

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
			 ~context_path_builddir:Uberspark_config.namespace_uobj_build_dir 
			 (self#get_d_sources_asm_file_list) [ "."; !Uberspark_config.namespace_root_dir ] ".";

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
		) self#get_d_sources_c_file_list;

		(* add object files generated from asm sources *)
		List.iter (fun fname ->
			o_file_list := !o_file_list @ [ fname ^ ".o"];
		) self#get_d_sources_asm_file_list;


		retval := Uberspark_bridge.Ld.invoke 
			 ~context_path_builddir:Uberspark_config.namespace_uobj_build_dir 
			Uberspark_config.namespace_uobj_linkerscript_filename
			Uberspark_config.namespace_uobj_binary_image_filename
			!o_file_list
			[ ] [ ]	".";

		(!retval)	
	;



	method install_create_ns 
		()
		: unit =
		
		let uobj_path_ns = self#get_d_path_ns in
		
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "d_path_ns=%s" uobj_path_ns;
		
		(* make namespace folder if not already existing *)
		Uberspark_osservices.mkdir ~parent:true uobj_path_ns (`Octal 0o0777);
	;


	method install_h_files_ns 
		()
		: unit =
		
		let uobj_path_to_mf_filename = self#get_d_path_to_mf_filename in
		let uobj_path_ns = self#get_d_path_ns in
		
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "d_path_to_mf_filename=%s" uobj_path_to_mf_filename;
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "d_path_ns=%s" uobj_path_ns;
		
		(* copy h files to namespace *)
		List.iter ( fun h_filename -> 
			Uberspark_osservices.file_copy (uobj_path_to_mf_filename ^ "/" ^ h_filename)
			(uobj_path_ns ^ "/" ^ h_filename);
		) self#get_d_sources_h_file_list;

	;


	method remove_ns 
		()
		: unit =
		
		let uobj_path_ns = self#get_d_path_ns in
		
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "d_path_ns=%s" uobj_path_ns;
		
		(* remove the path and files within *)
		Uberspark_osservices.rmdir_recurse [ uobj_path_ns ];
	;

end;;




let build
	(uobj_path : string)
	(uobj_target_def : Defs.Basedefs.target_def_t)
	: bool =

	let retval = ref false in
	let in_namespace_build = ref false in

	let (rval, abs_uobj_path) = (Uberspark_osservices.abspath uobj_path) in
	if(rval == false) then begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not obtain absolute path for uobj: %s" abs_uobj_path;
		(!retval)
	end else

	(* switch working directory to uobj_path *)
	let (rval, r_prevpath, r_curpath) = (Uberspark_osservices.dir_change abs_uobj_path) in
	if(rval == false) then begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not switch to uobj path: %s" abs_uobj_path;
		(!retval)
	end else

	let dummy = 0 in begin

	(* create _build folder *)
	Uberspark_osservices.mkdir ~parent:true Uberspark_config.namespace_uobj_build_dir (`Octal 0o0777);

	(* check to see if we are doing an in-namespace build or an out-of-namespace build *)
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "namespace root=%s" (!Uberspark_config.namespace_root_dir ^ "/" ^ Uberspark_config.namespace_root ^ "/");
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "abs_uobj_path_ns=%s" (abs_uobj_path);
	if (Str.string_match (Str.regexp_string (!Uberspark_config.namespace_root_dir ^ "/" ^ Uberspark_config.namespace_root ^ "/")) abs_uobj_path 0) then begin
		in_namespace_build := true;
	end else begin
		in_namespace_build := false;
	end;
	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "in_namespace_build=%B" !in_namespace_build;
	end;

	if not (Uberspark_bridge.initialize_from_config ()) then begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not initialize bridges!";
		(!retval)
	end else
	

	let uobj_mf_filename = (abs_uobj_path ^ "/" ^ Uberspark_config.namespace_uobj_mf_filename) in
	let dummy = 0 in begin
    Uberspark_logger.log "initialized bridges";
	Uberspark_logger.log "parsing uobj manifest: %s" uobj_mf_filename;
	end;

    (* create uobj instance and parse manifest *)
	let uobj = new uobject in
	let rval = (uobj#parse_manifest uobj_mf_filename true) in	
    if (rval == false) then	begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "unable to stat/parse manifest for uobj: %s" uobj_mf_filename;
		(!retval)
	end else

	let dummy = 0 in begin

	Uberspark_logger.log "successfully parsed uobj manifest";
	(*TBD: validate platform, arch, cpu target def with uobj target spec*)

	(* initialize uobj initial state *)
	(* TBD: we need to get the load address as argument to the build interface *)
	uobj#initialize ~context_path_builddir:Uberspark_config.namespace_uobj_build_dir uobj_target_def 
		Uberspark_config.config_settings.uobj_binary_image_load_address;

	(* install headers if we are doing an out-of-namespace build *)
	if not !in_namespace_build then begin
	    Uberspark_logger.log "prepping for out-of-namespace build...";
		uobj#install_create_ns ();
		uobj#install_h_files_ns ();
	    Uberspark_logger.log "ready for out-of-namespace build";
	end;

	if (List.length uobj#get_d_sources_c_file_list) > 0 then begin
		Uberspark_osservices.cp "*.c" (Uberspark_config.namespace_uobj_build_dir ^ "/.");
	end;

	if (List.length uobj#get_d_sources_h_file_list) > 0 then begin
		Uberspark_osservices.cp "*.h" "./_build/.";
	end;

	if (List.length uobj#get_d_sources_casm_file_list) > 0 then begin
		Uberspark_osservices.cp "*.cS" "./_build/.";
	end;


    Uberspark_logger.log "proceeding to compile c files...";
	end;

	if not (uobj#compile_c_files ()) then begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not compile one or more uobj c files!";
		(!retval)
	end else

	let dummy = 0 in begin
	Uberspark_logger.log "compiled c files successfully!";
    Uberspark_logger.log "proceeding to compile asm files...";
	end;

	if not (uobj#compile_asm_files ()) then begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not compile one or more uobj asm files!";
		(!retval)
	end else

	let dummy = 0 in begin
	Uberspark_logger.log "compiled asm files successfully!";
    Uberspark_logger.log "proceeding to link object files...";
	end;

	if not (uobj#link_object_files ()) then begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not link uobj object files!";
		(!retval)
	end else


	let dummy = 0 in begin
	Uberspark_logger.log "linked object files successfully!";

	(* cleanup namespace if we are doing an out-of-namespace build *)
	if not !in_namespace_build then begin
		uobj#remove_ns ();
	end;

	(* restore working directory *)
	ignore(Uberspark_osservices.dir_change r_prevpath);

	Uberspark_logger.log "cleaned up build";
	retval := true;
	end;

	(!retval)
;;
