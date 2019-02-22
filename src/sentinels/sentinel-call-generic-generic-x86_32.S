/*
	sentinel-call (generic-generic-x86_32)
	sentinel based on regular call instruction on x86_32

	author: amit vasudevan (amitvasudevan@acm.org)
*/

// @ param -- the uobj entry point function this sentinel is for
.extern sentinel_uobj_entry_point_function

// @param -- section name
.section .text

// @param -- customized name based on platform, cpu and arch
.global sentinel_call_generic_generic_x86_32
sentinel_call_generic_generic_x86_32:

	// @ param -- the uobj entry point function this sentinel is for
	jmp sentinel_uobj_entry_point_function
