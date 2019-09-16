(* uberspark front-end (command agnostic) common options handling *)
(* author: amit vasudevan (amitvasudevan@acm.org) *)


open Uslog
open Cmdliner

type opts = { log_level : int} 

(* fold verbosity and log level into a single logging level *)
let handler_opts 
  (verb : int)
  (loglvl : int)
  : opts = 
  if verb <= loglvl then
    begin
      let log_level = verb in
        { log_level }
    end
  else
    begin
      let log_level = loglvl in
        { log_level }
    end
  ;
;;

(* handle common options *)
let opts_t =
  let docs = Manpage.s_common_options in
  let verb =
    let doc = "Suppress all output logging. Same as `$(b,--log-level)=0'" in
    let quiet = (Uslog.ord Uslog.None), Arg.info ["q"; "quiet"] ~docs ~doc in
		let doc = "Give verbose output. Same as `$(b,--log-level)=5'" in
    let verbose = (Uslog.ord Uslog.Debug), Arg.info ["v"; "verbose"] ~docs ~doc in
      Arg.(last & vflag_all [(Uslog.ord Uslog.Info)] [quiet; verbose])
  in
  let loglvl =
    let doc = "Set output logging level to $(docv). All output log messages less than or equal to $(docv) will be printed to the standard output. $(docv) can be `5' (Debug), `4' (Info), `3' (Warn), `2' (Error), `1' (Stdoutput), or `0' (None)"  in
      Arg.(value & opt int (Uslog.ord Uslog.Info) & info ["log-level"] ~docs ~docv:"VAL" ~doc)
  in
  Term.(const handler_opts $ verb $ loglvl)
