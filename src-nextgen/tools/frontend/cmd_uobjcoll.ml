(* uberspark front-end command processing logic for command: uobjcoll *)
(* author: amit vasudevan (amitvasudevan@acm.org) *)

open Uberspark
open Cmdliner

type opts = { 
  platform : string; 
  arch : string;
  cpu: string;
};;

(* fold all uobjcoll options into type opts *)
let cmd_uobjcoll_opts_handler 
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
let cmd_uobjcoll_opts_t =
  let docs = "ACTION OPTIONS" in
	let platform =
    let doc = "Specify uobj collection target $(docv)." in
    Arg.(value & opt (some string) None & info ["p"; "platform"] ~docv:"PLATFORM" ~doc ~docs)
  in
	let arch =
    let doc = "Specify uobj collection target $(docv)." in
    Arg.(value & opt (some string) None & info ["a"; "arch"] ~docv:"ARCH" ~doc ~docs)
  in
	let cpu =
    let doc = "Specify uobj collection target $(docv)." in
    Arg.(value & opt (some string) None & info ["c"; "cpu"] ~docv:"CPU" ~doc ~docs)
  in
  Term.(const cmd_uobjcoll_opts_handler $ platform $ arch $ cpu)




(* build action handler *)
let handler_uobjcoll_build
  (cmd_uobjcoll_opts: opts)
  (uobjcoll_path_ns : string)
  =

  if cmd_uobjcoll_opts.platform = "" then
      `Error (true, "uobj collection PLATFORM must be specified.")
  else if cmd_uobjcoll_opts.arch = "" then
      `Error (true, "uobj collection ARCH must be specified.")
  else if cmd_uobjcoll_opts.cpu = "" then
      `Error (true, "uobj collection CPU must be specified.")
  else
    begin
     	let target_def: Uberspark.Defs.Basedefs.target_def_t = 
    		{platform = cmd_uobjcoll_opts.platform; arch = cmd_uobjcoll_opts.arch; cpu = cmd_uobjcoll_opts.cpu} in

      if (Uberspark.Uobjcoll.build uobjcoll_path_ns target_def Uberspark.Platform.manifest_var.platform.binary.uobjcoll_image_load_address) then begin
        Uberspark.Logger.log "uobj collection build success!";
        `Ok ()
      end else begin
        `Error (false, "uobj collection build failed!")
      end;

    end
  ;

;;


(* verify action handler *)
let handler_uobjcoll_verify
  (cmd_uobjcoll_opts: opts)
  (uobjcoll_path_ns : string)
  =

  if cmd_uobjcoll_opts.platform = "" then
      `Error (true, "uobj collection PLATFORM must be specified.")
  else if cmd_uobjcoll_opts.arch = "" then
      `Error (true, "uobj collection ARCH must be specified.")
  else if cmd_uobjcoll_opts.cpu = "" then
      `Error (true, "uobj collection CPU must be specified.")
  else
    begin
     	let target_def: Uberspark.Defs.Basedefs.target_def_t = 
    		{platform = cmd_uobjcoll_opts.platform; arch = cmd_uobjcoll_opts.arch; cpu = cmd_uobjcoll_opts.cpu} in

      if (Uberspark.Uobjcoll.verify uobjcoll_path_ns target_def Uberspark.Platform.manifest_var.platform.binary.uobjcoll_image_load_address) then begin
        Uberspark.Logger.log "uobj collection verification [SUCCESS]!";
        `Ok ()
      end else begin
        `Error (false, "uobj collection verification [FAILED]!")
      end;

    end
  ;

;;



(* main handler for uobjcoll command *)
let handler_uobjcoll 
  (copts : Commonopts.opts)
  (cmd_uobjcoll_opts: opts)
  (action : [> `Build ] as 'a)
  (path_ns : string)
  : [> `Error of bool * string | `Ok of unit ] = 

  let retval : [> `Error of bool * string | `Ok of unit ] ref = ref (`Ok ()) in

  (* perform common initialization *)
  Common.initialize copts;

  match action with
    | `Build -> 
      retval := handler_uobjcoll_build cmd_uobjcoll_opts path_ns;

    | `Verify -> 
      retval := handler_uobjcoll_verify cmd_uobjcoll_opts path_ns;

  ;

  (!retval)
;;