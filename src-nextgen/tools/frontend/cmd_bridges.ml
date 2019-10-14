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
  output_directory: string option;
};;

(* fold all bridges options into type opts *)
let cmd_bridges_opts_handler 
  (ar_bridge: bool)
  (as_bridge: bool)
  (cc_bridge: bool)
  (ld_bridge: bool)
  (pp_bridge: bool)
  (vf_bridge: bool)
  (output_directory: string option)
  : opts = 
  { ar_bridge=ar_bridge;
    as_bridge=as_bridge;
    cc_bridge=cc_bridge;
    ld_bridge=ld_bridge;
    pp_bridge=pp_bridge;
    vf_bridge=vf_bridge;
    output_directory=output_directory
  }
;;

(* handle bridges command options *)
let cmd_bridges_opts_t =
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

  let output_directory =
    let doc = "Select output directory, $(docv)."  in
      Arg.(value & opt (some string) None & info ["o"; "output-directory"] ~docs ~docv:"DIR" ~doc)
  in

  Term.(const cmd_bridges_opts_handler $ ar_bridge $ as_bridge $ cc_bridge $ ld_bridge $ pp_bridge $ vf_bridge $ output_directory)




(* bridges create action *)
let handler_bridges_action_create 
  (copts : Commonopts.opts)
  (cmd_bridges_opts: opts)
  (path_ns : string option)
  = 

    (* perform common initialization *)
    Commoninit.initialize copts;

    (* check to see if we have path_ns spcified *)
    let l_path_ns = ref "" in
    match path_ns with
    | None -> `Error (true, "need $(i,PATH) to bridge definition file")
    | Some sname -> 
      begin
          l_path_ns := sname;

          (* load the bridge settings from the file *)
          Uberspark.Bridge.load_from_file !l_path_ns;

          let bridgetypes = ref [] in 
          
          if cmd_bridges_opts.ar_bridge then
            bridgetypes := !bridgetypes @ [ Uberspark.Config.namespace_bridges_ar_bridge_name ];
          

          if cmd_bridges_opts.as_bridge then
            bridgetypes := !bridgetypes @ [ Uberspark.Config.namespace_bridges_as_bridge_name ];
          

          if cmd_bridges_opts.cc_bridge then
            bridgetypes := !bridgetypes @ [ Uberspark.Config.namespace_bridges_cc_bridge_name ];
          

          if cmd_bridges_opts.ld_bridge then
            bridgetypes := !bridgetypes @ [ Uberspark.Config.namespace_bridges_ld_bridge_name ];
          

          if cmd_bridges_opts.pp_bridge then
            bridgetypes := !bridgetypes @ [ Uberspark.Config.namespace_bridges_pp_bridge_name ];
          

          if cmd_bridges_opts.vf_bridge then
            bridgetypes := !bridgetypes @ [ Uberspark.Config.namespace_bridges_vf_bridge_name ];
          

          if ( List.length !bridgetypes == 0 ) then
            bridgetypes := [ Uberspark.Config.namespace_bridges_ar_bridge_name; 
            Uberspark.Config.namespace_bridges_as_bridge_name; 
            Uberspark.Config.namespace_bridges_cc_bridge_name; 
            Uberspark.Config.namespace_bridges_ld_bridge_name; 
            Uberspark.Config.namespace_bridges_pp_bridge_name; 
            Uberspark.Config.namespace_bridges_vf_bridge_name; 
            ];
          
          Uberspark.Bridge.store_settings_to_namespace !bridgetypes;
         `Ok()
      end
;;


(* bridges dump action *)
let handler_bridges_action_dump 
  (copts : Commonopts.opts)
  (cmd_bridges_opts: opts)
  (path_ns : string option)
  : [> `Error of bool * string | `Ok of unit ] = 

    let retval : [> `Error of bool * string | `Ok of unit ] ref = ref (`Ok ()) in

    (* perform common initialization *)
    Commoninit.initialize copts;

    (* check to see if we have path_ns spcified *)
    let l_path_ns = ref "" in
    let bridge_ns_prefix = ref "" in
    match path_ns with
    | None -> 
      retval := `Error (true, "need bridge $(i,NAMESPACE) argument");
      (!retval)
    | Some sname -> 
      begin
          l_path_ns := sname;
          let action_options_unspecified = ref false in 
(*
          if cmd_bridges_opts.ar_bridge then
            bridge_ns_prefix := Uberspark.Config.namespace_bridges_ar_bridge;
          else if cmd_bridges_opts.as_bridge then
            bridge_ns_prefix := Uberspark.Config.namespace_bridges_as_bridge;
          else if cmd_bridges_opts.cc_bridge then
            bridge_ns_prefix := Uberspark.Config.namespace_bridges_cc_bridge;
          else if cmd_bridges_opts.ld_bridge then
            bridge_ns_prefix := Uberspark.Config.namespace_bridges_ld_bridge;
          else if cmd_bridges_opts.pp_bridge then
            bridge_ns_prefix := Uberspark.Config.namespace_bridges_pp_bridge;
          else if cmd_bridges_opts.vf_bridge then
            bridge_ns_prefix := Uberspark.Config.namespace_bridges_vf_bridge;
          else 
            action_options_unspecified := true;
 *)                   

(*              `Error (true, "need one of the following action options: $(b,-ar), $(b,-as), $(b,-cc), $(b,-ld), $(b,-pp), and $(b,-vf)")


          (* dump the bridge configuration and container files if any *)          
          let bride_ns_path = (bridge_ns_prefix ^ "/" ^ l_path_ns) in 
          Uberspark.Bridge.dump bridge_ns_path cmd_bridges_opts.output_directory;
*)
        (!retval)
      end
    

    
;;


(* main handler for bridges command *)
let handler_bridges 
  (copts : Commonopts.opts)
  (cmd_bridges_opts: opts)
  (action : [> `Create | `Dump | `Rebuild | `Remove] as 'a)
  (path_ns : string option)
  = 

  let retval = 
  match action with
    | `Create -> 

      (handler_bridges_action_create copts cmd_bridges_opts path_ns)


    | `Dump ->

      (handler_bridges_action_dump copts cmd_bridges_opts path_ns)


    | `Rebuild -> 
 
      (* perform common initialization *)
      Commoninit.initialize copts;
      `Ok()
 


    | `Remove -> 

      (* perform common initialization *)
      Commoninit.initialize copts;
      `Ok()
        
  in

  retval

;;