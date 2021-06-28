(* uberspark front-end command processing logic for command: uobjcoll *)
(* author: amit vasudevan (amitvasudevan@acm.org) *)

open Uberspark
open Cmdliner

type opts = { 
  uobject : string option;
  baseinv : bool; 
};;

(* fold all verify options into type opts *)
let cmd_verify_opts_handler 
  (p_uobject : string option)
  (p_baseinv : bool)
  : opts = 
  
  { 
    uobject = p_uobject; 
    baseinv = p_baseinv; }
;;


(* handle verify command specific options *)
let cmd_verify_opts_t =
  let docs = "VERIFY OPTIONS" in

  let uobject =
    let doc = "Perform verification only for uobject specified by $(docv)."  in
      Arg.(value & opt (some string) None & info ["uobj"; "uobject"] ~docs ~docv:"UOBJECT" ~doc)
  in

	let baseinv =
    let doc = "Verify only uberspark base invariants." in
    Arg.(value & flag & info ["b"; "baseinv"] ~doc ~docs)

  in


  Term.(const cmd_verify_opts_handler $ uobject $ baseinv)



(* verify command handler *)
let handler_verify
    (p_copts : Commonopts.opts)
    (p_cmd_verify_opts: opts)
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

  let l_cmd_verify_opts_list = ref [] in
  (* process options *)
  let dummy=0 in begin
  l_cmd_verify_opts_list := !l_cmd_verify_opts_list @ [ ("baseinv", string_of_bool(p_cmd_verify_opts.baseinv)) ];
  match p_cmd_verify_opts.uobject with
  | None ->
    l_cmd_verify_opts_list := !l_cmd_verify_opts_list @ [ ("uobject", "") ];    
  | Some l_uobject_name -> 
    l_cmd_verify_opts_list := !l_cmd_verify_opts_list @ [ ("uobject", l_uobject_name) ];
  ;
  
  (*List.iter ( fun (x, y) -> 
  	Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "x: %s, y: %s" x y;
  )!l_cmd_verify_opts_list;
  *)
  end;       


  (* create and initialize operation context by processing manifest *)
  let l_rval = (Common.initialize_operation_context_with_staging ~p_in_order:false 
    p_copts l_cwd_abs l_manifest_file_path_abs [ "verify"; ]) in
  
  (* bail out on error, else return success *)
  if (l_rval == false) then begin
    `Error (false, "could not create and initialize operation context!")
  end else begin
    Uberspark.Logger.log "manifest processed succesfully!";
    `Ok()
  end;


;;

