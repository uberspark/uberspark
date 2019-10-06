(* uberspark front-end command processing logic for command: config *)
(* author: amit vasudevan (amitvasudevan@acm.org) *)

open Uberspark
open Cmdliner

type opts = { 
  arch : string option; 
  build : bool;
  lvl: int;
};;

(* fold all config options into type opts *)
let cmd_config_opts_handler 
  (arch : string option)
  (build: bool)
  (lvl : int)
  : opts = 
  { arch=arch; build=build; lvl=lvl}
;;

(* handle config command options *)
let cmd_config_opts_t =
  let docs = "ACTION OPTIONS" in
 	let arch =
    let doc = "Specify uobj target $(docv)." in
    Arg.(value & opt (some string) None & info ["a"; "arch"] ~docs ~docv:"ARCH" ~doc)
  in
  let build =
    let doc = "Build the uobj binary." in
    Arg.(value & flag & info ["b"; "build"] ~doc ~docs)
  in
  let lvl =
    let doc = "Set output logging level to $(docv). All output log messages less than or equal to $(docv) will be printed to the standard output. $(docv) can be `5' (Debug), `4' (Info), `3' (Warn), `2' (Error), `1' (Stdoutput), or `0' (None)"  in
      Arg.(value & opt int (Uberspark.Logger.ord Uberspark.Logger.Info) & info ["lvl"] ~docs ~docv:"VAL" ~doc)
  in
  Term.(const cmd_config_opts_handler $ arch $ build $ lvl)


(* main handler for config command *)
let handler_config 
  (copts : Commonopts.opts)
  (cmd_config_opts: opts)
  (action : [> `Create | `Dump | `Get | `Remove | `Set ] as 'a)
  (config_ns : string)
  = 

  (* perform common initialization *)
  Commoninit.initialize copts;

  Uberspark.Logger.log "config_ns=%s" config_ns;

  let retval = 
  match action with
    | `Create -> 
      Uberspark.Logger.log "config create";
      `Ok()
    
    | `Dump ->
      Uberspark.Logger.log "config dump";
      `Ok()

    | `Get -> 
      Uberspark.Logger.log "config get";
      `Ok()

    | `Remove -> 
      Uberspark.Logger.log "config remove";
      `Ok()

    | `Set -> 
      Uberspark.Logger.log "config set";
      `Ok()
  in

  retval

;;