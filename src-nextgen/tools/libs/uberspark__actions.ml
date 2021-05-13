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
	mutable uberspark_manifest_action : Uberspark.Manifest.json_node_uberspark_manifest_actions_t;
	mutable uberspark_manifest_var : Uberspark.Manifest.uberspark_manifest_var_t;
};;


(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* variable definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)

(* global actions list *)
let g_actions_list : uberspark_action_t list ref = ref [];;

(* manifest variable *)
let g_uobjcoll_manifest_var : Uberspark.Manifest.uberspark_manifest_var_t = Uberspark.Manifest.uberspark_manifest_var_default_value ();;

(* uobjcoll triage directory prefix *)
let g_triage_dir_prefix = ref "";;

(* staging directory prefix *)
let g_staging_dir_prefix = ref "";;

(* assoc list of uobj manifest variables; maps uobj namespace to uobj manifest variable *)
let g_uobj_manifest_var_assoc_list : (string * Uberspark.Manifest.uberspark_manifest_var_t) list ref = ref [];; 

(* hash table of uobjrtl manifest variables: maps uobjrtl namespace to uobjrtl manifest variable *)
let g_uobjrtl_manifest_var_hashtbl = ((Hashtbl.create 32) : ((string, Uberspark.Manifest.uberspark_manifest_var_t)  Hashtbl.t));;

(* hash table of loader manifest variables: maps loader namespace to loader manifest variable *)
let g_loader_manifest_var_hashtbl = ((Hashtbl.create 32) : ((string, Uberspark.Manifest.uberspark_manifest_var_t)  Hashtbl.t));;

(* hash table of bridge namespace to bridge object *)
let g_bridge_hashtbl = ((Hashtbl.create 32) : ((string, Uberspark.Bridge.bridge_object)  Hashtbl.t));;


(* actions element definition for default_action *)
let g_default_action : Uberspark.Manifest.json_node_uberspark_manifest_actions_t = {
	targets = [ "build"; "verify"; "docs"; "install"; ];
	name = "default action";
	category = "default_action";
	input = []; output = []; bridge_namespace = ""; bridge_cmd = [];
	uobj_namespace = "";
	uobjrtl_namespace = "";
	loader_namespace = "";
};;

(* return a new action element *)
let new_action_element ()
	: Uberspark.Manifest.json_node_uberspark_manifest_actions_t = {
	targets = [ "build"; "verify"; "docs"; "install"; ];
	name = "default action";
	category = "default_action";
	input = []; output = []; bridge_namespace = ""; bridge_cmd = [];
	uobj_namespace = "";
	uobjrtl_namespace = "";
	loader_namespace = "";
};;


(* assoc list of all actions to be processed; indexed by namespace of the uobjcoll, uobj or uobjrtl involved *)
let g_actions_assoc_list : (string * uberspark_action_t) list ref = ref [];; 


(* platform manifest variable *)
let g_uberspark_platform_manifest_var : Uberspark.Manifest.uberspark_manifest_var_t =
	Uberspark.Manifest.uberspark_manifest_var_default_value ();;	

(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* interface definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)



let consolidate_actions_uobj 
	(p_uobj_manifest_var : Uberspark.Manifest.uberspark_manifest_var_t)
	: bool * Uberspark.Manifest.json_node_uberspark_manifest_actions_t list =
	let retval = ref true in
	let l_actions_list : Uberspark.Manifest.json_node_uberspark_manifest_actions_t list ref = ref [] in 

	List.iter ( fun (l_uobj_action : Uberspark.Manifest.json_node_uberspark_manifest_actions_t) -> 
		if !retval then begin

			if l_uobj_action.category = "default_action" then begin

				(* thread through the default actions for the uobj *)				
				l_actions_list := !l_actions_list @ [
					{
						targets = [ "verify"; ];
						category = "translation";
						name = "verifying überSpark invariants";
						input = [ "*.c" ]; output = [ ]; bridge_namespace = g_uberspark_platform_manifest_var.platform.bridges.uberspark_vf_bridge_namespace; bridge_cmd = [];
						uobj_namespace = "";
						uobjrtl_namespace = "";
						loader_namespace = "";
					};

					{
						targets = [ "build"; ];
						name = "translating .c to .o";
						category = "translation";
						input = [ "*.c" ]; output = [ "*.o" ]; bridge_namespace = g_uberspark_platform_manifest_var.platform.bridges.cc_bridge_namespace; bridge_cmd = [];
						uobj_namespace = "";
						uobjrtl_namespace = "";
						loader_namespace = "";
					};

					{
						targets = [ "build"; ];
						name = "translating .cS to .o";
						category = "translation";
						input = [ "*.cS" ]; output = [ "*.o" ]; bridge_namespace = g_uberspark_platform_manifest_var.platform.bridges.casm_bridge_namespace; bridge_cmd = [];
						uobj_namespace = "";
						uobjrtl_namespace = "";
						loader_namespace = "";
					};

					{
						targets = [ "build"; ];
						name = "translating .s to .o";
						category = "translation";
						input = [ "*.s" ]; output = [ "*.o" ]; bridge_namespace = g_uberspark_platform_manifest_var.platform.bridges.as_bridge_namespace; bridge_cmd = [];
						uobj_namespace = "";
						uobjrtl_namespace = "";
						loader_namespace = "";
					};

					{
						targets = [ "build"; ];
						name = "translating .S to .o";
						category = "translation";
						input = [ "*.S" ]; output = [ "*.o" ]; bridge_namespace = g_uberspark_platform_manifest_var.platform.bridges.as_bridge_namespace; bridge_cmd = [];
						uobj_namespace = "";
						uobjrtl_namespace = "";
						loader_namespace = "";
					};

				];

			end else if l_uobj_action.category = "translation" then begin

				(* plug in the action as is *)
				l_actions_list := !l_actions_list @ [ l_uobj_action; ];

			end else begin
				
				(* unknown category, print error and exit *)
				Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "unkown uobj action category: %s" l_uobj_action.category;
				retval := false;
			
			end;
		end;
	) p_uobj_manifest_var.manifest.actions;

	(!retval, !l_actions_list)
;;


