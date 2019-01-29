(*------------------------------------------------------------------------------
	uberSpark uberobject collection interface
	author: amit vasudevan (amitvasudevan@acm.org)
------------------------------------------------------------------------------*)

open Usconfig
open Uslog
open Usmanifest
open Usextbinutils
open Usuobjgen
open Usuobj

module Usuobjcollection =
	struct

	let log_tag = "Usuobjcollection";;

	let usmf_type_uobjcollection = "uobj_collection";;

	(*--------------------------------------------------------------------------*)
	(* build a uobj collection *)
	(* us_manifest_filename = us manifest filename *)
	(* build_dir = directory to use for building *)
	(* keep_temp_files = true if temporary files need to be preserved in build_dir *)
	(*--------------------------------------------------------------------------*)
	let build 
				us_manifest_filename build_dir keep_temp_files = 

		Uslog.logf log_tag Uslog.Info "Starting...\n";
		
		let usmf_type = ref "" in
		let (retval, mf_json) = Usmanifest.read_manifest 
															us_manifest_filename keep_temp_files in
			if (retval == false) then
				begin
					Uslog.logf log_tag Uslog.Error "could not read uobj collection manifest.";
					ignore (exit 1);
				end
			;		

		Uslog.logf log_tag Uslog.Info "Parsed uobj collection manifest.\n";

		let (rval, usmf_hdr_type, usmf_hdr_subtype, usmf_hdr_id) =
				Usmanifest.parse_node_usmf_hdr mf_json in
			
		if (rval == false) then
			begin
				Uslog.logf log_tag Uslog.Error "invalid manifest hdr.";
				ignore (exit 1);
			end
		;
				
		if (compare usmf_hdr_type usmf_type_uobjcollection) <> 0 then
			begin
				Uslog.logf log_tag Uslog.Error "invalid uobj collection manifest type '%s'." !usmf_type;
				ignore (exit 1);
			end
		;
			
		Uslog.logf log_tag Uslog.Info "Validated uobj collection hdr and manifest type.\n";
						
																																																																																																																																																																																																		
		Uslog.logf log_tag Uslog.Info "Done.\r\n";
		()
	;;
								
																								
	end