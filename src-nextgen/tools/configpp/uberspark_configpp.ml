(*
  uberSpark configuration pre-processing tool
  author: amit vasudevan <amitvasudevan@acm.org>
*)

open Unix
open Sys
open Yojson
open Filename

let uberspark_srcdir = ref "";;

(* hashtbl of defnodes index by defnode name: string and the value is a string 
 that will replace defnode in the processed file
 *)
(*let g_defnodes_hashtbl = ((Hashtbl.create 32) : ((string, string)  Hashtbl.t));; 

let g_filename_defnodes_hashtbl = ((Hashtbl.create 32) : ( (string, ((string * Yojson.Basic.t) list) )  Hashtbl.t));;
*)

let g_defnodes_hashtbl = ((Hashtbl.create 32) : ( (string, ((string * Yojson.Basic.t) list) )  Hashtbl.t));;

let g_defnodes_strings_hashtbl = ((Hashtbl.create 32) : ((string, string)  Hashtbl.t));; 


let abspath path =
  let curdir = Unix.getcwd () in
  let retval = ref true in
  let path_filename = (Filename.basename path) in
  let path_dirname = (Filename.dirname path) in
  let retval_abspath = ref "" in
    try
      Unix.chdir path_dirname;
      retval_abspath := Unix.getcwd ();
      retval_abspath := !retval_abspath ^ "/" ^ path_filename;
      Unix.chdir curdir;
      
    with Unix.Unix_error (ecode, fname, fparam) -> 
      Printf.printf "Error: %s" (Unix.error_message ecode);
      retval := false;
    ;

  (!retval, !retval_abspath)
;;



let process_configpp_file 
  (input_filename : string) 
  (output_filename : string)
  (defnodes_strings_hashtbl : (string, string) Hashtbl.t)
  =

  let ic = open_in input_filename in
  let oc = open_out output_filename in
  try
    while true do
      let line = input_line ic in
      let output_line = ref "" in
      output_line := line;

      Hashtbl.iter (fun key value  ->
        let t_line = Str.global_replace (Str.regexp ("@@" ^ key ^ "@@")) value (!output_line) in
        output_line := t_line;
      ) defnodes_strings_hashtbl;

      Printf.fprintf oc "%s\n" !output_line;
    done
  with End_of_file -> ();				
  close_in ic;
  close_out oc;  

  ()
;;


(*
  split a given filename into source, source suffix
  return false if unable to
*)
let deconstruct_filename
  (input_filename : string)
  : (bool * string * string) =
  let o_source = ref "" in
  let o_source_suffix = ref "" in
  let retval = ref false in

  let l_source = Filename.chop_suffix_opt ~suffix:".us" input_filename in
  match l_source with

    | Some l_source ->
      o_source := l_source;

      if (Filename.check_suffix !o_source ".c") then
        begin
          o_source_suffix := ".c";
          retval := true;
        end
      else if (Filename.check_suffix !o_source ".h") then
        begin
          o_source_suffix := ".h";
          retval := true;
        end
      else if (Filename.check_suffix !o_source ".ml") then
        begin
          o_source_suffix := ".ml";
          retval := true;
        end
      else if (Filename.check_suffix !o_source ".mli") then
        begin
          o_source_suffix := ".mli";
          retval := true;
        end
      else 
        begin
          o_source_suffix := "";
          retval := false;
        end
      ;

      (!retval, !o_source, !o_source_suffix)


    | None -> 
      Printf.printf "invalid input file suffix, only .us supported!\n" ;
      (!retval, !o_source, !o_source_suffix)
;;



(*
  create defnode string output for C code (.c, .h)
*)
let defnode_string_output_c_h
  (defnode_assoc_list : (string * Yojson.Basic.t) list) 
  : string =
  let ret_str = ref "" in
  
  List.iter (fun (defnode_type, (defnode_list : Yojson.Basic.t)) ->
    (*Printf.printf "defnode type=%s\n" defnode_type; *)

    if (defnode_type = "constdef") then 
      begin
        let defnode_constdef_assoc_list : (string * Yojson.Basic.t) list ref = ref [] in 
          defnode_constdef_assoc_list := Yojson.Basic.Util.to_assoc defnode_list;

        List.iter (fun (id_name, (id_def:Yojson.Basic.t) ) ->
            ret_str := !ret_str ^ "#define " ^  id_name ^ " \"" ^ (Yojson.Basic.Util.to_string id_def) ^ "\"\r\n";
          ) !defnode_constdef_assoc_list;
      end
    else
      begin
        Printf.printf "ERROR: unknown defnode type=%s\n" defnode_type;
        ignore (exit 1);
      end
    ;

  ) defnode_assoc_list;

  
  (!ret_str)
;;



