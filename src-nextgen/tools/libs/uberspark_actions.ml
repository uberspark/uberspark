(*===========================================================================*)
(*===========================================================================*)
(*	uberSpark actions interface implementation		 *)
(*	author: amit vasudevan (amitvasudevan@acm.org)							 *)
(*===========================================================================*)
(*===========================================================================*)


(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* type definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)

type uberspark_action_t =
{
	mutable uberspark_manifest_action : Uberspark_manifest.json_node_uberspark_manifest_actions_t;
	mutable uberspark_manifest_var : Uberspark_manifest.uberspark_manifest_var_t;
};;


(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* variable definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)

(* global actions list *)
let g_actions_list : uberspark_action_t list ref = ref [];;

(* manifest variable *)
let g_uobjcoll_manifest_var : Uberspark_manifest.uberspark_manifest_var_t = Uberspark_manifest.uberspark_manifest_var_default_value ();;

(* uobjcoll triage directory prefix *)
let g_triage_dir_prefix = ref "";;

(* staging directory prefix *)
let g_staging_dir_prefix = ref "";;

(* assoc list of uobj manifest variables; maps uobj namespace to uobj manifest variable *)
let g_uobj_manifest_var_assoc_list : (string * Uberspark_manifest.uberspark_manifest_var_t) list ref = ref [];; 

(* hash table of uobjrtl manifest variables: maps uobjrtl namespace to uobjrtl manifest variable *)
let g_uobjrtl_manifest_var_hashtbl = ((Hashtbl.create 32) : ((string, Uberspark_manifest.uberspark_manifest_var_t)  Hashtbl.t));;


(* actions element definition for default_action *)
let g_default_action : Uberspark_manifest.json_node_uberspark_manifest_actions_t = {
	targets = [ "build"; "verify"; "docs"; "install"; ];
	name = "default action";
	category = "default_action";
	input = []; output = []; bridge_namespace = ""; bridge_cmd = [];
	uobj_namespace = "";
	uobjrtl_namespace = "";
};;

(* return a new action element *)
let new_action_element ()
	: Uberspark_manifest.json_node_uberspark_manifest_actions_t = {
	targets = [ "build"; "verify"; "docs"; "install"; ];
	name = "default action";
	category = "default_action";
	input = []; output = []; bridge_namespace = ""; bridge_cmd = [];
	uobj_namespace = "";
	uobjrtl_namespace = "";
};;




(* default actions list for uobjrtl *)
let g_uobjrtl_default_action_list : Uberspark_manifest.json_node_uberspark_manifest_actions_t list = [
	{
		targets = [ "build"; ];
		name = "translating .c to .o";
		category = "translation";
		input = [ "*.c" ]; output = [ "*.o" ]; bridge_namespace = Uberspark_config.json_node_uberspark_config_var.cc_bridge_namespace; bridge_cmd = [];
		uobj_namespace = "";
		uobjrtl_namespace = "";
	};

	{
		targets = [ "build"; ];
		name = "translating .cS to .s";
		category = "translation";
		input = [ "*.cS" ]; output = [ "*.s" ]; bridge_namespace = Uberspark_config.json_node_uberspark_config_var.casm_bridge_namespace; bridge_cmd = [];
		uobj_namespace = "";
		uobjrtl_namespace = "";
	};

	{
		targets = [ "build"; ];
		name = "translating .s to .o";
		category = "translation";
		input = [ "*.s" ]; output = [ "*.o" ]; bridge_namespace = Uberspark_config.json_node_uberspark_config_var.as_bridge_namespace; bridge_cmd = [];
		uobj_namespace = "";
		uobjrtl_namespace = "";
	};

]	
;;


