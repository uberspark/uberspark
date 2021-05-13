(*===========================================================================*)
(*===========================================================================*)
(* uberSpark uobj collection manifest interface implementation *)
(*	 author: amit vasudevan (amitvasudevan@acm.org) *)
(*===========================================================================*)
(*===========================================================================*)



(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* type definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)

type json_node_uberspark_uobjcoll_uobjs_t =
{
	mutable master    : string;
	mutable templars  : string list;
};;

type json_node_uberspark_uobjcoll_publicmethods_t =
{
	mutable uobj_namespace    : string;
	mutable public_method	 : string;
	mutable sentinel_type_list : string list;
};;


type json_node_uberspark_uobjcoll_initmethod_sentinels_t =
{
	mutable sentinel_type    : string;
	mutable sentinel_size	 : int;
};;


type json_node_uberspark_uobjcoll_initmethod_t =
{
	mutable uobj_namespace    : string;
	mutable public_method	 : string;
	mutable sentinels : json_node_uberspark_uobjcoll_initmethod_sentinels_t list;
};;

type json_node_uberspark_uobjcoll_configdefs_t =
{
	mutable name    : string;
	mutable value	 : string;
};;


type json_node_uberspark_uobjcoll_t =
{
	mutable namespace    : string;			
	mutable platform	   : string;
	mutable arch	       : string;
	mutable cpu		   : string;
	mutable hpl		   : string;
	mutable sentinels_intra_uobjcoll : string list;
	mutable uobjs 		: json_node_uberspark_uobjcoll_uobjs_t;
	mutable init_method	: json_node_uberspark_uobjcoll_initmethod_t;
	mutable public_methods : (string * json_node_uberspark_uobjcoll_publicmethods_t) list;
	mutable loaders : string list;
	mutable configdefs_verbatim : bool;
	mutable configdefs: (string * json_node_uberspark_uobjcoll_configdefs_t) list;
	mutable sources : string list; (* this is not part of the manifest, but populated in the backend *)
};;



(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* interface definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)


(*--------------------------------------------------------------------------*)
(* parse manifest json sub-node "uobjs" into var *)
(* return: *)
(* on success: true; var is modified with master and templar uobj lists *)
(* on failure: false; var is unmodified *)
(*--------------------------------------------------------------------------*)
let json_node_uberspark_uobjcoll_uobjs_to_var 
	(mf_json : Yojson.Basic.t)
	(json_node_uberspark_uobjcoll_uobjs_var : json_node_uberspark_uobjcoll_uobjs_t)
	: bool =

	let retval = ref true in

	try
		let open Yojson.Basic.Util in
			let json_uobjcoll_uobjs = mf_json |> member "uberspark.uobjcoll.uobjs" in
			if(json_uobjcoll_uobjs <> `Null) then
				begin
					json_node_uberspark_uobjcoll_uobjs_var.master <- json_uobjcoll_uobjs |> member "master" |> to_string;
					json_node_uberspark_uobjcoll_uobjs_var.templars <- (json_list_to_string_list  (json_uobjcoll_uobjs |> member "templars" |> to_list));
				end
			;


	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval)
;;


(*--------------------------------------------------------------------------*)
(* parse manifest json sub-node "uberspark.uobjcoll.configdefs" into var *)
(* return: *)
(* on success: true; var is modified with configdefs *)
(* on failure: false; var is unmodified *)
(*--------------------------------------------------------------------------*)
let json_node_uberspark_uobjcoll_configdefs_to_var 
	(mf_json : Yojson.Basic.t)
	: bool * ((string * json_node_uberspark_uobjcoll_configdefs_t) list) =

	let retval = ref true in
	let configdefs_assoc_list : (string * json_node_uberspark_uobjcoll_configdefs_t) list ref = ref [] in 

	try
		let open Yojson.Basic.Util in

			if (mf_json |> member "uberspark.uobjcoll.configdefs") <> `Null then begin

				let uobjcoll_configdefs_json_list = mf_json |> member "uberspark.uobjcoll.configdefs" |> to_list in

				List.iter (fun (configdef_entry_json:Yojson.Basic.t) ->
					let configdef_entry : json_node_uberspark_uobjcoll_configdefs_t = {
							name = "";
							value = "";
					} in

					configdef_entry.name <- configdef_entry_json |> member "name" |> to_string;
					configdef_entry.value <- configdef_entry_json |> member "value" |> to_string;

					configdefs_assoc_list := !configdefs_assoc_list @ [ (configdef_entry.name, configdef_entry)];
		
				) uobjcoll_configdefs_json_list;

			end;


	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval, !configdefs_assoc_list)
;;