let consolidate_actions_uobjrtl 
	(p_uobjrtl_manifest_var : Uberspark.Manifest.uberspark_manifest_var_t)
	: bool * Uberspark.Manifest.json_node_uberspark_manifest_actions_t list =
	let retval = ref true in
	let l_actions_list : Uberspark.Manifest.json_node_uberspark_manifest_actions_t list ref = ref [] in 

	List.iter ( fun (l_uobjrtl_action : Uberspark.Manifest.json_node_uberspark_manifest_actions_t) -> 
		if !retval then begin

			if l_uobjrtl_action.category = "default_action" then begin

				(* thread through the default actions for the uobj *)				
				l_actions_list := !l_actions_list @ [
					{
						targets = [ "build"; ];
						name = "translating .c to .o";
						category = "translation";
						input = [ "*.c" ]; output = [ "*.o" ]; bridge_namespace = g_uberspark_platform_manifest_var.platform.bridges.cc_bridge_namespace; bridge_cmd = [];
						uobj_namespace = "";
						uobjrtl_namespace = "";
						loader_namespace = "";
					};

					{
						targets = [ "build"; ];
						name = "translating .cS to .o";
						category = "translation";
						input = [ "*.cS" ]; output = [ "*.o" ]; bridge_namespace = g_uberspark_platform_manifest_var.platform.bridges.casm_bridge_namespace; bridge_cmd = [];
						uobj_namespace = "";
						uobjrtl_namespace = "";
						loader_namespace = "";
					};

					{
						targets = [ "build"; ];
						name = "translating .s to .o";
						category = "translation";
						input = [ "*.s" ]; output = [ "*.o" ]; bridge_namespace = g_uberspark_platform_manifest_var.platform.bridges.as_bridge_namespace; bridge_cmd = [];
						uobj_namespace = "";
						uobjrtl_namespace = "";
						loader_namespace = "";
					};
				];

			end else if l_uobjrtl_action.category = "translation" then begin

				(* plug in the action as is *)
				l_actions_list := !l_actions_list @ [ l_uobjrtl_action; ];

			end else begin
				
				(* unknown category, print error and exit *)
				Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "unkown uobjrtl action category: %s" l_uobjrtl_action.category;
				retval := false;
			
			end;
		end;
	) p_uobjrtl_manifest_var.manifest.actions;

	(!retval, !l_actions_list)
;;



let consolidate_actions_loader 
	(p_loader_manifest_var : Uberspark.Manifest.uberspark_manifest_var_t)
	: bool * Uberspark.Manifest.json_node_uberspark_manifest_actions_t list =
	let retval = ref true in
	let l_actions_list : Uberspark.Manifest.json_node_uberspark_manifest_actions_t list ref = ref [] in 

	List.iter ( fun (l_loader_action : Uberspark.Manifest.json_node_uberspark_manifest_actions_t) -> 
		if !retval then begin

			if l_loader_action.category = "bridge_exec" then begin

				(* plug in the action as is *)
				l_actions_list := !l_actions_list @ [ l_loader_action; ];

			end else begin
				
				(* unknown category, print error and exit *)
				Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "unkown loader action category: %s" l_loader_action.category;
				retval := false;
			
			end;
		end;
	) p_loader_manifest_var.manifest.actions;

	(!retval, !l_actions_list)
;;




