(* uberspark front-end command processing logic for command: bridges *)
(* author: amit vasudevan (amitvasudevan@acm.org) *)

open Uberspark
open Cmdliner

type opts = { 
  build: bool;
  output_directory: string option;
  bridge_exectype : string option;
};;

(* fold all bridges options into type opts *)
let cmd_bridge_opts_handler 
  (build : bool)
  (output_directory: string option)
  (bridge_exectype : string option)
  : opts = 
  { 
    
    build=build;
    output_directory=output_directory;
    bridge_exectype=bridge_exectype;
  }
;;

(* handle bridges command options *)
let cmd_bridge_opts_t =
  let docs = "ACTION OPTIONS" in
  

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


  Term.(const cmd_bridge_opts_handler $ build $ output_directory $ bridge_exectype)




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

          let l_bridge_object : Uberspark.Bridge.bridge_object = new Uberspark.Bridge.bridge_object in
          let l_rval = (l_bridge_object#load !l_path_ns) in

  				if l_rval then begin

            (* if bridge cateogory is container, then build the bridge *)
            if (l_bridge_object#get_json_node_uberspark_bridge_var).category = "container" then begin
              if not (l_bridge_object#build ()) then begin
                retval := `Error (false, "could not build bridge!");
              end else begin
                retval := `Ok();
              end;
            end;
 
          end else begin
            retval := `Error (false, "unable to load bridge manifest!");
          end
          ;  


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

  (* initialize operation context *)
  Common.initialize_operation_context p_copts;
  
  if (Common.setup_namespace_root_directory ()) then begin

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

  end else begin
    retval := `Error (false, "unable to load installation configuration!");
  end;

  (!retval)

;;