(*===========================================================================*)
(*===========================================================================*)
(*	uberSpark staging interface implementation		 *)
(*	author: amit vasudevan (amitvasudevan@acm.org)							 *)
(*===========================================================================*)
(*===========================================================================*)

open Unix
open Yojson


(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* type definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)



(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* variable definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)



(*Uberspark_logger.log ~lvl:Uberspark_logger.Error "%s" s;*)

(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* interface definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)

let create_as_new
	(staging_name : string)
	: bool =
	
	(* compute paths *)
	let staging_parent_path = (Uberspark_namespace.get_namespace_root_dir_prefix ()) ^ "/" ^ Uberspark_namespace.namespace_root ^ "/" ^ 
		Uberspark_namespace.namespace_staging in 
	let staging_path_golden = (Uberspark_namespace.get_namespace_root_dir_prefix ()) ^ "/" ^ Uberspark_namespace.namespace_root ^ 
		"/" ^ Uberspark_namespace.namespace_staging_golden in 
	let staging_path_current = staging_parent_path ^ "/" ^ Uberspark_namespace.namespace_staging_current in 
	let staging_path_to_create = staging_parent_path ^ "/" ^ staging_name in

	(* create new staging path *)
	Uberspark_osservices.mkdir ~parent:true staging_path_to_create (`Octal 0o0777);

	(* copy everything from root base to new staging path *)
	Uberspark_osservices.cp ~recurse:true (staging_path_golden ^ "/*") (staging_path_to_create ^ "/.");  

	(* remove the staging current symbolic link; its a regular file *)
	Uberspark_osservices.file_remove staging_path_current;

	(* create new staging current symbolic link and point to new staging path *)
	Uberspark_osservices.symlink true staging_path_to_create staging_path_current;
	
	(true)
;;


let create_from_existing
	(dst_staging_name : string)
	(src_staging_name : string)
	: bool =
	
	(* compute paths *)
	let staging_parent_path = (Uberspark_namespace.get_namespace_root_dir_prefix ()) ^ "/" ^ Uberspark_namespace.namespace_root ^ "/" ^ 
		Uberspark_namespace.namespace_staging in 
	let staging_path_current = staging_parent_path ^ "/" ^ Uberspark_namespace.namespace_staging_current in 
	let staging_path_src = staging_parent_path ^ "/" ^ src_staging_name in 
	let staging_path_dst = staging_parent_path ^ "/" ^ dst_staging_name in 

	(* create dst staging path *)
	Uberspark_osservices.mkdir ~parent:true staging_path_dst (`Octal 0o0777);

	(* copy everything from src staging to dst staging *)
	Uberspark_osservices.cp ~recurse:true (staging_path_src ^ "/*") (staging_path_dst ^ "/.");  

	(* remove the staging current symbolic link; its a regular file *)
	Uberspark_osservices.file_remove staging_path_current;

	(* create new staging current symbolic link and point to dst staging path *)
	Uberspark_osservices.symlink true staging_path_dst staging_path_current;
	
	(true)
;;



let switch
	(staging_name : string)
	: bool =
	
	(* compute paths *)
	let staging_parent_path = (Uberspark_namespace.get_namespace_root_dir_prefix ()) ^ "/" ^ Uberspark_namespace.namespace_root ^ "/" ^ 
		Uberspark_namespace.namespace_staging in 
	let staging_path_current = staging_parent_path ^ "/" ^ Uberspark_namespace.namespace_staging_current in 
	let staging_path_to_switch = staging_parent_path ^ "/" ^ staging_name in

	(* check if target staging path exists *)
	if (Uberspark_osservices.file_exists staging_path_current) then begin
		
		(* remove the staging current symbolic link; its a regular file *)
		Uberspark_osservices.file_remove staging_path_current;

		(* create new staging current symbolic link and point to new staging path *)
		Uberspark_osservices.symlink true staging_path_to_switch staging_path_current;
		
		(true)

	end else begin

		(* target staging does not exist *)
		(false)

	end;

;;




