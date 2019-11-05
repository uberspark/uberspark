

  class uobject :
  object
    val d_intrauobjcoll_callees_hashtbl : (string, string list) Hashtbl.t
    val d_hdr : Uberspark_manifest.Uobj.uobj_hdr_t
    val d_interuobjcoll_callees_hashtbl :
      (string, string list) Hashtbl.t
    val d_load_addr : int ref
    val d_ltag : string
    val d_mf_filename : string ref
    val d_path_to_mf_filename : string ref
    val d_path_ns : string ref
    val d_publicmethods_hashtbl :
      (string, Uberspark_manifest.Uobj.uobj_publicmethods_t) Hashtbl.t
    val d_sections_hashtbl :
      (string, Defs.Basedefs.section_info_t) Hashtbl.t
    val d_sections_memory_map_hashtbl :
      (string, Defs.Basedefs.section_info_t) Hashtbl.t
    val d_sections_memory_map_hashtbl_byorigin :
      (int, Defs.Basedefs.section_info_t) Hashtbl.t
    val d_size : int ref
    val d_slt_trampolinecode : string ref
    val d_slt_trampolinedata : string ref
    val d_sources_c_file_list : string list ref
    val d_sources_casm_file_list : string list ref
    val d_sources_h_file_list : string list ref
    val d_target_def : Defs.Basedefs.target_def_t

    method get_d_intrauobjcoll_callees_hashtbl : (string, string list) Hashtbl.t
    method get_d_hdr : Uberspark_manifest.Uobj.uobj_hdr_t
    method get_d_interuobjcoll_callees_hashtbl :
      (string, string list) Hashtbl.t
    method get_d_load_addr : int
    method get_d_mf_filename : string
    method get_d_path_to_mf_filename : string
    method get_d_path_ns : string
    method get_d_publicmethods_hashtbl :
      (string, Uberspark_manifest.Uobj.uobj_publicmethods_t) Hashtbl.t
    method get_d_sections_hashtbl :
      (string, Defs.Basedefs.section_info_t) Hashtbl.t
    method get_d_sections_memory_map_hashtbl :
      (string, Defs.Basedefs.section_info_t) Hashtbl.t
    method get_d_sections_memory_map_hashtbl_byorigin :
      (int, Defs.Basedefs.section_info_t) Hashtbl.t
    method get_d_size : int
    method get_d_slt_trampolinecode : string
    method get_d_slt_trampolinedata : string
    method get_d_sources_c_file_list : string list
    method get_d_sources_casm_file_list : string list
    method get_d_sources_h_file_list : string list
    method get_d_target_def : Defs.Basedefs.target_def_t
    method set_d_load_addr : int -> unit
    method set_d_size : int -> unit
    method set_d_slt_trampolinecode : string -> unit
    method set_d_slt_trampolinedata : string -> unit
    method set_d_target_def : Defs.Basedefs.target_def_t -> unit


    method consolidate_sections_with_memory_map : int -> int -> unit
    method parse_manifest : string -> bool -> bool
    method parse_manifest_slt : bool
    method initialize : Defs.Basedefs.target_def_t -> unit
    method compile_c_files : unit -> bool

    method install_create_ns : unit -> unit
    method install_h_files_ns : unit -> unit
end


val build : string -> Defs.Basedefs.target_def_t -> bool
