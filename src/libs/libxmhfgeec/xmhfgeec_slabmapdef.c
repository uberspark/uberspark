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

/*
 * slab entry stub
 * author: amit vasudevan (amitvasudevan@acm.org)
*/

#include <uberspark.h>

//#include <xmhf.h>
#include <xmhfgeec.h>
//#include <xmhf-debug.h>

__attribute__ ((section(".rodata"))) char * _namestring="_xmhfslab_";
__attribute__ ((section(".stack"))) __attribute__ ((aligned(4096))) uint8_t _slab_stack[MAX_PLATFORM_CPUS][XMHF_SLAB_STACKSIZE];
__attribute__ ((section(".stackhdr"))) uint32_t _slab_tos[MAX_PLATFORM_CPUS]= {
    ((uint32_t)&_slab_stack[1]),
    ((uint32_t)&_slab_stack[2]),
    ((uint32_t)&_slab_stack[3]),
    ((uint32_t)&_slab_stack[4]),
    ((uint32_t)&_slab_stack[5]),
    ((uint32_t)&_slab_stack[6]),
    ((uint32_t)&_slab_stack[7]),
    ((uint32_t)&_slab_stack[8])  };
__attribute__ ((section(".slab_dmadata"))) uint8_t _dmadataplaceholder[1] = {0};


