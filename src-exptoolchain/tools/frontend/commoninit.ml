(* uberspark front-end common initialization *)
(* author: amit vasudevan (amitvasudevan@acm.org) *)

open Uslog
open Cmdliner

let initialize 
  (copts : Commonopts.opts) = 
  
  Uslog.current_level := copts.log_level;

  Uslog.log "enforcing verifiable object abstractions for commodity system software stacks";
  Uslog.log "front-end tool";
  Uslog.log "version: 5.1";
  Uslog.log "website: https://uberspark.org";
  Uslog.log "creator: amit vasudevan <amitvasudevan@acm.org>";
  Uslog.log "";

;;