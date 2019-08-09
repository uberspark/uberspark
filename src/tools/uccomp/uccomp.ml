(*
	frama-c plugin for composition check
	author: amit vasudevan (amitvasudevan@acm.org)
*)

open Uslog
open Libusmf
open Sys
open Str

(*
open Umfcommon

module Self = Plugin.Register
	(struct
		let name = "US composition check"
		let shortname = "ucvf"
		let help = "UberSpark composition check"
	end)


module Cmdopt_slabsfile = Self.String
	(struct
		let option_name = "-umf-uobjlist"
		let default = ""
		let arg_name = "uobjlist-file"
		let help = "uobj list file"
	end)

module Cmdopt_outputfile_ccompdriverfile = Self.String
	(struct
		let option_name = "-umf-outuobjccompdriver"
		let default = ""
		let arg_name = "outuobjccompdriver-file"
		let help = "output uobj composition check driver file"
	end)


module Cmdopt_outputfile_ccompcheckfile = Self.String
	(struct
		let option_name = "-umf-outuobjccompcheck"
		let default = ""
		let arg_name = "outuobjccompcheck-file"
		let help = "output uobj composition check file"
	end)


module Cmdopt_maxincldevlistentries = Self.String
	(struct
		let option_name = "-umf-maxincldevlistentries"
		let default = ""
		let arg_name = "max-incldevlistentries"
		let help = "total number of INCL device list entries"
	end)

module Cmdopt_maxexcldevlistentries = Self.String
	(struct
		let option_name = "-umf-maxexcldevlistentries"
		let default = ""
		let arg_name = "max-excldevlistentries"
		let help = "total number of EXCL device list entries"
	end)

module Cmdopt_maxmemoffsetentries = Self.String
	(struct
		let option_name = "-umf-maxmemoffsetentries"
		let default = ""
		let arg_name = "max-memoffsetentries"
		let help = "total number of MEMOFFSET entries"
	end)

module Cmdopt_memoffsets = Self.False
	(struct
		let option_name = "-umf-memoffsets"
		(* let default = false *)
		let help = "when on (off by default), include absolute memory offsets in MEMOFFSETS list"
	end)
*)


(*
	**************************************************************************
	global variables
	**************************************************************************
*)

(*
(*	command line inputs *)
let g_slabsfile = ref "";;	(* argv 0 *)
let g_outputfile_ccompdriverfile = ref "";; (* argv 1 *)
let g_outputfile_ccompcheckfile = ref "";; (* argv 2 *)
(* let g_maxincldevlistentries = ref 0;; *) (* argv 3 *)
(* let g_maxexcldevlistentries = ref 0;; *) (* argv 4 *)
(* let g_maxmemoffsetentries = ref 0;; *) (* argv 5 *)
let g_memoffsets = ref false;; (*argv 6 *)
*)

(*	command line inputs *)
let g_slabsfile = ref "";;	(* argv 0 *)
let g_outputfile_ccompdriverfile = ref "";; (* argv 1 *)
let g_outputfile_ccompcheckfile = ref "";; (* argv 2 *)
let g_maxincldevlistentries = ref 0;;  (* argv 3 *)
let g_maxexcldevlistentries = ref 0;;  (* argv 4 *)
let g_maxmemoffsetentries = ref 0;;  (* argv 5 *)
let g_memoffsets = ref false;; (*argv 6 *)

(* other global variables *)
let g_rootdir = ref "";;


(*
let uccomp_process_cmdline () =
	g_slabsfile := Cmdopt_slabsfile.get();
	g_outputfile_ccompdriverfile := Cmdopt_outputfile_ccompdriverfile.get();
	g_outputfile_ccompcheckfile := Cmdopt_outputfile_ccompcheckfile.get();
	g_maxincldevlistentries := int_of_string (Cmdopt_maxincldevlistentries.get());
	g_maxexcldevlistentries := int_of_string (Cmdopt_maxexcldevlistentries.get());
	g_maxmemoffsetentries := int_of_string (Cmdopt_maxmemoffsetentries.get());
	if Cmdopt_memoffsets.get() then g_memoffsets := true else g_memoffsets := false;

	
	Self.result "g_slabsfile=%s\n" !g_slabsfile;
	Self.result "g_outputfile_ccompdriverfile=%s\n" !g_outputfile_ccompdriverfile;
	Self.result "g_outputfile_ccompcheckfile=%s\n" !g_outputfile_ccompcheckfile;
	Self.result "g_maxincldevlistentries=%d\n" !g_maxincldevlistentries;
	Self.result "g_maxexcldevlistentries=%d\n" !g_maxexcldevlistentries;
	Self.result "g_maxmemoffsetentries=%d\n" !g_maxmemoffsetentries;
	Self.result "g_memoffsets=%b\n" !g_memoffsets;
	()

*)


