(* uberspark front-end command processing logic for default execution; without
any options or commands *)
(* author: amit vasudevan (amitvasudevan@acm.org) *)

open Uberspark
open Cmdliner


(* main handler for default execution; without any options or commands *)
let handler_default 
  (copts : Commonopts.opts)
  = 

  (* setup logging level as specified in the cli and kick-start execution *)
  Uberspark.Logger.current_level := copts.log_level;
  Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "cmd_default...";

  (* get current working directory *)
  let l_cwd = Uberspark.Osservices.getcurdir() in

  (* get the absolute path of the current working directory *)
  let (rval, l_cwd_abs) = (Uberspark.Osservices.abspath l_cwd) in
	
  (* bail out on error *)
  if (rval == false) then
    `Error (false, "could not get absolute path of current working directory!")
  else

  (* announce working directory *)
  let l_dummy=0 in begin
  Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "current working directory: %s" l_cwd_abs;
  end;

  (* check if manifest exists within current working directory *)
  let l_manifest_file_path_abs = (l_cwd_abs ^ "/" ^ Uberspark.Namespace.namespace_root_mf_filename) in
  let rval = (Uberspark.Osservices.file_exists l_manifest_file_path_abs) in

  (* if not, display cli help and exit *)
  if (rval == false) then
    (`Help (`Pager, None))
  else

  (* print banner, setup root directory and staging prefix, and load default configuration *)
  let l_dummy=0 in begin
  Commoninit.initialize copts;
  end;

  (* announce absolute path of manifest filename *)
  let l_dummy=0 in begin
  Uberspark.Logger.log "using manifest: %s" l_manifest_file_path_abs;
  end;

  (* process uobjcoll manifest *)
  let rval = (Uberspark.Context.process_manifest 
    ~p_in_order:true l_cwd_abs l_manifest_file_path_abs  
      [ ]) in

  (* bail out on error, else return success *)
  if (rval == false) then begin
    `Error (false, "could not process manifest!")
  end else begin
    Uberspark.Logger.log "manifest processed succesfully!";
    `Ok()
  end;
;;
