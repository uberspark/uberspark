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

		method hashtbl_keys (h : (int, Defs.Basedefs.section_info_t) Hashtbl.t ) = Hashtbl.fold (fun key _ l -> key :: l) h [];




		(*--------------------------------------------------------------------------*)
		(* parse uobj manifest *)
		(* usmf_filename = canonical uobj manifest filename *)
		(* keep_temp_files = true if temporary files need to be preserved *)
		(*--------------------------------------------------------------------------*)
		method parse_manifest 
			(uobj_mf_filename : string)
			(keep_temp_files : bool) 
			: bool =
			
			(* store filename and uobj path/namespace *)
			d_mf_filename := Filename.basename uobj_mf_filename;
			d_path_ns := Filename.dirname uobj_mf_filename;
			
			(* read manifest JSON *)
			let (rval, mf_json) = Uberspark_manifest.get_manifest_json self#get_d_mf_filename in
			
			if (rval == false) then (false)
			else

			(* parse uobj-hdr node *)
			let rval = (Uberspark_manifest.Uobj.parse_uobj_hdr mf_json d_hdr ) in
			if (rval == false) then (false)
			else

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
		(* generate sentinel linkage table *)
		(*--------------------------------------------------------------------------*)
		method generate_slt	
			(fn_list: string list)
			(output_section_name_code : string)
			(output_section_name_data : string)
			(output_filename : string)
			: bool	= 
				let retval = ref false in
				
				Uberspark_logger.log ~lvl:Uberspark_logger.Debug "fn_list length=%u" (List.length fn_list);
				let oc = open_out output_filename in
					Printf.fprintf oc "\n/* --- this file is autogenerated --- */";
					Printf.fprintf oc "\n/* uberSpark sentinel linkage table */";
					Printf.fprintf oc "\n/* author: amit vasudevan (amitvasudevan@acm.org) */";
					Printf.fprintf oc "\n";
					Printf.fprintf oc "\n";
					Printf.fprintf oc "\n/* --- trampoline data follows --- */";
					Printf.fprintf oc "\n.section %s" output_section_name_data;
					Printf.fprintf oc "\n.global uobjslt_trampolinedata";
					Printf.fprintf oc "\nuobjslt_trampolinedata:";
					let tdata_0 = Str.global_replace (Str.regexp "TOTAL_TRAMPOLINES") "2" (self#get_d_slt_trampolinedata) in
					let tdata = Str.global_replace (Str.regexp "SIZEOF_TRAMPOLINE_ENTRY") "4" tdata_0 in
					Printf.fprintf oc "\n%s" (tdata);
					Printf.fprintf oc "\n";
					Printf.fprintf oc "\n";
					Printf.fprintf oc "\n/* --- trampoline code follows --- */";
					Printf.fprintf oc "\n";
					Printf.fprintf oc "\n";


					for index=0 to (List.length fn_list - 1) do 
						Printf.fprintf oc "\n";
						Printf.fprintf oc "\n.section %s" output_section_name_code;
						Printf.fprintf oc "\n.global %s" (List.nth fn_list index);
						Printf.fprintf oc "\n%s:" (List.nth fn_list index);
						let tcode = Str.global_replace (Str.regexp "TRAMPOLINE_FN_INDEX") (string_of_int index) (self#get_d_slt_trampolinecode) in
						Printf.fprintf oc "\n%s" tcode;
	
						Printf.fprintf oc "\n";
					done;

				close_out oc;	

				retval := true;
				(!retval)
			;

			



		(*--------------------------------------------------------------------------*)
		(* parse sentinel linkage manifest *)
		(*--------------------------------------------------------------------------*)
		method parse_manifest_slt	
			(*(fn_list: string list)*)
				= 
				let retval = ref false in 	
				let target_def = 	self#get_d_target_def in	
				let uobjslt_filename = (Uberspark_config.namespace_uobjslt ^ "/" ^
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
			(* generate uobj binary header source *)
			(*--------------------------------------------------------------------------*)
			method generate_src_binhdr = 

				(* open binary header source file *)
				let oc = open_out Uberspark_config.namespace_uobj_binhdr_src_filename in
				
				(* generate prologue *)
				Printf.fprintf oc "\n/* autogenerated uberSpark uobj binary header source */";
				Printf.fprintf oc "\n/* author: amit vasudevan (amitvasudevan@acm.org) */";
				Printf.fprintf oc "\n";
				Printf.fprintf oc "\n#include <uberspark.h>";
				Printf.fprintf oc "\n#include <usbinformat.h>";
				Printf.fprintf oc "\n";
				Printf.fprintf oc "\n";

				Printf.fprintf oc "\n__attribute__(( section(\".binhdr\") )) __attribute__((aligned(4096))) usbinformat_uobj_hdr_t uobj_hdr = {";

				(* generate common header *)
				(* hdr *)
				Printf.fprintf oc "\n\t{"; 
				(*magic*)
				Printf.fprintf oc "\n\t\tUSBINFORMAT_HDR_MAGIC_UOBJ,"; 
				(*num_sections*)
				Printf.fprintf oc "\n\t\t0x%08xUL," (Hashtbl.length self#get_d_sections_hashtbl);
				(*page_size*)
				Printf.fprintf oc "\n\t\t0x%08xUL," Uberspark_config.config_settings.binary_page_size; 
				(*aligned_at*)
				Printf.fprintf oc "\n\t\t0x%08xUL," Uberspark_config.config_settings.binary_page_size; 
				(*pad_to*)
				Printf.fprintf oc "\n\t\t0x%08xUL," Uberspark_config.config_settings.binary_page_size; 
				(*size*)
				Printf.fprintf oc "\n\t\t0x%08xULL," (self#get_d_size); 
				Printf.fprintf oc "\n\t},"; 
				(* load_addr *)
				Printf.fprintf oc "\n\t0x%08xULL," (self#get_d_load_addr); 
				(* load_size *)
				Printf.fprintf oc "\n\t0x%08xULL," (self#get_d_size); 
				
				(* generate uobj section defs *)
				Printf.fprintf oc "\n\t{"; 
				
				Hashtbl.iter (fun key (section_info:Defs.Basedefs.section_info_t) ->  
					Printf.fprintf oc "\n\t\t{"; 
					(* type *)
					Printf.fprintf oc "\n\t\t\t0x%08xUL," (section_info.usbinformat.f_type); 
					(* prot *)
					Printf.fprintf oc "\n\t\t\t0x%08xUL," (section_info.usbinformat.f_prot); 
					(* size *)
					Printf.fprintf oc "\n\t\t\t0x%016xULL," (section_info.usbinformat.f_size); 
					(* aligned_at *)
					Printf.fprintf oc "\n\t\t\t0x%08xUL," (section_info.usbinformat.f_aligned_at); 
					(* pad_to *)
					Printf.fprintf oc "\n\t\t\t0x%08xUL," (section_info.usbinformat.f_pad_to); 
					(* addr_start *)
					Printf.fprintf oc "\n\t\t\t0x%016xULL," (section_info.usbinformat.f_addr_start); 
					(* addr_file *)
					Printf.fprintf oc "\n\t\t\t0x%016xULL," (section_info.usbinformat.f_addr_file); 
					(* reserved *)
					Printf.fprintf oc "\n\t\t\t0ULL"; 
					Printf.fprintf oc "\n\t\t},"; 
				) self#get_d_sections_hashtbl;
				
				Printf.fprintf oc "\n\t},"; 

				(* generate epilogue *)
				Printf.fprintf oc "\n};";
				Printf.fprintf oc "\n";
				Printf.fprintf oc "\n";

				close_out oc;

				()
		;


			(*--------------------------------------------------------------------------*)
			(* generate uobj publicmethods info  *)
			(*--------------------------------------------------------------------------*)
			method generate_src_publicmethods_info = 

				(* open public methods info source file *)
				let oc = open_out Uberspark_config.namespace_uobj_publicmethods_info_src_filename in
				
				(* generate prologue *)
				Printf.fprintf oc "\n/* autogenerated uberSpark uobj public methods info source */";
				Printf.fprintf oc "\n/* author: amit vasudevan (amitvasudevan@acm.org) */";
				Printf.fprintf oc "\n";
				Printf.fprintf oc "\n#include <uberspark.h>";
				Printf.fprintf oc "\n#include <usbinformat.h>";
				Printf.fprintf oc "\n";
				Printf.fprintf oc "\n";

				Printf.fprintf oc "\n__attribute__(( section(\".pminfo\") )) __attribute__((aligned(4096))) usbinformat_uobj_publicmethod_info_t uobj_pminfo = {";

				(*num_publicmethods*)
				Printf.fprintf oc "\n\t\t0x%08xUL," (Hashtbl.length self#get_d_publicmethods_hashtbl);
				
				(* generate uobj public methods defs *)
				Printf.fprintf oc "\n\t{"; 
				
				Hashtbl.iter (fun key (pm_info:Uberspark_manifest.Uobj.uobj_publicmethods_t) ->  
					Printf.fprintf oc "\n\t\t{"; 
					(* name *)
					Printf.fprintf oc "\n\t\t\t\"%s\"," (pm_info.f_name); 
					(* vaddr *)
					Printf.fprintf oc "\n\t\t\t&%s," (pm_info.f_name); 
					Printf.fprintf oc "\n\t\t},"; 
				) self#get_d_publicmethods_hashtbl;
				
				Printf.fprintf oc "\n\t},"; 

				(* generate epilogue *)
				Printf.fprintf oc "\n};";
				Printf.fprintf oc "\n";
				Printf.fprintf oc "\n";

				close_out oc;

				()
		;



		(*--------------------------------------------------------------------------*)
		(* generate uobj intrauobjcoll-callees info  *)
		(*--------------------------------------------------------------------------*)
		method generate_src_intrauobjcoll_callees_info = 

			(* open public methods info source file *)
			let oc = open_out Uberspark_config.namespace_uobj_intrauobjcoll_callees_info_src_filename in
			
			(* generate prologue *)
			Printf.fprintf oc "\n/* autogenerated uberSpark uobj intrauobjcoll callees info source */";
			Printf.fprintf oc "\n/* author: amit vasudevan (amitvasudevan@acm.org) */";
			Printf.fprintf oc "\n";
			Printf.fprintf oc "\n#include <uberspark.h>";
			Printf.fprintf oc "\n#include <usbinformat.h>";
			Printf.fprintf oc "\n";
			Printf.fprintf oc "\n";

			Printf.fprintf oc "\n__attribute__(( section(\".intrauobjcollcalleesinfo\") )) __attribute__((aligned(4096))) usbinformat_uobj_intrauobjcoll_callees_info_t uobj_intrauobjcoll_callees = {";

			(*num_intrauobjcoll_callees*)
			let num_intrauobjcoll_callees = ref 0 in
			Hashtbl.iter (fun key value  ->
				num_intrauobjcoll_callees := !num_intrauobjcoll_callees + (List.length value);
			) self#get_d_intrauobjcoll_callees_hashtbl;
			Printf.fprintf oc "\n\t\t0x%08xUL," !num_intrauobjcoll_callees;
			
			(* generate uobj public methods defs *)
			Printf.fprintf oc "\n\t{"; 

			let slt_ordinal = ref 0 in
			Hashtbl.iter (fun key value ->  
				List.iter (fun pm_name -> 
					Printf.fprintf oc "\n\t\t{"; 
					
					(* uobj_ns *)
					Printf.fprintf oc "\n\t\t\t\"%s\"," key; 
					(* pm_name *)
					Printf.fprintf oc "\n\t\t\t\"%s\"," pm_name; 
					(* slt_ordinal *)
					Printf.fprintf oc "\n\t\t0x%08xUL," !slt_ordinal;
					
					Printf.fprintf oc "\n\t\t},"; 
					slt_ordinal := !slt_ordinal + 1;
				) value;
			) self#get_d_intrauobjcoll_callees_hashtbl;
			
			Printf.fprintf oc "\n\t},"; 

			(* generate epilogue *)
			Printf.fprintf oc "\n};";
			Printf.fprintf oc "\n";
			Printf.fprintf oc "\n";

			close_out oc;

			()
		;



		(*--------------------------------------------------------------------------*)
		(* generate uobj interuobjcoll-callees info  *)
		(*--------------------------------------------------------------------------*)
		method generate_src_interuobjcoll_callees_info = 

			(* open interuobjcoll callees info source file *)
			let oc = open_out Uberspark_config.namespace_uobj_interuobjcoll_callees_info_src_filename in
			
			(* generate prologue *)
			Printf.fprintf oc "\n/* autogenerated uberSpark uobj interuobjcoll callees info source */";
			Printf.fprintf oc "\n/* author: amit vasudevan (amitvasudevan@acm.org) */";
			Printf.fprintf oc "\n";
			Printf.fprintf oc "\n#include <uberspark.h>";
			Printf.fprintf oc "\n#include <usbinformat.h>";
			Printf.fprintf oc "\n";
			Printf.fprintf oc "\n";

			Printf.fprintf oc "\n__attribute__(( section(\".interuobjcollcalleesinfo\") )) __attribute__((aligned(4096))) usbinformat_uobj_interuobjcoll_callees_info_t uobj_interuobjcoll_callees = {";

			(*num_interuobjcoll_callees*)
			let num_interuobjcoll_callees = ref 0 in
			Hashtbl.iter (fun key value  ->
				num_interuobjcoll_callees := !num_interuobjcoll_callees + (List.length value);
			) self#get_d_interuobjcoll_callees_hashtbl;
			Printf.fprintf oc "\n\t\t0x%08xUL," !num_interuobjcoll_callees;
			
			(* generate interuobjcoll callee defs *)
			Printf.fprintf oc "\n\t{"; 

			let slt_ordinal = ref 0 in
			Hashtbl.iter (fun key value ->  
				List.iter (fun pm_name -> 
					Printf.fprintf oc "\n\t\t{"; 
					
					(* uobj_ns *)
					Printf.fprintf oc "\n\t\t\t\"%s\"," key; 
					(* pm_name *)
					Printf.fprintf oc "\n\t\t\t\"%s\"," pm_name; 
					(* slt_ordinal *)
					Printf.fprintf oc "\n\t\t0x%08xUL," !slt_ordinal;
					
					Printf.fprintf oc "\n\t\t},"; 
					slt_ordinal := !slt_ordinal + 1;
				) value;
			) self#get_d_interuobjcoll_callees_hashtbl;
			
			Printf.fprintf oc "\n\t},"; 

			(* generate epilogue *)
			Printf.fprintf oc "\n};";
			Printf.fprintf oc "\n";
			Printf.fprintf oc "\n";

			close_out oc;
			()
		;


		(*--------------------------------------------------------------------------*)
		(* generate uobj linker script *)
		(*--------------------------------------------------------------------------*)
		method generate_linker_script 
			(binary_origin : int)
			(binary_size : int)
			(sections_hashtbl : (int, Defs.Basedefs.section_info_t) Hashtbl.t) 
	 		 =
		
			let oc = open_out Uberspark_config.namespace_uobj_linkerscript_filename in
				Printf.fprintf oc "\n/* autogenerated uberSpark uobj linker script */";
				Printf.fprintf oc "\n/* author: amit vasudevan (amitvasudevan@acm.org) */";
				Printf.fprintf oc "\n";
				Printf.fprintf oc "\n";
				Printf.fprintf oc "\nOUTPUT_ARCH(\"i386\")";
				Printf.fprintf oc "\n";
				Printf.fprintf oc "\n";

				Printf.fprintf oc "\nMEMORY";
				Printf.fprintf oc "\n{";
		
				let keys = List.sort compare (self#hashtbl_keys sections_hashtbl) in				
				List.iter (fun key ->
						let x = Hashtbl.find sections_hashtbl key in
						(* new section memory *)
						Printf.fprintf oc "\n %s (%s) : ORIGIN = 0x%08x, LENGTH = 0x%08x"
							("mem_" ^ x.f_name)
							( "rw" ^ "ail") (x.usbinformat.f_addr_start) (x.usbinformat.f_size);
						()
				) keys ;

				Printf.fprintf oc "\n}";
				Printf.fprintf oc "\n";
			
					
				Printf.fprintf oc "\nSECTIONS";
				Printf.fprintf oc "\n{";
				Printf.fprintf oc "\n";
		
				let keys = List.sort compare (self#hashtbl_keys sections_hashtbl) in				

				let i = ref 0 in 			
				while (!i < List.length keys) do
					let key = (List.nth keys !i) in
					let x = Hashtbl.find sections_hashtbl key in
						(* new section *)
						if(!i == (List.length keys) - 1 ) then 
							begin
								Printf.fprintf oc "\n %s : {" x.f_name;
								Printf.fprintf oc "\n	%s_START_ADDR = .;" x.f_name;
								List.iter (fun subsection ->
											Printf.fprintf oc "\n *(%s)" subsection;
								) x.f_subsection_list;
								Printf.fprintf oc "\n . = ORIGIN(%s) + LENGTH(%s) - 1;" ("mem_" ^ x.f_name) ("mem_" ^ x.f_name);
								Printf.fprintf oc "\n BYTE(0xAA)";
								Printf.fprintf oc "\n	%s_END_ADDR = .;" x.f_name;
								Printf.fprintf oc "\n	} >%s =0x9090" ("mem_" ^ x.f_name);
								Printf.fprintf oc "\n";
							end
						else
							begin
								Printf.fprintf oc "\n %s : {" x.f_name;
								Printf.fprintf oc "\n	%s_START_ADDR = .;" x.f_name;
								List.iter (fun subsection ->
											Printf.fprintf oc "\n *(%s)" subsection;
								) x.f_subsection_list;
								Printf.fprintf oc "\n . = ORIGIN(%s) + LENGTH(%s) - 1;" ("mem_" ^ x.f_name) ("mem_" ^ x.f_name);
								Printf.fprintf oc "\n BYTE(0xAA)";
								Printf.fprintf oc "\n	%s_END_ADDR = .;" x.f_name;
								Printf.fprintf oc "\n	} >%s =0x9090" ("mem_" ^ x.f_name);
								Printf.fprintf oc "\n";
							end
						;
				
					i := !i + 1;
				done;
							
				Printf.fprintf oc "\n";
				Printf.fprintf oc "\n	/* this is to cause the link to fail if there is";
				Printf.fprintf oc "\n	* anything we didn't explicitly place.";
				Printf.fprintf oc "\n	* when this does cause link to fail, temporarily comment";
				Printf.fprintf oc "\n	* this part out to see what sections end up in the output";
				Printf.fprintf oc "\n	* which are not handled above, and handle them.";
				Printf.fprintf oc "\n	*/";
				Printf.fprintf oc "\n	/DISCARD/ : {";
				Printf.fprintf oc "\n	*(*)";
				Printf.fprintf oc "\n	}";
				Printf.fprintf oc "\n}";
				Printf.fprintf oc "\n";
																																																																																																																										
				close_out oc;
				()
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

			let rval = (self#generate_slt !callees_list ".uobjslt_callees_tcode" ".uobjslt_callees_tdata" Uberspark_config.namespace_uobjslt_callees_output_filename) in	
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

			let rval = (self#generate_slt !interuobjcoll_callees_list ".uobjslt_exitcallees_tcode" ".uobjslt_exitcallees_tdata" Uberspark_config.namespace_uobjslt_exitcallees_output_filename) in	
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
			self#generate_src_binhdr;
			Uberspark_logger.log ~tag:"" "[OK]";

			(* generate uobj binary public methods info source *)
			Uberspark_logger.log ~crlf:false "Generating uobj binary public methods info source...";
			self#generate_src_publicmethods_info;
			Uberspark_logger.log ~tag:"" "[OK]";

			(* generate uobj binary intrauobjcoll callees info source *)
			Uberspark_logger.log ~crlf:false "Generating uobj binary intrauobjcoll callees info source...";
			self#generate_src_intrauobjcoll_callees_info;
			Uberspark_logger.log ~tag:"" "[OK]";

			(* generate uobj binary interuobjcoll callees info source *)
			Uberspark_logger.log ~crlf:false "Generating uobj binary interuobjcoll callees info source...";
			self#generate_src_interuobjcoll_callees_info;
			Uberspark_logger.log ~tag:"" "[OK]";

			(* generate uobj binary linker script *)
			Uberspark_logger.log ~crlf:false "Generating uobj binary linker script...";
			self#generate_linker_script self#get_d_load_addr self#get_d_size self#get_d_sections_memory_map_hashtbl_byorigin;
			Uberspark_logger.log ~tag:"" "[OK]";


			()	
		;


end;;


