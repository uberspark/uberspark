(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* logging related functionality *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)

let log_print_string_backend
	(p_str : string) :
	unit =
    Ubersparkvbridge_options.Self.result "%s" p_str;
    ()
;;

(* initialize logging interface *)
let initialize_logging () : unit =
    Uberspark.Logger.log_tag := ""; (* no tag, since frama-c will print out plugin short name *)
    Uberspark.Logger.log_print_string_fn := log_print_string_backend;
    Uberspark.Logger.current_level := Ubersparkvbridge_options.LogLevel.get();
;;

(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)



(* this segment is called initially and 
    for every -then when frama-c is invokved 
    each parameter processing can turn off the flag if need be so that
    subsequent -then segments do not see it
*)
let run () =
    initialize_logging ();
    Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "vf-bridge plugin: uobjcoll namespace=%s" (Ubersparkvbridge_options.UobjcollNamespace.get());
    Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "vf-bridge plugin: uobjcoll platform namespace=%s" (Ubersparkvbridge_options.UobjcollPlatformNamespace.get());
    Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "vf-bridge plugin: root-dir=%s" (Ubersparkvbridge_options.RootDir.get());
    Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "vf-bridge plugin: staging-dir=%s" (Ubersparkvbridge_options.StagingDir.get());

    (* this currently adds CASM call and return 
    glue, dumps AST and runs abstract interpretation
    engine *)
    Ubersparkvbridge_ast.ast_dump ();

    ()

let () = Db.Main.extend run