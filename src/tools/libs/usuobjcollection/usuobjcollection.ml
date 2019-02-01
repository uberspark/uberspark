(*------------------------------------------------------------------------------
	uberSpark uberobject collection interface
	author: amit vasudevan (amitvasudevan@acm.org)
------------------------------------------------------------------------------*)

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
		let (rval, usmf_hdr_type, usmf_hdr_subtype, usmf_hdr_id) =
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


				Uslog.logf log_tag Uslog.Info "uobj type: %s" (uobj#get_o_usmf_hdr_type); 			 
				Uslog.logf log_tag Uslog.Info "uobj c-files: %u" (List.length uobj#get_o_usmf_sources_c_files); 			 

		) !uobj_dir_list;
																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																						
		Uslog.logf log_tag Uslog.Info "Done.";
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
																																																																																																
																																																																																																
	end