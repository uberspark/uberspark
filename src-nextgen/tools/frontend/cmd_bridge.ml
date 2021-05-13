(* uberspark front-end command processing logic for command: bridges *)
(* author: amit vasudevan (amitvasudevan@acm.org) *)

open Uberspark
open Cmdliner

type opts = { 
  ar_bridge: bool;
  as_bridge: bool;
  cc_bridge: bool;
  ld_bridge: bool;
  pp_bridge: bool;
  vf_bridge: bool;
  loader_bridge: bool;
  build: bool;
  output_directory: string option;
  bridge_exectype : string option;
};;

(* fold all bridges options into type opts *)
let cmd_bridge_opts_handler 
  (ar_bridge: bool)
  (as_bridge: bool)
  (cc_bridge: bool)
  (ld_bridge: bool)
  (pp_bridge: bool)
  (vf_bridge: bool)
  (loader_bridge: bool)
  (build : bool)
  (output_directory: string option)
  (bridge_exectype : string option)
  : opts = 
  { ar_bridge=ar_bridge;
    as_bridge=as_bridge;
    cc_bridge=cc_bridge;
    ld_bridge=ld_bridge;
    pp_bridge=pp_bridge;
    vf_bridge=vf_bridge;
    loader_bridge=loader_bridge;
    build=build;
    output_directory=output_directory;
    bridge_exectype=bridge_exectype;
  }
;;

(* handle bridges command options *)
let cmd_bridge_opts_t =
  let docs = "ACTION OPTIONS" in
  
  let ar_bridge =
  let doc = "Select archiver (ar) bridge namespace prefix." in
  Arg.(value & flag & info ["ar"; "ar-bridge"] ~doc ~docs)
  in

  let as_bridge =
  let doc = "Select assembler (as) bridge namespace prefix." in
  Arg.(value & flag & info ["as"; "as-bridge"] ~doc ~docs)
  in

  let cc_bridge =
  let doc = "Select compiler (cc) bridge namespace prefix." in
  Arg.(value & flag & info ["cc"; "cc-bridge"] ~doc ~docs)
  in

  let ld_bridge =
  let doc = "Select linker (ld) bridge namespace prefix." in
  Arg.(value & flag & info ["ld"; "ld-bridge"] ~doc ~docs)
  in

  let pp_bridge =
  let doc = "Select pre-processor (pp) bridge namespace prefix." in
  Arg.(value & flag & info ["pp"; "pp-bridge"] ~doc ~docs)
  in

  let vf_bridge =
  let doc = "Select verification (vf) bridge namespace prefix." in
  Arg.(value & flag & info ["vf"; "vf-bridge"] ~doc ~docs)
  in

  let loader_bridge =
  let doc = "Select loader bridge namespace prefix." in
  Arg.(value & flag & info ["loader"; "loader-bridge"] ~doc ~docs)
  in

  let build =
  let doc = "Build the bridge if bridge execution type is 'container'" in
  Arg.(value & flag & info ["b"; "build"] ~doc ~docs)
  in

  let output_directory =
    let doc = "Select output directory, $(docv)."  in
      Arg.(value & opt (some string) None & info ["o"; "output-directory"] ~docs ~docv:"DIR" ~doc)
  in

  let bridge_exectype =
    let doc = "Select bridge execution $(docv)."  in
      Arg.(value & opt (some string) None & info ["bet"; "bridge-exectype"] ~docs ~docv:"TYPE" ~doc)
  in


  Term.(const cmd_bridge_opts_handler $ ar_bridge $ as_bridge $ cc_bridge $ ld_bridge $ pp_bridge $ vf_bridge $ loader_bridge $ build $ output_directory $ bridge_exectype)




