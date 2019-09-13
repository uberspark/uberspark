(* uberspark front-end common types *)
(* author: amit vasudevan (amitvasudevan@acm.org) *)


open Uslog
open Cmdliner

type g_copts = { log_level : Uslog.log_level}


let g_copts log_level = { log_level };;

let pr_g_copts oc copts = 
	Printf.fprintf oc "log_level = %u\n" (Uslog.ord copts.log_level);
	();
;;

let g_copts_t =
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
  Term.(const g_copts $ verb)
