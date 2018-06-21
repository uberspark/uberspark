(*
	uberspark manifest parsing module
	author: amit vasudevan (amitvasudevan@acm.org)
*)
open Uslog

module Libusmf = 
	struct

(*
	**************************************************************************
	global variables
	**************************************************************************
*)
let slab_idtoname = ((Hashtbl.create 32) : ((int,string)  Hashtbl.t));;
let slab_idtotype = ((Hashtbl.create 32) : ((int,string)  Hashtbl.t));;
let slab_idtosubtype = ((Hashtbl.create 32) : ((int,string)  Hashtbl.t));;

let slab_nametoid = ((Hashtbl.create 32) : ((string,int)  Hashtbl.t));;
let slab_idtodir = ((Hashtbl.create 32) : ((int,string)  Hashtbl.t));;
let slab_idtogsm = ((Hashtbl.create 32) : ((int,string)  Hashtbl.t));;
let slab_idtommapfile = ((Hashtbl.create 32) : ((int,string)  Hashtbl.t));;

let slab_idtocallmask = ((Hashtbl.create 32) : ((int,int)  Hashtbl.t));;
let slab_idtocalleemask = ((Hashtbl.create 32) : ((int,int)  Hashtbl.t));;


(*
	**************************************************************************
	debugging related
	**************************************************************************
*)
let dbg_dump_string string_value =
  	Uslog.logf "test" Uslog.Info "string value: %s" string_value
		

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


(*
	**************************************************************************
	module internal interfaces
	**************************************************************************
*)

let usmf_populate_uobj_base_characteristics uobj_entry uobj_mf_filename uobj_id = 
	try
		 	let open Yojson.Basic.Util in
		 	let uobj_name = uobj_entry |> member "uobj-name" |> to_string in
		 	let uobj_type = uobj_entry |> member "uobj-type" |> to_string in
		 	let uobj_subtype = uobj_entry |> member "uobj-subtype" |> to_string in
			let uobj_dir = (Filename.dirname uobj_mf_filename) in
    	let uobj_mmapfile = uobj_dir ^ "_objects/_objs_slab_" ^ uobj_name ^ "/" ^ uobj_name ^ ".mmap" in

				Uslog.logf "libusmf" Uslog.Info "uobj-name:%s" uobj_name;
				Uslog.logf "libusmf" Uslog.Info "uobj-type:%s" uobj_type;
				Uslog.logf "libusmf" Uslog.Info "uobj-subtype:%s" uobj_subtype;
				Hashtbl.add slab_idtoname uobj_id uobj_name;
				Hashtbl.add slab_idtotype uobj_id uobj_type;
				Hashtbl.add slab_idtosubtype uobj_id uobj_subtype;
				Hashtbl.add slab_nametoid uobj_name uobj_id;
				Hashtbl.add slab_idtodir uobj_id uobj_dir;
				Hashtbl.add slab_idtogsm uobj_id uobj_mf_filename;
				Hashtbl.add slab_idtommapfile uobj_id uobj_mmapfile;


	with Yojson.Json_error s -> 
			Uslog.logf "test" Uslog.Info "usmf_populate_uobj_base_characteristics: ERROR in parsing manifest!";
	;

;;


let usmf_populate_uobj_callmasks uobj_entry uobj_id = 
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
									Uslog.logf "libusmf" Uslog.Info "destslabname=%s, id=%d\n" tag_s_destslabname (Hashtbl.find slab_nametoid tag_s_destslabname);
		            	
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
			Uslog.logf "test" Uslog.Info "usmf_populate_uobj_callmasks: ERROR in parsing manifest!";
	;

;;



(*
	**************************************************************************
	main interfaces
	**************************************************************************
*)

(* parse uobj list file specified by uobj_list_filename and generate the *)
(* required mappings from uobj name to uobj id and vice versa *)
let usmf_parse_uobj_list uobj_list_filename = 
	try

	(* read the uobj list JSON *)
  let uobj_entry = Yojson.Basic.from_file uobj_mf_filename in
	  (* Locally open the JSON manipulation functions *)
	  let open Yojson.Basic.Util in
			usmf_populate_uobj_base_characteristics	uobj_entry uobj_mf_filename uobj_id;
			usmf_populate_uobj_callmasks uobj_entry uobj_id;

	with Yojson.Json_error s -> 
		Uslog.logf "test" Uslog.Info "ERROR in parsing manifest!";
	;




(* parse uobj manifest specified by uobj_mf_filename and store parsed info*)
(* indexed by uobj_id*)
let usmf_parse_uobj_mf uobj_mf_filename uobj_id = 
	try

	(* read the manifest JSON *)
  let uobj_entry = Yojson.Basic.from_file uobj_mf_filename in
	  (* Locally open the JSON manipulation functions *)
	  let open Yojson.Basic.Util in
			usmf_populate_uobj_base_characteristics	uobj_entry uobj_mf_filename uobj_id;
			usmf_populate_uobj_callmasks uobj_entry uobj_id;

	with Yojson.Json_error s -> 
		Uslog.logf "test" Uslog.Info "ERROR in parsing manifest!";
	;


end



