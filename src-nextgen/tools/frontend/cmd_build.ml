(* uberspark front-end command processing logic for command: uobjcoll *)
(* author: amit vasudevan (amitvasudevan@acm.org) *)

open Uberspark
open Cmdliner

type opts = { 
  loaders : bool; 
};;

(* fold all build options into type opts *)
let cmd_build_opts_handler 
  (p_loaders : bool)
  : opts = 
  
  { loaders = p_loaders; }
;;


(* handle build command specific options *)
let cmd_build_opts_t =
  let docs = "BUILD OPTIONS" in

	let loaders =
    let doc = "Build only üobjcoll loaders." in
    Arg.(value & flag & info ["l"; "loaders"] ~doc ~docs)

  in
  Term.(const cmd_build_opts_handler $ loaders)



(* build command handler *)
let handler_build
    (p_copts : Commonopts.opts)
    (p_cmd_build_opts: opts)
  =

    Uberspark.Logger.log "build command handler: loaders=%b" p_cmd_build_opts.loaders;
    `Ok ()
;;

