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
	mutable namespace: string;
};;

type json_node_uberspark_uobj_publicmethods_t = 
{
	mutable fn_name: string;
	mutable fn_decl_return_value : string;
	mutable fn_decl_parameters: string;
	mutable fn_decl_parameter_size : int;
	mutable fn_address : int;
};;
	

type json_node_uberspark_uobj_t = 
{
	mutable namespace: string;
	mutable platform : string;
	mutable arch: string;
	mutable cpu : string;
	mutable sources : string list;
	mutable headers : string list;
	mutable public_methods :  (string * json_node_uberspark_uobj_publicmethods_t) list;
	mutable intra_uobjcoll_callees : (string * string list) list;
	mutable inter_uobjcoll_callees : (string * string list) list;
	mutable legacy_callees : (string * string list) list;
	mutable sections : (string * Uberspark.Defs.Basedefs.section_info_t) list;
	mutable uobjrtl : (string * json_node_uberspark_uobj_uobjrtl_t) list;
};;


(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* interface definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)



(*--------------------------------------------------------------------------*)
(* parse manifest json sub-node "public_methods" into var *)
(* return: *)
(* on success: true; var is modified with publicmethod declarations *)
(* on failure: false; var is unmodified *)
(*--------------------------------------------------------------------------*)
let json_node_uberspark_uobj_publicmethods_to_var
	(mf_json : Yojson.Basic.t)
	: bool *  ((string * json_node_uberspark_uobj_publicmethods_t) list)
=
		
	let retval = ref true in
	let publicmethods_assoc_list : (string * json_node_uberspark_uobj_publicmethods_t) list ref = ref [] in 

	try
		let open Yojson.Basic.Util in
			let uobj_publicmethods_json = mf_json |> member "uberspark.uobj.public_methods" in
				if uobj_publicmethods_json != `Null then
					begin

						let uobj_publicmethods_assoc_list = Yojson.Basic.Util.to_assoc uobj_publicmethods_json in
							
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
												fn_name = x;
												fn_decl_return_value = (List.nth uobj_publicmethods_inner_list 0) |> to_string;
												fn_decl_parameters = (List.nth uobj_publicmethods_inner_list 1) |> to_string;
												fn_decl_parameter_size = int_of_string ((List.nth uobj_publicmethods_inner_list 2) |> to_string );
												fn_address = 0; 
											} in


										publicmethods_assoc_list := !publicmethods_assoc_list @ [ (x, tbl_entry)];
		
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
	(mf_json : Yojson.Basic.t)
	: bool *  ((string * string list) list) =
	
	let retval = ref true in
	let intrauobjcoll_callees_assoc_list : (string * string list) list ref = ref [] in
	try
		let open Yojson.Basic.Util in
			let uobj_callees_json =  mf_json |> member "uberspark.uobj.intra_uobjcoll_callees" in
				if uobj_callees_json != `Null then
					begin

						let uobj_callees_assoc_list = Yojson.Basic.Util.to_assoc uobj_callees_json in
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
	(mf_json : Yojson.Basic.t)
	: bool *  ((string * string list) list) =
	
	let retval = ref true in
	let interuobjcoll_callees_assoc_list : (string * string list) list ref = ref [] in

	try
		let open Yojson.Basic.Util in
			let uobj_callees_json = mf_json |> member "uberspark.uobj.inter_uobjcoll_callees" in
				if uobj_callees_json != `Null then
					begin

						let uobj_callees_assoc_list = Yojson.Basic.Util.to_assoc uobj_callees_json in
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
	(mf_json : Yojson.Basic.t)
	: bool *  ((string * string list) list) =

	let retval = ref true in
	let legacy_callees_assoc_list : (string * string list) list ref = ref [] in

	try
		let open Yojson.Basic.Util in
			let uobj_legacy_callees_json = mf_json |> member "uberspark.uobj.legacy_callees" in
				if uobj_legacy_callees_json != `Null then
					begin

						let uobj_legacy_callees_list = Yojson.Basic.Util.to_list uobj_legacy_callees_json in
						let str_list_uobj_callees_list = (json_list_to_string_list uobj_legacy_callees_list) in

							if (List.length str_list_uobj_callees_list) > 0  then begin
								legacy_callees_assoc_list := !legacy_callees_assoc_list @ 
									[ ("uberspark_legacy", (json_list_to_string_list uobj_legacy_callees_list))];
							end;
							
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
	(mf_json : Yojson.Basic.t)
	: bool *  ((string * Uberspark.Defs.Basedefs.section_info_t) list) =

	let retval = ref true in
	let sections_assoc_list : (string * Uberspark.Defs.Basedefs.section_info_t) list ref = ref [] in


	try
		let open Yojson.Basic.Util in
			let uobj_sections_json = mf_json |> member "uberspark.uobj.sections" in
				if uobj_sections_json != `Null then
					begin

						let uobj_sections_list = Yojson.Basic.Util.to_list uobj_sections_json in
							
							List.iter (fun x ->
								let section_entry : Uberspark.Defs.Basedefs.section_info_t = 
								{ 
									fn_name = "";	
									f_subsection_list = [];	
									usbinformat = { f_type = 0; 
													f_prot = 0; 
													f_size = 0;
													f_aligned_at = 0; 
													f_pad_to = 0; 
													f_addr_start=0; 
													f_addr_file = 0;
													f_reserved = 0;
													};
								} in

								(* required field *)
								section_entry.fn_name <- 
									Yojson.Basic.Util.to_string (x |> member "name");	

								(* required field *)
								section_entry.usbinformat.f_size <- 
									int_of_string (Yojson.Basic.Util.to_string (x |> member "size"));

								(* 
									this is required for developer defined sections, but we dont complain here
									but allow the linking phase to complain if any references to this
									section appear
								*)
								if (x |> member "output_names") != `Null then begin
									section_entry.f_subsection_list <- 
										json_list_to_string_list ( Yojson.Basic.Util.to_list (x |> member "output_names") );	
								end;


								(* the following fields are all optional *)
								if (x |> member "type") != `Null then begin
									section_entry.usbinformat.f_type <-
										int_of_string (Yojson.Basic.Util.to_string (x |> member "type"));
								end;

								if (x |> member "attribute") != `Null then begin
									section_entry.usbinformat.f_prot <- 
										int_of_string (Yojson.Basic.Util.to_string (x |> member "attribute")); 
								end;

								if (x |> member "aligned_at") != `Null then begin
									section_entry.usbinformat.f_aligned_at <- 
										int_of_string (Yojson.Basic.Util.to_string (x |> member "aligned_at")); 
								end;

								if (x |> member "pad_to") != `Null then begin
									section_entry.usbinformat.f_pad_to <- 
										int_of_string (Yojson.Basic.Util.to_string (x |> member "pad_to")); 
								end;


								sections_assoc_list := !sections_assoc_list @ [ (section_entry.fn_name, section_entry) ];
												
								()
							) uobj_sections_list;

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
	(mf_json : Yojson.Basic.t)
	: bool *  ((string * json_node_uberspark_uobj_uobjrtl_t) list)
