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

    Uberspark.Context.initialize ~p_log_level:!Uberspark.Logger.current_level
        ~p_print_banner:false 
        (Casmbridge_options.RootDir.get())
        (Casmbridge_options.StagingDir.get())        
        (Casmbridge_options.UobjcollPlatformNamespace.get()) [];

    (* bail out if we are unable to process uobjcoll manifest *)
    if not (Uberspark.Context.process_uobjcoll_manifest ~p_only_stateinit:true
        (Casmbridge_options.UobjcollNamespace.get()) [] []) then begin
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