(*--------------------------------------------------------------------------*)
(* parse manifest json sub-node "init_method" into var *)
(* return: *)
(* on success: true; var is modified with init_method declarations and sentinels *)
(* on failure: false; var is unmodified *)
(*--------------------------------------------------------------------------*)
let json_node_uberspark_uobjcoll_initmethod_to_var 
	(mf_json : Yojson.Basic.t)
	: bool * json_node_uberspark_uobjcoll_initmethod_t =

	let retval = ref true in
	let entry : json_node_uberspark_uobjcoll_initmethod_t = {
			uobj_namespace = "";
			public_method = "";
			sentinels = [];
		} in
	let f_sentinels_list : json_node_uberspark_uobjcoll_initmethod_sentinels_t list ref = ref [] in 


	try
		let open Yojson.Basic.Util in
			let uobjcoll_initmethod_json = mf_json |> member "uberspark.uobjcoll.init_method" in
			if uobjcoll_initmethod_json != `Null then	begin
				entry.uobj_namespace <- uobjcoll_initmethod_json |> member "uobj_namespace" |> to_string;
				entry.public_method <- uobjcoll_initmethod_json |> member "public_method" |> to_string;
	
				let uobjcoll_initmethod_sentinels_json_list = uobjcoll_initmethod_json |> member "sentinels" |> to_list in

				List.iter (fun (sentinel_entry_json:Yojson.Basic.t) ->
					let sentinel_entry : json_node_uberspark_uobjcoll_initmethod_sentinels_t = {
							sentinel_type = "";
							sentinel_size = 0;
					} in

					sentinel_entry.sentinel_type <- sentinel_entry_json |> member "sentinel_type" |> to_string;

					if ( sentinel_entry_json |> member "sentinel_size") != `Null then begin
						sentinel_entry.sentinel_size <- int_of_string ( sentinel_entry_json |> member "sentinel_size" |> to_string);
					end;
					
					f_sentinels_list := !f_sentinels_list @ [ sentinel_entry ];
				) uobjcoll_initmethod_sentinels_json_list;

				entry.sentinels <- !f_sentinels_list;

			end;


	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval, entry)
;;


