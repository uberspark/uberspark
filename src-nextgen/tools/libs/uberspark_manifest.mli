
(* uberspark generic manifest header *)
type hdr_t =
{
	mutable f_coss_version : string;			
	mutable f_mftype : string;
	mutable f_uberspark_min_version   : string;
  mutable f_uberspark_max_version : string;
}


type hdrold_t =
  {
    mutable f_type         : string;			
    mutable f_namespace    : string;			
    mutable f_platform	   : string;
    mutable f_arch	       : string;
    mutable f_cpu				   : string;
  }

  val get_manifest_json : ?check_header:bool -> string -> bool * Yojson.Basic.t
  val parse_node_hdr : Yojson.Basic.t -> bool * hdrold_t
  
  val parse_uberspark_hdr : Yojson.Basic.t -> bool * hdr_t
