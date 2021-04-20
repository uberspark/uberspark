(*===========================================================================*)
(*===========================================================================*)
(*	uberSpark utility functions	implementation								 *)
(*	author: amit vasudevan (amitvasudevan@acm.org)							 *)
(*===========================================================================*)
(*===========================================================================*)


(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* type definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)


(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* interface definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)

(* 
    given a list of strings and a candidate string, 
    return true if candidate string is found in the list
    or false if not
*)

let string_list_exists_string
	(p_string_list : string list)
	(p_candidate_string : string) 
	: bool =

	(* check if the string begins with wildcard characters *)
	let l_string_check (p_str : string ) : bool =
		if (p_str = p_candidate_string) then begin
			(true)
		end else begin
			(false)
		end
	
    in

	(List.exists l_string_check p_string_list)
;;


(* 
    given tww lists of strings and a candidate string, 
    return true if candidate string is found in both the lists
    or false if not
*)

let string_list_exists_common_string
	(p_list_a : string list)
	(p_list_b : string list)
	(p_candidate_string : string) 
	: bool =

    let l_rval1 = string_list_exists_string p_list_a p_candidate_string in
    let l_rval2 = string_list_exists_string p_list_b p_candidate_string in

    if l_rval1 = true && l_rval2 = true then
        (true)
    else
        (false)
;;




(* 
    given a list of filenames and a path prefix, append path prefix to each 
    filename in the list and return the new list
*)
let filename_list_append_path_prefix
	(p_filename_list : string list)
	(p_path_prefix : string) 
	: string list =

    let l_rval : string list ref = ref [] in

    List.iter (fun (l_filename: string) ->
        l_rval := !l_rval @ [ p_path_prefix ^ l_filename ];
    )p_filename_list;

    (!l_rval)
;;



(* 
    given a list of filename and a file extension, return a list with
    only the filenames that match the file extension
*)
let filename_list_filter_by_extension
	(p_filename_list : string list)
	(p_file_ext : string) 
	: string list =

    let l_rval : string list ref = ref [] in

    List.iter (fun (l_filename: string) ->
		if (Filename.extension l_filename) = p_file_ext then begin
            l_rval := !l_rval @ [ l_filename ];
        end;
    )p_filename_list;

    (!l_rval)
;;




(* 
    given a list of filename and a file extension, return a list with
    all the filenames with extension substituted with the given file extension
*)
let filename_list_substitute_extension
	(p_filename_list : string list)
	(p_file_ext : string) 
	: string list =

    Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "%s: len(p_filename_list)=%u p_file_ext=%s" 
        __LOC__ (List.length p_filename_list) p_file_ext;

    let l_rval : string list ref = ref [] in

    List.iter (fun (l_filename: string) ->
		(*if (Filename.extension l_filename) = p_file_ext then begin*)
        l_rval := !l_rval @ [ (Filename.remove_extension l_filename) ^ p_file_ext ];
        (*end;*)
    )p_filename_list;

    Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "%s: len(l_rval)=%u" 
        __LOC__ (List.length !l_rval);

    (!l_rval)
;;

