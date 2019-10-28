(****************************************************************************)
(****************************************************************************)
(* uberSpark manifest interface for config*)
(*	 author: amit vasudevan (amitvasudevan@acm.org) *)
(****************************************************************************)
(****************************************************************************)


(****************************************************************************)
(* manifest node types *)
(****************************************************************************)

(* config-hdr node type *)
type config_hdr_t =
{
    mutable namespace    : string;			
};;

(* config-settings node type *)
type config_settings_t = 
{
	(* environment related settings *)
	mutable env_home_dir : string;

	(* uobj/uobjcoll binary related configuration settings *)	
	mutable binary_page_size : int;
	mutable binary_uobj_section_alignment : int;
	mutable binary_uobj_default_section_size : int;
	mutable binary_uobj_default_load_addr : int;
	mutable binary_uobj_default_size : int;

	(* bridge related configuration settings *)	
	mutable bridge_cc_bridge : string;

};;


(****************************************************************************)
(* manifest parse interfaces *)
(****************************************************************************)


(*--------------------------------------------------------------------------*)
(* parse json node "config-hdr" *)
(* return: *)
(* on success: true; config_hdr fields are modified with parsed values *)
(* on failure: false; config_hdr fields are untouched *)
(*--------------------------------------------------------------------------*)
let parse_config_hdr 
	(mf_json : Yojson.Basic.t)
	(config_hdr : config_hdr_t) 
	: bool =
	let retval = ref false in

	try
		let open Yojson.Basic.Util in
			let json_config_hdr = mf_json |> member "config-hdr" in
			if(json_config_hdr <> `Null) then
				begin
					config_hdr.namespace <- json_config_hdr |> member "namespace" |> to_string;
					retval := true;
				end
			;

	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval)
;;


(*--------------------------------------------------------------------------*)
(* parse json node "config-settings" *)
(* return: *)
(* on success: true; config_settings fields are modified with parsed values *)
(* on failure: false; config_settings fields are untouched *)
(*--------------------------------------------------------------------------*)
let parse_config_settings 
	(mf_json : Yojson.Basic.t)
	(config_settings : config_settings_t) 
	: bool =
	let retval = ref false in

	try
		let open Yojson.Basic.Util in
			let json_config_settings = mf_json |> member "config-settings" in
			if(json_config_settings <> `Null) then
				begin
					if (Yojson.Basic.Util.member "binary_page_size" json_config_settings) <> `Null then
						config_settings.binary_page_size <- int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "binary_page_size" json_config_settings));

					if (Yojson.Basic.Util.member "binary_uobj_section_alignment" json_config_settings) <> `Null then
						config_settings.binary_uobj_section_alignment <- int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "binary_uobj_section_alignment" json_config_settings));
					
					if (Yojson.Basic.Util.member "binary_uobj_default_section_size" json_config_settings) <> `Null then
						config_settings.binary_uobj_default_section_size <- int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "binary_uobj_default_section_size" json_config_settings));
			
					if (Yojson.Basic.Util.member "binary_uobj_default_load_addr" json_config_settings) <> `Null then
						config_settings.binary_uobj_default_load_addr <- int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "binary_uobj_default_load_addr" json_config_settings));

					if (Yojson.Basic.Util.member "binary_uobj_default_size" json_config_settings) <> `Null then
						config_settings.binary_uobj_default_size <- int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "binary_uobj_default_size" json_config_settings));

					if (Yojson.Basic.Util.member "bridge_cc_bridge" json_config_settings) <> `Null then
						config_settings.bridge_cc_bridge <- Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "bridge_cc_bridge" json_config_settings);

					retval := true;
				end
			;

	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval)
;;


(****************************************************************************)
(* manifest write interfaces *)
(****************************************************************************)


(*--------------------------------------------------------------------------*)
(* write config-hdr manifest node *)
(*--------------------------------------------------------------------------*)
let write_config_hdr 
	?(continuation = true)
	(oc : out_channel)
	(config_hdr : config_hdr_t) 
	: bool =
	let retval = ref false in

	Printf.fprintf oc "\n";
	Printf.fprintf oc "\n\t\"config-hdr\":{";
	Printf.fprintf oc "\n\t\t\"namespace\" : \"%s\"" config_hdr.namespace;

	if continuation then
		begin
			Printf.fprintf oc "\n\t},";
		end
	else
		begin
			Printf.fprintf oc "\n\t}";
		end
	;

	Printf.fprintf oc "\n";

	(!retval)
;;

(*--------------------------------------------------------------------------*)
(* write config-settings manifest node *)
(*--------------------------------------------------------------------------*)
let write_config_settings 
	?(continuation = true)
	(oc : out_channel)
	(config_settings : config_settings_t) 
	: bool =
	let retval = ref false in

	Printf.fprintf oc "\n";

	Printf.fprintf oc "\n\t\"config-settings\":{";
	Printf.fprintf oc "\n\t\t\"binary_page_size\" : \"0x%x\"," config_settings.binary_page_size;
	Printf.fprintf oc "\n\t\t\"binary_uobj_section_alignment\" : \"0x%x\"," config_settings.binary_uobj_section_alignment;
	Printf.fprintf oc "\n\t\t\"binary_uobj_default_section_size\" : \"0x%x\"," config_settings.binary_uobj_default_section_size;
	Printf.fprintf oc "\n\t\t\"binary_uobj_default_load_addr\" : \"0x%x\"," config_settings.binary_uobj_default_load_addr;
	Printf.fprintf oc "\n\t\t\"binary_uobj_default_size\" : \"0x%x\"," config_settings.binary_uobj_default_size;
	Printf.fprintf oc "\n\t\t\"bridge_cc_bridge\" : \"%s\"" config_settings.bridge_cc_bridge;

	if continuation then
		begin
			Printf.fprintf oc "\n\t},";
		end
	else
		begin
			Printf.fprintf oc "\n\t}";
		end
	;

	Printf.fprintf oc "\n";

	(!retval)
;;