let uccomp_process_cmdline () =
	let len = Array.length Sys.argv in
		Uslog.logf "uccomp" Uslog.Info "cmdline len=%u" len;

		if len = 8 then
	    	begin
					g_slabsfile := Sys.argv.(1);
					g_outputfile_ccompdriverfile := Sys.argv.(2);
					g_outputfile_ccompcheckfile := Sys.argv.(3);
					g_maxincldevlistentries := int_of_string (Sys.argv.(4));
					g_maxexcldevlistentries := int_of_string (Sys.argv.(5));
					g_maxmemoffsetentries := int_of_string (Sys.argv.(6));
					if int_of_string (Sys.argv.(7)) = 1 then g_memoffsets := true else g_memoffsets := false;

					Uslog.logf "uccomp" Uslog.Info "g_slabsfile=%s\n" !g_slabsfile;
					Uslog.logf "uccomp" Uslog.Info "g_outputfile_ccompdriverfile=%s\n" !g_outputfile_ccompdriverfile;
					Uslog.logf "uccomp" Uslog.Info "g_outputfile_ccompcheckfile=%s\n" !g_outputfile_ccompcheckfile;
					Uslog.logf "uccomp" Uslog.Info "g_maxincldevlistentries=%d\n" !g_maxincldevlistentries;
					Uslog.logf "uccomp" Uslog.Info "g_maxexcldevlistentries=%d\n" !g_maxexcldevlistentries;
					Uslog.logf "uccomp" Uslog.Info "g_maxmemoffsetentries=%d\n" !g_maxmemoffsetentries;
					Uslog.logf "uccomp" Uslog.Info "g_memoffsets=%b\n" !g_memoffsets;

				end
		else
				begin
					Uslog.logf "uccomp" Uslog.Info "uccomp_process_cmdline: Insufficient Parameters!";
					ignore(exit 1);
				end
		;

()



let uccomp_outputccompdriverfile () =
(*	let l_uapi_key = ref "" in
	let l_uapi_fndef = ref "" in
*)
	let i = ref 0 in
	let oc = open_out !g_outputfile_ccompdriverfile in


	Printf.fprintf oc "\n/* autogenerated XMHF composition driver file */";
	Printf.fprintf oc "\n/* author: amit vasudevan (amitvasudevan@acm.org) */";
	Printf.fprintf oc "\n\n";
	Printf.fprintf oc "#include <xmhf.h>\r\n";
	Printf.fprintf oc "#include <xmhf-debug.h>\r\n";
	Printf.fprintf oc "#include <xmhfgeec.h>\r\n";
	Printf.fprintf oc "\n\n";
	Printf.fprintf oc "#include <xc.h>\r\n";

	(* plug in header files *)
	while (!i < !Libusmf.g_totalslabs) do
	    if (compare "geec_sentinel" (Hashtbl.find Libusmf.slab_idtoname !i)) = 0 then
	    	begin
	    	end
	    else
	    	begin
	    		Printf.fprintf oc "#include <%s.h>\r\n" (Hashtbl.find Libusmf.slab_idtoname !i);
	    	end
	    ;
	    i := !i + 1;
	done;
	Printf.fprintf oc "\n\n";

	(* plug in frama-c nondeterminism support functions *)
	Printf.fprintf oc "\r\n//////";
	Printf.fprintf oc "\r\n// frama-c non-determinism functions";
	Printf.fprintf oc "\r\n//////";
	Printf.fprintf oc "\r\n";
	Printf.fprintf oc "\r\nu32 Frama_C_entropy_source;";
	Printf.fprintf oc "\r\n";
	Printf.fprintf oc "\r\n//@ assigns Frama_C_entropy_source \\from Frama_C_entropy_source;";
	Printf.fprintf oc "\r\nvoid Frama_C_update_entropy(void);";
	Printf.fprintf oc "\r\n";
	Printf.fprintf oc "\r\nu32 framac_nondetu32(void){";
	Printf.fprintf oc "\r\n  Frama_C_update_entropy();";
	Printf.fprintf oc "\r\n  return (u32)Frama_C_entropy_source;";
	Printf.fprintf oc "\r\n}";
	Printf.fprintf oc "\r\n";
	Printf.fprintf oc "\r\nu32 framac_nondetu32interval(u32 min, u32 max)";
	Printf.fprintf oc "\r\n{";
	Printf.fprintf oc "\r\n  u32 r,aux;";
	Printf.fprintf oc "\r\n  Frama_C_update_entropy();";
	Printf.fprintf oc "\r\n  aux = Frama_C_entropy_source;";
	Printf.fprintf oc "\r\n  if ((aux>=min) && (aux <=max))";
	Printf.fprintf oc "\r\n    r = aux;";
	Printf.fprintf oc "\r\n  else";
	Printf.fprintf oc "\r\n    r = min;";
	Printf.fprintf oc "\r\n  return r;";
	Printf.fprintf oc "\r\n}";
	Printf.fprintf oc "\r\n\r\n";

	(* generate main function *)
	Printf.fprintf oc "\r\n//////";
	Printf.fprintf oc "\r\n// main function";
	Printf.fprintf oc "\r\n//////";
	Printf.fprintf oc "\r\n";
	Printf.fprintf oc "void main(void){\r\n";

	(* iterate over the uapi_fndef hashtable *)
	Hashtbl.iter
  		(fun key value ->
    		Printf.fprintf oc "/* %s */\r\n" key;
    		Printf.fprintf oc "%s \r\n\r\n" (Hashtbl.find Libusmf.uapi_fndrvcode key);
  		)
  	Libusmf.uapi_fndef
	;

	Printf.fprintf oc "}\r\n";


	close_out oc;
	()


