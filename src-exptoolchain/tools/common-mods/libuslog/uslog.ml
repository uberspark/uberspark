(*
	uberspark logging module
	author: amit vasudevan (amitvasudevan@acm.org)
*)

module Uslog =
	struct
		
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


	let log ?(tag = "") ?(lvl = Info) =
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
									if (tag <> "") then
										begin
											print_string "[";
											print_string tag;
											print_string "] ";
										end
									;
									
									if (ord lvl) == !error_level then
											print_string "[ERROR] ";
									
									print_string str;
									print_newline ();

									if (ord lvl) == !error_level then
										begin
											print_string " ";
											print_newline ();
										end
									;
								end
						end
		in
		Printf.ksprintf do_log
	

	end