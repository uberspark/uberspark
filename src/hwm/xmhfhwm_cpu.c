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
 * x86 cpu hardware model implementation
 * author: amit vasudevan (amitvasudevan@acm.org)
*/


#include <uberspark.h>

uint32_t xmhfhwm_cpu_gprs_eip = 0;
uint32_t xmhfhwm_cpu_gprs_esp = 0;
uint32_t xmhfhwm_cpu_gprs_ebp = 0;

uint32_t xmhfhwm_cpu_gprs_eax = 0;
uint32_t xmhfhwm_cpu_gprs_ebx = 0;
uint32_t xmhfhwm_cpu_gprs_edx = 0;
uint32_t xmhfhwm_cpu_gprs_ecx = 0;
uint32_t xmhfhwm_cpu_gprs_esi = 0;
uint32_t xmhfhwm_cpu_gprs_edi = 0;

uint32_t xmhfhwm_cpu_eflags = 0;

uint16_t xmhfhwm_cpu_gdtr_limit=0;
uint32_t xmhfhwm_cpu_gdtr_base=0;
uint16_t xmhfhwm_cpu_idtr_limit=0;
uint32_t xmhfhwm_cpu_idtr_base=0;

uint16_t xmhfhwm_cpu_tr_selector=0;

uint32_t xmhfhwm_cpu_cr0 = 0;
uint32_t xmhfhwm_cpu_cr2 = 0;
uint32_t xmhfhwm_cpu_cr3 = 0;
uint32_t xmhfhwm_cpu_cr4 = 0;

uint32_t xmhfhwm_cpu_cs_selector = 0;
uint32_t xmhfhwm_cpu_ds_selector = 0;
uint32_t xmhfhwm_cpu_es_selector = 0;
uint32_t xmhfhwm_cpu_fs_selector = 0;
uint32_t xmhfhwm_cpu_gs_selector = 0;
uint32_t xmhfhwm_cpu_ss_selector = 0;

uint64_t xmhfhwm_cpu_xcr0 = 0;
xmhfhwm_cpu_state_t xmhfhwm_cpu_state = CPU_STATE_RUNNING;

uint64_t xmhfhwm_cpu_msr_efer = 0;
uint64_t xmhfhwm_cpu_msr_vmx_procbased_ctls2_msr = 0x0000008200000000ULL;
uint64_t xmhfhwm_cpu_msr_mtrrcap = 0x0000000000000d0aULL;
uint64_t xmhfhwm_cpu_msr_apic_base =  MMIO_APIC_BASE;
uint64_t xmhfhwm_cpu_msr_sysenter_cs = 0;
uint64_t xmhfhwm_cpu_msr_sysenter_eip = 0;
uint32_t xmhfhwm_cpu_msr_sysenter_esp_hi = 0;
uint32_t xmhfhwm_cpu_msr_sysenter_esp_lo = 0;
uint64_t xmhfhwm_cpu_msr_rdtsc = 0;

uint32_t xmhfhwm_cpu_vmcs_host_rip = 0;
uint32_t xmhfhwm_cpu_vmcs_host_rsp = 0;
uint32_t xmhfhwm_cpu_vmcs_host_cr3 = 0;

uint32_t xmhfhwm_pci_config_addr_port = 0x0UL;



//////
// move to ESP related instructions
//////

void _impl_xmhfhwm_cpu_insn_addl_imm_esp(uint32_t value){
	xmhfhwm_vdriver_writeesp(xmhfhwm_cpu_gprs_esp, (xmhfhwm_cpu_gprs_esp+value));
	xmhfhwm_cpu_gprs_esp += value;
}

void _impl_xmhfhwm_cpu_insn_movl_meax_esp(int index){
	uint32_t value_meax;
	value_meax = *((uint32_t *)((uint32_t)((int32_t)xmhfhwm_cpu_gprs_eax + (int32_t)index)));
	xmhfhwm_vdriver_writeesp(xmhfhwm_cpu_gprs_esp, value_meax);
	xmhfhwm_cpu_gprs_esp = value_meax;
}

void _impl_xmhfhwm_cpu_insn_subl_imm_esp(uint32_t value){
	xmhfhwm_vdriver_writeesp(xmhfhwm_cpu_gprs_esp, (xmhfhwm_cpu_gprs_esp-value));
	xmhfhwm_cpu_gprs_esp -= value;
}

void _impl_xmhfhwm_cpu_insn_movl_edx_esp(void){
	xmhfhwm_vdriver_writeesp(xmhfhwm_cpu_gprs_esp, xmhfhwm_cpu_gprs_edx);
	xmhfhwm_cpu_gprs_esp = xmhfhwm_cpu_gprs_edx;
}

void _impl_xmhfhwm_cpu_insn_movl_eax_esp(void){
	xmhfhwm_vdriver_writeesp(xmhfhwm_cpu_gprs_esp, xmhfhwm_cpu_gprs_eax);
	xmhfhwm_cpu_gprs_esp = xmhfhwm_cpu_gprs_eax;
}






void _impl_xmhfhwm_cpu_insn_hlt(void){
	// //@assert 0;
	// while(1);
	xmhfhwm_cpu_state = CPU_STATE_HALT;
}



void _impl_xmhfhwm_cpu_insn_pushl_mesp(int index){
	uint32_t value;
	value = *((uint32_t *)(xmhfhwm_cpu_gprs_esp + index));
	xmhfhwm_cpu_gprs_esp -= sizeof(uint32_t);
	*((uint32_t *)xmhfhwm_cpu_gprs_esp) = value;
}

void _impl_xmhfhwm_cpu_insn_pushl_mem(uint32_t value){
	xmhfhwm_cpu_gprs_esp -= sizeof(uint32_t);
	*((uint32_t *)xmhfhwm_cpu_gprs_esp) = value;
}


uint32_t _impl_xmhfhwm_cpu_insn_popl_mem(void){
	uint32_t value = *((uint32_t *)xmhfhwm_cpu_gprs_esp);
	xmhfhwm_cpu_gprs_esp += sizeof(uint32_t);
	return value;
}



void _impl_xmhfhwm_cpu_insn_movl_mesp_eax(uint32_t index){
	uint32_t *value;
	value = (uint32_t *)((uint32_t)((uint32_t)xmhfhwm_cpu_gprs_esp + (uint32_t)index));
	xmhfhwm_cpu_gprs_eax = *value;
}

void _impl_xmhfhwm_cpu_insn_movl_mesp_ebx(int index){
	uint32_t *value;
	value = (uint32_t *)((uint32_t)((int)xmhfhwm_cpu_gprs_esp + (int)index));
	xmhfhwm_cpu_gprs_ebx = *value;
}

void _impl_xmhfhwm_cpu_insn_movl_mesp_ecx(int index){
	uint32_t *value;
	value = (uint32_t *)((uint32_t)((int)xmhfhwm_cpu_gprs_esp + (int)index));
	xmhfhwm_cpu_gprs_ecx = *value;
}

void _impl_xmhfhwm_cpu_insn_movl_mesp_edx(int index){
	uint32_t *value;
	value = (uint32_t *)((uint32_t)((int)xmhfhwm_cpu_gprs_esp + (int)index));
	xmhfhwm_cpu_gprs_edx = *value;
}

void _impl_xmhfhwm_cpu_insn_movl_eax_ebx(void){
	xmhfhwm_cpu_gprs_ebx = xmhfhwm_cpu_gprs_eax;
}

