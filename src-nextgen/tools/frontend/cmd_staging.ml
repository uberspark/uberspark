(* uberspark front-end command processing logic for command: staging *)
(* author: amit vasudevan (amitvasudevan@acm.org) *)

open Uberspark
open Cmdliner

type opts = { 
  from_existing : string option;
  setting_name: string option;
  setting_value: string option;
  from_file : string option;
  to_file : string option;
};;

(* fold all staging options into type opts *)
let cmd_staging_opts_handler 
  (from_existing: string option)
  (setting_name: string option)
  (setting_value: string option)
  (from_file : string option)
  (to_file : string option)
  : opts = 
  { 
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
 
  Term.(const cmd_staging_opts_handler $ from_existing $ setting_name $ setting_value $ from_file $ to_file)



(*
  `Error (true, "message is printed along with usage.")
  `Ok ()
  `Error (false, "message is printed without usage")
*)


(* uberspark staging create sub-handler *)
let handler_staging_create
  (copts : Commonopts.opts)
  (cmd_staging_opts: opts)
  (name : string option)
  =

  let l_from_existing = ref "" in
  let l_name = ref "" in

  match cmd_staging_opts.from_existing with
    | None -> l_from_existing := "";
    | Some s_name -> l_from_existing := s_name;
  ;

  match name with
    | None -> l_name := "";
    | Some s_name -> l_name := s_name;
  ;

  Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "l_name=%s, l_from_existing=%s"  
    !l_name !l_from_existing;

  if (!l_name <> "") then begin
    if (!l_from_existing <> "") then begin
      (* create from existing staging *)
      if (Uberspark.Staging.create_from_existing !l_name !l_from_existing) then begin
        Uberspark.Logger.log "successfully created and switched to staging: '%s'" !l_name;
        `Ok ()
      end else begin
        `Error (false, "could not create staging; existing staging does not exist!")
      end;

    end else begin
      (* create new staging *)
      if (Uberspark.Staging.create_as_new !l_name) then begin
        Uberspark.Logger.log "successfully created and switched to staging: '%s'" !l_name;
        `Ok ()
      end else begin
        `Error (false, "could not create staging!")
      end;
    end;

  end else begin
    `Error (true, "need to specify staging name.")
  end;

;;



(* uberspark staging switch sub-handler *)
let handler_staging_switch
  (copts : Commonopts.opts)
  (cmd_staging_opts: opts)
  (name : string option)
  =

  let l_name = ref "" in

  match name with
    | None -> l_name := "";
    | Some s_name -> l_name := s_name;
  ;

  Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "l_name=%s" !l_name;

  if (!l_name <> "") then begin

    if not (Uberspark.Staging.switch !l_name) then begin
      `Error (false, "could not switch to specified staging: does not exist!.")
    end else begin
      Uberspark.Logger.log "successfully switched to staging: '%s'" !l_name;
      `Ok ()
    end;

  end else begin
    `Error (true, "need to specify staging name.")
  end;


;;


(* uberspark staging list sub-handler *)
let handler_staging_list
  (copts : Commonopts.opts)
  (cmd_staging_opts: opts)
  (name : string option)
  =
  let staging_list = Uberspark.Staging.list () in 

  Uberspark.Logger.log "list of available stagings:";

  List.iter (fun staging_name -> 
    Uberspark.Logger.log "%s" staging_name;
  )staging_list;
  
  `Ok ()
;;


(* uberspark staging remove sub-handler *)
let handler_staging_remove
  (copts : Commonopts.opts)
  (cmd_staging_opts: opts)
  (name : string option)
  =


  let l_name = ref "" in

  match name with
    | None -> l_name := "";
    | Some s_name -> l_name := s_name;
  ;

  Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "l_name=%s" !l_name;

  if (!l_name <> "") then begin

    if not (Uberspark.Staging.remove !l_name) then begin
      `Error (false, "could not rempve specified staging: does not exist or is currently active!.")
    end else begin
      Uberspark.Logger.log "successfully removed staging: '%s'" !l_name;
      `Ok ()
    end;

  end else begin
    `Error (true, "need to specify staging name.")
  end;

;;


(* uberspark staging config-set sub-handler *)
(* TBD process option --from-file and integrate Uberspark.Config.load_from_file *)
let handler_staging_config_set
  (copts : Commonopts.opts)
  (cmd_staging_opts: opts)
  (name : string option)
  =
  let l_setting_name = ref "" in
  let l_setting_value = ref "" in

  (* grab setting name and setting value *)
  match cmd_staging_opts.setting_name with
    | None -> l_setting_name := "";
    | Some sname -> l_setting_name := sname;
  ;

  match cmd_staging_opts.setting_value with
    | None -> l_setting_value := "";
    | Some sname -> l_setting_value := sname;
  ;

  if !l_setting_name = "" || !l_setting_value = "" then begin

    `Error (true, "need staging configuration setting name and setting value")

  end else begin

    let rval = (Uberspark.Config.settings_set !l_setting_name !l_setting_value) in 
    if rval == true then begin
      let config_ns_json_filename = (Uberspark.Namespace.get_namespace_staging_dir_prefix ())  ^ "/" ^ Uberspark.Namespace.namespace_root ^ "/" ^
        Uberspark.Namespace.namespace_config ^ "/" ^
        Uberspark.Namespace.namespace_config_mf_filename in
      Uberspark.Config.dump config_ns_json_filename;  
      Uberspark.Logger.log "configuration setting '%s' set to '%s' within current configuration" !l_setting_name !l_setting_value;
      `Ok()  
    end else begin
      `Error (false, "invalid configuration setting")
    end;

  end;

;;


(* uberspark staging config-get sub-handler *)
(* TBD process option --to-file and integrate Uberspark.Config.load_from_file *)
let handler_staging_config_get
  (copts : Commonopts.opts)
  (cmd_staging_opts: opts)
  (name : string option)
  =

  let l_setting_name = ref "" in
  let l_setting_value = ref "" in

  (* grab setting name *)
  match cmd_staging_opts.setting_name with
    | None -> l_setting_name := "";
    | Some sname -> l_setting_name := sname;
  ;

  if !l_setting_name = "" then begin

    `Error (true, "need staging configuration setting name")

  end else begin

    let(rval, setting_value) = Uberspark.Config.settings_get !l_setting_name in
    if rval == true then begin
      Uberspark.Logger.log ~lvl:Uberspark.Logger.Stdoutput "%s" setting_value;
      `Ok()
    end else begin
      `Error (false, "invalid configuration setting")
    end;

  end;

;;


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
        (* perform common initialization *)
        Commoninit.initialize copts;

        (handler_staging_create copts cmd_staging_opts path_ns)
    
    | `Switch ->
        (* perform common initialization *)
        Commoninit.initialize copts;

        (handler_staging_switch copts cmd_staging_opts path_ns)

    | `List ->
        (* perform common initialization *)
        Commoninit.initialize copts;

        (handler_staging_list copts cmd_staging_opts path_ns)

    | `Remove ->
        (* perform common initialization *)
        Commoninit.initialize copts;

        (handler_staging_remove copts cmd_staging_opts path_ns)

    | `Config_set ->
        (* perform common initialization *)
        Commoninit.initialize copts;

        (handler_staging_config_set copts cmd_staging_opts path_ns)

    | `Config_get ->
        (* perform common initialization, but dont emit any messages *)
        copts.log_level <- (Uberspark.Logger.ord Uberspark.Logger.Stdoutput);
        Commoninit.initialize copts;

        (handler_staging_config_get copts cmd_staging_opts path_ns)

  in
    retval
;;