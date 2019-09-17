(* uberspark front-end command processing logic for command: uobj *)
(* author: amit vasudevan (amitvasudevan@acm.org) *)

open Uslog
open Cmdliner
open Usosservices

(* handler for uobj command *)
let handler_uobj 
  (copts : Commonopts.opts)
  (build : bool)
  (path : 'a option) = 

  (* perform common initialization *)
  Commoninit.initialize copts;


  (* check for required argument PATH/NAMESPACE *)
  match path with
  | None -> 
      `Error (true, "uobj PATH or NAMESPACE must be specified")

  | Some p -> 
    if( build == true ) then
      begin
        let (rval, fullpath) = (Usosservices.abspath p) in
          if(rval == false) then
          begin
            Uslog.log ~lvl:Uslog.Error "could not obtain absolute path for uobj: %s" fullpath;
            ignore (exit 1);
          end
          ;
          
          Uslog.log "absolute path: %s" fullpath;
        
        `Ok ()

      end
    else
      begin
        `Error (true, "--build must be specified")
      end
    ;
  ;



;;