(*--------------------------------------------------------------------------*)
(* consolidate actions *)
(*--------------------------------------------------------------------------*)
let consolidate_actions ()
	: bool =
	let retval = ref true in


	let l_add_to_global_actions_list 
		(p_manifest_actions_list: Uberspark.Manifest.json_node_uberspark_manifest_actions_t list)
		(p_uberspark_manifest_var : Uberspark.Manifest.uberspark_manifest_var_t)
		: unit =

		List.iter ( fun (l_manifest_action : Uberspark.Manifest.json_node_uberspark_manifest_actions_t) -> 

			g_actions_list := !g_actions_list @ [ {
					uberspark_manifest_action = l_manifest_action;
					uberspark_manifest_var = p_uberspark_manifest_var;
					}
			];

		) p_manifest_actions_list;
	
		()
	in

	(* expand uobjcoll manifest actions *)
	List.iter ( fun (l_uobjcoll_action : Uberspark.Manifest.json_node_uberspark_manifest_actions_t) -> 
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

			end else if l_uobjcoll_action.category = "loader_action" then begin

				let l_loader_manifest_var = Hashtbl.find g_loader_manifest_var_hashtbl l_uobjcoll_action.loader_namespace in
				let (rval, ll_actions_list) = (consolidate_actions_loader l_loader_manifest_var) in
				if rval then begin
					l_add_to_global_actions_list ll_actions_list l_loader_manifest_var;
				end else begin
					retval := rval;
				end;

			end else if l_uobjcoll_action.category = "translation" then begin

				(* store action in global actions list, as is *)
				l_add_to_global_actions_list [ l_uobjcoll_action;] g_uobjcoll_manifest_var;

			end else begin
				(* unknown category, print error and exit *)
				Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "%s: unknown category=%s" __LOC__ l_uobjcoll_action.category;
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
	(p_uobjcoll_manifest_var : Uberspark.Manifest.uberspark_manifest_var_t)
	(p_uberspark_platform_manifest_var : Uberspark.Manifest.uberspark_manifest_var_t)
	(p_uobj_manifest_var_assoc_list : (string * Uberspark.Manifest.uberspark_manifest_var_t) list)
	(p_uobjrtl_manifest_var_hashtbl : ((string, Uberspark.Manifest.uberspark_manifest_var_t)  Hashtbl.t))
	(p_loader_manifest_var_hashtbl : ((string, Uberspark.Manifest.uberspark_manifest_var_t)  Hashtbl.t))
	(p_triage_dir_prefix : string )
	(p_staging_dir_prefix : string )
	: bool =

	let l_uobjcoll_actions_list : Uberspark.Manifest.json_node_uberspark_manifest_actions_t list ref = ref [] in 

	let l_add_default_uobjcoll_actions () : 
		Uberspark.Manifest.json_node_uberspark_manifest_actions_t list =
		let l_actions_list : Uberspark.Manifest.json_node_uberspark_manifest_actions_t list ref = ref [] in 

		(* add action element for each uobjrtl of category uobjrtl_action *)
		Hashtbl.iter (fun (l_uobjrtl_ns : string) (l_uobjrtl_manifest_var : Uberspark.Manifest.uberspark_manifest_var_t)  ->
		
			let l_uobjrtl_action = new_action_element () in
			
			l_uobjrtl_action.name <- "uobjrtl action";
			l_uobjrtl_action.category <- "uobjrtl_action";
			l_uobjrtl_action.uobjrtl_namespace <- l_uobjrtl_ns;
			
			l_actions_list := !l_actions_list @ [ l_uobjrtl_action; ];
		
		) g_uobjrtl_manifest_var_hashtbl;		

		(* add action element for each loader of category loader_action *)
		Hashtbl.iter (fun (l_loader_ns : string) (l_uobjrtl_manifest_var : Uberspark.Manifest.uberspark_manifest_var_t)  ->
		
			let l_loader_action = new_action_element () in
			
			l_loader_action.name <- "loader action";
			l_loader_action.category <- "loader_action";
			l_loader_action.loader_namespace <- l_loader_ns;
			
			l_actions_list := !l_actions_list @ [ l_loader_action; ];
		
		) g_loader_manifest_var_hashtbl;		



		(* add action element for each uobj of category uobj_action *)
		List.iter ( fun ( (l_uobj_ns:string), (l_uobj_manifest_var:Uberspark.Manifest.uberspark_manifest_var_t) ) -> 

			let l_uobj_action = new_action_element () in
			
			l_uobj_action.name <- "uobj action";
			l_uobj_action.category <- "uobj_action";
			l_uobj_action.uobj_namespace <- l_uobj_ns;
			
			l_actions_list := !l_actions_list @ [ l_uobj_action; ];

		) !g_uobj_manifest_var_assoc_list;

		(* add action elements for uobjcoll specific sources *)
		l_actions_list := !l_actions_list @ [

					{
						targets = [ "build"; ];
						name = "translating .c to .o";
						category = "translation";
						input = [ "*.c" ]; output = [ "*.o" ]; bridge_namespace = g_uberspark_platform_manifest_var.platform.bridges.cc_bridge_namespace; bridge_cmd = [];
						uobj_namespace = "";
						uobjrtl_namespace = "";
						loader_namespace = "";
					};

					{
						targets = [ "build"; ];
						name = "translating .cS to .o";
						category = "translation";
						input = [ "*.cS" ]; output = [ "*.o" ]; bridge_namespace = g_uberspark_platform_manifest_var.platform.bridges.casm_bridge_namespace; bridge_cmd = [];
						uobj_namespace = "";
						uobjrtl_namespace = "";
						loader_namespace = "";
					};

					{
						targets = [ "build"; ];
						name = "translating .s to .o";
						category = "translation";
						input = [ "*.s" ]; output = [ "*.o" ]; bridge_namespace = g_uberspark_platform_manifest_var.platform.bridges.as_bridge_namespace; bridge_cmd = [];
						uobj_namespace = "";
						uobjrtl_namespace = "";
						loader_namespace = "";
					};
		];

		(* add action element for final uobjcoll binary build *)
		let l_uobjcoll_action = new_action_element () in
		
		l_uobjcoll_action.targets <- ["build";];
		l_uobjcoll_action.name <- "uobjcoll binary build action";
		l_uobjcoll_action.category <- "translation";
		l_uobjcoll_action.input <- ["*.o";];
		l_uobjcoll_action.output <- [ "uobjcoll.flat";];
		l_uobjcoll_action.bridge_namespace <- g_uberspark_platform_manifest_var.platform.bridges.ld_bridge_namespace;
					
		l_actions_list := !l_actions_list @ [ l_uobjcoll_action; ];

		(!l_actions_list)
	in

	(* store triage and staging dir prefix *)
	g_triage_dir_prefix := p_triage_dir_prefix;
	g_staging_dir_prefix := p_staging_dir_prefix;

	(* store uberspark platform manifest var *)
	Uberspark.Manifest.uberspark_manifest_var_copy g_uberspark_platform_manifest_var p_uberspark_platform_manifest_var;

	(* if uobjrtl manifest actions is empty for any given uobjrtl, then add default actions *)
	(* Hashtbl.iter (fun x y -> Hashtbl.add g_uobjrtl_manifest_var_hashtbl x y; )p_uobjrtl_manifest_var_hashtbl;*)
	Hashtbl.iter (fun (l_uobjrtl_ns : string) (l_uobjrtl_manifest_var : Uberspark.Manifest.uberspark_manifest_var_t)  ->
		
		if List.length l_uobjrtl_manifest_var.manifest.actions == 0 then begin
		
			l_uobjrtl_manifest_var.manifest.actions <- [ g_default_action; ];
			Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "Added default action to uobjrtl: %s (%u)" 
				l_uobjrtl_manifest_var.uobjrtl.namespace (List.length l_uobjrtl_manifest_var.uobjrtl.sources); 
			
		end;

		Hashtbl.add g_uobjrtl_manifest_var_hashtbl l_uobjrtl_ns l_uobjrtl_manifest_var;

	) p_uobjrtl_manifest_var_hashtbl;


	(* if loader manifest actions is empty for any given loader, then emit error *)
	let l_rval = ref true in 
	Hashtbl.iter (fun (l_loader_ns : string) (l_loader_manifest_var : Uberspark.Manifest.uberspark_manifest_var_t)  ->
		if !l_rval then begin
			if List.length l_loader_manifest_var.manifest.actions == 0 then begin
			
				Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "No actions within loader: %s" 
					l_loader_manifest_var.loader.namespace ; 
				l_rval := false;

			end else begin
				Hashtbl.remove g_loader_manifest_var_hashtbl l_loader_ns;
				Hashtbl.add g_loader_manifest_var_hashtbl l_loader_ns l_loader_manifest_var;
			end;
		
		end;
	) p_loader_manifest_var_hashtbl;

	if !l_rval = false then
		(false)
	else

	let dummy=0 in begin

		(* if uobj manifest actions is empty for any given uobj, then add default actions *)
		List.iter ( fun ( (l_uobj_ns:string), (l_uobj_manifest_var:Uberspark.Manifest.uberspark_manifest_var_t) ) -> 
			
			if List.length l_uobj_manifest_var.manifest.actions == 0 then begin
				
				l_uobj_manifest_var.manifest.actions <- [ g_default_action; ];
				Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "Added default action to uobj: %s" 
					l_uobj_manifest_var.uobj.namespace; 
			
			end;

			g_uobj_manifest_var_assoc_list := !g_uobj_manifest_var_assoc_list @ [ (l_uobj_ns, l_uobj_manifest_var); ];

		) p_uobj_manifest_var_assoc_list;

		(* iterate through uobjcoll manifest actions, if empty, then add default actions *)
		(* expand any default_action category is non_empty *)
		Uberspark.Manifest.uberspark_manifest_var_copy g_uobjcoll_manifest_var p_uobjcoll_manifest_var;

		if List.length p_uobjcoll_manifest_var.manifest.actions == 0 then begin
			g_uobjcoll_manifest_var.manifest.actions <- l_add_default_uobjcoll_actions ();

			Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "Added default actions to uobjcoll: %s" 
				g_uobjcoll_manifest_var.uobjcoll.namespace; 

		end else begin

			List.iter ( fun (l_uobjcoll_action : Uberspark.Manifest.json_node_uberspark_manifest_actions_t) -> 

				if l_uobjcoll_action.category == "default_action" then begin
					l_uobjcoll_actions_list := !l_uobjcoll_actions_list @ (l_add_default_uobjcoll_actions ());
				end else begin
					l_uobjcoll_actions_list := !l_uobjcoll_actions_list @ [ l_uobjcoll_action; ];
				end;

			)p_uobjcoll_manifest_var.manifest.actions;

			g_uobjcoll_manifest_var.manifest.actions <- !l_uobjcoll_actions_list;

		end;
	end;


	(* consolidate all actions *)
	let rval = consolidate_actions () in

	if not rval then
		(false)
	else

	let dummy=0 in begin
		
		(* debug dump *)
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "uobjcoll (%s) total actions: %u" 
			g_uobjcoll_manifest_var.uobjcoll.namespace (List.length g_uobjcoll_manifest_var.manifest.actions);
		List.iter ( fun ( (l_uobj_ns:string), (l_uobj_manifest_var:Uberspark.Manifest.uberspark_manifest_var_t) ) -> 
			Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "uobj (%s) total actions: %u" 
				l_uobj_manifest_var.uobj.namespace (List.length l_uobj_manifest_var.manifest.actions);
		) !g_uobj_manifest_var_assoc_list;
		Hashtbl.iter (fun (l_uobjrtl_ns : string) (l_uobjrtl_manifest_var : Uberspark.Manifest.uberspark_manifest_var_t)  ->
			Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "uobjrtl (%s) total actions: %u" 
				l_uobjrtl_manifest_var.uobjrtl.namespace (List.length l_uobjrtl_manifest_var.manifest.actions);
		) g_uobjrtl_manifest_var_hashtbl;
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "triage dir prefix=%s" !g_triage_dir_prefix;
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "staging dir prefix=%s" !g_staging_dir_prefix;
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "consolidated actions: %u" (List.length !g_actions_list);

	end;


	(true)
;;


(*--------------------------------------------------------------------------*)
(* create and return a list of source files *)
(* given a manifest var and filename extension *)
(* if filter specified, it will filter only the files with specified filename extension *)
(* if replace specified, it will return all files with the extension replaced with *)
(* the filename extension *)
(*--------------------------------------------------------------------------*)
let get_sources_filename_list 
	(p_uberspark_manifest_var : Uberspark.Manifest.uberspark_manifest_var_t)
	(p_only_local_sources : bool)
(*)	(p_filename_ext : string) 
	(p_filename_ext_replace : bool)
*)
	: string list =

	let l_return_list : string list ref = ref [] in 
	(*Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "%s: p_filename_ext=%s" __LOC__ p_filename_ext;
	*)

	if p_uberspark_manifest_var.manifest.namespace = "uberspark/uobj" then begin
		
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "%s: processing for uberspark/uobj (total files=%u)..." 
			__LOC__ (List.length p_uberspark_manifest_var.uobj.sources);

		List.iter ( fun (l_filename : string) ->
			l_return_list := !l_return_list @ [ l_filename; ];
		) p_uberspark_manifest_var.uobj.sources;
		
	end else if p_uberspark_manifest_var.manifest.namespace = "uberspark/uobjrtl" then begin

		Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "%s: processing for uberspark/uobjrtl (total files=%u)..." 
			__LOC__ (List.length p_uberspark_manifest_var.uobjrtl.sources);

		List.iter ( fun (l_source_file : Uberspark.Manifest.Uobjrtl.json_node_uberspark_uobjrtl_modules_spec_t) -> 
			l_return_list := !l_return_list @ [ l_source_file.path; ];
		) p_uberspark_manifest_var.uobjrtl.sources;

	end else if p_uberspark_manifest_var.manifest.namespace = "uberspark/uobjcoll" then begin

		Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "%s: processing for uberspark/uobjcoll (total files=%u)..." 
			__LOC__ (List.length p_uberspark_manifest_var.uobjcoll.sources);

		List.iter ( fun (l_source_file : string) -> 
			if p_only_local_sources then begin
				if ((Str.string_match (Str.regexp_string (Uberspark.Namespace.namespace_root ^ "/" )) l_source_file 0) = false) then begin
					l_return_list := !l_return_list @ [ l_source_file; ];
				end;
			end else begin
				if ((Str.string_match (Str.regexp_string (Uberspark.Namespace.namespace_root ^ "/" )) l_source_file 0) = false) then begin
					l_return_list := !l_return_list @ [ p_uberspark_manifest_var.uobjcoll.namespace ^ "/" ^ l_source_file ];
				end else begin
					l_return_list := !l_return_list @ [ l_source_file ];
				end;		
			end;
			
			(*if p_filename_ext_replace then begin	
				if p_filename_ext = ".o" && 
					((Str.string_match (Str.regexp_string (Uberspark.Namespace.namespace_root ^ "/" )) l_source_file 0) = false) then begin
					l_return_list := !l_return_list @ [ p_uberspark_manifest_var.uobjcoll.namespace ^ "/" ^ ((Filename.remove_extension l_source_file) ^ p_filename_ext) ; ];
				end else begin
					l_return_list := !l_return_list @ [ ((Filename.remove_extension l_source_file) ^ p_filename_ext) ; ];
				end;		
			end else begin
				(* return only uobjcoll sources, not uobjrtl or uobj *)
				if ((Filename.extension l_source_file) = p_filename_ext) && 
				   ((Str.string_match (Str.regexp_string (Uberspark.Namespace.namespace_root ^ "/" )) l_source_file 0) = false) then begin
					l_return_list := !l_return_list @ [ l_source_file; ];
				end;
			end;*)
		) p_uberspark_manifest_var.uobjcoll.sources;


	end else begin

		Uberspark.Logger.log ~lvl:Uberspark.Logger.Warn "%s: unknown manifest namespace=%s" __LOC__ p_uberspark_manifest_var.manifest.namespace; 
		l_return_list := [];

	end;

	Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "%s: len(l_return_list)=%u" 
		__LOC__ (List.length !l_return_list);

	(!l_return_list)