(*
  create defnode string output for Ocaml code (.ml)
*)
let defnode_string_output_ml
  (defnode_assoc_list : (string * Yojson.Basic.t) list) 
  : string =
  let ret_str = ref "" in
  
  List.iter (fun (defnode_type, (defnode_list : Yojson.Basic.t)) ->
    (*Printf.printf "defnode type=%s\n" defnode_type; *)

    if (defnode_type = "constdef") then 
      begin
        let defnode_constdef_assoc_list : (string * Yojson.Basic.t) list ref = ref [] in 
          defnode_constdef_assoc_list := Yojson.Basic.Util.to_assoc defnode_list;

        List.iter (fun (id_name, (id_def:Yojson.Basic.t) ) ->
            ret_str := !ret_str ^ "let " ^  "const_" ^ id_name ^ " = \"" ^ (Yojson.Basic.Util.to_string id_def) ^ "\";;\r\n";
          ) !defnode_constdef_assoc_list;
      end
    else
      begin
        Printf.printf "ERROR: unknown defnode type=%s\n" defnode_type;
        ignore (exit 1);
      end
    ;

  ) defnode_assoc_list;

  
  (!ret_str)
;;


(*
  create defnode string output for Ocaml interface code (.mli)
*)
let defnode_string_output_mli
  (defnode_assoc_list : (string * Yojson.Basic.t) list) 
  : string =
  let ret_str = ref "" in
  
  List.iter (fun (defnode_type, (defnode_list : Yojson.Basic.t)) ->
    (*Printf.printf "defnode type=%s\n" defnode_type; *)

    if (defnode_type = "constdef") then 
      begin
        let defnode_constdef_assoc_list : (string * Yojson.Basic.t) list ref = ref [] in 
          defnode_constdef_assoc_list := Yojson.Basic.Util.to_assoc defnode_list;

        List.iter (fun (id_name, (id_def:Yojson.Basic.t) ) ->
            ret_str := !ret_str ^ "val " ^  "const_" ^ id_name ^ " : string\r\n";
          ) !defnode_constdef_assoc_list;
      end
    else
      begin
        Printf.printf "ERROR: unknown defnode type=%s\n" defnode_type;
        ignore (exit 1);
      end
    ;

  ) defnode_assoc_list;

  
  (!ret_str)
;;




(*
  create defnode string equivalent
*)
let create_defnode_strings 
  (defnode_string_output_function: (string * Yojson.Basic.t) list -> string) 
  =

  Hashtbl.iter (fun (defnode_name:string) (defnode_json_assoc_list : (string * Yojson.Basic.t) list)  ->
      let defnode_string_output = (defnode_string_output_function defnode_json_assoc_list) in
      Printf.printf "defnode:%s\n" defnode_name;
      Printf.printf "defnode output:\n%s\n" defnode_string_output;
      Hashtbl.remove g_defnodes_strings_hashtbl defnode_name;
      Hashtbl.add g_defnodes_strings_hashtbl defnode_name defnode_string_output;
  ) g_defnodes_hashtbl;

  ();
;;


(* 
   parse a configuration json manifest and populate relevant 
   hash tables and lists
*)
let parse_config_json
    (input_json_filename : string)
    =

  (* read input json file *)  
  let config_mf_json = ref `Null in
  try

    let mf_json = Yojson.Basic.from_file input_json_filename in
      config_mf_json := mf_json;
        
  with Yojson.Json_error s -> 
      Printf.printf "ERROR in reading manifest: %s" s;
      ignore(exit 1);
  ;

  Printf.printf "Successfully read json\n";

  (*parse json *)  
  let outer_json_node_index = ref 0 in 
  try
  let open Yojson.Basic.Util in
      if !config_mf_json != `Null then
        begin

          let mf_assoc_list = Yojson.Basic.Util.to_assoc !config_mf_json in
            
            List.iter (fun ( (defnode_name:string),(defnode_json:Yojson.Basic.t)) ->

             if(!outer_json_node_index == 0) then 
             begin
              if (defnode_name <> "hdr") then 
              begin
                Printf.printf "ERROR in manifest: expected first entry to be header, got: %s\n" defnode_name;
                ignore(exit 1);
              end
              ;
              Printf.printf "TODO: sanity check hdr\n";
             end

             else
             begin

              (* grab associative list of defnode json *)
              let defnode_json_assoc_list : (string * Yojson.Basic.t) list ref = ref [] in 
                defnode_json_assoc_list := Yojson.Basic.Util.to_assoc defnode_json;

              (* populate defnodes hashtbl *) 
              if (Hashtbl.mem g_defnodes_hashtbl defnode_name) then
                begin
                  let cur_defnode_json_assoc_list = (Hashtbl.find g_defnodes_hashtbl defnode_name) in
                    Hashtbl.replace g_defnodes_hashtbl defnode_name (cur_defnode_json_assoc_list @ !defnode_json_assoc_list);              
                end
              else
                begin
                  Hashtbl.add g_defnodes_hashtbl defnode_name !defnode_json_assoc_list;              
                end
              ;

              end;

              outer_json_node_index := !outer_json_node_index + 1;
              ()
            ) mf_assoc_list;

        end
      ;
                          
