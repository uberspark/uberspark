(* uberspark front-end command processing logic for command: uobjcoll *)
(* author: amit vasudevan (amitvasudevan@acm.org) *)

open Uberspark
open Cmdliner

type opts = { 
  loaders : bool; 
};;

(* fold all build options into type opts *)
let cmd_build_opts_handler 
  (p_loaders : bool)
  : opts = 
  
  { loaders = p_loaders; }
;;


(* handle build command specific options *)
let cmd_build_opts_t =
  let docs = "BUILD OPTIONS" in

	let loaders =
    let doc = "Build only üobjcoll loaders." in
    Arg.(value & flag & info ["l"; "loaders"] ~doc ~docs)

  in
  Term.(const cmd_build_opts_handler $ loaders)



(* build command handler *)
let handler_build
    (p_copts : Commonopts.opts)
    (p_cmd_build_opts: opts)
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
  let l_rval = (Common.create_and_initialize_operation_context ~p_in_order:false 
    p_copts l_cwd_abs l_manifest_file_path_abs [ "build"; ]) in
  
  (* bail out on error, else return success *)
  if (l_rval == false) then begin
    `Error (false, "could not create and initialize operation context!")
  end else begin
    Uberspark.Logger.log "manifest processed succesfully!";
    `Ok()
  end;
;;

