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
					let uobj_list_filename = ref "" in
					let uobj_mf_filename = ref "" in
						uobj_list_filename := Sys.argv.(1);
						uobj_mf_filename := Sys.argv.(2);
						Uslog.logf "libusmf_test" Uslog.Info "uobj list file: %s" !uobj_list_filename;
						Uslog.logf "libusmf_test" Uslog.Info "uobj manifest file: %s" !uobj_mf_filename;
						Libusmf.usmf_parse_uobj_list !uobj_list_filename;
						Libusmf.usmf_parse_uobj_mf !uobj_mf_filename;
						Uslog.logf "libusmf_test" Uslog.Info "All done!\n";
				end
		else
				begin
					Uslog.logf "libusmf_test" Uslog.Info "Insufficient Parameters!";
				end

	;;
		
main ();;



