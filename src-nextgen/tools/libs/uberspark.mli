
module Globaltypes : sig

  type usbinformat_section_info_t = {
    f_type : int;
    f_prot : int;
    f_size : int;
    f_aligned_at : int;
    f_pad_to : int;
    f_addr_start : int;
    f_addr_file : int;
    f_reserved : int;
  }
  type target_def_t = {
    mutable f_platform : string;
    mutable f_arch : string;
    mutable f_cpu : string;
  }
  type section_info_t = {
    f_name : string;
    f_subsection_list : string list;
    usbinformat : usbinformat_section_info_t;
  }
  type uobjcoll_sentineltypes_t = { s_type : string; s_type_id : string; }
  type uobjcoll_exitcallee_t = {
    s_retvaldecl : string;
    s_fname : string;
    s_fparamdecl : string;
    s_fparamdwords : int;
  }
  
end

 
module Config : sig
  val env_path_seperator : string
  val env_home_dir : string
  val namespace_root : string
  val namespace_default_uobj_mf_filename : string
  val namespace_uobj_mf_hdr_type : string
  val namespace_uobj_binhdr_src_filename : string
  val namespace_uobj_publicmethods_info_src_filename : string
  val namespace_uobj_intrauobjcoll_callees_info_src_filename : string
  val namespace_uobj_interuobjcoll_callees_info_src_filename : string
  val namespace_uobj_linkerscript_filename : string
  val namespace_uobjslt : string
  val namespace_uobjslt_mf_hdr_type : string
  val namespace_uobjslt_mf_filename : string
  val namespace_uobjslt_callees_output_filename : string
  val namespace_uobjslt_exitcallees_output_filename : string
  val namespace_uobjslt_output_symbols_filename : string
  val binary_page_size : int ref
  val binary_uobj_section_alignment : int ref
  val binary_uobj_default_section_size : int ref
  val binary_uobj_default_load_addr : int ref
  val binary_uobj_default_size : int ref
  val binary_uobj_publicmethod_max_length : int ref
  val binary_uobj_max_publicmethods : int ref
  val binary_uobj_namespace_max_length : int ref
  val binary_uobj_max_intrauobjcoll_callees : int ref
  val binary_uobj_max_interuobjcoll_callees : int ref
  val def_USBINFORMAT_SECTION_TYPE_PADDING : int
  val def_USBINFORMAT_SECTION_TYPE_UOBJ : int
  val def_USBINFORMAT_SECTION_TYPE_UOBJCOLL_ENTRYSENTINEL : int
  val def_USBINFORMAT_SECTION_TYPE_UOBJ_RESUMESENTINEL : int
  val def_USBINFORMAT_SECTION_TYPE_UOBJ_CALLEESENTINEL : int
  val def_USBINFORMAT_SECTION_TYPE_UOBJ_EXITCALLEESENTINEL : int
  val def_USBINFORMAT_SECTION_TYPE_UOBJ_HDR : int
  val def_USBINFORMAT_SECTION_TYPE_UOBJ_CODE : int
  val def_USBINFORMAT_SECTION_TYPE_UOBJ_RWDATA : int
  val def_USBINFORMAT_SECTION_TYPE_UOBJ_RODATA : int
  val def_USBINFORMAT_SECTION_TYPE_UOBJ_USTACK : int
  val def_USBINFORMAT_SECTION_TYPE_UOBJ_TSTACK : int
  val def_USBINFORMAT_SECTION_TYPE_UOBJ_USTACKTOS : int
  val def_USBINFORMAT_SECTION_TYPE_UOBJ_TSTACKTOS : int
  val def_USBINFORMAT_SECTION_TYPE_UOBJ_DMADATA : int
    
end


