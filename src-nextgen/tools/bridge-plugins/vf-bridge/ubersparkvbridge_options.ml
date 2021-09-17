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
        let name = "uberSpark verification bridge plugin"
        let shortname = "uberspark-vbridge"
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


module Casm = Self.False
    (struct
        let option_name = "-casm"
        let help = "when on (off by default), " ^ help_msg
    end)


module CasmInputFile = Self.String
	(struct
		let option_name = "-casm-infile"
		let default = "casm.mach"
		let arg_name = "input-file"
		let help = "CASM input file"
	end)

module CasmOutputFile = Self.String
	(struct
		let option_name = "-casm-outfile"
		let default = "casm.s"
		let arg_name = "output-file"
		let help = "CASM Assembly output file"
	end)


module LogLevel = Self.Int
    (struct
		let option_name = "-log-level"
		let default = 4 (* Uberspark.Logger.Info *)
		let arg_name = "logging-level"
		let help = "Output logging level"
    end)

module UobjcollNamespace = Self.String
    (struct
		let option_name = "-uobjcoll-ns"
		let default = ""
		let arg_name = "uobjcoll-ns"
		let help = "uobjcoll namespace"
    end)

module UobjcollPlatformNamespace = Self.String
    (struct
		let option_name = "-uobjcoll-platform-ns"
		let default = ""
		let arg_name = "uobjcoll-platform-ns"
		let help = "uobjcoll platform namespace"
    end)

module RootDir = Self.String
    (struct
		let option_name = "-root-dir"
		let default = ""
		let arg_name = "root-dir"
		let help = "uberspark root directory"
    end)


module StagingDir = Self.String
    (struct
		let option_name = "-staging-dir"
		let default = ""
		let arg_name = "staging-dir"
		let help = "uobjcoll staging directory"
    end)
