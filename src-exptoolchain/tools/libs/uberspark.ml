(* main library interface *)

(*module Logger = Uberspark_log*)

module Usuobj =
struct

		type sentinel_info_t = 
			{
				s_type: string;
      };;
    
    let my_method = Uberspark_log.log "hello there";
    
    end
