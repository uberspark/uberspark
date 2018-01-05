(*
	uberspark blueprint parsing module
	author: amit vasudevan (amitvasudevan@acm.org)
*)

open Uslog
open Usmf
open Sys
open Yojson
open Str


(*
	**************************************************************************
	global variables
	**************************************************************************
*)
let g_memoffsets = ref 0;; (* 0 or 1; 0 signifies no memoffsets and 1 implies memoffsets *)
let g_rootdir = ref "";; (*	rootdirectory of the uobjects; where .usbp resides *)
let g_totalslabs = ref 0;; (*total number of uobjs*)

let slab_idtodir = ((Hashtbl.create 32) : ((int,string)  Hashtbl.t));;
let slab_idtogsm = ((Hashtbl.create 32) : ((int,string)  Hashtbl.t));;
let slab_idtommapfile = ((Hashtbl.create 32) : ((int,string)  Hashtbl.t));;
let slab_idtoname = ((Hashtbl.create 32) : ((int,string)  Hashtbl.t));;
let slab_idtotype = ((Hashtbl.create 32) : ((int,string)  Hashtbl.t));;
let slab_idtosubtype = ((Hashtbl.create 32) : ((int,string)  Hashtbl.t));;
let slab_nametoid = ((Hashtbl.create 32) : ((string,int)  Hashtbl.t));;

let slab_idtocallmask = ((Hashtbl.create 32) : ((int,int)  Hashtbl.t));;
let slab_idtocalleemask = ((Hashtbl.create 32) : ((int,int)  Hashtbl.t));;

	

(*
	**************************************************************************
	debugging related
	**************************************************************************
*)
let dbg_dump_string string_value =
  Uslog.logf "test" Uslog.Info "string value: %s" string_value;
			;;


(*
	**************************************************************************
	helper interfaces
	**************************************************************************
*)
let left_pos s len =
  let rec aux i =
    if i >= len then None
    else match s.[i] with
    | ' ' | '\n' | '\t' | '\r' -> aux (succ i)
    | _ -> Some i
  in
  aux 0
 
let right_pos s len =
  let rec aux i =
    if i < 0 then None
    else match s.[i] with
    | ' ' | '\n' | '\t' | '\r' -> aux (pred i)
    | _ -> Some i
  in
  aux (pred len)
  
let trim s =
  let len = String.length s in
  match left_pos s len, right_pos s len with
  | Some i, Some j -> String.sub s i (j - i + 1)
  | None, None -> ""
  | _ -> assert false

let rec myMap ~f l = match l with
 | [] -> []
 | h::t -> (f h) :: (myMap ~f t);;


let populate_uobj_characteristics uobj_entry = 
	try
		 	let open Yojson.Basic.Util in
			let uobj_0 = uobj_entry in 
			
				let slabname = uobj_0 |> member "name" |> to_string in
  			let slabdir = uobj_0 |> member "dir" |> to_string in
  			let slabtype = uobj_0 |> member "type" |> to_string in
  			let slabsubtype = uobj_0 |> member "subtype" |> to_string in
  			let slabgsmfile = !g_rootdir ^ slabdir ^ "/" ^ slabname ^ ".gsm.pp" in
	    	let slabmmapfile = !g_rootdir ^ "_objects/_objs_slab_" ^ slabname ^ "/" ^ slabname ^ ".mmap" in

				  Uslog.logf "test" Uslog.Info "uobj_0: name: %s" slabname;

					Hashtbl.add slab_idtodir !g_totalslabs slabdir;
					Hashtbl.add slab_idtoname !g_totalslabs slabname;
					Hashtbl.add slab_idtotype !g_totalslabs slabtype;
					Hashtbl.add slab_idtosubtype !g_totalslabs slabsubtype;
					Hashtbl.add slab_idtogsm !g_totalslabs slabgsmfile;
					Hashtbl.add slab_idtommapfile !g_totalslabs slabmmapfile;
					Hashtbl.add slab_nametoid slabname !g_totalslabs;

					(* compute next uobj id *)
					g_totalslabs := !g_totalslabs + 1;

	with Yojson.Json_error s -> 
			Uslog.logf "test" Uslog.Info "populate_uobj_characteristics: ERROR in parsing manifest!";
	;

;;



