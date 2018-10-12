(*------------------------------------------------------------------------------
	uberSpark uberobject library verification and build interface
	author: amit vasudevan (amitvasudevan@acm.org)
------------------------------------------------------------------------------*)

open Uslog
open Usmanifest

module Usuobjlib =
	struct

	let log_tag = "Usuobjlib";;

	let usmf_type_usuobjlib = "uobjlib";;


	(*--------------------------------------------------------------------------*)
	(* build a uobjlib *)
	(* uobjlib_manifest_filename = uobjlib manifest filename *)
	(* build_dir = directory to use for building *)
	(* keep_temp_files = true if temporary files need to be preserved in build_dir *)
	(*--------------------------------------------------------------------------*)
	let build 
				uobjlib_manifest_filename build_dir keep_temp_files = 
		
		let usmf_type = ref "" in
		let (retval, mf_json) = Usmanifest.read_manifest 
															uobjlib_manifest_filename keep_temp_files in
			if (retval == false) then
				begin
					Uslog.logf log_tag Uslog.Error "could not read uobjlib manifest.";
					ignore (exit 1);
				end
			;		

			usmf_type := Usmanifest.parse_node_usmf_type mf_json; 
			if (compare !usmf_type usmf_type_usuobjlib) <> 0 then
				begin
					Uslog.logf log_tag Uslog.Error "invalid manifest type '%s'." !usmf_type;
					ignore (exit 1);
				end
			;
															
			Uslog.logf log_tag Uslog.Info "Done.\r\n";
		()
	;;
								
																								
	end