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
		input = [ ".c" ]; output = [ ".o" ]; bridge_namespace = "cc-bridge"; bridge_cmd = [];
		uobj_namespace = "";
		uobjrtl_namespace = "";
	};

	{
		targets = [ "build"; ];
		name = "translating .cS to .s";
		category = "translation";
		input = [ ".cS" ]; output = [ ".s" ]; bridge_namespace = "casm-bridge"; bridge_cmd = [];
		uobj_namespace = "";
		uobjrtl_namespace = "";
	};

	{
		targets = [ "build"; ];
		name = "translating .s to .o";
		category = "translation";
		input = [ ".s" ]; output = [ ".o" ]; bridge_namespace = "as-bridge"; bridge_cmd = [];
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

	(* store triage and staging dir prefix *)
	g_triage_dir_prefix := p_triage_dir_prefix;
	g_staging_dir_prefix := p_staging_dir_prefix;

	Hashtbl.iter (fun x y -> Hashtbl.add g_uobjrtl_manifest_var_hashtbl x y; )p_uobjrtl_manifest_var_hashtbl;

	(* add default actions for uobjcoll manifest actions if needed *)
	Uberspark_manifest.uberspark_manifest_var_copy g_uobjcoll_manifest_var p_uobjcoll_manifest_var;
	if List.length g_uobjcoll_manifest_var.manifest.actions == 0 then begin
		g_uobjcoll_manifest_var.manifest.actions <- [ g_default_action; ];
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "Added default action to uobjcoll: %s" 
			g_uobjcoll_manifest_var.uobjcoll.namespace; 
	end;
	
	(* add default actions for uobj manifest actions if needed *)
	List.iter ( fun ( (l_uobj_ns:string), (l_uobj_manifest_var:Uberspark_manifest.uberspark_manifest_var_t) ) -> 
		if List.length l_uobj_manifest_var.manifest.actions == 0 then begin
			l_uobj_manifest_var.manifest.actions <- [ g_default_action; ];
			Uberspark_logger.log ~lvl:Uberspark_logger.Debug "Added default action to uobj: %s" 
				l_uobj_manifest_var.uobj.namespace; 
		end;

		g_uobj_manifest_var_assoc_list := !g_uobj_manifest_var_assoc_list @ [ (l_uobj_ns, l_uobj_manifest_var); ];

	) p_uobj_manifest_var_assoc_list;


	(* add default actions for uobjrtl manifest actions if needed *)
	Hashtbl.iter (fun (l_uobjrtl_ns : string) (l_uobjrtl_manifest_var : Uberspark_manifest.uberspark_manifest_var_t)  ->
		if List.length l_uobjrtl_manifest_var.manifest.actions == 0 then begin
			l_uobjrtl_manifest_var.manifest.actions <- [ g_default_action; ];
			Uberspark_logger.log ~lvl:Uberspark_logger.Debug "Added default action to uobjrtl: %s" 
				l_uobjrtl_manifest_var.uobjrtl.namespace; 
		end;

		Hashtbl.add p_uobjrtl_manifest_var_hashtbl l_uobjrtl_ns l_uobjrtl_manifest_var;

	) p_uobjrtl_manifest_var_hashtbl;


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
	 

	(true)
;;


(*--------------------------------------------------------------------------*)
(* consolidate actions for uobj_action category *)
(*--------------------------------------------------------------------------*)
let consolidate_actions_for_category_uobj_action
	(p_uobj_action_node : Uberspark_manifest.json_node_uberspark_manifest_actions_t)
	: bool * Uberspark_manifest.json_node_uberspark_manifest_actions_t list =
	let retval = ref true in 
	let retval_list : Uberspark_manifest.json_node_uberspark_manifest_actions_t list ref = ref [] in 

	(* TBD:
		use p_uobj_action_node and return the list of actions 
	*)

	(!retval, !retval_list)
;;


(*--------------------------------------------------------------------------*)
(* consolidate actions for uobjrtl_action category *)
(*--------------------------------------------------------------------------*)
let consolidate_actions_for_category_uobjrtl_action
	(p_uobj_action_node : Uberspark_manifest.json_node_uberspark_manifest_actions_t)
	: bool * Uberspark_manifest.json_node_uberspark_manifest_actions_t list =
	let retval = ref true in 
	let retval_list : Uberspark_manifest.json_node_uberspark_manifest_actions_t list ref = ref [] in 

	(* TBD:
		use p_uobj_action_node and return the list of actions 
	*)

	(!retval, !retval_list)
;;


(*
			
	g_actions_assoc_list := g_actions_assoc_list @ [ (g_uobjcoll_manifest_var.uobjcoll.namespace, l_json_node_uberspark_manifest_action); ];

*)

(*--------------------------------------------------------------------------*)
(* expand default_action category within manifest actions *)
(*--------------------------------------------------------------------------*)
let expand_category_default_action
	()
	: bool = 
	let l_actions_list : Uberspark_manifest.json_node_uberspark_manifest_actions_t list ref = ref [] in 

	(* expand uobjcoll manifest actions *)
	List.iter ( fun (l_uobjcoll_action : Uberspark_manifest.json_node_uberspark_manifest_actions_t) -> 

		if l_uobjcoll_action.category == "default_action" then begin

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
			let l_uobcoll_action = new_action_element () in
			
			l_uobjcoll_action.targets <- ["build";];
			l_uobjcoll_action.name <- "uobjcoll binary build action";
			l_uobjcoll_action.category <- "translation";
			l_uobjcoll_action.input <- [".o";];
			l_uobjcoll_action.output <- [".flat";];
			l_uobjcoll_action.bridge_namespace <- "cc-bridge";
						
			l_actions_list := !l_actions_list @ [ l_uobjcoll_action; ];

		end else begin

			(* not a default action, so copy as is *)
			l_actions_list := !l_actions_list @ [ l_uobjcoll_action; ];

		end;

	
	) g_uobjcoll_manifest_var.manifest.actions;
	
	g_uobjcoll_manifest_var.manifest.actions <- !l_actions_list;


	(* expand uobj manifest actions *)
	let l_uobj_manifest_var_assoc_list : (string * Uberspark_manifest.uberspark_manifest_var_t) list ref = ref [] in 

	List.iter ( fun ( (l_uobj_ns:string), (l_uobj_manifest_var:Uberspark_manifest.uberspark_manifest_var_t) ) -> 
		l_actions_list := [];

		List.iter ( fun (l_uobj_action : Uberspark_manifest.json_node_uberspark_manifest_actions_t) -> 

			if l_uobj_action.category == "default_action" then begin
				l_actions_list := !l_actions_list @ [ l_uobj_action; ];

			end else begin

				(* not a default action, so copy as is *)
				l_actions_list := !l_actions_list @ [ l_uobj_action; ];

			end;

		)l_uobj_manifest_var.manifest.actions;
	
		l_uobj_manifest_var.manifest.actions <- !l_actions_list;

		l_uobj_manifest_var_assoc_list := !l_uobj_manifest_var_assoc_list @ [ (l_uobj_ns, l_uobj_manifest_var); ]		
	
	) !g_uobj_manifest_var_assoc_list;

	g_uobj_manifest_var_assoc_list := !l_uobj_manifest_var_assoc_list;

	(* expand uobjrtl manifest actions *)
	let l_uobjrtl_manifest_var_hashtbl = Hashtbl.copy g_uobjrtl_manifest_var_hashtbl in

	Hashtbl.clear g_uobjrtl_manifest_var_hashtbl;

	Hashtbl.iter (fun (l_uobjrtl_ns : string) (l_uobjrtl_manifest_var : Uberspark_manifest.uberspark_manifest_var_t)  ->
		l_actions_list := [];

		List.iter ( fun (l_uobjrtl_action : Uberspark_manifest.json_node_uberspark_manifest_actions_t) -> 

			if l_uobjrtl_action.category == "default_action" then begin
				l_actions_list := !l_actions_list @ [ l_uobjrtl_action; ];

			end else begin

				(* not a default action, so copy as is *)
				l_actions_list := !l_actions_list @ [ l_uobjrtl_action; ];

			end;

		)l_uobjrtl_manifest_var.manifest.actions;
	
		l_uobjrtl_manifest_var.manifest.actions <- !l_actions_list;

		Hashtbl.add g_uobjrtl_manifest_var_hashtbl l_uobjrtl_ns l_uobjrtl_manifest_var;		

	) l_uobjrtl_manifest_var_hashtbl;

	(true)
;;


(*--------------------------------------------------------------------------*)
(* consolidate actions *)
(*--------------------------------------------------------------------------*)
let consolidate_actions
	: bool =
	let retval = ref true in 

	(* TBD:
		1. iterate over uobjcoll_manifest_var.manifest.actions
		if default then we call the helper which will return to us the list of actions
		if uobjrtl_action then we call the helper which will return to us the list of actions
		if uobj_action then we call the helper which will return to us the list of actions
		else we just add it to global action list with the uobjcoll_manifest_var
	*)

	(* consolidate actions by expanding default_action category *)
	(* consolidate_actions_expanding_category_default_action (); *)


	
	(!retval)
;;


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
let process_actions
	: bool =
	let retval = ref true in 

	(* TBD:
		iterate over global action list
		1. get manifest var
		2. get action info
		3. build input file list and output file list by invoking helper
		4. call bridge with bridge variables 
	*)

	(!retval)
;;



(*

	List.iter ( fun (l_uberspark_manifest_var : Uberspark_manifest.uberspark_manifest_var_t)  -> 

		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "Checking actions within manifest type: %s (num_actions=%u)..."  
			l_uberspark_manifest_var.manifest.namespace (List.length l_uberspark_manifest_var.manifest.actions);

		if (List.length l_uberspark_manifest_var.manifest.actions) == 0 then begin
			Uberspark_logger.log ~lvl:Uberspark_logger.Debug "No actions specified, adding default actions...";
			(* TBD *)

		end else begin

			(* add the actions to the global actions variable *)
			List.iter ( fun (l_actions_node : Uberspark_manifest.json_node_uberspark_manifest_actions_t)  -> 
				(* check to see if category is uobjaction then we need to replace the actions with one from uobj *)
		
			)l_uberspark_manifest_var.manifest.actions;	
		end;

	) p_manifest_var_list;



*)
