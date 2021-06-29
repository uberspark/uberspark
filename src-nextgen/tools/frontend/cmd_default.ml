(* uberspark front-end command processing logic for default execution; without
any options or commands *)
(* author: amit vasudevan (amitvasudevan@acm.org) *)

open Uberspark
open Cmdliner


(* main handler for default execution; without any options or commands *)
let handler_default 
  (p_copts : Commonopts.opts)
  = 

  (* initialize console logging *)
  Common.initialize_logging p_copts;

  (* check for manifest *)
  let (l_cwd_abs, 
  l_manifest_file_path_abs, l_is_error) = (Common.check_for_manifest p_copts) in

  (* bail out on error *)
  if l_is_error then
    `Error (false, "could not get absolute path of current working directory!")
  else if (l_manifest_file_path_abs == "" && l_is_error == false) then
    (* no manifest file found in current directory, display cli help and exit *)
    (`Help (`Pager, None))
  else

  (* create and initialize operation context by processing manifest *)
  let l_rval = (Common.initialize_operation_context_with_staging ~p_in_order:true p_copts l_cwd_abs l_manifest_file_path_abs [] []) in
  
  (* bail out on error, else return success *)
  if (l_rval == false) then begin
    `Error (false, "could not create and initialize operation context!")
  end else begin
    Uberspark.Logger.log "manifest processed succesfully!";
    `Ok()
  end;
;;
