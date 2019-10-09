(*
	uberSpark bridge module
	author: amit vasudevan (amitvasudevan@acm.org)
*)
open Unix
open Yojson

type bridge_hdr_t = {
	mutable btype : string;
	mutable execname: string;
	mutable path: string;
	mutable params: string list;
	mutable extexecname: string;
	mutable devenv: string;
	mutable arch: string;
	mutable cpu: string;
	mutable version: string;
	mutable namespace: string;
}
;;

type cc_bridge_t = { 
	mutable hdr : bridge_hdr_t;
	mutable params_prefix_to_obj: string list;
	mutable params_prefix_to_asm: string list;
	mutable params_prefix_to_output: string list;
};;
