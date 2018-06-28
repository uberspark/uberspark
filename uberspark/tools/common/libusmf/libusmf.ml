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
let g_totalslabs = ref 0;;
let g_maxincldevlistentries = ref 0;; 
let g_maxexcldevlistentries = ref 0;; 
let g_maxmemoffsetentries = ref 0;;


let slab_idtoname = ((Hashtbl.create 32) : ((int,string)  Hashtbl.t));;
let slab_idtotype = ((Hashtbl.create 32) : ((int,string)  Hashtbl.t));;
let slab_idtosubtype = ((Hashtbl.create 32) : ((int,string)  Hashtbl.t));;

let slab_nametoid = ((Hashtbl.create 32) : ((string,int)  Hashtbl.t));;
let slab_idtodir = ((Hashtbl.create 32) : ((int,string)  Hashtbl.t));;
let slab_idtogsm = ((Hashtbl.create 32) : ((int,string)  Hashtbl.t));;
let slab_idtommapfile = ((Hashtbl.create 32) : ((int,string)  Hashtbl.t));;


let uapi_fndef  = ((Hashtbl.create 32) : ((string,string)  Hashtbl.t));;
let uapi_fndrvcode  = ((Hashtbl.create 32) : ((string,string)  Hashtbl.t));;


let slab_idtocallmask = ((Hashtbl.create 32) : ((int,int)  Hashtbl.t));;
let slab_idtocalleemask = ((Hashtbl.create 32) : ((int,int)  Hashtbl.t));;


let slab_idtouapifnmask = ((Hashtbl.create 32) : ((int,int)  Hashtbl.t));;
let slab_idtouapifnmaskstring = ((Hashtbl.create 32) : ((int,string)  Hashtbl.t));;
let uapi_fnccomppre = ((Hashtbl.create 32) : ((string,string)  Hashtbl.t));;
let uapi_fnccompasserts = ((Hashtbl.create 32) : ((string,string)  Hashtbl.t));;


let slab_idtordinclentries = ((Hashtbl.create 32) : ((int,string)  Hashtbl.t));;
let slab_idtordexclentries = ((Hashtbl.create 32) : ((int,string)  Hashtbl.t));;
let slab_idtordinclcount = ((Hashtbl.create 32) : ((int,int)  Hashtbl.t));;
let slab_idtordexclcount = ((Hashtbl.create 32) : ((int,int)  Hashtbl.t));;

let slab_idtomemgrantreadcaps =  ((Hashtbl.create 32) : ((int,int)  Hashtbl.t));;
let slab_idtomemgrantwritecaps =  ((Hashtbl.create 32) : ((int,int)  Hashtbl.t));;

let slab_idtomemoffsets = ((Hashtbl.create 32) : ((string,string)  Hashtbl.t));;

let slab_idtodatasize =  ((Hashtbl.create 32) : ((int,int)  Hashtbl.t));;
let slab_idtocodesize =  ((Hashtbl.create 32) : ((int,int)  Hashtbl.t));;
let slab_idtostacksize =  ((Hashtbl.create 32) : ((int,int)  Hashtbl.t));;
let slab_idtodmadatasize =  ((Hashtbl.create 32) : ((int,int)  Hashtbl.t));;


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


