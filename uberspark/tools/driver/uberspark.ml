(* uberspark config tool: to locate hwm, libraries and headers *)
(* author: amit vasudevan (amitvasudevan@acm.org) *)

open Sys
open Unix

let g_install_prefix = "/usr/local";;
let g_uberspark_install_bindir = "/usr/local/bin";;
let g_uberspark_install_homedir = "/usr/local/uberspark";;
let g_uberspark_install_includedir = "/usr/local/uberspark/include";;
let g_uberspark_install_hwmdir = "/usr/local/uberspark/hwm";;
let g_uberspark_install_hwmincludedir = "/usr/local/uberspark/hwm/include";;
let g_uberspark_install_libsdir = "/usr/local/uberspark/libs";;
let g_uberspark_install_libsincludesdir = "/usr/local/uberspark/libs/include";;
let g_uberspark_install_toolsdir = "/usr/local/uberspark/tools";;


let copt_builduobj = ref false;;
 
 
let main () =
	begin
		let speclist = [
			("--builduobj", Arg.Set copt_builduobj, "Build uobj binary by compiling and linking");
			("-b", Arg.Set copt_builduobj, "Build uobj binary by compiling and linking");
		] in
		let usage_msg = "uberSpark driver tool by Amit Vasudevan (amitvasudevan@acm.org)" in
			Arg.parse speclist print_endline usage_msg;
			print_endline ("copt_builduobj: " ^ string_of_bool !copt_builduobj);
	end
	;;
 

(* 
let main () =
	let len = Array.length Sys.argv in
		if len = 2 then
	    	begin
	      		if (compare "--print-uberspark-bindir" Sys.argv.(1)) = 0 then
	      			begin
						print_string g_uberspark_install_bindir;
	      				print_newline ();
	      			end
	      		else if (compare "--print-uberspark-homedir" Sys.argv.(1)) = 0 then
	      			begin
						print_string g_uberspark_install_homedir;
	      				print_newline ();
	      			end
	      		else if (compare "--print-uberspark-includedir" Sys.argv.(1)) = 0 then
	      			begin
						print_string g_uberspark_install_includedir;
	      				print_newline ();
	      			end
	      		else if (compare "--print-uberspark-hwmdir" Sys.argv.(1)) = 0 then
	      			begin
						print_string g_uberspark_install_hwmdir;
	      				print_newline ();
	      			end
	      		else if (compare "--print-uberspark-hwmincludedir" Sys.argv.(1)) = 0 then
	      			begin
						print_string g_uberspark_install_hwmincludedir;
	      				print_newline ();
	      			end
	      		else if (compare "--print-uberspark-libsdir" Sys.argv.(1)) = 0 then
	      			begin
						print_string g_uberspark_install_libsdir;
	      				print_newline ();
	      			end
	      		else if (compare "--print-uberspark-libsincludesdir" Sys.argv.(1)) = 0 then
	      			begin
						print_string g_uberspark_install_libsincludesdir;
	      				print_newline ();
	      			end
	      		else if (compare "--print-uberspark-toolsdir" Sys.argv.(1)) = 0 then
	      			begin
						print_string g_uberspark_install_toolsdir;
	      				print_newline ();
	      			end
	      		else
	      			begin
						print_string "Invalid argument!";
						print_newline ();
	      			end
	    	end
	    else
	    	begin
				print_string "Too many arguments!";
				print_newline ();
			end
		;;
*)
		
main ();;


