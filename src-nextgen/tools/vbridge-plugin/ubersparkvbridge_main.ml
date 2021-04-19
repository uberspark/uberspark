
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
        Ubersparkvbridge_print.output (Printf.sprintf "FINISH functionality : %u" !g_count);

    end;


    if Ubersparkvbridge_options.Casm.get() then begin
        Ubersparkvbridge_options.Casm.set(false);
        Ubersparkvbridge_print.output (Printf.sprintf "Calling CASM extractor...");
        let input_file = Ubersparkvbridge_options.CasmInputFile.get() in
        let output_file = Ubersparkvbridge_options.CasmOutputFile.get() in
            Ubersparkvbridge_print.output (Printf.sprintf "CASM inputfile=%s, outputfile=%s" input_file output_file);
            Ubersparkvbridge_casm.casm_extract input_file output_file;
    end;



    ()

let () = Db.Main.extend run