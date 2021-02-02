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
		input = [ ".c" ]; output = [ ".o" ]; bridge_namespace = Uberspark_config.json_node_uberspark_config_var.cc_bridge_namespace; bridge_cmd = [];
		uobj_namespace = "";
		uobjrtl_namespace = "";
	};

	{
		targets = [ "build"; ];
		name = "translating .cS to .s";
		category = "translation";
		input = [ ".cS" ]; output = [ ".s" ]; bridge_namespace = Uberspark_config.json_node_uberspark_config_var.casm_bridge_namespace; bridge_cmd = [];
		uobj_namespace = "";
		uobjrtl_namespace = "";
	};

	{
		targets = [ "build"; ];
		name = "translating .s to .o";
		category = "translation";
		input = [ ".s" ]; output = [ ".o" ]; bridge_namespace = Uberspark_config.json_node_uberspark_config_var.as_bridge_namespace; bridge_cmd = [];
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
		input = [ ".c" ]; output = [ ".o" ]; bridge_namespace = Uberspark_config.json_node_uberspark_config_var.cc_bridge_namespace; bridge_cmd = [];
		uobj_namespace = "";
		uobjrtl_namespace = "";
	};

	{
		targets = [ "build"; ];
		name = "translating .cS to .s";
		category = "translation";
		input = [ ".cS" ]; output = [ ".s" ]; bridge_namespace = Uberspark_config.json_node_uberspark_config_var.casm_bridge_namespace; bridge_cmd = [];
		uobj_namespace = "";
		uobjrtl_namespace = "";
	};

	{
		targets = [ "build"; ];
		name = "translating .s to .o";
		category = "translation";
		input = [ ".s" ]; output = [ ".o" ]; bridge_namespace = Uberspark_config.json_node_uberspark_config_var.as_bridge_namespace; bridge_cmd = [];
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
		l_uobjcoll_action.input <- [".o";];
		l_uobjcoll_action.output <- [".flat";];
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
(* build input and output list *)
(*--------------------------------------------------------------------------*)
let build_input_output
	(p_uberspark_action : uberspark_action_t )
	: (bool * string list * string list) =
	let retval = ref true in 

	(* TBD
		1. use p_uberspark_action.uberspark_manifest.action.input
			if there is an element of type .x then use p_uberspark_action.uberspark_manifest_var
			to grab sources with that extension
			else
			just use the input list as is

		2. use p_uberspark_action.uberspark_manifest.action.output
			if there is an element of type .x then use 
			input list; get basename for every element and then affix .x
			to generate output list
			else
			just use the output list as is iff lentgh of outputlist == length of input list
 	*)


	(!retval, [], [])
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

			l_current_action_index := !l_current_action_index + 1;

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