;;


(*--------------------------------------------------------------------------*)
(* given an action with input list, produce the list of input file names *)
(*--------------------------------------------------------------------------*)
(* return value, return list, boolean wildcard/nowildcard, sorted list of input extensions *)
let get_action_input_filename_list 
	(p_uberspark_action : uberspark_action_t )
	: bool * string list * bool * string list =

	let l_retval = ref true in
	let l_input_list : string list ref = ref [] in 
	let l_input_has_wildcard = ref false in 
	let l_input_ext_list : string list ref = ref [] in 

	let l_input_ext_hashtbl = ((Hashtbl.create 32) : ((string, string)  Hashtbl.t)) in

	(* check if the string begins with wildcard characters *)
	let l_wildcard_check (p_str : string ) : bool =
		if (Filename.remove_extension p_str) = "*" then begin
			(true)
		end else begin
			(false)
		end
	in

	(* input can be wilcard; .c, .cS, .o *)
	(* input will temporarily also allow .s *)
	(* input can be a list of files without wildcard *)

	(* check if we have a wildcard in the action input list *)
	if (List.exists l_wildcard_check p_uberspark_action.uberspark_manifest_action.input) then begin
		l_input_has_wildcard := true;

		if List.length p_uberspark_action.uberspark_manifest_action.input = 1 then begin
			let l_input_wildcard_ext = (Filename.extension (List.nth p_uberspark_action.uberspark_manifest_action.input 0)) in   			

			(* special handling for input *.o *)
			if l_input_wildcard_ext = ".o" then begin
				let l_l_input_list : string list ref = ref [] in
				l_l_input_list := get_sources_filename_list p_uberspark_action.uberspark_manifest_var false;
				Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "%s: len(l_l_input_list)=%u" 
					__LOC__ (List.length !l_l_input_list);
				l_l_input_list := Uberspark.Utils.filename_list_substitute_extension !l_l_input_list l_input_wildcard_ext;
				Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "%s: len(l_l_input_list)=%u" 
					__LOC__ (List.length !l_l_input_list);
			

				List.iter ( fun (l_filename : string) ->
					(* if bridge namespace is not null *)
					if p_uberspark_action.uberspark_manifest_action.bridge_namespace <> "" then begin

						(* and bridge namespace points to a container bridge then we add container mount point prefix *)
						if (Str.string_match (Str.regexp_string (Uberspark.Namespace.namespace_root ^ "/" ^ 
							Uberspark.Namespace.namespace_bridge ^ "/")) p_uberspark_action.uberspark_manifest_action.bridge_namespace 0) then begin
							l_input_list := !l_input_list @ [ Uberspark.Namespace.namespace_bridge_container_mountpoint ^ "/" ^ l_filename];
						
						end else begin
						(* else we add triage dir prefix *)
							l_input_list := !l_input_list @ [ !g_triage_dir_prefix ^ "/" ^ l_filename];
						end;
					end;
			
				) !l_l_input_list;

				Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "%s: len(l_input_list)=%u" 
					__LOC__ (List.length !l_input_list);


			end else begin
				l_input_list := get_sources_filename_list p_uberspark_action.uberspark_manifest_var true;
				l_input_list := Uberspark.Utils.filename_list_filter_by_extension !l_input_list l_input_wildcard_ext;
			end;

			l_input_ext_list := !l_input_ext_list @ [ l_input_wildcard_ext; ];

		end else begin
			Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "%s: action input is a wildcard but has more than 1 element!" __LOC__; 
			l_retval := false;
		end;
		

	end else begin
		(* no wildcard in the action input list, so copy over the list while storing unique extensions *)
		l_input_has_wildcard := false;

		List.iter ( fun (l_filename : string) ->
			l_input_list := !l_input_list @ [ l_filename; ];
			Hashtbl.remove l_input_ext_hashtbl (Filename.extension l_filename); 
			Hashtbl.add l_input_ext_hashtbl (Filename.extension l_filename) "";
		)p_uberspark_action.uberspark_manifest_action.input;

		(* generate sorted list of input extensions *)
		Hashtbl.iter ( fun (l_filename_ext : string) (l_dummy : string) -> 
			l_input_ext_list := !l_input_ext_list @ [ l_filename_ext; ];
		) l_input_ext_hashtbl;

		l_input_ext_list := List.sort compare !l_input_ext_list;

	end;

	(!l_retval, !l_input_list, !l_input_has_wildcard, !l_input_ext_list)