void _impl_xmhfhwm_cpu_insn_movl_eax_edi(void){
	xmhfhwm_cpu_gprs_edi = xmhfhwm_cpu_gprs_eax;
}


void _impl_xmhfhwm_cpu_insn_cmpl_imm_meax(uint32_t value, int index){
	uint32_t value_meax;
	value_meax = *((uint32_t *)((uint32_t)((int32_t)xmhfhwm_cpu_gprs_eax + (int32_t)index)));

	//XXX: TODO propagation of CF, PF, AF, SF and OF
        if(value_meax - value == 0)
		xmhfhwm_cpu_eflags |= EFLAGS_ZF;

}


void _impl_xmhfhwm_cpu_insn_movl_imm_meax(uint32_t value, int index){
	uint32_t *value_meax;
	value_meax = (uint32_t *)((uint32_t)((int32_t)xmhfhwm_cpu_gprs_eax + (int32_t)index));
	*value_meax = value;
}

void _impl_xmhfhwm_cpu_insn_movl_meax_edx(int index){
	uint32_t value_meax;
	value_meax = *((uint32_t *)((uint32_t)((int32_t)xmhfhwm_cpu_gprs_eax + (int32_t)index)));
	xmhfhwm_cpu_gprs_edx = value_meax;
}

void _impl_xmhfhwm_cpu_insn_movl_meax_edi(int index){
	uint32_t value_meax;
	value_meax = *((uint32_t *)((uint32_t)((int32_t)xmhfhwm_cpu_gprs_eax + (int32_t)index)));
	xmhfhwm_cpu_gprs_edi = value_meax;
}

void _impl_xmhfhwm_cpu_insn_movl_meax_esi(int index){
	uint32_t value_meax;
	value_meax = *((uint32_t *)((uint32_t)((int32_t)xmhfhwm_cpu_gprs_eax + (int32_t)index)));
	xmhfhwm_cpu_gprs_esi = value_meax;
}


void _impl_xmhfhwm_cpu_insn_movl_meax_ebp(int index){
	uint32_t value_meax;
	value_meax = *((uint32_t *)((uint32_t)((int32_t)xmhfhwm_cpu_gprs_eax + (int32_t)index)));
	xmhfhwm_cpu_gprs_ebp = value_meax;
}


void _impl_xmhfhwm_cpu_insn_movl_meax_ebx(int index){
	uint32_t value_meax;
	value_meax = *((uint32_t *)((uint32_t)((int32_t)xmhfhwm_cpu_gprs_eax + (int32_t)index)));
	xmhfhwm_cpu_gprs_ebx = value_meax;
}

void _impl_xmhfhwm_cpu_insn_movl_meax_eax(int index){
	uint32_t value_meax;
	value_meax = *((uint32_t *)((uint32_t)((int32_t)xmhfhwm_cpu_gprs_eax + (int32_t)index)));
	xmhfhwm_cpu_gprs_eax = value_meax;
}



void _impl_xmhfhwm_cpu_insn_movl_meax_ecx(int index){
	uint32_t value_meax;
	value_meax = *((uint32_t *)((uint32_t)((int32_t)xmhfhwm_cpu_gprs_eax + (int32_t)index)));
	xmhfhwm_cpu_gprs_ecx = value_meax;
}

void _impl_xmhfhwm_cpu_insn_movl_ecx_meax(int index){
	uint32_t *value_meax;
	value_meax = (uint32_t *)((uint32_t)((int32_t)xmhfhwm_cpu_gprs_eax + (int32_t)index));
	*value_meax = xmhfhwm_cpu_gprs_ecx;
}


void _impl_xmhfhwm_cpu_insn_movl_edx_meax(int index){
	uint32_t *value_meax;
	value_meax = (uint32_t *)((uint32_t)((int32_t)xmhfhwm_cpu_gprs_eax + (int32_t)index));
	*value_meax = xmhfhwm_cpu_gprs_edx;
}

void _impl_xmhfhwm_cpu_insn_bsrl_mesp_eax(int index){
	uint32_t value = *((uint32_t *)((uint32_t)((int32_t)xmhfhwm_cpu_gprs_esp + (int32_t)index)));
	uint32_t i;
	for(i=31; i >=0; i--){
		if(value & (1UL << i)){
			xmhfhwm_cpu_gprs_eax = i;
			return;
		}
	}
}

void _impl_xmhfhwm_cpu_insn_pushl_esi(void){
	xmhfhwm_cpu_gprs_esp -= sizeof(uint32_t);
	*((uint32_t *)xmhfhwm_cpu_gprs_esp) = xmhfhwm_cpu_gprs_esi;
}

void _impl_xmhfhwm_cpu_insn_pushl_ebx(void){
	xmhfhwm_cpu_gprs_esp -= sizeof(uint32_t);
	*((uint32_t *)xmhfhwm_cpu_gprs_esp) = xmhfhwm_cpu_gprs_ebx;
}


void _impl_xmhfhwm_cpu_insn_movl_mebx_ebx(int index){
	uint32_t value_mebx;
	value_mebx = *((uint32_t *)((uint32_t)((int32_t)xmhfhwm_cpu_gprs_ebx + (int32_t)index)));
	xmhfhwm_cpu_gprs_ebx = value_mebx;
}

void _impl_xmhfhwm_cpu_insn_movl_mecx_ecx(int index){
	uint32_t value_mecx;
	value_mecx = *((uint32_t *)((uint32_t)((int32_t)xmhfhwm_cpu_gprs_ecx + (int32_t)index)));
	xmhfhwm_cpu_gprs_ecx = value_mecx;
}

void _impl_xmhfhwm_cpu_insn_movl_medx_edx(int index){
	uint32_t value_medx;
	value_medx = *((uint32_t *)((uint32_t)((int32_t)xmhfhwm_cpu_gprs_edx + (int32_t)index)));
	xmhfhwm_cpu_gprs_edx = value_medx;
}


void _impl_xmhfhwm_cpu_insn_cpuid(void){

	if(xmhfhwm_cpu_gprs_eax == 0x0){
		xmhfhwm_cpu_gprs_ebx = INTEL_STRING_DWORD1;
		xmhfhwm_cpu_gprs_ecx = INTEL_STRING_DWORD3;
		xmhfhwm_cpu_gprs_edx = INTEL_STRING_DWORD2;
	}else if (xmhfhwm_cpu_gprs_eax == 0x1){
		xmhfhwm_cpu_gprs_ecx = (1 << 5); //VMX support
		xmhfhwm_cpu_gprs_ecx |= (1UL << 26); //XSAVE support
		xmhfhwm_cpu_gprs_edx = ((uint32_t)(1 << 12)); //MTRR support
	}else{
		//XXX: TODO
		xmhfhwm_cpu_gprs_ebx = 0;
		xmhfhwm_cpu_gprs_edx = 0;
	}

}

void _impl_xmhfhwm_cpu_insn_movl_mesp_esi(int index){
	uint32_t *value;
	value = (uint32_t *)((uint32_t)((int)xmhfhwm_cpu_gprs_esp + (int)index));
	xmhfhwm_cpu_gprs_esi = *value;
}


void _impl_xmhfhwm_cpu_insn_movl_ebx_mesi(int index){
	uint32_t *value;
	value = (uint32_t *)((uint32_t)((int)xmhfhwm_cpu_gprs_esi + (int)index));
	*value = xmhfhwm_cpu_gprs_ebx;
}

