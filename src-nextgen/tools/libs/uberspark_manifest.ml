(*----------------------------------------------------------------------------*)
(* uberSpark manifest interface *)
(*	 author: amit vasudevan (amitvasudevan@acm.org) *)
(*----------------------------------------------------------------------------*)

open Yojson

	(* uberspark generic manifest header *)
	type hdr_t =
	{
		mutable f_coss_version : string;			
		mutable f_mftype : string;
		mutable f_uberspark_min_version   : string;
		mutable f_uberspark_max_version   : string;
	};;


	type hdrold_t =
		{
			mutable f_type         : string;			
			mutable f_namespace    : string;			
			mutable f_platform	   : string;
			mutable f_arch	       : string;
			mutable f_cpu				   : string;
		};;


(*
(****************************************************************************)
(* return json object for a given manifest file *)
(****************************************************************************)
let get_manifest_json
	?(check_header = true) 
	(mf_filename : string)
	= 

	let retval = ref false in
	let retjson = ref `Null in

	try
				
		let mf_json = Yojson.Basic.from_file mf_filename in
			retval := true;
			retjson := mf_json;
								
	with Yojson.Json_error s -> 
			Uberspark_logger.log ~lvl:Uberspark_logger.Error "usmf_read_manifest: ERROR:%s" s;
			retval := false;
			;
	
	(!retval, !retjson)
;;
*)



(*--------------------------------------------------------------------------*)
(* parse node: "uberspark-hdr" *)
(* input: manifest json *)
(* return: *)
(* on success: true, manifest header node as hdr_t*)
(* on failure: false *)
(*--------------------------------------------------------------------------*)

let parse_uberspark_hdr mf_json =
	let retval = ref false in

	let coss_version = ref "" in
	let mftype = ref "" in
	let uberspark_min_version = ref "" in
	let uberspark_max_version = ref "" in

	try
		let open Yojson.Basic.Util in
			let json_mf_hdr = mf_json |> member "uberspark-hdr" in
			if(json_mf_hdr <> `Null) then
				begin
					coss_version := json_mf_hdr |> member "coss_version" |> to_string;
					mftype := json_mf_hdr |> member "mftype" |> to_string;
					uberspark_min_version := json_mf_hdr |> member "uberspark_min_version" |> to_string;
					uberspark_max_version := json_mf_hdr |> member "uberspark_max_version" |> to_string;
					retval := true;
				end
			;

	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval, {
		f_coss_version = !coss_version;
		f_mftype = !mftype;
		f_uberspark_min_version = !uberspark_min_version;
		f_uberspark_max_version = !uberspark_max_version;
	})
;;




(*--------------------------------------------------------------------------*)
(* read manifest file into json object; sanity checking uberspark version *)
(*--------------------------------------------------------------------------*)

let get_manifest_json 
	?(check_header = true)
	(mf_filename : string)
	: bool * Yojson.Basic.json = 
	let retval = ref false in
	let retjson = ref `Null in

	try

		let mf_json = Yojson.Basic.from_file mf_filename in
		retjson := mf_json;
		retval := true;

		if (check_header) then
		begin
			let (mf_hdr_parsed, mf_hdr) = parse_uberspark_hdr mf_json in
			if (mf_hdr_parsed) then 
				begin
					(* TBD: sanity check header and version *)
					retval := true;
					retjson := mf_json;
				end
			else 
				begin
					Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not find valid header within manifest!";
					retval := false;
					retjson := `Null;
				end
			;
		end
		;

	with Yojson.Json_error s -> 
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "%s" s;
		retval := false;
	;

	(!retval, !retjson)
;;




	(*--------------------------------------------------------------------------*)
	(* parse common manifest header node; "hdr" *)
	(* return: true if successfully parsed header node, false if not *)
	(* if true also return: manifest header node as hdr_t *)
	(*--------------------------------------------------------------------------*)

	let parse_node_hdr mf_json =
		let retval = ref false in
		let mf_hdr_type = ref "" in
		let mf_hdr_namespace = ref "" in
		let mf_hdr_platform = ref "" in
		let mf_hdr_arch = ref "" in
		let mf_hdr_cpu = ref "" in
		try
			let open Yojson.Basic.Util in
				let json_mf_hdr = mf_json |> member "hdr" in
				if(json_mf_hdr <> `Null) then
					begin
						mf_hdr_type := json_mf_hdr |> member "type" |> to_string;
						mf_hdr_namespace := json_mf_hdr |> member "namespace" |> to_string;
						mf_hdr_platform := json_mf_hdr |> member "platform" |> to_string;
						mf_hdr_arch := json_mf_hdr |> member "arch" |> to_string;
						mf_hdr_cpu := json_mf_hdr |> member "cpu" |> to_string;
						retval := true;
					end
				;

		with Yojson.Basic.Util.Type_error _ -> 
				retval := false;
		;

		(!retval, {
			f_type = !mf_hdr_type;
			f_namespace = !mf_hdr_namespace;
			f_platform = !mf_hdr_platform;
			f_arch = !mf_hdr_arch;
			f_cpu = !mf_hdr_cpu;
		})
	;;




