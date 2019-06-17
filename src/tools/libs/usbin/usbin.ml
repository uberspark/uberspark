(*
	uberSpark binary generation interface
	author: amit vasudevan (amitvasudevan@acm.org)
*)

open Usconfig
open Uslog
open Usextbinutils
open Usuobjcollection

module Usbin =
	struct

	let log_tag = "Usbin";;


	(*--------------------------------------------------------------------------*)
	(* generate uobj collection header source *)
	(*--------------------------------------------------------------------------*)
	let generate_uobjcoll_hdr_src () = 
			Uslog.logf log_tag Uslog.Info "Generating uobjcoll hdr source...";

			(* create uobjcoll source file *)
			let uobj_hfilename = 
					(!Usuobjcollection.o_usmf_hdr_id ^ ".hdr.c") in
			let oc = open_out uobj_hfilename in
			
			(* generate prologue *)
			Printf.fprintf oc "\n/* autogenerated uberSpark uobjcoll header */";
			Printf.fprintf oc "\n/* author: amit vasudevan (amitvasudevan@acm.org) */";
			Printf.fprintf oc "\n";
			Printf.fprintf oc "\n#include <uberspark.h>";
			Printf.fprintf oc "\n#include <usbinformat.h>";
			Printf.fprintf oc "\n";
			Printf.fprintf oc "\n";
			Printf.fprintf oc "\n__attribute__(( section(\".data\") )) __attribute__((aligned(4096))) usbinformat_uobjcoll_hdr_t uobjcoll_hdr = {";

				Printf.fprintf oc "\n\t{";

				Printf.fprintf oc "\n\t},";

				Printf.fprintf oc "\n\t0x%08xULL" 0;
				Printf.fprintf oc "\n\t0x%08xULL" 0;

				Printf.fprintf oc "\n\t{";

				Printf.fprintf oc "\n\t},";

			Printf.fprintf oc "\n};";
			Printf.fprintf oc "\n";
			Printf.fprintf oc "\n";

			close_out oc;

		()
	;;


	(*--------------------------------------------------------------------------*)
	(* generate uobj collection header binary *)
	(*--------------------------------------------------------------------------*)
	let generate_uobjcoll_hdr_bin () = 
		Uslog.logf log_tag Uslog.Info "Generating uobjcoll hdr binary...";

(*
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

		let uobjcoll_info_table_lscript_sections = ((Hashtbl.create 32) : ((int, Ustypes.section_info_t)  Hashtbl.t)) in
						Hashtbl.add uobjcoll_info_table_lscript_sections 0 
							{f_name = "data";	
								f_subsection_list = [ ".data" ];	
								usbinformat = { f_type=0; f_prot=0; f_va_offset=0; f_file_offset=0;
								f_size = (Usconfig.get_sizeof_uobjcoll_info_t());
								f_aligned_at = 0x1000; f_pad_to = 0x1000; f_reserved = 0;
								};
							};
				
		let uobjcoll_info_table_lscript = Usuobjgen.generate_linker_script  
			(uobjcoll_info_table_filename) 0 (Usconfig.get_sizeof_uobjcoll_info_t()) uobjcoll_info_table_lscript_sections in
			
		
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
*)

		()
	;;

	(*--------------------------------------------------------------------------*)
	(* generate uobj collection binary image *)
	(*--------------------------------------------------------------------------*)
	let generate_uobjcoll_bin_image uobjcoll_bin_image_filename = 

		(* generate uobj collection header source *)
		generate_uobjcoll_hdr_src ();

		(* generate uobj collection info table *)
		Usuobjcollection.generate_uobjcoll_info (Usconfig.get_std_uobjcoll_info_filename ()); 
		Uslog.logf log_tag Uslog.Info "Generated uobj collection info. table.";
	
		(* build uobj collection info table binary *)
		Usuobjcollection.build_uobjcoll_info_table (Usconfig.get_std_uobjcoll_info_filename ());
		Uslog.logf log_tag Uslog.Info "Built uobj collection info. table binary.";
	
		(* build uobj collection by building individidual uobjs *)
		Usuobjcollection.build "" true;
	
		(* build final image *)
		Usuobjcollection.build_uobjcoll_binary_image uobjcoll_bin_image_filename
		(Usconfig.get_std_uobjcoll_info_filename ());

		()
	;;
							
	end
