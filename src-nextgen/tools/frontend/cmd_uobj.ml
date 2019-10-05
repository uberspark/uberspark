(* uberspark front-end command processing logic for command: uobj *)
(* author: amit vasudevan (amitvasudevan@acm.org) *)

(*open Ustypes
open Usconfig
open Uslog
open Cmdliner
open Usosservices
open Usuobj
*)

open Uberspark
open Cmdliner

(* -b, --build option handler *)
let handler_uobj_build
  (platform : 'a option)
  (arch : 'a option)
  (cpu : 'a option)
  (uobj_path_ns : string)
  =


  match platform with
  | None -> 
      `Error (true, "uobj PLATFORM must be specified.")

  | Some str_platform ->
    match arch with
    | None -> 
        `Error (true, "uobj ARCH must be specified.")

    | Some str_arch ->
      match cpu with
      | None -> 
          `Error (true, "uobj CPU must be specified.")
    
      | Some str_cpu ->
  
          let (rval, abs_uobj_path_ns) = (Uberspark.Osservices.abspath uobj_path_ns) in
          if(rval == false) then
          begin
            Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "could not obtain absolute path for uobj: %s" abs_uobj_path_ns;
            ignore (exit 1);
          end
          ;

          (* create uobj instance and parse manifest *)
          let uobj = new Uberspark.Uobj.uobject in
          let uobj_mf_filename = (abs_uobj_path_ns ^ "/" ^ Uberspark.Config.namespace_default_uobj_mf_filename) in
          Uberspark.Logger.log "parsing uobj manifest: %s" uobj_mf_filename;
          let rval = (uobj#parse_manifest uobj_mf_filename true) in	
          if (rval == false) then
            begin
              Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "unable to stat/parse manifest for uobj: %s" uobj_mf_filename;
              ignore (exit 1);
            end
          ;

          Uberspark.Logger.log "successfully parsed uobj manifest";
          (*TBD: validate platform, arch, cpu target def with uobj target spec*)

          let target_def: Uberspark.Defs.Basedefs.target_def_t = {f_platform = str_platform; f_arch = str_arch; f_cpu = str_cpu} in
            uobj#initialize target_def;

      ;
    ;
  ;            


`Ok ()

;;


(* main handler for uobj command *)
let handler_uobj 
  (copts : Commonopts.opts)
  (build : bool)
  (platform : 'a option) 
  (arch : 'a option) 
  (cpu : 'a option) 
 (* (path : 'a option) = *)
  path = 


  (* perform common initialization *)
  Commoninit.initialize copts;


  (* check for required argument PATH/NAMESPACE *)
  (*match path with
  | None -> 
      `Error (true, "uobj PATH or NAMESPACE must be specified")

  | Some p -> *)
    if( build == true ) then
      begin
          (*(handler_uobj_build platform arch cpu p)*)
          (handler_uobj_build platform arch cpu path)
      end
    else
      begin
        `Error (true, "--build must be specified")
      end
    ;
 (* ;*)



;;