void _impl_xmhfhwm_cpu_insn_movl_ecx_mesi(int index){
	uint32_t *value;
	value = (uint32_t *)((uint32_t)((int)xmhfhwm_cpu_gprs_esi + (int)index));
	*value = xmhfhwm_cpu_gprs_ecx;
}


void _impl_xmhfhwm_cpu_insn_popl_eax(void){
	uint32_t value = *((uint32_t *)xmhfhwm_cpu_gprs_esp);
	xmhfhwm_cpu_gprs_esp += sizeof(uint32_t);
	xmhfhwm_cpu_gprs_eax = value;
}

void _impl_xmhfhwm_cpu_insn_popl_esi(void){
	uint32_t value = *((uint32_t *)xmhfhwm_cpu_gprs_esp);
	xmhfhwm_cpu_gprs_esp += sizeof(uint32_t);
	xmhfhwm_cpu_gprs_esi = value;
}

void _impl_xmhfhwm_cpu_insn_popl_ebx(void){
	uint32_t value = *((uint32_t *)xmhfhwm_cpu_gprs_esp);
	xmhfhwm_cpu_gprs_esp += sizeof(uint32_t);
	xmhfhwm_cpu_gprs_ebx = value;
}

void _impl_xmhfhwm_cpu_insn_popl_edx(void){
	uint32_t value = *((uint32_t *)xmhfhwm_cpu_gprs_esp);
	xmhfhwm_cpu_gprs_esp += sizeof(uint32_t);
	xmhfhwm_cpu_gprs_edx = value;
}


void _impl_xmhfhwm_cpu_insn_cli(void){
	xmhfhwm_cpu_eflags &= ~(EFLAGS_IF);
}

void _impl_xmhfhwm_cpu_insn_sti(void){
	xmhfhwm_cpu_eflags |= (EFLAGS_IF);
}


void _impl_xmhfhwm_cpu_insn_sgdt_mesp(int index){
	uint32_t *tmem_gdtbase;
	uint16_t *tmem_gdtlimit;
	tmem_gdtlimit = (uint16_t *)((uint32_t)((int)xmhfhwm_cpu_gprs_esp + (int)index));
	tmem_gdtbase = (uint32_t *)((uint32_t)((int)xmhfhwm_cpu_gprs_esp + (int)index) + sizeof(uint16_t));
	*tmem_gdtlimit = xmhfhwm_cpu_gdtr_limit;
	*tmem_gdtbase = xmhfhwm_cpu_gdtr_base;
}

void _impl_xmhfhwm_cpu_insn_xorl_eax_eax(void){
	xmhfhwm_cpu_gprs_eax = 0;
}

void _impl_xmhfhwm_cpu_insn_xorl_edx_edx(void){
	xmhfhwm_cpu_gprs_edx = 0;
}

void _impl_xmhfhwm_cpu_insn_sidt_mesp(int index){
	uint32_t *tmem_idtbase;
	uint16_t *tmem_idtlimit;
	tmem_idtlimit = (uint16_t *)((uint32_t)((int)xmhfhwm_cpu_gprs_esp + (int)index));
	tmem_idtbase = (uint32_t *)((uint32_t)((int)xmhfhwm_cpu_gprs_esp + (int)index) + sizeof(uint32_t));
	*tmem_idtlimit = xmhfhwm_cpu_idtr_limit;
	*tmem_idtbase = xmhfhwm_cpu_idtr_base;
}

void _impl_xmhfhwm_cpu_insn_getsec(void){
	//XXX:TODO
	if(xmhfhwm_cpu_gprs_ebx == 0)
		xmhfhwm_cpu_gprs_eax = 0;

}

void _impl_xmhfhwm_cpu_insn_str_ax(void){
	xmhfhwm_cpu_gprs_eax &= 0xFFFF0000UL;
	xmhfhwm_cpu_gprs_eax |= (uint16_t)xmhfhwm_cpu_tr_selector;
}

void _impl_xmhfhwm_cpu_insn_addl_eax_ecx(void){
	xmhfhwm_cpu_gprs_ecx += xmhfhwm_cpu_gprs_eax;
}

void _impl_xmhfhwm_cpu_insn_addl_eax_esp(void){
	xmhfhwm_cpu_gprs_esp += xmhfhwm_cpu_gprs_eax;
}

void _impl_xmhfhwm_cpu_insn_movl_mecx_eax(int index){
	uint32_t *value_mecx;
	value_mecx = (uint32_t *)((uint32_t)((int)xmhfhwm_cpu_gprs_ecx + (int)index));
	xmhfhwm_cpu_gprs_eax = *value_mecx;
}

void _impl_xmhfhwm_cpu_insn_movl_mecx_edx(int index){
	uint32_t *value_mecx;
	value_mecx = (uint32_t *)((uint32_t)((int)xmhfhwm_cpu_gprs_ecx + (int)index));
	xmhfhwm_cpu_gprs_edx = *value_mecx;
}


void _impl_xmhfhwm_cpu_insn_addl_imm_ecx(uint32_t value){
	xmhfhwm_cpu_gprs_ecx += value;
}

void _impl_xmhfhwm_cpu_insn_addl_imm_eax(uint32_t value){
	xmhfhwm_cpu_gprs_eax += value;
}



void _impl_xmhfhwm_cpu_insn_movl_edx_ecx(void){
	xmhfhwm_cpu_gprs_ecx = xmhfhwm_cpu_gprs_edx;
}

void _impl_xmhfhwm_cpu_insn_movl_eax_ecx(void){
	xmhfhwm_cpu_gprs_ecx = xmhfhwm_cpu_gprs_eax;
}

void _impl_xmhfhwm_cpu_insn_andl_imm_edx(uint32_t value){
	xmhfhwm_cpu_gprs_edx &= value;
}

void _impl_xmhfhwm_cpu_insn_andl_imm_ecx(uint32_t value){
	xmhfhwm_cpu_gprs_ecx &= value;
}

void _impl_xmhfhwm_cpu_insn_shl_imm_ecx(uint32_t value){
	xmhfhwm_cpu_gprs_ecx = xmhfhwm_cpu_gprs_ecx << value;
}

void _impl_xmhfhwm_cpu_insn_orl_imm_eax(uint32_t value){
	xmhfhwm_cpu_gprs_eax |= value;
}

void _impl_xmhfhwm_cpu_insn_shr_imm_eax(uint32_t value){
	xmhfhwm_cpu_gprs_eax = xmhfhwm_cpu_gprs_eax >> value;
}

void _impl_xmhfhwm_cpu_insn_orl_ecx_eax(void){
	xmhfhwm_cpu_gprs_eax = xmhfhwm_cpu_gprs_eax | xmhfhwm_cpu_gprs_ecx;
}

void _impl_xmhfhwm_cpu_insn_orl_edx_eax(void){
	xmhfhwm_cpu_gprs_eax = xmhfhwm_cpu_gprs_eax | xmhfhwm_cpu_gprs_edx;
}

void _impl_xmhfhwm_cpu_insn_inb_dx_al(void){
	xmhfhwm_cpu_gprs_eax &= 0xFFFFFF00UL;
        //XXX:TODO nondetu8 in lower 8 bits
}

