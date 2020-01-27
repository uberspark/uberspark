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
	let staging_path_golden = (Uberspark_namespace.get_namespace_root_dir_prefix ()) ^ "/" ^ Uberspark_namespace.namespace_root ^ "/" ^
		Uberspark_namespace.namespace_staging_golden in 
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

	(* check if src staging exists *)
	if (Uberspark_osservices.file_exists staging_path_src) then begin
	
		(* create dst staging path *)
		Uberspark_osservices.mkdir ~parent:true staging_path_dst (`Octal 0o0777);

		(* copy everything from src staging to dst staging *)
		Uberspark_osservices.cp ~recurse:true (staging_path_src ^ "/*") (staging_path_dst ^ "/.");  

		(* remove the staging current symbolic link; its a regular file *)
		Uberspark_osservices.file_remove staging_path_current;

		(* create new staging current symbolic link and point to dst staging path *)
		Uberspark_osservices.symlink true staging_path_dst staging_path_current;
		
		(true)

	end else begin
		(* src staging does not exist *)
		(false)
	end;

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



let remove
	(staging_name : string)
	: bool =
	
	(* compute paths *)
	let staging_parent_path = (Uberspark_namespace.get_namespace_root_dir_prefix ()) ^ "/" ^ Uberspark_namespace.namespace_root ^ "/" ^ 
		Uberspark_namespace.namespace_staging in 
	let staging_path_to_remove = staging_parent_path ^ "/" ^ staging_name in
	let staging_path_current =  (Uberspark_namespace.get_namespace_staging_dir_prefix ()) in


	(* check if target staging path exists *)
	if (Uberspark_osservices.file_exists staging_path_current) then begin

		(* sanity check to make sure target staging path is not the the current staging *)
		if staging_path_to_remove <> staging_path_current then begin 

			(* remove the target staging path *)
			Uberspark_osservices.rmdir_recurse [ staging_path_to_remove ];

			(true)

		end else begin

			(* cant remove current staging path *)
			(false)

		end;

	end else begin

		(* target staging does not exist *)
		(false)

	end;

;;




let list
	()
	: string list =
	
	let retlist = ref [] in

	(* compute paths *)
	let staging_parent_path = (Uberspark_namespace.get_namespace_root_dir_prefix ()) ^ "/" ^ Uberspark_namespace.namespace_root ^ "/" ^ 
		Uberspark_namespace.namespace_staging in 
	let staging_path_current =  (Uberspark_namespace.get_namespace_staging_dir_prefix ()) in

	(* obtain list of files within the staging area, these correspond to the various stagings *)
	let staging_dirlist = Uberspark_osservices.readdir staging_parent_path in

	(* iterate through the list now *)
	List.iter (fun fname ->
		Uberspark_logger.log "staging_dir_entry=%s" fname;
	) staging_dirlist;

	retlist := staging_dirlist;

	(!retlist)
;;


