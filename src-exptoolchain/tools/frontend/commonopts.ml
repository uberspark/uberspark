(* uberspark front-end (command agnostic) common options handling *)
(* author: amit vasudevan (amitvasudevan@acm.org) *)


open Uslog
open Cmdliner

type opts = { log_level : Uslog.log_level}


let opts log_level = { log_level };;

let opts_t =
  let docs = Manpage.s_common_options in
  let verb =
    let doc = "Suppress all informational output." in
    let quiet = Uslog.None, Arg.info ["q"; "quiet"] ~docs ~doc in
    (*let doc = "Give verbose output." in
    Arg.(value & opt (some string) None & info ["prehook"] ~docs ~doc)
		*)
		let doc = "Give verbose output." in
    let verbose = Uslog.Debug, Arg.info ["v"; "verbose"] ~docs ~doc in
    Arg.(last & vflag_all [Uslog.Info] [quiet; verbose])
  in
  Term.(const opts $ verb)