let usmf_populate_uobj_uapifunctions uobj_entry uobj_id = 
	try
		 	let open Yojson.Basic.Util in
			let uobj_0 = uobj_entry in 
			let i = ref 0 in
			
			Uslog.logf "libusmf" Uslog.Info "usmf_populate_uobj_uapifunctions: uobj_id=%u" uobj_id;

			let uobj_0_uapifunctions = uobj_0 |> member "uobj-uapifunctions" |> to_list in
			let uobj_0_uapifn_id = myMap uobj_0_uapifunctions ~f:(fun uobj_0 -> member "uapifunction-id" uobj_0 |> to_string) in 
			let uobj_0_uapifn_def = myMap uobj_0_uapifunctions ~f:(fun uobj_0 -> member "uapifunction-definition" uobj_0 |> to_string) in 
			let uobj_0_uapifn_drivercode = myMap uobj_0_uapifunctions ~f:(fun uobj_0 -> member "uapifunction-drivercode" uobj_0 |> to_string) in 
				begin
					while (!i < (List.length uobj_0_uapifunctions)) do
						begin
							let tag_ufn_uapifnid =  (trim (List.nth uobj_0_uapifn_id !i)) in
							let tag_ufn_uapifndef =  (trim (List.nth uobj_0_uapifn_def !i)) in
							let tag_ufn_uapifndrvcode =  (trim (List.nth uobj_0_uapifn_drivercode !i)) in
							let tag_ufn_uapikey = ref "" in
									
							(* uapi function definition tag, should only appear in uapi slabs *)
							if (compare (Hashtbl.find slab_idtosubtype uobj_id) "uapi") = 0 then
								begin
									
									(* make key *)
									tag_ufn_uapikey := (Hashtbl.find slab_idtoname uobj_id) ^ "_" ^ tag_ufn_uapifnid;
									Uslog.logf "libusmf" Uslog.Info "usmf_populate_uobj_uapifunctions: uapi key = %s \n" !tag_ufn_uapikey;
									Uslog.logf "libusmf" Uslog.Info "usmf_populate_uobj_uapifunctions: uapi fndef = %s \n" tag_ufn_uapifndef;
									Uslog.logf "libusmf" Uslog.Info "usmf_populate_uobj_uapifunctions: uapi fndrvcode = %s \n" tag_ufn_uapifndrvcode;
						
			            Hashtbl.add uapi_fndef !tag_ufn_uapikey tag_ufn_uapifndef; (* store uapi function definition indexed by uapi_key *)
			            Hashtbl.add uapi_fndrvcode !tag_ufn_uapikey tag_ufn_uapifndrvcode; (* store uapi function driver code by uapi_key *)

								end
							else
								begin
									Uslog.logf "libusmf" Uslog.Info "usmf_populate_uobj_uapifunctions: Error: Illegal UFN tag; slab is not a uapi slab!\n";
       						ignore(exit 1);
								end
							;

							i := !i + 1;
						end
					done;
					
					
				end

	
	with Yojson.Json_error s -> 
			Uslog.logf "libusmf" Uslog.Info "usmf_populate_uobj_uapifunctions: ERROR in parsing manifest!";
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

let do_action_on_uobj_list uobj_name =
  Hashtbl.add slab_idtoname !g_totalslabs uobj_name;
	Hashtbl.add slab_nametoid uobj_name !g_totalslabs;
	Uslog.logf "libusmf" Uslog.Info "Added uobj:%s with index=%u" uobj_name !g_totalslabs;
	g_totalslabs := !g_totalslabs + 1;

;;


let usmf_get_uobj_id uobj_name =
	let uobj_id = ref 0 in
		if (Hashtbl.mem slab_nametoid uobj_name) then
			begin
				uobj_id := Hashtbl.find slab_nametoid uobj_name;
			end
		else
			begin
				uobj_id := -1;
			end
		;
		
		!uobj_id;
;;