void _impl_xmhfhwm_cpu_insn_inl_dx_eax(void){
	uint16_t port = (uint16_t)xmhfhwm_cpu_gprs_edx;
        if(port == PCI_CONFIG_ADDR_PORT){
		xmhfhwm_cpu_gprs_eax = xmhfhwm_pci_config_addr_port;
        }else{
		xmhfhwm_cpu_gprs_eax = 0UL;
		//XXX:TODO nondetu32
        }
}

void _impl_xmhfhwm_cpu_insn_movl_eax_mesp(int index){
	uint32_t *value_mesp;
	value_mesp = (uint32_t *)((uint32_t)((int)xmhfhwm_cpu_gprs_esp + (int)index));
	*value_mesp = xmhfhwm_cpu_gprs_eax;
}

void _impl_xmhfhwm_cpu_insn_movl_imm_mesp(uint32_t value, int index){
	uint32_t *value_mesp;
	value_mesp = (uint32_t *)((uint32_t)((int)xmhfhwm_cpu_gprs_esp + (int)index));
	*value_mesp = value;
}

void _impl_xmhfhwm_cpu_insn_invept_mesp_edx(int index){
	uint32_t *value_mesp;
	value_mesp = (uint32_t *)((uint32_t)((int)xmhfhwm_cpu_gprs_esp + (int)index));
        //XXX: TODO invept logic
}

void _impl_xmhfhwm_cpu_insn_invvpid_mesp_edx(int index){
	uint32_t *value_mesp;
	value_mesp = (uint32_t *)((uint32_t)((int)xmhfhwm_cpu_gprs_esp + (int)index));
        //XXX: TODO invvpid logic
}


void _impl_xmhfhwm_cpu_insn_movw_mesp_ax(int index){
	uint16_t *value_mesp;
	value_mesp = (uint16_t *)((uint32_t)((int)xmhfhwm_cpu_gprs_esp + (int)index));
	xmhfhwm_cpu_gprs_eax &= 0xFFFF0000UL;
	xmhfhwm_cpu_gprs_eax |= (uint16_t)*value_mesp;
}

void _impl_xmhfhwm_cpu_insn_invvpid_mesp_ecx(int index){
	uint32_t *value_mesp;
	value_mesp = (uint32_t *)((uint32_t)((int)xmhfhwm_cpu_gprs_esp + (int)index));
        //XXX: TODO invvpid logic
	xmhfhwm_cpu_eflags &= ~(EFLAGS_CF);
	xmhfhwm_cpu_eflags &= ~(EFLAGS_ZF);

}

void _impl_xmhfhwm_cpu_insn_movl_imm_eax(uint32_t value){
	xmhfhwm_cpu_gprs_eax = value;
}

void _impl_xmhfhwm_cpu_insn_movl_imm_esp(uint32_t value){
	xmhfhwm_cpu_gprs_esp = value;
}

void _impl_xmhfhwm_cpu_insn_movl_imm_esi(uint32_t value){
	xmhfhwm_cpu_gprs_esi = value;
}

void _impl_xmhfhwm_cpu_insn_movl_imm_edi(uint32_t value){
	xmhfhwm_cpu_gprs_edi = value;
}

void _impl_xmhfhwm_cpu_insn_movl_imm_ecx(uint32_t value){
	xmhfhwm_cpu_gprs_ecx = value;
}

void _impl_xmhfhwm_cpu_insn_movl_imm_edx(uint32_t value){
	xmhfhwm_cpu_gprs_edx = value;
}

void _impl_xmhfhwm_cpu_insn_movl_imm_ebx(uint32_t value){
	xmhfhwm_cpu_gprs_ebx = value;
}


void _impl_xmhfhwm_cpu_insn_inw_dx_ax(void){
	xmhfhwm_cpu_gprs_eax &= 0xFFFF0000UL;
	//TODO: nondetu16
}

void _impl_xmhfhwm_cpu_insn_lgdt_mecx(int index){
	uint16_t *gdtlimit;
	uint32_t *gdtbase;
	gdtlimit = (uint16_t *)((uint32_t)((int)xmhfhwm_cpu_gprs_ecx + (int)index));
	gdtbase = (uint32_t *)((uint32_t)((int)xmhfhwm_cpu_gprs_ecx + (int)index + sizeof(uint16_t)));
        xmhfhwm_cpu_gdtr_base = *gdtbase;
        xmhfhwm_cpu_gdtr_limit = *gdtlimit;
}

void _impl_xmhfhwm_cpu_insn_lidt_mecx(int index){
	uint16_t *idtlimit;
	uint32_t *idtbase;
	idtlimit = (uint16_t *)((uint32_t)((int)xmhfhwm_cpu_gprs_ecx + (int)index));
	idtbase = (uint32_t *)((uint32_t)((int)xmhfhwm_cpu_gprs_ecx + (int)index + sizeof(uint16_t)));
        xmhfhwm_cpu_idtr_base = *idtbase;
        xmhfhwm_cpu_idtr_limit = *idtlimit;
}

void _impl_xmhfhwm_cpu_insn_ltr_ax(void){
	xmhfhwm_cpu_tr_selector = (uint16_t)(xmhfhwm_cpu_gprs_eax & 0x0000FFFFUL);
}

void _impl_xmhfhwm_cpu_insn_outb_al_dx(void){
	//TODO: output al to dx
}

void _impl_xmhfhwm_cpu_insn_outl_eax_dx(void){
	uint16_t port = (uint16_t)xmhfhwm_cpu_gprs_edx;

	if(port == PCI_CONFIG_ADDR_PORT){
                xmhfhwm_pci_config_addr_port = xmhfhwm_cpu_gprs_eax;
	}else{
		//TODO: output eax to dx
	}
}

void _impl_xmhfhwm_cpu_insn_outw_ax_dx(void){
	//TODO: output ax to dx
}

void _impl_xmhfhwm_cpu_insn_pause(void){

}


void _impl_xmhfhwm_cpu_insn_wrmsr(void){
	if(xmhfhwm_cpu_gprs_ecx == MSR_EFER){
                xmhfhwm_cpu_msr_efer = (uint64_t)xmhfhwm_cpu_gprs_edx << 32 |  (uint64_t)xmhfhwm_cpu_gprs_eax;
	}else if (xmhfhwm_cpu_gprs_ecx == MSR_APIC_BASE){
                xmhfhwm_cpu_msr_apic_base = (uint64_t)xmhfhwm_cpu_gprs_edx << 32 |  (uint64_t)xmhfhwm_cpu_gprs_eax;

	}else if (xmhfhwm_cpu_gprs_ecx == IA32_SYSENTER_CS_MSR){
                xmhfhwm_cpu_msr_sysenter_cs = (uint64_t)xmhfhwm_cpu_gprs_edx << 32 |  (uint64_t)xmhfhwm_cpu_gprs_eax;

	}else if (xmhfhwm_cpu_gprs_ecx == IA32_SYSENTER_EIP_MSR){
                xmhfhwm_cpu_msr_sysenter_eip = (uint64_t)xmhfhwm_cpu_gprs_edx << 32 |  (uint64_t)xmhfhwm_cpu_gprs_eax;

	}else if (xmhfhwm_cpu_gprs_ecx == IA32_SYSENTER_ESP_MSR){
                xmhfhwm_cpu_msr_sysenter_esp_hi = xmhfhwm_cpu_gprs_edx;
                xmhfhwm_cpu_msr_sysenter_esp_lo = xmhfhwm_cpu_gprs_eax;

	}
	//XXX: wrmsr logic
}

