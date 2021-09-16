
let g_count = ref 0;;


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

    if Casmbridge_options.Start.get() then begin
        g_count := !g_count +1;
        Casmbridge_options.Start.set(false);
        Uberspark.Logger.log "START functionality : %u" !g_count;
        Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "START functionality : log_level=%u" (!Uberspark.Logger.current_level);
        Casmbridge_ast.ast_dump ();

    end;


    if Casmbridge_options.Finish.get() then begin
        g_count := !g_count +1;

        Casmbridge_options.Finish.set(false);
        Uberspark.Logger.log "FINISH functionality : %u" !g_count;

    end;


    if Casmbridge_options.Casm.get() then begin
        Casmbridge_options.Casm.set(false);
        Uberspark.Logger.log "Calling CASM extractor...";
        let input_file = Casmbridge_options.CasmInputFile.get() in
        let output_file = Casmbridge_options.CasmOutputFile.get() in
            Uberspark.Logger.log "CASM inputfile=%s, outputfile=%s" input_file output_file;
            Casmbridge_gensrc.casm_extract input_file output_file;
    end;



    ()

let () = Db.Main.extend run