let usmf_populate_uobj_uapicallmasks uobj_entry uobj_id = 
	try
		 	let open Yojson.Basic.Util in
			let uobj_0 = uobj_entry in 
			let i = ref 0 in
	    let j = ref 0 in
	    let slab_uapifnmaskstring = ref "" in

			
			Uslog.logf "libusmf" Uslog.Info "usmf_populate_uobj_uapicallmasks: uobj_id=%u" uobj_id;

			let uobj_0_uapifn = uobj_0 |> member "uobj-uapicallees" |> to_list in
			let uobj_0_uapifn_uobjname = myMap uobj_0_uapifn ~f:(fun uobj_0 -> member "uobj-name" uobj_0 |> to_string) in 
  		let uobj_0_uapifn_id = myMap uobj_0_uapifn ~f:(fun uobj_0 -> member "uobj-uapifunctionid" uobj_0 |> to_string) in 
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

										Uslog.logf "libusmf" Uslog.Info "usmf_populate_uobj_uapicallmasks: processing entry %u" !i;

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
										Uslog.logf "libusmf" Uslog.Info "usmf_populate_uobj_uapicallmasks:uapi key = %s\n" !tag_u_uapikey;
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

										Uslog.logf "libusmf" Uslog.Info "usmf_populate_uobj_uapicallmasks:uapi fnccomppre =%s\n" (Hashtbl.find uapi_fnccomppre !tag_u_uapikey);

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

										Uslog.logf "libusmf" Uslog.Info "usmf_populate_uobj_uapicallmasks:uapi fnccompasserts =%s\n" (Hashtbl.find uapi_fnccompasserts !tag_u_uapikey);

								i := !i + 1;
						end
					done;

					j := 0;
    			while !j < !g_totalslabs do
    				begin
        			if (Hashtbl.mem slab_idtouapifnmask !j) then
        				begin
        					slab_uapifnmaskstring := !slab_uapifnmaskstring ^ (Printf.sprintf "\t0x%08x,\n" (Hashtbl.find slab_idtouapifnmask !j));
        				end
        			else
        				begin
									slab_uapifnmaskstring := !slab_uapifnmaskstring ^ "\t0x00000000,\n";
        				end
        			;
        			j := !j + 1;
    				end
    			done;
				
					Hashtbl.add slab_idtouapifnmaskstring uobj_id !slab_uapifnmaskstring;
					Uslog.logf "libusmf" Uslog.Info "usmf_populate_uobj_uapicallmasks: uobj_id=%d, uapifnmaskstr=%s\n" uobj_id (Hashtbl.find slab_idtouapifnmaskstring uobj_id);
			
	end

	
	with Yojson.Json_error s -> 
			Uslog.logf "libusmf" Uslog.Info "usmf_populate_uobj_uapicallmasks: ERROR in parsing manifest!";
	;

;;



