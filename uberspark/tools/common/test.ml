(*
	uberspark common modules test harness
	author: amit vasudevan (amitvasudevan@acm.org)
*)

open Uslog

let main () =
	begin
		Uslog.current_level := Uslog.ord Uslog.Info;
		Uslog.logf "test" Uslog.Info "Amazing stuff!";
	end
	;;
		
main ();;



