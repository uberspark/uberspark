class uobjcoll_loader :
object


    val d_loader_ns : string ref
    method get_d_loader_ns : string
    method set_d_loader_ns : string -> unit


	val d_loader_mf_filename_abspath : string ref
	method get_d_loader_mf_filename_abspath : string
	method set_d_loader_mf_filename_abspath : string -> unit

	val d_mf_json : Yojson.Basic.t ref

	method parse_manifest : unit -> bool
    method initialize : ?builddir:string -> string -> bool


end
