(* uberspark front-end command processing logic for command: clean *)
(* author: amit vasudevan (amitvasudevan@acm.org) *)

open Uberspark
open Cmdliner

type opts = { 
  all : bool; 
};;

(* fold all clean options into type opts *)
let cmd_clean_opts_handler 
  (p_all : bool)
  : opts = 
  
  { all = p_all; }
;;


(* handle clean command specific options *)
let cmd_clean_opts_t =
  let docs = "clean OPTIONS" in

	let all =
    let doc = "cleanup all stagings." in
    Arg.(value & flag & info ["a"; "all"] ~doc ~docs)

  in
  Term.(const cmd_clean_opts_handler $ all)



(* clean command handler *)
let handler_clean
    (p_copts : Commonopts.opts)
    (p_cmd_clean_opts: opts)
  =

  (* initialize console logging *)
  Common.initialize_logging p_copts;

  (* check for manifest *)
  let (l_cwd_abs, 
  l_manifest_file_path_abs, l_is_error) = (Common.check_for_manifest p_copts) in

  let dummy=0 in begin
    Uberspark.Logger.log "l_cwd_abs=%s l_manifest_file_path_abs=%s l_is_error=%b"
      l_cwd_abs l_manifest_file_path_abs l_is_error;
  end;

  (* bail out on error *)
  if l_is_error then
    `Error (false, "could not get absolute path of current working directory!")
  else if (l_manifest_file_path_abs = "" && l_is_error = false) then
    (* no manifest file found in current directory, display cli help and exit *)
    (`Help (`Pager, None))
  else

  let dummy=0 in begin
  Common.initialize_operation_context p_copts;
  end;

  (* check to see if we have staging directory *)
	let l_abspath_uobjcoll_staging_dir = (l_cwd_abs ^ "/" ^ Uberspark.Namespace.namespace_uobjcoll_staging_dir) in 

  let l_rval = (Uberspark.Osservices.file_exists l_abspath_uobjcoll_staging_dir) in 
  
  (* bail out on error, else return success *)
  if (l_rval == false) then begin
    Uberspark.Logger.log "nothing to do. no staging present!";
    `Ok()
  end else begin
    Uberspark.Logger.log "staging cleanup success!";
    `Ok()
  end;


;;

