(*===========================================================================*)
(*===========================================================================*)
(* uberSpark sentinel manifest interface implementation *)
(*	 author: amit vasudevan (amitvasudevan@acm.org) *)
(*===========================================================================*)
(*===========================================================================*)


(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* type definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)

type sentinel_hdr_t =
{
	mutable f_namespace    : string;			
	mutable f_platform	   : string;
	mutable f_arch	       : string;
	mutable f_cpu		   : string;
	mutable f_sizeof_code  : int;
};;


type json_node_uberspark_sentinel_t =
{
	mutable f_namespace    : string;			
	mutable f_platform	   : string;
	mutable f_arch	       : string;
	mutable f_cpu		   : string;
	mutable f_sizeof_code  : int;
	mutable f_code		   : string;
	mutable f_libcode	   : string;
};;


(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* interface definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)


(*--------------------------------------------------------------------------*)
(* convert json node "uberspark-sentinel" into json_node_uberspark_sentinel_t variable *)
(* return: *)
(* on success: true; json_node_uberspark_sentinel fields are modified with parsed values *)
(* on failure: false; json_node_uberspark_sentinel fields are untouched *)
(*--------------------------------------------------------------------------*)

let json_node_uberspark_sentinel_to_var 
	(mf_json : Yojson.Basic.t)
	(json_node_uberspark_sentinel : json_node_uberspark_sentinel_t) 
	: bool =
	let retval = ref false in

	try
		let open Yojson.Basic.Util in
			let l_json_node_uberspark_sentinel = mf_json |> member "uberspark-sentinel" in
			if(l_json_node_uberspark_sentinel <> `Null) then
				begin
					json_node_uberspark_sentinel.f_namespace <- l_json_node_uberspark_sentinel |> member "namespace" |> to_string;
					json_node_uberspark_sentinel.f_platform <- l_json_node_uberspark_sentinel |> member "platform" |> to_string;
					json_node_uberspark_sentinel.f_arch <- l_json_node_uberspark_sentinel |> member "arch" |> to_string;
					json_node_uberspark_sentinel.f_cpu <- l_json_node_uberspark_sentinel |> member "cpu" |> to_string;
					json_node_uberspark_sentinel.f_sizeof_code <- int_of_string (l_json_node_uberspark_sentinel |> member "sizeof-code" |> to_string);
					json_node_uberspark_sentinel.f_code <- l_json_node_uberspark_sentinel |> member "code" |> to_string;
					json_node_uberspark_sentinel.f_libcode <- l_json_node_uberspark_sentinel |> member "libcode" |> to_string;
					retval := true;
				end
			;

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
					sentinel_hdr.f_sizeof_code <- int_of_string (json_sentinel_hdr |> member "sizeof-code" |> to_string);
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


