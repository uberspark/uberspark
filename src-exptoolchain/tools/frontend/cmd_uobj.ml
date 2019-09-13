(* uberspark front-end command processing logic for command: uobj *)
(* author: amit vasudevan (amitvasudevan@acm.org) *)

open Uslog
open Cmdliner

(* handler for uobj command *)

let handler_uobj copts build path = 
  Printf.printf "build=%B\n" build;
  (*Printf.printf "log_level = %u\n"  (Uslog.ord copts.log_level);*)
  (*Printf.printf "path = %s\n" path;*)
  match path with
  | None -> Printf.printf "none\n"
  | Some p -> Printf.printf "specified: %s\n" p
  ;
  ()
;;