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

	val d_publicmethods_hashtbl = ((Hashtbl.create 32) : ((string, Uberspark_manifest.Uobj.uobj_publicmethods_t)  Hashtbl.t)); 
	method get_d_publicmethods_hashtbl = d_publicmethods_hashtbl;

	val d_intrauobjcoll_callees_hashtbl = ((Hashtbl.create 32) : ((string, string list)  Hashtbl.t)); 
	method get_d_intrauobjcoll_callees_hashtbl = d_intrauobjcoll_callees_hashtbl;

	val d_interuobjcoll_callees_hashtbl = ((Hashtbl.create 32) : ((string, string list)  Hashtbl.t)); 
	method get_d_interuobjcoll_callees_hashtbl = d_interuobjcoll_callees_hashtbl;

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

	(* uobj load address base *)
	val d_load_addr = ref Uberspark_config.config_settings.binary_uobj_default_load_addr;
	method get_d_load_addr = !d_load_addr;
	method set_d_load_addr load_addr = (d_load_addr := load_addr);
	
	(* uobj size *)
	val d_size = ref Uberspark_config.config_settings.binary_uobj_default_size; 
	method get_d_size = !d_size;
	method set_d_size size = (d_size := size);





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
				d_sources_h_file_list d_sources_c_file_list d_sources_casm_file_list) in

		if (rval == false) then (false)
		else
		let dummy = 0 in
			begin
				Uberspark_logger.log "total sources: h files=%u, c files=%u, casm files=%u" 
					(List.length self#get_d_sources_h_file_list)
					(List.length self#get_d_sources_c_file_list)
					(List.length self#get_d_sources_casm_file_list);
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


		(* parse uobj-binary/uobj-sections node *)
		let rval = (Uberspark_manifest.Uobj.parse_uobj_sections mf_json d_sections_hashtbl) in

		if (rval == false) then (false)
		else
		let dummy = 0 in
		if (rval == true) then
			begin
				Uberspark_logger.log "binary sections override:%u" (Hashtbl.length self#get_d_sections_hashtbl);								
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
		(uobj_load_addr : int)
		(uobjsize : int)  
		=

		let uobj_section_load_addr = ref 0 in
		self#set_d_load_addr uobj_load_addr;
		uobj_section_load_addr := uobj_load_addr;

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
					
		self#set_d_size uobjsize;
		()
	;



	(*--------------------------------------------------------------------------*)
	(* initialize *)
	(*--------------------------------------------------------------------------*)
	method initialize	
		(target_def: Defs.Basedefs.target_def_t)
		= 
		(* set target definition *)
		self#set_d_target_def target_def;	

		(* debug dump the target spec and definition *)		
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "uobj target spec => %s:%s:%s" 
				(self#get_d_hdr).f_platform (self#get_d_hdr).f_arch (self#get_d_hdr).f_cpu;
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "uobj target definition => %s:%s:%s" 
				(self#get_d_target_def).f_platform (self#get_d_target_def).f_arch (self#get_d_target_def).f_cpu;

		(* parse uobj slt manifest *)
		let rval = (self#parse_manifest_slt) in	
		if (rval == false) then
			begin
				Uberspark_logger.log ~lvl:Uberspark_logger.Error "unable to stat/parse uobj slt manifest!";
				ignore (exit 1);
			end
		;


		(* generate slt for callees *)
		let callees_list = ref [] in 
		Hashtbl.iter (fun key value  ->
			callees_list := !callees_list @ value;
		) self#get_d_intrauobjcoll_callees_hashtbl;
		Uberspark_logger.log "total callees=%u" (List.length !callees_list);

		let rval = (Uberspark_codegen.Uobj.generate_slt Uberspark_config.namespace_uobjslt_callees_output_filename 
			!callees_list self#get_d_slt_trampolinedata self#get_d_slt_trampolinecode ".uobjslt_callees_tcode" ".uobjslt_callees_tdata" ) in	
		if (rval == false) then
			begin
				Uberspark_logger.log ~lvl:Uberspark_logger.Error "unable to generate slt for callees!";
				ignore (exit 1);
			end
		;


		(* generate slt for interuobjcoll callees *)
		let interuobjcoll_callees_list = ref [] in
		Hashtbl.iter (fun key value ->
			interuobjcoll_callees_list := !interuobjcoll_callees_list @ value;
		)self#get_d_interuobjcoll_callees_hashtbl;
		Uberspark_logger.log "total interuobjcoll callees=%u" (List.length !interuobjcoll_callees_list);

		let rval = (Uberspark_codegen.Uobj.generate_slt Uberspark_config.namespace_uobjslt_exitcallees_output_filename 
			!interuobjcoll_callees_list self#get_d_slt_trampolinedata self#get_d_slt_trampolinecode ".uobjslt_exitcallees_tcode" ".uobjslt_exitcallees_tdata" ) in	
		if (rval == false) then
			begin
				Uberspark_logger.log ~lvl:Uberspark_logger.Error "unable to generate slt for exitcallees!";
				ignore (exit 1);
			end
		;
		
		(* add default uobj sections *)
		Hashtbl.add d_sections_hashtbl "uobj_hdr" 
			{ f_name = "uobj_hdr";	
				f_subsection_list = [ ".hdr" ];	
				usbinformat = { f_type= Defs.Basedefs.def_USBINFORMAT_SECTION_TYPE_UOBJ_HDR; 
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

		Hashtbl.add d_sections_hashtbl "uobj_data" 
			{ f_name = "uobj_data";	
				f_subsection_list = [".data"; ".rodata"];	
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

		(* consolidate uboj section memory map *)
		Uberspark_logger.log "Consolidating uobj section memory map...";
		self#consolidate_sections_with_memory_map self#get_d_load_addr self#get_d_size;
		Uberspark_logger.log "uobj section memory map initialized";

		(* generate uobj binary header source *)
		Uberspark_logger.log ~crlf:false "Generating uobj binary header source...";
		Uberspark_codegen.Uobj.generate_src_binhdr Uberspark_config.namespace_uobj_binhdr_src_filename
			self#get_d_load_addr self#get_d_size d_sections_hashtbl;
		Uberspark_logger.log ~tag:"" "[OK]";

		(* generate uobj binary public methods info source *)
		Uberspark_logger.log ~crlf:false "Generating uobj binary public methods info source...";
		Uberspark_codegen.Uobj.generate_src_publicmethods_info Uberspark_config.namespace_uobj_publicmethods_info_src_filename
			d_publicmethods_hashtbl;
		Uberspark_logger.log ~tag:"" "[OK]";

		(* generate uobj binary intrauobjcoll callees info source *)
		Uberspark_logger.log ~crlf:false "Generating uobj binary intrauobjcoll callees info source...";
		Uberspark_codegen.Uobj.generate_src_intrauobjcoll_callees_info 
			Uberspark_config.namespace_uobj_intrauobjcoll_callees_info_src_filename
			d_intrauobjcoll_callees_hashtbl;
		Uberspark_logger.log ~tag:"" "[OK]";

		(* generate uobj binary interuobjcoll callees info source *)
		Uberspark_logger.log ~crlf:false "Generating uobj binary interuobjcoll callees info source...";
		Uberspark_codegen.Uobj.generate_src_interuobjcoll_callees_info 
			Uberspark_config.namespace_uobj_interuobjcoll_callees_info_src_filename
			d_interuobjcoll_callees_hashtbl;
		Uberspark_logger.log ~tag:"" "[OK]";

		(* generate uobj binary linker script *)
		Uberspark_logger.log ~crlf:false "Generating uobj binary linker script...";
		Uberspark_codegen.Uobj.generate_linker_script Uberspark_config.namespace_uobj_linkerscript_filename 
			self#get_d_load_addr self#get_d_size self#get_d_sections_memory_map_hashtbl_byorigin;
		Uberspark_logger.log ~tag:"" "[OK]";


		()	
	;


	(*--------------------------------------------------------------------------*)
	(* compile c files *)
	(*--------------------------------------------------------------------------*)
	method compile_c_files	
		()
		: bool = 
		
		let retval = ref false in

		retval := Uberspark_bridge.Cc.invoke ~gen_obj:true (self#get_d_sources_c_file_list) ".";

		(!retval)	
	;



	method install_h_files_to_ns 
		()
		: unit =
		
		let uobj_path_to_mf_filename = self#get_d_path_to_mf_filename in
		let uobj_path_ns = self#get_d_path_ns in
		
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "d_path_to_mf_filename=%s" uobj_path_to_mf_filename;
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "d_path_ns=%s" uobj_path_ns;
		
		(* make namespace folder if not already existing *)
		Uberspark_osservices.mkdir ~parent:true uobj_path_ns (`Octal 0o0777);

		(* copy h files to namespace *)
		
		List.iter ( fun h_filename -> 
			Uberspark_osservices.file_copy (uobj_path_to_mf_filename ^ "/" ^ h_filename)
			(uobj_path_ns ^ "/" ^ h_filename);
		) self#get_d_sources_h_file_list;

	;



end;;



let install_uobj_c_files ()
	: unit =
	let dummy = ref 0 in
		dummy :=0 ;
	(* construct destination namespace folder *)
	(* copy c files *)
;;

let install_uobj_casm_files ()
	: unit =
	let dummy = ref 0 in
		dummy :=0 ;
	(* construct destination namespace folder *)
	(* copy casm files *)
;;


let install ()
	: unit =
	let dummy = ref 0 in
		dummy :=0 ;
	(* construct destination namespace folder *)
	(* copy c files *)
	(* copy casm files *)
	(* copy h files *)
;;

let remove ()
	: unit =
	let dummy = ref 0 in
		dummy :=0 ;

	(* construct destination namespace folder *)
	(* remove namespace folder *)
;;



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

	let dummy = 0 in begin
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
	uobj#initialize uobj_target_def;

	(* install headers if we are doing an out-of-namespace build *)
	if not !in_namespace_build then begin
	    Uberspark_logger.log "prepping for out-of-namespace build...";
		uobj#install_h_files_to_ns ();
	    Uberspark_logger.log "ready for out-of-namespace build";
	end;

    Uberspark_logger.log "proceeding to compile c files...";
	end;

	if not (uobj#compile_c_files ()) then begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not compile one or more uobj c files!";
		(!retval)
	end else

	let dummy = 0 in begin
		Uberspark_logger.log "compiled c files successfully!";
	end;

	(!retval)
;;
