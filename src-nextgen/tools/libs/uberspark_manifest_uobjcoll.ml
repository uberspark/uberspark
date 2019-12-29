(*----------------------------------------------------------------------------*)
(* uberSpark uobj collection manifest interface implementation *)
(*	 author: amit vasudevan (amitvasudevan@acm.org) *)
(*----------------------------------------------------------------------------*)

type uobjcoll_hdr_t =
{
	mutable f_namespace    : string;			
	mutable f_platform	   : string;
	mutable f_arch	       : string;
	mutable f_cpu		   : string;
	mutable f_hpl		   : string;
};;

type uobjcoll_uobjs_t =
{
	mutable f_prime_uobj_ns    : string;
	mutable f_templar_uobjs    : string list;
};;


type uobjcoll_interuobjcoll_publicmethods_t =
{
	mutable f_uobj_ns    : string;
	mutable f_pm_name	 : string;
	mutable f_sentinel_type_list : string list;
};;


type uobjcoll_sentinels_t =
{
	mutable f_interuobjcoll    : string list;
	mutable f_intrauobjcoll    : string list;
};;


(*--------------------------------------------------------------------------*)
(* parse manifest json node "uobjcoll-hdr" *)
(* return: *)
(* on success: true; uobjcoll_hdr fields are modified with parsed values *)
(* on failure: false; uobjcoll_hdr fields are untouched *)
(*--------------------------------------------------------------------------*)
let parse_uobjcoll_hdr 
	(mf_json : Yojson.Basic.t)
	(uobjcoll_hdr : uobjcoll_hdr_t) 
	: bool =
	let retval = ref false in

	try
		let open Yojson.Basic.Util in
			let json_uobjcoll_hdr = mf_json |> member "uobjcoll-hdr" in
			if(json_uobjcoll_hdr <> `Null) then
				begin
					uobjcoll_hdr.f_namespace <- json_uobjcoll_hdr |> member "namespace" |> to_string;
					uobjcoll_hdr.f_platform <- json_uobjcoll_hdr |> member "platform" |> to_string;
					uobjcoll_hdr.f_arch <- json_uobjcoll_hdr |> member "arch" |> to_string;
					uobjcoll_hdr.f_cpu <- json_uobjcoll_hdr |> member "cpu" |> to_string;
					uobjcoll_hdr.f_hpl <- json_uobjcoll_hdr |> member "hpl" |> to_string;
					retval := true;
				end
			;

	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval)
;;



(*--------------------------------------------------------------------------*)
(* parse manifest json node "uobjcoll-uobjs" *)
(* return: *)
(* on success: true; uobjcoll_uobjs fields are modified with parsed values *)
(* on failure: false; uobjcoll_uobjs fields are untouched *)
(*--------------------------------------------------------------------------*)
let parse_uobjcoll_uobjs 
	(mf_json : Yojson.Basic.t)
	(uobjcoll_uobjs : uobjcoll_uobjs_t) 
	: bool =
	let retval = ref false in

	try
		let open Yojson.Basic.Util in
			let json_uobjcoll_uobjs = mf_json |> member "uobjcoll-uobjs" in
			if(json_uobjcoll_uobjs <> `Null) then
				begin
					uobjcoll_uobjs.f_prime_uobj_ns <- json_uobjcoll_uobjs |> member "prime" |> to_string;
					uobjcoll_uobjs.f_templar_uobjs <- (json_list_to_string_list  (json_uobjcoll_uobjs |> member "templars" |> to_list));
					retval := true;
				end
			;

	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval)
;;



