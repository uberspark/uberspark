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
	val json_node_uberspark_loader_var : Uberspark.Manifest.Loader.json_node_uberspark_loader_t =
		{namespace = ""; platform = ""; arch = ""; cpu = ""; 
         bridge_namespace = ""; bridge_cmd = []; 
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
		let (rval, mf_json) = (Uberspark.Manifest.get_json_for_manifest 
			self#get_d_loader_mf_filename_abspath) in
		
		if (rval == false) then (false)
		else

		(* store manifest JSON *)
		let dummy = 0 in begin
		d_mf_json := mf_json;
		end;

		(* parse uberspark-loader node *)
		let rval = (Uberspark.Manifest.Loader.json_node_uberspark_loader_to_var mf_json
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
        self#set_d_loader_mf_filename_abspath (Uberspark.Namespace.get_namespace_staging_dir_prefix () ^ 
                "/" ^ self#get_d_loader_ns ^
                "/" ^ Uberspark.Namespace.namespace_root_mf_filename);
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "loader manifest filename abspath=%s" self#get_d_loader_mf_filename_abspath ;

		(* parse manifest *)
		let rval = (self#parse_manifest ()) in	
		if (rval == false) then	begin
			Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "unable to stat/parse manifest for loader!";
			(rval)
		end else

		let dummy = 0 in begin
		Uberspark.Logger.log "successfully parsed loader manifest";

		(* TBD: figure out build time-stamps before nuking this *)
		Uberspark.Osservices.rmdir_recurse [ (Uberspark.Namespace.get_namespace_staging_dir_prefix () ^ 
                "/" ^ self#get_d_loader_ns ^
                "/" ^ Uberspark.Namespace.namespace_loader_build_dir) ];
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "removed loader build folder";
		
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
        let r_bcmd = ref "" in

		Uberspark.Logger.log "building loader...";
        (* execute bridge_cmd command of the bridge_ns *)

    	List.iter ( fun (bcmd: string) -> 
    		Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "executing command:%s" bcmd;
    		
            r_bcmd := "cd " ^ (Uberspark.Namespace.get_namespace_staging_dir_prefix ()) ^ "/" ^ 
                self#get_d_loader_ns ^ " && " ^ bcmd;
            Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "revised command:%s" !r_bcmd;

            if !retval == true then begin

				retval := Uberspark.Platform.loader_bridge#invoke 
				[
					("@@BRIDGE_INPUT_FILES@@", "");
					("@@BRIDGE_SOURCE_FILES@@", "");
					("@@BRIDGE_INCLUDE_DIRS@@", "");
					("@@BRIDGE_INCLUDE_DIRS_WITH_PREFIX@@", "");
					("@@BRIDGE_COMPILEDEFS@@", "");
					("@@BRIDGE_COMPILEDEFS_WITH_PREFIX@@", "");
					("@@BRIDGE_DEFS@@", "");
					("@@BRIDGE_DEFS_WITH_PREFIX@@", "");
					("@@BRIDGE_PLUGIN_DIR@@", ((Uberspark.Namespace.get_namespace_root_dir_prefix ()) ^ "/" ^
					Uberspark.Namespace.namespace_root ^ "/" ^ Uberspark.Namespace.namespace_root_vf_bridge_plugin));
					("@@BRIDGE_CONTAINER_MOUNT_POINT@@", Uberspark.Namespace.namespace_bridge_container_mountpoint);
					("@@BRIDGE_LSCRIPT_FILENAME@@", "");
					("@@BRIDGE_BINARY_FILENAME@@", "");
					("@@BRIDGE_BINARY_FLAT_FILENAME@@", "");
					("@@BRIDGE_CCLIB_FILENAME@@", "");
					("@@BRIDGE_CMD@@", !r_bcmd);

				];

       	        if not !retval  then begin
		            Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "command exited with non-zero value!";
                end else begin
		            Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "executed loader bridge command successfully!";
                end;

            end else begin
	            Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "skipping command: %s" bcmd;
            end;
        ) json_node_uberspark_loader_var.bridge_cmd;

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
	let rval = (loader#initialize ~builddir:Uberspark.Namespace.namespace_loader_build_dir 
		loader_ns) in	
    if (rval == false) then	begin
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "unable to initialize loader object!";
		(false, None)
	end else

	(* initialize loader bridge *)
	let l_rval = ref true in 
	let dummy = 0 in begin

       	if not (Uberspark.Platform.loader_bridge#load (loader#get_d_json_node_uberspark_loader_var).bridge_namespace) then begin
		    Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "unable to load loader bridge!";
		    l_rval := false;
    	end else begin
    		Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "loaded loader bridge";
           	if not (Uberspark.Platform.loader_bridge#build ()) then begin
		        Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "unable to build loader bridge!";
    		    l_rval := false;
            end else begin
        		Uberspark.Logger.log ~lvl:Uberspark.Logger.Debug "built loader bridge successfully";
            end;
        end;
    
    end;

    if (!l_rval == false) then	begin
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "could not initialize loader bridge!";
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
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "invalid loader instance!";
		(false, None)

	| Some loader ->

	(* build loader  *)
	let rval = (loader#build_image ()) in	
    if (rval == false) then	begin
		Uberspark.Logger.log ~lvl:Uberspark.Logger.Error "unable to build loader binary image!";
		(false, None)
	end else

	let dummy = 0 in begin
	Uberspark.Logger.log "generated loader binary image";
	end;

	(true, Some loader)
;;

