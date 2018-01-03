(*
	uberspark common modules test harness
	author: amit vasudevan (amitvasudevan@acm.org)
*)

open Uslog
open Usmf
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

*)

let main () =
	Uslog.current_level := Uslog.ord Uslog.Info;

	let len = Array.length Sys.argv in
		if len = 2 then
	    	begin
					parse_manifest Sys.argv.(1);
				end
		else
				begin
					Uslog.logf "test" Uslog.Info "Insufficient Parameters!";
				end

	;;
		
main ();;