(* default actions list for uobjs *)
let g_uobj_default_action_list : Uberspark_manifest.json_node_uberspark_manifest_actions_t list = [
	{
		targets = [ "build"; ];
		name = "translating .c to .o";
		category = "translation";
		input = [ "*.c" ]; output = [ "*.o" ]; bridge_namespace = Uberspark_config.json_node_uberspark_config_var.cc_bridge_namespace; bridge_cmd = [];
		uobj_namespace = "";
		uobjrtl_namespace = "";
	};

	{
		targets = [ "build"; ];
		name = "translating .cS to .s";
		category = "translation";
		input = [ "*.cS" ]; output = [ "*.s" ]; bridge_namespace = Uberspark_config.json_node_uberspark_config_var.casm_bridge_namespace; bridge_cmd = [];
		uobj_namespace = "";
		uobjrtl_namespace = "";
	};

	{
		targets = [ "build"; ];
		name = "translating .s to .o";
		category = "translation";
		input = [ "*.s" ]; output = [ "*.o" ]; bridge_namespace = Uberspark_config.json_node_uberspark_config_var.as_bridge_namespace; bridge_cmd = [];
		uobj_namespace = "";
		uobjrtl_namespace = "";
	};

]	
;;



(* assoc list of all actions to be processed; indexed by namespace of the uobjcoll, uobj or uobjrtl involved *)
let g_actions_assoc_list : (string * uberspark_action_t) list ref = ref [];; 



(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* interface definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)



let consolidate_actions_uobj 
	(p_uobj_manifest_var : Uberspark_manifest.uberspark_manifest_var_t)
	: bool * Uberspark_manifest.json_node_uberspark_manifest_actions_t list =
	let retval = ref true in
	let l_actions_list : Uberspark_manifest.json_node_uberspark_manifest_actions_t list ref = ref [] in 

	List.iter ( fun (l_uobj_action : Uberspark_manifest.json_node_uberspark_manifest_actions_t) -> 
		if !retval then begin

			if l_uobj_action.category = "default_action" then begin

				(* thread through the default actions for the uobj *)				
				l_actions_list := !l_actions_list @ g_uobj_default_action_list;

			end else if l_uobj_action.category = "translation" then begin

				(* plug in the action as is *)
				l_actions_list := !l_actions_list @ [ l_uobj_action; ];

			end else begin
				
				(* unknown category, print error and exit *)
				Uberspark_logger.log ~lvl:Uberspark_logger.Error "unkown uobj action category: %s" l_uobj_action.category;
				retval := false;
			
			end;
		end;
	) p_uobj_manifest_var.manifest.actions;

	(!retval, !l_actions_list)
;;


let consolidate_actions_uobjrtl 
	(p_uobjrtl_manifest_var : Uberspark_manifest.uberspark_manifest_var_t)
	: bool * Uberspark_manifest.json_node_uberspark_manifest_actions_t list =
	let retval = ref true in
	let l_actions_list : Uberspark_manifest.json_node_uberspark_manifest_actions_t list ref = ref [] in 

	List.iter ( fun (l_uobjrtl_action : Uberspark_manifest.json_node_uberspark_manifest_actions_t) -> 
		if !retval then begin

			if l_uobjrtl_action.category = "default_action" then begin

				(* thread through the default actions for the uobj *)				
				l_actions_list := !l_actions_list @ g_uobjrtl_default_action_list;

			end else if l_uobjrtl_action.category = "translation" then begin

				(* plug in the action as is *)
				l_actions_list := !l_actions_list @ [ l_uobjrtl_action; ];

			end else begin
				
				(* unknown category, print error and exit *)
				Uberspark_logger.log ~lvl:Uberspark_logger.Error "unkown uobjrtl action category: %s" l_uobjrtl_action.category;
				retval := false;
			
			end;
		end;
	) p_uobjrtl_manifest_var.manifest.actions;

	(!retval, !l_actions_list)
;;