;;



(*--------------------------------------------------------------------------*)
(* given an action and input filename list, produce the list of output file names *)
(*--------------------------------------------------------------------------*)
(* return value, return list, boolean wildcard/nowildcard, sorted list of output extensions *)
let get_action_output_filename_list 
	(p_uberspark_action : uberspark_action_t )
	(p_input_filename_list : string list)
	: bool * string list * bool * string list =

	let l_retval = ref true in
	let l_output_list : string list ref = ref [] in 
	let l_output_has_wildcard = ref false in 
	let l_output_ext_list : string list ref = ref [] in 

	let l_output_ext_hashtbl = ((Hashtbl.create 32) : ((string, string)  Hashtbl.t)) in

	(* check if the string begins with wildcard characters *)
	let l_wildcard_check (p_str : string ) : bool =
		if (Filename.remove_extension p_str) = "*" then begin
			(true)
		end else begin
			(false)
		end
	
	in

	(* output can be wilcard; .o, .cSs *)
	(* output can be a list of files without wildcard *)

	(* check if we have a wildcard in the action output list *)
	if (List.exists l_wildcard_check p_uberspark_action.uberspark_manifest_action.output) then begin
		l_output_has_wildcard := true;

		if List.length p_uberspark_action.uberspark_manifest_action.output = 1 then begin
			let l_output_wildcard_ext = (Filename.extension (List.nth p_uberspark_action.uberspark_manifest_action.output 0)) in   			

			List.iter (fun (l_filename: string) ->
				l_output_list := !l_output_list @
					[ ((Filename.remove_extension l_filename) ^ l_output_wildcard_ext); ];
			)p_input_filename_list;

			l_output_ext_list := !l_output_ext_list @ [ l_output_wildcard_ext; ];

		end else begin
			Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "%s: action output is a wildcard but has more than 1 element!" __LOC__; 
			l_retval := false;
		end;
		

	end else begin
		(* no wildcard in the action output list, so copy over the list while storing unique extensions *)
		l_output_has_wildcard := false;

		List.iter ( fun (l_filename : string) ->
			l_output_list := !l_output_list @ [ l_filename; ];
			Hashtbl.remove l_output_ext_hashtbl (Filename.extension l_filename); 
			Hashtbl.add l_output_ext_hashtbl (Filename.extension l_filename) "";
		)p_uberspark_action.uberspark_manifest_action.output;

		(* generate sorted list of output extensions *)
		Hashtbl.iter ( fun (l_filename_ext : string) (l_dummy : string) -> 
			l_output_ext_list := !l_output_ext_list @ [ l_filename_ext; ];
		) l_output_ext_hashtbl;

		l_output_ext_list := List.sort compare !l_output_ext_list;

	end;

	(!l_retval, !l_output_list, !l_output_has_wildcard, !l_output_ext_list)