let uccomp_outputccompcheckfile () =
	(*let l_uapi_key = ref "" in
	let l_uapi_fndef = ref "" in
	*)
	let i = ref 0 in
	let oc = open_out !g_outputfile_ccompcheckfile in

	Printf.fprintf oc "\n/* autogenerated XMHF composition check file */";
	Printf.fprintf oc "\n/* author: amit vasudevan (amitvasudevan@acm.org) */";
	Printf.fprintf oc "\n\n";
	Printf.fprintf oc "#include <xmhf.h>\r\n";
	Printf.fprintf oc "#include <xmhf-debug.h>\r\n";
	Printf.fprintf oc "#include <xmhfgeec.h>\r\n";
	Printf.fprintf oc "\n\n";
	Printf.fprintf oc "#include <xc.h>\r\n";

	(* plug in header files *)
	while(!i < !Libusmf.g_totalslabs) do
	    if (compare "geec_sentinel" (Hashtbl.find Libusmf.slab_idtoname !i)) = 0 then
	    	begin
	    	end
	    else
	    	begin
	    		Printf.fprintf oc "#include <%s.h>\r\n" (Hashtbl.find Libusmf.slab_idtoname !i);
	    	end
	    ;
	    i := !i + 1;
	done;

	Printf.fprintf oc "\n\n";


	(* iterate over the uapi_fndef hashtable *)
	Hashtbl.iter
  		(fun key value ->
			Printf.fprintf oc "%s { \r\n" (Hashtbl.find Libusmf.uapi_fndef key);
			Printf.fprintf oc "%s \r\n" (Hashtbl.find Libusmf.uapi_fnccomppre key);
			Printf.fprintf oc "%s \r\n" (Hashtbl.find Libusmf.uapi_fnccompasserts key);
			Printf.fprintf oc "} \r\n\r\n";
  		)
  	Libusmf.uapi_fndef
	;

	close_out oc;
	()
	
	
(*	
let run () =
	Self.result "Generating composition check files...\n";
	uccomp_process_cmdline ();

	g_rootdir := (Filename.dirname !g_slabsfile) ^ "/";
	Self.result "g_rootdir=%s\n" !g_rootdir;

	umfcommon_init !g_slabsfile !g_memoffsets !g_rootdir;
	Self.result "g_totalslabs=%d \n" !g_totalslabs;
	
	uccomp_outputccompdriverfile ();

	uccomp_outputccompcheckfile ();
		
	Self.result "Done.\n";
	()


let () = Db.Main.extend run
*)

let main () =
	Uslog.current_level := Uslog.ord Uslog.Info;

	Uslog.logf "uccomp" Uslog.Info "Generating composition check files...\n";
	uccomp_process_cmdline ();

	g_rootdir := (Filename.dirname !g_slabsfile) ^ "/";
	Uslog.logf "uccomp" Uslog.Info "g_rootdir=%s\n" !g_rootdir;

(*	umfcommon_init !g_slabsfile !g_memoffsets !g_rootdir;*)
(*	Libusmf.usmf_initialize !g_slabsfile !g_memoffsets !g_rootdir;*)
	Libusmf.usmf_parse_uobj_list !g_slabsfile !g_rootdir;
	Libusmf.usmf_parse_uobjs !g_memoffsets;

		Uslog.logf "uccomp" Uslog.Info "g_totalslabs=%d \n" !Libusmf.g_totalslabs;
	
	uccomp_outputccompdriverfile ();

	uccomp_outputccompcheckfile ();
		
	Uslog.logf "uccomp" Uslog.Info "Done.\n";


;;

		
main ();;
