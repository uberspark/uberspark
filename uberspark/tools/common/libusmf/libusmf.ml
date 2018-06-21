(*
	uberspark manifest parsing module
	author: amit vasudevan (amitvasudevan@acm.org)
*)
open Uslog

module Libusmf = 
	struct

(*
	**************************************************************************
	global variables
	**************************************************************************
*)


(*
	**************************************************************************
	debugging related
	**************************************************************************
*)
let dbg_dump_string string_value =
  	Uslog.logf "test" Uslog.Info "string value: %s" string_value
		

(*
	**************************************************************************
	helper interfaces
	**************************************************************************
*)
let left_pos s len =
  let rec aux i =
    if i >= len then None
    else match s.[i] with
    | ' ' | '\n' | '\t' | '\r' -> aux (succ i)
    | _ -> Some i
  in
  aux 0
 
let right_pos s len =
  let rec aux i =
    if i < 0 then None
    else match s.[i] with
    | ' ' | '\n' | '\t' | '\r' -> aux (pred i)
    | _ -> Some i
  in
  aux (pred len)
  
let trim s =
  let len = String.length s in
  match left_pos s len, right_pos s len with
  | Some i, Some j -> String.sub s i (j - i + 1)
  | None, None -> ""
  | _ -> assert false

let rec myMap ~f l = match l with
 | [] -> []
 | h::t -> (f h) :: (myMap ~f t);;


(*
	**************************************************************************
	module internal interfaces
	**************************************************************************
*)




(*
	**************************************************************************
	main interfaces
	**************************************************************************
*)

(* parse uobj manifest specified by uobj_mf_filename and store parsed info*)
(* indexed by uobj_id*)
let usmf_parse_uobj_mf uobj_mf_filename uobj_id = 
	try

		(* read the manifest JSON *)
  let json = Yojson.Basic.from_file uobj_mf_filename in

	  (* Locally open the JSON manipulation functions *)
	  let open Yojson.Basic.Util in
			Uslog.logf "libusmf" Uslog.Info "wip!";
												
	with Yojson.Json_error s -> 
		Uslog.logf "test" Uslog.Info "ERROR in parsing manifest!";
	;


end



