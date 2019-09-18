(*----------------------------------------------------------------------------*)
(* uberSpark manifest interface *)
(*	 author: amit vasudevan (amitvasudevan@acm.org) *)
(*----------------------------------------------------------------------------*)

open Yojson


open Ustypes
open Usconfig
open Uslog
open Usosservices
(*open Usextbinutils*)


module Usmanifest =
	struct

	type hdr_t =
		{
			mutable f_type         : string;			
			mutable f_namespace    : string;			
			mutable f_platform	   : string;
			mutable f_arch	       : string;
			mutable f_cpu				   : string;
		};;


	let log_tag = "Usmanifest";;

	(*--------------------------------------------------------------------------*)
	(* read manifest file into json object *)
	(*--------------------------------------------------------------------------*)

(*	let read_manifest usmf_filename keep_temp_files = 
		let retval = ref false in
	  let retjson = ref `Null in
		let usmf_filename_in_pp = (usmf_filename ^ ".c") in
		let usmf_filename_out_pp = (usmf_filename ^ ".upp") in
			Usosservices.file_copy usmf_filename usmf_filename_in_pp;
			let (pp_retval, _) = Usextbinutils.preprocess usmf_filename_in_pp 
														usmf_filename_out_pp 
														(Usconfig.get_std_incdirs ())
														(Usconfig.get_std_defines () @ 
															Usconfig.get_std_define_asm ()) in
	
			if(pp_retval == 0) then 
				begin
					try
				
						 let uobj_mf_json = Yojson.Basic.from_file usmf_filename_out_pp in
								retval := true;
								retjson := uobj_mf_json;
								
					with Yojson.Json_error s -> 
							Uslog.logf "libusmf" Uslog.Debug "usmf_read_manifest: ERROR:%s" s;
							retval := false;
					;
					
					if(keep_temp_files == false) then
						begin
							Usosservices.file_remove usmf_filename_in_pp;
							Usosservices.file_remove usmf_filename_out_pp;
						end
					;
				end
			;	
	
		(!retval, !retjson)
	;;
*)


	let read_manifest mf_filename keep_temp_files = 
		let retval = ref false in
	  let retjson = ref `Null in
					try
				
						 let mf_json = Yojson.Basic.from_file mf_filename in
								retval := true;
								retjson := mf_json;
								
					with Yojson.Json_error s -> 
							Uslog.log ~lvl:Uslog.Error "usmf_read_manifest: ERROR:%s" s;
							retval := false;
					;
	
		(!retval, !retjson)
	;;


	(*--------------------------------------------------------------------------*)
	(* parse common manifest header node; "hdr" *)
	(* return: true if successfully parsed header node, false if not *)
	(* if true also return: manifest header node as hdr_t *)
	(*--------------------------------------------------------------------------*)

	let parse_node_hdr mf_json =
		let retval = ref false in
		let mf_hdr_type = ref "" in
		let mf_hdr_namespace = ref "" in
		let mf_hdr_platform = ref "" in
		let mf_hdr_arch = ref "" in
		let mf_hdr_cpu = ref "" in
		try
			let open Yojson.Basic.Util in
				let json_mf_hdr = mf_json |> member "hdr" in
				if(json_mf_hdr <> `Null) then
					begin
						mf_hdr_type := json_mf_hdr |> member "type" |> to_string;
						mf_hdr_namespace := json_mf_hdr |> member "namespace" |> to_string;
						mf_hdr_platform := json_mf_hdr |> member "platform" |> to_string;
						mf_hdr_arch := json_mf_hdr |> member "arch" |> to_string;
						mf_hdr_cpu := json_mf_hdr |> member "cpu" |> to_string;
						retval := true;
					end
				;

		with Yojson.Basic.Util.Type_error _ -> 
				retval := false;
		;

		(!retval, {
			f_type = !mf_hdr_type;
			f_namespace = !mf_hdr_namespace;
			f_platform = !mf_hdr_platform;
			f_arch = !mf_hdr_arch;
			f_cpu = !mf_hdr_cpu;
		})
	;;





	(*--------------------------------------------------------------------------*)
	(* parse common manifest node "usmf-hdr" *)
	(* return: true if successfully parsed usmf-hdr, false if not *)
	(* if true also return: manifest type string; manifest subtype string; *)
	(* id as string *)
	(*--------------------------------------------------------------------------*)

	let parse_node_usmf_hdr usmf_json =
		let retval = ref false in
		let usmf_hdr_type = ref "" in
		let usmf_hdr_subtype = ref "" in
		let usmf_hdr_id = ref "" in
		let usmf_hdr_platform = ref "" in
		let usmf_hdr_cpu = ref "" in
		let usmf_hdr_arch = ref "" in
		try
			let open Yojson.Basic.Util in
				let usmf_json_usmf_hdr = usmf_json |> member "usmf-hdr" in
				if(usmf_json_usmf_hdr <> `Null) then
					begin
						usmf_hdr_type := usmf_json_usmf_hdr |> member "type" |> to_string;
						usmf_hdr_subtype := usmf_json_usmf_hdr |> member "subtype" |> to_string;
						usmf_hdr_id := usmf_json_usmf_hdr |> member "id" |> to_string;
						usmf_hdr_platform := usmf_json_usmf_hdr |> member "platform" |> to_string;
						usmf_hdr_cpu := usmf_json_usmf_hdr |> member "cpu" |> to_string;
						usmf_hdr_arch := usmf_json_usmf_hdr |> member "arch" |> to_string;
						retval := true;
					end
				;

		with Yojson.Basic.Util.Type_error _ -> 
				retval := false;
		;

		(!retval, !usmf_hdr_type, !usmf_hdr_subtype, !usmf_hdr_id,
			!usmf_hdr_platform, !usmf_hdr_cpu, !usmf_hdr_arch)
	;;


(*
	(*--------------------------------------------------------------------------*)
	(* parse manifest node "uobjlib-sources" *)
	(* return true on successful parse, false if not *)
	(* return: if true then lists of h-files, c-files and casm files *)
	(*--------------------------------------------------------------------------*)
	let parse_node_usmf_sources usmf_json =
		let retval = ref true in
		let usmf_hfiles_list = ref [] in
		let usmf_cfiles_list = ref [] in
		let usmf_casmfiles_list = ref [] in

		try
			let open Yojson.Basic.Util in
		  	let usmf_sources_json = usmf_json |> member "usmf-sources" in
					if usmf_sources_json != `Null then
						begin

							let usmf_hfiles_json = usmf_sources_json |> 
								member "h-files" in
								if usmf_hfiles_json != `Null then
									begin
										let usmf_hfiles_json_list = usmf_hfiles_json |> 
												to_list in 
											List.iter (fun x -> usmf_hfiles_list := 
													!usmf_hfiles_list @ [(x |> to_string)]
												) usmf_hfiles_json_list;
									end
								;
	
							let usmf_cfiles_json = usmf_sources_json |> 
								member "c-files" in
								if usmf_cfiles_json != `Null then
									begin
										let usmf_cfiles_json_list = usmf_cfiles_json |> 
												to_list in 
											List.iter (fun x -> usmf_cfiles_list := 
													!usmf_cfiles_list @ [(x |> to_string)]
												) usmf_cfiles_json_list;
									end
								;

							let usmf_casmfiles_json = usmf_sources_json |> 
								member "casm-files" in
								if usmf_casmfiles_json != `Null then
									begin
										let usmf_casmfiles_json_list = usmf_casmfiles_json |> 
												to_list in 
											List.iter (fun x -> usmf_casmfiles_list := 
													!usmf_casmfiles_list @ [(x |> to_string)]
												) usmf_casmfiles_json_list;
									end
								;

						end
					;
					
		with Yojson.Basic.Util.Type_error _ -> 
				retval := false;
		;
	
		(!retval, !usmf_hfiles_list, !usmf_cfiles_list, !usmf_casmfiles_list)
	;;
*)

	(*--------------------------------------------------------------------------*)
	(* parse manifest node "usmf-vharness" *)
	(* return true if vharness node present, false if not *)
	(* return: if true then returns list of lists of vharnesses *)
	(*--------------------------------------------------------------------------*)
	
	let parse_node_usmf_vharness usmf_json =
		let retval = ref false in
		let usmf_vharness_list = ref [] in

		try
			let open Yojson.Basic.Util in
		  	let usmf_vharness_json = usmf_json |> member "usmf-vharness" in
					if usmf_vharness_json != `Null then
						begin

							let usmf_vharness_assoc_list = Yojson.Basic.Util.to_assoc 
									usmf_vharness_json in
								
								retval := true;
								List.iter (fun (x,y) ->
									Uslog.logf "usmanifest" Uslog.Debug "%s: key=%s" __LOC__ x;
									let usmf_vharness_attribute_list = ref [] in
										usmf_vharness_attribute_list := !usmf_vharness_attribute_list @
																	[ x ];
										List.iter (fun z ->
											usmf_vharness_attribute_list := !usmf_vharness_attribute_list @
																	[ (z |> to_string) ];
											()
										)(Yojson.Basic.Util.to_list y);
										
										usmf_vharness_list := !usmf_vharness_list @	[ !usmf_vharness_attribute_list ];
										(* if (List.length (Yojson.Basic.Util.to_list y)) < 3 then
											retval:=false;
										*)
									()
								) usmf_vharness_assoc_list;
							Uslog.logf "usmanifests" Uslog.Debug "%s: list length=%u" __LOC__ (List.length !usmf_vharness_list);

						end
					;
					
		with Yojson.Basic.Util.Type_error _ -> 
				retval := false;
		;
	
		(!retval, !usmf_vharness_list)
	;;

(*
	(*--------------------------------------------------------------------------*)
	(* parse manifest node "uobj-binary" *)
	(* return true on successful parse, false if not *)
	(* return: if true then list of sections *)
	(*--------------------------------------------------------------------------*)
	let parse_node_uobj_binary usmf_json =
		let retval = ref false in
		let uobj_sections_list = ref [] in

		try
			let open Yojson.Basic.Util in
		  	let uobj_binary_json = usmf_json |> member "uobj-binary" in
					if uobj_binary_json != `Null then
						begin

							let uobj_sections_json = uobj_binary_json |> member "uobj-sections" in
								if uobj_sections_json != `Null then
									begin
										let uobj_sections_assoc_list = Yojson.Basic.Util.to_assoc uobj_sections_json in
											retval := true;
											List.iter (fun (x,y) ->
													Uslog.logf log_tag Uslog.Debug "%s: key=%s" __LOC__ x;
													let uobj_section_attribute_list = ref [] in
														uobj_section_attribute_list := !uobj_section_attribute_list @
																					[ x ];
														List.iter (fun z ->
															uobj_section_attribute_list := !uobj_section_attribute_list @
																					[ (z |> to_string) ];
															()
														)(Yojson.Basic.Util.to_list y);
														
														uobj_sections_list := !uobj_sections_list @	[ !uobj_section_attribute_list ];
														if (List.length (Yojson.Basic.Util.to_list y)) < 3 then
															retval:=false;
													()
												) uobj_sections_assoc_list;
											Uslog.logf log_tag Uslog.Debug "%s: list length=%u" __LOC__ (List.length !uobj_sections_list);
									end
								;		
					
						end
					;
															
		with Yojson.Basic.Util.Type_error _ -> 
				retval := false;
		;

								
		(!retval, !uobj_sections_list)
	;;
*)


(*
	(*--------------------------------------------------------------------------*)
	(* parse manifest node "uobj-publicmethods" *)
	(* return true on successful parse, false if not *)
	(* return: if true then list public methods *)
	(*--------------------------------------------------------------------------*)
	let parse_node_uobj_publicmethods usmf_json =
		let retval = ref false in
		let uobj_publicmethods_list = ref [] in

		try
			let open Yojson.Basic.Util in
		  	let uobj_publicmethods_json = usmf_json |> member "uobj-publicmethods" in
					if uobj_publicmethods_json != `Null then
						begin

							let uobj_publicmethods_assoc_list = Yojson.Basic.Util.to_assoc uobj_publicmethods_json in
								retval := true;
								List.iter (fun (x,y) ->
										Uslog.logf log_tag Uslog.Debug "%s: key=%s" __LOC__ x;
										let uobj_publicmethods_attribute_list = ref [] in
											uobj_publicmethods_attribute_list := !uobj_publicmethods_attribute_list @
																		[ x ];
											List.iter (fun z ->
												uobj_publicmethods_attribute_list := !uobj_publicmethods_attribute_list @
																		[ (z |> to_string) ];
												()
											)(Yojson.Basic.Util.to_list y);
											
											uobj_publicmethods_list := !uobj_publicmethods_list @	[ !uobj_publicmethods_attribute_list ];
											if (List.length (Yojson.Basic.Util.to_list y)) < 3 then
												retval:=false;
										()
									) uobj_publicmethods_assoc_list;
								Uslog.logf log_tag Uslog.Debug "%s: list length=%u" __LOC__ (List.length !uobj_publicmethods_list);

						end
					;
															
		with Yojson.Basic.Util.Type_error _ -> 
				retval := false;
		;

								
		(!retval, !uobj_publicmethods_list)
	;;


	(*--------------------------------------------------------------------------*)
	(* parse manifest node "uobj-calleemethods" *)
	(* return true on successful parse, false if not *)
	(* return: if true then hashtable of calleemethods indexed by uobj id*)
	(*--------------------------------------------------------------------------*)
	let parse_node_uobj_calleemethods usmf_json =
		let retval = ref true in
		let uobj_calleemethods_hashtbl = ((Hashtbl.create 32) : ((string, string list)  Hashtbl.t)) in

		try
			let open Yojson.Basic.Util in
		  	let uobj_calleemethods_json = usmf_json |> member "uobj-calleemethods" in
					if uobj_calleemethods_json != `Null then
						begin

							let uobj_calleemethods_assoc_list = Yojson.Basic.Util.to_assoc uobj_calleemethods_json in
								retval := true;
								List.iter (fun (x,y) ->
										Uslog.logf log_tag Uslog.Debug "%s: key=%s" __LOC__ x;
										let uobj_calleemethods_attribute_list = ref [] in
											List.iter (fun z ->
												uobj_calleemethods_attribute_list := !uobj_calleemethods_attribute_list @
																		[ (z |> to_string) ];
												()
											)(Yojson.Basic.Util.to_list y);
											
											Hashtbl.add uobj_calleemethods_hashtbl x !uobj_calleemethods_attribute_list;
										()
									) uobj_calleemethods_assoc_list;
						end
					;
															
		with Yojson.Basic.Util.Type_error _ -> 
				retval := false;
		;

								
		(!retval, uobj_calleemethods_hashtbl)
	;;
						

	(*--------------------------------------------------------------------------*)
	(* parse manifest node "uobj-exitcallees" *)
	(* return true on successful parse, false if not *)
	(* return: if true then list of exitcallees function names *)
	(*--------------------------------------------------------------------------*)
	let parse_node_usmf_uobj_exitcallees usmf_json =
		let retval = ref true in
		let uobj_exitcallees_list = ref [] in

		try
			let open Yojson.Basic.Util in
		  	let uobj_exitcallees_json = usmf_json |> member "uobj-exitcallees" in
					if uobj_exitcallees_json != `Null then
						begin
							let usmf_uobj_exitcallees_json_list = uobj_exitcallees_json |> 
									to_list in 
								List.iter (fun x -> uobj_exitcallees_list := 
										!uobj_exitcallees_list @ [(x |> to_string)]
									) usmf_uobj_exitcallees_json_list;
						end
					;
	
		with Yojson.Basic.Util.Type_error _ -> 
				retval := false;
		;
	
		(!retval, !uobj_exitcallees_list)
	;;
						
*)												
																		
																								
																																				
												
	(*--------------------------------------------------------------------------*)
	(* parse manifest node "uobj-coll" *)
	(* return true on successful parse, false if not *)
	(* return: if true then list of uobj directories *)
	(*--------------------------------------------------------------------------*)
	let parse_node_usmf_uobj_coll usmf_json =
		let retval = ref true in
		let usmf_uobj_dirs_list = ref [] in

		try
			let open Yojson.Basic.Util in
		  	let uobj_coll_json = usmf_json |> member "uobj-coll" in
					if uobj_coll_json != `Null then
						begin
							let usmf_uobj_coll_json_list = uobj_coll_json |> 
									to_list in 
								List.iter (fun x -> usmf_uobj_dirs_list := 
										!usmf_uobj_dirs_list @ [(x |> to_string)]
									) usmf_uobj_coll_json_list;
						end
					;
	
		with Yojson.Basic.Util.Type_error _ -> 
				retval := false;
		;
	
		(!retval, !usmf_uobj_dirs_list)
	;;
																								

	(*--------------------------------------------------------------------------*)
	(* parse manifest node "uobjcoll-sentineltypes" *)
	(* return true on successful parse, false if not *)
	(* return: if true then list sentinel types *)
	(*--------------------------------------------------------------------------*)
	let parse_node_usmf_uobjcoll_sentineltypes usmf_json =
		let retval = ref false in
		let uobjcoll_sentineltypes_list = ref [] in

		try
			let open Yojson.Basic.Util in
		  	let uobjcoll_sentineltypes_json = usmf_json |> member "uobjcoll-sentineltypes" in
					if uobjcoll_sentineltypes_json != `Null then
						begin

							let uobjcoll_sentineltypes_assoc_list = Yojson.Basic.Util.to_assoc uobjcoll_sentineltypes_json in
								retval := true;
								List.iter (fun (s_type, s_type_id_json) ->
										let s_type_id = Yojson.Basic.Util.to_string s_type_id_json in
										Uslog.logf log_tag Uslog.Debug "%s: type=%s type_id=%s" __LOC__ 
												s_type s_type_id;
											uobjcoll_sentineltypes_list := !uobjcoll_sentineltypes_list @	[ [s_type; s_type_id ] ];
										()
									) uobjcoll_sentineltypes_assoc_list;
								Uslog.logf log_tag Uslog.Debug "%s: list length=%u" __LOC__ (List.length !uobjcoll_sentineltypes_list);

						end
					;
															
		with Yojson.Basic.Util.Type_error _ -> 
				retval := false;
		;

								
		(!retval, !uobjcoll_sentineltypes_list)
	;;
																																													

	(*--------------------------------------------------------------------------*)
	(* parse manifest node "uobjcoll-entrycallees" *)
	(* return true on successful parse, false if not *)
	(* return: if true then hashtable of entrycallees indexed by uobj id*)
	(*--------------------------------------------------------------------------*)
	let parse_node_usmf_uobjcoll_entrycallees usmf_json =
		let retval = ref true in
		let uobjcoll_entrycallees_hashtbl = ((Hashtbl.create 32) : ((string, string list)  Hashtbl.t)) in

		try
			let open Yojson.Basic.Util in
		  	let uobjcoll_entrycallees_json = usmf_json |> member "uobjcoll-entrycallees" in
					if uobjcoll_entrycallees_json != `Null then
						begin

							let uobjcoll_entrycallees_assoc_list = Yojson.Basic.Util.to_assoc uobjcoll_entrycallees_json in
								retval := true;
								List.iter (fun (x,y) ->
										Uslog.logf log_tag Uslog.Debug "%s: key=%s" __LOC__ x;
										let uobjcoll_entrycallees_attribute_list = ref [] in
											List.iter (fun z ->
												uobjcoll_entrycallees_attribute_list := !uobjcoll_entrycallees_attribute_list @
																		[ (z |> to_string) ];
												()
											)(Yojson.Basic.Util.to_list y);
											
											Hashtbl.add uobjcoll_entrycallees_hashtbl x !uobjcoll_entrycallees_attribute_list;
										()
									) uobjcoll_entrycallees_assoc_list;
						end
					;
															
		with Yojson.Basic.Util.Type_error _ -> 
				retval := false;
		;

								
		(!retval, uobjcoll_entrycallees_hashtbl)
	;;

																																																																																																																																																																																				
	(*--------------------------------------------------------------------------*)
	(* parse manifest node "uobjcoll-exitcallees" *)
	(* return true on successful parse, false if not *)
	(* return: if true then hashtable of exitcallees indexed by callee function name*)
	(*--------------------------------------------------------------------------*)
	let parse_node_usmf_uobjcoll_exitcallees usmf_json =
		let retval = ref true in
		let uobjcoll_exitcallees_hashtbl = ((Hashtbl.create 32) : ((string, Ustypes.uobjcoll_exitcallee_t)  Hashtbl.t)) in

		try
			let open Yojson.Basic.Util in
		  	let uobjcoll_exitcallees_json = usmf_json |> member "uobjcoll-exitcallees" in
					if uobjcoll_exitcallees_json != `Null then
						begin

							let uobjcoll_exitcallees_assoc_list = Yojson.Basic.Util.to_assoc uobjcoll_exitcallees_json in
								retval := true;
								List.iter (fun (x,y) ->
										Uslog.logf log_tag Uslog.Debug "%s: key=%s" __LOC__ x;
										
										Hashtbl.add uobjcoll_exitcallees_hashtbl x 
										{
											s_retvaldecl = Yojson.Basic.Util.to_string (List.nth (Yojson.Basic.Util.to_list y) 0);
											s_fname = x;
											s_fparamdecl = Yojson.Basic.Util.to_string (List.nth (Yojson.Basic.Util.to_list y) 1);
											s_fparamdwords = int_of_string ( Yojson.Basic.Util.to_string (List.nth (Yojson.Basic.Util.to_list y) 2));
										};
				
										()
									) uobjcoll_exitcallees_assoc_list;
						end
					;
															
		with Yojson.Basic.Util.Type_error _ -> 
				retval := false;
		;

								
		(!retval, uobjcoll_exitcallees_hashtbl)
	;;
																																																																																																																																																																																				
																																																																																																																																																																																				
																																																																																							
	end