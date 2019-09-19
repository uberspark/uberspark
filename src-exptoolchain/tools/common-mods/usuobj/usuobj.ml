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


		type uobj_publicmethods_t = 
			{
				f_name: string;
				f_retvaldecl : string;
				f_paramdecl: string;
				f_paramdwords : int;
			};;


		

class uobject = object(self)

		val log_tag = "Usuobj";
		val d_ltag = "Usuobj";

		val d_mf_filename = ref "";
		method get_d_mf_filename = !d_mf_filename;

		val d_path_ns = ref "";
		method get_d_path_ns = !d_path_ns;

		val d_hdr: Usmanifest.hdr_t = {f_type = ""; f_namespace = ""; f_platform = ""; f_arch = ""; f_cpu = ""};
		method get_d_hdr = d_hdr;


		val d_sources_h_file_list: string list ref = ref [];
		method get_d_sources_h_file_list = !d_sources_h_file_list;

		val d_sources_c_file_list: string list ref = ref [];
		method get_d_sources_c_file_list = !d_sources_c_file_list;

		val d_sources_casm_file_list: string list ref = ref [];
		method get_d_sources_casm_file_list = !d_sources_casm_file_list;

		val d_publicmethods_hashtbl = ((Hashtbl.create 32) : ((string, uobj_publicmethods_t)  Hashtbl.t)); 
		method get_d_publicmethods_hashtbl = d_publicmethods_hashtbl;

		val d_callees_hashtbl = ((Hashtbl.create 32) : ((string, string list)  Hashtbl.t)); 
		method get_d_callees_hashtbl = d_callees_hashtbl;

		val d_exitcallees_list : string list ref = ref [];
		method get_d_exitcallees_list = !d_exitcallees_list;





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

		val d_sections_hashtbl = ((Hashtbl.create 32) : ((string, Ustypes.section_info_t)  Hashtbl.t)); 
		method get_d_sections_hashtbl = d_sections_hashtbl;
		
	

	
		val o_uobj_publicmethods_sentinels_hashtbl = ((Hashtbl.create 32) : ((string, sentinel_info_t)  Hashtbl.t)); 
		method get_o_uobj_publicmethods_sentinels_hashtbl = o_uobj_publicmethods_sentinels_hashtbl;

		val o_uobj_publicmethods_sentinels_libname = ref "";
		method get_o_uobj_publicmethods_sentinels_libname = !o_uobj_publicmethods_sentinels_libname;

		val o_uobj_publicmethods_sentinels_lib_source_file_list : string list ref = ref [];
		method get_o_uobj_publicmethods_sentinels_lib_source_file_list = !o_uobj_publicmethods_sentinels_lib_source_file_list;



	


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

		
	

		
		(*--------------------------------------------------------------------------*)
		(* parse manifest node "uobj-sources" *)
		(* return true on successful parse, false if not *)
		(* return: if true then store lists of h-files, c-files and casm files *)
		(*--------------------------------------------------------------------------*)
		method parse_node_mf_uobj_sources mf_json =
			let retval = ref true in
			try
				let open Yojson.Basic.Util in
					let mf_uobj_sources_json = mf_json |> member "uobj-sources" in
					if mf_uobj_sources_json != `Null then
							begin

								let mf_hfiles_json = mf_uobj_sources_json |> member "h-files" in
									if mf_hfiles_json != `Null then
										begin
											let hfiles_json_list = mf_hfiles_json |> 
													to_list in 
												List.iter (fun x -> d_sources_h_file_list := 
														!d_sources_h_file_list @ [(x |> to_string)]
													) hfiles_json_list;
										end
									;

								let mf_cfiles_json = mf_uobj_sources_json |> member "c-files" in
									if mf_cfiles_json != `Null then
										begin
											let cfiles_json_list = mf_cfiles_json |> 
													to_list in 
												List.iter (fun x -> d_sources_c_file_list := 
														!d_sources_c_file_list @ [(x |> to_string)]
													) cfiles_json_list;
										end
									;

								let mf_casmfiles_json = mf_uobj_sources_json |> member "casm-files" in
									if mf_casmfiles_json != `Null then
										begin
											let casmfiles_json_list = mf_casmfiles_json |> 
													to_list in 
												List.iter (fun x -> d_sources_casm_file_list := 
														!d_sources_casm_file_list @ [(x |> to_string)]
													) casmfiles_json_list;
										end
									;
									
							end
						;
						
			with Yojson.Basic.Util.Type_error _ -> 
					retval := false;
			;
		
			(!retval)
		;
	

	  (*--------------------------------------------------------------------------*)
		(* parse manifest node "uobj-publicmethods" *)
		(* return true on successful parse, false if not *)
		(* return: if true then list public methods *)
		(*--------------------------------------------------------------------------*)
		method parse_node_mf_uobj_publicmethods mf_json =
			let retval = ref false in

			try
				let open Yojson.Basic.Util in
					let uobj_publicmethods_json = mf_json |> member "uobj-publicmethods" in
						if uobj_publicmethods_json != `Null then
							begin

								let uobj_publicmethods_assoc_list = Yojson.Basic.Util.to_assoc uobj_publicmethods_json in
									retval := true;
									
									List.iter (fun (x,y) ->
										let uobj_publicmethods_inner_list = (Yojson.Basic.Util.to_list y) in 
										if (List.length uobj_publicmethods_inner_list) <> 3 then
											begin
												retval := false;
											end
										else
											begin
												Hashtbl.add d_publicmethods_hashtbl (x) 
												{
													f_name = x;
													f_retvaldecl = (List.nth uobj_publicmethods_inner_list 0) |> to_string;
													f_paramdecl = (List.nth uobj_publicmethods_inner_list 1) |> to_string;
													f_paramdwords = int_of_string ((List.nth uobj_publicmethods_inner_list 2) |> to_string );
												};
														
												retval := true; 
											end
										;
							
										()
									) uobj_publicmethods_assoc_list;

							end
						;
																
			with Yojson.Basic.Util.Type_error _ -> 
					retval := false;
			;

									
			(!retval)
		;


		(*--------------------------------------------------------------------------*)
		(* parse manifest node "uobj-callees" *)
		(* return true on successful parse, false if not *)
		(* return: if true then populate hashtable of callees*)
		(*--------------------------------------------------------------------------*)
		method parse_node_mf_uobj_callees mf_json =
			let retval = ref true in

			try
				let open Yojson.Basic.Util in
					let uobj_callees_json = mf_json |> member "uobj-callees" in
						if uobj_callees_json != `Null then
							begin

								let uobj_callees_assoc_list = Yojson.Basic.Util.to_assoc uobj_callees_json in
									retval := true;
									List.iter (fun (x,y) ->
											let uobj_callees_attribute_list = ref [] in
												List.iter (fun z ->
													uobj_callees_attribute_list := !uobj_callees_attribute_list @
																			[ (z |> to_string) ];
													()
												)(Yojson.Basic.Util.to_list y);
												
												Hashtbl.add d_callees_hashtbl x !uobj_callees_attribute_list;
											()
										) uobj_callees_assoc_list;
							end
						;
																
			with Yojson.Basic.Util.Type_error _ -> 
					retval := false;
			;

									
			(!retval)
		;



		(*--------------------------------------------------------------------------*)
		(* parse manifest node "uobj-exitcallees" *)
		(* return true on successful parse, false if not *)
		(* return: if true then populate list of exitcallees function names *)
		(*--------------------------------------------------------------------------*)
		method parse_node_mf_uobj_exitcallees mf_json =
			let retval = ref true in

			try
				let open Yojson.Basic.Util in
					let uobj_exitcallees_json = mf_json |> member "uobj-exitcallees" in
						if uobj_exitcallees_json != `Null then
							begin
								let uobj_exitcallees_json_list = uobj_exitcallees_json |> 
										to_list in 
									List.iter (fun x -> d_exitcallees_list := 
											!d_exitcallees_list @ [(x |> to_string)]
										) uobj_exitcallees_json_list;
							end
						;
		
			with Yojson.Basic.Util.Type_error _ -> 
					retval := false;
			;
		
			(!retval)
		;


		(*--------------------------------------------------------------------------*)
		(* parse manifest node "uobj-binary/uobj-sections" *)
		(* return true on successful parse, false if not *)
		(* return: if true then populate list of sections *)
		(*--------------------------------------------------------------------------*)
		method parse_node_mf_uobj_binary mf_json =
		let retval = ref false in

		try
		let open Yojson.Basic.Util in
			let uobj_binary_json = mf_json |> member "uobj-binary" in
				if uobj_binary_json != `Null then
					begin

						let uobj_sections_json = uobj_binary_json |> member "uobj-sections" in
							if uobj_sections_json != `Null then
								begin
									
									let uobj_sections_assoc_list = Yojson.Basic.Util.to_assoc uobj_sections_json in
										retval := true;
										List.iter (fun (x,y) ->
												(* x = section name, y = list of section attributes *)
												let uobj_sections_attribute_list = (Yojson.Basic.Util.to_list y) in
													if (List.length uobj_sections_attribute_list  < 6 ) then
														begin
															Uslog.log ~lvl:Uslog.Error "insufficient entries within section attribute list for section: %s" x;															retval := false;
														end
													else
														begin
															let subsection_list = ref [] in 
															for index = 5 to ((List.length uobj_sections_attribute_list)-1) do 
																subsection_list := !subsection_list @	[ ((List.nth uobj_sections_attribute_list index) |> to_string) ]
															done;

															Hashtbl.add d_sections_hashtbl (x) 
															{ 
																f_name = (x);	
															 	f_subsection_list = !subsection_list;	
																usbinformat = { f_type = int_of_string ((List.nth uobj_sections_attribute_list 0) |> to_string); 
																								f_prot = int_of_string ((List.nth uobj_sections_attribute_list 1) |> to_string); 
																								f_size = int_of_string ((List.nth uobj_sections_attribute_list 2) |> to_string);
																								f_aligned_at = int_of_string ((List.nth uobj_sections_attribute_list 3) |> to_string); 
																								f_pad_to = int_of_string ((List.nth uobj_sections_attribute_list 4) |> to_string); 
																								f_addr_start=0; 
																								f_addr_file = 0;
																								f_reserved = 0;
																							};
															};
								
															retval := true;
														end
													;
												()
											) uobj_sections_assoc_list;
								end
							;		
				
					end
				;
														
		with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
		;

							
		(!retval)
		;




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
			let (rval, mf_json) = Usmanifest.read_manifest 
																self#get_d_mf_filename keep_temp_files in
			
			if (rval == false) then (false)
			else

			(* parse hdr node *)
			let (rval, hdr) =
								Usmanifest.parse_node_hdr mf_json in
			if (rval == false) then (false)
			else

			(* sanity check type to be uobj and store hdr*)
			if (compare hdr.f_type usmf_type_usuobj) <> 0 then (false)
			else
			let dummy = 0 in
				begin
					d_hdr.f_type <- hdr.f_type;								
					d_hdr.f_namespace <- hdr.f_namespace;
					d_hdr.f_platform <- hdr.f_platform;
					d_hdr.f_arch <- hdr.f_arch;
					d_hdr.f_cpu <- hdr.f_cpu;
				end;

			(* parse uobj-sources node *)
			let rval = (self#parse_node_mf_uobj_sources mf_json) in
	
			if (rval == false) then (false)
			else
			let dummy = 0 in
				begin
					Uslog.log "total sources: h files=%u, c files=%u, casm files=%u" 
						(List.length self#get_d_sources_h_file_list)
						(List.length self#get_d_sources_c_file_list)
						(List.length self#get_d_sources_casm_file_list);
				end;


			(* parse uobj-publicmethods node *)
			let rval = (self#parse_node_mf_uobj_publicmethods mf_json) in

			if (rval == false) then (false)
			else
			let dummy = 0 in
				begin
					Uslog.log "total public methods:%u" (Hashtbl.length self#get_d_publicmethods_hashtbl); 
				end;

			(* parse uobj-calles node *)
			let rval = (self#parse_node_mf_uobj_callees mf_json) in

			if (rval == false) then (false)
			else
			let dummy = 0 in
				begin
					Uslog.log "list of uobj-callees follows:";

					Hashtbl.iter (fun key value  ->
						Uslog.log "uobj=%s; callees=%u" key (List.length value);
					) self#get_d_callees_hashtbl;
				end;

			(* parse uobj-exitcallees node *)
			let rval = (self#parse_node_mf_uobj_exitcallees mf_json) in

			if (rval == false) then (false)
			else
			let dummy = 0 in
				begin
					Uslog.log "total exitcallees=%u" (List.length self#get_d_exitcallees_list);
				end;


			(* parse uobj-binary/uobj-sections node *)
			let rval = (self#parse_node_mf_uobj_binary mf_json) in

			if (rval == false) then (false)
			else
			let dummy = 0 in
			if (rval == true) then
				begin
					Uslog.log "binary sections override:%u" (Hashtbl.length self#get_d_sections_hashtbl);								
				end;
	
(*																											
			(* initialize uobj preprocess definition *)
			o_pp_definition := "__UOBJ_" ^ self#get_o_usmf_hdr_id ^ "__";

			(* initialize uobj sentinels lib name *)
			o_uobj_publicmethods_sentinels_libname := "lib" ^ (self#get_o_usmf_hdr_id) ^ "-" ^
				!o_usmf_hdr_platform ^ "-" ^ !o_usmf_hdr_cpu ^ "-" ^ !o_usmf_hdr_arch;
	
				*)
				
			(true)
		;

		

		(*--------------------------------------------------------------------------*)
		(* initialize *)
		(*--------------------------------------------------------------------------*)
		method initialize	= 
				

			(* add default uobj sections *)
			Hashtbl.add d_sections_hashtbl "uobj_hdr" 
				{ f_name = "uobj_hdr";	
				 	f_subsection_list = [ ".hdr" ];	
					usbinformat = { f_type= Usconfig.def_USBINFORMAT_SECTION_TYPE_UOBJ_HDR; 
													f_prot=0; 
													f_size = !Usconfig.section_size_general;
													f_aligned_at = !Usconfig.section_alignment; 
													f_pad_to = !Usconfig.section_alignment; 
													f_addr_start=0; 
													f_addr_file = 0;
													f_reserved = 0;
												};
				};

			Hashtbl.add o_uobj_sections_hashtbl "uobj_ustack" 
				{ f_name = "uobj_ustack";	
				 	f_subsection_list = [ ".ustack" ];	
					usbinformat = { f_type=Usconfig.def_USBINFORMAT_SECTION_TYPE_UOBJ_USTACK; 
													f_prot=0; 
													f_size = !Usconfig.section_size_general;
													f_aligned_at = !Usconfig.section_alignment;
													f_pad_to = !Usconfig.section_alignment; 
													f_addr_start=0; 
													f_addr_file = 0;
													f_reserved = 0;
												};
				};

			Hashtbl.add o_uobj_sections_hashtbl "uobj_tstack" 
				{ f_name = "uobj_tstack";	
				 	f_subsection_list = [ ".tstack"; ".stack" ];	
					usbinformat = { f_type=Usconfig.def_USBINFORMAT_SECTION_TYPE_UOBJ_TSTACK; 
													f_prot=0; 
													f_size = !Usconfig.section_size_general;
													f_aligned_at = !Usconfig.section_alignment;
													f_pad_to = !Usconfig.section_alignment; 
													f_addr_start=0; 
													f_addr_file = 0;
													f_reserved = 0;
												};
				};

			Hashtbl.add o_uobj_sections_hashtbl "uobj_code" 
				{ f_name = "uobj_code";	
				 	f_subsection_list = [ ".text" ];	
					usbinformat = { f_type=Usconfig.def_USBINFORMAT_SECTION_TYPE_UOBJ_CODE; 
													f_prot=0; 
													f_size = !Usconfig.section_size_general;
													f_aligned_at = !Usconfig.section_alignment; 
													f_pad_to = !Usconfig.section_alignment; 
													f_addr_start=0; 
													f_addr_file = 0;
													f_reserved = 0;
												};
				};

			Hashtbl.add o_uobj_sections_hashtbl "uobj_data" 
				{ f_name = "uobj_data";	
				 	f_subsection_list = [".data"; ".rodata"];	
					usbinformat = { f_type=Usconfig.def_USBINFORMAT_SECTION_TYPE_UOBJ_RWDATA; 
													f_prot=0; 
													f_size = !Usconfig.section_size_general;
													f_aligned_at = !Usconfig.section_alignment; 
													f_pad_to = !Usconfig.section_alignment;
													f_addr_start=0; 
													f_addr_file = 0;
													f_reserved = 0;
												};
				};
				
			Hashtbl.add o_uobj_sections_hashtbl "uobj_dmadata" 
				{ f_name = "uobj_dmadata";	
				 	f_subsection_list = [".dmadata"];	
					usbinformat = { f_type=Usconfig.def_USBINFORMAT_SECTION_TYPE_UOBJ_DMADATA;
													f_prot=0; 
													f_size = !Usconfig.section_size_general;
													f_aligned_at = !Usconfig.section_alignment; 
													f_pad_to = !Usconfig.section_alignment;
													f_addr_start=0; 
													f_addr_file = 0;
													f_reserved = 0;
												};
				};
			
			()	
		;





end




(*---------------------------------------------------------------------------*)
(* to be absorbed *)
(*---------------------------------------------------------------------------*)


(*




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
					(self#get_d_path_ns ^ "/" ^ 
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
				let hfilename = (self#get_d_path_ns ^ "/" ^ x) in 
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
			) self#get_d_sources_h_file_list;

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
											(self#get_d_path_ns ^ "/" ^ target_sentinel_fname) 
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
											(self#get_d_path_ns ^ "/" ^ target_sentinel_libfname) 
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
						(List.length !d_sources_c_file_list) 
						(List.length !d_sources_casm_file_list);

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
			Usosservices.file_copy (!d_path_ns ^ "/" ^ !d_mf_filename)
				(uobj_install_dir ^ "/" ^ Usconfig.std_uobj_usmf_name); 
			
			(* copy uobj header file *)
			Usosservices.file_copy (!d_path_ns ^ "/" ^ 
															Usconfig.uobj_hfilename ^ ".h")
				(install_dir ^ "/" ^ !o_usmf_hdr_id ^ ".h"); 
	
			(* copy sentinels lib *)
			Usosservices.file_copy (!d_path_ns ^ "/" ^ 
															self#get_o_uobj_publicmethods_sentinels_libname ^ ".a")
				(uobj_install_dir ^ "/" ^ self#get_o_uobj_publicmethods_sentinels_libname ^ ".a"); 
			
							
		()
	; 

end ;;


*)


(*---------------------------------------------------------------------------*)
(* potpourri *)
(*---------------------------------------------------------------------------*)


				(*let x_v = Hashtbl.find uobj_sections_memory_map_hashtbl key in

				Uslog.logf log_tag Uslog.Info "%s/%s at 0x%08x" 
					(Usconfig.get_sentinel_dir ()) sentinel_fname x_v.s_origin;
				*)



(*


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
						Hashtbl.iter (fun pm_key (pm: uobj_publicmethods_t) ->
				
						let sentinel_name = ref "" in
							sentinel_name := "sentinel_" ^ st.s_type ^ "_" ^ pm.f_name; 

						Hashtbl.add o_uobj_publicmethods_sentinels_hashtbl !sentinel_name 
							{
								s_type = st.s_type;
								s_type_id = st.s_type_id;
								s_retvaldecl = pm.f_retvaldecl;
								s_fname = pm.f_name;
								s_fparamdecl = pm.f_paramdecl;
								s_fparamdwords = pm.f_paramdwords;
								s_attribute = (Usconfig.get_sentinel_prot ());
								s_origin = 0;
								s_length = !Usconfig.section_size_sentinel;
							};
			
						) d_publicmethods_hashtbl;
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



*)




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
