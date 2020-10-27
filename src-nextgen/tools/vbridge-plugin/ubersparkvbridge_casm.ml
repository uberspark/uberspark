(*
    uberSpark verification bridge plugin -- casm extraction module

    author: Amit Vasudevan <amitvasudevan@acm.org>
*)

open Cil_types


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
  
  		
let ucasm_process 
    (infile : string)
    (outfile : string)
    : unit =
    let ic = open_in infile in
    let oc = open_out outfile in
    let tline = ref "" in
    let outline = ref "" in	
    let annotline_regexp = Str.regexp "_ = annot " in
    		    	
		try
    		while true do
      			tline := trim (input_line ic);
      			if (Str.string_match annotline_regexp !tline 0) then
      				begin
		      			outline := (Str.string_after !tline 11);
		      			outline := Str.string_before !outline ((String.length !outline) - 3);
		      			Printf.fprintf oc "%s\n" !outline; 
      				end
      			else
      				begin
      				end
      			;
      			
		    done;
		with End_of_file -> 
    			close_in ic;
    	;		
    
    	close_out oc;
    ()
    		
    		
    		
let casm_extract 
    (input_file : string)
    (output_file : string)
    : unit =
		Ubersparkvbridge_print.output "Starting CASM extraction...\n";
		ucasm_process input_file output_file;
		Ubersparkvbridge_print.output "Done.\n";
		()





