(* uberspark front-end common initialization *)
(* author: amit vasudevan (amitvasudevan@acm.org) *)

open Uberspark
open Cmdliner

let initialize 
  (copts : Commonopts.opts) = 
  
  Uberspark.Logger.current_level := copts.log_level;

  (* turn on exception stack backtrace dump *)
  Printexc.record_backtrace true;

  Uberspark.Logger.log "enforcing verifiable object abstractions for commodity system software stacks";
  Uberspark.Logger.log "front-end tool";
  Uberspark.Logger.log "version: 6.0.0";
  Uberspark.Logger.log "website: https://uberspark.org";
  Uberspark.Logger.log "creator: amit vasudevan <amitvasudevan@acm.org>";
  Uberspark.Logger.log "";

  (* setup namespace root directory *)
  (*Uberspark.Namespace.namespace_root_dir := copts.root_dir;*)
  Uberspark.Namespace.set_namespace_root_dir_prefix copts.root_dir;
  Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "namespace root dir prefix=%s" (Uberspark.Namespace.get_namespace_root_dir_prefix ());
  Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "staging dir prefix=%s" (Uberspark.Namespace.get_namespace_staging_dir_prefix ());
 
  Uberspark.Logger.log ~crlf:false "Loading current configuration...";
  (*if not (Uberspark.Config.load Uberspark.Namespace.namespace_config_current) then *)
  if not (Uberspark.Config.load ()) then 
    begin
      Uberspark.Logger.log ~tag:"" "[ERROR - exiting]";
      ignore ( exit 1);
    end
  ;

  Uberspark.Logger.log ~tag:"" "[OK]";

;;

