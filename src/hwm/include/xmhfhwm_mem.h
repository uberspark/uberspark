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

// XMHF memory emulation
// author: amit vasudevan (amitvasudevan@acm.org)

#ifndef __XMHFHWM_MEM_H__
#define __XMHFHWM_MEM_H__

#ifndef __ASSEMBLY__


#define XMHFHWM_MEM_X86SMP_APBOOTSTRAP_DATASEG_BASE	(0x1100 << 4)
#define XMHFHWM_MEM_X86SMP_APBOOTSTRAP_DATASEG_SIZE	256
#define XMHFHWM_MEM_X86SMP_APBOOTSTRAP_CODESEG_BASE	(0x1000 << 4)
#define XMHFHWM_MEM_X86SMP_APBOOTSTRAP_CODESEG_SIZE	PAGE_SIZE_4K


extern uint8_t xmhfhwm_mem_region_apbootstrap_dataseg[XMHFHWM_MEM_X86SMP_APBOOTSTRAP_DATASEG_SIZE];


extern void xmhfhwm_vdriver_mem_copy_to_apbootstrap_codeseg(uint32_t sourceaddr);


bool _impl_xmhfhwm_mem_read(uint32_t sysmemaddr, sysmem_read_t readsize, uint64_t *read_result);
bool _impl_xmhfhwm_mem_write(uint32_t sysmemaddr, sysmem_write_t writesize, uint64_t write_value);
bool _impl_xmhfhwm_mem_sysmemcopy(sysmem_copy_t sysmemcopy_type,
				uint32_t dstaddr, uint32_t srcaddr, uint32_t size);



#endif	//__ASSEMBLY__



#endif //__XMHFHWM_MEM_H__
