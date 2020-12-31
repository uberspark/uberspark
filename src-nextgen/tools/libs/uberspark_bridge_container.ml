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
        Uberspark_namespace.namespace_bridge_container_filename in
    (*let bridge_ns_docker = ((Str.string_after Uberspark_namespace.namespace_root 1) ^ "/" ^ bridge_ns) in *)
    let bridge_ns_docker = bridge_ns in
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
	?(context_path_builddir = ".")
    (context_path : string)
    (d_cmd : string)
    (bridge_ns: string)
    : int =

    let revised_d_cmd = ref "" in
        (*revised_d_cmd := "cd " ^ context_path_builddir ^ " && " ^ d_cmd;*)
        revised_d_cmd := d_cmd;

    let (rval, context_path_abs) = (Uberspark_osservices.abspath context_path) in
    if(rval == true) then begin

        Uberspark_logger.log ~lvl:Uberspark_logger.Debug "context_path=%s" context_path_abs;
        let r_d_cmd = ("cd " ^ Uberspark_namespace.namespace_bridge_container_mountpoint ^ " && " ^ !revised_d_cmd) in 
        (*let bridge_ns_docker = ((Str.string_after Uberspark_namespace.namespace_root 1) ^ "/" ^ bridge_ns) in *)
        let bridge_ns_docker = bridge_ns in
        let cmdline = ref [] in
        
            cmdline := !cmdline @ [ "run" ];
            cmdline := !cmdline @ [ "--rm" ];
            (* cmdline := !cmdline @ [ "-i" ]; *)
            cmdline := !cmdline @ [ "-e" ];
            cmdline := !cmdline @ [ "D_CMD=\"" ^ r_d_cmd ^ "\"" ];
            cmdline := !cmdline @ [ "-v" ];
            cmdline := !cmdline @ [ (Uberspark_namespace.get_namespace_root_dir_prefix ()) ^ ":" ^ (Uberspark_namespace.get_namespace_root_dir_prefix ()) ];
            cmdline := !cmdline @ [ "-v" ];
            cmdline := !cmdline @ [ context_path_abs ^ ":" ^ Uberspark_namespace.namespace_bridge_container_mountpoint ];
            cmdline := !cmdline @ [ "-t" ];
            cmdline := !cmdline @ [ bridge_ns_docker ];
            (*cmdline := !cmdline @ [ "/bin/sh" ];
            cmdline := !cmdline @ [ "-c" ];
            cmdline := !cmdline @ [ r_d_cmd ];
            *)

            Uberspark_logger.log ~lvl:Uberspark_logger.Debug "exec=%s" (String.concat " " !cmdline);

            let (r_exitcode, r_signal, _) = Uberspark_osservices.exec_process_withlog 
                    ~stag:"docker" "docker" !cmdline in
            (r_exitcode)
    end else begin 
            (1)
    end;
;;

