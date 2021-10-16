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
    		
type output = Genc | Genasm ;;

class gen_out out c_or_asm = object 
  inherit Visitor.frama_c_inplace

  method! vfile _ = 
    (* frama-c will complaint if not include the header files this is a temporary that only works for x86 *)
    match c_or_asm with
    | Genc ->
      (*could probably get archtecture as input and generate appropriate includes*)
      Format.pp_print_string out "#include <uberspark/include/uberspark.h>\n";
      Format.pp_print_string out "#include <uberspark/hwm/cpu/x86/32-bit/generic/include/hwm.h>\n";
      Cil.DoChildren
    | Genasm ->
      Cil.DoChildren

  method! vglob_aux g =
    match g with
    | GFun(f,_) ->
      (match c_or_asm with 
       | Genc ->
         (let rec print_args = function
           [] -> Format.pp_print_string out ")\n{\n"
           | e::[] -> Format.fprintf out "%a %a)\n{\n"
                         Printer.pp_typ e.vtype
                         Printer.pp_varinfo e
           | e::l ->
             Format.fprintf out "%a %a,"
               Printer.pp_typ e.vtype
               Printer.pp_varinfo e;
               print_args l
         in
         let print_ret_typ = function
           |TFun (t,_,_,_) ->
             Format.fprintf out "%a "
               Printer.pp_typ t
           | _ -> ()
         in
         (*print function return type, name and its arguments*)
         print_ret_typ f.svar.vtype;
         Printer.pp_fundec out f;
         Format.pp_print_string out "(";
         print_args f.sformals;
         Cil.DoChildrenPost(fun g -> Format.fprintf out "}\n"; g)
        )
       | Genasm ->
         (let rec find_sec_attr = function
               [] -> Format.pp_print_string out ".section .text\n"
             | attr::al ->
               (match attr with
                | Attr ("section", pl) ->
                  (match pl with
                   | AStr s::[] -> 
                     Format.fprintf out ".section %s\n" s
                   | _ -> raise (Failure "Error parsing section attribute"))
                | _ -> find_sec_attr al)
          in
          let rec find_ali_attr = function
              [] -> Format.pp_print_string out ".balign 4\n"
            | attr::al ->
              (match attr with
               | Attr ("aligned", pl) ->
                 (match pl with
                  | AInt n::[] -> 
                    Format.fprintf out ".balign %s\n" (Integer.to_string n)
                  | _ -> raise (Failure "Error parsing alignment attribute"))
               | _ -> find_ali_attr al)
          in
          (* output assembler function definition prologue*)
          find_sec_attr f.svar.vattr;
          find_ali_attr f.svar.vattr;
          Format.fprintf out ".global %a\n%a:\n"
            Printer.pp_varinfo f.svar
            Printer.pp_varinfo f.svar;
          Cil.DoChildren
         )
      )
    | _ ->
      ();
      Cil.SkipChildren

  method! vstmt_aux s =
    match s.skind with
      | Instr (Call (lv_opt, e, e_list, loc)) ->
        (let ename exp= 
          match exp.enode with 
          | Lval (Var v,_) ->
            Some v.vorig_name 
          | _ -> None
        in
        let casm_instr = ename e in 
        let casm_instr_args = List.filter_map ename e_list in
        (*creat a association list*)
        let rec zip_with_num n = function 
          | [] -> []
          | e :: l -> (n,e) :: zip_with_num (n+1) l
        in
        let assoc_list_args = zip_with_num 1 casm_instr_args in
        (*replace the #1 #2... with actual args*)
        let rec insert_args str = function
          | [] -> str
          | (n,a)::l ->
            let r = Str.regexp ("#"^ (string_of_int n)) in
            insert_args (Str.global_replace r a str) l  
        in
        let open Uberspark.Manifest.Hwm in 
        let l_cpu_hwm_manifest_var = Uberspark.Context.get_hwm_manifest_var_cpu () in 
        let casm_mnemonic_list = l_cpu_hwm_manifest_var.hwm.cpu.casm_instructions in
        (* function to lookup the casm_mnemonic list *)
        let rec lookup (k: string option) table = 
          match table with 
          | [] -> None
          | (k',v)::t -> if k = (Some k') then Some v else lookup k t
        in
        match lookup casm_instr casm_mnemonic_list with
        | Some jnode ->
          (match c_or_asm with
          | Genc ->
            let out_sl = jnode.casm_implementation in
            let out_sl' = List.map (fun x -> insert_args x assoc_list_args) out_sl in 
            List.iter (fun x -> Format.fprintf out "%a;\n" Format.pp_print_string x;) out_sl';
            Cil.DoChildren
          | Genasm ->
            let out_sl = jnode.output_assembly in
            let out_sl' = List.map (fun x -> insert_args x assoc_list_args) out_sl in 
            List.iter (fun x -> Format.fprintf out "%a\n" Format.pp_print_string x;) out_sl';
            Cil.DoChildren
          )
        | None -> (*print the stmt if not found*)
          Format.fprintf out "%a\n"
            Printer.pp_stmt s;
          Cil.DoChildren
       )
      | _ ->  
        if c_or_asm = Genc then Format.fprintf out "%a\n" Printer.pp_stmt s;
        Cil.DoChildren
end    		

let casm_extract 
    (input_file : string)
    (output_file : string)
    : unit =
		Uberspark.Logger.log "Starting CASM extraction to assembly...\n";
		(* ucasm_process input_file output_file; *)
    let chan = open_out output_file in
    let fmt = Format.formatter_of_out_channel chan in
    Visitor.visitFramacFileSameGlobals (new gen_out fmt Genasm) (Ast.get ());
    close_out chan;
		Uberspark.Logger.log "Done.\n";
		()

let casm_genc 
    (input_file : string)
    (output_file : string)
    : unit =
    Uberspark.Logger.log "Generating CASM C with hardware model embedding...\n";
    (* for now just copy input file to output file *)
    (* Uberspark.Osservices.file_copy input_file output_file; *)
    (* dump AST to file *)
    (* let ast_chan = open_out "ast.c" in
     * let ast_fmt = Format.formatter_of_out_channel ast_chan in
     * Printer.pp_file ast_fmt (Ast.get ());
     * close_out ast_chan; *)
    (* go thru the AST of casm file to generate corresponding c file  *)
    let chan = open_out output_file in
    let fmt = Format.formatter_of_out_channel chan in
    Visitor.visitFramacFileSameGlobals (new gen_out fmt Genc) (Ast.get ());
    close_out chan;
		Uberspark.Logger.log "Done.\n";
		()





