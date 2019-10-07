(* uberspark front-end command processing logic for command: config *)
(* author: amit vasudevan (amitvasudevan@acm.org) *)

open Uberspark
open Cmdliner

type opts = { 
  arch : string option; 
  build : bool;
  lvl: int;
  setting_name: string option;
  setting_value: string option;
};;

(* fold all config options into type opts *)
let cmd_config_opts_handler 
  (arch : string option)
  (build: bool)
  (lvl : int)
  (setting_name: string option)
  (setting_value: string option)
  : opts = 
  { arch=arch; build=build; lvl=lvl; setting_name=setting_name; setting_value=setting_value}
;;

(* handle config command options *)
let cmd_config_opts_t =
  let docs = "ACTION OPTIONS" in
 	let arch =
    let doc = "Specify uobj target $(docv)." in
    Arg.(value & opt (some string) None & info ["a"; "arch"] ~docs ~docv:"ARCH" ~doc)
  in
  let build =
    let doc = "Build the uobj binary." in
    Arg.(value & flag & info ["b"; "build"] ~doc ~docs)
  in
  let lvl =
    let doc = "Set output logging level to $(docv). All output log messages less than or equal to $(docv) will be printed to the standard output. $(docv) can be `5' (Debug), `4' (Info), `3' (Warn), `2' (Error), `1' (Stdoutput), or `0' (None)"  in
      Arg.(value & opt int (Uberspark.Logger.ord Uberspark.Logger.Info) & info ["lvl"] ~docs ~docv:"VAL" ~doc)
  in
  let setting_name =
    let doc = "Select configuration setting with $(docv)."  in
      Arg.(value & opt (some string) None & info ["setting-name"] ~docs ~docv:"NAME" ~doc)
  in
  let setting_value =
    let doc = "Set configuration setting specified by $(b,--setting-name) to $(docv). $(docv) can be a string or integer."  in
      Arg.(value & opt (some string) None & info ["setting-value"] ~docs ~docv:"VALUE" ~doc)
  in
 
 
  Term.(const cmd_config_opts_handler $ arch $ build $ lvl $ setting_name $ setting_value)


(* main handler for config command *)
let handler_config 
  (copts : Commonopts.opts)
  (cmd_config_opts: opts)
  (action : [> `Create | `Dump | `Get | `Remove | `Set ] as 'a)
  (path_ns : string option)
  = 

  (* perform common initialization *)
  Commoninit.initialize copts;

  (*Uberspark.Logger.log "config_ns=%s" config_ns;*)

  let retval = 
  match action with
    | `Create -> 
      Uberspark.Logger.log "config create";
      `Ok()
    
    | `Dump ->
      let output_filename = ref "" in
      Uberspark.Logger.log "config dump";
      (match path_ns with
        | None -> `Error (true, "need output file PATH")
        | Some sname -> 
          output_filename := sname;
          Uberspark.Config.dump !output_filename;
          Uberspark.Logger.log "Wrote current configuration to file: %s" !output_filename;
          `Ok()
      )

    | `Get -> 
      let setting_name = ref "" in
 
      Uberspark.Logger.log "config get";
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
       
 
    | `Remove -> 
      Uberspark.Logger.log "config remove";
      `Ok()

    | `Set -> 
      let setting_name = ref "" in
      let setting_value = ref "" in

      Uberspark.Logger.log "config set";
      (match cmd_config_opts.setting_name with
      | None -> `Error (true, "need setting name")
      | Some sname -> 
          setting_name := sname;
          (match cmd_config_opts.setting_value with
          | None -> `Error (true, "need setting value")
          | Some sname -> 
            setting_value := sname;
            if ( Uberspark.Config.settings_set !setting_name !setting_value) then
              `Ok()
            else
              `Error (false, "invalid configuration setting")
          )
      )
        
  in

  retval

;;