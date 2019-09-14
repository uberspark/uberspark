(* uberspark front-end command processing logic for command: uobj *)
(* author: amit vasudevan (amitvasudevan@acm.org) *)

open Uslog
open Cmdliner

(* handler for uobj command *)
let handler_uobj 
  (copts : Commonopts.opts)
  (build : bool)
  (path : 'a option) = 
  Commoninit.initialize copts;
  Uslog.log "build=%B" build;
  match path with
  | None -> Uslog.log "path=none";
      `Error (true, "one of build, verify must be specified")

  | Some p -> Uslog.log "path: %s" p;
      `Ok ()
  ;
;;