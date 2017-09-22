(*
	uberspark common modules test harness
	author: amit vasudevan (amitvasudevan@acm.org)
*)

open Uslog

let main () =
	begin
		Uslog.uslog_testnum := !Uslog.uslog_testnum + 1; 
		print_newline ();
		Uslog.uslog_log ();
	end
	;;
		
main ();;