(*--------------------------------------------------------------------------*)
(* consolidate actions *)
(*--------------------------------------------------------------------------*)
let consolidate_actions ()
	: bool =
	let retval = ref true in


	let l_add_to_global_actions_list 
		(p_manifest_actions_list: Uberspark_manifest.json_node_uberspark_manifest_actions_t list)
		(p_uberspark_manifest_var : Uberspark_manifest.uberspark_manifest_var_t)
		: unit =

		List.iter ( fun (l_manifest_action : Uberspark_manifest.json_node_uberspark_manifest_actions_t) -> 

			g_actions_list := !g_actions_list @ [ {
					uberspark_manifest_action = l_manifest_action;
					uberspark_manifest_var = p_uberspark_manifest_var;
					}
			];

		) p_manifest_actions_list;
	
		()
	in

	(* expand uobjcoll manifest actions *)
	List.iter ( fun (l_uobjcoll_action : Uberspark_manifest.json_node_uberspark_manifest_actions_t) -> 
		if !retval then begin

			if l_uobjcoll_action.category = "uobj_action" then begin
				
				let l_uobj_manifest_var = List.assoc l_uobjcoll_action.uobj_namespace !g_uobj_manifest_var_assoc_list  in
				let (rval, ll_actions_list) = (consolidate_actions_uobj l_uobj_manifest_var) in
				if rval then begin
					l_add_to_global_actions_list ll_actions_list l_uobj_manifest_var;
				end else begin
					retval := rval;
				end;

			end else if l_uobjcoll_action.category = "uobjrtl_action" then begin

				let l_uobjrtl_manifest_var = Hashtbl.find g_uobjrtl_manifest_var_hashtbl l_uobjcoll_action.uobjrtl_namespace in
				let (rval, ll_actions_list) = (consolidate_actions_uobjrtl l_uobjrtl_manifest_var) in
				if rval then begin
					l_add_to_global_actions_list ll_actions_list l_uobjrtl_manifest_var;
				end else begin
					retval := rval;
				end;

			end else if l_uobjcoll_action.category = "translation" then begin

				(* store action in global actions list, as is *)
				l_add_to_global_actions_list [ l_uobjcoll_action;] g_uobjcoll_manifest_var;

			end else begin
				(* unknown category, print error and exit *)
				Uberspark_logger.log ~lvl:Uberspark_logger.Error "%s: unknown category=%s" __LOC__ l_uobjcoll_action.category;
				retval := false;
			end;
		end;
	) g_uobjcoll_manifest_var.manifest.actions;

	(!retval)
;;


