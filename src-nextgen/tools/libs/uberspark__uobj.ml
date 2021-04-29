(*===========================================================================*)
(*===========================================================================*)
(*
	uberSpark uberobject module implementation 	             	 
	
	implements the following: 
	1.	uobject class which allows instantiation of objects
	that allow access to uobject manifest variables, 
	methods, source files, and actions

	2. public interface to add and query uobj objects, this
	allows us to use Uberspark.Uobj.find_uobj_for_ns and
	Uberspark.Uobj.add_uobj and maintain global hashtable of
	various uobjs for a given collection

	author: amit vasudevan (amitvasudevan@acm.org)							 
*)
(*===========================================================================*)
(*===========================================================================*)


(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* type definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)


(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* class definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
class uobject = object(self)


	(*---------------------------------------------------------------------------*)
	(* class public variable definitions *)
	(*---------------------------------------------------------------------------*)
  
	(* uobject namespace *)
	val o_namespace = ref "";





	(*---------------------------------------------------------------------------*)
	(* class public method definitions *)
	(*---------------------------------------------------------------------------*)

	(* initialize *)
	method initialize	
		?(builddir = ".")
		(uobj_mf_filename : string)
		(target_def: Uberspark.Defs.Basedefs.target_def_t)
		(uobj_load_address : int)
		: bool = 
	

		(true)	
	;



end;;



(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* variable definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)



(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* interface definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)




		


(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* class definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)





(*===========================================================================*)
(*===========================================================================*)


(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* stand-alone interfaces that are invoked for one-short create, initialize *)
(* and perform specific operation (compile, verify, build) *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)


(* create and initialize a uobj and return uobj object if successful *)
(*
let create_initialize
	(uobj_mf_filename : string)
	(uobj_target_def : Uberspark.Defs.Basedefs.target_def_t)
	(uobj_load_address : int)
	: bool * uobject option =

	(* create uobj instance and initialize *)
	let uobj:uobject = new uobject in
	let rval = (uobj#initialize ~builddir:Uberspark.Namespace.namespace_uobj_build_dir 
		uobj_mf_filename uobj_target_def uobj_load_address) in	
    if (rval == false) then	begin
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "unable to initialize uobj!";
		(false, None)
	end else

	(* prepare uobj sources *)
	let dummy = 0 in begin
	Uberspark.Logger.log "initialized uobj";
	uobj#prepare_sources ();
	Uberspark.Logger.log "prepped uobj sources";
	end;

	(* prepare uobj namespace *)
	let rval = (uobj#prepare_namespace_for_build ()) in	
    if (rval == false) then	begin
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "unable to prepare uobj namespace!";
		(false, None)
	end else

	let dummy = 0 in begin
	Uberspark.Logger.log "prepped uobj namespace";
	end;

	(* initialize bridges *)
	let l_rval = ref true in 
	let dummy = 0 in begin

	(* if uobj manifest specified config-settings node, re-initialize bridges to be sure 
	 we get uobj specific bridges if specified *)
	if (uobj#overlay_config_settings ()) then begin
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "initializing bridges with uobj manifest override...";
		if not (Uberspark.Bridge.initialize_from_config ()) then begin
			l_rval := false;
		end;
	end else begin
		(* uobj manifest did not have any config-settings specified *)
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "initializing bridges with default config settings...";
		if not (Uberspark.Bridge.initialize_from_config ()) then begin
			l_rval := false;
		end;
	end;
	end;

    if (!l_rval == false) then	begin
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "could not initialize bridges!";
		(false, None)
	end else

	(true, Some uobj)
;;
*)

(*
let create_initialize_and_build
	(uobj_mf_filename : string)
	(uobj_target_def : Uberspark.Defs.Basedefs.target_def_t)
	(uobj_load_address : int)
	: bool * uobject option =

	(* create uobj instance and initialize *)
    let (rval, uobjopt) = (create_initialize 
		uobj_mf_filename uobj_target_def uobj_load_address) in
    if (rval == false) then begin
		(false, None)
	end else

	match uobjopt with 
	| None ->
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "invalid uobj instance!";
		(false, None)

	| Some uobj ->

	(* build uobj binary image *)
	let rval = (uobj#build_image ()) in	
    if (rval == false) then	begin
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "unable to build uobj binary image!";
		(false, None)
	end else

	let dummy = 0 in begin
	Uberspark.Logger.log "generated uobj binary image";
	end;

	(true, Some uobj)
;;
*)

(*
let create_initialize_and_verify
	(uobj_mf_filename : string)
	(uobj_target_def : Uberspark.Defs.Basedefs.target_def_t)
	(uobj_load_address : int)
	: bool * uobject option =

	(* create uobj instance and initialize *)
    let (rval, uobjopt) = (create_initialize 
		uobj_mf_filename uobj_target_def uobj_load_address) in
    if (rval == false) then begin
		(false, None)
	end else

	match uobjopt with 
	| None ->
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "invalid uobj instance!";
		(false, None)

	| Some uobj ->

	(* verify uobj binary image *)
	let rval = (uobj#verify ()) in	
    if (rval == false) then	begin
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "unable to verify uobj!";
		(false, None)
	end else

	let dummy = 0 in begin
	Uberspark.Logger.log "uobj verification successful.";
	end;

	(true, Some uobj)
;;
*)



(*--------------------------------------------------------------------------*)
(* FOR FUTURE EXPANSION *)
(*--------------------------------------------------------------------------*)

(*

	(* get uobj manifest json nodes *)
	let rval = (Uberspark.Manifest.Uobj.get_uobj_mf_json_nodes mf_json d_uobj_mf_json_nodes) in

	if (rval == false) then (false)
	else

	(* debug *)
	(*let dummy = 0 in begin
	Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "mf_json=%s" (Uberspark.Manifest.json_node_pretty_print_to_string mf_json);
	let (rval, new_json) = Uberspark.Manifest.json_node_update "namespace" (Yojson.Basic.from_string "\"uberspark/uobjs/wohoo\"") (Yojson.Basic.Util.member "uobj-hdr" mf_json) in
	Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "mf_json=%s" (Uberspark.Manifest.json_node_pretty_print_to_string new_json);
	d_uobj_mf_json_nodes.f_uobj_hdr <- new_json;
	self#write_manifest "auto_test.json";		
	end;*)



	val d_uobj_mf_json_nodes : Uberspark.Manifest.Uobj.uobj_mf_json_nodes_t = {
		f_uberspark_hdr = `Null;
		f_uobj_hdr = `Null;
		f_uobj_sources = `Null;
		f_uobj_public_methods = `Null;
		f_uobj_intrauobjcoll_callees = `Null;
		f_uobj_interuobjcoll_callees = `Null;
		f_uobj_legacy_callees = `Null;
		f_uobj_binary = `Null;
	};


	(*--------------------------------------------------------------------------*)
	(* write uobj manifest *)
	(* uobj_mf_filename = uobj manifest filename *)
	(*--------------------------------------------------------------------------*)
	method write_manifest 
		(uobj_mf_filename : string)
		: bool =

		let oc = open_out uobj_mf_filename in
		Uberspark.Manifest.Uobj.write_uobj_mf_json_nodes d_uobj_mf_json_nodes oc;
		close_out oc;	

		(true)
	;
*)