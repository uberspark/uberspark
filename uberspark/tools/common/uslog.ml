(*
	uberspark log module
	author: amit vasudevan (amitvasudevan@acm.org)
*)

module Uslog =
	struct
  	let uslog_testnum = ref 0

		let uslog_log () = 
			print_int !uslog_testnum;
			print_newline ();
			()

	end