let usmf_populate_uobj_resource_devices uobj_entry uobj_id = 
	try
		 	let open Yojson.Basic.Util in
			let uobj_0 = uobj_entry in 
			let i = ref 0 in
			let slab_rdinclcount = ref 0 in
			let slab_rdexclcount = ref 0 in
			let slab_rdinclentriesstring = ref "" in
			let slab_rdexclentriesstring = ref "" in
			
			Uslog.logf "libusmf" Uslog.Info "usmf_populate_uobj_resource_devices: uobj_id=%u" uobj_id;
			slab_rdinclentriesstring := !slab_rdinclentriesstring ^ "{ \n";
    	slab_rdexclentriesstring := !slab_rdexclentriesstring ^ "{ \n";

			let uobj_0_devices = uobj_0 |> member "uobj-resource-devices" |> to_list in
			let uobj_0_device_type = myMap uobj_0_devices ~f:(fun uobj_0 -> member "type" uobj_0 |> to_string) in 
  		let uobj_0_device_opt1 = myMap uobj_0_devices ~f:(fun uobj_0 -> member "opt1" uobj_0 |> to_string) in 
  		let uobj_0_device_opt2 = myMap uobj_0_devices ~f:(fun uobj_0 -> member "opt2" uobj_0 |> to_string) in 
				begin
					while (!i < (List.length uobj_0_devices)) do
						begin
			            let tag_rd_qual =  (trim (List.nth uobj_0_device_type !i)) in
									let tag_rd_vid =  (trim (List.nth uobj_0_device_opt1 !i)) in
			            let tag_rd_did =  (trim (List.nth uobj_0_device_opt2 !i)) in 
	    
		    						if (compare tag_rd_qual "include") = 0 then 
		    							begin
		
							                if (!slab_rdinclcount >= !g_maxincldevlistentries) then 
							                	begin
							                		Uslog.logf "libusmf" Uslog.Info "Error: Too many RD INCL entries (max=%d)\n" !g_maxincldevlistentries;
								                  ignore(exit 1);
							                	end
							                ;
							                
							                slab_rdinclentriesstring := !slab_rdinclentriesstring ^ "\t{ .vendor_id= " ^ tag_rd_vid ^ ", .device_id= " ^ tag_rd_did ^ " },\n";
							                slab_rdinclcount := !slab_rdinclcount + 1;
											            							
		    							end
		    						else if (compare tag_rd_qual "exclude") = 0  then
		    							begin
		
							                if (!slab_rdexclcount >= !g_maxexcldevlistentries) then
							                	begin
							                    	Uslog.logf "libusmf" Uslog.Info "Error: Too many RD EXCL entries (max=%d)\n" !g_maxexcldevlistentries;
							                    	ignore (exit 1);
							                    end
							                ;
		
							                slab_rdexclentriesstring := !slab_rdexclentriesstring ^ "\t{ .vendor_id= " ^ tag_rd_vid ^ ", .device_id= " ^ tag_rd_did ^ " },\n";
							                slab_rdexclcount := !slab_rdexclcount + 1;
											            							
		    							end
		    						else
		    							begin
		    								Uslog.logf "libusmf" Uslog.Info "Error: Illegal RD entry qualifier: %s\n" tag_rd_qual;
		    								ignore(exit 1);
		    							end
		    						;

								i := !i + 1;
						end
					done;
					
		    	if !slab_rdinclcount = 0 then
    				begin
        			slab_rdinclentriesstring := !slab_rdinclentriesstring ^ "0 \n}, \n";
    				end
    			else
    				begin
        			slab_rdinclentriesstring := !slab_rdinclentriesstring ^ "}, \n";
    				end
    			;
    	
    			if !slab_rdexclcount = 0 then
    				begin
        			slab_rdexclentriesstring := !slab_rdexclentriesstring ^ "0 \n}, \n";
    				end
    			else	
    				begin
        			slab_rdexclentriesstring := !slab_rdexclentriesstring ^ "}, \n";
    				end
    			;

					Uslog.logf "libusmf" Uslog.Info "uobj_id=%d; inclentries=%s\n" uobj_id !slab_rdinclentriesstring;
					Uslog.logf "libusmf" Uslog.Info "uobj_id=%d; exclentries=%s\n" uobj_id !slab_rdexclentriesstring;
					Uslog.logf "libusmf" Uslog.Info "uobj_id=%d; inclcount=%d\n" uobj_id !slab_rdinclcount;
					Uslog.logf "libusmf" Uslog.Info "uobj_id=%d; exclcount=%d\n" uobj_id !slab_rdexclcount;

    			Hashtbl.add slab_idtordinclentries uobj_id !slab_rdinclentriesstring;
    			Hashtbl.add slab_idtordexclentries uobj_id !slab_rdexclentriesstring;
    			Hashtbl.add slab_idtordinclcount uobj_id !slab_rdinclcount;
    			Hashtbl.add slab_idtordexclcount uobj_id !slab_rdexclcount;

					
				end

	
	with Yojson.Json_error s -> 
			Uslog.logf "libusmf" Uslog.Info "usmf_populate_uobj_resource_devices: ERROR in parsing manifest!";
	;

;;



