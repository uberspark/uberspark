(*------------------------------------------------------------------------------
	uberSpark uberobject verification and build interface
	author: amit vasudevan (amitvasudevan@acm.org)
------------------------------------------------------------------------------*)


open Usconfig
open Uslog
open Usmanifest
open Usosservices
open Usextbinutils
open Usuobjgen

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

	
		val o_uobj_sections_hashtbl = ((Hashtbl.create 32) : ((string, Usextbinutils.ld_section_info_t)  Hashtbl.t)); 
		method get_o_uobj_sections_hashtbl = o_uobj_sections_hashtbl;


		val o_uobj_sentinels_hashtbl = ((Hashtbl.create 32) : ((string, sentinel_info_t)  Hashtbl.t)); 
		method get_o_uobj_sentinels_hashtbl = o_uobj_sentinels_hashtbl;

		val o_usmf_filename = ref "";
		method get_o_usmf_filename = !o_usmf_filename;

		val o_uobj_dir_abspathname = ref "";
		method get_o_uobj_dir_abspathname = !o_uobj_dir_abspathname;

		val o_uobj_sentinels_libname = ref "";
		method get_o_uobj_sentinels_libname = !o_uobj_sentinels_libname;


		val o_uobj_build_dirname = ref ".";
		method get_o_uobj_build_dirname = !o_uobj_build_dirname;
		
		val o_uobj_size = ref 0; 
		method get_o_uobj_size = !o_uobj_size;
		val o_uobj_load_addr = ref 0;
		method get_o_uobj_load_addr = !o_uobj_load_addr;
		
		val uobj_sections_memory_map_hashtbl = ((Hashtbl.create 32) : ((string, Usextbinutils.ld_section_info_t)  Hashtbl.t)); 
		val uobj_sections_memory_map_hashtbl_byorigin = ((Hashtbl.create 32) : ((int, Usextbinutils.ld_section_info_t)  Hashtbl.t)); 
		
		(* val mutable slab_idtoname = ((Hashtbl.create 32) : ((int,string)  Hashtbl.t)); *)

		val o_sentinels_source_file_list : string list ref = ref [];
		method get_o_sentinels_source_file_list = !o_sentinels_source_file_list;

		val o_sentinels_lib_source_file_list : string list ref = ref [];
		method get_o_sentinels_lib_source_file_list = !o_sentinels_lib_source_file_list;

		val o_pp_definition = ref "";
		method get_o_pp_definition = !o_pp_definition;





		(*--------------------------------------------------------------------------*)
		(* parse uobj manifest *)
		(* usmf_filename = canonical uobj manifest filename *)
		(* keep_temp_files = true if temporary files need to be preserved *)
		(*--------------------------------------------------------------------------*)
		method parse_manifest usmf_filename keep_temp_files =
			
				
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

			(* parse uobj-sentinels node *)
			let (rval, uobj_sentinels_list) = 
										Usmanifest.parse_node_uobj_sentinels mf_json in

			if (rval == false) then (false)
			else
			let dummy = 0 in
				begin
					List.iter (fun x ->

						(*make a unique name for this sentinel*)
						let sentinel_name = ref "" in
							sentinel_name := "sentinel_" ^ (List.nth x 0) ^ "_" ^ (List.nth x 2); 

						Hashtbl.add o_uobj_sentinels_hashtbl !sentinel_name 
							{
								s_type = (List.nth x 0);
								s_type_id = (List.nth x 1);
								s_retvaldecl = (List.nth x 2);
								s_fname = (List.nth x 3);
								s_fparamdecl = (List.nth x 4);
								s_fparamdwords = int_of_string (List.nth x 5);
								s_attribute = (List.nth x 6);
								s_origin = 0;
								s_length = int_of_string (List.nth x 7);
							};
						
					) uobj_sentinels_list;
				end;


			(* parse uobj-sections node *)
			let (rval, uobj_sections_list) = 
										Usmanifest.parse_node_uobj_binary mf_json in

			if (rval == false) then (false)
			else
			let dummy = 0 in
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


						Hashtbl.add o_uobj_sections_hashtbl (List.nth x 0) 
							{
								s_name = (List.nth x 0);
								s_type = 0;
								s_attribute = (List.nth x 1);
								s_subsection_list = !subsections_list;
								s_origin =  0;
								s_length = int_of_string (List.nth x 2);
							};
							
					) uobj_sections_list;

								
				end;
	
																											
			(* initialize uobj preprocess definition *)
			o_pp_definition := "__UOBJ_" ^ self#get_o_usmf_hdr_id ^ "__";

			(* initialize uobj sentinels lib name *)
			o_uobj_sentinels_libname := "lib" ^ (self#get_o_usmf_hdr_id) ^ "-" ^
				!o_usmf_hdr_platform ^ "-" ^ !o_usmf_hdr_cpu ^ "-" ^ !o_usmf_hdr_arch;
									
			(true)
		;
		


		(*--------------------------------------------------------------------------*)
		(* consolidate sections with memory map *)
		(* uobj_load_addr = load address of uobj *)
		(*--------------------------------------------------------------------------*)
		method consolidate_sections_with_memory_map
			(uobj_load_addr : int) 
			: int =

			let uobj_section_load_addr = ref 0 in
			o_uobj_load_addr := uobj_load_addr;
			uobj_section_load_addr := uobj_load_addr;
			
			(* iterate over sentinels *)
			Hashtbl.iter (fun key (x:sentinel_info_t)  ->
				Hashtbl.add uobj_sections_memory_map_hashtbl key 
					{
						s_name = key;
						s_type = int_of_string(x.s_type_id);
						s_attribute = x.s_attribute;
						s_subsection_list = [ ("." ^ key) ];
						s_origin =  !uobj_section_load_addr;
						s_length = x.s_length;
					};
				Hashtbl.add uobj_sections_memory_map_hashtbl_byorigin !uobj_section_load_addr 
					{
						s_name = key;
						s_type = int_of_string(x.s_type_id);
						s_attribute = x.s_attribute;
						s_subsection_list = [ ("." ^ key) ];
						s_origin =  !uobj_section_load_addr;
						s_length = x.s_length;
					};
			
				uobj_section_load_addr := !uobj_section_load_addr + x.s_length;
			)  o_uobj_sentinels_hashtbl;

			(* iterate over regular sections *)
			Hashtbl.iter (fun key (x:Usextbinutils.ld_section_info_t)  ->

				Hashtbl.add uobj_sections_memory_map_hashtbl key 
					{
						s_name = x.s_name;
						s_type = x.s_type;
						s_attribute = x.s_attribute;
						s_subsection_list = x.s_subsection_list;
						s_origin =  !uobj_section_load_addr;
						s_length = x.s_length;
					};
				Hashtbl.add uobj_sections_memory_map_hashtbl_byorigin !uobj_section_load_addr 
					{
						s_name = x.s_name;
						s_type = x.s_type;
						s_attribute = x.s_attribute;
						s_subsection_list = x.s_subsection_list;
						s_origin =  !uobj_section_load_addr;
						s_length = x.s_length;
					};

				uobj_section_load_addr := !uobj_section_load_addr + x.s_length;
			)  o_uobj_sections_hashtbl;
			
					

			o_uobj_size := !uobj_section_load_addr - uobj_load_addr;
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
									let (pestatus, pesignal, cc_outputfilename) = 
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
											end
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

			) self#get_o_uobj_sentinels_hashtbl;

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

			) o_uobj_sentinels_hashtbl;

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
													(Printf.sprintf "0x%08x" x_v.s_origin)
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
				
												
				o_sentinels_lib_source_file_list := !o_sentinels_lib_source_file_list @ 
					[ target_sentinel_libfname ];
						
			) o_uobj_sentinels_hashtbl;

			Uslog.logf log_tag Uslog.Info "Generated sentinels lib.";
			()
		;


		(*--------------------------------------------------------------------------*)
		(* build uobj sentinels *)
		(*--------------------------------------------------------------------------*)
		method build_sentinels 
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
		(* build uobj sentinels lib *)
		(*--------------------------------------------------------------------------*)
		method build_sentinels_lib 
			() = 
			(*let uobj_sentinels_lib_name = "lib" ^ (self#get_o_usmf_hdr_id) ^ "-" ^
				!o_usmf_hdr_platform ^ "-" ^ !o_usmf_hdr_cpu ^ "-" ^ !o_usmf_hdr_arch in*)
				
			Uslog.logf log_tag Uslog.Info "Building sentinels lib: %s...\r\n"
				self#get_o_uobj_sentinels_libname;

			(* compile all the sentinel lib source files *)							
			self#compile_cfile_list !o_sentinels_lib_source_file_list
					(Usconfig.get_std_incdirs ())
					(Usconfig.get_std_defines () @
					[ self#get_o_pp_definition ] @ 
								Usconfig.get_std_define_asm ());
			
			(* now create the lib archive *)
			let (pestatus, pesignal) = 
					(Usextbinutils.mklib  
						!o_sentinels_lib_source_file_list
						(self#get_o_uobj_sentinels_libname ^ ".a")
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
		
			()
		;



				(*let x_v = Hashtbl.find uobj_sections_memory_map_hashtbl key in

				Uslog.logf log_tag Uslog.Info "%s/%s at 0x%08x" 
					(Usconfig.get_sentinel_dir ()) sentinel_fname x_v.s_origin;
				*)


		(*--------------------------------------------------------------------------*)
		(* build a uobj *)
		(* build_dir = directory to use for building *)
		(* keep_temp_files = true if temporary files need to be preserved in build_dir *)
		(*--------------------------------------------------------------------------*)
		method build 
			(build_dir : string)
			(keep_temp_files : bool) = 
	
			Uslog.logf log_tag Uslog.Info "Starting build in '%s' [%b]\n" build_dir keep_temp_files;
			
			Uslog.logf log_tag Uslog.Info "cfiles_count=%u, casmfiles_count=%u\n"
						(List.length !o_usmf_sources_c_files) 
						(List.length !o_usmf_sources_casm_files);

			(* generate uobj top-level header *)
			self#generate_uobj_hfile ();
	
			(* generate sentinels *)
			self#generate_sentinels ();

			(* generate sentinels lib *)
			self#generate_sentinels_lib ();

	
			(* generate uobj linker script *)
			(* use usmf_hdr_id as the uobj_name *)
			let uobj_linker_script_filename =	
				Usuobjgen.generate_linker_script !o_usmf_hdr_id 
					uobj_sections_memory_map_hashtbl_byorigin in
				Uslog.logf log_tag Uslog.Info "uobj_lscript=%s\n" uobj_linker_script_filename;

					
			(* generate uobj header *)
			(* use usmf_hdr_id as the uobj_name *)
			let uobj_hdr_filename = 
				self#generate_uobj_hdr !o_usmf_hdr_id (self#get_o_uobj_load_addr) 
					o_uobj_sections_hashtbl in
				Uslog.logf log_tag Uslog.Info "uobj_hdr_filename=%s\n" uobj_hdr_filename;

			(* compile all sentinels *)							
			self#build_sentinels ();
									
			(* compile sentinels lib *)
			self#build_sentinels_lib ();						
									
			(* compile all the cfiles *)							
			self#compile_cfile_list (!o_usmf_sources_c_files @ [ uobj_hdr_filename ]) 
					(Usconfig.get_std_incdirs ())
					(Usconfig.get_std_defines () @ [ self#get_o_pp_definition ]);
		
			(* link the uobj binary *)
			Uslog.logf log_tag Uslog.Info "Proceeding to link uobj binary '%s'..."
					!o_usmf_hdr_id;
				let uobj_libdirs_list = ref [] in
				let uobj_libs_list = ref [] in
				let (pestatus, pesignal) = 
						(Usextbinutils.link_uobj  
							( !o_sentinels_source_file_list @
								!o_usmf_sources_c_files @ 
								[ uobj_hdr_filename ]
							)
							!uobj_libdirs_list !uobj_libs_list
							uobj_linker_script_filename (!o_usmf_hdr_id ^ ".elf")
						) in
						if (pesignal == true) || (pestatus != 0) then
							begin
									Uslog.logf log_tag Uslog.Error "in linking uobj binary '%s'!" !o_usmf_hdr_id;
									ignore(exit 1);
							end
						else
							begin
									Uslog.logf log_tag Uslog.Info "Linked uobj binary '%s' successfully" !o_usmf_hdr_id;
							end
						;
																																																																																																																							
																																																																																																																																																																																																			
			Uslog.logf log_tag Uslog.Info "Done.\r\n";
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
  	Printf.fprintf ochannel "\n\t0x%08xUL, " (Hashtbl.length o_uobj_sentinels_hashtbl);
		
		(* plug in the sentinels *)
		Printf.fprintf ochannel "\n\t{";
		Hashtbl.iter (fun key (x:sentinel_info_t)  ->
			let x_v = Hashtbl.find uobj_sections_memory_map_hashtbl key in
			Printf.fprintf ochannel "\n\t\t{";
		  	Printf.fprintf ochannel "\n\t\t\t0x%08xUL, " (int_of_string(x.s_type_id));
		  	Printf.fprintf ochannel "\n\t\t\t0x%08xUL, " (0);
		  	Printf.fprintf ochannel "\n\t\t\t0x%08xUL, " (x_v.s_origin);
		  	Printf.fprintf ochannel "\n\t\t\t0x%08xUL " (x.s_length);
			Printf.fprintf ochannel "\n\t\t},";
		)  o_uobj_sentinels_hashtbl;
		Printf.fprintf ochannel "\n\t},";

		(*ustack_tos*)
    let info = Hashtbl.find uobj_sections_memory_map_hashtbl 
			(Usconfig.get_section_name_ustack()) in
		let ustack_size = (Usconfig.get_sizeof_uobj_ustack()) in
		let ustack_tos = ref 0 in
		ustack_tos := info.s_origin + ustack_size;
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
		tstack_tos := info.s_origin + tstack_size;
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
			Hashtbl.iter (fun key (x:Usextbinutils.ld_section_info_t)  ->
				(* new section *)
				let section_name_var = ("__uobjsection_filler_" ^ x.s_name) in
				
				  if ((compare (List.nth x.s_subsection_list 0) ".text") <> 0) && 
						((compare (List.nth x.s_subsection_list 0) ".ustack") <> 0) &&
						((compare (List.nth x.s_subsection_list 0) ".tstack") <> 0) &&
						((compare (List.nth x.s_subsection_list 0) ".hdr") <> 0) then
						begin
							Printf.fprintf oc "\n__attribute__((section (\"%s\"))) uint8_t %s[1]={ 0 };"
								(List.nth x.s_subsection_list 0) section_name_var;
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
			Usosservices.file_copy (!o_uobj_dir_abspathname ^ "/" ^ !o_usmf_filename)
				(uobj_install_dir ^ "/" ^ Usconfig.std_uobj_usmf_name); 
			
			(* copy uobj header file *)
			Usosservices.file_copy (!o_uobj_dir_abspathname ^ "/" ^ 
															Usconfig.uobj_hfilename ^ ".h")
				(uobj_install_dir ^ "/" ^ !o_usmf_hdr_id ^ ".h"); 
	
			(* copy sentinels lib *)
			Usosservices.file_copy (!o_uobj_dir_abspathname ^ "/" ^ 
															self#get_o_uobj_sentinels_libname ^ ".a")
				(uobj_install_dir ^ "/" ^ self#get_o_uobj_sentinels_libname ^ ".a"); 
			
							
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