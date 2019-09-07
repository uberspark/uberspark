/*
 * @XMHF_LICENSE_HEADER_START@
 *
 * eXtensible, Modular Hypervisor Framework (XMHF)
 * Copyright (c) 2009-2012 Carnegie Mellon University
 * Copyright (c) 2010-2012 VDG Inc.
 * All Rights Reserved.
 *
 * Developed by: XMHF Team
 *               Carnegie Mellon University / CyLab
 *               VDG Inc.
 *               http://xmhf.org
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * Redistributions of source code must retain the above copyright
 * notice, this list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in
 * the documentation and/or other materials provided with the
 * distribution.
 *
 * Neither the names of Carnegie Mellon or VDG Inc, nor the names of
 * its contributors may be used to endorse or promote products derived
 * from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
 * CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
 * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
 * THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 * @XMHF_LICENSE_HEADER_END@
 */

//author: amit vasudevan (amitvasudevan@acm.org)

#ifndef __UBERSPARK_H__
#define __UBERSPARK_H__

#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdarg.h>
#include <string.h>
#include <ctype.h>
#include <assert.h>

#include <usconfig.h>
#include <xmhf-hwm.h>

#define _USMF_STR(s) #s
#define USMF_STR(s) _USMF_STR(s)


//////
#define UOBJCOLL_INFO_T_MAGIC	0xD00DF00D
#define UOBJCOLL_MAX_UOBJS		32

#define UOBJ_MAX_SENTINELS		8

#define UOBJ_SENTINEL_TYPE_CALL		call
#define UOBJ_SENTINEL_TYPE_CALL_ID	0xFFFF0000

//////


#ifndef __ASSEMBLY__


//////

typedef void * uobj_entrystub_t;

typedef struct {
	uint32_t s_type;
	uint32_t s_attribute;
	uint32_t s_load_addr;
	uint32_t s_load_size;
} __attribute__((packed)) uobj_sentinel_info_t;

typedef struct {
	uint32_t total_sentinels;
	uobj_sentinel_info_t sentinels[UOBJ_MAX_SENTINELS];
	uint32_t ustack_tos[MAX_PLATFORM_CPUS];
	uint32_t tstack_tos[MAX_PLATFORM_CPUS];
} __attribute__((packed)) uobj_info_t;

typedef struct {
	uint32_t magic;
	uint32_t total_uobjs;
	uint32_t sizeof_uobj_info_t;
	uint32_t load_addr;
}__attribute__((packed)) uobjcoll_hdr_t;

typedef struct {
	uobjcoll_hdr_t uobjcoll_hdr;
	uobj_info_t uobj[UOBJCOLL_MAX_UOBJS];
} __attribute__((packed)) uobjcoll_info_t;

#define SIZEOF_UOBJCOLL_INFO_T	(sizeof(uobjcoll_info_t))
#define UOBJ_INFO_T_SIZE		(sizeof(uobj_info_t))

//////




#if defined (__XMHF_VERIFICATION__) && defined (__USPARK_FRAMAC_VA__)
//////
// frama-c non-determinism functions
//////

uint32_t Frama_C_entropy_source;

//@ assigns Frama_C_entropy_source \from Frama_C_entropy_source;
void Frama_C_update_entropy(void);

uint32_t framac_nondetu32(void){
  Frama_C_update_entropy();
  return (uint32_t)Frama_C_entropy_source;
}

uint32_t framac_nondetu32interval(uint32_t min, uint32_t max)
{
  uint32_t r,aux;
  Frama_C_update_entropy();
  aux = Frama_C_entropy_source;
  if ((aux>=min) && (aux <=max))
    r = aux;
  else
    r = min;
  return r;
}

#endif //

#endif //__ASSEMBLY__


#endif //__UBERSPARK_H__
