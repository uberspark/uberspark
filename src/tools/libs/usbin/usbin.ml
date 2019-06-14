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
	(* generate uobj collection binary image *)
	(*--------------------------------------------------------------------------*)
	let generate_uobjcoll_bin_image uobjcoll_bin_image_filename = 

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
