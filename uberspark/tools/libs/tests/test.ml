(*
	uberspark common modules test harness
	author: amit vasudevan (amitvasudevan@acm.org)
*)

open Unix
open Uslog
open Sys
open Yojson
open Str

	
(*
let main () =
	begin
		Uslog.current_level := Uslog.ord Uslog.Info;
		Uslog.logf "test" Uslog.Info "Amazing stuff!";
	end
	;;
		
main ();;
*)

(*
let g_cfiles_list = ref [""];;

let do_action_on_cfile cfilename =
  Uslog.logf "test" Uslog.Info "c-file name: %s" cfilename;
			;;

let do_action_on_vharness_file filename =
  Uslog.logf "test" Uslog.Info "v-harness(file): %s" filename;
			;;

let do_action_on_vharness_options optionstring =
  Uslog.logf "test" Uslog.Info "v-harness(options): %s" optionstring;
			;;


let rec myMap ~f l = match l with
 | [] -> []
 | h::t -> (f h) :: (myMap ~f t);;

 
let parse_json filename = 
	Uslog.logf "test" Uslog.Info "Manifest file: %s" filename;

try
	
  (* read the manifest JSON *)
  let json = Yojson.Basic.from_file filename in

	  (* Locally open the JSON manipulation functions *)
	  let open Yojson.Basic.Util in
	  	let ns = json |> member "ns" |> to_string in
	  	let cfiles = json |> member "c-files" |> to_string in
  		let vharness = json |> member "v-harness" |> to_list in
  		let vfiles = myMap vharness ~f:(fun json -> member "file" json |> to_string) in 
  		let voptions = myMap vharness ~f:(fun json -> member "options" json |> to_string) in

				(* Print the results of the parsing *)
			  Uslog.logf "test" Uslog.Info "Namespace (ns): %s" ns;
			  Uslog.logf "test" Uslog.Info "c-files: %s" cfiles;

				g_cfiles_list := (Str.split (Str.regexp "[ \r\n\t]+") cfiles);
				List.iter do_action_on_cfile !g_cfiles_list;

				List.iter do_action_on_vharness_file vfiles;
				List.iter do_action_on_vharness_options voptions;
			
			
				Uslog.logf "test" Uslog.Info "Done!";

with Yojson.Json_error s -> 
				Uslog.logf "test" Uslog.Info "ERROR in parsing manifest!";

	;
		
	;;



let main () =
	Uslog.current_level := Uslog.ord Uslog.Info;

	let len = Array.length Sys.argv in
		if len = 2 then
	    	begin
					parse_json Sys.argv.(1);
				end
		else
				begin
					Uslog.logf "test" Uslog.Info "Insufficient Parameters!";
				end

	;;
		
main ();;
*)


(*
 
let ccomp_program = ref "ccomp";;
let ccomp_program_options = ref "-help";;


let main () =
	Uslog.current_level := Uslog.ord Uslog.Info;

	Uslog.logf "test" Uslog.Info "Proceeding to execute program (%s) with options (%s)..." !ccomp_program !ccomp_program_options;
	let inp = Unix.open_process_in (!ccomp_program ^ " " ^ !ccomp_program_options) in
  		try
				while true do
      				let program_line = input_line inp in
								Uslog.logf "test" Uslog.Info "[progout] %s" program_line;
				done;	
			with End_of_file -> 
    			close_in inp;
    	;		
		
	Uslog.logf "test" Uslog.Info "All done!";

	;;
		
main ();;

*)


let us_exec_cmd do_output = 
	if do_output then
		begin
		end
	else
		begin
		end
	;	
	
;;
 
let cmd = ref "ccomp -c sample1.c";;  
(* let cmd = ref "frama-c -wp -wp-prover alt-ergo,cvc3,z3 sample.c";; *)  
let tfile = ref "";;
let status = ref 0;;

let main () =
	Uslog.current_level := Uslog.ord Uslog.Info;

	(*
	tfile := Filename.temp_file ~temp_dir:"." "us_" ".output";
	Uslog.logf "test" Uslog.Info "tfile=%s" !tfile;
	*)
	
	(* cmd := !cmd ^ " 1>" ^ !tfile ^ " 2>&1"; 
	Uslog.logf "test" Uslog.Info "Proceeding to execute command: %s..." !cmd;
	*)
	
	(*
	status := Sys.command (!cmd);
	Uslog.logf "test" Uslog.Info "return status=%d" !status;
	*)
	
	(*Sys.remove !tfile;*)

  let proc = Unix.open_process_in (!cmd ^ " 2>&1") in
		try
    	while true do
      	let line = input_line proc in
					Uslog.logf "test" Uslog.Info "| %s" line;
			done
			;
		with End_of_file ->
    	begin
				let pstatus = Unix.close_process_in proc in
					match pstatus with
    				| Unix.WEXITED st ->
        				status := st;
    				| _ -> 
								status := 1; (*program killed or stopped by signal*)
					;			
			end
		;	

	Uslog.logf "test" Uslog.Info "return status=%d" !status;

	;;
		
main ();;

