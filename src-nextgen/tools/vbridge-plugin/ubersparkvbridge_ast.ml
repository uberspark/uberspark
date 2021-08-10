(*
    uberSpark verification bridge plugin -- AST module

    author: Amit Vasudevan <amitvasudevan@acm.org>
*)
open Cil
open Cil_types

(*
  pretty printing here: frama-c-api/html/Printer_api.S_pp.html
*)

(*
  capabilities required over the ast

  1. need a way to insert annotations for statements/instructions
    use-case: assert that a hwm register or status bit is zero when performing certain memory accesses; as in case of
    interrupt signal/principles

*)

(*
class occurence
...
end


within the above replace occurence.add xxx
wit hashtbl.add xxx and put (kf, ki, lv)

just pretty print for now when we dump into hashtbl

Db.Value.Compute to stat with (remove that from class occurence and put it in main)
remove db.progess --> only for gui; we dont need it

then do hashtbl iter and print varinfo and then call classify_accesses
include access_type
is_sub_lval
*)

(*let assertion_one : code_annotation_node = AAssert ( [], Assert, { pred_name = [];}) ;; 
*)


(*--------------------------------------------------------------------------*)
(* dump an annotation *)
(*--------------------------------------------------------------------------*)
let dump_annotation (annot : Cil_types.code_annotation) : unit =
  Uberspark.Logger.log "dumping annotation...";

  (*Printer.pp_code_annotation Format.std_formatter annot;*)
  match annot.annot_content with
    | AAssert (bhvnamelist, akind, pred) ->
      Uberspark.Logger.log "assert";

    | _ ->
      Uberspark.Logger.log "something else";
  ;

  Uberspark.Logger.log "annotation dumped";
  ()
;;

(* every annotation needs an emitter and we define ours here
    see: frama-c-api/html/Emitter.html
    note: creating an emitter with the same name and same type will result
    in frama-c kernel reporting and error and bailing out
*)
(* this emitter can emit both code annotations as well
as global annotations *)
let l_annotation_emitter = Emitter.create
    "uberSpark Interrupt Check" [ Emitter.Code_annot; Emitter.Global_annot ] ~correctness:[] ~tuning:[];;

let is_casm_func_call e = 
  match e.enode with
  | Lval (lh, _) ->
    (match lh with 
     | Var (v) ->
       if (String.length v.vorig_name) < 5 then false
       else if String.sub v.vorig_name 0 5 = "casm_" then true 
       else false
     | _ -> false)
  | _ -> false
;;

let rec casm_func_call_push_args = function 
  [] -> []
  | e::l ->
    Cil_types.CastE (Cil_types.TInt (IUInt, []), e) :: casm_func_call_push_args l
;;

let rec casm_func_call_pop_args e_list loc = 
  match e_list with  
  |  [] -> []
  | e::l ->
    let const = Cil_types.CInt64 ((Integer.of_string "4"), Cil_types.IUInt, Some "0x4") in 
    let const_enode = Cil_types.Const const in 
    let const_exp = Cil.new_exp loc const_enode in 
    Cil_types.CastE (Cil_types.TInt (IUInt, []), const_exp) :: casm_func_call_pop_args l loc
;;

let casm_func_call_ret lv_opt loc = 
  match lv_opt with 
  | None -> []
  | Some lv -> 
    (* Start building the first binary op*)
    (* this is for cast hwm_cpu_gprs_edx *)
    let edx_varinfo = (Globals.Vars.find_from_astinfo "hwm_cpu_gprs_edx" VGlobal) in
    let edx_enode = Cil_types.Lval (Cil.var edx_varinfo) in
    let edx_exp = Cil.new_exp loc edx_enode in
    let edx_cast_enode = Cil_types.CastE (Cil_types.TInt (IULongLong, []), edx_exp) in 
    let edx_cast_exp = Cil.new_exp loc edx_cast_enode in
    (* cast 32*)
    let const = Cil_types.CInt64 ((Integer.of_string "32"), Cil_types.IInt, Some "32") in 
    let const_enode = Cil_types.Const const in 
    let const_exp = Cil.new_exp loc const_enode in 
    (* construct the first binop*)
    let sl_binop_enode
      = Cil_types.BinOp (Cil_types.Shiftlt, edx_cast_exp, const_exp, Cil_types.TInt (Cil_types.IULongLong, [])) in
    let sl_binop_exp = Cil.new_exp loc sl_binop_enode in
    (* cast hwm_cpu_gprs_eax *)
    let eax_varinfo = (Globals.Vars.find_from_astinfo "hwm_cpu_gprs_eax" VGlobal) in
    let eax_enode = Cil_types.Lval (Cil.var eax_varinfo) in
    let eax_exp = Cil.new_exp loc eax_enode in
    let eax_cast_enode = Cil_types.CastE (Cil_types.TInt (IULongLong, []), eax_exp) in 
    let eax_cast_exp = Cil.new_exp loc eax_cast_enode in
    (* the whole binop*)
    let or_binop_enode
      = Cil_types.BinOp (Cil_types.BOr, sl_binop_exp, eax_cast_exp, Cil_types.TInt (Cil_types.IULongLong, [])) in
    let or_binop_exp = Cil.new_exp loc or_binop_enode in
    let ret_instr = Cil_types.Set(lv, or_binop_exp, loc) in
    let ret_stmt = Cil.mkStmt ~valid_sid:true (Cil_types.Instr ret_instr) in
    [ret_stmt]
