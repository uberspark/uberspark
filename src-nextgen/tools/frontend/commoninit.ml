(* uberspark front-end common initialization *)
(* author: amit vasudevan (amitvasudevan@acm.org) *)

open Uberspark
open Cmdliner

let initialize 
  (copts : Commonopts.opts) = 
  
  Uberspark.Context.initialize ~p_log_level:copts.log_level
    [
      "enforcing verifiable object abstractions for commodity system software stacks";
      "front-end tool";
      "version: 6.0.0";
      "website: https://uberspark.org";
      "creator: amit vasudevan <amitvasudevan@acm.org>";
      "";
    ];


;;

