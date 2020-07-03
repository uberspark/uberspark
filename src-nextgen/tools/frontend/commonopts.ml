(* uberspark front-end (command agnostic) common options handling *)
(* author: amit vasudevan (amitvasudevan@acm.org) *)


open Uberspark
open Cmdliner

type opts = { 
  mutable log_level : int;
  mutable root_dir : string;
  } 

(* fold verbosity and log level into a single logging level *)
let handler_opts 
  (verb : int)
  (loglvl : int)
  (rootdir : string option)
  : opts = 
  Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "verb=%u, loglvl=%u" verb loglvl;

  let l_rootdir = ref "" in

  match rootdir with
  | None -> 
    (*l_rootdir := Unix.getenv "HOME";*)
    l_rootdir := "";
  | Some l_str ->
    l_rootdir := l_str;
  ;


  if verb == 0 then 
    begin
      { log_level=0; root_dir = !l_rootdir; }
    end
  else if verb == 5 then
    begin
      { log_level=5 ; root_dir = !l_rootdir; }
    end
  else if verb < loglvl then
    begin
      { log_level=verb ; root_dir = !l_rootdir; }
    end
  else
    begin
      { log_level=loglvl ; root_dir = !l_rootdir; }
    end
  ;
;;

(* handle common options *)
let opts_t =
  let docs = Manpage.s_common_options in
  let verb =
    let doc = "Suppress all output logging. Same as `$(b,--log-level)=0'" in
    let quiet = (Uberspark.Logger.ord Uberspark.Logger.None), Arg.info ["q"; "quiet"] ~docs ~doc in
		let doc = "Give verbose output. Same as `$(b,--log-level)=5'" in
    let verbose = (Uberspark.Logger.ord Uberspark.Logger.Debug), Arg.info ["v"; "verbose"] ~docs ~doc in
      Arg.(last & vflag_all [(Uberspark.Logger.ord Uberspark.Logger.Info)] [quiet; verbose])
  in
  let loglvl =
    let doc = "Set output logging level to $(docv). All output log messages less than or equal to $(docv) will be printed to the standard output. $(docv) can be `5' (Debug), `4' (Info), `3' (Warn), `2' (Error), `1' (Stdoutput), or `0' (None)"  in
      Arg.(value & opt int (Uberspark.Logger.ord Uberspark.Logger.Info) & info ["log-level"] ~docs ~docv:"VAL" ~doc)
  in
  let rootdir =
    let doc = "Use root directory $(docv) as namespace root folder."  in
      Arg.(value & opt (some string) None & info ["rd"; "root-dir"] ~docs ~docv:"DIR" ~doc)
  in

  Term.(const handler_opts $ verb $ loglvl $ rootdir)
