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


	(* uobj manifest uberspark-loader json node var *)
	val json_node_uberspark_loader_var : Uberspark_manifest.Loader.json_node_uberspark_loader_t =
		{f_namespace = ""; f_platform = ""; f_arch = ""; f_cpu = ""; 
         f_bridge_ns = ""; f_bridge_cmd = []; 
		};
	method get_d_json_node_uberspark_loader_var = json_node_uberspark_loader_var;


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

		(* parse uberspark-loader node *)
		let rval = (Uberspark_manifest.Loader.json_node_uberspark_loader_to_var mf_json
				json_node_uberspark_loader_var) in

		if (rval == false) then (false)
		else

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


	(*--------------------------------------------------------------------------*)
	(* build image *)
	(*--------------------------------------------------------------------------*)
	method build_image	
    	()
		: bool =

        let retval = ref true in

		Uberspark_logger.log "building loader...";
        (* execute bridge_cmd command of the bridge_ns *)

    	List.iter ( fun (bcmd: string) -> 
    		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "executing command:%s" bcmd;
            if !retval == true then begin
       	        if not (Uberspark_bridge.Loader.invoke bcmd) then begin
		            Uberspark_logger.log ~lvl:Uberspark_logger.Error "command exited with non-zero value!";
		            retval := false;
                end else begin
		            Uberspark_logger.log ~lvl:Uberspark_logger.Debug "executed loader bridge command successfully!";
                end;
            end else begin
	            Uberspark_logger.log ~lvl:Uberspark_logger.Debug "skipping command: %s" bcmd;
            end;
        ) json_node_uberspark_loader_var.f_bridge_cmd;

		(!retval)	
	;



end;;


(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* stand-alone interfaces that are invoked for one-short create, initialize *)
(* and build *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)

(* create and initialize a loader object and return object if successful *)
let create_initialize
	(loader_ns : string)
	: bool * uobjcoll_loader option =

	(* create loader instance and initialize *)
	let loader:uobjcoll_loader = new uobjcoll_loader in
	let rval = (loader#initialize ~builddir:Uberspark_namespace.namespace_loader_build_dir 
		loader_ns) in	
    if (rval == false) then	begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "unable to initialize loader object!";
		(false, None)
	end else

	(* initialize loader bridge *)
	let l_rval = ref true in 
	let dummy = 0 in begin

       	if not (Uberspark_bridge.Loader.load (loader#get_d_json_node_uberspark_loader_var).f_bridge_ns) then begin
		    Uberspark_logger.log ~lvl:Uberspark_logger.Error "unable to load loader bridge!";
		    l_rval := false;
    	end else begin
    		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "loaded loader bridge";
           	if not (Uberspark_bridge.Loader.build ()) then begin
		        Uberspark_logger.log ~lvl:Uberspark_logger.Error "unable to build loader bridge!";
    		    l_rval := false;
            end else begin
        		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "built loader bridge successfully";
            end;
        end;
    
    end;

    if (!l_rval == false) then	begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "could not initialize loader bridge!";
		(false, None)
	end else

	(true, Some loader)
;;


let create_initialize_and_build
	(loader_ns : string)
    : bool * uobjcoll_loader option =

	(* create loader instance and initialize *)
    let (rval, loaderopt) = (create_initialize 
		loader_ns) in
    if (rval == false) then begin
		(false, None)
	end else

	match loaderopt with 
	| None ->
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "invalid loader instance!";
		(false, None)

	| Some loader ->

	(* build loader  *)
	let rval = (loader#build_image ()) in	
    if (rval == false) then	begin
		Uberspark_logger.log ~lvl:Uberspark_logger.Error "unable to build loader binary image!";
		(false, None)
	end else

	let dummy = 0 in begin
	Uberspark_logger.log "generated loader binary image";
	end;

	(true, Some loader)
;;

