class uobjcoll_loader :
object


    val d_loader_ns : string ref
    method get_d_loader_ns : string
    method set_d_loader_ns : string -> unit


	val d_loader_mf_filename_abspath : string ref
	method get_d_loader_mf_filename_abspath : string
	method set_d_loader_mf_filename_abspath : string -> unit

	val d_mf_json : Yojson.Basic.t ref

	val json_node_uberspark_loader_var : Uberspark_manifest.Loader.json_node_uberspark_loader_t

	method parse_manifest : unit -> bool
    method initialize : ?builddir:string -> string -> bool

	method build_image : unit -> bool



end

val create_initialize : string -> bool * uobjcoll_loader option
val create_initialize_and_build : string -> bool * uobjcoll_loader option

