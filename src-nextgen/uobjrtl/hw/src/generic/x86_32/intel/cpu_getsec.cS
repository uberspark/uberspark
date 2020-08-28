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

// uberspark_uobjrtl_hw__generic_x86_32_intel__txt: CPU TXT functions
// authors: amit vasudevan (amitvasudevan@acm.org) and jonmccune@cmu.edu

#include <uberspark/uobjrtl/hw/include/generic/x86_32/intel/hw.h>



/** 
 * @fn uberspark_uobjrtl_hw__generic_x86_32_intel__getsec
 * 
 * @brief CASM documentation placeholder
 * 
 * @param[in] eax
 * @param[in] ebx
 * @param[in] ecx
 * @param[in] edx
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
CASM_FUNCDEF(void, uberspark_uobjrtl_hw__generic_x86_32_intel__getsec,
{
    __casm__pushl_esi();
    __casm__pushl_ebx();

    __casm__movl_mesp_eax(0xC);
    __casm__movl_meax_eax(0x0);
    __casm__movl_mesp_ebx(0x10);
    __casm__movl_mebx_ebx(0x0);
    __casm__movl_mesp_ecx(0x14);
    __casm__movl_mecx_ecx(0x0);
    __casm__movl_mesp_edx(0x18);
    __casm__movl_medx_edx(0x0);

    __casm__getsec();

    __casm__movl_mesp_esi(0xC);
    __casm__movl_eax_mesi(0x0);
    __casm__movl_mesp_esi(0x10);
    __casm__movl_ebx_mesi(0x0);
    __casm__movl_mesp_esi(0x14);
    __casm__movl_ecx_mesi(0x0);
    __casm__movl_mesp_esi(0x18);
    __casm__movl_edx_mesi(0x0);

    __casm__popl_ebx();
    __casm__popl_esi();
    __casm__ret();
},
uint32_t *eax,
uint32_t *ebx,
uint32_t *ecx,
uint32_t *edx)


