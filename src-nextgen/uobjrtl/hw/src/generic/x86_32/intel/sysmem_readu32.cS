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

//functions to read/write memory from "system physical address"
//all reads and writes to non-framework memory areas (e.g., BIOS
//data areas, MMIO, rich guest memory etc.) should finally end up
//here

//author: amit vasudevan (amitvasudevan@acm.org)

#include <uberspark/uobjrtl/hw/include/generic/x86_32/intel/hw.h>




/** 
 * @brief documentation placeholder
 * 
 * @param[in] var1
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
CASM_FUNCDEF(uint32_t, uberspark_uobjrtl_hw__generic_x86_32_intel__sysmemaccess_readu32,
{
	__casm__pushl_esi();	//save esi
	__casm__movl_mesp_esi(0x8); //esi = addr
	__casm__movl_mesi_eax(0x0); //eax = [esi]
	__casm__popl_esi();	//restore esi
	__casm__retu32();		//return
},
uint32_t addr)


