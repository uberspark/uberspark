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

type json_node_uberspark_platform_cpu_t = 
{

	mutable arch : string;
	mutable addressing : string;
	mutable model : string;
};;


type json_node_uberspark_platform_bridges_t = 
{
	mutable bridge_id : string;
	mutable bridge_namespace : string;

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
	mutable bridges : (string * json_node_uberspark_platform_bridges_t) list; 
	mutable cpu : json_node_uberspark_platform_cpu_t;
	
};;

(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* interface definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)



(*--------------------------------------------------------------------------*)
(* 
	parse uberspark.platform.bridges json nodes and populate
	bridges field of provided platform variable
	return: true on success, false if there was an issue with type errors 
	during parsing
*)
(*--------------------------------------------------------------------------*)
let json_node_uberspark_platform_bridges_to_var 
	?(p_only_configurable = false)
	(mf_json : Yojson.Basic.t)
	(json_node_uberspark_platform_var : json_node_uberspark_platform_t) 
	: bool =
	let retval = ref true in

	let l_bridges_list : (string * json_node_uberspark_platform_bridges_t) list ref = ref [] in

	(* copy over all the input list values to begin with *)
	l_bridges_list := json_node_uberspark_platform_var.bridges;

	(* we don't use p_only_configurable currently; we allow overriding all 
	bridge_id, bridge_namespace values *)
	try
		let open Yojson.Basic.Util in

		if (mf_json |> member "uberspark.platform.bridges") <> `Null then
		begin
			let l_node_list =  mf_json |> member "uberspark.platform.bridges" |> to_list in
			List.iter (fun x -> 
				let l_bridges_var : json_node_uberspark_platform_bridges_t = 
					{ bridge_id = ""; bridge_namespace = ""; } in

				l_bridges_var.bridge_id <- x |> member "bridge_id" |> to_string;
				l_bridges_var.bridge_namespace <- x |> member "bridge_namespace" |> to_string;
	
				(* add to l_bridges_list by overriding existing values if any *)
				l_bridges_list := List.remove_assoc l_bridges_var.bridge_id !l_bridges_list;
				l_bridges_list := !l_bridges_list @ [(l_bridges_var.bridge_id, l_bridges_var);] ;

			) l_node_list;

			json_node_uberspark_platform_var.bridges <- !l_bridges_list;
		end;


	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval)
;;


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

		if not (json_node_uberspark_platform_bridges_to_var ~p_only_configurable:p_only_configurable
			mf_json json_node_uberspark_platform_var) then begin
			retval := false;
		end else begin
			
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


			if (Yojson.Basic.Util.member "uberspark.platform.cpu.arch" mf_json) <> `Null then
				json_node_uberspark_platform_var.cpu.arch <- Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uberspark.platform.cpu.arch" mf_json);

			if (Yojson.Basic.Util.member "uberspark.platform.cpu.addressing" mf_json) <> `Null then
				json_node_uberspark_platform_var.cpu.addressing <- Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uberspark.platform.cpu.addressing" mf_json);

			if (Yojson.Basic.Util.member "uberspark.platform.cpu.model" mf_json) <> `Null then
				json_node_uberspark_platform_var.cpu.model <- Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uberspark.platform.cpu.model" mf_json);


			retval := true;
		end;

	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval)
;;



(* 
	copy constructor for uberspark.platform.xxx nodes
	we use this to copy one json_node_uberspark_platform_t 
	variable into another 
*)
let json_node_uberspark_platform_var_copy 
	(output : json_node_uberspark_platform_t )
	(input : json_node_uberspark_platform_t )
	: unit = 

	output.binary.page_size 								<- 	input.binary.page_size 							;
	output.binary.uobj_section_alignment 					<- 	input.binary.uobj_section_alignment 				;
	output.binary.uobj_default_section_size 				<- 	input.binary.uobj_default_section_size 			;
	output.binary.uobj_image_load_address 					<- 	input.binary.uobj_image_load_address 				;
	output.binary.uobj_image_uniform_size 					<- 	input.binary.uobj_image_uniform_size 				;
	output.binary.uobj_image_size 							<- 	input.binary.uobj_image_size 						;
	output.binary.uobj_image_alignment 					<- 	input.binary.uobj_image_alignment 				;
	output.binary.uobjcoll_image_load_address 				<- 	input.binary.uobjcoll_image_load_address 			;
	output.binary.uobjcoll_image_hdr_section_alignment 	<- 	input.binary.uobjcoll_image_hdr_section_alignment ;
	output.binary.uobjcoll_image_hdr_section_size 			<- 	input.binary.uobjcoll_image_hdr_section_size 		;
	output.binary.uobjcoll_image_section_alignment 		<- 	input.binary.uobjcoll_image_section_alignment 	;
	output.binary.uobjcoll_image_size 						<- 	input.binary.uobjcoll_image_size 					;

	output.bridges 			<- 	input.bridges	;

	output.cpu.arch 						<- 	input.cpu.arch 					;
	output.cpu.addressing						<- 	input.cpu.addressing 					;
	output.cpu.model 						<- 	input.cpu.model 					;

	()
;;


(* default json_node_uberspark_platform_t variable definition *)
(* we use this to initialize variables of type json_node_uberspark_platform_t *)
let json_node_uberspark_platform_var_default_value () 
	: json_node_uberspark_platform_t = 

	{
		binary = {
			page_size = 0;
			uobj_section_alignment = 0;
			uobj_default_section_size = 0;
			uobj_image_load_address = 0;
			uobj_image_uniform_size = true;
			uobj_image_size = 0;
			uobj_image_alignment = 0;
			uobjcoll_image_load_address = 0;
			uobjcoll_image_hdr_section_alignment = 0;
			uobjcoll_image_hdr_section_size = 0;
			uobjcoll_image_section_alignment = 0;
			uobjcoll_image_size = 0;
		};
		bridges = [];

		cpu = {
			arch = "";
			addressing = "";
			model = "";
		};

	}
;;