;;



(*--------------------------------------------------------------------------*)
(* build input and output lists for actions processing *)
(*--------------------------------------------------------------------------*)
(*
	return value is:
	bool (true or false)
	l_input_file_list, l_output_file_list, 
	l_input_has_wildcard, l_output_has_wildcard,
	l_input_ext_list, l_output_ext_list
*)
let get_action_input_output_filename_lists
	(p_action : uberspark_action_t)
	: bool * string list * string list * bool * bool * string list * string list =

	Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "> building input file list for action...";
	let (l_rval_input, l_input_file_list, 
		l_input_has_wildcard, l_input_ext_list) = 
		get_action_input_filename_list p_action in

	Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug 
		"> l_rval_input=%b, len(l_input_file_list)=%u, l_input_has_wildcard=%b len(l_input_ext_list)=%u"
		l_rval_input (List.length l_input_file_list) l_input_has_wildcard
		(List.length l_input_ext_list);

	if l_rval_input then begin
		
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "> building ouput file list for action...";
		let (l_rval_output, l_output_file_list, 
			l_output_has_wildcard, l_output_ext_list) = 
			get_action_output_filename_list p_action l_input_file_list in

		Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug 
			"> l_rval_output=%b, len(l_output_file_list)=%u, l_output_has_wildcard=%b len(l_output_ext_list)=%u"
			l_rval_output (List.length l_output_file_list) l_output_has_wildcard
			(List.length l_output_ext_list);

		if(l_rval_output) then begin

			Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "> successfully built input and output file list for action";
			(true, l_input_file_list, l_output_file_list, l_input_has_wildcard, l_output_has_wildcard, l_input_ext_list, l_output_ext_list)

		end else begin
			Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "unable to build output file list for action!";
			(false, [], [], false, false, [], [])
		end;


	end else begin
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "unable to build input file list for action!";
		(false, [], [], false, false, [], [])
	end;

;;


(*--------------------------------------------------------------------------*)
(* return a list of auxillary source files for uobj verification *)
(* includes all uobjrtl sources and basic uobjcoll sources *)
(*--------------------------------------------------------------------------*)
let get_uobj_verification_aux_sources
	() : string list =

	let l_uobjcoll_list : string list ref = ref [] in 
	let l_uobjrtl_list : string list ref = ref [] in 
	let l_return_list : string list ref = ref [] in 

	(* grab the uobjcoll sources first *)
	l_uobjcoll_list := (get_sources_filename_list g_uobjcoll_manifest_var true);
	l_uobjcoll_list := Uberspark.Utils.filename_list_append_path_prefix
						!l_uobjcoll_list (g_uobjcoll_manifest_var.uobjcoll.namespace ^ "/");

	l_return_list := !l_return_list @ !l_uobjcoll_list;

	Hashtbl.iter (fun (l_uobjrtl_ns : string) (l_uobjrtl_manifest_var : Uberspark.Manifest.uberspark_manifest_var_t)  ->
		l_uobjrtl_list := [];
		l_uobjrtl_list := (get_sources_filename_list l_uobjrtl_manifest_var true);
		l_uobjrtl_list := Uberspark.Utils.filename_list_append_path_prefix
						!l_uobjrtl_list (l_uobjrtl_ns ^ "/");
	
		l_return_list := !l_return_list @ !l_uobjrtl_list;

	)g_uobjrtl_manifest_var_hashtbl;


	Uberspark.Utils.filename_list_append_path_prefix
						!l_return_list (!g_triage_dir_prefix ^ "/");

	Uberspark.Utils.filename_list_substitute_extension
						!l_return_list ".c";

	(!l_return_list)		
;;