(*--------------------------------------------------------------------------*)
(* parse manifest json sub-node "public_methods" into var *)
(* return: *)
(* on success: true; var is modified with public_methods declarations and sentinels *)
(* on failure: false; var is unmodified *)
(*--------------------------------------------------------------------------*)
let json_node_uberspark_uobjcoll_publicmethods_to_var 
	(mf_json : Yojson.Basic.t)
	: bool * ((string * json_node_uberspark_uobjcoll_publicmethods_t) list) =

	let retval = ref true in
	let uobjcoll_publicmethods_assoc_list : (string * json_node_uberspark_uobjcoll_publicmethods_t) list ref = ref [] in 

	try
		let open Yojson.Basic.Util in
			let uobjcoll_publicmethods_json = mf_json |> member "uberspark.uobjcoll.public_methods" in
			if uobjcoll_publicmethods_json != `Null then	begin

				let uobj_ns_assoc_list = Yojson.Basic.Util.to_assoc uobjcoll_publicmethods_json in
					
				List.iter (fun ( (uobj_namespace:string),(uobj_ns_json:Yojson.Basic.t)) ->

					let pm_name_assoc_list = Yojson.Basic.Util.to_assoc uobj_ns_json in

					List.iter (fun ( (public_method:string),(sentinel_type_list_json:Yojson.Basic.t)) ->
						let sentinel_type_list = (json_list_to_string_list  (sentinel_type_list_json |> to_list)) in
						let entry : json_node_uberspark_uobjcoll_publicmethods_t = {
							uobj_namespace = uobj_namespace;
							public_method = public_method;
							sentinel_type_list = sentinel_type_list;
						} in
						let canonical_pm_name_key = (Uberspark.Namespace.get_variable_name_prefix_from_ns uobj_namespace) ^ "__" ^ public_method in
						uobjcoll_publicmethods_assoc_list := !uobjcoll_publicmethods_assoc_list @ [ (canonical_pm_name_key, entry) ];

					) pm_name_assoc_list;

				) uobj_ns_assoc_list;

			end;


	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval, !uobjcoll_publicmethods_assoc_list)
;;


(*--------------------------------------------------------------------------*)
(* parse manifest json sub-node "uberspark-uobjcoll" into var *)
(* return: *)
(* on success: true; var is modified with uberspark-uobjcoll json node definition *)
(* on failure: false; var is unmodified *)
(*--------------------------------------------------------------------------*)
let json_node_uberspark_uobjcoll_to_var 
	(mf_json : Yojson.Basic.t)
	(json_node_uberspark_uobjcoll_var : json_node_uberspark_uobjcoll_t)
	: bool =

	let retval = ref false in

	try
		let open Yojson.Basic.Util in
					if (mf_json |> member "uberspark.uobjcoll.namespace") != `Null then
						json_node_uberspark_uobjcoll_var.namespace <- mf_json |> member "uberspark.uobjcoll.namespace" |> to_string;
	
					if (mf_json |> member "uberspark.uobjcoll.platform") != `Null then
						json_node_uberspark_uobjcoll_var.platform <- mf_json |> member "uberspark.uobjcoll.platform" |> to_string;

					if (mf_json |> member "uberspark.uobjcoll.arch") != `Null then
						json_node_uberspark_uobjcoll_var.arch <- mf_json |> member "uberspark.uobjcoll.arch" |> to_string;
					
					if (mf_json |> member "uberspark.uobjcoll.cpu") != `Null then
						json_node_uberspark_uobjcoll_var.cpu <- mf_json |> member "uberspark.uobjcoll.cpu" |> to_string;
					
					if (mf_json |> member "uberspark.uobjcoll.hpl") != `Null then
						json_node_uberspark_uobjcoll_var.hpl <- mf_json |> member "uberspark.uobjcoll.hpl" |> to_string;
					
					if (mf_json |> member "uberspark.uobjcoll.sentinels_intra_uobjcoll") != `Null then
						json_node_uberspark_uobjcoll_var.sentinels_intra_uobjcoll <- (json_list_to_string_list (mf_json |> member "uberspark.uobjcoll.sentinels_intra_uobjcoll" |> to_list));

					(* check for loaders if any *)
					if (mf_json |> member "uberspark.uobjcoll.loaders") != `Null then begin
						json_node_uberspark_uobjcoll_var.loaders <- (json_list_to_string_list (mf_json |> member "uberspark.uobjcoll.loaders" |> to_list));
					end;
					
					(* check if configdefs_verbatim is specified *)
					if (mf_json |> member "uberspark.uobjcoll.configdefs_verbatim") != `Null then begin
						json_node_uberspark_uobjcoll_var.configdefs_verbatim <- mf_json |> member "uberspark.uobjcoll.configdefs_verbatim" |> to_bool;
					end else begin
						json_node_uberspark_uobjcoll_var.configdefs_verbatim <- false;
					end;


					let rval1 = (json_node_uberspark_uobjcoll_uobjs_to_var 
						mf_json json_node_uberspark_uobjcoll_var.uobjs) in
					let (rval2, json_node_uberspark_uobjcoll_initmethod_var) = 
						(json_node_uberspark_uobjcoll_initmethod_to_var mf_json) in
					let (rval3, json_node_uberspark_uobjcoll_publicmethods_var) = 
						(json_node_uberspark_uobjcoll_publicmethods_to_var mf_json) in
					let (rval4, json_node_uberspark_uobjcoll_configdefs_var) = 
						(json_node_uberspark_uobjcoll_configdefs_to_var mf_json) in


					if (rval1 && rval2 && rval3 && rval4) then begin
						json_node_uberspark_uobjcoll_var.init_method <- json_node_uberspark_uobjcoll_initmethod_var;
						json_node_uberspark_uobjcoll_var.public_methods <- json_node_uberspark_uobjcoll_publicmethods_var;
						json_node_uberspark_uobjcoll_var.configdefs <- json_node_uberspark_uobjcoll_configdefs_var;
						retval := true;
					end;

	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval)
;;



(* 
	copy constructor for uberspark.uobjcoll.xxx nodes
	we use this to copy one json_node_uberspark_uobjcoll_t 
	variable into another 
*)
let json_node_uberspark_uobjcoll_var_copy 
	(output : json_node_uberspark_uobjcoll_t )
	(input : json_node_uberspark_uobjcoll_t )
	: unit = 

	output.namespace <- input.namespace; 
	output.platform <- input.platform; 
	output.arch <- input.arch; 
	output.cpu <- input.cpu ; 
	output.hpl <- input.hpl;
	output.sentinels_intra_uobjcoll <- input.sentinels_intra_uobjcoll;
	output.uobjs.master <- input.uobjs.master; 
	output.uobjs.templars <- input.uobjs.templars;
	output.init_method.uobj_namespace <- input.init_method.uobj_namespace; 
	output.init_method.public_method <- input.init_method.public_method; 
	output.init_method.sentinels <- input.init_method.sentinels;
	output.public_methods <- input.public_methods;
	output.loaders <- input.loaders;
	output.configdefs_verbatim <- input.configdefs_verbatim;
	output.configdefs <- input.configdefs;
	output.sources <- input.sources;


	()
;;


(* default json_node_uberspark_uobjcoll_t variable definition *)
(* we use this to initialize variables of type json_node_uberspark_uobjcoll_t *)
let json_node_uberspark_uobjcoll_var_default_value () 
	: json_node_uberspark_uobjcoll_t = 

	{
		namespace = ""; platform = ""; arch = ""; cpu = ""; hpl = "";
		sentinels_intra_uobjcoll = [];
		uobjs = { master = ""; templars = [];};
		init_method = {uobj_namespace = ""; public_method = ""; sentinels = [];};
		public_methods = [];
		loaders = [];
		configdefs_verbatim = false;
		configdefs = [];
		sources = [];
	}
;;


