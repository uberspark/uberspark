/*
	libsentinel-call (generic-generic-x86_32)
	library interface for a regular call instruction on x86_32

	author: amit vasudevan (amitvasudevan@acm.org)
*/

// @param -- section name
.section .text

// @param -- uobj entry point function name
.global uobj_entry_point_fname
uobj_entry_point_fname:

	// @ param -- the sentinel for the uobj entry point
	movl $(UOBJ_ENTRY_POINT_SENTINEL), %eax
	jmp *%eax
