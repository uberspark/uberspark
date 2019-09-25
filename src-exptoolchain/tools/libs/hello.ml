open Unix
open Uberspark

let myval : Uberspark.Usuobj.sentinel_info_t = {s_type="sample"};;

let main () = 
  (*Uberspark.Logger.log "sample";*)
  Uberspark.Usuobj.my_method;
  print_string "Hello world!\n";
  ()
;;


main ();;