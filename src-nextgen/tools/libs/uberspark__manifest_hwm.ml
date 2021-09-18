(*===========================================================================*)
(*===========================================================================*)
(* 
	uberSpark hardware model (hwm) manifest interface implementation 
	 author: amit vasudevan (amitvasudevan@acm.org) 
*)
(*===========================================================================*)
(*===========================================================================*)



(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* type definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)


type json_node_uberspark_hwm_cpu_modules_spec_module_funcdecls_t =
{
	mutable fn_name : string;
};;


type json_node_uberspark_hwm_cpu_modules_spec_t =
{
	mutable path : string;
	mutable fn_decls : json_node_uberspark_hwm_cpu_modules_spec_module_funcdecls_t list;
};;

type json_node_uberspark_hwm_cpu_casm_instruction_t =
{
	mutable casm_mnemonic : string;
	mutable casm_total_operands : int;
	mutable output_assembly : string list;
	mutable casm_implementation : string list;
};;


type json_node_uberspark_hwm_cpu_t = 
{

	mutable arch : string;
	mutable addressing : string;
	mutable model : string;

	mutable sources: json_node_uberspark_hwm_cpu_modules_spec_t list;
	mutable casm_instructions: (string * json_node_uberspark_hwm_cpu_casm_instruction_t) list;
};;

type json_node_uberspark_hwm_t = 
{
	mutable namespace: string;
	mutable cpu : json_node_uberspark_hwm_cpu_t;
	
};;

(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* interface definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)



(*--------------------------------------------------------------------------*)
(* 
	parse uberspark.hwm.cpu.xxx json nodes and populate
	cpu field of provided hwm variable
	return: true on success, false if there was an issue with type errors 
	during parsing
*)
(*--------------------------------------------------------------------------*)
let json_node_uberspark_hwm_cpu_to_var 
	?(p_only_configurable = false)
	(mf_json : Yojson.Basic.t)
	(json_node_uberspark_hwm_var : json_node_uberspark_hwm_t) 
	: bool =
	
	let retval = ref true in

	try
		let open Yojson.Basic.Util in

		if (Yojson.Basic.Util.member "uberspark.hwm.cpu.arch" mf_json) <> `Null then
			json_node_uberspark_hwm_var.cpu.arch <- (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uberspark.hwm.cpu.arch" mf_json));

		if (Yojson.Basic.Util.member "uberspark.hwm.cpu.addressing" mf_json) <> `Null then
			json_node_uberspark_hwm_var.cpu.addressing <- (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uberspark.hwm.cpu.addressing" mf_json));

		if (Yojson.Basic.Util.member "uberspark.hwm.cpu.model" mf_json) <> `Null then
			json_node_uberspark_hwm_var.cpu.model <- (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uberspark.hwm.cpu.model" mf_json));

		if (mf_json |> member "uberspark.hwm.cpu.sources") <> `Null then
		begin
			let json_node_uberspark_hwm_cpu_modules_spec_c_list =  mf_json |> member "uberspark.hwm.cpu.sources" |> to_list in
			List.iter (fun x -> 
				let f_modules_spec_c_element : json_node_uberspark_hwm_cpu_modules_spec_t = 
					{ path = ""; fn_decls = []; } in

				f_modules_spec_c_element.path <- x |> member "path" |> to_string;

				(* add to f_modules_spec list *)
				json_node_uberspark_hwm_var.cpu.sources <- json_node_uberspark_hwm_var.cpu.sources @ [ f_modules_spec_c_element ];
			) json_node_uberspark_hwm_cpu_modules_spec_c_list;
		end;

		if (mf_json |> member "uberspark.hwm.cpu.casm_instructions") <> `Null then
		begin
			let json_node_uberspark_hwm_cpu_casm_instructions_list =  
				mf_json |> member "uberspark.hwm.cpu.casm_instructions" |> to_list in
			(*let l_entry_count = ref 0 in *)

			List.iter (fun x -> 
				let f_casm_instruction_element : json_node_uberspark_hwm_cpu_casm_instruction_t = 
					{ casm_mnemonic = ""; casm_total_operands = 0; output_assembly = []; casm_implementation = [];} in


				f_casm_instruction_element.casm_mnemonic <- x |> member "casm_mnemonic" |> to_string;
				(*l_entry_count := !l_entry_count + 1;
				Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "Processing entry: %u: %s" !l_entry_count f_casm_instruction_element.casm_mnemonic;
				*)
				f_casm_instruction_element.casm_total_operands <- int_of_string (x |> member "casm_total_operands" |> to_string);
				f_casm_instruction_element.output_assembly <- json_list_to_string_list (x |> member "output_assembly" |> to_list);

				if (x |> member "casm_implementation") <> `Null then
					f_casm_instruction_element.casm_implementation <- json_list_to_string_list (x |> member "casm_implementation" |> to_list);

				json_node_uberspark_hwm_var.cpu.casm_instructions <- json_node_uberspark_hwm_var.cpu.casm_instructions @ [ (f_casm_instruction_element.casm_mnemonic, f_casm_instruction_element) ];
			) json_node_uberspark_hwm_cpu_casm_instructions_list;
		end;


	with Yojson.Basic.Util.Type_error (e, j) -> 
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "%s" e;
		
		retval := false;
	;

	(!retval)
;;


(*--------------------------------------------------------------------------*)
(* 
	parse uberspark.hwm.xxx json nodes and populate 
	json_node_uberspark_hwm_var if they are found
	return: true on success, false if there was an issue with type errors 
	during parsing
*)
(*--------------------------------------------------------------------------*)

let json_node_uberspark_hwm_to_var 
	?(p_only_configurable = false)
	(mf_json : Yojson.Basic.t)
	(json_node_uberspark_hwm_var : json_node_uberspark_hwm_t) 
	: bool =
	
	let retval = ref false in

	(* use not p_only_configurable for fields that cannot be overlayed *)

	try
		let open Yojson.Basic.Util in

		if (Yojson.Basic.Util.member "uberspark.hwm.namespace" mf_json) <> `Null then
			json_node_uberspark_hwm_var.namespace <- (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uberspark.hwm.namespace" mf_json));

		let (l_rval1) = (json_node_uberspark_hwm_cpu_to_var ~p_only_configurable:p_only_configurable
					mf_json json_node_uberspark_hwm_var) in


		retval := l_rval1;
	
	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval)
;;



(* 
	copy constructor for uberspark.hwm.xxx nodes
	we use this to copy one json_node_uberspark_hwm_t 
	variable into another 
*)
let json_node_uberspark_hwm_var_copy 
	(output : json_node_uberspark_hwm_t )
	(input : json_node_uberspark_hwm_t )
	: unit = 

	output.namespace 								<- 	input.namespace				;

	output.cpu.arch 								<- 	input.cpu.arch				;
	output.cpu.addressing 					<- 	input.cpu.addressing				;
	output.cpu.model  				<- 	input.cpu.model 			;
	output.cpu.sources  				<- 	input.cpu.sources 			;
	output.cpu.casm_instructions  				<- 	input.cpu.casm_instructions 			;

	()
;;


(* default json_node_uberspark_hwm_t variable definition *)
(* we use this to initialize variables of type json_node_uberspark_hwm_t *)
let json_node_uberspark_hwm_var_default_value () 
	: json_node_uberspark_hwm_t = 

	{
		namespace = "";
		cpu = {
			arch = "";
			addressing = "";
			model = "";

			sources = [];
			casm_instructions = [];
		};
	}
;;
