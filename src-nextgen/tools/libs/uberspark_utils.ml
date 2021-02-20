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

    let l_rval : string list ref = ref [] in

    List.iter (fun (l_filename: string) ->
		if (Filename.extension l_filename) = p_file_ext then begin
            l_rval := !l_rval @ [ (Filename.remove_extension l_filename) ^ p_file_ext ];
        end;
    )p_filename_list;

    (!l_rval)
;;

