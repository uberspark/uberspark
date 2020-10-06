(* 
    überSpark verification bridge (frama-c) plugin

    author: Amit Vasudevan <amitvasudevan@acm.org>
*)

(*
    note that frama-c -then command will cause the previously
    set options to return true again in the segment following the
    -then

*)

let help_msg = "output a warm welcome message to the user"

module Self = Plugin.Register
    (struct
        let name = "hello world"
        let shortname = "hello"
        let help = help_msg
    end)

module Start = Self.False
    (struct
        let option_name = "-hstart"
        let help = "when on (off by default), " ^ help_msg
    end)


module Finish = Self.False
    (struct
        let option_name = "-hfinish"
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