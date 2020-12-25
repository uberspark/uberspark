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
	(json_node_uberspark_uobjcoll : Yojson.Basic.t)
	(json_node_uberspark_uobjcoll_uobjs_var : json_node_uberspark_uobjcoll_uobjs_t)
	: bool =

	let retval = ref true in

	try
		let open Yojson.Basic.Util in
			let json_uobjcoll_uobjs = json_node_uberspark_uobjcoll |> member "uobjs" in
			if(json_uobjcoll_uobjs <> `Null) then
				begin
					json_node_uberspark_uobjcoll_uobjs_var.master <- json_uobjcoll_uobjs |> member "master" |> to_string;
					json_node_uberspark_uobjcoll_uobjs_var.templars <- (json_list_to_string_list  (json_uobjcoll_uobjs |> member "templars" |> to_list));
					retval := true;
				end
			;


	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval)
;;


(*--------------------------------------------------------------------------*)
(* parse manifest json sub-node "init_method" into var *)
(* return: *)
(* on success: true; var is modified with init_method declarations and sentinels *)
(* on failure: false; var is unmodified *)
(*--------------------------------------------------------------------------*)
let json_node_uberspark_uobjcoll_initmethod_to_var 
	(json_node_uberspark_uobjcoll : Yojson.Basic.t)
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
			let uobjcoll_initmethod_json = json_node_uberspark_uobjcoll |> member "init_method" in
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

				retval := true;
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
	(json_node_uberspark_uobjcoll : Yojson.Basic.t)
	: bool * ((string * json_node_uberspark_uobjcoll_publicmethods_t) list) =

	let retval = ref true in
	let uobjcoll_publicmethods_assoc_list : (string * json_node_uberspark_uobjcoll_publicmethods_t) list ref = ref [] in 

	try
		let open Yojson.Basic.Util in
			let uobjcoll_publicmethods_json = json_node_uberspark_uobjcoll |> member "public_methods" in
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
						let canonical_pm_name_key = (Uberspark_namespace.get_variable_name_prefix_from_ns uobj_namespace) ^ "__" ^ public_method in
						uobjcoll_publicmethods_assoc_list := !uobjcoll_publicmethods_assoc_list @ [ (canonical_pm_name_key, entry) ];

					) pm_name_assoc_list;

				) uobj_ns_assoc_list;

				retval := true;
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

	let retval = ref true in

	try
		let open Yojson.Basic.Util in
			let json_node_uberspark_uobjcoll = mf_json |> member "uberspark-uobjcoll" in
				if json_node_uberspark_uobjcoll != `Null then begin
					json_node_uberspark_uobjcoll_var.namespace <- json_node_uberspark_uobjcoll |> member "namespace" |> to_string;
					json_node_uberspark_uobjcoll_var.platform <- json_node_uberspark_uobjcoll |> member "platform" |> to_string;
					json_node_uberspark_uobjcoll_var.arch <- json_node_uberspark_uobjcoll |> member "arch" |> to_string;
					json_node_uberspark_uobjcoll_var.cpu <- json_node_uberspark_uobjcoll |> member "cpu" |> to_string;
					json_node_uberspark_uobjcoll_var.hpl <- json_node_uberspark_uobjcoll |> member "hpl" |> to_string;
					json_node_uberspark_uobjcoll_var.sentinels_intra_uobjcoll <- (json_list_to_string_list (json_node_uberspark_uobjcoll |> member "sentinels_intra_uobjcoll" |> to_list));

					(* check for loaders if any *)
					if (json_node_uberspark_uobjcoll |> member "loaders") != `Null then begin
						json_node_uberspark_uobjcoll_var.loaders <- (json_list_to_string_list (json_node_uberspark_uobjcoll |> member "loaders" |> to_list));
					end;
					
					let rval1 = (json_node_uberspark_uobjcoll_uobjs_to_var json_node_uberspark_uobjcoll json_node_uberspark_uobjcoll_var.uobjs) in
					let (rval2, json_node_uberspark_uobjcoll_initmethod_var) = 
						(json_node_uberspark_uobjcoll_initmethod_to_var json_node_uberspark_uobjcoll) in
					let (rval3, json_node_uberspark_uobjcoll_publicmethods_var) = 
						(json_node_uberspark_uobjcoll_publicmethods_to_var json_node_uberspark_uobjcoll) in

					if (rval1 && rval2 && rval3) then begin
						json_node_uberspark_uobjcoll_var.init_method <- json_node_uberspark_uobjcoll_initmethod_var;
						json_node_uberspark_uobjcoll_var.public_methods <- json_node_uberspark_uobjcoll_publicmethods_var;
						retval := true;
					end;
				end;

	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval)
;;