(*--------------------------------------------------------------------------*)
(* initiatize actions processing *)
(*--------------------------------------------------------------------------*)
let initialize
	(p_uobjcoll_manifest_var : Uberspark_manifest.uberspark_manifest_var_t)
	(p_uobj_manifest_var_assoc_list : (string * Uberspark_manifest.uberspark_manifest_var_t) list)
	(p_uobjrtl_manifest_var_hashtbl : ((string, Uberspark_manifest.uberspark_manifest_var_t)  Hashtbl.t))
	(p_triage_dir_prefix : string )
	(p_staging_dir_prefix : string )
	: bool =

	let l_uobjcoll_actions_list : Uberspark_manifest.json_node_uberspark_manifest_actions_t list ref = ref [] in 

	let l_add_default_uobjcoll_actions () : 
		Uberspark_manifest.json_node_uberspark_manifest_actions_t list =
		let l_actions_list : Uberspark_manifest.json_node_uberspark_manifest_actions_t list ref = ref [] in 

		(* add action element for each uobjrtl of category uobjrtl_action *)
		Hashtbl.iter (fun (l_uobjrtl_ns : string) (l_uobjrtl_manifest_var : Uberspark_manifest.uberspark_manifest_var_t)  ->
		
			let l_uobjrtl_action = new_action_element () in
			
			l_uobjrtl_action.name <- "uobjrtl action";
			l_uobjrtl_action.category <- "uobjrtl_action";
			l_uobjrtl_action.uobjrtl_namespace <- l_uobjrtl_ns;
			
			l_actions_list := !l_actions_list @ [ l_uobjrtl_action; ];
		
		) g_uobjrtl_manifest_var_hashtbl;		

		(* add action element for each uobj of category uobj_action *)
		List.iter ( fun ( (l_uobj_ns:string), (l_uobj_manifest_var:Uberspark_manifest.uberspark_manifest_var_t) ) -> 

			let l_uobj_action = new_action_element () in
			
			l_uobj_action.name <- "uobj action";
			l_uobj_action.category <- "uobj_action";
			l_uobj_action.uobj_namespace <- l_uobj_ns;
			
			l_actions_list := !l_actions_list @ [ l_uobj_action; ];

		) !g_uobj_manifest_var_assoc_list;

		(* add action element for final uobjcoll binary build *)
		let l_uobjcoll_action = new_action_element () in
		
		l_uobjcoll_action.targets <- ["build";];
		l_uobjcoll_action.name <- "uobjcoll binary build action";
		l_uobjcoll_action.category <- "translation";
		l_uobjcoll_action.input <- ["*.o";];
		l_uobjcoll_action.output <- [ "uobjcoll.flat";];
		l_uobjcoll_action.bridge_namespace <- Uberspark_config.json_node_uberspark_config_var.ld_bridge_namespace;
					
		l_actions_list := !l_actions_list @ [ l_uobjcoll_action; ];

		(!l_actions_list)
	in

	(* store triage and staging dir prefix *)
	g_triage_dir_prefix := p_triage_dir_prefix;
	g_staging_dir_prefix := p_staging_dir_prefix;

	(* if uobjrtl manifest actions is empty for any given uobjrtl, then add default actions *)
	(* Hashtbl.iter (fun x y -> Hashtbl.add g_uobjrtl_manifest_var_hashtbl x y; )p_uobjrtl_manifest_var_hashtbl;*)
	Hashtbl.iter (fun (l_uobjrtl_ns : string) (l_uobjrtl_manifest_var : Uberspark_manifest.uberspark_manifest_var_t)  ->
		
		if List.length l_uobjrtl_manifest_var.manifest.actions == 0 then begin
		
			l_uobjrtl_manifest_var.manifest.actions <- [ g_default_action; ];
			Uberspark_logger.log ~lvl:Uberspark_logger.Debug "Added default action to uobjrtl: %s" 
				l_uobjrtl_manifest_var.uobjrtl.namespace; 
			
		end;

		Hashtbl.add g_uobjrtl_manifest_var_hashtbl l_uobjrtl_ns l_uobjrtl_manifest_var;

	) p_uobjrtl_manifest_var_hashtbl;

	(* if uobj manifest actions is empty for any given uobj, then add default actions *)
	List.iter ( fun ( (l_uobj_ns:string), (l_uobj_manifest_var:Uberspark_manifest.uberspark_manifest_var_t) ) -> 
		
		if List.length l_uobj_manifest_var.manifest.actions == 0 then begin
			
			l_uobj_manifest_var.manifest.actions <- [ g_default_action; ];
			Uberspark_logger.log ~lvl:Uberspark_logger.Debug "Added default action to uobj: %s" 
				l_uobj_manifest_var.uobj.namespace; 
		
		end;

		g_uobj_manifest_var_assoc_list := !g_uobj_manifest_var_assoc_list @ [ (l_uobj_ns, l_uobj_manifest_var); ];

	) p_uobj_manifest_var_assoc_list;

	(* iterate through uobjcoll manifest actions, if empty, then add default actions *)
	(* expand any default_action category is non_empty *)
	Uberspark_manifest.uberspark_manifest_var_copy g_uobjcoll_manifest_var p_uobjcoll_manifest_var;

	if List.length p_uobjcoll_manifest_var.manifest.actions == 0 then begin
		g_uobjcoll_manifest_var.manifest.actions <- l_add_default_uobjcoll_actions ();

		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "Added default actions to uobjcoll: %s" 
			g_uobjcoll_manifest_var.uobjcoll.namespace; 

	end else begin

		List.iter ( fun (l_uobjcoll_action : Uberspark_manifest.json_node_uberspark_manifest_actions_t) -> 

			if l_uobjcoll_action.category == "default_action" then begin
				l_uobjcoll_actions_list := !l_uobjcoll_actions_list @ (l_add_default_uobjcoll_actions ());
			end else begin
				l_uobjcoll_actions_list := !l_uobjcoll_actions_list @ [ l_uobjcoll_action; ];
			end;

		)p_uobjcoll_manifest_var.manifest.actions;

		g_uobjcoll_manifest_var.manifest.actions <- !l_uobjcoll_actions_list;

	end;

	(* consolidate all actions *)
	let rval = consolidate_actions () in

	if not rval then
		(false)
	else

	let dummy=0 in begin
		
		(* debug dump *)
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "uobjcoll (%s) total actions: %u" 
			g_uobjcoll_manifest_var.uobjcoll.namespace (List.length g_uobjcoll_manifest_var.manifest.actions);
		List.iter ( fun ( (l_uobj_ns:string), (l_uobj_manifest_var:Uberspark_manifest.uberspark_manifest_var_t) ) -> 
			Uberspark_logger.log ~lvl:Uberspark_logger.Debug "uobj (%s) total actions: %u" 
				l_uobj_manifest_var.uobj.namespace (List.length l_uobj_manifest_var.manifest.actions);
		) !g_uobj_manifest_var_assoc_list;
		Hashtbl.iter (fun (l_uobjrtl_ns : string) (l_uobjrtl_manifest_var : Uberspark_manifest.uberspark_manifest_var_t)  ->
			Uberspark_logger.log ~lvl:Uberspark_logger.Debug "uobjrtl (%s) total actions: %u" 
				l_uobjrtl_manifest_var.uobjrtl.namespace (List.length l_uobjrtl_manifest_var.manifest.actions);
		) g_uobjrtl_manifest_var_hashtbl;
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "triage dir prefix=%s" !g_triage_dir_prefix;
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "staging dir prefix=%s" !g_staging_dir_prefix;
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "consolidated actions: %u" (List.length !g_actions_list);

	end;


	(true)
