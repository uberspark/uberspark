(*===========================================================================*)
(*===========================================================================*)
(* uberSpark config manifest interface implementation *)
(*	 author: amit vasudevan (amitvasudevan@acm.org) *)
(*===========================================================================*)
(*===========================================================================*)



(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* type definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)

type json_node_uberspark_config_t = 
{

	(* uobj/uobjcoll binary related configuration settings *)	
	mutable binary_page_size : int;
	mutable binary_uobj_section_alignment : int;
	mutable binary_uobj_default_section_size : int;

	mutable uobj_binary_image_load_address : int;
	mutable uobj_binary_image_uniform_size : bool;
	mutable uobj_binary_image_size : int;
	mutable uobj_binary_image_alignment : int;

	(* uobjcoll related configuration settings *)
	mutable uobjcoll_binary_image_load_address : int;
	mutable uobjcoll_binary_image_hdr_section_alignment : int;
	mutable uobjcoll_binary_image_hdr_section_size : int;
	mutable uobjcoll_binary_image_section_alignment : int;

	(* bridge related configuration settings *)	
	mutable bridge_cc_bridge : string;
	mutable bridge_as_bridge : string;
	mutable bridge_ld_bridge : string;
};;



(* config-hdr node type *)
type config_hdr_t =
{
    mutable name    : string;			
};;

(* config-settings node type *)
type config_settings_t = 
{

	(* uobj/uobjcoll binary related configuration settings *)	
	mutable binary_page_size : int;
	mutable binary_uobj_section_alignment : int;
	mutable binary_uobj_default_section_size : int;

	mutable uobj_binary_image_load_address : int;
	mutable uobj_binary_image_uniform_size : bool;
	mutable uobj_binary_image_size : int;
	mutable uobj_binary_image_alignment : int;

	(* uobjcoll related configuration settings *)
	mutable uobjcoll_binary_image_load_address : int;
	mutable uobjcoll_binary_image_hdr_section_alignment : int;
	mutable uobjcoll_binary_image_hdr_section_size : int;
	mutable uobjcoll_binary_image_section_alignment : int;

	(* bridge related configuration settings *)	
	mutable bridge_cc_bridge : string;
	mutable bridge_as_bridge : string;
	mutable bridge_ld_bridge : string;
};;


(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* interface definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)


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
					config_hdr.name <- json_config_hdr |> member "name" |> to_string;
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
			
					if (Yojson.Basic.Util.member "uobj_binary_image_load_address" json_config_settings) <> `Null then
						config_settings.uobj_binary_image_load_address <- int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uobj_binary_image_load_address" json_config_settings));

					if (Yojson.Basic.Util.member "uobj_binary_image_uniform_size" json_config_settings) <> `Null then
						config_settings.uobj_binary_image_uniform_size <- Yojson.Basic.Util.to_bool (Yojson.Basic.Util.member "uobj_binary_image_uniform_size" json_config_settings);

					if (Yojson.Basic.Util.member "uobj_binary_image_size" json_config_settings) <> `Null then
						config_settings.uobj_binary_image_size <- int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uobj_binary_image_size" json_config_settings));

					if (Yojson.Basic.Util.member "uobj_binary_image_alignment" json_config_settings) <> `Null then
						config_settings.uobj_binary_image_alignment <- int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uobj_binary_image_alignment" json_config_settings));

					if (Yojson.Basic.Util.member "uobjcoll_binary_image_load_address" json_config_settings) <> `Null then
						config_settings.uobjcoll_binary_image_load_address <- int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uobjcoll_binary_image_load_address" json_config_settings));

					if (Yojson.Basic.Util.member "uobjcoll_binary_image_hdr_section_alignment" json_config_settings) <> `Null then
						config_settings.uobjcoll_binary_image_hdr_section_alignment <- int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uobjcoll_binary_image_hdr_section_alignment" json_config_settings));

					if (Yojson.Basic.Util.member "uobjcoll_binary_image_hdr_section_size" json_config_settings) <> `Null then
						config_settings.uobjcoll_binary_image_hdr_section_size <- int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uobjcoll_binary_image_hdr_section_size" json_config_settings));

					if (Yojson.Basic.Util.member "uobjcoll_binary_image_section_alignment" json_config_settings) <> `Null then
						config_settings.uobjcoll_binary_image_section_alignment <- int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uobjcoll_binary_image_section_alignment" json_config_settings));

					if (Yojson.Basic.Util.member "bridge_cc_bridge" json_config_settings) <> `Null then
						config_settings.bridge_cc_bridge <- Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "bridge_cc_bridge" json_config_settings);

					if (Yojson.Basic.Util.member "bridge_as_bridge" json_config_settings) <> `Null then
						config_settings.bridge_as_bridge <- Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "bridge_as_bridge" json_config_settings);

					if (Yojson.Basic.Util.member "bridge_ld_bridge" json_config_settings) <> `Null then
						config_settings.bridge_ld_bridge <- Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "bridge_ld_bridge" json_config_settings);

					retval := true;
				end
			;

	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval)
;;


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
	Printf.fprintf oc "\n\t\t\"name\" : \"%s\"" config_hdr.name;

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
	Printf.fprintf oc "\n\t\t\"uobj_binary_image_load_address\" : \"0x%x\"," config_settings.uobj_binary_image_load_address;
	Printf.fprintf oc "\n\t\t\"uobj_binary_image_uniform_size\" : %B," config_settings.uobj_binary_image_uniform_size;
	Printf.fprintf oc "\n\t\t\"uobj_binary_image_size\" : \"0x%x\"," config_settings.uobj_binary_image_size;
	Printf.fprintf oc "\n\t\t\"uobj_binary_image_alignment\" : \"0x%x\"," config_settings.uobj_binary_image_alignment;
	Printf.fprintf oc "\n\t\t\"uobjcoll_binary_image_load_address\" : \"0x%x\"," config_settings.uobjcoll_binary_image_load_address;
	Printf.fprintf oc "\n\t\t\"uobjcoll_binary_image_hdr_section_alignment\" : \"0x%x\"," config_settings.uobjcoll_binary_image_hdr_section_alignment;
	Printf.fprintf oc "\n\t\t\"uobjcoll_binary_image_hdr_section_size\" : \"0x%x\"," config_settings.uobjcoll_binary_image_hdr_section_size;
	Printf.fprintf oc "\n\t\t\"uobjcoll_binary_image_section_alignment\" : \"0x%x\"," config_settings.uobjcoll_binary_image_section_alignment;
	Printf.fprintf oc "\n\t\t\"bridge_cc_bridge\" : \"%s\"," config_settings.bridge_cc_bridge;
	Printf.fprintf oc "\n\t\t\"bridge_as_bridge\" : \"%s\"," config_settings.bridge_as_bridge;
	Printf.fprintf oc "\n\t\t\"bridge_ld_bridge\" : \"%s\"" config_settings.bridge_ld_bridge;

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

