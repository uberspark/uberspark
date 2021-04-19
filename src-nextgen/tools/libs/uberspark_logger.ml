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

let log_tag = ref "uberspark";;

(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* default log printing backend functions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)

let log_print_string_default_backend
	(p_str : string) :
	unit =
		print_string p_str;
;;

let log_print_newline_default_backend
	() :
	unit =
		print_newline ();
;;


(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* variable definitions for the above backend functions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
let log_print_string_fn = ref log_print_string_default_backend;;
let log_print_newline_fn = ref log_print_newline_default_backend;;




(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* interface definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)

let log 
	?(tag = !log_tag) 
	?(stag = "") 
	?(lvl = Info) 
	?(crlf = true) =
	let do_log str =
			if (ord lvl) <= !current_level then
					begin
						if (ord lvl) == (ord Stdoutput) then
							begin
								!log_print_string_fn str;
								if crlf then
									!log_print_newline_fn ();							
							end
						else
							begin
								if (tag <> "") then
									begin
										!log_print_string_fn tag;
										!log_print_string_fn " >> ";
									end
								;
								
								if (stag <> "") then
									begin
										!log_print_string_fn "[";
										!log_print_string_fn stag;
										!log_print_string_fn "] ";
									end
								;
								
								if (ord lvl) == !error_level then
										!log_print_string_fn "ERROR: ";
								
								!log_print_string_fn str;
								if crlf then
									!log_print_newline_fn ();

								if (ord lvl) == !error_level then
									begin
										!log_print_string_fn " ";
										if crlf then
											!log_print_newline_fn ();
									end
								;
							end
					end
	in
	Printf.ksprintf do_log
;;	
