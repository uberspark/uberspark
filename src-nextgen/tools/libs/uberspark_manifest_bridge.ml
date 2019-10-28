(****************************************************************************)
(****************************************************************************)
(* uberSpark manifest interface for bridge *)
(*	 author: amit vasudevan (amitvasudevan@acm.org) *)
(****************************************************************************)
(****************************************************************************)


(****************************************************************************)
(* manifest node types *)
(****************************************************************************)

(* bridge-hdr node type *)
type bridge_hdr_t = {
	mutable btype : string;
	mutable execname: string;
	mutable devenv: string;
	mutable arch: string;
	mutable cpu: string;
	mutable version: string;
	mutable path: string;
	mutable params: string list;
	mutable container_fname: string;
	mutable namespace: string;
}
;;

(* bridge-cc node type *)
type bridge_cc_t = { 
	mutable bridge_hdr : bridge_hdr_t;
	mutable params_prefix_to_obj: string;
	mutable params_prefix_to_asm: string;
	mutable params_prefix_to_output: string;
};;


(****************************************************************************)
(* manifest parse interfaces *)
(****************************************************************************)




(****************************************************************************)
(* manifest write interfaces *)
(****************************************************************************)


