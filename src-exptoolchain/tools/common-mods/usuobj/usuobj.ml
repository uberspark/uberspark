(*------------------------------------------------------------------------------
	uberSpark uberobject verification and build interface
	author: amit vasudevan (amitvasudevan@acm.org)
------------------------------------------------------------------------------*)

open Ustypes
open Usconfig
open Uslog
open Usmanifest
open Usosservices
(*open Usextbinutils*)
(*open Usuobjgen*)

module Usuobj =
struct

		type sentinel_info_t = 
			{
				s_type: string;
				s_type_id : string;
				s_retvaldecl : string;
				s_fname: string;
				s_fparamdecl: string;
				s_fparamdwords : int;
				s_attribute : string;
				s_origin: int;
				s_length: int;	
			};;


		type uobj_publicmethods_info_t = 
			{
				pm_fname: string;
				pm_retvaldecl : string;
				pm_fparamdecl: string;
				pm_fparamdwords : int;
			};;


		

class uobject = object(self)
			
		val log_tag = "Usuobj";
		
		val usmf_type_usuobj = "uobj";

		val o_usmf_hdr_type = ref "";
		method get_o_usmf_hdr_type = !o_usmf_hdr_type;
		
		val o_usmf_hdr_subtype = ref "";
		method get_o_usmf_hdr_subtype = !o_usmf_hdr_subtype;

		val o_usmf_hdr_id = ref "";
		method get_o_usmf_hdr_id = !o_usmf_hdr_id;
		
		val o_usmf_hdr_platform = ref "";
		method get_o_usmf_hdr_platform = !o_usmf_hdr_platform;
		
		val o_usmf_hdr_cpu = ref "";
		method get_o_usmf_hdr_cpu = !o_usmf_hdr_cpu;

		val o_usmf_hdr_arch = ref "";
		method get_o_usmf_hdr_arch = !o_usmf_hdr_arch;

		val o_usmf_sources_h_files: string list ref = ref [];
		method get_o_usmf_sources_h_files = !o_usmf_sources_h_files;
		val o_usmf_sources_c_files: string list ref = ref [];
		method get_o_usmf_sources_c_files = !o_usmf_sources_c_files;
		val o_usmf_sources_casm_files: string list ref = ref [];
		method get_o_usmf_sources_casm_files = !o_usmf_sources_casm_files;

	

		val o_uobj_publicmethods_hashtbl = ((Hashtbl.create 32) : ((string, uobj_publicmethods_info_t)  Hashtbl.t)); 
		method get_o_uobj_publicmethods_hashtbl = o_uobj_publicmethods_hashtbl;

		val o_uobj_publicmethods_sentinels_hashtbl = ((Hashtbl.create 32) : ((string, sentinel_info_t)  Hashtbl.t)); 
		method get_o_uobj_publicmethods_sentinels_hashtbl = o_uobj_publicmethods_sentinels_hashtbl;

		val o_uobj_publicmethods_sentinels_libname = ref "";
		method get_o_uobj_publicmethods_sentinels_libname = !o_uobj_publicmethods_sentinels_libname;

		val o_uobj_publicmethods_sentinels_lib_source_file_list : string list ref = ref [];
		method get_o_uobj_publicmethods_sentinels_lib_source_file_list = !o_uobj_publicmethods_sentinels_lib_source_file_list;



		val o_usmf_filename = ref "";
		method get_o_usmf_filename = !o_usmf_filename;

		val o_uobj_dir_abspathname = ref "";
		method get_o_uobj_dir_abspathname = !o_uobj_dir_abspathname;



		val o_uobj_build_dirname = ref ".";
		method get_o_uobj_build_dirname = !o_uobj_build_dirname;
		
		(* uobj load address base *)
		val o_uobj_load_addr = ref 0;
		method get_o_uobj_load_addr = !o_uobj_load_addr;
		method set_o_uobj_load_addr load_addr = (o_uobj_load_addr := load_addr);

		(* uobj size *)
		val o_uobj_size = ref 0; 
		method get_o_uobj_size = !o_uobj_size;
		method set_o_uobj_size size = (o_uobj_size := size);

