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

type json_node_uberspark_platform_bridges_t = 
{
	(* bridge related configuration settings *)	
	mutable cc_bridge_namespace : string;
	mutable as_bridge_namespace : string;
	mutable casm_bridge_namespace : string;
	mutable ld_bridge_namespace : string;
	mutable uberspark_vf_bridge_namespace : string;
};;

type json_node_uberspark_platform_binary_t = 
{

	(* uobj/uobjcoll binary related configuration settings *)	
	mutable page_size : int;
	mutable uobj_section_alignment : int;
	mutable uobj_default_section_size : int;

	mutable uobj_image_load_address : int;
	mutable uobj_image_uniform_size : bool;
	mutable uobj_image_size : int;
	mutable uobj_image_alignment : int;

	(* uobjcoll related configuration settings *)
	mutable uobjcoll_image_load_address : int;
	mutable uobjcoll_image_hdr_section_alignment : int;
	mutable uobjcoll_image_hdr_section_size : int;
	mutable uobjcoll_image_section_alignment : int;
	mutable uobjcoll_image_size : int;

};;

type json_node_uberspark_platform_t = 
{
	mutable binary : json_node_uberspark_platform_binary_t;
	mutable bridges : json_node_uberspark_platform_bridges_t;
};;

(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* interface definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)


(*--------------------------------------------------------------------------*)
(* 
	parse uberspark.platform.xxx json nodes and populate 
	json_node_uberspark_platform_var if they are found
	return: true on success, false if there was an issue with type errors 
	during parsing
*)
(*--------------------------------------------------------------------------*)

