(* uberspark front-end common initialization *)
(* author: amit vasudevan (amitvasudevan@acm.org) *)

open Uslog
open Cmdliner

let initialize 
  (copts : Commonopts.opts) = 
  
  Uslog.current_level := (Uslog.ord copts.log_level);

;;