void _impl_xmhfhwm_cpu_insn_rdmsr(void){
	//TODO: rdmsr emulation
	if(xmhfhwm_cpu_gprs_ecx == MSR_APIC_BASE){
		xmhfhwm_cpu_gprs_edx = (uint32_t) ((uint64_t)xmhfhwm_cpu_msr_apic_base >> 32);
		xmhfhwm_cpu_gprs_eax = (uint32_t)xmhfhwm_cpu_msr_apic_base | 0x100;
	}else if (xmhfhwm_cpu_gprs_ecx == MSR_EFER){
		xmhfhwm_cpu_gprs_edx = (uint32_t) ((uint64_t)xmhfhwm_cpu_msr_efer >> 32);
		xmhfhwm_cpu_gprs_eax = (uint32_t)xmhfhwm_cpu_msr_efer;
	}else if (xmhfhwm_cpu_gprs_ecx == IA32_VMX_PROCBASED_CTLS2_MSR){
		xmhfhwm_cpu_gprs_edx = (uint32_t) ((uint64_t)xmhfhwm_cpu_msr_vmx_procbased_ctls2_msr >> 32);
		xmhfhwm_cpu_gprs_eax = (uint32_t)xmhfhwm_cpu_msr_vmx_procbased_ctls2_msr;

	}else if(xmhfhwm_cpu_gprs_ecx == IA32_MTRRCAP){
		xmhfhwm_cpu_gprs_edx = (uint32_t) ((uint64_t)xmhfhwm_cpu_msr_mtrrcap >> 32);
		xmhfhwm_cpu_gprs_eax = (uint32_t)xmhfhwm_cpu_msr_mtrrcap;


	}else if (xmhfhwm_cpu_gprs_ecx == IA32_SYSENTER_CS_MSR){
		xmhfhwm_cpu_gprs_edx = (uint32_t) ((uint64_t)xmhfhwm_cpu_msr_sysenter_cs >> 32);
		xmhfhwm_cpu_gprs_eax = (uint32_t)xmhfhwm_cpu_msr_sysenter_cs;

	}else if (xmhfhwm_cpu_gprs_ecx == IA32_SYSENTER_EIP_MSR){
		xmhfhwm_cpu_gprs_edx = (uint32_t) ((uint64_t)xmhfhwm_cpu_msr_sysenter_eip >> 32);
		xmhfhwm_cpu_gprs_eax = (uint32_t)xmhfhwm_cpu_msr_sysenter_eip;

	}else if (xmhfhwm_cpu_gprs_ecx == IA32_SYSENTER_ESP_MSR){
		xmhfhwm_cpu_gprs_edx = xmhfhwm_cpu_msr_sysenter_esp_hi;
		xmhfhwm_cpu_gprs_eax = xmhfhwm_cpu_msr_sysenter_esp_lo;

	}else{

	}

}

void _impl_xmhfhwm_cpu_insn_rdtsc(void){
	xmhfhwm_cpu_gprs_edx = (uint32_t) ((uint64_t)xmhfhwm_cpu_msr_rdtsc >> 32);
	xmhfhwm_cpu_gprs_eax = (uint32_t)xmhfhwm_cpu_msr_rdtsc;
	xmhfhwm_cpu_msr_rdtsc++;
}

void _impl_xmhfhwm_cpu_insn_movl_cr0_eax(void){
	xmhfhwm_cpu_gprs_eax = xmhfhwm_cpu_cr0;
}

void _impl_xmhfhwm_cpu_insn_movl_cr2_eax(void){
	xmhfhwm_cpu_gprs_eax = xmhfhwm_cpu_cr2;
}

void _impl_xmhfhwm_cpu_insn_movl_cr3_eax(void){
	xmhfhwm_cpu_gprs_eax = xmhfhwm_cpu_cr3;
}

void _impl_xmhfhwm_cpu_insn_movl_cr4_eax(void){
	xmhfhwm_cpu_gprs_eax = xmhfhwm_cpu_cr4;
}

void _impl_xmhfhwm_cpu_insn_movl_esp_eax(void){
	xmhfhwm_cpu_gprs_eax = xmhfhwm_cpu_gprs_esp;

}

void _impl_xmhfhwm_cpu_insn_movl_esp_ecx(void){
	xmhfhwm_cpu_gprs_ecx = xmhfhwm_cpu_gprs_esp;

}


void _impl_xmhfhwm_cpu_insn_pushfl(void){
	xmhfhwm_cpu_gprs_esp -= sizeof(uint32_t);
	*((uint32_t *)xmhfhwm_cpu_gprs_esp) = xmhfhwm_cpu_eflags;
}

void _impl_xmhfhwm_cpu_insn_movl_cs_eax(void){
	xmhfhwm_cpu_gprs_eax = xmhfhwm_cpu_cs_selector;
}

void _impl_xmhfhwm_cpu_insn_movl_ds_eax(void){
	xmhfhwm_cpu_gprs_eax = xmhfhwm_cpu_ds_selector;
}

void _impl_xmhfhwm_cpu_insn_movl_es_eax(void){
	xmhfhwm_cpu_gprs_eax = xmhfhwm_cpu_es_selector;
}

void _impl_xmhfhwm_cpu_insn_movl_fs_eax(void){
	xmhfhwm_cpu_gprs_eax = xmhfhwm_cpu_fs_selector;
}

void _impl_xmhfhwm_cpu_insn_movl_gs_eax(void){
	xmhfhwm_cpu_gprs_eax = xmhfhwm_cpu_gs_selector;
}

void _impl_xmhfhwm_cpu_insn_movl_ss_eax(void){
	xmhfhwm_cpu_gprs_eax = xmhfhwm_cpu_ss_selector;
}


void _impl_xmhfhwm_cpu_insn_btl_imm_mecx(uint32_t value, int index){
	uint32_t *value_mecx;
	value_mecx = (uint32_t *)((uint32_t)((int)xmhfhwm_cpu_gprs_ecx + (int)index));
	//store bit specified by value in *value_mecx into CF
        if( *value_mecx & (1UL << value))
		xmhfhwm_cpu_eflags |= EFLAGS_CF;
	else
		xmhfhwm_cpu_eflags &= ~(EFLAGS_CF);
}

void _impl_xmhfhwm_cpu_insn_btrl_imm_mecx(uint32_t value, int index){
	uint32_t *value_mecx;
	value_mecx = (uint32_t *)((uint32_t)((int)xmhfhwm_cpu_gprs_ecx + (int)index));
	//store bit specified by value in *value_mecx into CF and clear that bit
        if( *value_mecx & (1UL << value)){
		xmhfhwm_cpu_eflags |= EFLAGS_CF;
		*value_mecx = *value_mecx & ~((1UL << value));
        }else{
		xmhfhwm_cpu_eflags &= ~(EFLAGS_CF);
        }
}

void _impl_xmhfhwm_cpu_insn_btsl_imm_mecx(uint32_t value, int index){
	uint32_t *value_mecx;
	value_mecx = (uint32_t *)((uint32_t)((int)xmhfhwm_cpu_gprs_ecx + (int)index));
	//store bit specified by value in *value_mecx into CF and set that bit
        if( *value_mecx & (1UL << value)){
		xmhfhwm_cpu_eflags |= EFLAGS_CF;
        }else{
		xmhfhwm_cpu_eflags &= ~(EFLAGS_CF);
		*value_mecx = *value_mecx | ((1UL << value));
        }
}


