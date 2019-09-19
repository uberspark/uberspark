(* uberspark front-end command processing logic for command: uobj *)
(* author: amit vasudevan (amitvasudevan@acm.org) *)

open Ustypes
open Usconfig
open Uslog
open Cmdliner
open Usosservices
open Usuobj


(* -b, --build option handler *)
let handler_uobj_build
  (uobj_path_ns : string)
  =

  (* grab absolute path for uobj path/namespace *)
  let (rval, abs_uobj_path_ns) = (Usosservices.abspath uobj_path_ns) in
  if(rval == false) then
  begin
    Uslog.log ~lvl:Uslog.Error "could not obtain absolute path for uobj: %s" abs_uobj_path_ns;
    ignore (exit 1);
  end
  ;

  (* create uobj instance and parse manifest *)
  let uobj = new Usuobj.uobject in
  let uobj_mf_filename = (abs_uobj_path_ns ^ Usconfig.env_path_seperator ^ Usconfig.namespace_default_uobj_mf_filename) in
  Uslog.log "parsing uobj manifest: %s" uobj_mf_filename;
  let rval = (uobj#parse_manifest uobj_mf_filename true) in	
  if (rval == false) then
    begin
      Uslog.log ~lvl:Uslog.Error "unable to stat/parse manifest for uobj: %s" uobj_mf_filename;
      ignore (exit 1);
    end
  ;

  Uslog.log "successfully parsed uobj manifest";
  uobj#initialize {f_platform = ""; f_arch = ""; f_cpu = ""};

`Ok ()

;;


(* main handler for uobj command *)
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
          (handler_uobj_build p)
      end
    else
      begin
        `Error (true, "--build must be specified")
      end
    ;
  ;



;;