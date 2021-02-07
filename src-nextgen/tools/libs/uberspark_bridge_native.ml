(*
	uberSpark bridge, native sub-module
	author: amit vasudevan (amitvasudevan@acm.org)
*)

let run_shell_command 
   	?(context_path_builddir = ".")
    (context_path : string)
    (d_cmd : string)
    (bridge_ns : string)
    : int =
    
    let revised_d_cmd = ref "" in
        (*revised_d_cmd := "cd " ^ context_path_builddir ^ " && " ^ d_cmd;*)
        revised_d_cmd := d_cmd;

    let cmdline = ref [] in
    
        cmdline := !cmdline @ [ "-c" ];
        cmdline := !cmdline @ [ !revised_d_cmd ];

 
        let (r_exitcode, r_signal, _) = Uberspark_osservices.exec_process_withlog 
                ~stag:"sh" "sh" !cmdline in
		(r_exitcode)
;;

