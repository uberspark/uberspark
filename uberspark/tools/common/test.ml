(*
	uberspark common modules test harness
	author: amit vasudevan (amitvasudevan@acm.org)
*)

open Uslog
open Sys
open Core.Std
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

(* let	list_of_cfiles = ref [];;
*)

let do_action_on_cfile cfilename =
  Uslog.logf "test" Uslog.Info "c-file name: %s" cfilename;
	;;

let rec print_list_string myList = match myList with
| [] ->
	begin
	(* print_endline "This is the end of the string list!" *)
	end
| head::body -> 
	begin
		do_action_on_cfile head;
		print_list_string body
	end
;;

let parse_json filename = 
	Uslog.logf "test" Uslog.Info "Manifest file: %s" filename;

  (* read the manifest JSON *)
  let json = Yojson.Basic.from_file filename in

	  (* Locally open the JSON manipulation functions *)
	  let open Yojson.Basic.Util in
	  	let ns = json |> member "ns" |> to_string in
	  	let cfiles = json |> member "c-files" |> to_string in

								(* Print the results of the parsing *)
			  Uslog.logf "test" Uslog.Info "Namespace (ns): %s" ns;
			  Uslog.logf "test" Uslog.Info "c-files: %s" cfiles;

				let list_of_cfiles = (Str.split (Str.regexp "[ \t]+") cfiles) in
			  	(* List.iter dump_cfile list_of_cfiles; *)
					print_list_string list_of_cfiles;					
					Uslog.logf "test" Uslog.Info "Done!";


		
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




