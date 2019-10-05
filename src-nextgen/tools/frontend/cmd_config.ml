(* uberspark front-end command processing logic for command: config *)
(* author: amit vasudevan (amitvasudevan@acm.org) *)

open Uberspark
open Cmdliner

type opts = { 
  filename : string; 
  option2 : int
};;


(* main handler for config command *)
let handler_config 
  (copts : Commonopts.opts)
  (action : [> `Create | `Dump | `Get | `Remove | `Set ] as 'a)
  (config_ns : string)
  = 

  (* perform common initialization *)
  Commoninit.initialize copts;

  Uberspark.Logger.log "config_ns=%s" config_ns;

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
  ;


  `Ok ()
;;