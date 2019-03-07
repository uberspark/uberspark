(*------------------------------------------------------------------------------
	uberSpark uberobject collection interface
	author: amit vasudevan (amitvasudevan@acm.org)
------------------------------------------------------------------------------*)

open Unix

open Usconfig
open Uslog
open Usosservices
open Usmanifest
open Usextbinutils
open Usuobjgen
open Usuobj

module Usuobjcollection =
	struct

	let log_tag = "Usuobjcollection";;
	
	let total_uobjs = ref 0;;

	let usmf_type_uobjcoll = "uobj_collection";;

	let rootdir = ref "";;

	let usmf_filename_canonical = ref "";;
	
	let uobj_dir_list = ref [];;

	(*let uobj_list = ref [];;*)

	let uobj_hashtbl = ((Hashtbl.create 32) : ((string,Usuobj.uobject)  Hashtbl.t));;
	let uobj_dir_hashtbl = ((Hashtbl.create 32) : ((string,string)  Hashtbl.t));;

	let o_load_addr = ref 0;;

	let o_usmf_hdr_id = ref"";;


	(*--------------------------------------------------------------------------*)
	(* initialize build configuration for a uobj collection *)
	(* usmf_filename = uobj collection manifest filename *)
	(* build_dir = directory to use for building *)
	(* keep_temp_files = true if temp files need to be preserved in build_dir *)
	(*--------------------------------------------------------------------------*)
	let init_build_configuration 
				usmf_filename build_dir keep_temp_files = 

		(* compute the canonical path of the manifest filename *)
		let (retval, retval_path) = Usosservices.abspath usmf_filename in
			if (retval == false) then
				begin
					Uslog.logf log_tag Uslog.Error "unable to obtain canonical path for '%s'" usmf_filename;
					ignore (exit 1);
				end
			;
		usmf_filename_canonical := retval_path;
		Uslog.logf log_tag Uslog.Info "canonical path=%s" !usmf_filename_canonical;		
		
		(* compute root directory of uobj collection manifest *)
		rootdir := Filename.dirname !usmf_filename_canonical;
		Uslog.logf log_tag Uslog.Info "root-dir=%s" !rootdir;		
		
		(* read uobj collection manifest into JSON object *)
		let (retval, mf_json) = Usmanifest.read_manifest 
															!usmf_filename_canonical keep_temp_files in
			if (retval == false) then
				begin
					Uslog.logf log_tag Uslog.Error "could not read uobj collection manifest.";
					ignore (exit 1);
				end
			;		
		Uslog.logf log_tag Uslog.Info "read uobj collection manifest into JSON object";


		(* read uobj collection manifest header *)
		let (rval, usmf_hdr_type, usmf_hdr_subtype, usmf_hdr_id,
			usmf_platform, usmf_cpu, usmf_arch) =
				Usmanifest.parse_node_usmf_hdr mf_json in
			
		if (rval == false) then
			begin
				Uslog.logf log_tag Uslog.Error "invalid uobj collection manifest hdr.";
				ignore (exit 1);
			end
		;

								
		(* sanity check header type *)
		if (compare usmf_hdr_type usmf_type_uobjcoll) <> 0 then
			begin
				Uslog.logf log_tag Uslog.Error "invalid uobj collection manifest type '%s'." usmf_hdr_type;
				ignore (exit 1);
			end
		;
		Uslog.logf log_tag Uslog.Info "Validated uobj collection hdr and manifest type.";

		(* parse uobj-coll node and compute uobj dir list and uobj count *)
		let(rval, ret_uobj_dir_list) = 
			Usmanifest.parse_node_usmf_uobj_coll	mf_json in
	
			if (rval == false) then
				begin
					Uslog.logf log_tag Uslog.Error "invalid uobj-coll node in manifest.";
					ignore (exit 1);
				end
			;
		
		(* iterate through and make the uobj dir list canonical *)
		List.iter (fun x ->  
						(* Uslog.logf log_tag Uslog.Info "uobj dir: %s" x; *)
						let (retval, retval_path) = (Usosservices.abspath (!rootdir ^ "/" ^ x)) in
							if (retval == false) then
								begin
									Uslog.logf log_tag Uslog.Error "unable to obtain canonical path for '%s'" x;
									ignore (exit 1);
								end
							;
						(*Uslog.logf log_tag Uslog.Info "entry: %s; canonical path=%s" x retval_path;*)
						uobj_dir_list := !uobj_dir_list @ [ retval_path ];
		) ret_uobj_dir_list;
						
		total_uobjs := (List.length !uobj_dir_list);
		Uslog.logf log_tag Uslog.Info "uobj count=%u" !total_uobjs;


		(* store uobj collection id *)
		o_usmf_hdr_id := usmf_hdr_id;

		Uslog.logf log_tag Uslog.Info "Done.";
		()
	;;



	(*--------------------------------------------------------------------------*)
	(* collect uobjs after parsing their respective manifests *)
	(*--------------------------------------------------------------------------*)
	let collect_uobjs_with_manifest_parsing () = 

		(* instantiate uobjs *)
		List.iter (fun x ->  
			(* Uslog.logf log_tag Uslog.Info "uobj dir: %s" (x ^ "/" ^ Usconfig.std_uobj_usmf_name); *) 
			let uobj = new Usuobj.uobject in
				let retval = uobj#parse_manifest (x ^ "/" ^ Usconfig.std_uobj_usmf_name) true in	
				if (retval == false) then
					begin
						Uslog.logf log_tag Uslog.Error "unable to parse manifest for uobj: '%s'" x;
						ignore (exit 1);
					end
				;

				(* uobj_list := !uobj_list @ [ uobj ]; *)
		    if (Hashtbl.mem uobj_hashtbl (uobj#get_o_usmf_hdr_id)) then
		    	begin
						Uslog.logf log_tag Uslog.Error "multiple uobjs with same id: '%s'" (uobj#get_o_usmf_hdr_id);
						ignore (exit 1);
		    	end
		    else
		    	begin
						Hashtbl.add uobj_hashtbl (uobj#get_o_usmf_hdr_id) uobj;
		    	end
		    ;

		    if (Hashtbl.mem uobj_dir_hashtbl (uobj#get_o_usmf_hdr_id)) then
		    	begin
						Uslog.logf log_tag Uslog.Error "uobj appears multiple times in collection: '%s'" (uobj#get_o_usmf_hdr_id);
						ignore (exit 1);
		    	end
		    else
		    	begin
						Hashtbl.add uobj_dir_hashtbl (uobj#get_o_usmf_hdr_id) x;
		    	end
		    ;

				Uslog.logf log_tag Uslog.Info "uobj type: %s" (uobj#get_o_usmf_hdr_type); 			 
				Uslog.logf log_tag Uslog.Info "uobj c-files: %u" (List.length uobj#get_o_usmf_sources_c_files); 			 

		) !uobj_dir_list;
																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																						
		Uslog.logf log_tag Uslog.Info "Done.";
		()
	;;
								


	(*--------------------------------------------------------------------------*)
	(* compute uobj collection memory map *)
	(* uobjcoll_load_addr = load address of uobj collection *)
	(*--------------------------------------------------------------------------*)
	let compute_memory_map
			(uobjcoll_load_addr : int) =
		let uobj_load_addr = ref 0 in
		uobj_load_addr := uobjcoll_load_addr + (Usconfig.get_sizeof_uobjcoll_info_t());
		o_load_addr := uobjcoll_load_addr;

		Hashtbl.iter (fun key uobj ->  
				(* uobj#compute_sections_memory_map !uobj_load_addr; *)
				uobj#consolidate_sections_with_memory_map !uobj_load_addr;
				uobj_load_addr := !uobj_load_addr + uobj#get_o_uobj_size;
		) uobj_hashtbl;

		()
	;;

																								
	(*--------------------------------------------------------------------------*)
	(* build a uobj *)
	(* build_dir = directory to use for building *)
	(* keep_temp_files = true if temporary files need to be preserved in build_dir *)
	(*--------------------------------------------------------------------------*)
	let build build_dir keep_temp_files = 
		Hashtbl.iter (fun key uobj ->  
			Uslog.logf log_tag Uslog.Info "Building uobj '%s'..." key; 
			let(rval, r_prevpath, r_curpath) = Usosservices.dir_change 
				(uobj#get_o_uobj_dir_abspathname) in
				if(rval == true) then 
					begin
						uobj#build build_dir keep_temp_files;
						ignore(Usosservices.dir_change r_prevpath);
					end
				else
					begin
						Uslog.logf log_tag Uslog.Error "could not change to uobj directory: %s" (uobj#get_o_uobj_dir_abspathname);
						ignore (exit 1);
					end
				;
			
		) uobj_hashtbl;

		()
	;;
										
																																																																																																
	(*--------------------------------------------------------------------------*)
	(* generate uobj collection info table *)
	(*--------------------------------------------------------------------------*)
	let generate_uobjcoll_info uobjcoll_info_filename = 
    let oc = open_out uobjcoll_info_filename in

		Printf.fprintf oc "\n/* autogenerated uobj collection info table */";
		Printf.fprintf oc "\n/* author: amit vasudevan (amitvasudevan@acm.org) */";
		Printf.fprintf oc "\n";
		Printf.fprintf oc "\n";
		Printf.fprintf oc "\n#include <uberspark.h>";
		Printf.fprintf oc "\n#include <xmhfgeec.h>";
		Printf.fprintf oc "\n";
		Printf.fprintf oc "\n";
(*		Printf.fprintf oc "\n__attribute__(( section(\".data\") )) __attribute__((aligned(4096))) uobj_info_t uobjcoll_info_table[] = {";*)
		Printf.fprintf oc "\n__attribute__(( section(\".data\") )) __attribute__((aligned(4096))) uobjcoll_info_t uobjcoll_info_table = {";

		Printf.fprintf oc "\n\t{";

		Printf.fprintf oc "\n\t\tUOBJCOLL_INFO_T_MAGIC,";
		Printf.fprintf oc "\n\t\t%u," !total_uobjs;
		Printf.fprintf oc "\n\t\tUOBJ_INFO_T_SIZE,";
		Printf.fprintf oc "\n\t\t0x%08x" !o_load_addr;

		Printf.fprintf oc "\n\t},";

		Printf.fprintf oc "\n\t{";

		Hashtbl.iter (fun key uobj ->  
				uobj#generate_uobj_info oc;
		) uobj_hashtbl;

		Printf.fprintf oc "\n\t}";

		Printf.fprintf oc "\n};";

		close_out oc;
																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																								
		()
	;;

																																																																																																
	(*--------------------------------------------------------------------------*)
	(* generate uobj collection info table *)
	(*--------------------------------------------------------------------------*)
	let build_uobjcoll_info_table uobjcoll_info_table_filename = 
		let (pestatus, pesignal, cc_outputfilename) = 
			Usextbinutils.compile_cfile uobjcoll_info_table_filename (uobjcoll_info_table_filename ^ ".o") 
				(Usconfig.get_std_incdirs ())	(Usconfig.get_std_defines ()) in
			if (pesignal == true) || (pestatus != 0) then
				begin
						Uslog.logf log_tag Uslog.Error "in compiling %s!" uobjcoll_info_table_filename;
						ignore(exit 1);
				end
			else
				begin
						Uslog.logf log_tag Uslog.Info "Compiled %s successfully" uobjcoll_info_table_filename;
				end
			;

		(* generate linker sript *)
		let uobjcoll_info_table_lscript_sections = ((Hashtbl.create 32) : ((int, Usextbinutils.ld_section_info_t)  Hashtbl.t)) in
						Hashtbl.add uobjcoll_info_table_lscript_sections 0 
							{s_name = "data";	s_type = 0;	s_attribute = "rw";
								s_subsection_list = [ ".data" ];	s_origin = 0;
								s_length = (Usconfig.get_sizeof_uobjcoll_info_t());
							};
		let uobjcoll_info_table_lscript = Usuobjgen.generate_linker_script  
			(uobjcoll_info_table_filename) uobjcoll_info_table_lscript_sections in
			
		
		(* build uobj collection info table binary *)
		let uobj_libdirs_list = ref [] in
		let uobj_libs_list = ref [] in
		let (pestatus, pesignal) = 
				(Usextbinutils.link_uobj  
					[uobjcoll_info_table_filename]
					!uobj_libdirs_list !uobj_libs_list
					uobjcoll_info_table_lscript (uobjcoll_info_table_filename ^ ".elf")
				) in
				if (pesignal == true) || (pestatus != 0) then
					begin
							Uslog.logf log_tag Uslog.Error "in building uobj collection info table binary!";
							ignore(exit 1);
					end
				else
					begin
							Uslog.logf log_tag Uslog.Info "Built uobj collection info table binary";
					end
				;



		()
	;;
																																																																																																																																																																																																																																																																																																																																																																																																

	(*--------------------------------------------------------------------------*)
	(* build uobj collection binary image *)
	(*--------------------------------------------------------------------------*)
	let build_uobjcoll_binary_image 
		uobjcoll_binary_image_filename 
		uobjcoll_info_table_binary_filename =
		
		let input_filename_list = ref [] in

		(* generate flat-form binary for uobj info table *)
		let (pestatus, pesignal) = 
		(Usextbinutils.mkbin
			  (uobjcoll_info_table_binary_filename ^ ".elf")
				(uobjcoll_info_table_binary_filename ^ ".bin")
		) in
		if (pesignal == true) || (pestatus != 0) then
			begin
					Uslog.logf log_tag Uslog.Error "in generating flat-form binary for uobjcoll info table!";
					ignore(exit 1);
			end
		;
 
		(* add uobj info table flat-form binary filename to list of files to be*)
		(* concatentated*)
		input_filename_list := !input_filename_list @ [ uobjcoll_info_table_binary_filename ^ ".bin"];
	
		(* iterate through the uobjs and generate flat-form binaries *)
		Hashtbl.iter (fun key uobj ->  
			let uobj_binary_input_filename = 
				(Hashtbl.find uobj_dir_hashtbl (uobj#get_o_usmf_hdr_id)) ^ "/" ^
				(uobj#get_o_usmf_hdr_id) ^ ".elf" in
			let uobj_binary_output_filename = 
				(Hashtbl.find uobj_dir_hashtbl (uobj#get_o_usmf_hdr_id)) ^ "/" ^
				(uobj#get_o_usmf_hdr_id) ^ ".bin" in

				(* generate flat-form binary for uobj *)
				let (pestatus, pesignal) = 
				(Usextbinutils.mkbin
					  uobj_binary_input_filename
						uobj_binary_output_filename
				) in
				if (pesignal == true) || (pestatus != 0) then
					begin
							Uslog.logf log_tag Uslog.Error "in generating flat-form binary for uobj: %s!" (uobj#get_o_usmf_hdr_id);
							ignore(exit 1);
					end
				;

				(* add uobj flat-form binary filename to list of files to be*)
				(* concatentated*)
				input_filename_list := !input_filename_list @ [ uobj_binary_output_filename ];
				
		) uobj_hashtbl;

	  Usosservices.file_concat uobjcoll_binary_image_filename !input_filename_list;
		
		()		 
	;;


	(*--------------------------------------------------------------------------*)
	(* install uobj collection *)
	(* install_dir = directory to install to *)
	(*--------------------------------------------------------------------------*)
	let install 
		(install_dir : string)
		= 
			
		let uobjcoll_install_dir = (install_dir ^ "/" ^ !o_usmf_hdr_id) in
		Uslog.logf log_tag Uslog.Info "install uobjcoll in: %s" uobjcoll_install_dir;
		
		let (retval, retecode, retemsg) = Usosservices.mkdir uobjcoll_install_dir 0o755 in
		
		if (retval == false) && (retecode != Unix.EEXIST) then 
			begin
				Uslog.logf log_tag Uslog.Error "error in creating directory: %s" retemsg;
			end
		;
		
		(* copy uobj collection manifest *)
		Usosservices.file_copy !usmf_filename_canonical 
			(uobjcoll_install_dir ^ "/" ^ Usconfig.default_uobjcoll_usmf_name);
		
		(* copy uobj collection binary image *)
		(* Usosservices.file_copy !usmf_filename_canonical 
			(uobjcoll_install_dir ^ "/" ^ Usconfig.default_uobjcoll_usmf_name);
			*)
		
		(* iterate over all the uobjs in the collection *)
		(* and invoke their install method *)
		Hashtbl.iter (fun key uobj ->  
				uobj#install uobjcoll_install_dir;
		) uobj_hashtbl;
		
		
		()		 
	;;
																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																
	end
	
