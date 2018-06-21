(*
	test module for libusmf: uobj manifest parsing library
	author: amit vasudevan (amitvasudevan@acm.org)
*)

open Uslog
open Libusmf
open Sys
open Str

let main () =
	Uslog.current_level := Uslog.ord Uslog.Info;

	let len = Array.length Sys.argv in
		if len = 3 then
	    	begin
					let uobj_mf_filename = ref "" in
					let uobj_id = ref "" in
						uobj_mf_filename := Sys.argv.(1);
						uobj_id := Sys.argv.(2);
						Uslog.logf "libusmf_test" Uslog.Info "uobj manifest file: %s" !uobj_mf_filename;
						Uslog.logf "libusmf_test" Uslog.Info "uobj id=%s\n" !uobj_id;
						(* parse manifest *)
						Libusmf.dbg_dump_string !uobj_mf_filename;
						Uslog.logf "libusmf_test" Uslog.Info "All done!\n";
				end
		else
				begin
					Uslog.logf "libusmf_test" Uslog.Info "Insufficient Parameters!";
				end

	;;
		
main ();;



