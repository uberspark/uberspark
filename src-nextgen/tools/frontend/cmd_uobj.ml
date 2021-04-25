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
    Arg.(value & opt (some string) None & info ["p"; "platform"] ~docv:"PLATFORM" ~doc ~docs)
  in
	let arch =
    let doc = "Specify uobj target $(docv)." in
    Arg.(value & opt (some string) None & info ["a"; "arch"] ~docv:"ARCH" ~doc ~docs)
  in
	let cpu =
    let doc = "Specify uobj target $(docv)." in
    Arg.(value & opt (some string) None & info ["c"; "cpu"] ~docv:"CPU" ~doc ~docs)
  in
  Term.(const cmd_uobj_opts_handler $ platform $ arch $ cpu)




(* build action handler *)
let handler_uobj_build
  (cmd_uobj_opts: opts)
  (uobj_path_ns : string)
  =

  if cmd_uobj_opts.platform = "" then
      `Error (true, "uobj PLATFORM must be specified.")
  else if cmd_uobj_opts.arch = "" then
      `Error (true, "uobj ARCH must be specified.")
  else if cmd_uobj_opts.cpu = "" then
      `Error (true, "uobj CPU must be specified.")
  else
    begin
     	let target_def: Uberspark.Defs.Basedefs.target_def_t = 
    		{platform = cmd_uobj_opts.platform; arch = cmd_uobj_opts.arch; cpu = cmd_uobj_opts.cpu} in

      let (rval, uobj) = (Uberspark.Uobj.create_initialize_and_build (uobj_path_ns ^ "/" ^ Uberspark.Namespace.namespace_root_mf_filename) target_def 
        Uberspark.Platform.json_node_uberspark_platform_var.binary.uobj_image_load_address) in
      if (rval) then begin
        Uberspark.Logger.log "uobj build success!";
        `Ok ()
      end else begin
        `Error (false, "uobj build failed!")
      end;

    end
  ;

;;



(* verify action handler *)
let handler_uobj_verify
  (cmd_uobj_opts: opts)
  (uobj_path_ns : string)
  =

  if cmd_uobj_opts.platform = "" then
      `Error (true, "uobj PLATFORM must be specified.")
  else if cmd_uobj_opts.arch = "" then
      `Error (true, "uobj ARCH must be specified.")
  else if cmd_uobj_opts.cpu = "" then
      `Error (true, "uobj CPU must be specified.")
  else
    begin
     	let target_def: Uberspark.Defs.Basedefs.target_def_t = 
    		{platform = cmd_uobj_opts.platform; arch = cmd_uobj_opts.arch; cpu = cmd_uobj_opts.cpu} in

      let (rval, uobj) = (Uberspark.Uobj.create_initialize_and_verify (uobj_path_ns ^ "/" ^ Uberspark.Namespace.namespace_root_mf_filename) target_def 
        Uberspark.Platform.json_node_uberspark_platform_var.binary.uobj_image_load_address) in
      if (rval) then begin
        Uberspark.Logger.log "[SUCCESS] uobj verification!";
        `Ok ()
      end else begin
        `Error (false, "[FAIL] uobj verification!")
      end;

    end
  ;

;;



(* main handler for uobj command *)
let handler_uobj 
  (copts : Commonopts.opts)
  (cmd_uobj_opts: opts)
  (action : [> `Build ] as 'a)
  (path_ns : string)
  : [> `Error of bool * string | `Ok of unit ] = 

  let retval : [> `Error of bool * string | `Ok of unit ] ref = ref (`Ok ()) in

  (* perform common initialization *)
  Commoninit.initialize copts;

  match action with
    | `Build -> 
      retval := handler_uobj_build cmd_uobj_opts path_ns;

    | `Verify -> 
      retval := handler_uobj_verify cmd_uobj_opts path_ns;

  ;

(*  (* initialize bridges *)
  if (Commoninit.initialize_bridges) then 
    begin
  
    end
  else
    begin
      retval := `Error (false, "error in initializing bridges. check your bridge definitions");
    end
  ;
*)
  (!retval)
;;