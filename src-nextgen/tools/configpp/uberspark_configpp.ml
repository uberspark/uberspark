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
let g_defnodes_hashtbl = ((Hashtbl.create 32) : ((string, string)  Hashtbl.t));; 

let g_filename_defnodes_hashtbl = ((Hashtbl.create 32) : ((string, Yojson.Basic.t)  Hashtbl.t));;

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
  (defnodes_hashtbl : (string, string) Hashtbl.t)
  =

  let ic = open_in input_filename in
  let oc = open_out output_filename in
  try
    while true do
      let line = input_line ic in
      let output_line = ref "" in
      output_line := line;

      Hashtbl.iter (fun key value  ->
        let t_line = Str.global_replace (Str.regexp key) value (!output_line) in
        output_line := t_line;
      ) defnodes_hashtbl;

      Printf.fprintf oc "%s\n" !output_line;
    done
  with End_of_file -> ();				
  close_in ic;
  close_out oc;  

  ()
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
            
            List.iter (fun (x,y) ->
             Printf.printf "%s:\n" x;

             if(!outer_json_node_index == 0) then 
             begin
              if (x <> "hdr") then 
              begin
                Printf.printf "ERROR in manifest: expected first entry to be header, got: %s\n" x;
                ignore(exit 1);
              end
              ;
              Printf.printf "TODO: sanity check hdr\n";
             end

             else
             begin

              (* grab list of files for this defnode *)
              let files_json_list : Yojson.Basic.t list ref = ref [] in
              let mf_files_json = y |> member "files" in
                if mf_files_json != `Null then
                  begin
                    Printf.printf "files:\n";
                    files_json_list := mf_files_json |> to_list;
                  end
                else
                  begin
                    Printf.printf "ERROR in manifest: 'files' node missing within defnodes\n";
                    ignore(exit 1);
                  end
                ;

              (* grab list of defnodes *)
              let def_nodes_assoc_list : (string * Yojson.Basic.t) list ref = ref [] in 
              let mf_def_nodes_json = y |> member "def-nodes" in
              if mf_def_nodes_json != `Null then
                begin
                    def_nodes_assoc_list := Yojson.Basic.Util.to_assoc mf_def_nodes_json;
                end
              ;

              List.iter (fun x -> 
                 Printf.printf "%s\n" (x |> to_string);
              ) !files_json_list;


                (*let mf_def_nodes_json = y |> member "def-nodes" in
                if mf_def_nodes_json != `Null then
                  begin
                    Printf.printf "def-nodes:\n";
                    let def_nodes_assoc_list = Yojson.Basic.Util.to_assoc mf_def_nodes_json in
                  *)
                    List.iter (fun (x,y) ->
                      Printf.printf "%s:\n" x;
                      let def_nodes_types_assoc_list = Yojson.Basic.Util.to_assoc y in
                      List.iter (fun (m,n) ->
                        Printf.printf "%s:\n" m;
                        let def_nodes_types_inner_assoc_list = Yojson.Basic.Util.to_assoc n in
                        List.iter (fun (a,b) ->
                          Printf.printf "id:%s, val:%s\n" a (b |> to_string);
                        ) def_nodes_types_inner_assoc_list;
                      ) def_nodes_types_assoc_list;
                    )!def_nodes_assoc_list;
                  (*end
                ;*)
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


  ()
;;


let main () = 
 
  (* sanity check usage *)
  if (Array.length Sys.argv) < 2 then
  begin
    Printf.printf "Usage: uberspark_confpp <input_json>\n\n";
  end;
   
  (* get json file and open it *)  
  let input_json_filename = Sys.argv.(1) in 
    Printf.printf "Using configuration json file: %s\n" input_json_filename;


  (* parse config json *)
  parse_config_json input_json_filename;  

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

