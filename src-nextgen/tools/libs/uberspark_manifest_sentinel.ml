(*----------------------------------------------------------------------------*)
(* uberSpark manifest interface for sentinel *)
(*	 author: amit vasudevan (amitvasudevan@acm.org) *)
(*----------------------------------------------------------------------------*)

type sentinel_mf_json_nodes_t =
{
	mutable f_uberspark_hdr					: Yojson.Basic.t;			
	mutable f_sentinel_hdr   				: Yojson.Basic.t;
	mutable f_sentinel_code       			: Yojson.Basic.t;
	mutable f_sentinel_libcode			   	: Yojson.Basic.t;
};;


type sentinel_hdr_t =
{
	mutable f_namespace    : string;			
	mutable f_platform	   : string;
	mutable f_arch	       : string;
	mutable f_cpu		   : string;
};;



(*--------------------------------------------------------------------------*)
(* parse manifest json node into individual sentinel manifest json nodes *)
(* return: *)
(* on success: true; sentinel_mf_json_nodes fields are modified with parsed values *)
(* on failure: false; sentinel_mf_json_nodes fields are untouched *)
(*--------------------------------------------------------------------------*)
let get_sentinel_mf_json_nodes 
	(mf_json : Yojson.Basic.t)
	(sentinel_mf_json_nodes : sentinel_mf_json_nodes_t) 
	: bool =
	let retval = ref false in

	try
		let open Yojson.Basic.Util in
			sentinel_mf_json_nodes.f_uberspark_hdr <- mf_json |> member "uberspark-hdr";
			sentinel_mf_json_nodes.f_sentinel_hdr <- mf_json |> member "sentinel-hdr";
			sentinel_mf_json_nodes.f_sentinel_code <- mf_json |> member "sentinel-code";
			sentinel_mf_json_nodes.f_sentinel_libcode <- mf_json |> member "sentinel-libcode";

			retval := true;
	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval)
;;





(*--------------------------------------------------------------------------*)
(* parse json node "sentinel-hdr" *)
(* return: *)
(* on success: true; sentinel_hdr fields are modified with parsed values *)
(* on failure: false; sentinel_hdr fields are untouched *)
(*--------------------------------------------------------------------------*)

let parse_sentinel_hdr 
	(mf_json : Yojson.Basic.t)
	(sentinel_hdr : sentinel_hdr_t) 
	: bool =
	let retval = ref false in

	try
		let open Yojson.Basic.Util in
			let json_sentinel_hdr = mf_json |> member "sentinel-hdr" in
			if(json_sentinel_hdr <> `Null) then
				begin
					sentinel_hdr.f_namespace <- json_sentinel_hdr |> member "namespace" |> to_string;
					sentinel_hdr.f_platform <- json_sentinel_hdr |> member "platform" |> to_string;
					sentinel_hdr.f_arch <- json_sentinel_hdr |> member "arch" |> to_string;
					sentinel_hdr.f_cpu <- json_sentinel_hdr |> member "cpu" |> to_string;
					retval := true;
				end
			;

	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval)
;;


(*--------------------------------------------------------------------------*)
(* parse json node "sentinel-code" *)
(* return: *)
(* on success: true; string representation of sentinel code *)
(* on failure: false; null string *)
(*--------------------------------------------------------------------------*)

let parse_sentinel_code 
	(mf_json : Yojson.Basic.t)
	: bool * string =
	let retval = ref false in
	let retstr = ref "" in

	try
		let open Yojson.Basic.Util in
			let json_sentinel_code = mf_json |> member "sentinel-code" in
			if(json_sentinel_code <> `Null) then
				begin
					retstr := json_sentinel_code |> to_string;
					retval := true;
				end
			;

	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval, !retstr)
;;



(*--------------------------------------------------------------------------*)
(* parse json node "sentinel-libcode" *)
(* return: *)
(* on success: true; string representation of trampoline data *)
(* on failure: false; null string *)
(*--------------------------------------------------------------------------*)

let parse_sentinel_libcode 
	(mf_json : Yojson.Basic.t)
	: bool * string =
	let retval = ref false in
	let retstr = ref "" in

	try
		let open Yojson.Basic.Util in
			let json_sentinel_libcode = mf_json |> member "sentinel-libcode" in
			if(json_sentinel_libcode <> `Null) then
				begin
					retstr := json_sentinel_libcode |> to_string;
					retval := true;
				end
			;

	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval, !retstr)
;;


