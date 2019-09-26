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

#ifndef __UBERSPARK_CONFIG_H__
#define __UBERSPARK_CONFIG_H__


#define USCONFIG_SIZEOF_UOBJ_TSTACK				4096
#define USCONFIG_SIZEOF_UOBJ_USTACK				4096

#define USCONFIG_UOBJCOLL_MAX_UOBJS				32
#define USCONFIG_UOBJCOLL_MAX_ENTRYSENTINELS	32
#define USCONFIG_UOBJ_MAX_SECTIONS				32
#define USCONFIG_UOBJ_PUBLICMETHOD_MAX_LENGTH   128
#define USCONFIG_UOBJ_MAX_PUBLICMETHODS         16
#define USCONFIG_UOBJ_MAX_INTRAUOBJCOLL_CALLEES 16
#define USCONFIG_UOBJ_NAMESPACE_MAX_LENGTH      256
#define USCONFIG_UOBJ_MAX_INTERUOBJCOLL_CALLEES 16

//////
// to be defunct definitions
//////
#define XMHFGEEC_MAX_SLABS                  32
#define XMHFGEEC_TOTAL_SLABS                16
#define XMHF_CONFIG_MAX_INCLDEVLIST_ENTRIES 6
#define XMHF_CONFIG_MAX_EXCLDEVLIST_ENTRIES 6
#define	XMHF_SLAB_STACKSIZE					16384

#ifndef __ASSEMBLY__



#endif //__ASSEMBLY__


#endif //__UBERSPARK_CONFIG_H__
