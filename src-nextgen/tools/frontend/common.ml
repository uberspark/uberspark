(* uberspark front-end common initialization *)
(* author: amit vasudevan (amitvasudevan@acm.org) *)

open Uberspark
open Cmdliner



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
  let rval = (Uberspark.Context.process_manifest 
    ~p_in_order:p_in_order p_cwd_abs p_manifest_file_path_abs  
      p_operations) in

  (rval)
;;

