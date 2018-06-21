(*
	uberspark manifest parsing module
	author: amit vasudevan (amitvasudevan@acm.org)
*)

open Uslog
open Sys
open Yojson
open Str


(*
	**************************************************************************
	global variables
	**************************************************************************
*)


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


(*
	**************************************************************************
	module internal interfaces
	**************************************************************************
*)

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


let populate_uobj_uapicallmasks uobj_entry uobj_id = 
	try
		 	let open Yojson.Basic.Util in
			let uobj_0 = uobj_entry in 
			let i = ref 0 in
			
			Uslog.logf "test" Uslog.Info "populate_uobj_uapicallmasks: uobj_id=%u" uobj_id;

			let uobj_0_uapifn = uobj_0 |> member "uobj-uapifn" |> to_list in
			let uobj_0_uapifn_uobjname = myMap uobj_0_uapifn ~f:(fun uobj_0 -> member "uobj-name" uobj_0 |> to_string) in 
  		let uobj_0_uapifn_id = myMap uobj_0_uapifn ~f:(fun uobj_0 -> member "fnid" uobj_0 |> to_string) in 
  		let uobj_0_uapifn_opt1 = myMap uobj_0_uapifn ~f:(fun uobj_0 -> member "opt1" uobj_0 |> to_string) in 
  		let uobj_0_uapifn_opt2 = myMap uobj_0_uapifn ~f:(fun uobj_0 -> member "opt2" uobj_0 |> to_string) in 
				begin
					while (!i < (List.length uobj_0_uapifn)) do
						begin

									let tag_u_destslabname = (trim (List.nth uobj_0_uapifn_uobjname !i)) in
									let tag_u_destslabid = (Hashtbl.find slab_nametoid tag_u_destslabname) in
									let tag_u_uapifn = int_of_string (trim (List.nth uobj_0_uapifn_id !i)) in
									let tag_u_uapifnpre = (trim (List.nth uobj_0_uapifn_opt1 !i)) in
									let tag_u_uapifncheckassert = (trim (List.nth uobj_0_uapifn_opt2 !i)) in
									let tag_u_mask = ref 0 in
									let tag_u_uapikey = ref "" in
									let tag_u_tempstr = ref "" in

										Uslog.logf "test" Uslog.Info "populate_uobj_uapicallmasks: processing entry %u" !i;

										if (Hashtbl.mem slab_idtouapifnmask tag_u_destslabid) then
											begin
											tag_u_mask := Hashtbl.find slab_idtouapifnmask tag_u_destslabid; 
											tag_u_mask := !tag_u_mask lor (1 lsl tag_u_uapifn);
											Hashtbl.add slab_idtouapifnmask tag_u_destslabid !tag_u_mask;
											end
										else
											begin
											tag_u_mask := (1 lsl tag_u_uapifn);
											Hashtbl.add slab_idtouapifnmask tag_u_destslabid !tag_u_mask;
											end
										;

										(* make key *)
										tag_u_uapikey := tag_u_destslabname ^ "_" ^ (trim (List.nth uobj_0_uapifn_id !i));
										Uslog.logf "test" Uslog.Info "uapi key = %s\n" !tag_u_uapikey;
										if (Hashtbl.mem uapi_fnccomppre !tag_u_uapikey) then
											begin
											tag_u_tempstr := (Hashtbl.find uapi_fnccomppre !tag_u_uapikey);
											Hashtbl.add uapi_fnccomppre !tag_u_uapikey (!tag_u_tempstr ^ (Printf.sprintf "/* %s:*/\r\n" (Hashtbl.find slab_idtoname uobj_id)) ^ tag_u_uapifnpre ^ "\r\n");
											end
										else
											begin
											Hashtbl.add uapi_fnccomppre !tag_u_uapikey ( (Printf.sprintf "/* %s:*/\r\n" (Hashtbl.find slab_idtoname uobj_id)) ^ tag_u_uapifnpre ^ "\r\n");
											end
										;

										Uslog.logf "test" Uslog.Info "uapi fnccomppre =%s\n" (Hashtbl.find uapi_fnccomppre !tag_u_uapikey);

										if (Hashtbl.mem uapi_fnccompasserts !tag_u_uapikey) then
											begin
											tag_u_tempstr := (Hashtbl.find uapi_fnccompasserts !tag_u_uapikey);
											Hashtbl.add uapi_fnccompasserts !tag_u_uapikey (!tag_u_tempstr ^ (Printf.sprintf "/*@assert %s: " (Hashtbl.find slab_idtoname uobj_id)) ^ tag_u_uapifncheckassert ^ ";*/\r\n");
											end
										else
											begin
											Hashtbl.add uapi_fnccompasserts !tag_u_uapikey ((Printf.sprintf "/*@assert %s: " (Hashtbl.find slab_idtoname uobj_id)) ^ tag_u_uapifncheckassert ^ ";*/\r\n");
											end
										;

										Uslog.logf "test" Uslog.Info "uapi fnccompasserts =%s\n" (Hashtbl.find uapi_fnccompasserts !tag_u_uapikey);

								i := !i + 1;
						end
					done;
				end

	
	with Yojson.Json_error s -> 
			Uslog.logf "test" Uslog.Info "populate_uobj_characteristics: ERROR in parsing manifest!";
	;

;;

(*
*) 



(*
	**************************************************************************
	main interfaces
	**************************************************************************
*)

(* parse uobj manifest specified by uobj_mf_filename and store parsed info*)
(* indexed by uobj_id*)
let usmf_parse_uobj_mf uobj_mf_filename uobj_id = 
	try

		(* read the manifest JSON *)
  let json = Yojson.Basic.from_file uobj_mf_filename in

	  (* Locally open the JSON manipulation functions *)
	  let open Yojson.Basic.Util in
												
	with Yojson.Json_error s -> 
		Uslog.logf "test" Uslog.Info "ERROR in parsing manifest!";
	;
;;