let usmf_populate_uobj_resource_memory uobj_entry uobj_id = 
	try
		 	let open Yojson.Basic.Util in
			let uobj_0 = uobj_entry in 
			let i = ref 0 in
			
			Uslog.logf "libusmf" Uslog.Info "usmf_populate_uobj_resource_memory: uobj_id=%u" uobj_id;

			let uobj_0_mem = uobj_0 |> member "uobj-resource-memory" |> to_list in
			let uobj_0_mem_accesstype = myMap uobj_0_mem ~f:(fun uobj_0 -> member "access-type" uobj_0 |> to_string) in 
  		let uobj_0_mem_uobj_name = myMap uobj_0_mem ~f:(fun uobj_0 -> member "uobj-name" uobj_0 |> to_string) in 
				begin
					while (!i < (List.length uobj_0_mem)) do
						begin
		            let tag_rm_qual =  (trim (List.nth uobj_0_mem_accesstype !i)) in
		            let tag_rm_slabname =  (trim (List.nth uobj_0_mem_uobj_name !i)) in
    						let tag_rm_mask = ref 0 in
    
    						if (compare tag_rm_qual "read") = 0 then 
    							begin
					                if (Hashtbl.mem slab_idtomemgrantreadcaps uobj_id) then
					                	begin
						                    tag_rm_mask := Hashtbl.find slab_idtomemgrantreadcaps uobj_id; 
						                    tag_rm_mask := !tag_rm_mask lor (1 lsl (Hashtbl.find slab_nametoid tag_rm_slabname));
						                    Hashtbl.add slab_idtomemgrantreadcaps uobj_id !tag_rm_mask;
					                	end
					                else
					                	begin
						                    tag_rm_mask := (1 lsl (Hashtbl.find slab_nametoid tag_rm_slabname));
						                    Hashtbl.add slab_idtomemgrantreadcaps uobj_id !tag_rm_mask;
					                	end
					                ;
    							end
    						else if (compare tag_rm_qual "write") = 0 then
    							begin
					                if (Hashtbl.mem slab_idtomemgrantwritecaps uobj_id) then
					                	begin
						                    tag_rm_mask := Hashtbl.find slab_idtomemgrantwritecaps uobj_id; 
						                    tag_rm_mask := !tag_rm_mask lor (1 lsl (Hashtbl.find slab_nametoid tag_rm_slabname));
						                    Hashtbl.add slab_idtomemgrantwritecaps uobj_id !tag_rm_mask;
					                	end
					                else
					                	begin
						                    tag_rm_mask := (1 lsl (Hashtbl.find slab_nametoid tag_rm_slabname));
						                    Hashtbl.add slab_idtomemgrantwritecaps uobj_id !tag_rm_mask;
					                	end
					                ;
    							end
    						else 
       							begin
					            	Uslog.logf "libusmf" Uslog.Info "usmf_populate_uobj_resource_memory:Error: Illegal RM entry qualifier: %s\n" tag_rm_qual;
				                ignore(exit 1);
    							end
    						;
			            
								i := !i + 1;
						end
					done;
					
          Uslog.logf "libusmf" Uslog.Info "usmf_populate_uobj_resource_memory: readcaps for uobj_id=%d caps=%u\n" uobj_id (Hashtbl.find slab_idtomemgrantreadcaps uobj_id);
          Uslog.logf "libusmf" Uslog.Info "usmf_populate_uobj_resource_memory: writecaps for uobj_id=%d caps=%u\n" uobj_id (Hashtbl.find slab_idtomemgrantwritecaps uobj_id);

					
				end

	
	with Yojson.Json_error s -> 
			Uslog.logf "libusmf" Uslog.Info "usmf_populate_uobj_resource_memory: ERROR in parsing manifest!";
	;

;;


let usmf_populate_uobj_export_functions uobj_entry uobj_id = 
	try
		 	let open Yojson.Basic.Util in
			let uobj_0 = uobj_entry in 
			let i = ref 0 in
    	let slab_memoffsetsstring = ref "" in
    	let slab_memoffsetcount = ref 0 in
			
			let uobj_0_exportfunctions = uobj_0 |> member "uobj-exportfunctions" |> to_string in
			let uobj_0_exportfunctions_list = (Str.split (Str.regexp "[ \r\n\t]+") uobj_0_exportfunctions) in
				begin
					while (!i < (List.length uobj_0_exportfunctions_list)) do
						begin
		          let tag_ex_varname = (trim (List.nth uobj_0_exportfunctions_list !i)) in
								Uslog.logf "libusmf" Uslog.Info "usmf_populate_uobj_export_functions: uobj_id=%d exportfunction name=%s\n" uobj_id tag_ex_varname;

                if (Hashtbl.mem slab_idtomemoffsets ((string_of_int uobj_id) ^ "_" ^ tag_ex_varname) ) then
	            	begin
	                    if (!slab_memoffsetcount < !g_maxmemoffsetentries) then
	                    	begin
	                        	slab_memoffsetsstring := !slab_memoffsetsstring ^ "\t0x" ^ (Hashtbl.find slab_idtomemoffsets ((string_of_int uobj_id) ^ "_" ^ tag_ex_varname)) ^ ",\n";
	                        	slab_memoffsetcount := !slab_memoffsetcount + 1;
	                        end
	                    else
	                    	begin
           									Uslog.logf "libusmf" Uslog.Info "usmf_populate_uobj_export_functions: Error: Max. EX entries exceeded!\n";
	                        	ignore(exit 1);
	                        end
	                    ;
	                    
	            	end
	            else
	            	begin
   									Uslog.logf "libusmf" Uslog.Info "usmf_populate_uobj_export_functions: Error: No entry found for slab: %s, EX entry: %s!" (Hashtbl.find slab_idtoname uobj_id) tag_ex_varname;
	                	ignore (exit 1);
	            	end
	            ;
		            	
							
							i := !i + 1;
						end
					done;
				end

	
	with Yojson.Json_error s -> 
			Uslog.logf "test" Uslog.Info "usmf_populate_uobj_export_functions: ERROR in parsing manifest!";
	;