;;


let casm_func_call_wrapper' lv_opt e e_list loc = 
  let pushl_kf = (Globals.Functions.find_by_name "_impl__casm__pushl_mem") in 
  let pushl_varinfo = (Globals.Functions.get_vi pushl_kf) in
  (* let try_lv = (Cil_types.Var try_varinfo, Cil_types.NoOffset) in *)
  let pushl_lv = Cil.var pushl_varinfo in
  let pushl_enode = Cil_types.Lval pushl_lv in
  let pushl_exp = Cil.new_exp loc pushl_enode in
  (*construct constant*)
  let const = Cil_types.CInt64 ((Integer.of_string "3735928559"), Cil_types.IUInt, Some "0xDEADBEEF") in 
  let const_enode = Cil_types.Const const in 
  let const_exp = Cil.new_exp loc const_enode in 
  let rip_instr = Cil_types.Call( None, pushl_exp, [const_exp], loc) in
  let rip_insert_stmt = Cil.mkStmt ~valid_sid:true (Cil_types.Instr rip_instr) in

  (* parameters set up*)
  let push_args = casm_func_call_push_args e_list in 
  let push_args_instrs = List.map (fun enode -> Cil_types.Call(None, pushl_exp, [Cil.new_exp loc enode], loc))  push_args in
  let push_args_stmts = List.map (fun instr -> Cil.mkStmt ~valid_sid:true (Cil_types.Instr instr)) push_args_instrs in

  (* pop args *)
  let addl_kf = (Globals.Functions.find_by_name "_impl__casm__addl_imm_esp") in 
  let addl_varinfo = (Globals.Functions.get_vi addl_kf) in
  let addl_lv = Cil.var addl_varinfo in
  let addl_enode = Cil_types.Lval addl_lv in
  let addl_exp = Cil.new_exp loc addl_enode in
  (* Const 0X40 *) 
  let pop_args = casm_func_call_pop_args e_list loc in 
  let pop_args_instrs = List.map (fun enode -> Cil_types.Call(None, addl_exp, [Cil.new_exp loc enode], loc))  pop_args in
  let pop_args_stmts = List.map (fun instr -> Cil.mkStmt ~valid_sid:true (Cil_types.Instr instr)) pop_args_instrs in
  let ret_stmt = casm_func_call_ret lv_opt loc in 

  (push_args_stmts @ [rip_insert_stmt], pop_args_stmts @ ret_stmt)
;;