(*
		(* uobj section count *)
		val o_uobj_num_sections = ref 0; 
		method get_o_uobj_num_sections = !o_uobj_num_sections;
		method set_o_uobj_num_sections num_sections = (o_uobj_num_sections := num_sections);
*)

		(* base uobj sections hashtbl indexed by section name *)		
		val o_uobj_sections_hashtbl = ((Hashtbl.create 32) : ((string, Ustypes.section_info_t)  Hashtbl.t)); 
		method get_o_uobj_sections_hashtbl = (o_uobj_sections_hashtbl);
		method get_o_uobj_sections_hashtbl_length = (Hashtbl.length o_uobj_sections_hashtbl);
		
		(* hashtbl of uobj sections with memory map info indexed by section name *)
		val uobj_sections_memory_map_hashtbl = ((Hashtbl.create 32) : ((string, Ustypes.section_info_t)  Hashtbl.t)); 
		method get_uobj_sections_memory_map_hashtbl = (uobj_sections_memory_map_hashtbl);

		(* hashtbl of uobj sections with memory map info indexed by section va*)
		val uobj_sections_memory_map_hashtbl_byorigin = ((Hashtbl.create 32) : ((int, Ustypes.section_info_t)  Hashtbl.t)); 
		method get_uobj_sections_memory_map_hashtbl_byorigin = (uobj_sections_memory_map_hashtbl_byorigin);
		
		(* val mutable slab_idtoname = ((Hashtbl.create 32) : ((int,string)  Hashtbl.t)); *)

		val o_sentinels_source_file_list : string list ref = ref [];
		method get_o_sentinels_source_file_list = !o_sentinels_source_file_list;


		val o_pp_definition = ref "";
		method get_o_pp_definition = !o_pp_definition;

		val o_sentineltypes_hashtbl = ((Hashtbl.create 32) : ((string, Ustypes.uobjcoll_sentineltypes_t)  Hashtbl.t));
		method get_o_sentineltypes_hashtbl = o_sentineltypes_hashtbl;

		val o_calleemethods_hashtbl = ref ((Hashtbl.create 32) : ((string, string list)  Hashtbl.t)); 

		val o_exitcallees_list : string list ref = ref [];


		(*--------------------------------------------------------------------------*)
		(* initialize *)
		(* sentineltypes_hashtbl = hash table of sentinel types *)
		(*--------------------------------------------------------------------------*)
		method initialize 
			(sentineltypes_hashtbl : ((string, Ustypes.uobjcoll_sentineltypes_t) Hashtbl.t) ) 
			= 
				
			(* copy over sentineltypes hash table into uobj sentineltypes hash table*)
			Hashtbl.iter (fun key (st:Ustypes.uobjcoll_sentineltypes_t)  ->
					Hashtbl.add o_sentineltypes_hashtbl key st;
			) sentineltypes_hashtbl;

			(* iterate over sentineltypes hash table to construct sentinels hash table*)
			Hashtbl.iter (fun st_key (st:Ustypes.uobjcoll_sentineltypes_t)  ->
						Hashtbl.iter (fun pm_key (pm: uobj_publicmethods_info_t) ->
				
						let sentinel_name = ref "" in
							sentinel_name := "sentinel_" ^ st.s_type ^ "_" ^ pm.pm_fname; 

						Hashtbl.add o_uobj_publicmethods_sentinels_hashtbl !sentinel_name 
							{
								s_type = st.s_type;
								s_type_id = st.s_type_id;
								s_retvaldecl = pm.pm_retvaldecl;
								s_fname = pm.pm_fname;
								s_fparamdecl = pm.pm_fparamdecl;
								s_fparamdwords = pm.pm_fparamdwords;
								s_attribute = (Usconfig.get_sentinel_prot ());
								s_origin = 0;
								s_length = !Usconfig.section_size_sentinel;
							};
			
						) o_uobj_publicmethods_hashtbl;
			) o_sentineltypes_hashtbl;


			(* add default uobj sections *)
			Hashtbl.add o_uobj_sections_hashtbl "uobj_hdr" 
				{ f_name = "uobj_hdr";	
				 	f_subsection_list = [ ".hdr" ];	
					usbinformat = { f_type= Usconfig.def_USBINFORMAT_SECTION_TYPE_UOBJ_HDR; f_prot=0; 
													f_addr_start=0; 
													f_size = !Usconfig.section_size_general;
													f_addr_file = 0;
													f_aligned_at = !Usconfig.section_alignment; f_pad_to = !Usconfig.section_alignment; f_reserved = 0;
												};
				};
			Hashtbl.add o_uobj_sections_hashtbl "uobj_ustack" 
				{ f_name = "uobj_ustack";	
				 	f_subsection_list = [ ".ustack" ];	
					usbinformat = { f_type=Usconfig.def_USBINFORMAT_SECTION_TYPE_UOBJ_USTACK; f_prot=0; 
													f_addr_start=0; 
													f_size = !Usconfig.section_size_general;
													f_addr_file = 0;
													f_aligned_at = !Usconfig.section_alignment; f_pad_to = !Usconfig.section_alignment; f_reserved = 0;
												};
				};
			Hashtbl.add o_uobj_sections_hashtbl "uobj_tstack" 
				{ f_name = "uobj_tstack";	
				 	f_subsection_list = [ ".tstack"; ".stack" ];	
					usbinformat = { f_type=Usconfig.def_USBINFORMAT_SECTION_TYPE_UOBJ_TSTACK; f_prot=0; 
													f_addr_start=0; 
													f_size = !Usconfig.section_size_general;
													f_addr_file = 0;
													f_aligned_at = !Usconfig.section_alignment; f_pad_to = !Usconfig.section_alignment; f_reserved = 0;
												};
				};
			Hashtbl.add o_uobj_sections_hashtbl "uobj_code" 
				{ f_name = "uobj_code";	
				 	f_subsection_list = [ ".text" ];	
					usbinformat = { f_type=Usconfig.def_USBINFORMAT_SECTION_TYPE_UOBJ_CODE; f_prot=0; 
													f_addr_start=0; 
													f_size = !Usconfig.section_size_general;
													f_addr_file = 0;
								f_aligned_at = !Usconfig.section_alignment; f_pad_to = !Usconfig.section_alignment; f_reserved = 0;
												};
				};
			Hashtbl.add o_uobj_sections_hashtbl "uobj_data" 
				{ f_name = "uobj_data";	
				 	f_subsection_list = [".data"; ".rodata"];	
					usbinformat = { f_type=Usconfig.def_USBINFORMAT_SECTION_TYPE_UOBJ_RWDATA; f_prot=0; 
													f_addr_start=0; 
													f_size = !Usconfig.section_size_general;
													f_addr_file = 0;
													f_aligned_at = !Usconfig.section_alignment; f_pad_to = !Usconfig.section_alignment; f_reserved = 0;
												};
				};
				
			Hashtbl.add o_uobj_sections_hashtbl "uobj_dmadata" 
				{ f_name = "uobj_dmadata";	
				 	f_subsection_list = [".dmadata"];	
					usbinformat = { f_type=Usconfig.def_USBINFORMAT_SECTION_TYPE_UOBJ_DMADATA; f_prot=0; 
													f_addr_start=0; 
													f_size = !Usconfig.section_size_general;
													f_addr_file = 0;
													f_aligned_at = !Usconfig.section_alignment; f_pad_to = !Usconfig.section_alignment; f_reserved = 0;
												};
				};
			
			()	
		;



		(*--------------------------------------------------------------------------*)
		(* parse uobj manifest *)
		(* usmf_filename = canonical uobj manifest filename *)
		(* keep_temp_files = true if temporary files need to be preserved *)
		(*--------------------------------------------------------------------------*)
		method parse_manifest 
			(usmf_filename : string)
			(keep_temp_files : bool) 
			: bool =
			
				
			(* store filename and uobj dir absolute pathname *)
			o_usmf_filename := Filename.basename usmf_filename;
			o_uobj_dir_abspathname := Filename.dirname usmf_filename;
			

			(* read manifest JSON *)
			let (rval, mf_json) = Usmanifest.read_manifest 
																usmf_filename keep_temp_files in
			
			if (rval == false) then (false)
			else
			(* parse usmf-hdr node *)
			let (rval, usmf_hdr_type, usmf_hdr_subtype, usmf_hdr_id,
					usmf_hdr_platform, usmf_hdr_cpu, usmf_hdr_arch) =
								Usmanifest.parse_node_usmf_hdr mf_json in

			if (rval == false) then (false)
			else
			
			(* sanity check type to be uobj *)
			if (compare usmf_hdr_type usmf_type_usuobj) <> 0 then (false)
			else
			let dummy = 0 in
				begin
					o_usmf_hdr_type := usmf_hdr_type;								
					o_usmf_hdr_subtype := usmf_hdr_subtype;
					o_usmf_hdr_id := usmf_hdr_id;
					o_usmf_hdr_platform := usmf_hdr_platform;
					o_usmf_hdr_cpu := usmf_hdr_cpu;
					o_usmf_hdr_arch := usmf_hdr_arch;
				end;

			(* parse usmf-sources node *)
			let(rval, usmf_sources_h_files, usmf_source_c_files, usmf_sources_casm_files) = 
				Usmanifest.parse_node_usmf_sources	mf_json in
	
			if (rval == false) then (false)
			else
			let dummy = 0 in
				begin
					o_usmf_sources_h_files := usmf_sources_h_files;
					o_usmf_sources_c_files := usmf_source_c_files;
					o_usmf_sources_casm_files := usmf_sources_casm_files;
				end;


			(* parse uobj-publicmethods node *)
			let (rval, uobj_publicmethods_list) = 
										Usmanifest.parse_node_uobj_publicmethods mf_json in

			if (rval == false) then (false)
			else
			let dummy = 0 in
				begin
					List.iter (fun x ->

						Hashtbl.add o_uobj_publicmethods_hashtbl (List.nth x 0) 
							{
								pm_fname = (List.nth x 0);
								pm_retvaldecl = (List.nth x 1);
								pm_fparamdecl = (List.nth x 2);
								pm_fparamdwords = int_of_string (List.nth x 3);
							};
						
					) uobj_publicmethods_list;
				end;


			(* parse uobj-callemethods node *)
			let (rval, uobj_calleemethods_hashtbl) = 
										Usmanifest.parse_node_uobj_calleemethods mf_json in

			if (rval == false) then (false)
			else
			let dummy = 0 in
				begin
					o_calleemethods_hashtbl := uobj_calleemethods_hashtbl;
					Hashtbl.iter (fun key value  ->
						Uslog.logf log_tag Uslog.Info "key=%s length of list=%u" key (List.length value);
					) !o_calleemethods_hashtbl;

					Uslog.logf log_tag Uslog.Info "successfully parsed uobj-calleemethods";
				end;


			(* parse uobj-exitcallees node *)
			let (rval, uobj_exitcallees_list) = 
										Usmanifest.parse_node_usmf_uobj_exitcallees mf_json in

			if (rval == false) then (false)
			else
			let dummy = 0 in
				begin
					o_exitcallees_list := uobj_exitcallees_list;
					List.iter (fun v  ->
						Uslog.logf log_tag Uslog.Info "exitcallee=%s" v;
					) !o_exitcallees_list;

					Uslog.logf log_tag Uslog.Info "successfully parsed uobj-exitcallees";
				end;


			(* parse uobj-sections node *)
			let (rval, uobj_sections_list) = 
										Usmanifest.parse_node_uobj_binary mf_json in

			(*if (rval == false) then (false)
			else
			let dummy = 0 in*)
			if (rval == true) then
				begin

					List.iter (fun x ->
						(* compute subsection list *)
						let elem_index = ref 0 in
						let subsections_list = ref [] in
						while (!elem_index < List.length x) do
								if (!elem_index > 2) then
									begin
								    subsections_list := !subsections_list @  [(List.nth x !elem_index)];
									end
								; 
								elem_index := !elem_index + 1;
						done;

						Hashtbl.remove o_uobj_sections_hashtbl (List.nth x 0); 
						Hashtbl.add o_uobj_sections_hashtbl (List.nth x 0) 
							{ f_name = (List.nth x 0);	
							 	f_subsection_list = !subsections_list;	
								usbinformat = { f_type=0; f_prot=0; 
																f_addr_start=0; 
																f_size = int_of_string (List.nth x 2);
																f_addr_file = 0;
																f_aligned_at = !Usconfig.section_alignment; f_pad_to = !Usconfig.section_alignment; f_reserved = 0;
															};
							};

							
					) uobj_sections_list;

								
				end;
	
																											
			(* initialize uobj preprocess definition *)
			o_pp_definition := "__UOBJ_" ^ self#get_o_usmf_hdr_id ^ "__";

			(* initialize uobj sentinels lib name *)
			o_uobj_publicmethods_sentinels_libname := "lib" ^ (self#get_o_usmf_hdr_id) ^ "-" ^
				!o_usmf_hdr_platform ^ "-" ^ !o_usmf_hdr_cpu ^ "-" ^ !o_usmf_hdr_arch;
									
			(true)
		;
		




		(*--------------------------------------------------------------------------*)
		(* consolidate sections with memory map *)
		(* uobj_load_addr = load address of uobj *)
		(*--------------------------------------------------------------------------*)
		method consolidate_sections_with_memory_map
			(uobj_load_addr : int)
			(uobjsize : int)  
			: int =

			let uobj_section_load_addr = ref 0 in
			o_uobj_load_addr := uobj_load_addr;
			uobj_section_load_addr := uobj_load_addr;

			(* iterate over sentinels *)
			Hashtbl.iter (fun key (x:sentinel_info_t)  ->
				(* compute and round up section size to section alignment *)
				let remainder_size = (x.s_length mod !Usconfig.section_alignment) in
				let padding_size = ref 0 in
					if remainder_size > 0 then
						begin
							padding_size := !Usconfig.section_alignment - remainder_size;
						end
					else
						begin
							padding_size := 0;
						end
					;
				let section_size = (x.s_length + !padding_size) in 
				
				Hashtbl.add uobj_sections_memory_map_hashtbl key 
					{ f_name = key;	
					 	f_subsection_list = [ ("." ^ key) ];	
						usbinformat = { f_type = int_of_string(x.s_type_id);
														f_prot=0; 
														f_addr_start = !uobj_section_load_addr; 
														(*f_size = x.s_length;*)
														f_size = section_size;
														f_addr_file = 0;
														f_aligned_at = !Usconfig.section_alignment; f_pad_to = !Usconfig.section_alignment; f_reserved = 0;
													};
					};
				Hashtbl.add uobj_sections_memory_map_hashtbl_byorigin !uobj_section_load_addr 
					{ f_name = key;	
					 	f_subsection_list = [ ("." ^ key) ];	
						usbinformat = { f_type = int_of_string(x.s_type_id); 
														f_prot=0; 
														f_addr_start = !uobj_section_load_addr; 
														(* f_size = x.s_length; *)
														f_size = section_size;
														f_addr_file = 0;
														f_aligned_at = !Usconfig.section_alignment; f_pad_to = !Usconfig.section_alignment; f_reserved = 0;
												};
					};
			
				(* uobj_section_load_addr := !uobj_section_load_addr + x.s_length; *)
				Uslog.logf log_tag Uslog.Info "section at address 0x%08x, size=0x%08x padding=0x%08x" !uobj_section_load_addr section_size !padding_size;
				uobj_section_load_addr := !uobj_section_load_addr + section_size;
			)  o_uobj_publicmethods_sentinels_hashtbl;

			(* iterate over regular sections *)
			Hashtbl.iter (fun key (x:Ustypes.section_info_t)  ->
				(* compute and round up section size to section alignment *)
				let remainder_size = (x.usbinformat.f_size mod !Usconfig.section_alignment) in
				let padding_size = ref 0 in
					if remainder_size > 0 then
						begin
							padding_size := !Usconfig.section_alignment - remainder_size;
						end
					else
						begin
							padding_size := 0;
						end
					;
				let section_size = (x.usbinformat.f_size + !padding_size) in 


				Hashtbl.add uobj_sections_memory_map_hashtbl key 
					{ f_name = x.f_name;	
					 	f_subsection_list = x.f_subsection_list;	
						usbinformat = { f_type=x.usbinformat.f_type; 
														f_prot=0; 
														f_addr_start = !uobj_section_load_addr; 
														(*f_size = x.usbinformat.f_size;*)
														f_size = section_size;
														f_addr_file = 0;
														f_aligned_at = !Usconfig.section_alignment; f_pad_to = !Usconfig.section_alignment; f_reserved = 0;
													};
					};
				Hashtbl.add uobj_sections_memory_map_hashtbl_byorigin !uobj_section_load_addr 
					{ f_name = x.f_name;	
					 	f_subsection_list = x.f_subsection_list;	
						usbinformat = { f_type=x.usbinformat.f_type; 
														f_prot=0; 
														f_addr_start = !uobj_section_load_addr; 
														(*f_size = x.usbinformat.f_size;*)
														f_size = section_size;
														f_addr_file = 0;
														f_aligned_at = !Usconfig.section_alignment; f_pad_to = !Usconfig.section_alignment; f_reserved = 0;
												};
					};

				(*uobj_section_load_addr := !uobj_section_load_addr + x.usbinformat.f_size;*)
				Uslog.logf log_tag Uslog.Info "section at address 0x%08x, size=0x%08x padding=0x%08x" !uobj_section_load_addr section_size !padding_size;
				uobj_section_load_addr := !uobj_section_load_addr + section_size;
			)  o_uobj_sections_hashtbl;

			(* check to see if the uobj sections fit neatly into uobj size *)
			(* if not, add a filler section to pad it to uobj size *)
			if (!uobj_section_load_addr - uobj_load_addr) > uobjsize then
				begin
					Uslog.logf log_tag Uslog.Error "uobj total section sizes (0x%08x) span beyond uobj size (0x%08x)!" (!uobj_section_load_addr - uobj_load_addr) uobjsize;
					ignore(exit 1);
				end
			;	

			if (!uobj_section_load_addr - uobj_load_addr) < uobjsize then
				begin
					(* add padding section *)
					Hashtbl.add uobj_sections_memory_map_hashtbl "usuobj_padding" 
						{ f_name = "usuobj_padding";	
						 	f_subsection_list = [ ];	
							usbinformat = { f_type = Usconfig.def_USBINFORMAT_SECTION_TYPE_PADDING;
															f_prot=0; 
															f_addr_start = !uobj_section_load_addr; 
															f_size = (uobjsize - (!uobj_section_load_addr - uobj_load_addr));
															f_addr_file = 0;
															f_aligned_at = !Usconfig.section_alignment; f_pad_to = !Usconfig.section_alignment; f_reserved = 0;
														};
						};
					Hashtbl.add uobj_sections_memory_map_hashtbl_byorigin !uobj_section_load_addr 
						{ f_name = "usuobj_padding";	
						 	f_subsection_list = [ ];	
							usbinformat = { f_type = Usconfig.def_USBINFORMAT_SECTION_TYPE_PADDING;
															f_prot=0; 
															f_addr_start = !uobj_section_load_addr; 
															f_size = (uobjsize - (!uobj_section_load_addr - uobj_load_addr));
															f_addr_file = 0;
															f_aligned_at = !Usconfig.section_alignment; f_pad_to = !Usconfig.section_alignment; f_reserved = 0;
														};
						};
				end
			;	
						
			o_uobj_size := uobjsize;
			(!o_uobj_size)
		;





		(*--------------------------------------------------------------------------*)
		(* compile a uobj cfile *)
		(* cfile_list = list of cfiles *)
		(* cc_includedirs_list = list of include directories *)
		(* cc_defines_list = list of definitions *)
		(*--------------------------------------------------------------------------*)
		method compile_cfile_list cfile_list cc_includedirs_list cc_defines_list =
			List.iter (fun x ->  
									Uslog.logf log_tag Uslog.Info "Compiling: %s" x;
									(*let (pestatus, pesignal, cc_outputfilename) = 
										(Usextbinutils.compile_cfile x (x ^ ".o") cc_includedirs_list cc_defines_list) in
											begin
												if (pesignal == true) || (pestatus != 0) then
													begin
															(* Uslog.logf log_mpf Uslog.Info "output lines:%u" (List.length poutput); *)
															(* List.iter (fun y -> Uslog.logf log_mpf Uslog.Info "%s" !y) poutput; *) 
															(* Uslog.logf log_mpf Uslog.Info "%s" !(List.nth poutput 0); *)
															Uslog.logf log_tag Uslog.Error "in compiling %s!" x;
															ignore(exit 1);
													end
												else
													begin
															Uslog.logf log_tag Uslog.Info "Compiled %s successfully" x;
													end
											end*)
								) cfile_list;
								
			()
		;

		(*--------------------------------------------------------------------------*)
		(* consolidate h-files and embed sentinel declarations *)
		(*--------------------------------------------------------------------------*)
		method generate_uobj_hfile
			() = 
			Uslog.logf log_tag Uslog.Info "Generating uobj hfile...";

			(* create uobj hfile *)
			let uobj_hfilename = 
					(self#get_o_uobj_dir_abspathname ^ "/" ^ 
						(Usconfig.get_uobj_hfilename ()) ^ ".h") in
			let oc = open_out uobj_hfilename in
			
			(* generate hfile prologue *)
			Printf.fprintf oc "\n/* autogenerated uberSpark uobj top-level header */";
			Printf.fprintf oc "\n/* author: amit vasudevan (amitvasudevan@acm.org) */";
			Printf.fprintf oc "\n";
			Printf.fprintf oc "\n";
			Printf.fprintf oc "\n#ifndef __%s_h__" self#get_o_usmf_hdr_id;
			Printf.fprintf oc "\n#define __%s_h__" self#get_o_usmf_hdr_id;
			Printf.fprintf oc "\n";
			Printf.fprintf oc "\n";

			(* bring in all the contents of the individual h-files *)
			List.iter (fun x ->
				let hfilename = (self#get_o_uobj_dir_abspathname ^ "/" ^ x) in 
				(* Uslog.logf log_tag Uslog.Info "h-file: %s" x; *)

				Printf.fprintf oc "\n#ifndef __%s_%s_h__" self#get_o_usmf_hdr_id (Filename.chop_extension x);
				Printf.fprintf oc "\n#define __%s_%s_h__" self#get_o_usmf_hdr_id (Filename.chop_extension x);
				Printf.fprintf oc "\n";
				Printf.fprintf oc "\n";

				let ic = open_in hfilename in
				try
    			while true do
      			let line = input_line ic in
      			Printf.fprintf oc "%s\n" line;
    			done
  			with End_of_file -> ();				
				close_in ic;
	
				Printf.fprintf oc "\n";
				Printf.fprintf oc "\n";
				Printf.fprintf oc "\n#endif //__%s_%s_h__" self#get_o_usmf_hdr_id (Filename.chop_extension x);
				Printf.fprintf oc "\n";
				Printf.fprintf oc "\n";
			) self#get_o_usmf_sources_h_files;

		  (* plug in sentinel declarations *)
			Printf.fprintf oc "\n/* sentinel declarations follow */";
			Printf.fprintf oc "\n";
			Printf.fprintf oc "\n#ifndef __ASSEMBLY__";

			Hashtbl.iter (fun key (x:sentinel_info_t)  ->
				Uslog.logf log_tag Uslog.Info "key=%s" key;
				let sentinel_fname = x.s_fname ^ 
													"_" ^	x.s_type ^ "_" ^ !o_usmf_hdr_platform ^ "_" ^
													!o_usmf_hdr_cpu ^ "_" ^ !o_usmf_hdr_arch in

				Printf.fprintf oc "\n";
				Printf.fprintf oc "\n#ifdef %s" self#get_o_pp_definition;
				Printf.fprintf oc "\n\t%s %s %s;" x.s_retvaldecl x.s_fname
						x.s_fparamdecl;	
				Printf.fprintf oc "\n#else";
				let sentinel_type_definition_string = 
					List.assoc x.s_type (Usconfig.get_sentinel_types ()) in	
				Printf.fprintf oc "\n";
				Printf.fprintf oc "\n\t%s %s %s;" x.s_retvaldecl sentinel_fname
						x.s_fparamdecl;

				Printf.fprintf oc "\n#ifdef %s" ("ENFORCE_" ^ sentinel_type_definition_string);
					Printf.fprintf oc "\n#define %s %s" x.s_fname sentinel_fname;
				Printf.fprintf oc "\n#endif //%s" ("ENFORCE_" ^ sentinel_type_definition_string);
				
				Printf.fprintf oc "\n#endif //%s" self#get_o_pp_definition;
				Printf.fprintf oc "\n";

			) self#get_o_uobj_publicmethods_sentinels_hashtbl;

			(* now print out the last entry of the sentinel equal to the call *)


			Printf.fprintf oc "\n#endif //__ASSEMBLY__";
			Printf.fprintf oc "\n";

			(* generate hfile epilogue *)
			Printf.fprintf oc "\n";
			Printf.fprintf oc "\n";
			Printf.fprintf oc "\n#endif //__%s_h__" self#get_o_usmf_hdr_id;
			Printf.fprintf oc "\n";
			Printf.fprintf oc "\n";
				
			(* close uobj hfile *)	
			close_out oc;
			Uslog.logf log_tag Uslog.Info "Generated uobj hfile.";
			(uobj_hfilename)
		;


		(*--------------------------------------------------------------------------*)
		(* generate uobj sentinels *)
		(*--------------------------------------------------------------------------*)
		(*
		method generate_sentinels 
			() = 
			Uslog.logf log_tag Uslog.Info "Generating sentinels for target (%s-%s-%s)...\r\n"
				!o_usmf_hdr_platform !o_usmf_hdr_cpu !o_usmf_hdr_arch;

			Hashtbl.iter (fun key (x:sentinel_info_t)  ->
				let sentinel_fname = "sentinel-" ^ x.s_type ^ "-" ^ 
						!o_usmf_hdr_platform ^ "-" ^ !o_usmf_hdr_cpu ^ "-" ^ 
						!o_usmf_hdr_arch ^ ".S" in
				let target_sentinel_fname = "sentinel-" ^ x.s_fname ^ "-" ^ x.s_type ^ "-" ^ 
						!o_usmf_hdr_platform ^ "-" ^ !o_usmf_hdr_cpu ^ "-" ^ 
						!o_usmf_hdr_arch ^ ".S" in
					
				let (pp_retval, _) = Usextbinutils.preprocess 
											((Usconfig.get_sentinel_dir ()) ^ "/" ^ sentinel_fname) 
											(self#get_o_uobj_dir_abspathname ^ "/" ^ target_sentinel_fname) 
											(Usconfig.get_std_incdirs ())
											(Usconfig.get_std_defines () @ 
												Usconfig.get_std_define_asm () @
												[ self#get_o_pp_definition ] @
												[ "UOBJ_ENTRY_POINT_FNAME=" ^ x.s_fname 
												] @
												[ "UOBJ_SENTINEL_SECTION_NAME=." ^ key
												] @
												[ "UOBJ_SENTINEL_ENTRY_POINT_FNAME=" ^ x.s_fname ^ 
													"_" ^	x.s_type ^ "_" ^ !o_usmf_hdr_platform ^ "_" ^
													!o_usmf_hdr_cpu ^ "_" ^ !o_usmf_hdr_arch
												]) in
					if (pp_retval != 0) then
						begin
								Uslog.logf log_tag Uslog.Error "in generating sentinel: %s"
									target_sentinel_fname;
								ignore(exit 1);
						end
					;
				
				
				o_sentinels_source_file_list := !o_sentinels_source_file_list @ 
					[ target_sentinel_fname ];

			) o_uobj_publicmethods_sentinels_hashtbl;

			Uslog.logf log_tag Uslog.Info "Generated sentinels.";
			()
		;
		

		(*--------------------------------------------------------------------------*)
		(* generate uobj sentinels lib *)
		(*--------------------------------------------------------------------------*)
		method generate_sentinels_lib 
			() = 
			Uslog.logf log_tag Uslog.Info "Generating sentinels lib for target (%s-%s-%s)..."
				!o_usmf_hdr_platform !o_usmf_hdr_cpu !o_usmf_hdr_arch;

			Hashtbl.iter (fun key (x:sentinel_info_t)  ->
				let sentinel_libfname = "libsentinel-" ^ x.s_type ^ "-" ^ 
						!o_usmf_hdr_platform ^ "-" ^ !o_usmf_hdr_cpu ^ "-" ^ 
						!o_usmf_hdr_arch ^ ".S" in
				let target_sentinel_libfname = "libsentinel-" ^ x.s_fname ^ "-" ^ x.s_type ^ "-" ^ 
						!o_usmf_hdr_platform ^ "-" ^ !o_usmf_hdr_cpu ^ "-" ^ 
						!o_usmf_hdr_arch ^ ".S" in
				let x_v = Hashtbl.find uobj_sections_memory_map_hashtbl key in
				
				let (pp_retval, _) = Usextbinutils.preprocess 
											((Usconfig.get_sentinel_dir ()) ^ "/" ^ sentinel_libfname) 
											(self#get_o_uobj_dir_abspathname ^ "/" ^ target_sentinel_libfname) 
											(Usconfig.get_std_incdirs ())
											(Usconfig.get_std_defines () @ 
												Usconfig.get_std_define_asm () @
												[ self#get_o_pp_definition ] @
												[ "UOBJ_SENTINEL_ENTRY_POINT=" ^ 
													(Printf.sprintf "0x%08x" x_v.usbinformat.f_addr_start)
												] @
												[ "UOBJ_SENTINEL_SECTION_NAME=.text"
												] @
												[ "UOBJ_SENTINEL_ENTRY_POINT_FNAME=" ^ x.s_fname ^ 
													"_" ^	x.s_type ^ "_" ^ !o_usmf_hdr_platform ^ "_" ^
													!o_usmf_hdr_cpu ^ "_" ^ !o_usmf_hdr_arch
												]) in
					if (pp_retval != 0) then
						begin
								Uslog.logf log_tag Uslog.Error "in generating sentinel lib: %s"
									target_sentinel_libfname;
								ignore(exit 1);
						end
					;
				
												
				o_uobj_publicmethods_sentinels_lib_source_file_list := !o_uobj_publicmethods_sentinels_lib_source_file_list @ 
					[ target_sentinel_libfname ];
						
			) o_uobj_publicmethods_sentinels_hashtbl;

			Uslog.logf log_tag Uslog.Info "Generated sentinels lib.";
			()
		;
		*)

		(*--------------------------------------------------------------------------*)
		(* compile uobj sentinels *)
		(*--------------------------------------------------------------------------*)
		method compile_sentinels 
			() = 
			Uslog.logf log_tag Uslog.Info "Building sentinels for target (%s-%s-%s)...\r\n"
				!o_usmf_hdr_platform !o_usmf_hdr_cpu !o_usmf_hdr_arch;

			(* compile all the sentinel source files *)							
			self#compile_cfile_list !o_sentinels_source_file_list
					(Usconfig.get_std_incdirs ())
					(Usconfig.get_std_defines () @ 
					[ self#get_o_pp_definition ] @
								Usconfig.get_std_define_asm ());

			Uslog.logf log_tag Uslog.Info "Built sentinels.";
			()
		;


		(*--------------------------------------------------------------------------*)
		(* compile uobj sentinels lib *)
		(*--------------------------------------------------------------------------*)
		method compile_sentinels_lib 
			() = 
			(*let uobj_sentinels_lib_name = "lib" ^ (self#get_o_usmf_hdr_id) ^ "-" ^
				!o_usmf_hdr_platform ^ "-" ^ !o_usmf_hdr_cpu ^ "-" ^ !o_usmf_hdr_arch in*)
				
			Uslog.logf log_tag Uslog.Info "Building sentinels lib: %s...\r\n"
				self#get_o_uobj_publicmethods_sentinels_libname;

			(* compile all the sentinel lib source files *)							
			self#compile_cfile_list !o_uobj_publicmethods_sentinels_lib_source_file_list
					(Usconfig.get_std_incdirs ())
					(Usconfig.get_std_defines () @
					[ self#get_o_pp_definition ] @ 
								Usconfig.get_std_define_asm ());

(*						
			(* now create the lib archive *)
			let (pestatus, pesignal) = 
					(Usextbinutils.mklib  
						!o_uobj_publicmethods_sentinels_lib_source_file_list
						(self#get_o_uobj_publicmethods_sentinels_libname ^ ".a")
					) in
					if (pesignal == true) || (pestatus != 0) then
						begin
								Uslog.logf log_tag Uslog.Error "in building sentinel lib!";
								ignore(exit 1);
						end
					else
						begin
								Uslog.logf log_tag Uslog.Info "Built sentinels lib.";
						end
					;
*)
		
			()
		;



				(*let x_v = Hashtbl.find uobj_sections_memory_map_hashtbl key in

				Uslog.logf log_tag Uslog.Info "%s/%s at 0x%08x" 
					(Usconfig.get_sentinel_dir ()) sentinel_fname x_v.s_origin;
				*)


		(*--------------------------------------------------------------------------*)
		(* compile a uobj *)
		(* build_dir = directory to use for building *)
		(* keep_temp_files = true if temporary files need to be preserved in build_dir *)
		(*--------------------------------------------------------------------------*)
		method compile 
			(build_dir : string)
			(keep_temp_files : bool) = 
	
			Uslog.logf log_tag Uslog.Info "Starting compilation in '%s' [%b]\n" build_dir keep_temp_files;
			
			Uslog.logf log_tag Uslog.Info "cfiles_count=%u, casmfiles_count=%u\n"
						(List.length !o_usmf_sources_c_files) 
						(List.length !o_usmf_sources_casm_files);

			(* generate uobj top-level header *)
			self#generate_uobj_hfile ();
	
			(* generate sentinels *)
			(* TBD: hook in later *)
			(* self#generate_sentinels (); *)

			(* generate sentinels lib *)
			(* TBD: hook in later *)
			(* self#generate_sentinels_lib (); *)

			(* compile all sentinels *)							
			self#compile_sentinels ();
									
			(* compile sentinels lib *)
			self#compile_sentinels_lib ();						

			(* compile all the cfiles *)
			(* TBD: hook in later *)
			(*							
			self#compile_cfile_list (!o_usmf_sources_c_files) 
					(Usconfig.get_std_incdirs ())
					(Usconfig.get_std_defines () @ [ self#get_o_pp_definition ]);
			*)			

			Uslog.logf log_tag Uslog.Info "Compilation finished.\r\n";
			()
		;

(*
	(*--------------------------------------------------------------------------*)
	(* generate uobj info table *)
	(*--------------------------------------------------------------------------*)
	method generate_uobj_info ochannel = 
		let i = ref 0 in 
		
		Printf.fprintf ochannel "\n";
    Printf.fprintf ochannel "\n	//%s" (!o_usmf_hdr_id);
    Printf.fprintf ochannel "\n	{";

	  (* total_sentinels *)
  	Printf.fprintf ochannel "\n\t0x%08xUL, " (Hashtbl.length o_uobj_publicmethods_sentinels_hashtbl);
		
		(* plug in the sentinels *)
		Printf.fprintf ochannel "\n\t{";
		Hashtbl.iter (fun key (x:sentinel_info_t)  ->
			let x_v = Hashtbl.find uobj_sections_memory_map_hashtbl key in
			Printf.fprintf ochannel "\n\t\t{";
		  	Printf.fprintf ochannel "\n\t\t\t0x%08xUL, " (int_of_string(x.s_type_id));
		  	Printf.fprintf ochannel "\n\t\t\t0x%08xUL, " (0);
		  	Printf.fprintf ochannel "\n\t\t\t0x%08xUL, " (x_v.usbinformat.f_va_offset);
		  	Printf.fprintf ochannel "\n\t\t\t0x%08xUL " (x.s_length);
			Printf.fprintf ochannel "\n\t\t},";
		)  o_uobj_publicmethods_sentinels_hashtbl;
		Printf.fprintf ochannel "\n\t},";

		(*ustack_tos*)
    let info = Hashtbl.find uobj_sections_memory_map_hashtbl 
			(Usconfig.get_section_name_ustack()) in
		let ustack_size = (Usconfig.get_sizeof_uobj_ustack()) in
		let ustack_tos = ref 0 in
		ustack_tos := info.usbinformat.f_va_offset + ustack_size;
		Printf.fprintf ochannel "\n\t{";
		i := 0;
		while (!i < (Usconfig.get_std_max_platform_cpus ())) do
		    Printf.fprintf ochannel "\n\t\t0x%08xUL," !ustack_tos;
				i := !i + 1;
				ustack_tos := !ustack_tos + ustack_size;
		done;
    Printf.fprintf ochannel "\n\t},";

		(*tstack_tos*)
    let info = Hashtbl.find uobj_sections_memory_map_hashtbl 
			(Usconfig.get_section_name_tstack()) in
		let tstack_size = (Usconfig.get_sizeof_uobj_tstack()) in
		let tstack_tos = ref 0 in
		tstack_tos := info.usbinformat.f_va_offset + tstack_size;
		Printf.fprintf ochannel "\n\t{";
		i := 0;
		while (!i < (Usconfig.get_std_max_platform_cpus ())) do
		    Printf.fprintf ochannel "\n\t\t0x%08xUL," !tstack_tos;
				i := !i + 1;
				tstack_tos := !tstack_tos + tstack_size;
		done;
    Printf.fprintf ochannel "\n\t},";
																								
    Printf.fprintf ochannel "\n	}";
		Printf.fprintf ochannel "\n";

		()
	;

*)

(*
	(*--------------------------------------------------------------------------*)
	(* generate uobj header *)
	(*--------------------------------------------------------------------------*)
	method generate_uobj_hdr 
			(uobj_name : string) 
			(uobj_load_addr : int)
			(*(uobj_sections_list : string list list)*)
			uobj_sections_hashtbl
			: string  =
		let uobj_hdr_filename = (uobj_name ^ ".hdr.c") in
		let oc = open_out uobj_hdr_filename in
			Printf.fprintf oc "\n/* autogenerated uberSpark uobj header */";
			Printf.fprintf oc "\n/* author: amit vasudevan (amitvasudevan@acm.org) */";
			Printf.fprintf oc "\n";
			Printf.fprintf oc "\n";
	
			Printf.fprintf oc "\n#include <uberspark.h>";
			Printf.fprintf oc "\n";

			Printf.fprintf oc "\n__attribute__((section (\".hdr\"))) uobj_info_t __uobj_info =";
			self#generate_uobj_info oc;
			Printf.fprintf oc ";";
			
			
			Printf.fprintf oc "\n__attribute__((section (\".ustack\"))) uint8_t __ustack[MAX_PLATFORM_CPUS * USCONFIG_SIZEOF_UOBJ_USTACK]={ 0 };";
			Printf.fprintf oc "\n__attribute__((section (\".tstack\"))) uint8_t __tstack[MAX_PLATFORM_CPUS * USCONFIG_SIZEOF_UOBJ_TSTACK]={ 0 };";
	
			(* iterate over regular sections *)
			Hashtbl.iter (fun key (x:Ustypes.section_info_t)  ->
				(* new section *)
				let section_name_var = ("__uobjsection_filler_" ^ x.f_name) in
				
				  if ((compare (List.nth x.f_subsection_list 0) ".text") <> 0) && 
						((compare (List.nth x.f_subsection_list 0) ".ustack") <> 0) &&
						((compare (List.nth x.f_subsection_list 0) ".tstack") <> 0) &&
						((compare (List.nth x.f_subsection_list 0) ".hdr") <> 0) then
						begin
							Printf.fprintf oc "\n__attribute__((section (\"%s\"))) uint8_t %s[1]={ 0 };"
								(List.nth x.f_subsection_list 0) section_name_var;
						end
					;
			)  uobj_sections_hashtbl;
	
			Printf.fprintf oc "\n";
			Printf.fprintf oc "\n";
				
			close_out oc;
		(uobj_hdr_filename)
	; 
*)

	(*--------------------------------------------------------------------------*)
	(* install uobj *)
	(*--------------------------------------------------------------------------*)
	method install 
			(install_dir : string) 
			=
			
			(* create uobj installation folder if not already existing *)
			let uobj_install_dir = (install_dir ^ "/" ^ !o_usmf_hdr_id) in
				Uslog.logf log_tag Uslog.Info "Installing uobj: '%s'..." uobj_install_dir;
			let (retval, retecode, retemsg) = Usosservices.mkdir uobj_install_dir 0o755 in
				if (retval == false) && (retecode != Unix.EEXIST) then 
				begin
					Uslog.logf log_tag Uslog.Error "error in creating directory: %s" retemsg;
				end
				;

			(* copy uobj manifest *)
			Usosservices.file_copy (!o_uobj_dir_abspathname ^ "/" ^ !o_usmf_filename)
				(uobj_install_dir ^ "/" ^ Usconfig.std_uobj_usmf_name); 
			
			(* copy uobj header file *)
			Usosservices.file_copy (!o_uobj_dir_abspathname ^ "/" ^ 
															Usconfig.uobj_hfilename ^ ".h")
				(install_dir ^ "/" ^ !o_usmf_hdr_id ^ ".h"); 
	
			(* copy sentinels lib *)
			Usosservices.file_copy (!o_uobj_dir_abspathname ^ "/" ^ 
															self#get_o_uobj_publicmethods_sentinels_libname ^ ".a")
				(uobj_install_dir ^ "/" ^ self#get_o_uobj_publicmethods_sentinels_libname ^ ".a"); 
			
							
		()
	; 

end ;;

end


(*---------------------------------------------------------------------------*)
(* potpourri *)
(*---------------------------------------------------------------------------*)
(*		
						(*slab_tos*)
    Printf.fprintf oc "\n\t{";
		i := 0;
		while (!i < Usconfig.get_std_max_platform_cpus) do
		    (* Printf.fprintf oc "\n\t\t   %s + (1*XMHF_SLAB_STACKSIZE)," (Hashtbl.find slab_idtostack_addrstart !i);*)
		    Printf.fprintf oc "\n\t\t0x00000000UL,";
				i := !i + 1;
		done;
    Printf.fprintf oc "\n\t},";

		Printf.fprintf oc "\n\t0x00000000UL, ";    (*slab_callcaps*)
    Printf.fprintf oc "\n\ttrue,";             (*slab_uapisupported*)
		
		(*slab_uapicaps*)
    Printf.fprintf oc "\n\t{";
		i := 0;
		while (!i < total_uobjs) do
		    Printf.fprintf oc "\n\t\t0x00000000UL,";
				i := !i + 1;
		done;
    Printf.fprintf oc "\n\t},";

		Printf.fprintf oc "\n\t0x00000000UL, ";    (*slab_memgrantreadcaps*)
		Printf.fprintf oc "\n\t0x00000000UL, ";    (*slab_memgrantwritecaps*)

		(*incl_devices*)
    Printf.fprintf oc "\n\t{";
		i := 0;
		while (!i < get_std_max_incldevlist_entries) do
		    Printf.fprintf oc "\n\t\t{0x00000000UL,0x00000000UL},";
				i := !i + 1;
		done;
    Printf.fprintf oc "\n\t},";

		Printf.fprintf oc "\n\t0x00000000UL, ";    (*incl_devices_count*)

		(*excl_devices*)
    Printf.fprintf oc "\n\t{";
		i := 0;
		while (!i < get_std_max_excldevlist_entries) do
		    Printf.fprintf oc "\n\t\t{0x00000000UL,0x00000000UL},";
				i := !i + 1;
		done;
    Printf.fprintf oc "\n\t},";
		
		Printf.fprintf oc "\n\t0x00000000UL, ";    (*excl_devices_count*)

		(*excl_devices*)
    Printf.fprintf oc "\n\t{";
		i := 0;
		while (!i < get_std_max_excldevlist_entries) do
		    Printf.fprintf oc "\n\t\t{0x00000000UL,0x00000000UL},";
				i := !i + 1;
		done;
    Printf.fprintf oc "\n\t},";
*)

(*
 		type section_info_t = 
			{
				origin: int;
				length: int;	
				subsection_list : string list;
			};;
		val uobj_sections_memory_map_hashtbl = ((Hashtbl.create 32) : ((string, section_info_t)  Hashtbl.t)); 
	
			Hashtbl.add uobj_sections_hashtbl "sample" { origin=0; length=0; subsection_list = ["one"; "two"; "three"]};
			let mysection = Hashtbl.find uobj_sections_hashtbl "sample" in
				Uslog.logf log_tag Uslog.Info "origin=%u" mysection.origin;
*)
