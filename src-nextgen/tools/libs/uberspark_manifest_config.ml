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



(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* interface definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)


(*--------------------------------------------------------------------------*)
(* convert json node "uberspark-config" into json_node_uberspark_config_t variable *)
(* return: *)
(* on success: true; json_node_uberspark_config_var fields are modified with parsed values *)
(* on failure: false; json_node_uberspark_config_Var fields are untouched *)
(*--------------------------------------------------------------------------*)

let json_node_uberspark_config_to_var 
	(json_node_uberspark_config : Yojson.Basic.t)
	(json_node_uberspark_config_var : json_node_uberspark_config_t) 
	: bool =
	let retval = ref false in

	try
		let open Yojson.Basic.Util in
			if(json_node_uberspark_config <> `Null) then
				begin

					if (Yojson.Basic.Util.member "binary_page_size" json_node_uberspark_config) <> `Null then
						json_node_uberspark_config_var.binary_page_size <- int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "binary_page_size" json_node_uberspark_config));

					if (Yojson.Basic.Util.member "binary_uobj_section_alignment" json_node_uberspark_config) <> `Null then
						json_node_uberspark_config_var.binary_uobj_section_alignment <- int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "binary_uobj_section_alignment" json_node_uberspark_config));
					
					if (Yojson.Basic.Util.member "binary_uobj_default_section_size" json_node_uberspark_config) <> `Null then
						json_node_uberspark_config_var.binary_uobj_default_section_size <- int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "binary_uobj_default_section_size" json_node_uberspark_config));
			
					if (Yojson.Basic.Util.member "uobj_binary_image_load_address" json_node_uberspark_config) <> `Null then
						json_node_uberspark_config_var.uobj_binary_image_load_address <- int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uobj_binary_image_load_address" json_node_uberspark_config));

					if (Yojson.Basic.Util.member "uobj_binary_image_uniform_size" json_node_uberspark_config) <> `Null then
						json_node_uberspark_config_var.uobj_binary_image_uniform_size <- Yojson.Basic.Util.to_bool (Yojson.Basic.Util.member "uobj_binary_image_uniform_size" json_node_uberspark_config);

					if (Yojson.Basic.Util.member "uobj_binary_image_size" json_node_uberspark_config) <> `Null then
						json_node_uberspark_config_var.uobj_binary_image_size <- int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uobj_binary_image_size" json_node_uberspark_config));

					if (Yojson.Basic.Util.member "uobj_binary_image_alignment" json_node_uberspark_config) <> `Null then
						json_node_uberspark_config_var.uobj_binary_image_alignment <- int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uobj_binary_image_alignment" json_node_uberspark_config));

					if (Yojson.Basic.Util.member "uobjcoll_binary_image_load_address" json_node_uberspark_config) <> `Null then
						json_node_uberspark_config_var.uobjcoll_binary_image_load_address <- int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uobjcoll_binary_image_load_address" json_node_uberspark_config));

					if (Yojson.Basic.Util.member "uobjcoll_binary_image_hdr_section_alignment" json_node_uberspark_config) <> `Null then
						json_node_uberspark_config_var.uobjcoll_binary_image_hdr_section_alignment <- int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uobjcoll_binary_image_hdr_section_alignment" json_node_uberspark_config));

					if (Yojson.Basic.Util.member "uobjcoll_binary_image_hdr_section_size" json_node_uberspark_config) <> `Null then
						json_node_uberspark_config_var.uobjcoll_binary_image_hdr_section_size <- int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uobjcoll_binary_image_hdr_section_size" json_node_uberspark_config));

					if (Yojson.Basic.Util.member "uobjcoll_binary_image_section_alignment" json_node_uberspark_config) <> `Null then
						json_node_uberspark_config_var.uobjcoll_binary_image_section_alignment <- int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uobjcoll_binary_image_section_alignment" json_node_uberspark_config));

					if (Yojson.Basic.Util.member "bridge_cc_bridge" json_node_uberspark_config) <> `Null then
						json_node_uberspark_config_var.bridge_cc_bridge <- Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "bridge_cc_bridge" json_node_uberspark_config);

					if (Yojson.Basic.Util.member "bridge_as_bridge" json_node_uberspark_config) <> `Null then
						json_node_uberspark_config_var.bridge_as_bridge <- Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "bridge_as_bridge" json_node_uberspark_config);

					if (Yojson.Basic.Util.member "bridge_ld_bridge" json_node_uberspark_config) <> `Null then
						json_node_uberspark_config_var.bridge_ld_bridge <- Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "bridge_ld_bridge" json_node_uberspark_config);


					retval := true;
				end
			;

	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval)
;;



(*--------------------------------------------------------------------------*)
(* convert json_node_uberspark_config_var to json string *)
(*--------------------------------------------------------------------------*)
let json_node_uberspark_config_var_to_jsonstr  
	(json_node_uberspark_config_var : json_node_uberspark_config_t) 
	: string =
	let retstr = ref "" in


	retstr := !retstr ^ Printf.sprintf  "\n";

	retstr := !retstr ^ Printf.sprintf  "\n\t\"uberspark-config\":{";
	retstr := !retstr ^ Printf.sprintf  "\n\t\t\"binary_page_size\" : \"0x%x\"," json_node_uberspark_config_var.binary_page_size;
	retstr := !retstr ^ Printf.sprintf  "\n\t\t\"binary_uobj_section_alignment\" : \"0x%x\"," json_node_uberspark_config_var.binary_uobj_section_alignment;
	retstr := !retstr ^ Printf.sprintf  "\n\t\t\"binary_uobj_default_section_size\" : \"0x%x\"," json_node_uberspark_config_var.binary_uobj_default_section_size;
	retstr := !retstr ^ Printf.sprintf  "\n\t\t\"uobj_binary_image_load_address\" : \"0x%x\"," json_node_uberspark_config_var.uobj_binary_image_load_address;
	retstr := !retstr ^ Printf.sprintf  "\n\t\t\"uobj_binary_image_uniform_size\" : %B," json_node_uberspark_config_var.uobj_binary_image_uniform_size;
	retstr := !retstr ^ Printf.sprintf  "\n\t\t\"uobj_binary_image_size\" : \"0x%x\"," json_node_uberspark_config_var.uobj_binary_image_size;
	retstr := !retstr ^ Printf.sprintf  "\n\t\t\"uobj_binary_image_alignment\" : \"0x%x\"," json_node_uberspark_config_var.uobj_binary_image_alignment;
	retstr := !retstr ^ Printf.sprintf  "\n\t\t\"uobjcoll_binary_image_load_address\" : \"0x%x\"," json_node_uberspark_config_var.uobjcoll_binary_image_load_address;
	retstr := !retstr ^ Printf.sprintf  "\n\t\t\"uobjcoll_binary_image_hdr_section_alignment\" : \"0x%x\"," json_node_uberspark_config_var.uobjcoll_binary_image_hdr_section_alignment;
	retstr := !retstr ^ Printf.sprintf  "\n\t\t\"uobjcoll_binary_image_hdr_section_size\" : \"0x%x\"," json_node_uberspark_config_var.uobjcoll_binary_image_hdr_section_size;
	retstr := !retstr ^ Printf.sprintf  "\n\t\t\"uobjcoll_binary_image_section_alignment\" : \"0x%x\"," json_node_uberspark_config_var.uobjcoll_binary_image_section_alignment;
	retstr := !retstr ^ Printf.sprintf  "\n\t\t\"bridge_cc_bridge\" : \"%s\"," json_node_uberspark_config_var.bridge_cc_bridge;
	retstr := !retstr ^ Printf.sprintf  "\n\t\t\"bridge_as_bridge\" : \"%s\"," json_node_uberspark_config_var.bridge_as_bridge;
	retstr := !retstr ^ Printf.sprintf  "\n\t\t\"bridge_ld_bridge\" : \"%s\"" json_node_uberspark_config_var.bridge_ld_bridge;

	retstr := !retstr ^ Printf.sprintf  "\n\t}";

	retstr := !retstr ^ Printf.sprintf  "\n";

	(!retstr)
;;





