

  class uobject :
  object
    val d_intrauobjcoll_callees_hashtbl : (string, string list) Hashtbl.t
    val d_hdr : Uberspark_manifest.Uobj.uobj_hdr_t
    val d_interuobjcoll_callees_hashtbl :
      (string, string list) Hashtbl.t
    val d_legacy_callees_hashtbl :
      (string, string list) Hashtbl.t

    val d_load_addr : int ref
    val d_ltag : string
    val d_mf_filename : string ref
    val d_path_to_mf_filename : string ref
    val d_path_ns : string ref

 


  	val d_uobj_mf_json_nodes : Uberspark_manifest.Uobj.uobj_mf_json_nodes_t 

    val d_publicmethods_hashtbl :
      (string, Uberspark_manifest.Uobj.uobj_publicmethods_t) Hashtbl.t

  	val d_sections_list : (string * Defs.Basedefs.section_info_t) list ref 
  	val d_default_sections_list : (string * Defs.Basedefs.section_info_t) list ref 
  	val d_memorymapped_sections_list : (string * Defs.Basedefs.section_info_t) list ref 

    val d_size : int ref
    val d_slt_trampolinecode : string ref
    val d_slt_trampolinedata : string ref
    val d_sources_c_file_list : string list ref
    val d_sources_casm_file_list : string list ref
    val d_sources_h_file_list : string list ref
    val d_sources_asm_file_list : string list ref

    val d_target_def : Defs.Basedefs.target_def_t
  	val d_context_path_builddir : string ref


    method get_d_intrauobjcoll_callees_hashtbl : (string, string list) Hashtbl.t
    method get_d_hdr : Uberspark_manifest.Uobj.uobj_hdr_t
    method get_d_interuobjcoll_callees_hashtbl :
      (string, string list) Hashtbl.t

    method get_d_legacy_callees_hashtbl :
      (string, string list) Hashtbl.t

    method get_d_load_addr : int
    method get_d_size : int
    method get_d_uniform_size : bool
    method get_d_alignment : int
 
    method get_d_mf_filename : string
    method get_d_path_to_mf_filename : string
    method get_d_path_ns : string

    method get_d_target_def : Defs.Basedefs.target_def_t

 
    method get_d_publicmethods_hashtbl :
      (string, Uberspark_manifest.Uobj.uobj_publicmethods_t) Hashtbl.t

  	method get_d_sections_list_ref : (string * Defs.Basedefs.section_info_t) list ref  
	  method get_d_sections_list_val : (string * Defs.Basedefs.section_info_t) list 
  	method get_d_default_sections_list_ref : (string * Defs.Basedefs.section_info_t) list ref  
	  method get_d_default_sections_list_val : (string * Defs.Basedefs.section_info_t) list 
  	method get_d_memorymapped_sections_list_ref : (string * Defs.Basedefs.section_info_t) list ref  
	  method get_d_memorymapped_sections_list_val : (string * Defs.Basedefs.section_info_t) list 


    method get_d_slt_trampolinecode : string
    method get_d_slt_trampolinedata : string
    method get_d_sources_c_file_list : string list
    method get_d_sources_casm_file_list : string list
    method get_d_sources_h_file_list : string list
    method get_d_sources_asm_file_list : string list
    
 
    method set_d_size : int -> unit
    method set_d_load_addr : int -> unit
    method set_d_alignment : int -> unit
    method set_d_uniform_size : bool -> unit
 
    method set_d_slt_trampolinecode : string -> unit
    method set_d_slt_trampolinedata : string -> unit
    method set_d_target_def : Defs.Basedefs.target_def_t -> unit
  	method get_d_context_path_builddir : string
	  method set_d_context_path_builddir : string -> unit


    method consolidate_sections_with_memory_map : unit -> unit
  	method write_manifest : string -> bool
    method parse_manifest : string -> bool -> bool
    method parse_manifest_slt : bool
    method initialize : ?context_path_builddir:string -> Defs.Basedefs.target_def_t -> int -> unit
 
    method compile_c_files : unit -> bool
    method compile_asm_files : unit -> bool
    method link_object_files : unit -> bool

    method install_create_ns : unit -> unit
    method install_h_files_ns : ?context_path_builddir:string -> unit
    method remove_ns : unit -> unit

  	method prepare_namespace_for_build : unit -> bool
  	method prepare_sources : string -> bool

end


val build : string -> Defs.Basedefs.target_def_t -> bool
val create_parse_and_build : string -> Defs.Basedefs.target_def_t -> bool
