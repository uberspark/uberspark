(* uberspark front-end command processing logic for command: staging *)
(* author: amit vasudevan (amitvasudevan@acm.org) *)

open Uberspark
open Cmdliner

type opts = { 
  as_new : bool;
  from_existing : string option;
  setting_name: string option;
  setting_value: string option;
  from_file : string option;
  to_file : string option;
};;

(* fold all staging options into type opts *)
let cmd_staging_opts_handler 
  (as_new: bool)
  (from_existing: string option)
  (setting_name: string option)
  (setting_value: string option)
  (from_file : string option)
  (to_file : string option)
  : opts = 
  { 
      as_new = as_new;
      from_existing = from_existing;
      setting_name=setting_name; 
      setting_value=setting_value;
      from_file = from_file;
      to_file = to_file;
  }
;;

(* handle staging command options *)
let cmd_staging_opts_t =
  let docs = "ACTION OPTIONS" in

  let as_new =
    let doc = "Create a new staging. This is the default." in
    Arg.(value & flag & info ["as-new"] ~doc ~docs )

  in
  let from_existing =
    let doc = "Create a new staging from an existing staging specified by $(docv)."  in
      Arg.(value & opt (some string) None & info ["from-existing"] ~docs ~docv:"NAME" ~doc)

  in
  let setting_name =
    let doc = "Select staging configuration setting with $(docv)."  in
      Arg.(value & opt (some string) None & info ["setting-name"] ~docs ~docv:"NAME" ~doc)

  in
  let setting_value =
    let doc = "Set staging configuration setting specified by $(b,--setting-name) to $(docv). $(docv) can be a string or integer."  in
      Arg.(value & opt (some string) None & info ["setting-value"] ~docs ~docv:"VALUE" ~doc)

  in
  let from_file =
    let doc = "Set staging configuration settings from file specified by $(docv)."  in
      Arg.(value & opt (some string) None & info ["from-file"] ~docs ~docv:"NAME" ~doc)

  in
  let to_file =
    let doc = "Store staging configuration settings to file specified by $(docv)."  in
      Arg.(value & opt (some string) None & info ["to-file"] ~docs ~docv:"NAME" ~doc)

  in
 
  Term.(const cmd_staging_opts_handler $ as_new $ from_existing $ setting_name $ setting_value $ from_file $ to_file)



(* main handler for staging command *)
let handler_staging 
  (copts : Commonopts.opts)
  (cmd_staging_opts: opts)
  (action : [> `Create | `Switch | `List | `Remove | `Config_set | `Config_get] as 'a)
  (path_ns : string option)
  = 

  let retval = 
  match action with
    | `Create -> 
        `Ok()
    
    | `Switch ->
        `Ok()

    | `List ->
        `Ok()

    | `Remove ->
        `Ok()

    | `Config_set ->
        `Ok()

    | `Config_get ->
        `Ok()

  in
    retval
;;