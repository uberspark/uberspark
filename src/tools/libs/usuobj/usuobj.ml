(*------------------------------------------------------------------------------
	uberSpark uberobject verification and build interface
	author: amit vasudevan (amitvasudevan@acm.org)
------------------------------------------------------------------------------*)

open Uslog
open Usmanifest

module Usuobj =
	struct

	let log_tag = "Usuobj";;

	let usmf_type_usuobj = "uobj";;


	(*--------------------------------------------------------------------------*)
	(* build a uobj *)
	(* uobj_manifest_filename = uobj manifest filename *)
	(* build_dir = directory to use for building *)
	(* keep_temp_files = true if temporary files need to be preserved in build_dir *)
	(*--------------------------------------------------------------------------*)
	let build 
				uobjlib_manifest_filename build_dir keep_temp_files = 

		Uslog.logf log_tag Uslog.Info "Starting...\n";
		
		let usmf_type = ref "" in
		let (retval, mf_json) = Usmanifest.read_manifest 
															uobjlib_manifest_filename keep_temp_files in
			if (retval == false) then
				begin
					Uslog.logf log_tag Uslog.Error "could not read uobj manifest.";
					ignore (exit 1);
				end
			;		

		Uslog.logf log_tag Uslog.Info "Parsed uobj manifest.\n";

		let (rval, usmf_hdr_type, usmf_hdr_subtype, usmf_hdr_id) =
				Usmanifest.parse_node_usmf_hdr mf_json in
			
		if (rval == false) then
			begin
				Uslog.logf log_tag Uslog.Error "invalid manifest hdr.";
				ignore (exit 1);
			end
		;
				
		if (compare usmf_hdr_type usmf_type_usuobj) <> 0 then
			begin
				Uslog.logf log_tag Uslog.Error "invalid uobj manifest type '%s'." !usmf_type;
				ignore (exit 1);
			end
		;
			
		Uslog.logf log_tag Uslog.Info "Validated uobj hdr and manifest type.\n";
						
		let(rval, uobj_cfiles, uobj_casmfiles) = 
			Usmanifest.parse_node_usmf_sources	mf_json in

		if (rval == false) then
			begin
				Uslog.logf log_tag Uslog.Error "invalid usmf-sources node in manifest.";
				ignore (exit 1);
			end
		;

		Uslog.logf log_tag Uslog.Info "cfiles_count=%u, casmfiles_count=%u\n"
					(List.length uobj_cfiles) (List.length uobj_casmfiles);

		



																																										
		Uslog.logf log_tag Uslog.Info "Done.\r\n";
		()
	;;
								
																								
	end