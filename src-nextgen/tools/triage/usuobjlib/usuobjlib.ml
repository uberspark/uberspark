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

			Uslog.logf log_tag Uslog.Info "Done.\n";

			let (rval, usmf_hdr_type, usmf_hdr_sucategory, usmf_hdr_id,
					usmplatform, usmcpu, usmarch) =
					Usmanifest.parse_node_usmf_hdr mf_json in
				
			if (rval == false) then
				begin
					Uslog.logf log_tag Uslog.Error "invalid manifest hdr.";
					ignore (exit 1);
				end
			;
				
			if (compare usmf_hdr_type usmf_type_usuobjlib) <> 0 then
				begin
					Uslog.logf log_tag Uslog.Error "invalid uobjlib manifest type '%s'." !usmf_type;
					ignore (exit 1);
				end
			;
			
						
			let(rval, uobjlib_hfiles, uobjlib_cfiles, uobjlib_casmfiles) = 
				Usmanifest.parse_node_usmsources	mf_json in

			if (rval == false) then
				begin
					Uslog.logf log_tag Uslog.Error "invalid usmf-sources node in manifest.";
					ignore (exit 1);
				end
			;

			Uslog.logf log_tag Uslog.Info "cfiles_count=%u, casmfiles_count=%u\n"
						(List.length uobjlib_cfiles) (List.length uobjlib_casmfiles);


			let(rval, uobjlib_vharness_list) = 
				Usmanifest.parse_node_usmf_vharness	mf_json in

			if (rval == true) then
				begin
					Uslog.logf log_tag Uslog.Info "total vharness elements=%u\n"
						(List.length uobjlib_vharness_list);
				
					List.iter (fun x ->
						Uslog.logf log_tag Uslog.Info "total elements=%u\n"
							(List.length x);

						List.iter (fun y ->
							Uslog.logf log_tag Uslog.Info "element=%s\n" y;
							()
						) x;

						()
					) uobjlib_vharness_list;

				end
			;

																																										
			Uslog.logf log_tag Uslog.Info "Done.\r\n";
		()
	;;
								
																								
	end