=
		
	let retval = ref true in
	let uobjrtl_assoc_list : (string * json_node_uberspark_uobj_uobjrtl_t) list ref = ref [] in 

	try
		let open Yojson.Basic.Util in
			let uobj_uobjrtl_json = mf_json |> member "uberspark.uobj.uobjrtl" in
				if uobj_uobjrtl_json != `Null then
					begin

						let uobj_uobjrtl_list = Yojson.Basic.Util.to_list uobj_uobjrtl_json in
							
							List.iter (fun x ->
								let f_uobjrtl_element : json_node_uberspark_uobj_uobjrtl_t = 
									{ namespace = ""; } in
								
								let uobjrtl_namespace = Yojson.Basic.Util.to_string (x |> member "namespace") in
								f_uobjrtl_element.namespace <- uobjrtl_namespace;

								uobjrtl_assoc_list := !uobjrtl_assoc_list @ [ (uobjrtl_namespace, f_uobjrtl_element) ];
													
								()
							) uobj_uobjrtl_list;

					end
				;
														
	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

							
	(!retval, !uobjrtl_assoc_list)
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

	let retval = ref true in

	try
		let open Yojson.Basic.Util in
					if (mf_json |> member "uberspark.uobj.namespace") != `Null then
						json_node_uberspark_uobj_var.namespace <- mf_json |> member "uberspark.uobj.namespace" |> to_string;
	
					if (mf_json |> member "uberspark.uobj.platform") != `Null then
						json_node_uberspark_uobj_var.platform <- mf_json |> member "uberspark.uobj.platform" |> to_string;

					if (mf_json |> member "uberspark.uobj.arch") != `Null then
						json_node_uberspark_uobj_var.arch <- mf_json |> member "uberspark.uobj.arch" |> to_string;
					
					if (mf_json |> member "uberspark.uobj.cpu") != `Null then
						json_node_uberspark_uobj_var.cpu <- mf_json |> member "uberspark.uobj.cpu" |> to_string;
					
					if (mf_json |> member "uberspark.uobj.sources") != `Null then
						json_node_uberspark_uobj_var.sources <- (json_list_to_string_list (mf_json |> member "uberspark.uobj.sources" |> to_list));

					if (mf_json |> member "uberspark.uobj.headers") != `Null then
						json_node_uberspark_uobj_var.headers <- (json_list_to_string_list (mf_json |> member "uberspark.uobj.headers" |> to_list));


					(* let rval1 = (json_node_uberspark_uobj_sources_to_var mf_json json_node_uberspark_uobj_var.sources) in*)
					let (rval2, json_node_uberspark_uobj_publicmethods_var) = (json_node_uberspark_uobj_publicmethods_to_var mf_json) in
					let (rval3, json_node_uberspark_uobj_intrauobjcoll_callees_var) = (json_node_uberspark_uobj_intrauobjcoll_callees_to_var mf_json) in
					let (rval4, json_node_uberspark_uobj_interuobjcoll_callees_var) = (json_node_uberspark_uobj_interuobjcoll_callees_to_var mf_json) in
					let (rval5, json_node_uberspark_uobj_legacy_callees_var) = (json_node_uberspark_uobj_legacy_callees_to_var mf_json) in
					let (rval6, json_node_uberspark_uobj_sections_var) = (json_node_uberspark_uobj_sections_to_var mf_json) in
					let (rval7, json_node_uberspark_uobj_uobjrtl_var) = (json_node_uberspark_uobj_uobjrtl_to_var mf_json) in

					if rval2 then begin
						json_node_uberspark_uobj_var.public_methods <- json_node_uberspark_uobj_publicmethods_var;
					end;

					if rval3 then begin
						json_node_uberspark_uobj_var.intra_uobjcoll_callees <- json_node_uberspark_uobj_intrauobjcoll_callees_var;
					end;

					if rval4 then begin
						json_node_uberspark_uobj_var.inter_uobjcoll_callees <- json_node_uberspark_uobj_interuobjcoll_callees_var;
					end;

					if rval5 then begin
						json_node_uberspark_uobj_var.legacy_callees <- json_node_uberspark_uobj_legacy_callees_var;
					end;

					if rval6 then begin
						json_node_uberspark_uobj_var.sections <- json_node_uberspark_uobj_sections_var;
					end;

					if rval7 then begin
						json_node_uberspark_uobj_var.uobjrtl <- json_node_uberspark_uobj_uobjrtl_var;
					end;

														
	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval)
;;


(* 
	copy constructor for uberspark.uobj.xxx nodes
	we use this to copy one json_node_uberspark_uobj_t 
	variable into another 
*)
let json_node_uberspark_uobj_var_copy 
	(output : json_node_uberspark_uobj_t )
	(input : json_node_uberspark_uobj_t )
	: unit = 

	output.namespace <- input.namespace; 
	output.platform <- input.platform; 
	output.arch <- input.arch; 
	output.cpu <- input.cpu; 
	(*
	output.sources.source_h_files<- input.sources.source_h_files; 
	output.sources.source_c_files <- input.sources.source_c_files; 
	output.sources.source_casm_files <- input.sources.source_casm_files; 
	output.sources.source_asm_files <- input.sources.source_asm_files;
	*)
	output.sources <- input.sources;
	output.headers <- input.headers;

	output.public_methods <- input.public_methods; 
	output.intra_uobjcoll_callees <- input.intra_uobjcoll_callees; 
	output.inter_uobjcoll_callees <- input.inter_uobjcoll_callees;
	output.legacy_callees <- input.legacy_callees; 
	output.sections <- input.sections; 
	output.uobjrtl <- input.uobjrtl; 

	()
;;


(* default json_node_uberspark_uobj_t variable definition *)
(* we use this to initialize variables of type json_node_uberspark_uobj_t *)
let json_node_uberspark_uobj_var_default_value () 
	: json_node_uberspark_uobj_t = 

	{
		namespace = ""; platform = ""; arch = ""; cpu = ""; 
		sources = []; headers = [];
		public_methods = []; intra_uobjcoll_callees = []; inter_uobjcoll_callees = [];
		legacy_callees = []; sections = []; uobjrtl = []; 
	}
;;