;;




(*
			
	g_actions_assoc_list := g_actions_assoc_list @ [ (g_uobjcoll_manifest_var.uobjcoll.namespace, l_json_node_uberspark_manifest_action); ];

*)

(*
	let wildcard (p_str : string ) : bool = 
		if p_str starts with . then return true
		else return false
		
	List.exists wildcard list_name

*)


(*--------------------------------------------------------------------------*)
(* create and return a list of files for either input our output *)
(* given a manifest var and extension filter *)
(*--------------------------------------------------------------------------*)
let filter_source_filename_list 
	(p_uberspark_manifest_var : Uberspark_manifest.uberspark_manifest_var_t)
	(p_wildcard_ext : string) 
	: string list =

	let l_return_list : string list ref = ref [] in 

	if p_uberspark_manifest_var.manifest.namespace = "uberspark/uobj" then begin
		
		List.iter ( fun (l_filename : string) ->
			if (Filename.extension l_filename) = p_wildcard_ext then begin
				l_return_list := !l_return_list @ [ l_filename; ];
			end;
		) p_uberspark_manifest_var.uobj.sources.source_c_files;
		
	end else if p_uberspark_manifest_var.manifest.namespace = "uberspark/uobjrtl" then begin

		List.iter ( fun (l_source_file : Uberspark_manifest.Uobjrtl.json_node_uberspark_uobjrtl_modules_spec_t) -> 
			if (Filename.extension l_source_file.path) = p_wildcard_ext then begin
				l_return_list := !l_return_list @ [ l_source_file.path; ];
			end;
		) p_uberspark_manifest_var.uobjrtl.source_c_files;

	end else begin

		Uberspark_logger.log ~lvl:Uberspark_logger.Warn "%s: unknown manifest namespace=%s" __LOC__ p_uberspark_manifest_var.manifest.namespace; 
		l_return_list := [];

	end;

	(!l_return_list)
;;


