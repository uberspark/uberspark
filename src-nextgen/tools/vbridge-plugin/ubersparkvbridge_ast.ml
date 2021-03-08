(*
    uberSpark verification bridge plugin -- AST module

    author: Amit Vasudevan <amitvasudevan@acm.org>
*)

open Cil_datatype
open Cil_types
   		
    		
(* dump AST of the source files provided *)    		
let ast_dump 
    ()
    : unit =

	  Ubersparkvbridge_print.output "Starting AST dump...\n";
	
    (* get Cil AST *)
    let file = Ast.get () in

    (* pretty print it *)
    Kernel.CodeOutput.output (fun fmt -> Printer.pp_file fmt file);
    (*Printer.pp_file Format.std_formatter file;*)


		Ubersparkvbridge_print.output "AST dump Done.\n";
		()