;;



let usmf_populate_uobj_binary_sections uobj_entry uobj_id = 
	try
		 	let open Yojson.Basic.Util in
			let uobj_0 = uobj_entry in 
			let i = ref 0 in
			
			Uslog.logf "libusmf" Uslog.Info "usmf_populate_uobj_binary_sections: uobj_id=%u" uobj_id;

			let uobj_0_bs = uobj_0 |> member "uobj-binary-sections" |> to_list in
			let uobj_0_bs_section_name = myMap uobj_0_bs ~f:(fun uobj_0 -> member "section-name" uobj_0 |> to_string) in 
  		let uobj_0_bs_section_size = myMap uobj_0_bs ~f:(fun uobj_0 -> member "section-size" uobj_0 |> to_string) in 
				begin
					while (!i < (List.length uobj_0_bs)) do
						begin
		            let tag_ms_qual =  (trim (List.nth uobj_0_bs_section_name !i)) in
		            let tag_ms_size =  int_of_string (trim (List.nth uobj_0_bs_section_size !i)) in
            
     						if (compare tag_ms_qual "data") = 0 then 
    							begin
					                Hashtbl.add slab_idtodatasize uobj_id tag_ms_size;
    							end
    						else if (compare tag_ms_qual "code") = 0 then
    							begin
            						Hashtbl.add slab_idtocodesize uobj_id tag_ms_size;
    							end
    						else if (compare tag_ms_qual "stack") = 0 then
    							begin
        							Hashtbl.add slab_idtostacksize uobj_id tag_ms_size;
    							end
    						else if (compare tag_ms_qual "dmadata") = 0 then
    							begin
        							Hashtbl.add slab_idtodmadatasize uobj_id tag_ms_size;
    							end
    						else
    							begin
										Uslog.logf "libusmf" Uslog.Info "usmf_populate_uobj_binary_sections: Error: Illegal MS entry qualifier: %s\n" tag_ms_qual;
					          ignore(exit 1);
    							end
    						;
  
								i := !i + 1;
						end
					done;
					
        Uslog.logf "libusmf" Uslog.Info "usmf_populate_uobj_binary_sections: uobj_id=%d code size:=%u\n" uobj_id (Hashtbl.find slab_idtocodesize uobj_id);
        Uslog.logf "libusmf" Uslog.Info "usmf_populate_uobj_binary_sections: uobj_id=%d data size:=%u\n" uobj_id (Hashtbl.find slab_idtodatasize uobj_id);
        Uslog.logf "libusmf" Uslog.Info "usmf_populate_uobj_binary_sections: uobj_id=%d stack size:=%u\n" uobj_id (Hashtbl.find slab_idtostacksize uobj_id);
        Uslog.logf "libusmf" Uslog.Info "usmf_populate_uobj_binary_sections: uobj_id=%d dmadata size:=%u\n" uobj_id (Hashtbl.find slab_idtodmadatasize uobj_id);
					
				end

	
	with Yojson.Json_error s -> 
			Uslog.logf "libusmf" Uslog.Info "usmf_populate_uobj_binary_sections: ERROR in parsing manifest!";
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
  let json = Yojson.Basic.from_file uobj_list_filename in
	  (* Locally open the JSON manipulation functions *)
	  let open Yojson.Basic.Util in
	  	let uobj_list = json |> member "uobj-list" |> to_string in
			let uobj_list_trimmed = ref [""] in
				uobj_list_trimmed := (Str.split (Str.regexp "[ \r\n\t]+") uobj_list);
				List.iter do_action_on_uobj_list !uobj_list_trimmed;
			
	with Yojson.Json_error s -> 
		Uslog.logf "libusmf" Uslog.Info "ERROR in parsing manifest!";
	;

