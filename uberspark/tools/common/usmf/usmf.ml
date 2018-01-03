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

let usmf_fnametoverifopts = ((Hashtbl.create 32) : ((string,string)  Hashtbl.t));;
let g_cfiles_list = ref [""];;

let slab_nametoid = ((Hashtbl.create 32) : ((string,int)  Hashtbl.t));;
let slab_idtocallmask = ((Hashtbl.create 32) : ((int,int)  Hashtbl.t));;
let slab_idtocalleemask = ((Hashtbl.create 32) : ((int,int)  Hashtbl.t));;



(*
	**************************************************************************
	debug helpers
	**************************************************************************
*)

let dbg_dump_hashtbl key value = 
	Uslog.logf "test" Uslog.Info "key=%s, value=%s" key value;
	;;

let dbg_dump_list_string str_value = 
	Uslog.logf "test" Uslog.Info "list item==%s" str_value;
	;;

let do_action_on_cfile cfilename =
  Uslog.logf "test" Uslog.Info "c-file name: %s" cfilename;
			;;

let do_action_on_vharness_file filename =
  Uslog.logf "test" Uslog.Info "v-harness(file): %s" filename;
			;;

let do_action_on_vharness_options optionstring =
  Uslog.logf "test" Uslog.Info "v-harness(options): %s" optionstring;
			;;

	
(*
	**************************************************************************
	helpers
	**************************************************************************
*)
let usmf_handle_uobj_callees uobj_name uobj_id =
	let tag_s_destslabname = uobj_name in
	let tag_s_mask = ref 0 in

  Uslog.logf "test" Uslog.Info "dest_uobj_name=%s, id=%d\n" tag_s_destslabname (Hashtbl.find slab_nametoid tag_s_destslabname);

					        	
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

;;
			
				
						
			
(*
	**************************************************************************
	interfaces
	**************************************************************************
*)

let rec myMap ~f l = match l with
 | [] -> []
 | h::t -> (f h) :: (myMap ~f t);;

 
(*
	slabid = uobj_id
	totalslabs = uobj_count
	is_memoffsets = is_memoffsets
*)
 
let parse_manifest filename uobj_id uobj_count is_memoffsets = 
	Uslog.logf "test" Uslog.Info "Manifest file: %s" filename;

try
	
  (* read the manifest JSON *)
  let json = Yojson.Basic.from_file filename in

	  (* Locally open the JSON manipulation functions *)
	  let open Yojson.Basic.Util in
	  	let ns = json |> member "ns" |> to_string in
	  	let cfiles = json |> member "c-files" |> to_string in
	  	let uobjcallees = json |> member "uobj-callees" |> to_string in
			let uobjcallees_list = (Str.split (Str.regexp "[ \r\n\t]+") uobjcallees) in
  		let vharness = json |> member "v-harness" |> to_list in
  		let vfiles = myMap vharness ~f:(fun json -> member "file" json |> to_string) in 
  		let voptions = myMap vharness ~f:(fun json -> member "options" json |> to_string) in

				(* Print the results of the parsing *)
			  Uslog.logf "test" Uslog.Info "Namespace (ns): %s" ns;
			  Uslog.logf "test" Uslog.Info "c-files: %s" cfiles;

				g_cfiles_list := (Str.split (Str.regexp "[ \r\n\t]+") cfiles);
				List.iter do_action_on_cfile !g_cfiles_list;

			  Uslog.logf "test" Uslog.Info "uobj-callees:\r\n";
				List.iter dbg_dump_list_string uobjcallees_list;
			  
				for uobjcallees_list_element=0 to (List.length uobjcallees_list - 1) do
					(* usmf_handle_uobj_callees (List.nth uobjcallees_list uobjcallees_list_element) uobj_id;		
					*)
			  	Uslog.logf "test" Uslog.Info "element=%u -> %s" uobjcallees_list_element (List.nth uobjcallees_list uobjcallees_list_element);
				done
				;
				
				let numelems_vfiles = List.length vfiles in
				let numelems_voptions = List.length voptions in
				let elemcnt = ref 0 in 
					if numelems_vfiles = numelems_voptions then
						begin
							elemcnt := 0;
							while (!elemcnt < numelems_vfiles) do
								let vfile_name = List.nth vfiles !elemcnt in
								let voptions_str = List.nth voptions !elemcnt in
									(*
									Uslog.logf "test" Uslog.Info "vfile=%s voptions=%s" vfile_name voptions_str;
					       	*)
									 Hashtbl.add usmf_fnametoverifopts vfile_name voptions_str;
									elemcnt := !elemcnt + 1;
							done;
							
							(*debug dump*)
							Hashtbl.iter dbg_dump_hashtbl usmf_fnametoverifopts;
							
							Uslog.logf "test" Uslog.Info "Parsed Manifest!";
						end
					else
						begin
							Uslog.logf "test" Uslog.Info "ERROR in parsing manifest: numelems_vfiles != numelems_voptions";
						end
					;

				(*List.iter do_action_on_vharness_file vfiles;
				List.iter do_action_on_vharness_options voptions;
				*)
			

with Yojson.Json_error s -> 
				Uslog.logf "test" Uslog.Info "ERROR in parsing manifest!";

	;
		
	;;