(*--------------------------------------------------------------------------*)
(* build input and output list *)
(*--------------------------------------------------------------------------*)
(*
	return input list, return output list
	return input ext, return output ext
	return true on success, false on failure
*)
let build_input_output
	(p_uberspark_action : uberspark_action_t )
	: (bool * string list * string list * string * string) =
	
	let l_retval = ref true in 
	let l_input_list : string list ref = ref [] in 
	let l_output_list : string list ref = ref [] in 
	let l_input_wildcard_ext = ref "" in 
	let l_output_wildcard_ext = ref "" in 
	
	(* check if the string begins with wildcard characters and stores the extension in l_input_wildcard_ext if so *)
	let l_wildcard_input (p_str : string ) : bool =
		if (Filename.remove_extension p_str) = "*" then begin
			l_input_wildcard_ext := Filename.extension p_str;
			(true)
		end else begin
			(false)
		end
	in

	(* check if the string begins with wildcard characters and stores the extension in l_output_wildcard_ext if so *)
	let l_wildcard_output (p_str : string ) : bool =
		if (Filename.remove_extension p_str) = "*" then begin
			l_output_wildcard_ext := Filename.extension p_str;
			(true)
		end else begin
			(false)
		end
	in


	(*  
		input and output list must have at least one element
		input can be a wildcard, output has to be wildcard or a single entry 
	    if input has no wildcard, output cannot have wildcard
		output can be a single entry or the same number of entries as input
		all input extensions must be same, all output extensions must be same	
	*)

	(* if (List.length p_uberspark_action.uberspark_manifest_action.input >= 1 && 
		List.length p_uberspark_action.uberspark_manifest_action.output >= 1) then begin
	*)

	if (List.length p_uberspark_action.uberspark_manifest_action.input >= 1) then begin

		if (List.exists l_wildcard_input p_uberspark_action.uberspark_manifest_action.input) then begin

			if (List.exists l_wildcard_output p_uberspark_action.uberspark_manifest_action.output) then begin
				
				l_input_list := filter_source_filename_list p_uberspark_action.uberspark_manifest_var !l_input_wildcard_ext; 
				l_output_list := filter_source_filename_list p_uberspark_action.uberspark_manifest_var !l_output_wildcard_ext; 

			end else begin
				if List.length p_uberspark_action.uberspark_manifest_action.output = 1 then begin
					l_input_list := filter_source_filename_list p_uberspark_action.uberspark_manifest_var !l_input_wildcard_ext; 
					l_output_list := [ (List.nth p_uberspark_action.uberspark_manifest_action.output 0); ];
				end else begin
					Uberspark_logger.log ~lvl:Uberspark_logger.Error "%s: action input is a wildcard, output has to be wildcard!" __LOC__; 
					l_retval := false;
				end;
			end;
		
		end else begin

			if (List.exists l_wildcard_output p_uberspark_action.uberspark_manifest_action.output) then begin
					Uberspark_logger.log ~lvl:Uberspark_logger.Error "%s: action input is not a wildcard, output cannot be wildcard!" __LOC__; 
					l_retval := false;
			end else begin
				if List.length p_uberspark_action.uberspark_manifest_action.output = 1 then begin

					l_input_wildcard_ext := Filename.extension ((List.nth p_uberspark_action.uberspark_manifest_action.input 1));
					List.iter ( fun (l_filename : string) ->
						if (Filename.extension l_filename) = !l_input_wildcard_ext then begin
							l_input_list := !l_input_list @ [ l_filename; ];
						end else begin
							Uberspark_logger.log ~lvl:Uberspark_logger.Error "%s: action input list has files of different extensions!" __LOC__; 
							l_retval := false;
						end;
					)p_uberspark_action.uberspark_manifest_action.input;

					l_output_list := [ (List.nth p_uberspark_action.uberspark_manifest_action.output 0); ];

				end else if List.length p_uberspark_action.uberspark_manifest_action.output = List.length p_uberspark_action.uberspark_manifest_action.input then begin

					l_input_wildcard_ext := Filename.extension ((List.nth p_uberspark_action.uberspark_manifest_action.input 0));
					List.iter ( fun (l_filename : string) ->
						if (Filename.extension l_filename) = !l_input_wildcard_ext then begin
							l_input_list := !l_input_list @ [ l_filename; ];
						end else begin
							Uberspark_logger.log ~lvl:Uberspark_logger.Error "%s: action input list has files of different extensions! " __LOC__; 
							l_retval := false;
						end;
					)p_uberspark_action.uberspark_manifest_action.input;

					if !l_retval then begin
						l_output_wildcard_ext := Filename.extension ((List.nth p_uberspark_action.uberspark_manifest_action.output 0));
						List.iter ( fun (l_filename : string) ->
							if (Filename.extension l_filename) = !l_output_wildcard_ext then begin
								l_output_list := !l_output_list @ [ l_filename; ];
							end else begin
								Uberspark_logger.log ~lvl:Uberspark_logger.Error "%s: action output list has files of different extensions!" __LOC__; 
								l_retval := false;
							end;
						)p_uberspark_action.uberspark_manifest_action.input;
					end;

				end else begin
					Uberspark_logger.log ~lvl:Uberspark_logger.Error "%s: output can be a single entry or the same number of entries as input" __LOC__; 
					l_retval := false;
				end;
			end;
		
		end;
	
	end else begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "%s: action input and output list must have at least one element!" __LOC__; 
		l_retval := false;
	end;	

	(!l_retval, !l_input_list, !l_output_list, !l_input_wildcard_ext, !l_output_wildcard_ext)
