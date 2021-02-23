(* uberspark front-end command processing logic for command: uobjcoll *)
(* author: amit vasudevan (amitvasudevan@acm.org) *)

open Uberspark
open Cmdliner

(* build command handler *)
let handler_build
  (copts : Commonopts.opts)
  (loaders: bool)
  =

    Uberspark.Logger.log "build command handler: loaders=%b" loaders;
    `Ok ()
;;