void _impl_xmhfhwm_cpu_insn_vmxon_mesp(int index){
	uint64_t *value_mesp;
	value_mesp = (uint32_t *)((uint32_t)((int)xmhfhwm_cpu_gprs_esp + (int)index));
	//TODO: vmxon emulation
	xmhfhwm_cpu_eflags &= ~(EFLAGS_CF);
	xmhfhwm_cpu_eflags &= ~(EFLAGS_ZF);
}

void _impl_xmhfhwm_cpu_insn_vmwrite_eax_ecx(void){
        hwm_vdriver_cpu_vmwrite(xmhfhwm_cpu_gprs_ecx, xmhfhwm_cpu_gprs_eax);
	//ecx=encoding, eax=value
	if(xmhfhwm_cpu_gprs_ecx == VMCS_HOST_RIP){
                xmhfhwm_cpu_vmcs_host_rip = xmhfhwm_cpu_gprs_eax;
	}else if(xmhfhwm_cpu_gprs_ecx == VMCS_HOST_RSP){
                //@assert 1;
                xmhfhwm_cpu_vmcs_host_rsp = xmhfhwm_cpu_gprs_eax;
	}else if(xmhfhwm_cpu_gprs_ecx == VMCS_HOST_CR3){
                //@assert 1;
                xmhfhwm_cpu_vmcs_host_cr3 = xmhfhwm_cpu_gprs_eax;

	}else{

	}
}

void _impl_xmhfhwm_cpu_insn_vmread_ecx_eax(void){
	//ecx=encoding, eax=value
	if(xmhfhwm_cpu_gprs_ecx == VMCS_HOST_RIP){
                xmhfhwm_cpu_gprs_eax = xmhfhwm_cpu_vmcs_host_rip;
	}else if(xmhfhwm_cpu_gprs_ecx == VMCS_HOST_RSP){
                xmhfhwm_cpu_gprs_eax = xmhfhwm_cpu_vmcs_host_rsp;
	}else if(xmhfhwm_cpu_gprs_ecx == VMCS_HOST_CR3){
                xmhfhwm_cpu_gprs_eax = xmhfhwm_cpu_vmcs_host_cr3;

	}else{

	}

}

void _impl_xmhfhwm_cpu_insn_vmclear_mesp(int index){
	uint64_t *value_mesp;
	value_mesp = (uint32_t *)((uint32_t)((int)xmhfhwm_cpu_gprs_esp + (int)index));

}

void _impl_xmhfhwm_cpu_insn_vmptrld_mesp(int index){
	uint64_t *value_mesp;
	value_mesp = (uint32_t *)((uint32_t)((int)xmhfhwm_cpu_gprs_esp + (int)index));

}

void _impl_xmhfhwm_cpu_insn_wbinvd(void){
	//XXX: wbinvd logic
}

void _impl_xmhfhwm_cpu_insn_movl_eax_cr0(void){
	xmhfhwm_cpu_cr0 = xmhfhwm_cpu_gprs_eax;
}

void _impl_xmhfhwm_cpu_insn_movl_eax_cr3(void){
	xmhfhwm_vdriver_cpu_writecr3(xmhfhwm_cpu_cr3, xmhfhwm_cpu_gprs_eax);
	xmhfhwm_cpu_cr3 = xmhfhwm_cpu_gprs_eax;
}

void _impl_xmhfhwm_cpu_insn_movl_ebx_cr3(void){
	xmhfhwm_vdriver_cpu_writecr3(xmhfhwm_cpu_cr3, xmhfhwm_cpu_gprs_ebx);
	xmhfhwm_cpu_cr3 = xmhfhwm_cpu_gprs_ebx;
}


void _impl_xmhfhwm_cpu_insn_movl_eax_cr4(void){
	xmhfhwm_cpu_cr4 = xmhfhwm_cpu_gprs_eax;
}


void _impl_xmhfhwm_cpu_insn_popfl(void){
	uint32_t value = *((uint32_t *)xmhfhwm_cpu_gprs_esp);
	xmhfhwm_cpu_gprs_esp += sizeof(uint32_t);
	xmhfhwm_cpu_eflags = value;
}


void _impl_xmhfhwm_cpu_insn_xgetbv(void){
	if(xmhfhwm_cpu_gprs_ecx == 1){
		xmhfhwm_cpu_gprs_eax = (uint32_t)xmhfhwm_cpu_xcr0;
		xmhfhwm_cpu_gprs_edx = (uint32_t)((uint64_t)xmhfhwm_cpu_xcr0 >> 32);
	}else{
		//XXX: TODO: GPF
	}
}

void _impl_xmhfhwm_cpu_insn_xsetbv(void){
	if(xmhfhwm_cpu_gprs_ecx == 1){
		xmhfhwm_cpu_xcr0 = ((uint64_t)xmhfhwm_cpu_gprs_edx << 32) |
			xmhfhwm_cpu_gprs_eax;
	}else{
		//XXX: TODO: GPF
	}

}

void _impl_xmhfhwm_cpu_insn_pushl_edi(void){
	xmhfhwm_cpu_gprs_esp -= sizeof(uint32_t);
	*((uint32_t *)xmhfhwm_cpu_gprs_esp) = xmhfhwm_cpu_gprs_edi;
}

void _impl_xmhfhwm_cpu_insn_movl_mesp_edi(int index){
	uint32_t *value;
	value = (uint32_t *)((uint32_t)((int)xmhfhwm_cpu_gprs_esp + (int)index));
	xmhfhwm_cpu_gprs_edi = *value;
}

void _impl_xmhfhwm_cpu_insn_cld(void){
	xmhfhwm_cpu_eflags &= ~(EFLAGS_DF);
}



void _impl_xmhfhwm_cpu_insn_popl_edi(void){
	uint32_t value = *((uint32_t *)xmhfhwm_cpu_gprs_esp);
	xmhfhwm_cpu_gprs_esp += sizeof(uint32_t);
	xmhfhwm_cpu_gprs_edi = value;
}


void _impl_xmhfhwm_cpu_insn_andl_imm_eax(uint32_t value){
	xmhfhwm_cpu_gprs_eax &= value;
}




void _impl_xmhfhwm_cpu_insn_pushl_ebp(void){
	xmhfhwm_cpu_gprs_esp -= sizeof(uint32_t);
	*((uint32_t *)xmhfhwm_cpu_gprs_esp) = xmhfhwm_cpu_gprs_ebp;
}

void _impl_xmhfhwm_cpu_insn_movl_esp_edx(void){
	xmhfhwm_cpu_gprs_edx = xmhfhwm_cpu_gprs_esp;

}

void _impl_xmhfhwm_cpu_insn_pushl_eax(void){
	xmhfhwm_cpu_gprs_esp -= sizeof(uint32_t);
	*((uint32_t *)xmhfhwm_cpu_gprs_esp) = xmhfhwm_cpu_gprs_eax;
}

void _impl_xmhfhwm_cpu_insn_pushl_edx(void){
	xmhfhwm_cpu_gprs_esp -= sizeof(uint32_t);
	*((uint32_t *)xmhfhwm_cpu_gprs_esp) = xmhfhwm_cpu_gprs_edx;
}

