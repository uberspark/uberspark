(*
	uberSpark binary generation interface
	author: amit vasudevan (amitvasudevan@acm.org)
*)

open Usconfig
open Uslog
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
