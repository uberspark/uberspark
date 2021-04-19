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



(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* variable definitions for the above backend functions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
let log_print_string_fn = ref log_print_string_default_backend;;




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

	let do_log (p_str: string) =
		(* only print if the given log lvl is less than or equal to current_level *)
		if (ord lvl) <= !current_level then	begin
			let l_prefix = ref "" in
			let l_suffix = ref "" in 
			
			(* add primary tag if one is present *)
			if tag <> "" then begin
				l_prefix := !l_prefix ^ tag ^ " >> ";
			end;

			(* add secondary tag if one is present *)
			if stag <> "" then begin
				l_prefix := !l_prefix ^ "[" ^ stag ^ "] ";
			end;

			(* add line-feed if specified *)
			if crlf then begin
				l_suffix := "\n";
			end;

			(* we have special handling for stdoutput and error *)
			match lvl with
				| Stdoutput -> (* no prefix, but append suffix *)
					!log_print_string_fn (p_str ^ !l_suffix);

				| Error -> (* append an error before the string *)
					!log_print_string_fn (!l_prefix ^ "ERROR: " ^ p_str ^ !l_suffix);

				| _ -> (* any other is just prefix, string, following by suffix *)
					!log_print_string_fn (!l_prefix ^ p_str ^ !l_suffix);

			;
			
		end;
		()
	in 


	Printf.ksprintf do_log
;;	
