
let g_count = ref 0;;


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

    if Ubersparkvbridge_options.Start.get() then begin
        g_count := !g_count +1;
        Ubersparkvbridge_options.Start.set(false);
        Uberspark.Logger.log "START functionality : %u" !g_count;
        Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "START functionality : log_level=%u" (!Uberspark.Logger.current_level);
        Ubersparkvbridge_ast.ast_dump ();

    end;


    if Ubersparkvbridge_options.Finish.get() then begin
        g_count := !g_count +1;

        Ubersparkvbridge_options.Finish.set(false);
        Uberspark.Logger.log "FINISH functionality : %u" !g_count;

    end;


    if Ubersparkvbridge_options.Casm.get() then begin
        Ubersparkvbridge_options.Casm.set(false);
        Uberspark.Logger.log "Calling CASM extractor...";
        let input_file = Ubersparkvbridge_options.CasmInputFile.get() in
        let output_file = Ubersparkvbridge_options.CasmOutputFile.get() in
            Uberspark.Logger.log "CASM inputfile=%s, outputfile=%s" input_file output_file;
            Ubersparkvbridge_casm.casm_extract input_file output_file;
    end;



    ()

let () = Db.Main.extend run