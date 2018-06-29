(*
	uberspark log module
	author: amit vasudevan (amitvasudevan@acm.org)
*)

module Uslog =
	struct
  (*
		let uslog_testnum = ref 0

		let uslog_log () = 
			print_int !uslog_testnum;
			print_newline ();
			()
		*)
		
	type log_level =
  	  | Error
    	| Warn
    	| Info

	let ord lvl =
    match lvl with
    | Error -> 50
    | Warn  -> 40
    | Info  -> 30

	let current_level = ref (ord Warn)

	let logf name lvl =
    let do_log str =
        if (ord lvl) >= !current_level then
            begin
						print_string "[";
						print_string name;
						print_string "] ";
						print_endline str;
    				end
		in
    Printf.ksprintf do_log

	end