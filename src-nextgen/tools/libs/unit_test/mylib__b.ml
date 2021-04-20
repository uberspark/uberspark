type b_type_t =
{
	mutable x : string;
    mutable y : string;
};;


let b_proc1 (p_arg: int) : unit = 
    Printf.sprintf "%d" p_arg;
    ()
;;

let b_proc2 (p_arg: Mylib.A.a_type_t) : unit = 
    Printf.sprintf "%s" p_arg.x;
    ()
;;
