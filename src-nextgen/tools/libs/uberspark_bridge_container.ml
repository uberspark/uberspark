(*
	uberSpark bridge, container sub-module
	author: amit vasudevan (amitvasudevan@acm.org)
*)

(****************************************************************************)
(* docker container command interfaces *)
(****************************************************************************)
let list_images 
    (str: string)=
    let cmdline = ref [] in
        cmdline := !cmdline @ [ "images" ];
        let (r_exitcode, r_signal, _) = Uberspark_osservices.exec_process_withlog ~stag:"docker" "docker" !cmdline in
		()
;;