void _impl_xmhfhwm_cpu_insn_pushl_esp(void){
	uint32_t value = xmhfhwm_cpu_gprs_esp;
	xmhfhwm_cpu_gprs_esp -= sizeof(uint32_t);
	*((uint32_t *)xmhfhwm_cpu_gprs_esp) = value;
}


void _impl_xmhfhwm_cpu_insn_pushl_imm(uint32_t value){
	xmhfhwm_cpu_gprs_esp -= sizeof(uint32_t);
	*((uint32_t *)xmhfhwm_cpu_gprs_esp) = value;
}


void _impl_xmhfhwm_cpu_insn_pushl_ecx(void){
	xmhfhwm_cpu_gprs_esp -= sizeof(uint32_t);
	*((uint32_t *)xmhfhwm_cpu_gprs_esp) = xmhfhwm_cpu_gprs_ecx;
}



void _impl_xmhfhwm_cpu_insn_popl_ebp(void){
	uint32_t value = *((uint32_t *)xmhfhwm_cpu_gprs_esp);
	xmhfhwm_cpu_gprs_esp += sizeof(uint32_t);
	xmhfhwm_cpu_gprs_ebp = value;
}





void _impl_xmhfhwm_cpu_insn_vmlaunch(void){
	xmhfhwm_vdriver_slabep();

	//xmhfhwm_cpu_eflags |= EFLAGS_CF;
}

void  _impl_xmhfhwm_cpu_insn_vmresume(void){
	xmhfhwm_vdriver_slabep();

}



void _impl_xmhfhwm_cpu_insn_pushal(void){
	uint32_t value = xmhfhwm_cpu_gprs_esp;
	_impl_xmhfhwm_cpu_insn_pushl_eax();
	_impl_xmhfhwm_cpu_insn_pushl_ecx();
	_impl_xmhfhwm_cpu_insn_pushl_edx();
	_impl_xmhfhwm_cpu_insn_pushl_ebx();
	_impl_xmhfhwm_cpu_insn_pushl_imm(value);
	_impl_xmhfhwm_cpu_insn_pushl_ebp();
	_impl_xmhfhwm_cpu_insn_pushl_esi();
	_impl_xmhfhwm_cpu_insn_pushl_edi();

}

void _impl_xmhfhwm_cpu_insn_movw_imm_ax(uint16_t value){
	xmhfhwm_cpu_gprs_eax &= 0xFFFF0000UL;
	xmhfhwm_cpu_gprs_eax |= value;
}

void  _impl_xmhfhwm_cpu_insn_movw_ax_ds(void){
	xmhfhwm_cpu_ds_selector = xmhfhwm_cpu_gprs_eax & 0x0000FFFFUL;
}

void  _impl_xmhfhwm_cpu_insn_movw_ds_ax(void){
	uint16_t val = xmhfhwm_cpu_ds_selector;
        xmhfhwm_cpu_gprs_eax &= 0xFFFF0000UL;
        xmhfhwm_cpu_gprs_eax |= val;
}


void  _impl_xmhfhwm_cpu_insn_movw_ax_es(void){
	xmhfhwm_cpu_es_selector = xmhfhwm_cpu_gprs_eax & 0x0000FFFFUL;
}

void  _impl_xmhfhwm_cpu_insn_movw_ax_fs(void){
	xmhfhwm_cpu_fs_selector = xmhfhwm_cpu_gprs_eax & 0x0000FFFFUL;
}

void  _impl_xmhfhwm_cpu_insn_movw_ax_gs(void){
	xmhfhwm_cpu_gs_selector = xmhfhwm_cpu_gprs_eax & 0x0000FFFFUL;
}

void  _impl_xmhfhwm_cpu_insn_movw_ax_ss(void){
	xmhfhwm_cpu_ss_selector = xmhfhwm_cpu_gprs_eax & 0x0000FFFFUL;
}


void _impl_xmhfhwm_cpu_insn_iretl(void){
	//XXX: TODO IRETL logic
	xmhfhwm_vdriver_slabep();
}


void _impl_xmhfhwm_cpu_insn_mull_ecx(void){
        xmhfhwm_cpu_gprs_eax = xmhfhwm_cpu_gprs_eax * xmhfhwm_cpu_gprs_ecx;
}

void _impl_xmhfhwm_cpu_insn_addl_ecx_eax(void){
	xmhfhwm_cpu_gprs_eax += xmhfhwm_cpu_gprs_ecx;
}





//////////////////////////////////////////////////////////////////////////////
//
// System memory/MMIO interfaces
//
//////////////////////////////////////////////////////////////////////////////


physmem_extent_t xmhfhwm_sysmemaccess_physmem_extents[32];
uint32_t xmhfhwm_sysmemaccess_physmem_extents_total=0;

static bool xmhfhwm_sysmemaccess_checkextents(uint32_t addr_start, uint32_t size){
	uint32_t index;
	bool within_extents=false;
	for(index=0; index < xmhfhwm_sysmemaccess_physmem_extents_total; index++){
		if(addr_start >= xmhfhwm_sysmemaccess_physmem_extents[index].addr_start
		&& (addr_start + size) <= xmhfhwm_sysmemaccess_physmem_extents[index].addr_end){
			within_extents = true;
			break;
		}
	}

	//@assert within_extents;
	return within_extents;
}

static unsigned char *rep_movsb_memcpy(unsigned char *dst, const unsigned char *src, size_t n)
{
	const unsigned char *p = src;
	unsigned char *q = dst;

	while (n) {
		*q++ = *p++;
		n--;
	}

	return dst;
}

void _impl_xmhfhwm_cpu_insn_rep_movsb(void){
	if(xmhfhwm_cpu_eflags & EFLAGS_DF){
		//reverse, TODO

	}else{
		//increment
		if(xmhfhwm_sysmemaccess_checkextents(xmhfhwm_cpu_gprs_edi,
						xmhfhwm_cpu_gprs_ecx)){
			//copy to sysmem is havoc
		}else{
			rep_movsb_memcpy(xmhfhwm_cpu_gprs_edi, xmhfhwm_cpu_gprs_esi,
				xmhfhwm_cpu_gprs_ecx);
		}
                xmhfhwm_cpu_gprs_edi += xmhfhwm_cpu_gprs_ecx;
                xmhfhwm_cpu_gprs_esi += xmhfhwm_cpu_gprs_ecx;
	}
}



static uint64_t _impl_xmhfhwm_cpu_sysmemread(uint32_t sysmemaddr, sysmem_read_t readsize){
	bool hwmdevstatus=false;
	uint64_t read_result=0;

	hwmdevstatus = _impl_xmhfhwm_e1000_read(sysmemaddr, readsize, &read_result);
        if(hwmdevstatus)
		return read_result;

	hwmdevstatus = _impl_xmhfhwm_txt_read(sysmemaddr, readsize, &read_result);
        if(hwmdevstatus)
		return read_result;

	hwmdevstatus = _impl_xmhfhwm_bios_read(sysmemaddr, readsize, &read_result);
        if(hwmdevstatus)
		return read_result;

	hwmdevstatus = _impl_xmhfhwm_mem_read(sysmemaddr, readsize, &read_result);
        if(hwmdevstatus)
		return read_result;

	hwmdevstatus = _impl_xmhfhwm_vtd_read(sysmemaddr, readsize, &read_result);
        if(hwmdevstatus)
		return read_result;

	hwmdevstatus = _impl_xmhfhwm_lapic_read(sysmemaddr, readsize, &read_result);
        if(hwmdevstatus)
		return read_result;

	//@assert 0;
	return read_result;
}


