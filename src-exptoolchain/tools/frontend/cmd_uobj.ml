(* uberspark front-end command processing logic for command: uobj *)
(* author: amit vasudevan (amitvasudevan@acm.org) *)

open Uslog
open Cmdliner
(*
type g_copts = { log_level : Uslog.log_level}

let pr_g_copts oc copts = 
	Printf.fprintf oc "log_level = %u\n" (Uslog.ord copts.log_level);
	();
;;
*)

(* handler for uobj command *)

let handler_uobj 
  (copts : Commonopts.opts)
  (build : bool)
  (path : 'a option) = 
  Uslog.current_level := (Uslog.ord copts.log_level);
  Printf.printf "build=%B" build; print_newline ();
  Uslog.log "build=%B" build;
  (*Printf.printf "path = %s\n" path;*)
  match path with
  | None -> Printf.printf "none"; print_newline ();
      `Error (true, "one of build, verify must be specified")

  | Some p -> Printf.printf "specified: %s" p; print_newline();
      `Ok ()
  ;
(* )  let page = ("RESULT", 7, "", "", ""), [`S "RESULT"; `P "Say something";] in
  `Ok (Cmdliner.Manpage.print `Plain Format.std_formatter page)
*)
(* `Error (false, "Whatcha") *)
;;