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




