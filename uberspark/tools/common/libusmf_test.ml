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
					let uobj_id = ref 0 in
						uobj_mf_filename := Sys.argv.(1);
						uobj_id := int_of_string(Sys.argv.(2));
						Uslog.logf "libusmf_test" Uslog.Info "uobj manifest file: %s" !uobj_mf_filename;
						Uslog.logf "libusmf_test" Uslog.Info "uobj id=%u\n" !uobj_id;
						(* parse manifest *)
						Libusmf.usmf_parse_uobj_mf !uobj_mf_filename 0;
						Uslog.logf "libusmf_test" Uslog.Info "All done!\n";
				end
		else
				begin
					Uslog.logf "libusmf_test" Uslog.Info "Insufficient Parameters!";
				end

	;;
		
main ();;



