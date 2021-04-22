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
  if copts.root_dir = "" then begin
    (* we open the installation manifest to figure out the root directory *)
		let installation_manifest_filename = Uberspark.Namespace.namespace_installation_configdir ^ "/" ^
          Uberspark.Namespace.namespace_root_mf_filename in
    let mf_json_node_uberspark_installation_var : Uberspark.Manifest.Installation.json_node_uberspark_installation_t = 
		  {root_directory = ""; } in
    let (rval, mf_json) = (Uberspark.Manifest.get_json_for_manifest installation_manifest_filename ) in
  		if(rval == true) then	begin

				(* convert to var *)
				let rval =	(Uberspark.Manifest.Installation.json_node_uberspark_installation_to_var mf_json mf_json_node_uberspark_installation_var) in
  				if rval then begin
            Uberspark.Namespace.set_namespace_root_dir_prefix mf_json_node_uberspark_installation_var.root_directory;

          end else begin
            Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "Malformed installation configuration manifest at: %s" installation_manifest_filename;
            ignore (exit 1);
				  end;

      end else begin
        Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "Could not load installation configuration manifest from: %s" installation_manifest_filename;
        ignore (exit 1);
      end;

  end else begin
    (* --root-dir was specified on the command line, so we simply override *)
    Uberspark.Namespace.set_namespace_root_dir_prefix copts.root_dir;
  end;
  
  
  Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "namespace root dir prefix=%s" (Uberspark.Namespace.get_namespace_root_dir_prefix ());
  Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "staging dir prefix=%s" (Uberspark.Namespace.get_namespace_staging_dir_prefix ());
 
  Uberspark.Logger.log ~crlf:false "Loading current configuration...";
  (*if not (Uberspark.Platform.load Uberspark.Namespace.namespace_platform_current) then *)
  if not (Uberspark.Platform.load ()) then 
    begin
      Uberspark.Logger.log ~tag:"" "[ERROR - exiting]";
      ignore ( exit 1);
    end
  ;

  Uberspark.Logger.log ~tag:"" "[OK]";

;;

