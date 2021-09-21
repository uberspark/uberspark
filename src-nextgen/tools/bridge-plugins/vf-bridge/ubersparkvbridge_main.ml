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

    Uberspark.Context.initialize ~p_log_level:!Uberspark.Logger.current_level
        ~p_print_banner:false 
        (Ubersparkvbridge_options.RootDir.get())
        (Ubersparkvbridge_options.StagingDir.get())        
        (Ubersparkvbridge_options.UobjcollPlatformNamespace.get()) [];

    (* bail out if we are unable to process uobjcoll manifest *)
    if not (Uberspark.Context.process_uobjcoll_manifest ~p_only_stateinit:true
        (Ubersparkvbridge_options.UobjcollNamespace.get()) [] []) then begin
        Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "unable to process uobjcoll manifest!";
        ignore(exit 1);
    end;

    (* debug: print the number of hwms associated with the uobjcoll *)
    Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "number of hwms for uobjcoll=%u" (List.length (Uberspark.Context.get_hwm_manifest_var_assoc_list ()));
    let l_cpu_hwm_manifest_var = Uberspark.Context.get_hwm_manifest_var_cpu () in 
    Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "cpu arch=%s, addressing=%s, model=%s" 
        l_cpu_hwm_manifest_var.hwm.cpu.arch
        l_cpu_hwm_manifest_var.hwm.cpu.addressing
        l_cpu_hwm_manifest_var.hwm.cpu.model;

    Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "cpu hwm casm_instructions count=%u"
        (List.length l_cpu_hwm_manifest_var.hwm.cpu.casm_instructions); 

    (* this currently adds CASM call and return 
    glue, dumps AST and runs abstract interpretation
    engine *)
    Ubersparkvbridge_ast.ast_dump ();

    ()

let () = Db.Main.extend run