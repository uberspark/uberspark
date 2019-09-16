(*
	uberSpark OS services interface
	author: amit vasudevan (amitvasudevan@acm.org)
*)

open Unix
open Sys
open Uslog

module Usosservices =
	struct
		
	let file_copy input_name output_name =
		let buffer_size = 8192 in
		let buffer = Bytes.create buffer_size in
	  let fd_in = openfile input_name [O_RDONLY] 0 in
	  let fd_out = openfile output_name [O_WRONLY; O_CREAT; O_TRUNC] 0o666 in
	  let rec copy_loop () = match read fd_in buffer 0 buffer_size with
	    |  0 -> ()
	    | r -> ignore (write fd_out buffer 0 r); copy_loop ()
	  in
	  copy_loop ();
	  close fd_in;
	  close fd_out;
		()
	;;


	let file_concat output_name input_name_list =
	  let fd_out = openfile output_name [O_WRONLY; O_CREAT; O_TRUNC] 0o666 in

		List.iter (fun x ->  
			let buffer_size = 8192 in
			let buffer = Bytes.create buffer_size in
		  let fd_in = openfile x [O_RDONLY] 0 in
		  let rec copy_loop () = match read fd_in buffer 0 buffer_size with
		    |  0 -> ()
		    | r -> ignore (write fd_out buffer 0 r); copy_loop ()
		  in
		  copy_loop ();
		  close fd_in;
		) input_name_list;

		close fd_out;
		()
	;;



	let file_remove filename =
		Sys.remove filename;
		()
	;;


	(* execute a process and print its output if verbose is set to true *)
	(* return the error code of the process and the output as a list of lines *)
	let exec_process_withlog p_name cmdline verbose verbose_mod_tag =
		let readme, writeme = Unix.pipe () in
		let pid = Unix.create_process
			p_name (Array.of_list ([p_name] @ cmdline))
	    Unix.stdin writeme writeme in
	  Unix.close writeme;
	  let in_channel = Unix.in_channel_of_descr readme in
	  let p_output = ref [] in
		let p_singleoutputline = ref "" in
		let p_exitstatus = ref 0 in
		let p_exitsignal = ref false in
	  begin
	    try
	      while true do
					p_singleoutputline := input_line in_channel;
					if verbose then
						Uslog.logf verbose_mod_tag Uslog.Info "%s" !p_singleoutputline;
											
					p_output := p_singleoutputline :: !p_output 
		    done
	    with End_of_file -> 
				match	(Unix.waitpid [] pid) with
	    	| (wpid, Unix.WEXITED status) ->
	        	p_exitstatus := status;
						p_exitsignal := false;
	    	| (wpid, Unix.WSIGNALED signal) ->
	        	p_exitsignal := true;
	    	| (wpid, Unix.WSTOPPED signal) ->
	        	p_exitsignal := true;
				;
				()
	  end;
	
		Unix.close readme;
		(!p_exitstatus, !p_exitsignal, (List.rev !p_output))
	;;


	let abspath path =
		let curdir = Unix.getcwd () in
		let retval = ref true in
		let path_filename = (Filename.basename path) in
		let path_dirname = (Filename.dirname path) in
		let retval_abspath = ref "" in
			try
				Unix.chdir path_dirname;
				retval_abspath := Unix.getcwd ();
				retval_abspath := !retval_abspath ^ "/" ^ path_filename;
				Unix.chdir curdir;
				
			with Unix.Unix_error (ecode, fname, fparam) -> 
				retval := false;
			;
	
		(!retval, !retval_abspath)
	;;


	let dir_change path =
		let retval = ref true in
		let retval_prevpath = ref "" in
		let retval_curpath = ref "" in
			try
				retval_prevpath := Unix.getcwd ();
				Unix.chdir path;
				retval_curpath := Unix.getcwd ();

			with Unix.Unix_error (ecode, fname, fparam) -> 
				retval := false;
			;
	
		(!retval, !retval_prevpath, !retval_curpath)
	;;


	let mkdir path perm =
		let retval = ref true in
		let retecode = ref Unix.EFAULT in
		let reterrmsg = ref "" in
		try
    	Unix.mkdir path perm;
		with Unix.Unix_error (ecode, fname, fparam) -> 
				reterrmsg := Unix.error_message ecode;
				retecode := ecode;
				retval := false;
		;

		(!retval, !retecode, !reterrmsg)
	;;

	end
	
(*	
				let info =
    			try Unix.stat uobj_binary_filename
    			with Unix.Unix_error (e, _, _) ->
						Uslog.logf log_tag Uslog.Error "no %s: %s!" uobj_binary_filename
								(Unix.error_message e);
      			exit 1 in
		   		Uslog.logf log_tag Uslog.Info "filesize=%u" info.Unix.st_size;
*)