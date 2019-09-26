(* uberSpark: main library interface *)
(* author: amit vasudevan <amitvasudevan@acm.org> *)

module Config = Uberspark_config
module Globaltypes = Globaltypes
module Logger = Uberspark_logger
module Osservices = Uberspark_osservices
module Manifest = Uberspark_manifest
module Binary = Uberspark_binary
module Uobj = Uberspark_uobj

(*
module Usuobj =
struct

		type sentinel_info_t = 
			{
				s_type: string;
      };;
    
    let my_method = Uberspark_log.log "hello there";
    
    end
*)