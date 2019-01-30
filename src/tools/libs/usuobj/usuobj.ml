(*------------------------------------------------------------------------------
	uberSpark uberobject verification and build interface
	author: amit vasudevan (amitvasudevan@acm.org)
------------------------------------------------------------------------------*)

open Usconfig
open Uslog
open Usmanifest
open Usextbinutils
open Usuobjgen

module Usuobj =
struct

class uobject = object(self)
		val log_tag = "Usuobj";
		
		val usmf_type_usuobj = "uobj";

		val o_usmf_hdr_type = ref "";

		(* val mutable slab_idtoname = ((Hashtbl.create 32) : ((int,string)  Hashtbl.t)); *)


		(*--------------------------------------------------------------------------*)
		(* parse uobj manifest *)
		(* usmf_filename = uobj manifest filename *)
		(* keep_temp_files = true if temporary files need to be preserved *)
		(*--------------------------------------------------------------------------*)
		method parse_manifest usmf_filename keep_temp_files =
			let fretval = ref false in

			let (rval, mf_json) = Usmanifest.read_manifest 
																usmf_filename keep_temp_files in
				if (rval == true) then
					begin
						let (rval, usmf_hdr_type, usmf_hdr_subtype, usmf_hdr_id) =
								Usmanifest.parse_node_usmf_hdr mf_json in

							if (rval == true) then
								begin
									if (compare usmf_hdr_type usmf_type_usuobj) == 0 then
										begin
											o_usmf_hdr_type := usmf_hdr_type;								
										end
									;

								end
							;
					
					end
				;		
	
			
				

			(!fretval)
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
		(* build a uobj *)
		(* uobj_manifest_filename = uobj manifest filename *)
		(* build_dir = directory to use for building *)
		(* keep_temp_files = true if temporary files need to be preserved in build_dir *)
		(*--------------------------------------------------------------------------*)
		method build 
					uobjlib_manifest_filename build_dir keep_temp_files = 
	
			Uslog.logf log_tag Uslog.Info "Starting build in '%s'...\n" build_dir;
			
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
	
			(* parse uobj-binary node *)
			let (rval, uobj_sections_list) = 
					Usmanifest.parse_node_uobj_binary mf_json in
						if (rval == false) then
							begin
								Uslog.logf log_tag Uslog.Error "invalid or no uobj-binary node found within uobj manifest.";
								ignore (exit 1);
							end
						;
	
			Uslog.logf log_tag Uslog.Info "Parsed uobj-binary from uobj manifest: total sections=%u"
				(List.length uobj_sections_list); 
			
	
			(* generate uobj linker script *)
			(* use usmf_hdr_id as the uobj_name *)
			let uobj_linker_script_filename =	
				Usuobjgen.generate_uobj_linker_script usmf_hdr_id 0x60000000 
					uobj_sections_list in
				Uslog.logf log_tag Uslog.Info "uobj_lscript=%s\n" uobj_linker_script_filename;
					
	
	
			(* generate uobj header *)
			(* use usmf_hdr_id as the uobj_name *)
			let uobj_hdr_filename = 
				Usuobjgen.generate_uobj_hdr usmf_hdr_id 0x60000000 
					uobj_sections_list in
				Uslog.logf log_tag Uslog.Info "uobj_hdr_filename=%s\n" uobj_hdr_filename;
			
			
							
			self#compile_cfile_list (uobj_cfiles @ [ uobj_hdr_filename ]) 
					(Usconfig.get_std_incdirs ())
					(Usconfig.get_std_defines ());
		
			Uslog.logf log_tag Uslog.Info "Proceeding to link uobj binary '%s'..."
					usmf_hdr_id;
				let uobj_libdirs_list = ref [] in
				let uobj_libs_list = ref [] in
				let (pestatus, pesignal) = 
						(Usextbinutils.link_uobj  
							(uobj_cfiles @ [ uobj_hdr_filename ])
							!uobj_libdirs_list !uobj_libs_list
							uobj_linker_script_filename usmf_hdr_id
						) in
						if (pesignal == true) || (pestatus != 0) then
							begin
									Uslog.logf log_tag Uslog.Error "in linking uobj binary '%s'!" usmf_hdr_id;
									ignore(exit 1);
							end
						else
							begin
									Uslog.logf log_tag Uslog.Info "Linked uobj binary '%s' successfully" usmf_hdr_id;
							end
						;
																																																																																																																							
																																																																																																																																																																																																			
			Uslog.logf log_tag Uslog.Info "Done.\r\n";
			()
		;


end ;;

end