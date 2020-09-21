let run () =
    if Ubersparkvbridge_options.Enabled.get() then
        Ubersparkvbridge_print.output "Hello, world!"


let () = Db.Main.extend run