;;


(* parse uobj mmap file to aid in export function parsing *)
let usmf_parse_uobj_mmap uobj_mmap_filename uobj_id =
	let i = ref 0 in
	let trimfilename = trim uobj_mmap_filename in
	let trimline = ref "" in
	let sfh = open_in trimfilename in
	let varname = ref "" in
	let varaddr = ref "" in
	
		Uslog.logf "libusmf" Uslog.Info "usmf_parse_uobj_mmap: uobj_id=%d\n" uobj_id;
		Uslog.logf "libusmf" Uslog.Info "usmf_parse_uobj_mmap: g_totalslabs:%d\n" !g_totalslabs;
		Uslog.logf "libusmf" Uslog.Info "usmf_parse_uobj_mmap: filename:%s\n" trimfilename;

		try
    		while true do
	  			trimline := trim (input_line sfh);
					let lineentry = Str.split (Str.regexp ":") !trimline in
					varname := (trim (List.nth lineentry 0));
					varaddr := (trim (List.nth lineentry 1));
					
	        Hashtbl.add slab_idtomemoffsets ((string_of_int uobj_id) ^ "_" ^ !varname) !varaddr;
					(* Uslog.logf "libusmf" Uslog.Info "usmf_parse_uobj_mmap: %s-->%s\n" ((string_of_int uobj_id) ^ "_" ^ !varname) !varaddr; *)

					i := !i + 1;
		    done;
		with End_of_file -> 
    			close_in sfh;
    	;		

	()
;;

(* parse uobj manifest specified by uobj_mf_filename and store parsed info*)
(* indexed by uobj_id*)
let usmf_parse_uobj_mf uobj_mf_filename uobj_mmap_filename = 
	if !g_totalslabs > 0 then
		begin
			try
		
			(* read the manifest JSON *)
		  let uobj_entry = Yojson.Basic.from_file uobj_mf_filename in
			  (* Locally open the JSON manipulation functions *)
			  let open Yojson.Basic.Util in
			  	let uobj_name = uobj_entry |> member "uobj-name" |> to_string in
					let uobj_id = ref 0 in
						uobj_id := (usmf_get_uobj_id uobj_name);
						if(!uobj_id = -1) then
							begin
								Uslog.logf "libusmf" Uslog.Info "ERROR in obtaining uobj id";
								ignore(exit 1);
							end
						;
						Uslog.logf "libusmf" Uslog.Info "uobj-name=%s" uobj_name;
						Uslog.logf "libusmf" Uslog.Info "uobj-id=%d" !uobj_id;
						(* g_maxincldevlistentries := int_of_string (Cmdopt_maxincldevlistentries.get()); *)
						(* g_maxexcldevlistentries := int_of_string (Cmdopt_maxexcldevlistentries.get()); *)
						g_maxincldevlistentries := 64;
						g_maxexcldevlistentries := 64;
						g_maxmemoffsetentries := 64;

						usmf_populate_uobj_base_characteristics	uobj_entry uobj_mf_filename !uobj_id;
						usmf_populate_uobj_uapifunctions uobj_entry !uobj_id;
						usmf_populate_uobj_callmasks uobj_entry !uobj_id;
						usmf_populate_uobj_uapicallmasks uobj_entry !uobj_id;
						usmf_populate_uobj_resource_devices uobj_entry !uobj_id;
						usmf_populate_uobj_resource_memory uobj_entry !uobj_id;
						usmf_parse_uobj_mmap uobj_mmap_filename !uobj_id;
						usmf_populate_uobj_export_functions uobj_entry !uobj_id;
						usmf_populate_uobj_binary_sections uobj_entry !uobj_id;
																		
		with Yojson.Json_error s -> 
				Uslog.logf "libusmf" Uslog.Info "ERROR in parsing manifest!";
			;
		end
		;
;;


end



