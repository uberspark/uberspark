(* uberspark front-end common initialization *)
(* author: amit vasudevan (amitvasudevan@acm.org) *)

open Uberspark
open Cmdliner

let initialize 
  (copts : Commonopts.opts) = 
  
  Uberspark.Logger.current_level := copts.log_level;

  Uberspark.Logger.log "enforcing verifiable object abstractions for commodity system software stacks";
  Uberspark.Logger.log "front-end tool";
  Uberspark.Logger.log "version: 5.1";
  Uberspark.Logger.log "website: https://uberspark.org";
  Uberspark.Logger.log "creator: amit vasudevan <amitvasudevan@acm.org>";
  Uberspark.Logger.log "";

  Uberspark.Logger.log ~crlf:false "Loading current configuration...";
  Uberspark.Config.switch "uberspark/config/default";
  Uberspark.Logger.log ~tag:"" "[OK]";

;;