let json_node_uberspark_platform_to_var 
	?(p_only_configurable = false)
	(mf_json : Yojson.Basic.t)
	(json_node_uberspark_platform_var : json_node_uberspark_platform_t) 
	: bool =
	let retval = ref false in

	(* use not p_only_configurable for fields that cannot be overlayed *)

	try
		let open Yojson.Basic.Util in
			if (Yojson.Basic.Util.member "uberspark.platform.binary.page_size" mf_json) <> `Null then
				json_node_uberspark_platform_var.binary.page_size <- int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uberspark.platform.binary.page_size" mf_json));

			if (Yojson.Basic.Util.member "uberspark.platform.binary.uobj_section_alignment" mf_json) <> `Null then
				json_node_uberspark_platform_var.binary.uobj_section_alignment <- int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uberspark.platform.binary.uobj_section_alignment" mf_json));
			
			if (Yojson.Basic.Util.member "uberspark.platform.binary.uobj_default_section_size" mf_json) <> `Null then
				json_node_uberspark_platform_var.binary.uobj_default_section_size <- int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uberspark.platform.binary.uobj_default_section_size" mf_json));
	
			if (Yojson.Basic.Util.member "uberspark.platform.binary.uobj_image_load_address" mf_json) <> `Null then
				json_node_uberspark_platform_var.binary.uobj_image_load_address <- int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uberspark.platform.binary.uobj_image_load_address" mf_json));

			if (Yojson.Basic.Util.member "uberspark.platform.binary.uobj_image_uniform_size" mf_json) <> `Null then
				json_node_uberspark_platform_var.binary.uobj_image_uniform_size <- Yojson.Basic.Util.to_bool (Yojson.Basic.Util.member "uberspark.platform.binary.uobj_image_uniform_size" mf_json);

			if (Yojson.Basic.Util.member "uberspark.platform.binary.uobj_image_size" mf_json) <> `Null then
				json_node_uberspark_platform_var.binary.uobj_image_size <- int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uberspark.platform.binary.uobj_image_size" mf_json));

			if (Yojson.Basic.Util.member "uberspark.platform.binary.uobj_image_alignment" mf_json) <> `Null then
				json_node_uberspark_platform_var.binary.uobj_image_alignment <- int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uberspark.platform.binary.uobj_image_alignment" mf_json));

			if (Yojson.Basic.Util.member "uberspark.platform.binary.uobjcoll_image_load_address" mf_json) <> `Null then
				json_node_uberspark_platform_var.binary.uobjcoll_image_load_address <- int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uberspark.platform.binary.uobjcoll_image_load_address" mf_json));

			if (Yojson.Basic.Util.member "uberspark.platform.binary.uobjcoll_image_hdr_section_alignment" mf_json) <> `Null then
				json_node_uberspark_platform_var.binary.uobjcoll_image_hdr_section_alignment <- int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uberspark.platform.binary.uobjcoll_image_hdr_section_alignment" mf_json));

			if (Yojson.Basic.Util.member "uberspark.platform.binary.uobjcoll_image_hdr_section_size" mf_json) <> `Null then
				json_node_uberspark_platform_var.binary.uobjcoll_image_hdr_section_size <- int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uberspark.platform.binary.uobjcoll_image_hdr_section_size" mf_json));

			if (Yojson.Basic.Util.member "uberspark.platform.binary.uobjcoll_image_section_alignment" mf_json) <> `Null then
				json_node_uberspark_platform_var.binary.uobjcoll_image_section_alignment <- int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uberspark.platform.binary.uobjcoll_image_section_alignment" mf_json));

			if (Yojson.Basic.Util.member "uberspark.platform.binary.uobjcoll_image_size" mf_json) <> `Null then
				json_node_uberspark_platform_var.binary.uobjcoll_image_size <- int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uberspark.platform.binary.uobjcoll_image_size" mf_json));

			if (Yojson.Basic.Util.member "uberspark.platform.bridges.cc_bridge_namespace" mf_json) <> `Null then
				json_node_uberspark_platform_var.bridges.cc_bridge_namespace <- Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uberspark.platform.bridges.cc_bridge_namespace" mf_json);

			if (Yojson.Basic.Util.member "uberspark.platform.bridges.as_bridge_namespace" mf_json) <> `Null then
				json_node_uberspark_platform_var.bridges.as_bridge_namespace <- Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uberspark.platform.bridges.as_bridge_namespace" mf_json);

			if (not p_only_configurable) &&  (Yojson.Basic.Util.member "uberspark.platform.bridges.casm_bridge_namespace" mf_json) <> `Null then
				json_node_uberspark_platform_var.bridges.casm_bridge_namespace <- Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uberspark.platform.bridges.casm_bridge_namespace" mf_json);

			if (Yojson.Basic.Util.member "uberspark.platform.bridges.ld_bridge_namespace" mf_json) <> `Null then
				json_node_uberspark_platform_var.bridges.ld_bridge_namespace <- Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uberspark.platform.bridges.ld_bridge_namespace" mf_json);

			if (not p_only_configurable) && (Yojson.Basic.Util.member "uberspark.platform.bridges.uberspark_vf_bridge_namespace" mf_json) <> `Null then
				json_node_uberspark_platform_var.bridges.uberspark_vf_bridge_namespace <- Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uberspark.platform.bridges.uberspark_vf_bridge_namespace" mf_json);

			retval := true;

	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval)
;;



(*--------------------------------------------------------------------------*)
(* convert json_node_uberspark_platform_var.binary.to json string *)
(*--------------------------------------------------------------------------*)
let json_node_uberspark_platform_var_to_jsonstr  
	(json_node_uberspark_platform_var : json_node_uberspark_platform_t) 
	: string =
	let retstr = ref "" in


	retstr := !retstr ^ Printf.sprintf  "\n";

	retstr := !retstr ^ Printf.sprintf  "\n\t\"uberspark.platform.binary.page_size\" : \"0x%x\"," json_node_uberspark_platform_var.binary.page_size;
	retstr := !retstr ^ Printf.sprintf  "\n\t\"uberspark.platform.binary.uobj_section_alignment\" : \"0x%x\"," json_node_uberspark_platform_var.binary.uobj_section_alignment;
	retstr := !retstr ^ Printf.sprintf  "\n\t\"uberspark.platform.binary.uobj_default_section_size\" : \"0x%x\"," json_node_uberspark_platform_var.binary.uobj_default_section_size;
	retstr := !retstr ^ Printf.sprintf  "\n\t\"uberspark.platform.binary.uobj_image_load_address\" : \"0x%x\"," json_node_uberspark_platform_var.binary.uobj_image_load_address;
	retstr := !retstr ^ Printf.sprintf  "\n\t\"uberspark.platform.binary.uobj_image_uniform_size\" : %B," json_node_uberspark_platform_var.binary.uobj_image_uniform_size;
	retstr := !retstr ^ Printf.sprintf  "\n\t\"uberspark.platform.binary.uobj_image_size\" : \"0x%x\"," json_node_uberspark_platform_var.binary.uobj_image_size;
	retstr := !retstr ^ Printf.sprintf  "\n\t\"uberspark.platform.binary.uobj_image_alignment\" : \"0x%x\"," json_node_uberspark_platform_var.binary.uobj_image_alignment;
	retstr := !retstr ^ Printf.sprintf  "\n\t\"uberspark.platform.binary.uobjcoll_image_load_address\" : \"0x%x\"," json_node_uberspark_platform_var.binary.uobjcoll_image_load_address;
	retstr := !retstr ^ Printf.sprintf  "\n\t\"uberspark.platform.binary.uobjcoll_image_hdr_section_alignment\" : \"0x%x\"," json_node_uberspark_platform_var.binary.uobjcoll_image_hdr_section_alignment;
	retstr := !retstr ^ Printf.sprintf  "\n\t\"uberspark.platform.binary.uobjcoll_image_hdr_section_size\" : \"0x%x\"," json_node_uberspark_platform_var.binary.uobjcoll_image_hdr_section_size;
	retstr := !retstr ^ Printf.sprintf  "\n\t\"uberspark.platform.binary.uobjcoll_image_section_alignment\" : \"0x%x\"," json_node_uberspark_platform_var.binary.uobjcoll_image_section_alignment;
	retstr := !retstr ^ Printf.sprintf  "\n\t\"uberspark.platform.binary.uobjcoll_image_size\" : \"0x%x\"," json_node_uberspark_platform_var.binary.uobjcoll_image_size;
	retstr := !retstr ^ Printf.sprintf  "\n\t\"uberspark.platform.bridges.cc_bridge_namespace\" : \"%s\"," json_node_uberspark_platform_var.bridges.cc_bridge_namespace;
	retstr := !retstr ^ Printf.sprintf  "\n\t\"uberspark.platform.bridges.as_bridge_namespace\" : \"%s\"," json_node_uberspark_platform_var.bridges.as_bridge_namespace;
	retstr := !retstr ^ Printf.sprintf  "\n\t\"uberspark.platform.bridges.casm_bridge_namespace\" : \"%s\"," json_node_uberspark_platform_var.bridges.casm_bridge_namespace;
	retstr := !retstr ^ Printf.sprintf  "\n\t\"uberspark.platform.bridges.ld_bridge_namespace\" : \"%s\"," json_node_uberspark_platform_var.bridges.ld_bridge_namespace;
	retstr := !retstr ^ Printf.sprintf  "\n\t\"uberspark.platform.bridges.uberspark_vf_bridge_namespace\" : \"%s\"" json_node_uberspark_platform_var.bridges.uberspark_vf_bridge_namespace;


	retstr := !retstr ^ Printf.sprintf  "\n";

	(!retstr)
;;





