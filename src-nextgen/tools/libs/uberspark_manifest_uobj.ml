(*===========================================================================*)
(*===========================================================================*)
(* uberSpark uobj manifest interface implementation *)
(*	 author: amit vasudevan (amitvasudevan@acm.org) *)
(*===========================================================================*)
(*===========================================================================*)


(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* type definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)

type json_node_uberspark_uobj_uobjrtl_t = 
{
	mutable f_namespace: string;
};;


type json_node_uberspark_uobj_sources_t = 
{
	mutable f_h_files: string list;
	mutable f_c_files: string list;
	mutable f_casm_files: string list;
	mutable f_asm_files : string list;
};;

type json_node_uberspark_uobj_publicmethods_t = 
{
	mutable f_name: string;
	mutable f_retvaldecl : string;
	mutable f_paramdecl: string;
	mutable f_paramdwords : int;
	mutable f_addr : int;
};;
	

type json_node_uberspark_uobj_t = 
{
	mutable f_namespace: string;
	mutable f_platform : string;
	mutable f_arch: string;
	mutable f_cpu : string;
	mutable f_sources : json_node_uberspark_uobj_sources_t;
	mutable f_publicmethods :  (string * json_node_uberspark_uobj_publicmethods_t) list;
	mutable f_intrauobjcoll_callees : (string * string list) list;
	mutable f_interuobjcoll_callees : (string * string list) list;
	mutable f_legacy_callees : (string * string list) list;
	mutable f_sections : (string * Defs.Basedefs.section_info_t) list;
	mutable f_uobjrtl : json_node_uberspark_uobj_uobjrtl_t list;
};;


(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* interface definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)


