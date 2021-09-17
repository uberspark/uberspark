(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* logging related functionality *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)

let log_print_string_backend
	(p_str : string) :
	unit =
    Casmbridge_options.Self.result "%s" p_str;
    ()
;;

(* initialize logging interface *)
let initialize_logging () : unit =
    Uberspark.Logger.log_tag := ""; (* no tag, since frama-c will print out plugin short name *)
    Uberspark.Logger.log_print_string_fn := log_print_string_backend;
    Uberspark.Logger.current_level := Casmbridge_options.LogLevel.get();
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
    Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "CASM: uobjcoll namespace=%s" (Casmbridge_options.UobjcollNamespace.get());
    Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "CASM: uobjcoll platform namespace=%s" (Casmbridge_options.UobjcollPlatformNamespace.get());
    Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "CASM: root-dir=%s" (Casmbridge_options.RootDir.get());
    Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "CASM: staging-dir=%s" (Casmbridge_options.StagingDir.get());

    if Casmbridge_options.CasmGenasm.get() then begin
        Casmbridge_options.CasmGenasm.set(false);
        Uberspark.Logger.log "CASM: Generating Assembly code...";
        let input_file = Casmbridge_options.CasmInputFile.get() in
        let output_file = Casmbridge_options.CasmOutputFile.get() in
            Uberspark.Logger.log "inputfile=%s, outputfile=%s" input_file output_file;
            Casmbridge_gensrc.casm_extract input_file output_file;
    end;


    if Casmbridge_options.CasmGenc.get() then begin
        Casmbridge_options.CasmGenc.set(false);
        Uberspark.Logger.log "CASM: Generating C code with HWM embedding...";
        let input_file = Casmbridge_options.CasmInputFile.get() in
        let output_file = Casmbridge_options.CasmOutputFile.get() in
            Uberspark.Logger.log "inputfile=%s, outputfile=%s" input_file output_file;
            Casmbridge_gensrc.casm_genc input_file output_file;
    end;


    ()

let () = Db.Main.extend run