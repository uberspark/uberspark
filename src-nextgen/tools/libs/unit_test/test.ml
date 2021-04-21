open Mylib

let var_x : Mylib.A.a_type_t = {
  x = ""; y = "";
};;

let main () = 
  Mylib.B.b_proc2 var_x;
  ()
;;


main ();;