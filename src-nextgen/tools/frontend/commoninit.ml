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
  Uberspark.Config.load Uberspark.Config.namespace_config_current;
  Uberspark.Logger.log ~tag:"" "[OK]";

;;


let initialize_bridges () : bool =
  let retval = ref false in

  Uberspark.Bridge.load (Uberspark.Config.namespace_bridges_cc_bridge ^ "/" ^ !Uberspark.Config.bridge_cc_bridge);

  if ( !Uberspark.Bridge.cc_bridge_settings_loaded) then
    begin
      Uberspark.Logger.log "loaded cc_bridge settings";
      retval := true;
    end
  else
    begin
      Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "unable to load cc_bridge settings!";
      retval := false;
    end
  ;  

  (!retval)
;;