let casm_func_call_wrapper lv_opt e e_list loc = 
  if is_casm_func_call e then (casm_func_call_wrapper' lv_opt e e_list loc) else ([],[])
;;

(*--------------------------------------------------------------------------*)
(* given a function comb through it and find calls *)
(*--------------------------------------------------------------------------*)
class function_call_visitor (p_kf : Cil_types.kernel_function) = object (self)

  inherit Visitor.frama_c_inplace
  (* see frama-c-api/html/Cil.cilVisitor-c.html on the list of method we can override *)

  (* note plugin development guide page 99 says that we need to use vstmt_aux and vglob_aux
  instead if vstmt and vglob *)
  
  (* statements are as in frama-c-api/html/Cil_types.html#TYPEstmtkind *)
  (* e.g, instruction -- no control flow change, return, goto, break etc. *)
  method! vstmt_aux (stmt: Cil_types.stmt) =
    (*Printer.pp_stmt Format.std_formatter stmt;*)
    
    match stmt.skind with
      | Instr (Call (lv_opt, e, e_list, loc)) ->
        Uberspark.Logger.log "Call()";
        let l_g_int_vi = (Globals.Vars.find_from_astinfo "g_int" VGlobal) in
        let l_instr = Cil_types.Set(Cil.var l_g_int_vi, Cil.integer ~loc 1, loc) in
        let l_insert_stmt = Cil.mkStmt ~valid_sid:true (Cil_types.Instr l_instr) in
        
        let (prologue, epilogue) = casm_func_call_wrapper lv_opt e e_list loc in

        l_insert_stmt.labels <- stmt.labels;
        stmt.labels <- [];
        let l_bloc_kind = Cil_types.Block(Cil.mkBlock ( (l_insert_stmt :: prologue) @ (stmt :: epilogue))) in
        let l_new_stmt = Cil.mkStmt ~valid_sid:true l_bloc_kind in
        Cil.ChangeTo l_new_stmt
  
      | _ ->
        Cil.DoChildren
    ;
  ;

  (* instructions are as in frama-c-api/html/Cil_types.html#TYPEinstr *)
  (* e.g., set, call, local_init, asm, skip etc. *)
  method! vinst (inst: Cil_types.instr) =


    (* Note sometimes the pretty printer can try to be smart and print additional instructions
      for example:
      return 0; gets converterd to
      _result = 0;
      return result;
      then when we get the Set() for _result=0; the pp_instr below will print both
    *)
    (*Printer.pp_instr Format.std_formatter inst;*)
    Cil.DoChildren
  ;

end


let find_function_calls
  (p_kf : Cil_types.kernel_function)
  : unit =

  let l_visitor = new function_call_visitor p_kf in
  Uberspark.Logger.log "finding calls within function...";

  ignore( Visitor.visitFramacFunction l_visitor (Kernel_function.get_definition p_kf)); 

  Uberspark.Logger.log "done!";

  ()
;;










(*--------------------------------------------------------------------------*)
(* given a function comb through it and find memory write statements or lvals 
and output those instructions or statements *)
(*--------------------------------------------------------------------------*)
(* input cilfunction kf
have visitor.visitframacfunction with class mem_write visitor 
class mem_write visitor can take in additional argument: one of them is kf, other can be flags or even a function to execute
whenever the mem_write statement is visited
experiment with vinst and vstmt and see what we get

use a global.function.iter to drive this analysis for all global functions 
*)
class mem_write_visitor (p_kf : Cil_types.kernel_function) = object (self)

  inherit Visitor.frama_c_inplace
  (* see frama-c-api/html/Cil.cilVisitor-c.html on the list of method we can override *)

  (* note plugin development guide page 99 says that we need to use vstmt_aux and vglob_aux
  instead if vstmt and vglob *)
  method! vstmt_aux (stmt: Cil_types.stmt) =
    (*Printer.pp_stmt Format.std_formatter stmt;

    if (Annotations.has_code_annot stmt) then begin
      Uberspark.Logger.log "<-- STMT WITH ANNOT -->");
    end else begin
      Uberspark.Logger.log "<-- STMT WITHOUT ANNOT -->");
    end;*)

    Cil.DoChildren
  ;

  method! vinst (inst: Cil_types.instr) =

    let l_kstmt = self#current_stmt in
    match l_kstmt with
      | Some stmt ->
          if (Annotations.has_code_annot stmt) then begin
            Uberspark.Logger.log "[WITH ANNOT]";

            (* remove the annotation *)
            (*let l_stmt_annot_list = Annotations.code_annot stmt in
            List.iter ( fun (x : Cil_types.code_annotation) -> 
              Annotations.remove_code_annot (Annotations.emitter_of_code_annot x stmt) stmt x;
            )l_stmt_annot_list;*)

            (* dump the annotation *)
            let l_stmt_annot_list = Annotations.code_annot stmt in
            List.iter ( fun (x : Cil_types.code_annotation) -> 
              dump_annotation x;
            )l_stmt_annot_list;



          end;
      | _ ->
        Uberspark.Logger.log "no statement for instruction, wierd!";
    ;

    match inst with
      | Set (lv, e, loc) ->
        Uberspark.Logger.log "Set()";
        let l_kstmt = self#current_stmt in
        match l_kstmt with
          | Some stmt ->

              (* create an annotation *)
              let l_assert = Logic_const.prel (Req, Cil.lzero(), Cil.lzero()) in
                Annotations.add_assert l_annotation_emitter stmt l_assert;
                Uberspark.Logger.log "Created assertion";

              (* remove the annotation *)
              (*let l_stmt_annot_list = Annotations.code_annot stmt in
              List.iter ( fun (x : Cil_types.code_annotation) -> 
                Annotations.remove_code_annot (Annotations.emitter_of_code_annot x stmt) stmt x;
              )l_stmt_annot_list;*)

              (* dump the annotation *)
              (*let l_stmt_annot_list = Annotations.code_annot stmt in
              List.iter ( fun (x : Cil_types.code_annotation) -> 
                dump_annotation x;
              )l_stmt_annot_list;
              *)
          | _ ->
            Uberspark.Logger.log "no statement for instruction, wierd!";
        ;
        
  
      | Call (None, e, e_list, loc) ->
        Uberspark.Logger.log "Call_nolv()";

      | Call (Some lv, e, e_list, loc) ->
        Uberspark.Logger.log "Call()";

      | Local_init (v, linit, loc) ->
        Uberspark.Logger.log "Local_init()";

      | Asm (attr, asminsns, Some e_asm, loc) ->
        Uberspark.Logger.log "Asm()";

      | Asm (attr, asminsns, None, loc) ->
        Uberspark.Logger.log "Asm_noext()";

      | Skip loc ->
        Uberspark.Logger.log "Skip()";

      | Code_annot (annot, loc) ->
        Uberspark.Logger.log "Code_annot()";
    ;

    (* Note sometimes the pretty printer can try to be smart and print additional instructions
      for example:
      return 0; gets converterd to
      _result = 0;
      return result;
      then when we get the Set() for _result=0; the pp_instr below will print both
    *)
    Printer.pp_instr Format.std_formatter inst;

    Cil.DoChildren
  ;



(*

|Call of vinst
|Local+init Consinit branch of vinst

  
treat_call
  lval_assertion
    check_array_access
      valid_index

check_uchar_assign
|Set branch of vinst
|Local+init Assigninit branch of vinst

|Lval branch of vexpr

*)


end


let find_memory_writes
  (p_kf : Cil_types.kernel_function)
  : unit =

  let l_visitor = new mem_write_visitor p_kf in
  Uberspark.Logger.log "finding instructions within function...";

  ignore( Visitor.visitFramacFunction l_visitor (Kernel_function.get_definition p_kf)); 

  Uberspark.Logger.log "done!";

  ()
;;




(* see section 4.17 in plugin development guide as well as
frama-c-api/html/Cil.html 

also see frama-c-api/html/Cil_types.html for the type; each method! name corresponds to a type
but not always same name; e.g., the vfunc method is for type funcdec*)
class ast_visitor = object(self)
  inherit Visitor.frama_c_inplace

  method! vfunc (fdec : Cil_types.fundec) =
    (* fdec.svar is varinfo type as in frama-c-api/html/Cil_types.html#TYPElocation *)
    Uberspark.Logger.log "global defined function: %s" fdec.svar.vname;
    
    (* location is in fdec.svar.vdecl as in frama-c-api/html/Cil_types.html#TYPElocation *)
    let (p1, p2) = fdec.svar.vdecl in 
    Filepath.pp_pos Format.std_formatter p1;
    Filepath.pp_pos Format.std_formatter p2;

    (* location is a Filepath.position per frama-c-api/html/Filepath.html#TYPEposition *)
    Uberspark.Logger.log " --> %s" (Filepath.Normalized.to_pretty_string p1.pos_path);
    Uberspark.Logger.log " --> %s" (Filepath.Normalized.to_pretty_string p2.pos_path);

    (* print number of statements in this function *)
    (* using sallstmts we need to make sure Cfg.computeCFGInfo is called; which seems to 
     be the default case: see frama-c-api/html/Cil_types.html#TYPEspec type fundec *)
    Uberspark.Logger.log " num statements=%u" 
      (List.length fdec.sallstmts);
    Uberspark.Logger.log " num statements from block=%u" 
      (List.length fdec.sbody.bstmts);


    (* print out function contract if any *)    
    try
      let l_kf = Globals.Functions.get fdec.svar in
      Uberspark.Logger.log "got global function definition";

      (* find first statement in the function *)
      let (l_first_stmt : Cil_types.stmt) = Kernel_function.find_first_stmt l_kf in
      Printer.pp_stmt Format.std_formatter l_first_stmt;

      (* find last statement in the function *)
      let (l_last_stmt : Cil_types.stmt) = List.nth fdec.sbody.bstmts  ((List.length fdec.sbody.bstmts)-1) in
      Printer.pp_stmt Format.std_formatter l_last_stmt;



      try 
        (* if populate is true then default function contract is generated: frama-c-api/html/Annotations.html *)
        let (l_kf_spec : Cil_types.funspec) = Annotations.funspec ~populate:false l_kf in

        Uberspark.Logger.log "function has specification: len(spec_behavior) = %u"  
          (List.length l_kf_spec.spec_behavior);

        let default_bhv = Cil.find_default_behavior l_kf_spec in
        match default_bhv with
        | None ->
            Uberspark.Logger.log "no default behavior";
        | Some (b : Cil_types.behavior) ->
            Uberspark.Logger.log "there is a default behavior, behavior name=%s" b.b_name;

        ;
      with Annotations.No_funspec _ ->
        Uberspark.Logger.log "function has no specifications!";
      ;  

    with Not_found -> 
        Uberspark.Logger.log "no such global function!";
    ;



    (Cil.DoChildren)
  ;

end;;


(* gather all global function definitions *)
let ast_get_global_function_definitions (p_ast_file :  Cil_types.file) : unit =

  let l_visitor = new ast_visitor in
  
  Visitor.visitFramacFileSameGlobals (l_visitor:>Visitor.frama_c_visitor) p_ast_file;

;;



(* our main function that works on the project we created *)
let ast_manipulation_main 
  ()
  : unit = 

    (* get Cil AST *)
    let file = Ast.get () in

    (* pretty print AST *)
    (* see frama-c-api/html/Printer_api.S_pp.html for Printer.pp_file documentation *)
    (*Kernel.CodeOutput.output (fun fmt -> Printer.pp_file fmt file);*)
	  Uberspark.Logger.log "Starting AST dump...";
    Printer.pp_file Format.std_formatter file;
		Uberspark.Logger.log "AST dump Done.";

    ast_get_global_function_definitions file;

    (* iterate through global functions: frama-c-api/html/Globals.Functions.html *)
    (* API on kernel functions here: frama-c-v20.0/frama-c-api/html/Kernel_function.html *)
    (* for each function find memory writes *)
    (*Globals.Functions.iter ( fun (l_kf : Cil_types.kernel_function) : unit ->
      if (Kernel_function.is_definition l_kf) then begin
        Uberspark.Logger.log "kernel function (definition): %s" (Kernel_function.get_name l_kf));
        find_memory_writes l_kf;
      end else begin
        Uberspark.Logger.log "kernel function (only declaration): %s" (Kernel_function.get_name l_kf));
      end;

      ()
    );*)


    (* iterate through global functions: frama-c-api/html/Globals.Functions.html *)
    (* API on kernel functions here: frama-c-v20.0/frama-c-api/html/Kernel_function.html *)
    (* for each function find function calls *)
    Globals.Functions.iter ( fun (l_kf : Cil_types.kernel_function) : unit ->
      if (Kernel_function.is_definition l_kf) then begin
        Uberspark.Logger.log "kernel function (definition): %s" (Kernel_function.get_name l_kf);
        find_function_calls l_kf;
      end else begin
        Uberspark.Logger.log "kernel function (only declaration): %s" (Kernel_function.get_name l_kf);
      end;

      ()
    );


    (* iterate through global variables: frama-c-api/html/Globals.Vars.html *)
    Globals.Vars.iter ( fun (l_varinfo: Cil_types.varinfo) (l_initinfo: Cil_types.initinfo) : unit ->
      Uberspark.Logger.log "global variable: %s" l_varinfo.vname;
      ()
    );


    (* create a global annotation *)
    (* frama-c-api/html/Annotations.html *)
  
    (* make a variable of type Cil_types.logic_info *)
    (* see frama-c-api/html/Cil_const.html *)
    let l_var_logic_info : Cil_types.logic_info =
      Cil_const.make_logic_info "test_is_separated" in

    (* the above logic variable is going to be a 
    predicate with a formal parameter; char * x *)
    (* note that : 
     frama-c-api/html/Cil.html#VALcharPtrType contains
     a list of functions that can be used to define
     a ton of pre-defined types
     
     we then cast the Cil_types.typ to Cil_types.logic_type
     using the Ctype variant; 
     *)

    let l_var_logic_info_param_1 : Cil_types.logic_var = 
      (Cil_const.make_logic_var_formal "x" 
        (Ctype ( Cil.charPtrType )) ) in
       
    (* stick it into the formal parameter field
     of l_var_logic_info *)
    l_var_logic_info.l_profile <- [ l_var_logic_info_param_1; ];

    (* one constructs body using logic terms and
    pedicates. Cil_types.term --> logic term
    Conversion from exp to term is given here:
    frama-c-api/html/Logic_utils.html
    so we take C expression and convert to logic
    term and make up the predicate body. At the last we need to
    have it as Cil_types.logic_body so we can stick it into
    l_var_logic_info.l_body *)


    (* Cil_type.logic_body which is l_body's type can be LBnone, LBterm of term 
    and others as in: frama-c-api/html/Cil_types.html#TYPElogic_body *)

    (* now we contruct a body which basically takes all global variables 
     and makes a separated predicate and && them together *)
    let l_body_predicate : Cil_types.predicate ref = ref (Logic_const.ptrue) in
    Globals.Vars.iter ( fun (l_varinfo: Cil_types.varinfo) (l_initinfo: Cil_types.initinfo) : unit ->
      let l_gvar_lval : Cil_types.lval = (Cil.var  l_varinfo) in
      let l_gvar_addrof_exp : Cil_types.exp = (Cil.mkAddrOf Cil_datatype.Location.unknown l_gvar_lval) in
      (* Logic_const.tvar converts form logic_var to term: frama-c-api/html/Logic_const.html *)
      let l_var_logic_info_param_1_term : Cil_types.term = (Logic_const.tvar l_var_logic_info_param_1) in 
      (* Logic_utils.expr_to_term converts exp to term; cast=true means we want C var cast
        see frama-c-api/html/Logic_utils.html *)
      let l_gvar_addrof_exp_term : Cil_types.term = (Logic_utils.expr_to_term ~cast:true l_gvar_addrof_exp) in

      let l_gvar_predicate : Cil_types.predicate = (Logic_const.pseparated [l_gvar_addrof_exp_term; l_var_logic_info_param_1_term]) in 
      l_body_predicate := (Logic_const.pand (!l_body_predicate,l_gvar_predicate));
      ()
    );


    l_var_logic_info.l_body <- (LBpred (!l_body_predicate));



    (* the type of global annotation is DFun_or_pred 
     as in frama-c-api/html/Cil_types.html for type
     global_annotation *)
    let l_dfun_or_pred : Cil_types.global_annotation =
      Dfun_or_pred (l_var_logic_info  , Cil_datatype.Location.unknown) in
  
    Annotations.add_global l_annotation_emitter l_dfun_or_pred;
    Uberspark.Logger.log "Created global annotation";





    (* iterate through global annotations:  frama-c-api/html/Annotations.html*)
    Annotations.iter_global ( fun (l_emitter : Emitter.t)
            (l_global_annot : Cil_types.global_annotation)
             : unit ->
      match l_global_annot with
        | Dfun_or_pred (p_logic_info, p_location) ->
            Uberspark.Logger.log "global annotation Dfun_or_pred";
            (* debug print the logic_info node: frama-c-api/html/Cil_types_debug.html *)
            (* note: constant ids in the dump can be generated 
            programmatically via new_raw_id as described in frama-c-api/html/Cil_const.html *)
            Cil_types_debug.pp_logic_info Format.std_formatter p_logic_info;
            Cil_types_debug.pp_logic_body Format.std_formatter p_logic_info.l_body;

        | _ ->
          Uberspark.Logger.log "uncategorized global annotation";
      ;

      ()
    );


    (* pretty print AST *)
    (* see frama-c-api/html/Printer_api.S_pp.html for Printer.pp_file documentation *)
    (*Kernel.CodeOutput.output (fun fmt -> Printer.pp_file fmt file);*)
	  Uberspark.Logger.log "Starting AST dump...";
    Printer.pp_file Format.std_formatter file;
		Uberspark.Logger.log "AST dump Done.";

  ()
;;




(* dump AST of the source files provided *)    		
let ast_dump 
    ()
    : unit =
	
  (* enforce AST computation *)
  Ast.compute ();

 let l_project = File.create_project_from_visitor "uberspark_ast"
        (fun prj -> new Visitor.frama_c_copy prj) in
    
    Project.on l_project ast_manipulation_main ();

    (* recompute CFG for value analysis *)
    Cfg.clearFileCFG ~clear_id:false (Ast.get());
    Cfg.computeFileCFG (Ast.get());

    (* set entry point for value analysis *)
    Globals.set_entry_point "main" true;
    !Db.Value.compute();

		Uberspark.Logger.log "Done with AST manipulation on project.";

		()
;;




