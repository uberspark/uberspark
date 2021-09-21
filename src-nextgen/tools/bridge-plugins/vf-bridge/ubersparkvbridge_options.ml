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
        let name = "uberSpark verification bridge plugin"
        let shortname = "uberspark-vbridge"
        let help = ""
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
