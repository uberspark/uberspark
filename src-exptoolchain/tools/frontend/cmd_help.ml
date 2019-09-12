(* uberspark front-end command processing logic for command: help *)
(* author: amit vasudevan (amitvasudevan@acm.org) *)

open Cmdliner

(* handler for help command *)
let handler_help copts man_format cmds topic = match topic with
| None -> `Help (`Pager, None) (* help about the program. *)
| Some topic ->
		(* let topics = "topics" :: "patterns" :: "environment" :: cmds in *)
		let topics = "topics" :: cmds in 
		let conv, _ = Cmdliner.Arg.enum (List.rev_map (fun s -> (s, s)) topics) in
    match conv topic with
    | `Error e -> `Error (false, e)
    | `Ok t when t = "topics" -> List.iter print_endline cmds; `Ok ()
    | `Ok t when List.mem t cmds -> `Help (man_format, Some t)
    | `Ok t ->
        let page = (topic, 7, "", "", ""), [`S topic; `P "Say something";] in
        `Ok (Cmdliner.Manpage.print man_format Format.std_formatter page)