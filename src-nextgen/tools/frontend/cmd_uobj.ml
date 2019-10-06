(* uberspark front-end command processing logic for command: uobj *)
(* author: amit vasudevan (amitvasudevan@acm.org) *)

open Uberspark
open Cmdliner

type opts = { 
  platform : string; 
  arch : string;
  cpu: string;
};;

(* fold all uobj options into type opts *)
let cmd_uobj_opts_handler 
  (platform : string option)
  (arch : string option)
  (cpu : string option)
  : opts = 
  let l_platform = ref "" in
  let l_arch = ref "" in
  let l_cpu = ref "" in

  match platform with
  | None -> 
    l_platform := "";
  | Some l_str ->
    l_platform := l_str;
  ;

  match arch with
  | None -> 
    l_arch := "";
  | Some l_str ->
    l_arch := l_str;
  ;

  match cpu with
  | None -> 
    l_cpu := "";
  | Some l_str ->
    l_cpu := l_str;
  ;

  { platform = !l_platform; arch = !l_arch; cpu = !l_cpu}
;;

(* handle uobj command options *)
let cmd_uobj_opts_t =
  let docs = "ACTION OPTIONS" in
	let platform =
    let doc = "Specify uobj target $(docv)." in
    Arg.(value & opt (some string) None & info ["p"; "platform"] ~docv:"PLATFORM" ~doc)
  in
	let arch =
    let doc = "Specify uobj target $(docv)." in
    Arg.(value & opt (some string) None & info ["a"; "arch"] ~docv:"ARCH" ~doc)
  in
	let cpu =
    let doc = "Specify uobj target $(docv)." in
    Arg.(value & opt (some string) None & info ["c"; "cpu"] ~docv:"CPU" ~doc)
  in
  Term.(const cmd_uobj_opts_handler $ platform $ arch $ cpu)




(* build action handler *)
let handler_uobj_build
  (cmd_uobj_opts: opts)
  (uobj_path_ns : string)
  =

(*  
  match platform with
  | None -> 
      `Error (true, "uobj PLATFORM must be specified.")

  | Some str_platform ->
    match arch with
    | None -> 
        `Error (true, "uobj ARCH must be specified.")

    | Some str_arch ->
      match cpu with
      | None -> 
          `Error (true, "uobj CPU must be specified.")
    
      | Some str_cpu ->
  
          let (rval, abs_uobj_path_ns) = (Uberspark.Osservices.abspath uobj_path_ns) in
          if(rval == false) then
          begin
            Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "could not obtain absolute path for uobj: %s" abs_uobj_path_ns;
            ignore (exit 1);
          end
          ;

          (* create uobj instance and parse manifest *)
          let uobj = new Uberspark.Uobj.uobject in
          let uobj_mf_filename = (abs_uobj_path_ns ^ "/" ^ Uberspark.Config.namespace_default_uobj_mf_filename) in
          Uberspark.Logger.log "parsing uobj manifest: %s" uobj_mf_filename;
          let rval = (uobj#parse_manifest uobj_mf_filename true) in	
          if (rval == false) then
            begin
              Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "unable to stat/parse manifest for uobj: %s" uobj_mf_filename;
              ignore (exit 1);
            end
          ;

          Uberspark.Logger.log "successfully parsed uobj manifest";
          (*TBD: validate platform, arch, cpu target def with uobj target spec*)

          let target_def: Uberspark.Defs.Basedefs.target_def_t = {f_platform = str_platform; f_arch = str_arch; f_cpu = str_cpu} in
            uobj#initialize target_def;

      ;
    ;
  ;            
*)

`Ok ()

;;


(* main handler for uobj command *)
let handler_uobj 
  (copts : Commonopts.opts)
  (cmd_uobj_opts: opts)
  (action : [> `Build ] as 'a)
  (path_ns : string)
  = 

  (* perform common initialization *)
  Commoninit.initialize copts;

  match action with
  | `Build -> 
    (handler_uobj_build cmd_uobj_opts path_ns)
  ;

  `Error (true, "invalid action specification")


;;