(*
	uberSpark type definitions
	author: amit vasudevan (amitvasudevan@acm.org)
*)

module Ustypes =
struct

		(* from usbinformat.h *)
		type usbinformat_section_info_t =
			{
				f_type         : int;			
				f_prot         : int;			
				f_addr_start   : int;
				f_addr_end     : int;
				f_addr_file    : int;
        f_aligned_at   : int;
	      f_pad_to       : int;
        f_reserved     : int; 
			};;


		(* local type definitions *)
		type section_info_t = 
			{
				f_name: string;
				f_subsection_list : string list;
				usbinformat : usbinformat_section_info_t;
			};;
		

		type uobjcoll_sentineltypes_t = 
			{
				s_type: string;
				s_type_id : string;
			};;

		type uobjcoll_exitcallee_t = 
			{
				s_retvaldecl : string;
				s_fname: string;
				s_fparamdecl: string;
				s_fparamdwords : int;
			};;
				
												
end
