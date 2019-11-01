(*
	uberSpark bridge, container sub-module
	author: amit vasudevan (amitvasudevan@acm.org)
*)

(****************************************************************************)
(* docker container command interfaces *)
(****************************************************************************)

let build_image 
    (bridge_container_path : string)
    (bridge_ns: string)
    : int =
    
    let bridge_container_filepath = bridge_container_path ^ "/" ^
        Uberspark_config.namespace_bridge_container_filename in
    let cmdline = ref [] in
    
        cmdline := !cmdline @ [ "build" ];
        cmdline := !cmdline @ [ "--rm" ];
        cmdline := !cmdline @ [ "-f" ];
        cmdline := !cmdline @ [ bridge_container_filepath ];
        cmdline := !cmdline @ [ "-t" ];
        cmdline := !cmdline @ [ bridge_ns ];
        cmdline := !cmdline @ [ bridge_container_path ];

        let (r_exitcode, r_signal, _) = Uberspark_osservices.exec_process_withlog 
                ~stag:"docker" "docker" !cmdline in
		(r_exitcode)
;;


let list_images 
    (str: string)=
    let cmdline = ref [] in
        cmdline := !cmdline @ [ "images" ];
        let (r_exitcode, r_signal, _) = Uberspark_osservices.exec_process_withlog ~stag:"docker" "docker" !cmdline in
		()
;;


let run_image 
    (context_path : string)
    (d_cmd : string)
    (bridge_ns: string)
    : int =
    
    let cmdline = ref [] in
    
        cmdline := !cmdline @ [ "run" ];
        cmdline := !cmdline @ [ "--rm" ];
        cmdline := !cmdline @ [ "-i" ];
        cmdline := !cmdline @ [ "-e" ];
        cmdline := !cmdline @ [ "D_CMD=\"" ^ d_cmd ^ "\""];
        cmdline := !cmdline @ [ "-v" ];
        cmdline := !cmdline @ [ "src:" ^ context_path ];
        cmdline := !cmdline @ [ "-t" ];
        cmdline := !cmdline @ [ bridge_ns ];

        let (r_exitcode, r_signal, _) = Uberspark_osservices.exec_process_withlog 
                ~stag:"docker" "docker" !cmdline in
		(r_exitcode)
;;

