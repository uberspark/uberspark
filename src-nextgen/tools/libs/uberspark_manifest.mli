
(* uberspark generic manifest header *)
type hdr_t =
{
	mutable f_prog_name    : string;			
	mutable f_prog_version : string;			
	mutable f_uberspark_mftype : string;
	mutable f_uberspark_version   : string;
}


type hdrold_t =
  {
    mutable f_type         : string;			
    mutable f_namespace    : string;			
    mutable f_platform	   : string;
    mutable f_arch	       : string;
    mutable f_cpu				   : string;
  }

  val read_manifest : string -> bool -> bool * Yojson.Basic.t
  val parse_node_hdr : Yojson.Basic.t -> bool * hdrold_t