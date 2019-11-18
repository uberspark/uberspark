(*------------------------------------------------------------------------------
	uberSpark uberobject collection verification and build interface implementation
	author: amit vasudevan (amitvasudevan@acm.org)
------------------------------------------------------------------------------*)

open Str


let d_mf_filename = ref "";;
let get_d_mf_filename = !d_mf_filename;;

let d_path_to_mf_filename = ref "";;
let get_d_path_to_mf_filename = !d_path_to_mf_filename;;

let d_path_ns = ref "";;
let get_d_path_ns = !d_path_ns;;

let d_hdr: Uberspark_manifest.Uobjcoll.uobjcoll_hdr_t = {f_namespace = ""; f_platform = ""; f_arch = ""; f_cpu = ""};;
let get_d_hdr = d_hdr;;


(*--------------------------------------------------------------------------*)
(* parse uobjcoll manifest *)
(* uobjcoll_mf_filename = uobj collection manifest filename *)
(*--------------------------------------------------------------------------*)
let parse_manifest 
	(uobjcoll_mf_filename : string)
	: bool =
	
	(* store filename and uobjcoll path to filename *)
	d_mf_filename := Filename.basename uobjcoll_mf_filename;
	d_path_to_mf_filename := Filename.dirname uobjcoll_mf_filename;
	
	(* read manifest JSON *)
	let (rval, mf_json) = Uberspark_manifest.get_manifest_json get_d_mf_filename in
	
	if (rval == false) then (false)
	else

	(* parse uobjcoll-hdr node *)
	let rval = (Uberspark_manifest.Uobjcoll.parse_uobjcoll_hdr mf_json d_hdr ) in
	if (rval == false) then (false)
	else

	let dummy=0 in begin
		d_path_ns := !Uberspark_namespace.namespace_root_dir  ^ "/" ^ d_hdr.f_namespace;
		Uberspark_logger.log ~lvl:Uberspark_logger.Debug "uobj collection path ns=%s" get_d_path_ns;
	end;

	(true)
;;




let build
	(uobjcoll_path_ns : string)
	(target_def : Defs.Basedefs.target_def_t)
	: bool =

	let retval = ref false in

	Uberspark_logger.log ~lvl:Uberspark_logger.Debug "uobj collection build start...";

	(!retval)
;;
