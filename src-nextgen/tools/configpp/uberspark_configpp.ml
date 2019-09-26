(*
  uberSpark configuration pre-processing tool
  author: amit vasudevan <amitvasudevan@acm.org>
*)

open Unix
open Sys
open Yojson

let main () = 
  let root_dir = Sys.getcwd () in
  Printf.printf "Current directory:%s" root_dir;
;;


main ();;

