/*
	sentinel-call (generic-generic-x86_32)
	sentinel based on regular call instruction on x86_32

	author: amit vasudevan (amitvasudevan@acm.org)
*/

// @ param -- the uobj entry point function this sentinel is for
.extern UOBJ_ENTRY_POINT_FNAME

// @param -- section name
.section UOBJ_SENTINEL_SECTION_NAME

// @param -- customized name based on platform, cpu and arch
.global UOBJ_SENTINEL_ENTRY_POINT_FNAME
UOBJ_SENTINEL_ENTRY_POINT_FNAME:

	// @ param -- the uobj entry point function this sentinel is for
	jmp UOBJ_ENTRY_POINT_FNAME
