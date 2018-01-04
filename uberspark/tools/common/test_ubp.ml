(*
	uberspark blueprint parsing module
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


let g_cfiles_list = ref [""];;

let dbg_dump_string string_value =
  Uslog.logf "test" Uslog.Info "string value: %s" string_value;
			;;


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


let parse_ubp_entry entry = 
	try
	  	let open Yojson.Basic.Util in
			let uobj_0 = entry in 
			let uobj_0_name = uobj_0 |> member "name" |> to_string in
  		let uobj_0_uapifn = uobj_0 |> member "uobj-uapifn" |> to_list in

			let uobj_0_uapifn_name = myMap uobj_0_uapifn ~f:(fun uobj_0 -> member "name" uobj_0 |> to_string) in 
  		let uobj_0_uapifn_id = myMap uobj_0_uapifn ~f:(fun uobj_0 -> member "id" uobj_0 |> to_string) in 
  		let uobj_0_uapifn_opt1 = myMap uobj_0_uapifn ~f:(fun uobj_0 -> member "opt1" uobj_0 |> to_string) in 
  		let uobj_0_uapifn_opt2 = myMap uobj_0_uapifn ~f:(fun uobj_0 -> member "opt2" uobj_0 |> to_string) in 

			(* Print the results of the parsing *)
		  Uslog.logf "test" Uslog.Info "uobj_0: name: %s" uobj_0_name;
			List.iter dbg_dump_string uobj_0_uapifn_name;
	
	with Yojson.Json_error s -> 
			Uslog.logf "test" Uslog.Info "ERROR in parsing manifest!";
	;
;;

 
let parse_ubp filename = 
	Uslog.logf "test" Uslog.Info "Manifest file: %s" filename;

	try

	(* read the manifest JSON *)
  let json = Yojson.Basic.from_file filename in

	  (* Locally open the JSON manipulation functions *)
	  let open Yojson.Basic.Util in
	  	let uobjs = json |> member "uobjs" |> to_list in
				List.iter parse_ubp_entry uobjs;
				
	with Yojson.Json_error s -> 
		Uslog.logf "test" Uslog.Info "ERROR in parsing manifest!";
	;
;;



let main () =
	Uslog.current_level := Uslog.ord Uslog.Info;

	let len = Array.length Sys.argv in
		if len = 2 then
	    	begin
					parse_ubp Sys.argv.(1);
				end
		else
				begin
					Uslog.logf "test" Uslog.Info "Insufficient Parameters!";
				end

	;;
		
main ();;




