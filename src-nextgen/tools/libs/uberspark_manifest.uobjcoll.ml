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

