(*
	uberSpark configuration data interface
	author: amit vasudevan (amitvasudevan@acm.org)
*)

module Usconfig =
	struct

	(* standard include directories *)
	let std_incdirs = [
										"/usr/local/uberspark/include";
										"/usr/local/uberspark/hwm/include";
										"/usr/local/uberspark/libs/include";
										"."
										];;

	let get_std_incdirs () =	(std_incdirs)	;;

	(* standard preprocessor definitions *)
	let std_defines = [ 
											"__XMHF_TARGET_CPU_X86__"; 
											"__XMHF_TARGET_CONTAINER_VMX__";
											"__XMHF_TARGET_PLATFORM_X86PC__";
											"__XMHF_TARGET_TRIAD_X86_VMX_X86PC__"
										];;

	let get_std_defines () =	(std_defines)	;;

	let std_define_asm = [
												"__ASSEMBLY__"
											];;
				
	let get_std_define_asm () =	(std_define_asm)	;;
				
								
	end