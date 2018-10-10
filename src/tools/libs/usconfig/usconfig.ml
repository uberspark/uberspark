(*
	uberSpark configuration data interface
	author: amit vasudevan (amitvasudevan@acm.org)
*)

module Usconfig =
	struct

	(* standard include directories *)
	let std_incdirs = [
											"../../include";
											"."
										];;

	(* standard preprocessor definitions *)
	let std_defines = [ 
											"__XMHF_TARGET_CPU_X86__"; 
											"__XMHF_TARGET_CONTAINER_VMX__";
											"__XMHF_TARGET_PLATFORM_X86PC__";
											"__XMHF_TARGET_TRIAD_X86_VMX_X86PC__"
										];;

	let std_define_asm = [
												"__ASSEMBLY__"
											];;
				
				
								
	end