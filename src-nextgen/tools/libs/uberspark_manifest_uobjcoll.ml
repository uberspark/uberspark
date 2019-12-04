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
};;

type uobjcoll_uobjs_t =
{
	mutable f_prime_uobj_ns    : string;
	mutable f_templar_uobjs    : string list;
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