(*--------------------------------------------------------------------------*)
(* parse manifest json sub-node "sources" into var *)
(* return: *)
(* on success: true; var is modified with h,c,casm,asm file lists *)
(* on failure: false; var is unmodified *)
(*--------------------------------------------------------------------------*)
let json_node_uberspark_uobj_sources_to_var 
	(json_node_uberspark_uobj : Yojson.Basic.t)
	(json_node_uberspark_uobj_source_var : json_node_uberspark_uobj_sources_t)
	: bool =

	let retval = ref true in

	try
		let open Yojson.Basic.Util in
			let json_node_uberspark_uobj_sources = json_node_uberspark_uobj |> member "sources" in
			if json_node_uberspark_uobj_sources != `Null then
					begin

						let mf_hfiles_json = json_node_uberspark_uobj_sources |> member "h-files" in
							if mf_hfiles_json != `Null then
								begin
									let hfiles_json_list = mf_hfiles_json |> 
											to_list in 
										List.iter (fun x -> json_node_uberspark_uobj_source_var.f_h_files <- 
												json_node_uberspark_uobj_source_var.f_h_files @ [(x |> to_string)]
											) hfiles_json_list;
								end
							;

						let mf_cfiles_json = json_node_uberspark_uobj_sources |> member "c-files" in
							if mf_cfiles_json != `Null then
								begin
									let cfiles_json_list = mf_cfiles_json |> 
											to_list in 
										List.iter (fun x -> json_node_uberspark_uobj_source_var.f_c_files <- 
												json_node_uberspark_uobj_source_var.f_c_files @ [(x |> to_string)]
											) cfiles_json_list;
								end
							;

						let mf_casmfiles_json = json_node_uberspark_uobj_sources |> member "casm-files" in
							if mf_casmfiles_json != `Null then
								begin
									let casmfiles_json_list = mf_casmfiles_json |> 
											to_list in 
										List.iter (fun x -> json_node_uberspark_uobj_source_var.f_casm_files <- 
												json_node_uberspark_uobj_source_var.f_casm_files @ [(x |> to_string)]
											) casmfiles_json_list;
								end
							;

						let mf_asmfiles_json = json_node_uberspark_uobj_sources |> member "asm-files" in
							if mf_asmfiles_json != `Null then
								begin
									let asmfiles_json_list = mf_asmfiles_json |> 
											to_list in 
										List.iter (fun x -> json_node_uberspark_uobj_source_var.f_asm_files <- 
												json_node_uberspark_uobj_source_var.f_asm_files @ [(x |> to_string)]
											) asmfiles_json_list;
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
(* parse manifest json sub-node "publicmethods" into var *)
(* return: *)
(* on success: true; var is modified with publicmethod declarations *)
(* on failure: false; var is unmodified *)
(*--------------------------------------------------------------------------*)
let json_node_uberspark_uobj_publicmethods_to_var
	(json_node_uberspark_uobj : Yojson.Basic.t)
	: bool *  ((string * json_node_uberspark_uobj_publicmethods_t) list)
=
		
	let retval = ref false in
	let publicmethods_assoc_list : (string * json_node_uberspark_uobj_publicmethods_t) list ref = ref [] in 

	try
		let open Yojson.Basic.Util in
			let uobj_publicmethods_json = json_node_uberspark_uobj |> member "publicmethods" in
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
										let tbl_entry : json_node_uberspark_uobj_publicmethods_t = 
											{
												f_name = x;
												f_retvaldecl = (List.nth uobj_publicmethods_inner_list 0) |> to_string;
												f_paramdecl = (List.nth uobj_publicmethods_inner_list 1) |> to_string;
												f_paramdwords = int_of_string ((List.nth uobj_publicmethods_inner_list 2) |> to_string );
												f_addr = 0; 
											} in


										publicmethods_assoc_list := !publicmethods_assoc_list @ [ (x, tbl_entry)];
		
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

							
	(!retval, !publicmethods_assoc_list)
;;



(*--------------------------------------------------------------------------*)
(* parse manifest json sub-node "intrauobjcoll-callees" into var *)
(* return: *)
(* on success: true; var is modified with intrauobjcoll-callees declarations *)
(* on failure: false; var is unmodified *)
(*--------------------------------------------------------------------------*)
let json_node_uberspark_uobj_intrauobjcoll_callees_to_var
	(json_node_uberspark_uobj : Yojson.Basic.t)
	: bool *  ((string * string list) list) =
	
	let retval = ref true in
	let intrauobjcoll_callees_assoc_list : (string * string list) list ref = ref [] in
	try
		let open Yojson.Basic.Util in
			let uobj_callees_json =  json_node_uberspark_uobj |> member "intrauobjcoll-callees" in
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
										
										intrauobjcoll_callees_assoc_list := !intrauobjcoll_callees_assoc_list @ 
											[ (x, !uobj_callees_attribute_list)];
									()
								) uobj_callees_assoc_list;
					end
				;
														
	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

							
	(!retval, !intrauobjcoll_callees_assoc_list)
;;


(*--------------------------------------------------------------------------*)
(* parse manifest json sub-node "interuobjcoll-callees" into var *)
(* return: *)
(* on success: true; var is modified with interuobjcoll-callees declarations *)
(* on failure: false; var is unmodified *)
(*--------------------------------------------------------------------------*)
let json_node_uberspark_uobj_interuobjcoll_callees_to_var
	(json_node_uberspark_uobj : Yojson.Basic.t)
	: bool *  ((string * string list) list) =
	
	let retval = ref true in
	let interuobjcoll_callees_assoc_list : (string * string list) list ref = ref [] in

	try
		let open Yojson.Basic.Util in
			let uobj_callees_json = json_node_uberspark_uobj |> member "interuobjcoll-callees" in
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

										interuobjcoll_callees_assoc_list := !interuobjcoll_callees_assoc_list @ 
											[ (x, !uobj_callees_attribute_list)];
									()
								) uobj_callees_assoc_list;
					end
				;
														
	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

							
	(!retval, !interuobjcoll_callees_assoc_list)
;;


(*--------------------------------------------------------------------------*)
(* parse manifest json sub-node "legacy-callees" into var *)
(* return: *)
(* on success: true; var is modified with legacyl-callees declarations *)
(* on failure: false; var is unmodified *)
(*--------------------------------------------------------------------------*)
let json_node_uberspark_uobj_legacy_callees_to_var
	(json_node_uberspark_uobj : Yojson.Basic.t)
	: bool *  ((string * string list) list) =

	let retval = ref true in
	let legacy_callees_assoc_list : (string * string list) list ref = ref [] in

	try
		let open Yojson.Basic.Util in
			let uobj_legacy_callees_json = json_node_uberspark_uobj |> member "legacy-callees" in
				if uobj_legacy_callees_json != `Null then
					begin

						let uobj_legacy_callees_list = Yojson.Basic.Util.to_list uobj_legacy_callees_json in
						let str_list_uobj_callees_list = (json_list_to_string_list uobj_legacy_callees_list) in

							if (List.length str_list_uobj_callees_list) > 0  then begin
								legacy_callees_assoc_list := !legacy_callees_assoc_list @ 
									[ ("uberspark_legacy", (json_list_to_string_list uobj_legacy_callees_list))];
							end;
							
							retval := true;

					end
				;
														
	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

							
	(!retval, !legacy_callees_assoc_list)
;;



(*--------------------------------------------------------------------------*)
(* parse manifest json sub-node "sections" into var *)
(* return: *)
(* on success: true; var is modified with sections declarations *)
(* on failure: false; var is unmodified *)
(*--------------------------------------------------------------------------*)
let json_node_uberspark_uobj_sections_to_var
	(json_node_uberspark_uobj : Yojson.Basic.t)
	: bool *  ((string * Defs.Basedefs.section_info_t) list) =

	let retval = ref true in
	let sections_assoc_list : (string * Defs.Basedefs.section_info_t) list ref = ref [] in

	try
	let open Yojson.Basic.Util in

		let uobj_sections_json = json_node_uberspark_uobj |> member "sections" in
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
				
											sections_assoc_list := !sections_assoc_list @ [ (x, section_entry) ]; 
											
											retval := true;
										end
									;
								()
							) uobj_sections_assoc_list;
				end
			;		
			
													
	with Yojson.Basic.Util.Type_error _ -> 
		retval := false;
	;

						
	(!retval, !sections_assoc_list)
