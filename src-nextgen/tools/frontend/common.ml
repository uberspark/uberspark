(* uberspark front-end common initialization *)
(* author: amit vasudevan (amitvasudevan@acm.org) *)

open Uberspark
open Cmdliner


(* manifest variable *)
let d_uberspark_manifest_var : Uberspark.Manifest.uberspark_manifest_var_t = Uberspark.Manifest.uberspark_manifest_var_default_value ();;


(*
  initiaizes console logging 
*)
let initialize_logging 
  (p_copts : Commonopts.opts) : unit = 

  (* setup logging level as specified in the options *)
  Uberspark.Logger.current_level := p_copts.log_level;

;;

(*
  returns (l_cwd_abs, l_manifest_file_path_abs, is_error)
  (<cwd_abs>, <manifest file path abs>, false) => manifest present and no error
  (<cwd_abs>, "", false) => manifest not present and no error
  ("", "", true) => manifest not present and error
*)
let check_for_manifest 
  (copts : Commonopts.opts) : (string * string * bool) = 
  
  Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "check_for_manifest...";

  (* get current working directory *)
  let l_cwd = Uberspark.Osservices.getcurdir() in

  (* get the absolute path of the current working directory *)
  let (rval, l_cwd_abs) = (Uberspark.Osservices.abspath l_cwd) in

  (* bail out on error *)
  if (rval == false) then
    (*Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "check_for_manifest: could not get absolute path of current working directory!";*)
    ("", "", true)
  else

  (* announce working directory *)
  let l_dummy=0 in begin
  Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "check_for_manifest: current working directory: %s" l_cwd_abs;
  end;

  (* check if manifest exists within current working directory *)
  let l_manifest_file_path_abs = (l_cwd_abs ^ "/" ^ Uberspark.Namespace.namespace_root_mf_filename) in
  let rval = (Uberspark.Osservices.file_exists l_manifest_file_path_abs) in

  (* if not, display cli help and exit *)
  if (rval == false) then
    (l_cwd_abs, "", false)
  else

  (* announce absolute path of manifest filename *)
  let l_dummy=0 in begin
  Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "check_for_manifest: using manifest: %s" l_manifest_file_path_abs;
  end;

  (l_cwd_abs, l_manifest_file_path_abs, false)
;;


let create_staging
	?(p_in_order = true) 
	(abspath_cwd : string)
	(abspath_mf_filename : string)
	(p_targets : string list)
	: bool =

	Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "processing uobjcoll manifest...";

	(* read manifest file into manifest variable *)
	let rval = Uberspark.Manifest.manifest_file_to_uberspark_manifest_var abspath_mf_filename d_uberspark_manifest_var in

	(* bail out on error *)
  	if (rval == false) then
    	(false)
  	else

	let l_dummy=0 in begin
	Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "read manifest file into JSON object";
	end;


	(* sanity check we are an uobjcoll manifest and bail out on error*)
	if (d_uberspark_manifest_var.manifest.namespace <> Uberspark.Namespace.namespace_uobjcoll_mf_node_type_tag) then
		(false)
	else

	(* create triage folder *)
	let dummy = 0 in begin
	Uberspark.Osservices.mkdir ~parent:true Uberspark.Namespace.namespace_uobjcoll_staging_dir (`Octal 0o0777);
	end;

	(* create uobjcoll namespace folder within triage *)
	(* TBD: sanity check uobjcoll namespace prefix *)
	let l_abspath_uobjcoll_triage_dir = (abspath_cwd ^ "/" ^ Uberspark.Namespace.namespace_uobjcoll_staging_dir) in 
	let l_abspath_uobjcoll_triage_dir_uobjcoll_ns = (l_abspath_uobjcoll_triage_dir ^ "/" ^ d_uberspark_manifest_var.uobjcoll.namespace) in
	begin
	Uberspark.Osservices.mkdir ~parent:true l_abspath_uobjcoll_triage_dir_uobjcoll_ns (`Octal 0o0777);
	end;

	(* sanity check we have canonical uobjcoll sources folder organization *)
	if ( not (Uberspark.Osservices.is_dir (abspath_cwd ^ "/install")) ||
		 not (Uberspark.Osservices.is_dir (abspath_cwd ^ "/uobjs")) ||
		not (Uberspark.Osservices.is_dir (abspath_cwd ^ "/include")) ||
		not (Uberspark.Osservices.is_dir (abspath_cwd ^ "/docs")) ) then
		(false)
	else

	(* copy over uobjcoll sources folder structure  into uobjcoll triage dir with uobjcoll namespace prefix *)
	let dummy = 0 in begin
		Uberspark.Osservices.cp ~recurse:true (abspath_cwd ^ "/install") (l_abspath_uobjcoll_triage_dir_uobjcoll_ns ^ "/.");
		Uberspark.Osservices.cp ~recurse:true (abspath_cwd ^ "/uobjs") (l_abspath_uobjcoll_triage_dir_uobjcoll_ns ^ "/.");
		Uberspark.Osservices.cp ~recurse:true (abspath_cwd ^ "/include") (l_abspath_uobjcoll_triage_dir_uobjcoll_ns ^ "/.");
		Uberspark.Osservices.cp ~recurse:true (abspath_cwd ^ "/docs") (l_abspath_uobjcoll_triage_dir_uobjcoll_ns ^ "/.");
		Uberspark.Osservices.cp ~recurse:false abspath_mf_filename (l_abspath_uobjcoll_triage_dir_uobjcoll_ns ^ "/.");
	end;

	(* change working directory to triage *)
	let (rval, _, _) = (Uberspark.Osservices.dir_change l_abspath_uobjcoll_triage_dir) in
	if(rval == false) then begin
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "could not switch to uobjcoll triage folder";
		(false)
	end else

	(* copy over uobjcoll sources folder structure  into uobjcoll triage dir with uobjcoll namespace prefix *)
	let dummy = 0 in begin
	Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "switched operating context to: %s" l_abspath_uobjcoll_triage_dir;
	end;

	(* invoke common manifest processing logic *)
	(Uberspark.Context.process_manifest_common ~p_in_order:p_in_order (d_uberspark_manifest_var.uobjcoll.namespace) p_targets)
;;


let create_and_initialize_operation_context 
	?(p_in_order = true) 
  (p_copts : Commonopts.opts) 
  (p_cwd_abs : string)
  (p_manifest_file_path_abs : string)
  (p_operations : string list)
  : bool = 
  
  Uberspark.Context.initialize ~p_log_level:p_copts.log_level
    [
      "enforcing verifiable object abstractions for commodity system software stacks";
      "front-end tool";
      "version: 6.0.0";
      "website: https://uberspark.org";
      "creator: amit vasudevan <amitvasudevan@acm.org>";
      "";
    ];

  (* process uobjcoll manifest *)
  let rval = (create_staging 
    ~p_in_order:p_in_order p_cwd_abs p_manifest_file_path_abs  
      p_operations) in

  (rval)
;;


