let help_msg = "output a warm welcome message to the user"

module Self = Plugin.Register
(struct
let name = "hello world"
let shortname = "hello"
let help = help_msg
end)

module Enabled = Self.False
(struct
let option_name = "-hello"
let help = "when on (off by default), " ^ help_msg
end)

module Output_file = Self.String
(struct
let option_name = "-hello-output"
let default = "-"
let arg_name = "output-file"
let help =
"file where the message is output (default: output to the console)"
end)

let run () =
try
if Enabled.get() then
let filename = Output_file.get () in
let output msg =
if Output_file.is_default() then
Self.result "%s" msg
else
let chan = open_out filename in
Printf. fprintf chan "%s\n" msg;
flush chan;
close_out chan;
in
output "Hello, world!"
with Sys_error _ as exc ->
let msg = Printexc.to_string exc in
Printf.eprintf "There was an error: %s\n" msg


let () = Db.Main.extend run