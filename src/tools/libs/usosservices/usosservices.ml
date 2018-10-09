(*
	uberSpark OS services interface
	author: amit vasudevan (amitvasudevan@acm.org)
*)

open Unix

module UsOsservices =
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

	end