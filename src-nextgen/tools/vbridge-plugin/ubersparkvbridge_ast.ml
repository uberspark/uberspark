(*
    uberSpark verification bridge plugin -- AST module

    author: Amit Vasudevan <amitvasudevan@acm.org>
*)

open Cil_types
   		
    		
(* dump AST of the source files provided *)    		
let ast_dump 
    ()
    : unit =
		Ubersparkvbridge_print.output "Starting AST dump...\n";
		Ubersparkvbridge_print.output "AST dump Done.\n";
		()





