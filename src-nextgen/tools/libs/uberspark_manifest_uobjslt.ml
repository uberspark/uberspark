(*----------------------------------------------------------------------------*)
(* uberSpark manifest interface for uobjslt*)
(*	 author: amit vasudevan (amitvasudevan@acm.org) *)
(*----------------------------------------------------------------------------*)

type uobjslt_hdr_t =
{
	mutable f_namespace    : string;			
	mutable f_platform	   : string;
	mutable f_arch	       : string;
	mutable f_cpu		   : string;
};;


(*--------------------------------------------------------------------------*)
(* parse json node "uobjslt-hdr" *)
(* return: *)
(* on success: true; uobjslt_hdr fields are modified with parsed values *)
(* on failure: false; uobjslt_hdr fields are untouched *)
(*--------------------------------------------------------------------------*)

let parse_uobjslt_hdr 
	(mf_json : Yojson.Basic.t)
	(uobjslt_hdr : uobjslt_hdr_t) 
	: bool =
	let retval = ref false in

	try
		let open Yojson.Basic.Util in
			let json_uobjslt_hdr = mf_json |> member "uobjslt-hdr" in
			if(json_uobjslt_hdr <> `Null) then
				begin
					uobjslt_hdr.f_namespace <- json_uobjslt_hdr |> member "namespace" |> to_string;
					uobjslt_hdr.f_platform <- json_uobjslt_hdr |> member "platform" |> to_string;
					uobjslt_hdr.f_arch <- json_uobjslt_hdr |> member "arch" |> to_string;
					uobjslt_hdr.f_cpu <- json_uobjslt_hdr |> member "cpu" |> to_string;
					retval := true;
				end
			;

	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval)
;;


(*--------------------------------------------------------------------------*)
(* parse json node "uobjslt-directxfer" *)
(* return: *)
(* on success: true; string representation of directxfer template code *)
(* on failure: false; null string *)
(*--------------------------------------------------------------------------*)
let parse_uobjslt_directxfer 
	(mf_json : Yojson.Basic.t)
	: bool * string =
	let retval = ref false in
	let retstr = ref "" in

	try
		let open Yojson.Basic.Util in
			let json_uobjslt_directxfer = mf_json |> member "uobjslt-directxfer" in
			if(json_uobjslt_directxfer <> `Null) then
				begin
					retstr := json_uobjslt_directxfer |> to_string;
					retval := true;
				end
			;

	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval, !retstr)
;;




(*--------------------------------------------------------------------------*)
(* parse json node "uobjslt-indirectxfer" *)
(* return: *)
(* on success: true; string representation of indirectxfer template code *)
(* on failure: false; null string *)
(*--------------------------------------------------------------------------*)
let parse_uobjslt_indirectxfer 
	(mf_json : Yojson.Basic.t)
	: bool * string =
	let retval = ref false in
	let retstr = ref "" in

	try
		let open Yojson.Basic.Util in
			let json_uobjslt_indirectxfer = mf_json |> member "uobjslt-indirectxfer" in
			if(json_uobjslt_indirectxfer <> `Null) then
				begin
					retstr := json_uobjslt_indirectxfer |> to_string;
					retval := true;
				end
			;

	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval, !retstr)
;;




(*--------------------------------------------------------------------------*)
(* parse json node "uobjslt-addrdef" *)
(* return: *)
(* on success: true; string representation of addrdef template directive *)
(* on failure: false; null string *)
(*--------------------------------------------------------------------------*)
let parse_uobjslt_addrdef 
	(mf_json : Yojson.Basic.t)
	: bool * string =
	let retval = ref false in
	let retstr = ref "" in

	try
		let open Yojson.Basic.Util in
			let json_uobjslt_addrdef = mf_json |> member "uobjslt-addrdef" in
			if(json_uobjslt_addrdef <> `Null) then
				begin
					retstr := json_uobjslt_addrdef |> to_string;
					retval := true;
				end
			;

	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval, !retstr)
;;




(*--------------------------------------------------------------------------*)
(* parse json node "uobjslt-trampolinecode" *)
(* return: *)
(* on success: true; string representation of trampoline code *)
(* on failure: false; null string *)
(*--------------------------------------------------------------------------*)

let parse_uobjslt_trampolinecode 
	(mf_json : Yojson.Basic.t)
	: bool * string =
	let retval = ref false in
	let retstr = ref "" in

	try
		let open Yojson.Basic.Util in
			let json_uobjslt_trampolinecode = mf_json |> member "uobjslt-trampolinecode" in
			if(json_uobjslt_trampolinecode <> `Null) then
				begin
					retstr := json_uobjslt_trampolinecode |> to_string;
					retval := true;
				end
			;

	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval, !retstr)
;;



(*--------------------------------------------------------------------------*)
(* parse json node "uobjslt-trampolinedata" *)
(* return: *)
(* on success: true; string representation of trampoline data *)
(* on failure: false; null string *)
(*--------------------------------------------------------------------------*)

let parse_uobjslt_trampolinedata 
	(mf_json : Yojson.Basic.t)
	: bool * string =
	let retval = ref false in
	let retstr = ref "" in

	try
		let open Yojson.Basic.Util in
			let json_uobjslt_trampolinedata = mf_json |> member "uobjslt-trampolinedata" in
			if(json_uobjslt_trampolinedata <> `Null) then
				begin
					retstr := json_uobjslt_trampolinedata |> to_string;
					retval := true;
				end
			;

	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval, !retstr)
;;


