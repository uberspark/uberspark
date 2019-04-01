(*
	uberSpark type definitions
	author: amit vasudevan (amitvasudevan@acm.org)
*)

module Ustypes =
struct

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
