(*----------------------------------------------------------------------------*)
(* uberSpark manifest interface *)
(*	 author: amit vasudevan (amitvasudevan@acm.org) *)
(*----------------------------------------------------------------------------*)

open Yojson


open Usconfig
open Uslog
open Usosservices
open Usextbinutils


module Usmanifest =
	struct

	(*--------------------------------------------------------------------------*)
	(* read manifest file into json object *)
	(*--------------------------------------------------------------------------*)

	let read_manifest usmf_filename keep_temp_files = 
		let retval = ref false in
	  let retjson = ref `Null in
		let usmf_filename_in_pp = (usmf_filename ^ ".c") in
		let usmf_filename_out_pp = (usmf_filename ^ ".upp") in
			Usosservices.file_copy usmf_filename usmf_filename_in_pp;
			let (pp_retval, _) = Usextbinutils.preprocess usmf_filename_in_pp 
														usmf_filename_out_pp 
														(Usconfig.get_std_incdirs ())
														(Usconfig.get_std_defines () @ 
															Usconfig.get_std_define_asm ()) in
	
			if(pp_retval == 0) then 
				begin
					try
				
						 let uobj_mf_json = Yojson.Basic.from_file usmf_filename_out_pp in
								retval := true;
								retjson := uobj_mf_json;
								
					with Yojson.Json_error s -> 
							Uslog.logf "libusmf" Uslog.Debug "usmf_read_manifest: ERROR:%s" s;
							retval := false;
					;
					
					if(keep_temp_files == false) then
						begin
							Usosservices.file_remove usmf_filename_in_pp;
							Usosservices.file_remove usmf_filename_out_pp;
						end
					;
				end
			;	
	
		(!retval, !retjson)
	;;


	(*--------------------------------------------------------------------------*)
	(* parse manifest node "usmf-type" *)
	(* return: manifest type string *)
	(*--------------------------------------------------------------------------*)

	let parse_node_usmf_type usmf_json =
		try
			let open Yojson.Basic.Util in
				let usmf_type = usmf_json |> member "usmf-type" |> to_string in
	 				(usmf_type)
		with Yojson.Basic.Util.Type_error _ -> 
				("")
		;
	
	;;

								
	end