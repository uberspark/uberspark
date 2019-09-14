(* uberspark front-end command processing logic for command: help *)
(* author: amit vasudevan (amitvasudevan@acm.org) *)

open Uslog
open Cmdliner

(* handler for help command *)
let handler_help 
  (copts : Commonopts.opts)
  man_format cmds topic = 
  Commoninit.initialize copts;
  match topic with
    | None -> `Help (`Pager, None) (* help about the program. *)
    | Some topic ->
		  let topics = "topics" :: cmds in 
		  let conv, _ = Cmdliner.Arg.enum (List.rev_map (fun s -> (s, s)) topics) in
      match conv topic with
        | `Error e -> `Error (false, e)
        | `Ok t when t = "topics" -> Uslog.log "help is available for the following COMMANDs:";
                                      List.iter (fun x ->
                                          Uslog.log "%s" x;
                                      )  cmds; 
                                      Uslog.log "use uberspark help COMMAND or uberspark COMMAND --help";
                                      `Ok ()
        | `Ok t when List.mem t cmds -> `Help (man_format, Some t)
        | `Ok t ->
          let page = (topic, 7, "", "", ""), [`S topic; `P "Cowabunga!";] in
          `Ok (Cmdliner.Manpage.print man_format Format.std_formatter page)