(*--------------------------------------------------------------------------*)
(* parse manifest json node "uobjcoll-interuobjcoll-publicmethods" into hashtbl *)
(* return: *)
(* on success: true; hash table modified with parsed values *)
(* on failure: false; hash table left untouched *)
(*--------------------------------------------------------------------------*)
let parse_uobjcoll_interuobjcoll_publicmethods_into_hashtbl
	(mf_json : Yojson.Basic.t)
	(publicmethods_hashtbl : ((string, uobjcoll_interuobjcoll_publicmethods_t)  Hashtbl.t))
	: bool =
		
	let retval = ref false in

	try
		let open Yojson.Basic.Util in
			let uobjcoll_interuobjcoll_publicmethods_json = mf_json |> member "uobjcoll-interuobjcoll-publicmethods" in
				if uobjcoll_interuobjcoll_publicmethods_json != `Null then
					begin

						let uobj_ns_assoc_list = Yojson.Basic.Util.to_assoc uobjcoll_interuobjcoll_publicmethods_json in
							
						List.iter (fun ( (uobj_ns:string),(uobj_ns_json:Yojson.Basic.t)) ->

							let pm_name_assoc_list = Yojson.Basic.Util.to_assoc uobj_ns_json in

							List.iter (fun ( (pm_name:string),(sentinel_type_list_json:Yojson.Basic.t)) ->
								let sentinel_type_list = (json_list_to_string_list  (sentinel_type_list_json |> to_list)) in
								let entry : uobjcoll_interuobjcoll_publicmethods_t = {
									f_uobj_ns = uobj_ns;
									f_pm_name = pm_name;
									f_sentinel_type_list = sentinel_type_list;
								} in
								let canonical_pm_name_key = uobj_ns ^ "__" ^ pm_name in
								Hashtbl.add publicmethods_hashtbl canonical_pm_name_key entry;

							) pm_name_assoc_list;

						) uobj_ns_assoc_list;

						retval := true;
					end
				;
														
	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

							
	(!retval)
;;


(*--------------------------------------------------------------------------*)
(* parse manifest json node "uobjcoll-interuobjcoll-publicmethods" into assoc list *)
(* return: *)
(* on success: true; assoc list is modified with parsed values *)
(* on failure: false; assoc list is left untouched *)
(*--------------------------------------------------------------------------*)
let parse_uobjcoll_interuobjcoll_publicmethods
	(mf_json : Yojson.Basic.t)
	(publicmethods_assoc_list : (string * uobjcoll_interuobjcoll_publicmethods_t) list ref)
	: bool =
		
	let retval = ref false in

	try
		let open Yojson.Basic.Util in
			let uobjcoll_interuobjcoll_publicmethods_json = mf_json |> member "uobjcoll-interuobjcoll-publicmethods" in
				if uobjcoll_interuobjcoll_publicmethods_json != `Null then
					begin

						let uobj_ns_assoc_list = Yojson.Basic.Util.to_assoc uobjcoll_interuobjcoll_publicmethods_json in
							
						List.iter (fun ( (uobj_ns:string),(uobj_ns_json:Yojson.Basic.t)) ->

							let pm_name_assoc_list = Yojson.Basic.Util.to_assoc uobj_ns_json in

							List.iter (fun ( (pm_name:string),(sentinel_type_list_json:Yojson.Basic.t)) ->
								let sentinel_type_list = (json_list_to_string_list  (sentinel_type_list_json |> to_list)) in
								let entry : uobjcoll_interuobjcoll_publicmethods_t = {
									f_uobj_ns = uobj_ns;
									f_pm_name = pm_name;
									f_sentinel_type_list = sentinel_type_list;
								} in
								let canonical_pm_name_key = uobj_ns ^ "__" ^ pm_name in
								publicmethods_assoc_list := !publicmethods_assoc_list @ [ (canonical_pm_name_key, entry) ];

							) pm_name_assoc_list;

						) uobj_ns_assoc_list;

						retval := true;
					end
				;
														
	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

							
	(!retval)
;;


(*--------------------------------------------------------------------------*)
(* parse manifest json node "uobjcoll-sentinels" *)
(* return: *)
(* on success: true; uobjcoll_sentinels fields are modified with parsed values *)
(* on failure: false; uobjcoll_sentinels fields are untouched *)
(*--------------------------------------------------------------------------*)
let parse_uobjcoll_sentinels 
	(mf_json : Yojson.Basic.t)
	(uobjcoll_sentinels : uobjcoll_sentinels_t) 
	: bool =
	let retval = ref false in

	try
		let open Yojson.Basic.Util in
			let json_uobjcoll_sentinels = mf_json |> member "uobjcoll-sentinels" in
			if(json_uobjcoll_sentinels <> `Null) then
				begin
					uobjcoll_sentinels.f_interuobjcoll <- (json_list_to_string_list  (json_uobjcoll_sentinels |> member "interuobjcoll" |> to_list));
					uobjcoll_sentinels.f_intrauobjcoll <- (json_list_to_string_list  (json_uobjcoll_sentinels |> member "intrauobjcoll" |> to_list));
					retval := true;
				end
			;

	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval)
;;


