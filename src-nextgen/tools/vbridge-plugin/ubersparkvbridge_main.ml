
let g_count = ref 0;;

(* this segment is called initially and 
    for every -then when frama-c is invokved 
    each parameter processing can turn off the flag if need be so that
    subsequent -then segments do not see it
*)
let run () =
    if Ubersparkvbridge_options.Start.get() then begin
        g_count := !g_count +1;
        Ubersparkvbridge_options.Start.set(false);
        Ubersparkvbridge_print.output (Printf.sprintf "START functionality : %u" !g_count);

    end;


    if Ubersparkvbridge_options.Finish.get() then begin
        g_count := !g_count +1;

        Ubersparkvbridge_options.Finish.set(false);
        Ubersparkvbridge_print.output (Printf.sprintf "FINISH functionality : %u" !g_count);

    end;

    ()

let () = Db.Main.extend run