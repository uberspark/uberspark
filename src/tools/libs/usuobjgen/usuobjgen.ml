(*------------------------------------------------------------------------------
	uberSpark uberobject support module generation interface
	author: amit vasudevan (amitvasudevan@acm.org)
------------------------------------------------------------------------------*)

open Usconfig
open Uslog
open Usmanifest
open Usextbinutils

module Usuobjgen =
	struct

	let log_tag = "Usuobjgen";;

	let generate_uobj_hdr uobj_name uobj_load_addr uobj_sections_list =
		let uobj_hdr_filename = (uobj_name ^ ".hdr.c") in
		let oc = open_out uobj_hdr_filename in
			Printf.fprintf oc "\n/* autogenerated uberSpark uobj header */";
			Printf.fprintf oc "\n/* author: amit vasudevan (amitvasudevan@acm.org) */";
			Printf.fprintf oc "\n";
			Printf.fprintf oc "\n";
	
			Printf.fprintf oc "\n#include <uberspark.h>";
			Printf.fprintf oc "\n";
	
			List.iter (fun x ->
				(* new section *)
				let section_name_var = ("__uobjsection_filler_" ^ (List.nth x 0)) in
				let section_name = (List.nth x 3) in
				  if (compare section_name ".text") <> 0 then
						begin
							Printf.fprintf oc "\n__attribute__((section (\"%s\"))) uint8_t %s[1]={ 0 };"
								section_name section_name_var;
						end
					;
				()
			)  uobj_sections_list;
	
			Printf.fprintf oc "\n";
			Printf.fprintf oc "\n";
				
			close_out oc;
		(uobj_hdr_filename)
	;; 


	let generate_uobj_linker_script 
		uobj_name 
		uobj_load_addr 
		uobj_sections_list = 
		
		let uobj_linker_script_filename = (uobj_name ^ ".lscript") in
		let uobj_section_load_addr = ref 0 in
		let oc = open_out uobj_linker_script_filename in
			Printf.fprintf oc "\n/* autogenerated uberSpark uobj linker script */";
			Printf.fprintf oc "\n/* author: amit vasudevan (amitvasudevan@acm.org) */";
			Printf.fprintf oc "\n";
			Printf.fprintf oc "\n";
			Printf.fprintf oc "\nOUTPUT_ARCH(\"i386\")";
			Printf.fprintf oc "\n";
			Printf.fprintf oc "\nMEMORY";
			Printf.fprintf oc "\n{";
	
			uobj_section_load_addr := uobj_load_addr;
			
			List.iter (fun x ->
				(* new section *)
				let memregion_name = ("uobjmem_" ^ (List.nth x 0)) in
				let memregion_attrs = ( (List.nth x 1) ^ "ail") in
				let memregion_origin = !uobj_section_load_addr in
				let memregion_size =  int_of_string (List.nth x 2) in
					Printf.fprintf oc "\n %s (%s) : ORIGIN = 0x%08x, LENGTH = 0x%08x"
						memregion_name memregion_attrs memregion_origin memregion_size;
				uobj_section_load_addr := !uobj_section_load_addr + memregion_size;
				()
			)  uobj_sections_list;
					
			Printf.fprintf oc "\n}";
			Printf.fprintf oc "\n";
			
			
			Printf.fprintf oc "\nSECTIONS";
			Printf.fprintf oc "\n{";
			Printf.fprintf oc "\n";
	
			uobj_section_load_addr := uobj_load_addr;
			
			List.iter (fun x ->
				(* new section *)
				Printf.fprintf oc "\n	. = 0x%08x;" !uobj_section_load_addr;
		    Printf.fprintf oc "\n %s : {" (List.nth x 0);
				let section_size= (List.nth x 2) in
				let elem_index = ref 0 in
				elem_index := 0;
				List.iter (fun y ->
					if (!elem_index > 2) then
						begin
					    Printf.fprintf oc "\n *(%s)" y;
						end
					; 
					elem_index := !elem_index + 1;
					()
				) x;
		
				Printf.fprintf oc "\n . = %s;" section_size;
		    Printf.fprintf oc "\n	} >uobjmem_%s =0x9090" (List.nth x 0);
		    Printf.fprintf oc "\n";
				uobj_section_load_addr := !uobj_section_load_addr + 
						int_of_string(section_size);
				()
			) uobj_sections_list;
	
	
			Printf.fprintf oc "\n";
			Printf.fprintf oc "\n	/* this is to cause the link to fail if there is";
			Printf.fprintf oc "\n	* anything we didn't explicitly place.";
			Printf.fprintf oc "\n	* when this does cause link to fail, temporarily comment";
			Printf.fprintf oc "\n	* this part out to see what sections end up in the output";
			Printf.fprintf oc "\n	* which are not handled above, and handle them.";
			Printf.fprintf oc "\n	*/";
			Printf.fprintf oc "\n	/DISCARD/ : {";
			Printf.fprintf oc "\n	*(*)";
			Printf.fprintf oc "\n	}";
			Printf.fprintf oc "\n}";
			Printf.fprintf oc "\n";
																																																																																																																									
			close_out oc;
			(uobj_linker_script_filename)
	;;
																																																
																																																																								
	end