(*===========================================================================*)
(*===========================================================================*)
(*	uberSpark logging module interface implementation		 *)
(*	author: amit vasudevan (amitvasudevan@acm.org)							 *)
(*===========================================================================*)
(*===========================================================================*)


(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* type definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)


type log_level =
	| None
	| Stdoutput
	| Error
	| Warn
	| Info
	| Debug
;;

(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* variable definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)

let ord lvl =
	match lvl with
	| None      -> 0
	| Stdoutput -> 1
	| Error     -> 2
	| Warn      -> 3
	| Info      -> 4
	| Debug     -> 5
;;

let current_level = ref (ord Info);;

let error_level = ref (ord Error);;


(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* interface definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)


let logf name lvl =
	let do_log str =
		if (ord lvl) <= !current_level then
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
;;


let log ?(tag = "uberspark") ?(stag = "") ?(lvl = Info) ?(crlf = true)=
	let do_log str =
			if (ord lvl) <= !current_level then
					begin
						if (ord lvl) == (ord Stdoutput) then
							begin
								print_string str;
								if crlf then
									print_newline ();							
							end
						else
							begin
								if (tag <> "") then
									begin
										print_string tag;
										print_string " >> ";
									end
								;
								
								if (stag <> "") then
									begin
										print_string "[";
										print_string stag;
										print_string "] ";
									end
								;
								
								if (ord lvl) == !error_level then
										print_string "ERROR: ";
								
								print_string str;
								if crlf then
									print_newline ();

								if (ord lvl) == !error_level then
									begin
										print_string " ";
										if crlf then
											print_newline ();
									end
								;
							end
					end
	in
	Printf.ksprintf do_log
;;	
