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
 * x86 cpu txt implementation
 * author: amit vasudevan (amitvasudevan@acm.org)
*/


#include <uberspark/include/uberspark.h>


hwm_txt_heap_t hwm_txt_heap = {
        .biosdatasize = (sizeof(bios_data_t)+0x8),
	.osmledatasize = (PAGE_SIZE_4K+0x8),
	.ossinitdatasize = (sizeof(os_sinit_data_t)+0x8),
        .sinitmledatasize = (sizeof(sinit_mle_data_t)+0x8),
        .ossinitdata.capabilities = TXT_CAPS_T_RLP_WAKE_MONITOR,
	.sinitmledata.rlp_wakeup_addr = HWM_TXT_SYSMEM_RLPWAKEUPADDR,
};

uint32_t hwm_txt_heap_base_hi=0;
uint32_t hwm_txt_heap_base_lo=HWM_TXT_SYSMEM_HEAPBASE;

uint32_t hwm_txt_heap_size_hi=0;
uint32_t hwm_txt_heap_size_lo=sizeof(hwm_txt_heap);

uint32_t hwm_txt_mle_join_hi=0;
uint32_t hwm_txt_mle_join_lo=0;

uint32_t hwm_txt_rlp_wakeup_addr=0;

static unsigned char *hwm_txt_memcpy(unsigned char *dst, const unsigned char *src, size_t n)
{
	const unsigned char *p = src;
	unsigned char *q = dst;

	while (n) {
		*q++ = *p++;
		n--;
	}

	return dst;
}


bool _impl_hwm_txt_read(uint32_t sysmemaddr, sysmem_read_t readsize, uint64_t *read_result){
	bool retval = true;

	if(sysmemaddr == (TXT_PUB_CONFIG_REGS_BASE+TXTCR_HEAP_BASE)){
		//@assert (readsize == SYSMEMREADU32);
		*read_result = (uint64_t)hwm_txt_heap_base_lo;

	}else if(sysmemaddr == (TXT_PUB_CONFIG_REGS_BASE+TXTCR_HEAP_BASE+0x4)){
		//@assert (readsize == SYSMEMREADU32);
		*read_result = (uint64_t)hwm_txt_heap_base_hi;

	}else if(sysmemaddr == (TXT_PUB_CONFIG_REGS_BASE+TXTCR_HEAP_SIZE)){
		//@assert (readsize == SYSMEMREADU32);
		*read_result = (uint64_t)hwm_txt_heap_size_lo;

	}else if(sysmemaddr == (TXT_PUB_CONFIG_REGS_BASE+TXTCR_HEAP_SIZE+0x4)){
		//@assert (readsize == SYSMEMREADU32);
		*read_result = (uint64_t)hwm_txt_heap_size_hi;

	}else if(sysmemaddr == (TXT_PRIV_CONFIG_REGS_BASE+TXTCR_MLE_JOIN)){
		//@assert (readsize == SYSMEMREADU32);
		*read_result = (uint64_t)hwm_txt_mle_join_lo;

	}else if(sysmemaddr == (TXT_PRIV_CONFIG_REGS_BASE+TXTCR_MLE_JOIN+0x4)){
		//@assert (readsize == SYSMEMREADU32);
		*read_result = (uint64_t)hwm_txt_mle_join_hi;

	}else if(sysmemaddr >= HWM_TXT_SYSMEM_HEAPBASE &&
		sysmemaddr < (HWM_TXT_SYSMEM_HEAPBASE+sizeof(hwm_txt_heap))){
		//@assert (readsize == SYSMEMREADU32);
                *read_result = (uint64_t) *((uint32_t *)((uint32_t)&hwm_txt_heap + (sysmemaddr - HWM_TXT_SYSMEM_HEAPBASE)));
	}else{
		retval= false;
	}


	return retval;
}


bool _impl_hwm_txt_write(uint32_t sysmemaddr, sysmem_write_t writesize, uint64_t write_value){
	bool retval = false;

	if(sysmemaddr == (TXT_PRIV_CONFIG_REGS_BASE+TXTCR_MLE_JOIN)){
		//@assert writesize == SYSMEMWRITEU32;
		hwm_txt_mle_join_lo = (uint32_t)write_value;
		retval = true;
	}else if(sysmemaddr == (TXT_PRIV_CONFIG_REGS_BASE+TXTCR_MLE_JOIN+0x4)){
		//@assert writesize == SYSMEMWRITEU32;
		hwm_txt_mle_join_hi = (uint32_t)write_value;
		retval = true;
	}else if(sysmemaddr == HWM_TXT_SYSMEM_RLPWAKEUPADDR){
		//@assert writesize == SYSMEMWRITEU32;
		hwm_vdriver_txt_write_rlp_wakeup_addr(hwm_txt_rlp_wakeup_addr, (uint32_t)write_value);
		hwm_txt_rlp_wakeup_addr = (uint32_t)write_value;
		retval = true;
	}else{

	}


	return retval;
}



bool _impl_hwm_txt_sysmemcopy(sysmem_copy_t sysmemcopy_type,
				uint32_t dstaddr, uint32_t srcaddr, uint32_t size){
	bool retval = true;

	if(sysmemcopy_type == SYSMEMCOPYSYS2OBJ){
		//dstaddr = obj address space
		//srcaddr = TXT address space
		if(srcaddr >= HWM_TXT_SYSMEM_HEAPBASE &&
			(srcaddr+size-1) < (HWM_TXT_SYSMEM_HEAPBASE+sizeof(hwm_txt_heap))){
			//@assert \valid((unsigned char *)dstaddr + (0..(size-1)));
			hwm_txt_memcpy(dstaddr, ((uint32_t)&hwm_txt_heap+(srcaddr-HWM_TXT_SYSMEM_HEAPBASE)), size);
		}else{
			//@assert 1;
			retval = false;
		}

	}else{
		//@assert 1;
		retval = false;
	}

	return retval;
}

