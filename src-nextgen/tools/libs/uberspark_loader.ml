(*===========================================================================*)
(*===========================================================================*)
(*	uberSpark uobjcollection loader build interface       	             	 *)
(*	implementation															 *)
(*	author: amit vasudevan (amitvasudevan@acm.org)							 *)
(*===========================================================================*)
(*===========================================================================*)

open Str

		
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* type definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)


(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* class definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)

class uobjcoll_loader 
	= object(self)

	val d_loader_ns = ref "";
	method get_d_loader_ns = !d_loader_ns;
	method set_d_loader_ns (loader_ns : string) = 
		d_loader_ns := loader_ns;
		()
	;

	val d_loader_mf_filename_abspath = ref "";
	method get_d_loader_mf_filename_abspath = !d_loader_mf_filename_abspath;
	method set_d_loader_mf_filename_abspath (loader_mf_filename_abspath : string) = 
		d_loader_mf_filename_abspath := loader_mf_filename_abspath;
		()
	;

	(* loader manifest file top-level json *)
	val d_mf_json : Yojson.Basic.t ref = ref `Null;


	(*--------------------------------------------------------------------------*)
	(* parse loader manifest *)
	(* usmf_filename = canonical uobj manifest filename *)
	(*--------------------------------------------------------------------------*)
	method parse_manifest 
		()
		: bool =

		(* read manifest JSON *)
		let (rval, mf_json) = (Uberspark_manifest.get_json_for_manifest 
			self#get_d_loader_mf_filename_abspath) in
		
		if (rval == false) then (false)
		else

		(* store manifest JSON *)
		let dummy = 0 in begin
		d_mf_json := mf_json;
		end;

		(* parse uberspark-uobj node *)
		(*let rval = (Uberspark_manifest.Uobj.json_node_uberspark_uobj_to_var mf_json
				json_node_uberspark_uobj_var) in

		if (rval == false) then (false)
		else*)

		(true)
	;



	(*--------------------------------------------------------------------------*)
	(* initialize *)
	(*--------------------------------------------------------------------------*)
	method initialize	
		?(builddir = ".")
		(loader_ns : string)
		: bool = 
	
		(* store loader namespace *)
		self#set_d_loader_ns loader_ns;

        (* store loader manifest filename abspath *)
        self#set_d_loader_mf_filename_abspath (Uberspark_namespace.get_namespace_staging_dir_prefix () ^ 
                "/" ^ self#get_d_loader_ns ^
                "/" ^ Uberspark_namespace.namespace_root_mf_filename);
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "loader manifest filename abspath=%s" self#get_d_loader_mf_filename_abspath ;

		(* parse manifest *)
		let rval = (self#parse_manifest ()) in	
		if (rval == false) then	begin
			Uberspark_logger.log ~lvl:Uberspark_logger.Error "unable to stat/parse manifest for loader!";
			(rval)
		end else

		let dummy = 0 in begin
		Uberspark_logger.log "successfully parsed loader manifest";
		end;

		(true)	
	;


end;;


(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* stand-alone interfaces that are invoked for one-short create, initialize *)
(* and perform specific operation (compile, verify, build) *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)

