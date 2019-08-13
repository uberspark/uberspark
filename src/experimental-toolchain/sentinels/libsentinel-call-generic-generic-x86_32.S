/*
	libsentinel-call (generic-generic-x86_32)
	library interface for a regular call instruction on x86_32

	author: amit vasudevan (amitvasudevan@acm.org)
*/

// @param -- section name
.section UOBJ_SENTINEL_SECTION_NAME

// @param -- uobj entry point function name
.global UOBJ_SENTINEL_ENTRY_POINT_FNAME
UOBJ_SENTINEL_ENTRY_POINT_FNAME:

	// @ param -- the sentinel for the uobj entry point
	movl $(UOBJ_SENTINEL_ENTRY_POINT), %eax
	jmp *%eax