with Yojson.Basic.Util.Type_error _ -> 
  Printf.printf "ERROR in reading manifest: type error\n";
  ignore(exit 1);
;


(*debug print out filenames_defnodes hashtbl *)
 Printf.printf "total elements within filenames_defnodes hashtbl: %u\n" (Hashtbl.length g_defnodes_hashtbl);
 

  ()
;;


let main () = 
 
  (* sanity check usage *)
  if (Array.length Sys.argv) < 4 then
  begin
    Printf.printf "Usage: uberspark_configpp <input_file> <output_file> <config_json>\n";
    ignore (exit 1);
  end;
   
  (* get json file and open it *)  
  let input_json_filename = Sys.argv.(3) in 
    Printf.printf "Using configuration json file: %s\n" input_json_filename;

  (* parse config json *)
  parse_config_json input_json_filename;  


  (* determine the source file type and suffix *)
  let (rval, source_filename, source_filename_suffix) = (deconstruct_filename Sys.argv.(1)) in
  if (rval == false) then 
    begin
      Printf.printf "Unsupported file source/extension:%s" Sys.argv.(1); 
      ignore(exit 1);
    end;

 (* create defnode strings hashtbl based on source file type *)
  if (source_filename_suffix = ".c" || source_filename_suffix = ".h") then 
    begin
      Printf.printf "source is c code; using c output..\n";
      create_defnode_strings defnode_string_output_c_h;
    end
  else if (source_filename_suffix = ".ml") then 
    begin
      Printf.printf "source is Ocaml code; using ocaml output..\n";
      create_defnode_strings defnode_string_output_ml;
    end
  else if (source_filename_suffix = ".mli") then 
    begin
      Printf.printf "source is Ocaml interface code; using ocaml interface output..\n";
      create_defnode_strings defnode_string_output_mli;
    end
  else
    begin
      Printf.printf "ERROR: unknown source file type!";
      ignore(exit 1);
    end
  ;

 (* create output file with defnode substitutions *)
  Printf.printf "Generating output file...";
  process_configpp_file (Sys.argv.(1)) (Sys.argv.(2)) g_defnodes_strings_hashtbl;
  Printf.printf "Done!\n\n";

;;


(*
let main () = 
 
  (* sanity check usage *)
  if (Array.length Sys.argv) < 2 then
  begin
    Printf.printf "Usage: uberspark_confpp <input_json>\n\n";
  end;
   

  (* populate defnodes hashtbl *)
  Hashtbl.add  g_defnodes_hashtbl "leo" "leader";
  Hashtbl.add  g_defnodes_hashtbl "mikey" "goofhead";
  Hashtbl.add  g_defnodes_hashtbl "raph" "rage-monster";
  Hashtbl.add  g_defnodes_hashtbl "donnie" "techy";
  

  (* get input filename *)  
  let input_filename = Sys.argv.(1) in 
  let output_filename = (Filename.chop_suffix_opt ~suffix:".us" input_filename) in
  match output_filename with
  | None -> 
    Printf.printf "invalid input file suffix, only .us supported!\n" ;
    ignore(exit 1);

  | Some output_filename_final ->

    Printf.printf "input file: %s\n" input_filename;
    Printf.printf "output file: %s\n" output_filename_final;

    let (rval, input_filename_abspath) = abspath input_filename in
    if (rval == false) then 
    begin
      Printf.printf "could not obtain absollute path of input file\n" ;
      ignore(exit 1);
    end;

    let (rval, output_filename_abspath) = abspath output_filename_final in
    if (rval == false) then 
    begin
      Printf.printf "could not obtain absollute path of output file\n" ;
      ignore(exit 1);
    end;

    Printf.printf "input file abspath: %s\n" input_filename_abspath;
    Printf.printf "output file abspath: %s\n" output_filename_abspath;

    process_configpp_file input_filename_abspath output_filename_abspath g_defnodes_hashtbl;
  ;  

;;
*)

main ();;

(* TBA *)

(*


          let (rval, source_filename, source_filename_suffix) = (deconstruct_filename target_filename) in
          if (rval == true) then 
            begin
            
              List.iter (fun (defnode_name, (defnode_alist : Yojson.Basic.t)) ->
                Printf.printf "defnode name=%s, src suffix=%s\n" defnode_name source_filename_suffix; (* target we need to substitute within target_filane *)

                if (source_filename_suffix = ".c" || source_filename_suffix = ".h") then 
                  begin
                    let source_output = process_defnode_list_output_c_h defnode_alist in
                      Printf.printf "source output:\n%s\n" source_output;
                  end
                else
                  begin
                    Printf.printf "ERROR: unknown, we should never be here!";
                    ignore(exit 1);
                  end
                ;
                      
              )defnode_list;

            end
          else
            begin
              Printf.printf "Unsupported file source/extension:%s, ignoring\n" target_filename; 
            end;
*)