;;


(*--------------------------------------------------------------------------*)
(* process actions *)
(*--------------------------------------------------------------------------*)
let process_actions ()
	: bool =
	let retval = ref true in 

	let l_current_action_index = ref 1 in
	Uberspark_logger.log ~lvl:Uberspark_logger.Info "Processing actions...(total=%u)" (List.length !g_actions_list);
	Uberspark_logger.log ~lvl:Uberspark_logger.Info "Initializing action bridges...";

	(* initialize uobjcoll bridges *)
	(* TBD: initialize bridge from consolidated actions *)
	let rval = (Uberspark_bridge.initialize_from_config ()) in	
    if (rval == false) then	begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "unable to initialize uobj collection bridges!";
		(false)
	end else

	let dummy=0 in begin
	Uberspark_logger.log ~lvl:Uberspark_logger.Info "successfully initialized action bridges";
	end;

	let dummy=0 in begin
	(* iterate over global action list *)
	List.iter ( fun (l_action : uberspark_action_t) -> 
		if !retval then begin

			Uberspark_logger.log ~lvl:Uberspark_logger.Info "Processing actions [%u/%u]..." !l_current_action_index (List.length !g_actions_list);
			Uberspark_logger.log ~lvl:Uberspark_logger.Debug "> manifest.namespace=%s" l_action.uberspark_manifest_var.manifest.namespace;

			Uberspark_logger.log ~lvl:Uberspark_logger.Debug "> building input and output file list for action...";
			let (l_rval, l_input_file_list, l_output_file_list, l_input_file_ext, l_output_file_ext) = 
				(build_input_output l_action) in 
			if l_rval then begin
				Uberspark_logger.log ~lvl:Uberspark_logger.Debug 
					"> l_rval=%b, len(l_input_file_list)=%u, len(l_output_file_list)=%u input_file_ext=%s output_file_ext=%s"
					l_rval (List.length l_input_file_list) (List.length l_output_file_list) l_input_file_ext l_output_file_ext;
				
				Uberspark_logger.log ~lvl:Uberspark_logger.Debug "> input and output file list generation success";



				l_current_action_index := !l_current_action_index + 1;

			end else begin
				Uberspark_logger.log ~lvl:Uberspark_logger.Error "unable to build input and output file list for action!";
				retval := false;
			end;

		end;
	) !g_actions_list;
	end;

	(* TBD:
		iterate over global action list
		1. get manifest var
		2. get action info
		3. build input file list and output file list by invoking helper
		4. call bridge with bridge variables 
	*)

	(!retval)
;;



