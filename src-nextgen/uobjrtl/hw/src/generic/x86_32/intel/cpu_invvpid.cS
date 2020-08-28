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

//uberspark_uobjrtl_hw__generic_x86_32_intel__vmx: CPU VMX functions
//author: amit vasudevan (amitvasudevan@acm.org)

#include <uberspark/uobjrtl/hw/include/generic/x86_32/intel/hw.h>



//////
// VMX instruction INVVPID
//////
/** 
 * @fn uberspark_uobjrtl_hw__generic_x86_32_intel__invvpid
 * 
 * @brief CASM documentation placeholder
 * 
 * @param[in] invalidation_type
 * @param[in] vpid
 * @param[in] linear_addr_lo
 * @param[in] linear_addr_hi
 * 
 * @retval something
 *  
 * @details_begin 
 *  lorem ipsum dolor...
 * @details_end
 *
 *  @uobjrtl_namespace{uberspark/uobjrtl/hw}
 * 
 * @headers_begin 
 *  #include <uberspark/uobjrtl/hw/include/generic/x86_32/intel/hw.h>
 * @headers_end
 * 
 * @comments_begin
 * @comments_end
 * 
 * 
 */
CASM_FUNCDEF(void, uberspark_uobjrtl_hw__generic_x86_32_intel__invvpid,
{
    __casm__subl_imm_esp(0x10);		//make space for 128-bits (4 32-bit dwords)
    __casm__movl_mesp_edx(0x14);		//edx = invalidation_type
    __casm__movl_mesp_eax(0x18);		//eax = vpid
    __casm__movl_eax_mesp(0x0);		//(esp+0x0) = vpid
    __casm__movl_imm_mesp(0x0,0x4);	//(esp+0x4) = 0 (reserved)
    __casm__movl_mesp_eax(0x1C);		//eax = linear_addr_lo
    __casm__movl_eax_mesp(0x8);		//(esp+0x8) = linear_addr_lo
    __casm__movl_mesp_eax(0x20);		//eax = linear_addr_hi
    __casm__movl_eax_mesp(0xC);		//(esp+0xC) = linear_addr_hi
    __casm__invvpid_mesp_edx(0x0);		//invvpid (esp+0), edx
    __casm__addl_imm_esp(0x10);		//remove 128-bits and reset esp to incoming frame
    __casm__ret();						//return
},
uint32_t invalidation_type,
uint32_t vpid,
uint32_t linear_addr_lo,
uint32_t linear_addr_hi)