module Logger : sig
type log_level = None | Stdoutput | Error | Warn | Info | Debug
val ord : log_level -> int
val current_level : int ref
val error_level : int ref
val logf : string -> log_level -> ('a, unit, string, unit) format4 -> 'a
val log :
  ?tag:string ->
  ?stag:string ->
  ?lvl:log_level -> ?crlf:bool -> ('a, unit, string, unit) format4 -> 'a
end

module Osservices : sig
  val abspath : string -> bool * string
end

module Uobj : sig

  type sentinel_info_t = 
    {
      s_type: string;
      s_type_id : string;
      s_retvaldecl : string;
      s_fname: string;
      s_fparamdecl: string;
      s_fparamdwords : int;
      s_attribute : string;
      s_origin: int;
      s_length: int;	
    }
  
  
  type uobj_publicmethods_t = 
    {
      f_name: string;
      f_retvaldecl : string;
      f_paramdecl: string;
      f_paramdwords : int;
    }
  
    class uobject :
    object
      val d_callees_hashtbl : (string, string list) Hashtbl.t
      val d_hdr : Uberspark_manifest.hdr_t
      val d_interuobjcoll_callees_hashtbl :
        (string, string list) Hashtbl.t
      val d_load_addr : int ref
      val d_ltag : string
      val d_mf_filename : string ref
      val d_path_ns : string ref
      val d_publicmethods_hashtbl :
        (string, uobj_publicmethods_t) Hashtbl.t
      val d_sections_hashtbl :
        (string, Globaltypes.section_info_t) Hashtbl.t
      val d_sections_memory_map_hashtbl :
        (string, Globaltypes.section_info_t) Hashtbl.t
      val d_sections_memory_map_hashtbl_byorigin :
        (int, Globaltypes.section_info_t) Hashtbl.t
      val d_size : int ref
      val d_slt_trampolinecode : string ref
      val d_slt_trampolinedata : string ref
      val d_sources_c_file_list : string list ref
      val d_sources_casm_file_list : string list ref
      val d_sources_h_file_list : string list ref
      val d_target_def : Globaltypes.target_def_t
      method consolidate_sections_with_memory_map : int -> int -> unit
      method generate_linker_script :
        int ->
        int ->
        (int, Globaltypes.section_info_t) Hashtbl.t -> unit
      method generate_slt :
        string list -> string -> string -> string -> bool
      method generate_src_binhdr : unit
      method generate_src_interuobjcoll_callees_info : unit
      method generate_src_intrauobjcoll_callees_info : unit
      method generate_src_publicmethods_info : unit
      method get_d_callees_hashtbl : (string, string list) Hashtbl.t
      method get_d_hdr : Uberspark_manifest.hdr_t
      method get_d_interuobjcoll_callees_hashtbl :
        (string, string list) Hashtbl.t
      method get_d_load_addr : int
      method get_d_mf_filename : string
      method get_d_path_ns : string
      method get_d_publicmethods_hashtbl :
        (string, uobj_publicmethods_t) Hashtbl.t
      method get_d_sections_hashtbl :
        (string, Globaltypes.section_info_t) Hashtbl.t
      method get_d_sections_memory_map_hashtbl :
        (string, Globaltypes.section_info_t) Hashtbl.t
      method get_d_sections_memory_map_hashtbl_byorigin :
        (int, Globaltypes.section_info_t) Hashtbl.t
      method get_d_size : int
      method get_d_slt_trampolinecode : string
      method get_d_slt_trampolinedata : string
      method get_d_sources_c_file_list : string list
      method get_d_sources_casm_file_list : string list
      method get_d_sources_h_file_list : string list
      method get_d_target_def : Globaltypes.target_def_t
      method hashtbl_keys :
        (int, Globaltypes.section_info_t) Hashtbl.t ->
        int list
      method initialize : Globaltypes.target_def_t -> unit
      method parse_manifest : string -> bool -> bool
      method parse_manifest_slt : bool
      method parse_node_mf_uobj_binary : Yojson.Basic.t -> bool
      method parse_node_mf_uobj_callees : Yojson.Basic.t -> bool
      method parse_node_mf_uobj_interuobjcoll_callees :
        Yojson.Basic.t -> bool
      method parse_node_mf_uobj_publicmethods : Yojson.Basic.t -> bool
      method parse_node_mf_uobj_sources : Yojson.Basic.t -> bool
      method set_d_load_addr : int -> unit
      method set_d_size : int -> unit
      method set_d_slt_trampolinecode : string -> unit
      method set_d_slt_trampolinedata : string -> unit
      method set_d_target_def :
        Globaltypes.target_def_t -> unit
    end
  

end