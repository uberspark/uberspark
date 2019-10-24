(* uberspark front-end command processing logic for command: config *)
(* author: amit vasudevan (amitvasudevan@acm.org) *)

open Uberspark
open Cmdliner

type opts = { 
  setting_name: string option;
  setting_value: string option;
  new_ns : string option;
  from_ns : bool;
  from_file : bool;
};;

(* fold all config options into type opts *)
let cmd_config_opts_handler 
  (setting_name: string option)
  (setting_value: string option)
  (new_ns : string option)
  (from_ns: bool)
  (from_file: bool)
  : opts = 
  { setting_name=setting_name; setting_value=setting_value;
    new_ns=new_ns; from_ns=from_ns; from_file=from_file}
;;

(* handle config command options *)
let cmd_config_opts_t =
  let docs = "ACTION OPTIONS" in
  let setting_name =
    let doc = "Select configuration setting with $(docv)."  in
      Arg.(value & opt (some string) None & info ["setting-name"] ~docs ~docv:"NAME" ~doc)
  in
  let setting_value =
    let doc = "Set configuration setting specified by $(b,--setting-name) to $(docv). $(docv) can be a string or integer."  in
      Arg.(value & opt (some string) None & info ["setting-value"] ~docs ~docv:"VALUE" ~doc)
  in
  let new_ns =
    let doc = "A new namespace specified by $(docv)."  in
      Arg.(value & opt (some string) None & info ["newns"; "new-namespace"] ~docs ~docv:"NAME" ~doc)
  in
  let from_ns =
    let doc = "Create a new namespace from an existing namespace." in
    Arg.(value & flag & info ["from-ns"] ~doc ~docs )
  in
  let from_file =
    let doc = "Create a new namespace from a given (json) configuration file." in
    Arg.(value & flag & info ["from-file"] ~doc ~docs )
  in
 
 
  Term.(const cmd_config_opts_handler $ setting_name $ setting_value $ new_ns $ from_ns $ from_file)


(* main handler for config command *)
let handler_config 
  (copts : Commonopts.opts)
  (cmd_config_opts: opts)
  (action : [> `Create | `Dump | `Get | `Switch | `Set | `Remove] as 'a)
  (path_ns : string option)
  = 

  let retval = 
  match action with
    | `Create -> 
        let new_ns = ref "" in
        let src_path_ns = ref "" in

        (* perform common initialization *)
        Commoninit.initialize copts;

       (match cmd_config_opts.new_ns with
        | None -> `Error (true, "need new namespace specification")
        | Some sname -> 
          new_ns := sname;
          (match path_ns with
          | None -> `Error (true, "need PATH or NAMESPACE argument")
          | Some sname -> 
            src_path_ns := sname;
            if cmd_config_opts.from_file then
              begin
                Uberspark.Config.create_from_file !src_path_ns !new_ns;
                Uberspark.Logger.log "created configuration namespace '%s'" !new_ns;
                `Ok()
              end  
            else if cmd_config_opts.from_ns then
              begin
                Uberspark.Config.create_from_existing_ns !src_path_ns !new_ns;
                Uberspark.Logger.log "created configuration namespace '%s'" !new_ns;
                `Ok()
              end
            else
              `Error (true, "need either --from-ns or --from-file options")
          )
       ) 
    

    | `Dump ->
      let output_filename = ref "" in

      (* perform common initialization *)
      Commoninit.initialize copts;

      (match path_ns with
        | None -> `Error (true, "need output file PATH")
        | Some sname -> 
          output_filename := sname;
          Uberspark.Config.dump !output_filename;
          Uberspark.Logger.log "wrote current configuration to file: %s" !output_filename;
          `Ok()
      )


    | `Get -> 
      let setting_name = ref "" in
 
      (* perform common initialization *)
      copts.log_level <- (Uberspark.Logger.ord Uberspark.Logger.Stdoutput);
      Commoninit.initialize copts;

      (match cmd_config_opts.setting_name with
        | None -> `Error (true, "need setting name")
        | Some sname -> 
          setting_name := sname;
          let(rval, setting_value) = Uberspark.Config.settings_get !setting_name in
          if rval == true then
            begin
              Uberspark.Logger.log ~lvl:Uberspark.Logger.Stdoutput "%s" setting_value;
              `Ok()
            end
          else
            `Error (false, "invalid configuration setting")
      )
       

    | `Switch ->

      (* perform common initialization *)
      Commoninit.initialize copts;

      let src_path_ns = ref "" in
      (match path_ns with
      | None -> `Error (true, "need NAMESPACE argument")
      | Some sname -> 
        src_path_ns := sname;
        Uberspark.Config.switch !src_path_ns;
        Uberspark.Logger.log "switched to configuration namespace '%s'" !src_path_ns;
        `Ok()
      )
      

    | `Set -> 
      let setting_name = ref "" in
      let setting_value = ref "" in

      (* perform common initialization *)
      Commoninit.initialize copts;

      (match cmd_config_opts.setting_name with
      | None -> `Error (true, "need setting name")
      | Some sname -> 
          setting_name := sname;
          (match cmd_config_opts.setting_value with
          | None -> `Error (true, "need setting value")
          | Some sname -> 
            setting_value := sname;
            let rval = (Uberspark.Config.settings_set !setting_name !setting_value) in 
            if rval == true then 
              begin
                let config_ns_json_filename = Uberspark.Config.namespace_root ^
                  Uberspark.Config.namespace_config_current ^ "/" ^
                  Uberspark.Config.namespace_config_json_filename in
                Uberspark.Config.dump config_ns_json_filename;  
                Uberspark.Logger.log "configuration setting '%s' set to '%s' within current configuration" !setting_name !setting_value;
                `Ok()  
              end
            else
              `Error (false, "invalid configuration setting")
          )
      )


    | `Remove -> 

      (* perform common initialization *)
      Commoninit.initialize copts;

      let src_path_ns = ref "" in
      (match path_ns with
      | None -> `Error (true, "need NAMESPACE argument")
      | Some sname -> 
        src_path_ns := sname;
        Uberspark.Config.remove !src_path_ns;
        Uberspark.Logger.log "removed configuration namespace: %s" !src_path_ns;
        `Ok()
      )

        
  in

  retval

;;