(*--------------------------------------------------------------------------*)
(* invoke bridge *)
(*--------------------------------------------------------------------------*)
let invoke_bridge
	(p_action : uberspark_action_t)
	(p_input_file_list : string list )
	(p_output_file_list : string list )
	(p_input_file_ext_list : string list)
	(p_output_file_ext_list : string list)
	: bool =

	let l_retval = ref true in

	Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "> invoke_bridge: start...";
	Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "> p_input_fle_list: ";
	List.iter ( fun x -> Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug ">  %s" x;) p_input_file_list;
	Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "> p_output_fle_list: ";
	List.iter ( fun x -> Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug ">  %s" x;) p_output_file_list;
	Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "> p_input_file_ext_list: ";
	List.iter ( fun x -> Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug ">  %s" x;) p_input_file_ext_list;
	Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "> p_output_file_ext_list: ";
	List.iter ( fun x -> Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug ">  %s" x;) p_output_file_ext_list;
	Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "> action.bridge_namespace=%s: "
		p_action.uberspark_manifest_action.bridge_namespace;

	if p_action.uberspark_manifest_action.bridge_namespace <> "" &&
		 Hashtbl.mem g_bridge_hashtbl  p_action.uberspark_manifest_action.bridge_namespace = true then begin

		let l_bridge_object = Hashtbl.find g_bridge_hashtbl  p_action.uberspark_manifest_action.bridge_namespace in
		let l_build_dir = ref "" in
		let l_bridge_cmd : string list ref = ref [] in

		if p_action.uberspark_manifest_var.manifest.namespace = "uberspark/uobjcoll" then begin
			l_build_dir := p_action.uberspark_manifest_var.uobjcoll.namespace;
		end else if p_action.uberspark_manifest_var.manifest.namespace = "uberspark/uobj" then begin
			l_build_dir := p_action.uberspark_manifest_var.uobj.namespace;
		end else if p_action.uberspark_manifest_var.manifest.namespace = "uberspark/uobjrtl" then begin
			l_build_dir := p_action.uberspark_manifest_var.uobjrtl.namespace;
		end else if p_action.uberspark_manifest_var.manifest.namespace = "uberspark/loaders" then begin
			l_build_dir := p_action.uberspark_manifest_var.loader.namespace;
			l_bridge_cmd := p_action.uberspark_manifest_action.bridge_cmd;
		end else begin
			Uberspark.Logger.log ~lvl:Uberspark.Logger.Warn "> unknown manifest namespace=%s"
				p_action.uberspark_manifest_var.manifest.namespace;
		end;

		Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "> l_build_dir=%s" !l_build_dir;
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "> l_bridge_object category=%s" (l_bridge_object#get_json_node_uberspark_bridge_var).category ;
		
		let l_bridge_defs_list : string list ref = ref [] in
		let l_is_assembly_ext (p_ext : string ) : bool =
			if (p_ext = ".s") || (p_ext = ".S") then begin
				(true)
			end else begin
				(false)
			end
		in

		if (List.exists l_is_assembly_ext p_input_file_ext_list) then begin
			l_bridge_defs_list := [ "__ASSEMBLY__"; ];
		end;


		(* TBD: match bridge extension with input and output ext lists *)
		l_retval := l_bridge_object#invoke 
					~context_path_builddir:!l_build_dir 
				[
					("@@BRIDGE_LOG_LEVEL@@", (Printf.sprintf "%u" !Uberspark.Logger.current_level));
					("@@BRIDGE_UBERSPARK_ROOT_DIR_PREFIX@@", (Uberspark.Namespace.get_namespace_root_dir_prefix ()));
					("@@BRIDGE_UBERSPARK_STAGING_DIR_PREFIX@@", !g_staging_dir_prefix);
					("@@BRIDGE_CMD@@", (Uberspark.Bridge.bridge_parameter_to_string ~prefix:" && " !l_bridge_cmd));
					("@@BRIDGE_INPUT_FILES@@", (Uberspark.Bridge.bridge_parameter_to_string p_input_file_list));
					("@@BRIDGE_SOURCE_FILES@@", (Uberspark.Bridge.bridge_parameter_to_string p_input_file_list));
					("@@BRIDGE_INCLUDE_DIRS@@", (Uberspark.Bridge.bridge_parameter_to_string [ "."; !g_triage_dir_prefix; Uberspark.Namespace.namespace_bridge_container_mountpoint; !g_staging_dir_prefix; ]));
					("@@BRIDGE_INCLUDE_DIRS_WITH_PREFIX@@", (Uberspark.Bridge.bridge_parameter_to_string ~prefix:"-I " [ "."; !g_triage_dir_prefix; Uberspark.Namespace.namespace_bridge_container_mountpoint; !g_staging_dir_prefix; ]));
					("@@BRIDGE_COMPILEDEFS@@", (Uberspark.Bridge.bridge_parameter_to_string !l_bridge_defs_list));
					("@@BRIDGE_COMPILEDEFS_WITH_PREFIX@@", (Uberspark.Bridge.bridge_parameter_to_string ~prefix:"-D " !l_bridge_defs_list));
					("@@BRIDGE_DEFS@@", (Uberspark.Bridge.bridge_parameter_to_string !l_bridge_defs_list));
					("@@BRIDGE_DEFS_WITH_PREFIX@@", (Uberspark.Bridge.bridge_parameter_to_string ~prefix:"-D " !l_bridge_defs_list));
					("@@BRIDGE_PLUGIN_DIR@@", ((Uberspark.Namespace.get_namespace_root_dir_prefix ()) ^ "/" ^
					Uberspark.Namespace.namespace_root ^ "/" ^ Uberspark.Namespace.namespace_root_vf_bridge_plugin));
					("@@BRIDGE_CONTAINER_MOUNT_POINT@@", Uberspark.Namespace.namespace_bridge_container_mountpoint);
					("@@BRIDGE_LSCRIPT_FILENAME@@",	Uberspark.Namespace.namespace_uobjcoll_linkerscript_filename);
					("@@BRIDGE_BINARY_FILENAME@@", Uberspark.Namespace.namespace_uobjcoll_binary_image_filename);
					("@@BRIDGE_BINARY_FLAT_FILENAME@@", Uberspark.Namespace.namespace_uobjcoll_binary_flat_image_filename);
					("@@BRIDGE_CCLIB_FILENAME@@", (Uberspark.Namespace.namespace_bridge_container_mountpoint ^ "/" ^ Uberspark.Namespace.namespace_uobj_cclib_filename));
				];


	end else begin
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "unable to find entry in bridge hashtbl for bridge_namespace=%s!"
			p_action.uberspark_manifest_action.bridge_namespace;
		l_retval := false;
	end;



	Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "> invoke_bridge: end(l_retval=%b)..." !l_retval;
	(!l_retval)
;;


(*--------------------------------------------------------------------------*)
(* initialize action bridges *)
(*--------------------------------------------------------------------------*)
let initialize_bridges ()
	: bool =

	let l_retval = ref true in

	(* iterate over global action list and build hashtbl of unique bridge namespace to bridge object
	mapping
	*)
	List.iter ( fun (l_action : uberspark_action_t) -> 
	
		if !l_retval then begin
	
			(* process bridge only if its non-empty and not previously in the hashtbl *)
			if (l_action.uberspark_manifest_action.bridge_namespace <> "" && 
				Hashtbl.mem g_bridge_hashtbl l_action.uberspark_manifest_action.bridge_namespace = false) then begin

				Uberspark.Logger.log ~lvl:Uberspark.Logger.Info "initializing bridge: %s ..." 
					l_action.uberspark_manifest_action.bridge_namespace;

				let l_bridge_object : Uberspark.Bridge.bridge_object = new Uberspark.Bridge.bridge_object in
				let l_rval = (l_bridge_object#load l_action.uberspark_manifest_action.bridge_namespace) in
				
				if l_rval then begin

					(* if bridge cateogory is container, then build the bridge *)
					if (l_bridge_object#get_json_node_uberspark_bridge_var).category = "container" then begin
						if not (l_bridge_object#build ()) then begin
							Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "unable to build bridge container!";
							l_retval := false;
						end else begin
							Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "successfully built bridge container!";
						end;
					end;

					if !l_retval then begin

						Uberspark.Logger.log ~lvl:Uberspark.Logger.Info "Bridge initialized successfully";
						Hashtbl.add g_bridge_hashtbl l_action.uberspark_manifest_action.bridge_namespace l_bridge_object;

					end else begin

						Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "%s: could not initialize bridge!" __LOC__ ;

					end;


				end else begin
					Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "%s: could not initialize bridge!" __LOC__;
					l_retval := false; 
				end;

			
			end else begin
				(* bridge namespace is empty ot already in hashtbl, so just print a debug message and skip *)
				Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "bridge_namespace=%s empty or already processed, skipping" 
					l_action.uberspark_manifest_action.bridge_namespace;
			end;


		end; (* !l_retval *)

	) !g_actions_list;

	(!l_retval)
;;


(*--------------------------------------------------------------------------*)
(* process actions per the action category *)
(*--------------------------------------------------------------------------*)
let process_actions_category 
	(p_action : uberspark_action_t)	
	: bool =
	let l_retval = ref true in 

	Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "> manifest.namespace=%s" p_action.uberspark_manifest_var.manifest.namespace;

	if p_action.uberspark_manifest_action.category = "translation" then begin
	
		let (l_rval, l_input_file_list,	l_output_file_list, 
			l_input_has_wildcard, l_output_has_wildcard,
			l_input_ext_list, l_output_ext_list) = 
			get_action_input_output_filename_lists p_action in

		if l_rval then begin
			
			let l_rval_bridge = invoke_bridge p_action
				l_input_file_list l_output_file_list
				l_input_ext_list l_output_ext_list in

			if l_rval_bridge then begin
				l_retval := true;
			end else begin
				Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "error in invoking action bridge!";
				l_retval := false;
			end;

		end else begin
			Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "unable to build input and/or output file list for action!";
			l_retval := false;
		end;

	end else if p_action.uberspark_manifest_action.category = "bridge_exec" then begin
	
			let l_rval_bridge = invoke_bridge p_action
				[] []
				[] [] in

			if l_rval_bridge then begin
				l_retval := true;
			end else begin
				Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "error in invoking action bridge!";
				l_retval := false;
			end;

	end else begin
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "%s: unknown action category=%s!" __LOC__ p_action.uberspark_manifest_action.category ;
		l_retval := false;
	end;

	(!l_retval)
;;


(*--------------------------------------------------------------------------*)
(* process actions *)
(*--------------------------------------------------------------------------*)
(*
	each action has a target spec; i.e., the target for which this
	action will be executed

	single input target: build, verify, docs, install
	we see if input target is present in the list of targets for
	the action; then execute

	now if uberspark is executed as is then we have two options:
		1. execute in the order specified of actions
		2. execute in preferred pipeline order 
			(verify, build, docs, install); in this case we execute
			common target only once

	logic:
	if in_order then
		List.iter actions
			execute action based on the category
	else	
	List.iter p_targets
		List.iter actions
		if element in action target or action target
			or category is common && exec_common = false
			
			execute action based on the category
		
		if exec_commmon = false
			exec_common = true
	
*)

let process_actions 
	?(p_in_order = true) 
	(p_targets: string list)
	: bool =
	let retval = ref true in 

	let l_current_action_index = ref 1 in
	Uberspark.Logger.log ~lvl:Uberspark.Logger.Info "Processing actions...(total=%u; p_in_order=%b)" 
		(List.length !g_actions_list) p_in_order;
	Uberspark.Logger.log ~lvl:Uberspark.Logger.Info "Initializing action bridges...";

	(* initialize uobjcoll bridges *)
	let rval = initialize_bridges () in	
    if (rval == false) then	begin
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "unable to initialize uobj collection bridges!";
		(false)
	end else

	let dummy=0 in begin
	Uberspark.Logger.log ~lvl:Uberspark.Logger.Info "successfully initialized action bridges";
	end;

	let dummy=0 in begin
	if p_in_order then begin

		(* we process all actions in order of where they are defined in the manifests *)
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Info "Processing all actions in manifest order...";

		(* iterate over global action list *)
		List.iter ( fun (l_action : uberspark_action_t) -> 
			if !retval then begin

				Uberspark.Logger.log ~lvl:Uberspark.Logger.Info "Processing action [%u/%u]..." !l_current_action_index (List.length !g_actions_list);

				retval := process_actions_category l_action;

				if !retval then begin
					Uberspark.Logger.log ~lvl:Uberspark.Logger.Info "Action processed successfully";
					l_current_action_index := !l_current_action_index + 1;
				end else begin
					Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "Could not process action!";
				end;

			end;
		) !g_actions_list;

	end else begin

		(* we process all actions by target as listed in p_targets *)
		List.iter ( fun (l_target : string) -> 

			Uberspark.Logger.log ~lvl:Uberspark.Logger.Info "Processing actions for target: %s..." l_target;

			(* iterate over global action list *)
			List.iter ( fun (l_action : uberspark_action_t) -> 
				if !retval then begin

					if (Uberspark.Utils.string_list_exists_string l_action.uberspark_manifest_action.targets l_target) then begin

						Uberspark.Logger.log ~lvl:Uberspark.Logger.Info "Processing action [%u/%u]..." !l_current_action_index (List.length !g_actions_list);

						retval := process_actions_category l_action;

						if !retval then begin
							Uberspark.Logger.log ~lvl:Uberspark.Logger.Info "Action processed successfully";
							l_current_action_index := !l_current_action_index + 1;
						end else begin
							Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "Could not process action!";
						end;

					end else begin
						Uberspark.Logger.log ~lvl:Uberspark.Logger.Info "Skipping action [%u/%u]..." !l_current_action_index (List.length !g_actions_list);
						l_current_action_index := !l_current_action_index + 1;
					end;
				end;

			) !g_actions_list;


		) p_targets;

	end;
	end;

	(!retval)
;;