(* bridges create action *)
let handler_bridges_action_create 
  (p_copts: Commonopts.opts)
  (cmd_bridges_opts: opts)
  (path_ns : string option)
  : [> `Error of bool * string | `Ok of unit ] = 

  let retval : [> `Error of bool * string | `Ok of unit ] ref = ref (`Ok ()) in

  (* initialize console logging *)
  Common.initialize_logging p_copts;

  (* TBD: future expansion 
    plug in bridge create functionality to take a json and
   add it to the appropriate bridge folder 
  *)

  (!retval)
;;


(* bridges dump action *)
let handler_bridges_action_dump 
  (p_copts: Commonopts.opts)
  (cmd_bridges_opts: opts)
  (path_ns : string option)
  : [> `Error of bool * string | `Ok of unit ] = 

    let retval : [> `Error of bool * string | `Ok of unit ] ref = ref (`Ok ()) in

  (* initialize console logging *)
  Common.initialize_logging p_copts;

    (* check to see if we have path_ns spcified *)
    let l_path_ns = ref "" in
    let l_output_directory = ref "" in
    let l_bridge_exectype = ref "" in

    let bridge_ns_prefix = ref "" in

    match path_ns with
    | None -> 
        begin
          retval := `Error (true, "need bridge $(i,NAMESPACE) argument");
          (!retval)
        end

    | Some path_ns_qname -> 
        begin
          l_path_ns := path_ns_qname;

          (* 
            TBD: use the namespace and Uberspark.Bridge. to 
            dump the bridge files

            begin
              (* dump the bridge configuration and container files if any *)          
              let bridge_ns_path = (!bridge_ns_prefix ^ "/" ^ !l_bridge_exectype ^ 
              "/" ^ !l_path_ns) in 
                Uberspark.Bridge.dump bridge_ns_path ~bridge_exectype:!l_bridge_exectype !l_output_directory;
              Uberspark.Logger.log "Successfully dumped bridge definitions to directory: '%s'" !l_output_directory;
            end

          *)

          (!retval)

          end
;;


(* bridges config action *)
let handler_bridges_action_config 
  (p_copts: Commonopts.opts)
  (cmd_bridges_opts: opts)
  (path_ns : string option)
  : [> `Error of bool * string | `Ok of unit ] = 

    let retval : [> `Error of bool * string | `Ok of unit ] ref = ref (`Ok ()) in

  (* initialize console logging *)
  Common.initialize_logging p_copts;

    let l_path_ns = ref "" in
    let bridge_ns_prefix = ref "" in
    let bridge_type = ref [] in 

    match path_ns with
    | None -> 
        begin
          retval := `Error (true, "need bridge $(i,NAMESPACE) argument");
          (!retval)
        end

    | Some path_ns_qname -> 
        begin
          l_path_ns := path_ns_qname;

          (* 
            TBD: use the namespace and Uberspark.Bridge. to create
            a new bridge object, load and build the container 
            
            if (Uberspark.Bridge.ld_bridge#load bridge_ns) then begin
            Uberspark.Logger.log "loaded ld-bridge settings";
            if ( Uberspark.Bridge.ld_bridge#build () ) then begin
              retval := `Ok();
            end else begin
              retval := `Error (false, "could not build ld-bridge!");
            end;
          end else begin
            retval := `Error (false, "unable to load ld-bridge settings!");
          end
          ;  

          *)

   

          (!retval)

        end
;;


(* bridges remove action *)
let handler_bridges_action_remove 
  (p_copts: Commonopts.opts)
  (cmd_bridges_opts: opts)
  (path_ns : string option)
  : [> `Error of bool * string | `Ok of unit ] = 

    let retval : [> `Error of bool * string | `Ok of unit ] ref = ref (`Ok ()) in

  (* initialize console logging *)
  Common.initialize_logging p_copts;

    let l_path_ns = ref "" in
    let l_bridge_exectype = ref "" in

    let bridge_ns_prefix = ref "" in

    match path_ns with
    | None -> 
        begin
          retval := `Error (true, "need bridge $(i,NAMESPACE) argument");
          (!retval)
        end

    | Some path_ns_qname -> 
        begin
          l_path_ns := path_ns_qname;

          (* 
            TBD: use the namespace and remove actual directory
            name via Uberspark.Namespace. and Uberpark.Osservices.
          *)

          (!retval)
        end
       
;;


(*
 retval := `Error (true, "need $(b,--bridge-exectype) action option");
*)
 


(* main handler for bridges command *)
let handler_bridge 
  (p_copts: Commonopts.opts)
  (cmd_bridges_opts: opts)
  (action : [> `Config | `Create | `Dump | `Remove] as 'a)
  (path_ns : string option)
  : [> `Error of bool * string | `Ok of unit ] = 

  let retval : [> `Error of bool * string | `Ok of unit ] ref = ref (`Ok ()) in

  match action with
    | `Config -> 
 
      retval := handler_bridges_action_config p_copts cmd_bridges_opts path_ns;

    | `Create -> 
      retval := handler_bridges_action_create p_copts cmd_bridges_opts path_ns;

    | `Dump ->

      retval := handler_bridges_action_dump p_copts cmd_bridges_opts path_ns;


    | `Remove -> 

      retval := handler_bridges_action_remove p_copts cmd_bridges_opts path_ns;

  ;

    (!retval)


;;