static void _impl_xmhfhwm_cpu_sysmemwrite(uint32_t sysmemaddr, sysmem_write_t writesize, uint64_t write_value){
	bool hwmdevstatus=false;

	hwmdevstatus = _impl_xmhfhwm_e1000_write(sysmemaddr, writesize, write_value);
        if(hwmdevstatus)
		return;

	hwmdevstatus = _impl_xmhfhwm_txt_write(sysmemaddr, writesize, write_value);
        if(hwmdevstatus)
		return;

	hwmdevstatus = _impl_xmhfhwm_bios_write(sysmemaddr, writesize, write_value);
        if(hwmdevstatus)
		return;

	hwmdevstatus = _impl_xmhfhwm_vtd_write(sysmemaddr, writesize, write_value);
        if(hwmdevstatus)
		return;

	hwmdevstatus = _impl_xmhfhwm_lapic_write(sysmemaddr, writesize, write_value);
        if(hwmdevstatus)
		return;

	hwmdevstatus = _impl_xmhfhwm_mem_write(sysmemaddr, writesize, write_value);
		if(hwmdevstatus)
		return;

	//@assert 0;
	return;
}

static void _impl_xmhfhwm_cpu_sysmemcopy(sysmem_copy_t sysmemcopy_type,
		uint32_t dstaddr, uint32_t srcaddr, uint32_t size){
	bool hwmdevstatus=false;

	hwmdevstatus = _impl_xmhfhwm_txt_sysmemcopy(sysmemcopy_type,
			dstaddr, srcaddr, size);
        if(hwmdevstatus)
		return;

	hwmdevstatus = _impl_xmhfhwm_bios_sysmemcopy(sysmemcopy_type,
			dstaddr, srcaddr, size);
        if(hwmdevstatus)
		return;


	hwmdevstatus = _impl_xmhfhwm_mem_sysmemcopy(sysmemcopy_type,
			dstaddr, srcaddr, size);
        if(hwmdevstatus)
		return;


	//@assert 0;
	return;
}


/*
// TODO: parts of the following eventually
// needs to move to the appropriate hardware
// model backend
uint8_t _impl_xmhfhwm_lapic_mmiospace[PAGE_SIZE_4K];

static uint32_t _impl_xmhfhwm_gethwmaddrforsysmem(uint32_t sysmemaddr){
	if(sysmemaddr >= MMIO_APIC_BASE && sysmemaddr <
		(MMIO_APIC_BASE+ PAGE_SIZE_4K)){
		return (uint32_t)&_impl_xmhfhwm_lapic_mmiospace;
	}else
		return 0;
}*/


void _impl_xmhfhwm_cpu_insn_rep_movsb_sysmem(sysmem_copy_t sysmemcopy_type){
	if(xmhfhwm_cpu_eflags & EFLAGS_DF){
		//reverse, TODO
		//@assert 0;
	}else{
		//increment
		_impl_xmhfhwm_cpu_sysmemcopy(sysmemcopy_type,
					xmhfhwm_cpu_gprs_edi,
					xmhfhwm_cpu_gprs_esi,
					xmhfhwm_cpu_gprs_ecx);

                xmhfhwm_cpu_gprs_edi += xmhfhwm_cpu_gprs_ecx;
                xmhfhwm_cpu_gprs_esi += xmhfhwm_cpu_gprs_ecx;
	}
}


void _impl_xmhfhwm_cpu_insn_movl_mesi_eax(int index){
	//uint32_t *value_mesi;
	//value_mesi = (uint32_t *)_impl_xmhfhwm_gethwmaddrforsysmem(((uint32_t)((int)xmhfhwm_cpu_gprs_esi + (int)index)));
	uint32_t sysmemaddr = ((uint32_t)((int)xmhfhwm_cpu_gprs_esi + (int)index));
	//xmhfhwm_cpu_gprs_eax = *value_mesi;
	xmhfhwm_cpu_gprs_eax = _impl_xmhfhwm_cpu_sysmemread(sysmemaddr, SYSMEMREADU32);
}

void _impl_xmhfhwm_cpu_insn_movl_mesi_edx(uint32_t index){
	//uint32_t *value_mesi;
	//value_mesi = (uint32_t *)((uint32_t)((int)xmhfhwm_cpu_gprs_esi + (int)index));
	uint32_t sysmemaddr = (uint32_t)(xmhfhwm_cpu_gprs_esi + index);
	//xmhfhwm_cpu_gprs_edx = *value_mesi;
	xmhfhwm_cpu_gprs_edx = _impl_xmhfhwm_cpu_sysmemread(sysmemaddr, SYSMEMREADU32);
}

void _impl_xmhfhwm_cpu_insn_movl_eax_mesi(int index){
	//uint32_t *value;
	//value = (uint32_t *)((uint32_t)((int)xmhfhwm_cpu_gprs_esi + (int)index));
	uint32_t sysmemaddr = ((uint32_t)((int)xmhfhwm_cpu_gprs_esi + (int)index));
	// *value = xmhfhwm_cpu_gprs_eax;
	_impl_xmhfhwm_cpu_sysmemwrite(sysmemaddr, SYSMEMWRITEU32, xmhfhwm_cpu_gprs_eax);
}

void _impl_xmhfhwm_cpu_insn_movl_edx_mesi(int index){
	//uint32_t *value;
	//value = (uint32_t *)((uint32_t)((int)xmhfhwm_cpu_gprs_esi + (int)index));
	uint32_t sysmemaddr = ((uint32_t)((int)xmhfhwm_cpu_gprs_esi + (int)index));
	// *value = xmhfhwm_cpu_gprs_edx;
	_impl_xmhfhwm_cpu_sysmemwrite(sysmemaddr, SYSMEMWRITEU32, xmhfhwm_cpu_gprs_edx);
}

void _impl_xmhfhwm_cpu_insn_movb_al_mesi(int index){
	//uint32_t *value_mesi;
	//value_mesi = (uint32_t *)((uint32_t)((int)xmhfhwm_cpu_gprs_esi + (int)index));
	uint32_t sysmemaddr = ((uint32_t)((int)xmhfhwm_cpu_gprs_esi + (int)index));
	// *value_mesi |= (xmhfhwm_cpu_gprs_eax & 0x000000FFUL);
	_impl_xmhfhwm_cpu_sysmemwrite(sysmemaddr, SYSMEMWRITEU8, (xmhfhwm_cpu_gprs_eax & 0x000000FFUL));
}

void _impl_xmhfhwm_cpu_insn_movw_ax_mesi(int index){
	//uint32_t *value_mesi;
	//value_mesi = (uint32_t *)((uint32_t)((int)xmhfhwm_cpu_gprs_esi + (int)index));
	uint32_t sysmemaddr = ((uint32_t)((int)xmhfhwm_cpu_gprs_esi + (int)index));
	// *value_mesi |= (xmhfhwm_cpu_gprs_eax & 0x0000FFFFUL);
	_impl_xmhfhwm_cpu_sysmemwrite(sysmemaddr, SYSMEMWRITEU16, (xmhfhwm_cpu_gprs_eax & 0x0000FFFFUL));
}
