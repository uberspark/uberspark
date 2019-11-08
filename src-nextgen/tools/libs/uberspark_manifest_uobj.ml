(*----------------------------------------------------------------------------*)
(* uberSpark manifest interface for uobj*)
(*	 author: amit vasudevan (amitvasudevan@acm.org) *)
(*----------------------------------------------------------------------------*)

type uobj_hdr_t =
{
	mutable f_namespace    : string;			
	mutable f_platform	   : string;
	mutable f_arch	       : string;
	mutable f_cpu		   : string;
};;

type uobj_publicmethods_t = 
{
	f_name: string;
	f_retvaldecl : string;
	f_paramdecl: string;
	f_paramdwords : int;
};;


(*--------------------------------------------------------------------------*)
(* parse manifest json node "uobj-hdr" *)
(* return: *)
(* on success: true; uobj_hdr fields are modified with parsed values *)
(* on failure: false; uobj_hdr fields are untouched *)
(*--------------------------------------------------------------------------*)
let parse_uobj_hdr 
	(mf_json : Yojson.Basic.t)
	(uobj_hdr : uobj_hdr_t) 
	: bool =
	let retval = ref false in

	try
		let open Yojson.Basic.Util in
			let json_uobj_hdr = mf_json |> member "uobj-hdr" in
			if(json_uobj_hdr <> `Null) then
				begin
					uobj_hdr.f_namespace <- json_uobj_hdr |> member "namespace" |> to_string;
					uobj_hdr.f_platform <- json_uobj_hdr |> member "platform" |> to_string;
					uobj_hdr.f_arch <- json_uobj_hdr |> member "arch" |> to_string;
					uobj_hdr.f_cpu <- json_uobj_hdr |> member "cpu" |> to_string;
					retval := true;
				end
			;

	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval)
;;


(*--------------------------------------------------------------------------*)
(* parse manifest json node "uobj-sources" *)
(* return: *)
(* on success: true; h,c,casm file lists are modified with parsed values *)
(* on failure: false; h,c,casm file lists are untouched *)
(*--------------------------------------------------------------------------*)
let parse_uobj_sources 
	(mf_json : Yojson.Basic.t)
	(h_file_list : string list ref)
	(c_file_list : string list ref)
	(casm_file_list : string list ref)
	: bool =

	let retval = ref true in

	try
		let open Yojson.Basic.Util in
			let mf_uobj_sources_json = mf_json |> member "uobj-sources" in
			if mf_uobj_sources_json != `Null then
					begin

						let mf_hfiles_json = mf_uobj_sources_json |> member "h-files" in
							if mf_hfiles_json != `Null then
								begin
									let hfiles_json_list = mf_hfiles_json |> 
											to_list in 
										List.iter (fun x -> h_file_list := 
												!h_file_list @ [(x |> to_string)]
											) hfiles_json_list;
								end
							;

						let mf_cfiles_json = mf_uobj_sources_json |> member "c-files" in
							if mf_cfiles_json != `Null then
								begin
									let cfiles_json_list = mf_cfiles_json |> 
											to_list in 
										List.iter (fun x -> c_file_list := 
												!c_file_list @ [(x |> to_string)]
											) cfiles_json_list;
								end
							;

						let mf_casmfiles_json = mf_uobj_sources_json |> member "casm-files" in
							if mf_casmfiles_json != `Null then
								begin
									let casmfiles_json_list = mf_casmfiles_json |> 
											to_list in 
										List.iter (fun x -> casm_file_list := 
												!casm_file_list @ [(x |> to_string)]
											) casmfiles_json_list;
								end
							;
							
					end
				;
				
	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval)
;;



(*--------------------------------------------------------------------------*)
(* parse manifest json node "uobj-publicmethods" *)
(* return: *)
(* on success: true; public methods hash table is modified with parsed values *)
(* on failure: false; hash table is left untouched *)
(*--------------------------------------------------------------------------*)
let parse_uobj_publicmethods
	(mf_json : Yojson.Basic.t)
	(publicmethods_hashtbl : ((string, uobj_publicmethods_t)  Hashtbl.t))
	: bool =
		
	let retval = ref false in

	try
		let open Yojson.Basic.Util in
			let uobj_publicmethods_json = mf_json |> member "uobj-publicmethods" in
				if uobj_publicmethods_json != `Null then
					begin

						let uobj_publicmethods_assoc_list = Yojson.Basic.Util.to_assoc uobj_publicmethods_json in
							retval := true;
							
							List.iter (fun (x,y) ->
								let uobj_publicmethods_inner_list = (Yojson.Basic.Util.to_list y) in 
								if (List.length uobj_publicmethods_inner_list) <> 3 then
									begin
										retval := false;
									end
								else
									begin
										let tbl_entry : uobj_publicmethods_t = 
											{
												f_name = x;
												f_retvaldecl = (List.nth uobj_publicmethods_inner_list 0) |> to_string;
												f_paramdecl = (List.nth uobj_publicmethods_inner_list 1) |> to_string;
												f_paramdwords = int_of_string ((List.nth uobj_publicmethods_inner_list 2) |> to_string );
											} in

										Hashtbl.add publicmethods_hashtbl x tbl_entry; 
												
										retval := true; 
									end
								;
					
								()
							) uobj_publicmethods_assoc_list;

					end
				;
														
	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

							
	(!retval)
;;


(*--------------------------------------------------------------------------*)
(* parse manifest json node "uobj-intrauobjcoll-callees" *)
(* return: *)
(* on success: true; intrauobjcoll-callees hash table modified with parsed values *)
(* on failure: false; intrauobjcoll-callees hash table is left untouched *)
(*--------------------------------------------------------------------------*)
let parse_uobj_intrauobjcoll_callees 
	(mf_json : Yojson.Basic.t)
	(intrauobjcoll_callees_hashtbl : ((string, string list)  Hashtbl.t) )
	: bool =
	
	let retval = ref true in

	try
		let open Yojson.Basic.Util in
			let uobj_callees_json = mf_json |> member "uobj-intrauobjcoll-callees" in
				if uobj_callees_json != `Null then
					begin

						let uobj_callees_assoc_list = Yojson.Basic.Util.to_assoc uobj_callees_json in
							retval := true;
							List.iter (fun (x,y) ->
									let uobj_callees_attribute_list = ref [] in
										List.iter (fun z ->
											uobj_callees_attribute_list := !uobj_callees_attribute_list @
																	[ (z |> to_string) ];
											()
										)(Yojson.Basic.Util.to_list y);
										
										Hashtbl.add intrauobjcoll_callees_hashtbl x !uobj_callees_attribute_list;
									()
								) uobj_callees_assoc_list;
					end
				;
														
	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

							
	(!retval)
;;




(*--------------------------------------------------------------------------*)
(* parse manifest json node "uobj-interuobjcoll-callees" *)
(* return: *)
(* on success: true; interuobjcoll-callees hash table modified with parsed values *)
(* on failure: false; interuobjcoll-callees hash table is left untouched *)
(*--------------------------------------------------------------------------*)
let parse_uobj_interuobjcoll_callees 
	(mf_json : Yojson.Basic.t)
	(interuobjcoll_callees_hashtbl : ((string, string list)  Hashtbl.t) )
	: bool =

	let retval = ref true in

	try
		let open Yojson.Basic.Util in
			let uobj_callees_json = mf_json |> member "uobj-interuobjcoll-callees" in
				if uobj_callees_json != `Null then
					begin

						let uobj_callees_assoc_list = Yojson.Basic.Util.to_assoc uobj_callees_json in
							retval := true;
							List.iter (fun (x,y) ->
									let uobj_callees_attribute_list = ref [] in
										List.iter (fun z ->
											uobj_callees_attribute_list := !uobj_callees_attribute_list @
																	[ (z |> to_string) ];
											()
										)(Yojson.Basic.Util.to_list y);
										
										Hashtbl.add interuobjcoll_callees_hashtbl x !uobj_callees_attribute_list;
									()
								) uobj_callees_assoc_list;
					end
				;
														
	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

							
	(!retval)
;;



(*--------------------------------------------------------------------------*)
(* parse manifest json node "uobj-legacy-callees" *)
(* return: *)
(* on success: true; legacy-callees string list modified with parsed values *)
(* on failure: false; legacy-callees string list is left untouched *)
(*--------------------------------------------------------------------------*)
let parse_uobj_legacy_callees 
	(mf_json : Yojson.Basic.t)
	(legacy_callees_list : string list ref )
	: bool =

	let retval = ref true in

	try
		let open Yojson.Basic.Util in
			let uobj_legacy_callees_json = mf_json |> member "uobj-legacy-callees" in
				if uobj_legacy_callees_json != `Null then
					begin

						let uobj_legacy_callees_list = Yojson.Basic.Util.to_list uobj_legacy_callees_json in
							legacy_callees_list := json_list_to_string_list uobj_legacy_callees_list;
							retval := true;

					end
				;
														
	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

							
	(!retval)
;;





(*--------------------------------------------------------------------------*)
(* parse manifest json node "uobj-binary/uobj-sections" *)
(* return: *)
(* on success: true; sections hash table modified with parsed values *)
(* on failure: false; sections hash table is left untouched *)
(*--------------------------------------------------------------------------*)
let parse_uobj_sections 
	(mf_json : Yojson.Basic.t)
	(sections_hashtbl : ((string, Defs.Basedefs.section_info_t)  Hashtbl.t) )
	: bool =

	let retval = ref false in

	try
	let open Yojson.Basic.Util in
		let uobj_binary_json = mf_json |> member "uobj-binary" in
			if uobj_binary_json != `Null then
				begin

					let uobj_sections_json = uobj_binary_json |> member "uobj-sections" in
						if uobj_sections_json != `Null then
							begin
								
								let uobj_sections_assoc_list = Yojson.Basic.Util.to_assoc uobj_sections_json in
									retval := true;
									List.iter (fun (x,y) ->
											(* x = section name, y = list of section attributes *)
											let uobj_sections_attribute_list = (Yojson.Basic.Util.to_list y) in
												if (List.length uobj_sections_attribute_list  < 6 ) then
													begin
														Uberspark_logger.log ~lvl:Uberspark_logger.Error "insufficient entries within section attribute list for section: %s" x;															retval := false;
													end
												else
													begin
														let subsection_list = ref [] in 
														for index = 5 to ((List.length uobj_sections_attribute_list)-1) do 
															subsection_list := !subsection_list @	[ ((List.nth uobj_sections_attribute_list index) |> to_string) ]
														done;

														let section_entry : Defs.Basedefs.section_info_t = 
														{ 
															f_name = (x);	
															f_subsection_list = !subsection_list;	
															usbinformat = { f_type = int_of_string ((List.nth uobj_sections_attribute_list 0) |> to_string); 
																							f_prot = int_of_string ((List.nth uobj_sections_attribute_list 1) |> to_string); 
																							f_size = int_of_string ((List.nth uobj_sections_attribute_list 2) |> to_string);
																							f_aligned_at = int_of_string ((List.nth uobj_sections_attribute_list 3) |> to_string); 
																							f_pad_to = int_of_string ((List.nth uobj_sections_attribute_list 4) |> to_string); 
																							f_addr_start=0; 
																							f_addr_file = 0;
																							f_reserved = 0;
																						};
														} in
							
															Hashtbl.add sections_hashtbl x section_entry; 
														
														retval := true;
													end
												;
											()
										) uobj_sections_assoc_list;
							end
						;		
			
				end
			;
													
	with Yojson.Basic.Util.Type_error _ -> 
		retval := false;
	;

						
	(!retval)
;;
