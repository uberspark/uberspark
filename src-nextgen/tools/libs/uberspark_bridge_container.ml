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
    let bridge_ns_docker = ((Str.string_after Uberspark_config.namespace_root 1) ^ "/" ^ bridge_ns) in 
    let cmdline = ref [] in
    
        cmdline := !cmdline @ [ "build" ];
        cmdline := !cmdline @ [ "--rm" ];
        cmdline := !cmdline @ [ "-f" ];
        cmdline := !cmdline @ [ bridge_container_filepath ];
        cmdline := !cmdline @ [ "-t" ];
        cmdline := !cmdline @ [ bridge_ns_docker ];
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

    let (rval, context_path_abs) = (Uberspark_osservices.abspath context_path) in
    if(rval == true) then begin

        let bridge_ns_docker = ((Str.string_after Uberspark_config.namespace_root 1) ^ "/" ^ bridge_ns) in 
        let cmdline = ref [] in
        
            cmdline := !cmdline @ [ "run" ];
            cmdline := !cmdline @ [ "--rm" ];
            cmdline := !cmdline @ [ "-i" ];
            (*cmdline := !cmdline @ [ "-e" ];*)
            (* cmdline := !cmdline @ [ "D_CMD=\"" ^ d_cmd ^ "\""]; *)
            (*cmdline := !cmdline @ [ "D_CMD=" ^ d_cmd];*)
            cmdline := !cmdline @ [ "-v" ];
            cmdline := !cmdline @ [ "src:" ^ context_path_abs ];
            cmdline := !cmdline @ [ "-t" ];
            cmdline := !cmdline @ [ bridge_ns_docker ];
            cmdline := !cmdline @ [ "/bin/sh" ];
            cmdline := !cmdline @ [ "-c" ];
            cmdline := !cmdline @ [ d_cmd ];



            let (r_exitcode, r_signal, _) = Uberspark_osservices.exec_process_withlog 
                    ~stag:"docker" "docker" !cmdline in
            (r_exitcode)
    end else begin 
            (1)
    end;
;;