let populate_uobj_callmasks uobj_entry uobj_id = 
	try
		 	let open Yojson.Basic.Util in
			let uobj_0 = uobj_entry in 
			let i = ref 0 in
			
			let uobj_0_callees = uobj_0 |> member "uobj-callees" |> to_string in
			let uobj_0_callees_list = (Str.split (Str.regexp "[ \r\n\t]+") uobj_0_callees) in
				begin
					while (!i < (List.length uobj_0_callees_list)) do
						begin
		            let tag_s_destslabname = (trim (List.nth uobj_0_callees_list !i)) in
		            let tag_s_mask = ref 0 in
									Uslog.logf "test" Uslog.Info "destslabname=%s, id=%d\n" tag_s_destslabname (Hashtbl.find slab_nametoid tag_s_destslabname);
		            	
		            	if (Hashtbl.mem slab_idtocallmask (Hashtbl.find slab_nametoid tag_s_destslabname)) then
		            		begin
		            			tag_s_mask := Hashtbl.find slab_idtocallmask (Hashtbl.find slab_nametoid tag_s_destslabname);
		            			tag_s_mask := !tag_s_mask lor (1 lsl uobj_id);
		            			Hashtbl.add slab_idtocallmask (Hashtbl.find slab_nametoid tag_s_destslabname) !tag_s_mask;
		            		end
		            	else
		            		begin
		            			tag_s_mask := (1 lsl uobj_id);
		            			Hashtbl.add slab_idtocallmask (Hashtbl.find slab_nametoid tag_s_destslabname) !tag_s_mask;
		            		end
		            	;
		            
		            	if (Hashtbl.mem slab_idtocalleemask uobj_id) then
		            		begin
		            			tag_s_mask := Hashtbl.find slab_idtocalleemask uobj_id;
		            			tag_s_mask := !tag_s_mask lor (1 lsl (Hashtbl.find slab_nametoid tag_s_destslabname));
		            			Hashtbl.add slab_idtocalleemask uobj_id !tag_s_mask;
		            		end
		            	else
		            		begin
		            			tag_s_mask := (1 lsl (Hashtbl.find slab_nametoid tag_s_destslabname));
		            			Hashtbl.add slab_idtocalleemask uobj_id !tag_s_mask;
		            		end
		            	;
							
							i := !i + 1;
						end
					done;
				end

	
	with Yojson.Json_error s -> 
			Uslog.logf "test" Uslog.Info "populate_uobj_characteristics: ERROR in parsing manifest!";
	;

;;

(*
			let uobj_0_uapifn = uobj_0 |> member "uobj-uapifn" |> to_list in
			let uobj_0_uapifn_name = myMap uobj_0_uapifn ~f:(fun uobj_0 -> member "name" uobj_0 |> to_string) in 
  		let uobj_0_uapifn_id = myMap uobj_0_uapifn ~f:(fun uobj_0 -> member "id" uobj_0 |> to_string) in 
  		let uobj_0_uapifn_opt1 = myMap uobj_0_uapifn ~f:(fun uobj_0 -> member "opt1" uobj_0 |> to_string) in 
  		let uobj_0_uapifn_opt2 = myMap uobj_0_uapifn ~f:(fun uobj_0 -> member "opt2" uobj_0 |> to_string) in 
*) 



(*
	**************************************************************************
	main interfaces
	**************************************************************************
*)


let parse_ubp filename = 
	try

		(* read the manifest JSON *)
  let json = Yojson.Basic.from_file filename in

	  (* Locally open the JSON manipulation functions *)
	  let open Yojson.Basic.Util in
	  	let uobjs = json |> member "uobjs" |> to_list in
			let i = ref 0 in
					(* List.iter parse_ubp_entry uobjs; *)
				List.iter populate_uobj_characteristics uobjs;

				while (!i < (List.length uobjs)) do
					begin
					populate_uobj_callmasks (List.nth uobjs !i) !i;
					i := !i + 1;
					end
				done;
												
	with Yojson.Json_error s -> 
		Uslog.logf "test" Uslog.Info "ERROR in parsing manifest!";
	;
;;



(*
	**************************************************************************
	test rig
	**************************************************************************
*)

let main () =
	Uslog.current_level := Uslog.ord Uslog.Info;

	let len = Array.length Sys.argv in
		if len = 4 then
	    	begin
					g_memoffsets := int_of_string(Sys.argv.(2));
					g_rootdir := Sys.argv.(3);
					Uslog.logf "test" Uslog.Info "Manifest file: %s" Sys.argv.(1);
					Uslog.logf "test" Uslog.Info "g_memoffsets=%u\n" !g_memoffsets;
					Uslog.logf "test" Uslog.Info "g_rootdir=%s\n" !g_rootdir;
					parse_ubp Sys.argv.(1);
					Uslog.logf "test" Uslog.Info "All done!\n";
				end
		else
				begin
					Uslog.logf "test" Uslog.Info "Insufficient Parameters!";
				end

	;;
		
main ();;




