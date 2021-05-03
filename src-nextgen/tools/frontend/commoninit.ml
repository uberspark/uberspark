(* uberspark front-end common initialization *)
(* author: amit vasudevan (amitvasudevan@acm.org) *)

open Uberspark
open Cmdliner

(*
  returns (is_manifest_present, is_error)
  (true, false) => manifest present and no error
  (false, false) => manifest not present and no error
  (false, true) => manifest not present and error
*)
let check_for_manifest 
  (copts : Commonopts.opts) : (bool * bool) = 
  
  (* setup logging level as specified in the cli and kick-start execution *)
  Uberspark.Logger.current_level := copts.log_level;
  Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "check_for_manifest...";

  (* get current working directory *)
  let l_cwd = Uberspark.Osservices.getcurdir() in

  (* get the absolute path of the current working directory *)
  let (rval, l_cwd_abs) = (Uberspark.Osservices.abspath l_cwd) in

  (* bail out on error *)
  if (rval == false) then
    Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "check_for_manifest: could not get absolute path of current working directory!";
    (false, true)
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
    (false, false)
  else

  (true, false)
;;




let initialize_context 
  (copts : Commonopts.opts) = 
  
  Uberspark.Context.initialize ~p_log_level:copts.log_level
    [
      "enforcing verifiable object abstractions for commodity system software stacks";
      "front-end tool";
      "version: 6.0.0";
      "website: https://uberspark.org";
      "creator: amit vasudevan <amitvasudevan@acm.org>";
      "";
    ];

;;

