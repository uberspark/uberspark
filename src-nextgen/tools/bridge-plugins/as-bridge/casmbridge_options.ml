(* 
    überSpark verification bridge (frama-c) plugin

    author: Amit Vasudevan <amitvasudevan@acm.org>
*)

(*
    note that frama-c -then command will cause the previously
    set options to return true again in the segment following the
    -then

*)

module Self = Plugin.Register
    (struct
        let name = "uberSpark CASM bridge plugin"
        let shortname = "casmbridge"
        let help = ""
    end)

(* option to generate C code *)
module CasmGenc = Self.False
    (struct
        let option_name = "-casm-genc"
        let help = "when on (off by default), generate C code with hardware model"
    end)

(* option to generate Assembly code *)
module CasmGenasm = Self.False
    (struct
        let option_name = "-casm-genasm"
        let help = "when on (off by default), generate Assembly code"
    end)

(* input file name *)
module CasmInputFile = Self.String
	(struct
		let option_name = "-casm-infile"
		let default = "casm.mach"
		let arg_name = "input-file"
		let help = "CASM input file"
	end)

(* output file name *)
module CasmOutputFile = Self.String
	(struct
		let option_name = "-casm-outfile"
		let default = "casm.s"
		let arg_name = "output-file"
		let help = "CASM output file"
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
