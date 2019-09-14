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
  Commoninit.initialize copts;
  Uslog.log "build=%B" build;
  (*Printf.printf "path = %s\n" path;*)
  match path with
  | None -> Uslog.log "path=none";
      `Error (true, "one of build, verify must be specified")

  | Some p -> Uslog.log "path: %s" p;
      `Ok ()
  ;
(* )  let page = ("RESULT", 7, "", "", ""), [`S "RESULT"; `P "Say something";] in
  `Ok (Cmdliner.Manpage.print `Plain Format.std_formatter page)
*)
(* `Error (false, "Whatcha") *)
;;