;;


(*--------------------------------------------------------------------------*)
(* parse manifest json sub-node "uobjrtl" into var *)
(* return: *)
(* on success: true; var is modified with uobjrtl declarations *)
(* on failure: false; var is unmodified *)
(*--------------------------------------------------------------------------*)
let json_node_uberspark_uobj_uobjrtl_to_var
	(json_node_uberspark_uobj : Yojson.Basic.t)
	: bool *  (json_node_uberspark_uobj_uobjrtl_t list)
=
		
	let retval = ref false in
	let uobjrtl_list : json_node_uberspark_uobj_uobjrtl_t list ref = ref [] in 

	try
		let open Yojson.Basic.Util in
			let uobj_uobjrtl_json = json_node_uberspark_uobj |> member "uobjrtl" in
				if uobj_uobjrtl_json != `Null then
					begin

						let uobj_uobjrtl_list = Yojson.Basic.Util.to_list uobj_uobjrtl_json in
							retval := true;
							
							List.iter (fun x ->
								let f_uobjrtl_element : json_node_uberspark_uobj_uobjrtl_t = 
									{ f_namespace = ""; } in
								
								f_uobjrtl_element.f_namespace <- Yojson.Basic.Util.to_string (x |> member "namespace");

								uobjrtl_list := !uobjrtl_list @ [ f_uobjrtl_element ];
													
								()
							) uobj_uobjrtl_list;

					end
				;
														
	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

							
	(!retval, !uobjrtl_list)
;;



(*--------------------------------------------------------------------------*)
(* parse manifest json node "uberspark-uobj" into var *)
(* return: *)
(* on success: true; var is modified with uberspark-uobj json node declarations *)
(* on failure: false; var is unmodified *)
(*--------------------------------------------------------------------------*)
let json_node_uberspark_uobj_to_var
	(mf_json : Yojson.Basic.t)
	(json_node_uberspark_uobj_var : json_node_uberspark_uobj_t)
	: bool =

	let retval = ref false in

	try
		let open Yojson.Basic.Util in
			let json_node_uberspark_uobj = mf_json |> member "uberspark-uobj" in
				if json_node_uberspark_uobj != `Null then begin
					json_node_uberspark_uobj_var.f_namespace <- json_node_uberspark_uobj |> member "namespace" |> to_string;
					json_node_uberspark_uobj_var.f_platform <- json_node_uberspark_uobj |> member "platform" |> to_string;
					json_node_uberspark_uobj_var.f_arch <- json_node_uberspark_uobj |> member "arch" |> to_string;
					json_node_uberspark_uobj_var.f_cpu <- json_node_uberspark_uobj |> member "cpu" |> to_string;
					
					let rval1 = (json_node_uberspark_uobj_sources_to_var json_node_uberspark_uobj json_node_uberspark_uobj_var.f_sources) in
					let (rval2, json_node_uberspark_uobj_publicmethods_var) = (json_node_uberspark_uobj_publicmethods_to_var json_node_uberspark_uobj) in
					let (rval3, json_node_uberspark_uobj_intrauobjcoll_callees_var) = (json_node_uberspark_uobj_intrauobjcoll_callees_to_var json_node_uberspark_uobj) in
					let (rval4, json_node_uberspark_uobj_interuobjcoll_callees_var) = (json_node_uberspark_uobj_interuobjcoll_callees_to_var json_node_uberspark_uobj) in
					let (rval5, json_node_uberspark_uobj_legacy_callees_var) = (json_node_uberspark_uobj_legacy_callees_to_var json_node_uberspark_uobj) in
					let (rval6, json_node_uberspark_uobj_sections_var) = (json_node_uberspark_uobj_sections_to_var json_node_uberspark_uobj) in

					if (rval1 && rval2 && rval3 && rval4 && rval5 && rval6) then begin

						json_node_uberspark_uobj_var.f_publicmethods <- json_node_uberspark_uobj_publicmethods_var;
						json_node_uberspark_uobj_var.f_intrauobjcoll_callees <- json_node_uberspark_uobj_intrauobjcoll_callees_var;
						json_node_uberspark_uobj_var.f_interuobjcoll_callees <- json_node_uberspark_uobj_interuobjcoll_callees_var;
						json_node_uberspark_uobj_var.f_legacy_callees <- json_node_uberspark_uobj_legacy_callees_var;
						json_node_uberspark_uobj_var.f_sections <- json_node_uberspark_uobj_sections_var;

						retval := true;
					end;

				end;
														
	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;


	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "json_node_uberspark_uobj_to_var: retval=%b" !retval;		
	(!retval)
;;




