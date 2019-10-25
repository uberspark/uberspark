(* uberspark generic manifest header *)
type hdr_t =
{
	mutable f_coss_version : string;			
	mutable f_mftype : string;
	mutable f_uberspark_min_version   : string;
  mutable f_uberspark_max_version : string;
}


val get_manifest_json : ?check_header:bool -> string -> bool * Yojson.Basic.t
val parse_uberspark_hdr : Yojson.Basic.t -> bool * hdr_t


module Uobj : sig
  type uobj_hdr_t =
    {
      mutable f_namespace    : string;			
      mutable f_platform	   : string;
      mutable f_arch	       : string;
      mutable f_cpu				   : string;
    }


  val parse_uobj_hdr : Yojson.Basic.t -> uobj_hdr_t -> bool
  
end

