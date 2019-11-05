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

  (* setup namespace root directory *)
  Uberspark.Config.namespace_root_dir := copts.root_dir;

  Uberspark.Logger.log ~crlf:false "Loading current configuration...";
  if not (Uberspark.Config.load Uberspark.Config.namespace_config_current) then 
    begin
      Uberspark.Logger.log ~tag:"" "[ERROR - exiting]";
      ignore ( exit 1);
    end
  ;

  Uberspark.Logger.log ~tag:"" "[OK]";

;;

