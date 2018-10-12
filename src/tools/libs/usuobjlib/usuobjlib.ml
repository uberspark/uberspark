(*------------------------------------------------------------------------------
	uberSpark uberobject library verification and build interface
	author: amit vasudevan (amitvasudevan@acm.org)
------------------------------------------------------------------------------*)

open Uslog
open Libusmf

module Usuobjlib =
	struct

	let log_tag = "Usuobjlib";;


	(*--------------------------------------------------------------------------*)
	(* build a uobjlib *)
	(* uobjlib_manifest_filename = uobjlib manifest filename *)
	(* build_dir = directory to use for building *)
	(* keep_temp_files = true if temporary files need to be preserved in build_dir *)
	(*--------------------------------------------------------------------------*)
	let build 
				uobjlib_manifest_filename build_dir keep_temp_files = 
		
		let (retval, mf_json) = Libusmf.usmf_read_manifest 
															uobjlib_manifest_filename keep_temp_files in
			if (retval == false) then
				begin
					Uslog.logf log_tag Uslog.Error "could not read uobjlib manifest.";
					ignore (exit 1);
				end
			;		
					
			Uslog.logf log_tag Uslog.Info "Done.\r\n";
		()
	;;
								
																								
	end