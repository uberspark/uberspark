(* uberspark front-end command processing logic for command: uobjcoll *)
(* author: amit vasudevan (amitvasudevan@acm.org) *)

open Uberspark
open Cmdliner

type opts = { 
  baseinv : bool; 
};;

(* fold all verify options into type opts *)
let cmd_verify_opts_handler 
  (p_baseinv : bool)
  : opts = 
  
  { baseinv = p_baseinv; }
;;


(* handle verify command specific options *)
let cmd_verify_opts_t =
  let docs = "VERIFY OPTIONS" in

	let baseinv =
    let doc = "verify only uberspark base invariants." in
    Arg.(value & flag & info ["b"; "baseinv"] ~doc ~docs)

  in
  Term.(const cmd_verify_opts_handler $ baseinv)



(* verify command handler *)
let handler_verify
    (p_copts : Commonopts.opts)
    (p_cmd_verify_opts: opts)
  =
  (* setup logging level as specified in the cli and kick-start execution *)
  Uberspark.Logger.current_level := p_copts.log_level;
  Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "cmd_verify...";

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
  Commoninit.initialize p_copts;
  end;

  (* announce absolute path of manifest filename *)
  let l_dummy=0 in begin
  Uberspark.Logger.log "using manifest: %s" l_manifest_file_path_abs;
  end;

  (* process uobjcoll manifest *)
  let rval = (Uberspark.Uobjcoll.process_manifest 
    ~p_in_order:false l_cwd_abs l_manifest_file_path_abs  
      [ "verify"; ]) in

  (* bail out on error, else return success *)
  if (rval == false) then begin
    `Error (false, "could not process manifest!")
  end else begin
    Uberspark.Logger.log "manifest processed succesfully!";
    `Ok()
  end;
;;

