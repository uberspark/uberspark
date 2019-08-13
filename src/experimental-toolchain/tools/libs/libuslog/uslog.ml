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
  	  | None
			| Stdoutput
			| Error
    	| Warn
    	| Info
			| Debug

	let ord lvl =
    match lvl with
		| None      -> 100
		| Stdoutput -> 60
		| Error     -> 50
    | Warn      -> 40
    | Info      -> 30
		| Debug     -> 20

	let current_level = ref (ord Info)
	let error_level = ref (ord Error)
	
	let logf name lvl =
    let do_log str =
        if (ord lvl) >= !current_level then
            begin
							if (ord lvl) == (ord Stdoutput) then
								begin
									print_string str;
									print_newline ();							
								end
							else
								begin
									print_string "[";
									print_string name;
									print_string "] ";
									if (ord lvl) == !error_level then
											print_string "[ERROR] ";
									print_endline str;
									if (ord lvl) == !error_level then
											print_endline " ";
								end
						end
		in
    Printf.ksprintf do_log

	end