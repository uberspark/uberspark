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


#include <uberspark/include/uberspark.h>

uint32_t hwm_cpu_gprs_eip = 0;
uint32_t hwm_cpu_gprs_esp = 0;
uint32_t hwm_cpu_gprs_ebp = 0;

uint32_t hwm_cpu_gprs_eax = 0;
uint32_t hwm_cpu_gprs_ebx = 0;
uint32_t hwm_cpu_gprs_edx = 0;
uint32_t hwm_cpu_gprs_ecx = 0;
uint32_t hwm_cpu_gprs_esi = 0;
uint32_t hwm_cpu_gprs_edi = 0;

uint32_t hwm_cpu_eflags = 0;

uint16_t hwm_cpu_gdtr_limit=0;
uint32_t hwm_cpu_gdtr_base=0;
uint16_t hwm_cpu_idtr_limit=0;
uint32_t hwm_cpu_idtr_base=0;

uint16_t hwm_cpu_tr_selector=0;

uint32_t hwm_cpu_cr0 = 0;
uint32_t hwm_cpu_cr2 = 0;
uint32_t hwm_cpu_cr3 = 0;
uint32_t hwm_cpu_cr4 = 0;

uint32_t hwm_cpu_cs_selector = 0;
uint32_t hwm_cpu_ds_selector = 0;
uint32_t hwm_cpu_es_selector = 0;
uint32_t hwm_cpu_fs_selector = 0;
uint32_t hwm_cpu_gs_selector = 0;
uint32_t hwm_cpu_ss_selector = 0;

uint64_t hwm_cpu_xcr0 = 0;
hwm_cpu_state_t hwm_cpu_state = CPU_STATE_RUNNING;

uint64_t hwm_cpu_msr_efer = 0;
uint64_t hwm_cpu_msr_vmx_procbased_ctls2_msr = 0x0000008200000000ULL;
uint64_t hwm_cpu_msr_mtrrcap = 0x0000000000000d0aULL;
uint64_t hwm_cpu_msr_apic_base =  MMIO_APIC_BASE;
uint64_t hwm_cpu_msr_sysenter_cs = 0;
uint64_t hwm_cpu_msr_sysenter_eip = 0;
uint32_t hwm_cpu_msr_sysenter_esp_hi = 0;
uint32_t hwm_cpu_msr_sysenter_esp_lo = 0;
uint64_t hwm_cpu_msr_rdtsc = 0;

uint32_t hwm_cpu_vmcs_host_rip = 0;
uint32_t hwm_cpu_vmcs_host_rsp = 0;
uint32_t hwm_cpu_vmcs_host_cr3 = 0;

uint32_t hwm_pci_config_addr_port = 0x0UL;



//////
// move to ESP related instructions
//////

void _impl__casm__addl_imm_esp(uint32_t value){
	hwm_vdriver_writeesp(hwm_cpu_gprs_esp, (hwm_cpu_gprs_esp+value));
	hwm_cpu_gprs_esp += value;
}

void _impl__casm__movl_meax_esp(int index){
	uint32_t value_meax;
	value_meax = *((uint32_t *)((uint32_t)((int32_t)hwm_cpu_gprs_eax + (int32_t)index)));
	hwm_vdriver_writeesp(hwm_cpu_gprs_esp, value_meax);
	hwm_cpu_gprs_esp = value_meax;
}

void _impl__casm__subl_imm_esp(uint32_t value){
	hwm_vdriver_writeesp(hwm_cpu_gprs_esp, (hwm_cpu_gprs_esp-value));
	hwm_cpu_gprs_esp -= value;
}

void _impl__casm__movl_edx_esp(void){
	hwm_vdriver_writeesp(hwm_cpu_gprs_esp, hwm_cpu_gprs_edx);
	hwm_cpu_gprs_esp = hwm_cpu_gprs_edx;
}

void _impl__casm__movl_eax_esp(void){
	hwm_vdriver_writeesp(hwm_cpu_gprs_esp, hwm_cpu_gprs_eax);
	hwm_cpu_gprs_esp = hwm_cpu_gprs_eax;
}






void _impl__casm__hlt(void){
	// //@assert 0;
	// while(1);
	hwm_cpu_state = CPU_STATE_HALT;
}



void _impl__casm__pushl_mesp(int index){
	uint32_t value;
	value = *((uint32_t *)(hwm_cpu_gprs_esp + index));
	hwm_cpu_gprs_esp -= sizeof(uint32_t);
	*((uint32_t *)hwm_cpu_gprs_esp) = value;
}

void _impl__casm__pushl_mem(uint32_t value){
	hwm_cpu_gprs_esp -= sizeof(uint32_t);
	*((uint32_t *)hwm_cpu_gprs_esp) = value;
}


uint32_t _impl__casm__popl_mem(void){
	uint32_t value = *((uint32_t *)hwm_cpu_gprs_esp);
	hwm_cpu_gprs_esp += sizeof(uint32_t);
	return value;
}



void _impl__casm__movl_mesp_eax(uint32_t index){
	uint32_t *value;
	value = (uint32_t *)((uint32_t)((uint32_t)hwm_cpu_gprs_esp + (uint32_t)index));
	hwm_cpu_gprs_eax = *value;
}

void _impl__casm__movl_mesp_ebx(int index){
	uint32_t *value;
	value = (uint32_t *)((uint32_t)((int)hwm_cpu_gprs_esp + (int)index));
	hwm_cpu_gprs_ebx = *value;
}

void _impl__casm__movl_mesp_ecx(int index){
	uint32_t *value;
	value = (uint32_t *)((uint32_t)((int)hwm_cpu_gprs_esp + (int)index));
	hwm_cpu_gprs_ecx = *value;
}

void _impl__casm__movl_mesp_edx(int index){
	uint32_t *value;
	value = (uint32_t *)((uint32_t)((int)hwm_cpu_gprs_esp + (int)index));
	hwm_cpu_gprs_edx = *value;
}

void _impl__casm__movl_eax_ebx(void){
	hwm_cpu_gprs_ebx = hwm_cpu_gprs_eax;
}

void _impl__casm__movl_eax_edi(void){
	hwm_cpu_gprs_edi = hwm_cpu_gprs_eax;
}


void _impl__casm__cmpl_imm_meax(uint32_t value, int index){
	uint32_t value_meax;
	value_meax = *((uint32_t *)((uint32_t)((int32_t)hwm_cpu_gprs_eax + (int32_t)index)));

	//XXX: TODO propagation of CF, PF, AF, SF and OF
        if(value_meax - value == 0)
		hwm_cpu_eflags |= EFLAGS_ZF;

}


void _impl__casm__movl_imm_meax(uint32_t value, int index){
	uint32_t *value_meax;
	value_meax = (uint32_t *)((uint32_t)((int32_t)hwm_cpu_gprs_eax + (int32_t)index));
	*value_meax = value;
}

void _impl__casm__movl_meax_edx(int index){
	uint32_t value_meax;
	value_meax = *((uint32_t *)((uint32_t)((int32_t)hwm_cpu_gprs_eax + (int32_t)index)));
	hwm_cpu_gprs_edx = value_meax;
}

void _impl__casm__movl_meax_edi(int index){
	uint32_t value_meax;
	value_meax = *((uint32_t *)((uint32_t)((int32_t)hwm_cpu_gprs_eax + (int32_t)index)));
	hwm_cpu_gprs_edi = value_meax;
}

void _impl__casm__movl_meax_esi(int index){
	uint32_t value_meax;
	value_meax = *((uint32_t *)((uint32_t)((int32_t)hwm_cpu_gprs_eax + (int32_t)index)));
	hwm_cpu_gprs_esi = value_meax;
}


void _impl__casm__movl_meax_ebp(int index){
	uint32_t value_meax;
	value_meax = *((uint32_t *)((uint32_t)((int32_t)hwm_cpu_gprs_eax + (int32_t)index)));
	hwm_cpu_gprs_ebp = value_meax;
}


void _impl__casm__movl_meax_ebx(int index){
	uint32_t value_meax;
	value_meax = *((uint32_t *)((uint32_t)((int32_t)hwm_cpu_gprs_eax + (int32_t)index)));
	hwm_cpu_gprs_ebx = value_meax;
}

void _impl__casm__movl_meax_eax(int index){
	uint32_t value_meax;
	value_meax = *((uint32_t *)((uint32_t)((int32_t)hwm_cpu_gprs_eax + (int32_t)index)));
	hwm_cpu_gprs_eax = value_meax;
}



void _impl__casm__movl_meax_ecx(int index){
	uint32_t value_meax;
	value_meax = *((uint32_t *)((uint32_t)((int32_t)hwm_cpu_gprs_eax + (int32_t)index)));
	hwm_cpu_gprs_ecx = value_meax;
}

void _impl__casm__movl_ecx_meax(int index){
	uint32_t *value_meax;
	value_meax = (uint32_t *)((uint32_t)((int32_t)hwm_cpu_gprs_eax + (int32_t)index));
	*value_meax = hwm_cpu_gprs_ecx;
}


void _impl__casm__movl_edx_meax(int index){
	uint32_t *value_meax;
	value_meax = (uint32_t *)((uint32_t)((int32_t)hwm_cpu_gprs_eax + (int32_t)index));
	*value_meax = hwm_cpu_gprs_edx;
}

void _impl__casm__bsrl_mesp_eax(int index){
	uint32_t value = *((uint32_t *)((uint32_t)((int32_t)hwm_cpu_gprs_esp + (int32_t)index)));
	uint32_t i;
	for(i=31; i >=0; i--){
		if(value & (1UL << i)){
			hwm_cpu_gprs_eax = i;
			return;
		}
	}
}

void _impl__casm__pushl_esi(void){
	hwm_cpu_gprs_esp -= sizeof(uint32_t);
	*((uint32_t *)hwm_cpu_gprs_esp) = hwm_cpu_gprs_esi;
}

void _impl__casm__pushl_ebx(void){
	hwm_cpu_gprs_esp -= sizeof(uint32_t);
	*((uint32_t *)hwm_cpu_gprs_esp) = hwm_cpu_gprs_ebx;
}


void _impl__casm__movl_mebx_ebx(int index){
	uint32_t value_mebx;
	value_mebx = *((uint32_t *)((uint32_t)((int32_t)hwm_cpu_gprs_ebx + (int32_t)index)));
	hwm_cpu_gprs_ebx = value_mebx;
}

void _impl__casm__movl_mecx_ecx(int index){
	uint32_t value_mecx;
	value_mecx = *((uint32_t *)((uint32_t)((int32_t)hwm_cpu_gprs_ecx + (int32_t)index)));
	hwm_cpu_gprs_ecx = value_mecx;
}

void _impl__casm__movl_medx_edx(int index){
	uint32_t value_medx;
	value_medx = *((uint32_t *)((uint32_t)((int32_t)hwm_cpu_gprs_edx + (int32_t)index)));
	hwm_cpu_gprs_edx = value_medx;
}


void _impl__casm__cpuid(void){

	if(hwm_cpu_gprs_eax == 0x0){
		hwm_cpu_gprs_ebx = INTEL_STRING_DWORD1;
		hwm_cpu_gprs_ecx = INTEL_STRING_DWORD3;
		hwm_cpu_gprs_edx = INTEL_STRING_DWORD2;
	}else if (hwm_cpu_gprs_eax == 0x1){
		hwm_cpu_gprs_ecx = (1 << 5); //VMX support
		hwm_cpu_gprs_ecx |= (1UL << 26); //XSAVE support
		hwm_cpu_gprs_edx = ((uint32_t)(1 << 12)); //MTRR support
	}else{
		//XXX: TODO
		hwm_cpu_gprs_ebx = 0;
		hwm_cpu_gprs_edx = 0;
	}

}

void _impl__casm__movl_mesp_esi(int index){
	uint32_t *value;
	value = (uint32_t *)((uint32_t)((int)hwm_cpu_gprs_esp + (int)index));
	hwm_cpu_gprs_esi = *value;
}


void _impl__casm__movl_ebx_mesi(int index){
	uint32_t *value;
	value = (uint32_t *)((uint32_t)((int)hwm_cpu_gprs_esi + (int)index));
	*value = hwm_cpu_gprs_ebx;
}

void _impl__casm__movl_ecx_mesi(int index){
	uint32_t *value;
	value = (uint32_t *)((uint32_t)((int)hwm_cpu_gprs_esi + (int)index));
	*value = hwm_cpu_gprs_ecx;
}


void _impl__casm__popl_eax(void){
	uint32_t value = *((uint32_t *)hwm_cpu_gprs_esp);
	hwm_cpu_gprs_esp += sizeof(uint32_t);
	hwm_cpu_gprs_eax = value;
}

void _impl__casm__popl_esi(void){
	uint32_t value = *((uint32_t *)hwm_cpu_gprs_esp);
	hwm_cpu_gprs_esp += sizeof(uint32_t);
	hwm_cpu_gprs_esi = value;
}

void _impl__casm__popl_ebx(void){
	uint32_t value = *((uint32_t *)hwm_cpu_gprs_esp);
	hwm_cpu_gprs_esp += sizeof(uint32_t);
	hwm_cpu_gprs_ebx = value;
}

void _impl__casm__popl_edx(void){
	uint32_t value = *((uint32_t *)hwm_cpu_gprs_esp);
	hwm_cpu_gprs_esp += sizeof(uint32_t);
	hwm_cpu_gprs_edx = value;
}


void _impl__casm__cli(void){
	hwm_cpu_eflags &= ~(EFLAGS_IF);
}

void _impl__casm__sti(void){
	hwm_cpu_eflags |= (EFLAGS_IF);
}


void _impl__casm__sgdt_mesp(int index){
	uint32_t *tmem_gdtbase;
	uint16_t *tmem_gdtlimit;
	tmem_gdtlimit = (uint16_t *)((uint32_t)((int)hwm_cpu_gprs_esp + (int)index));
	tmem_gdtbase = (uint32_t *)((uint32_t)((int)hwm_cpu_gprs_esp + (int)index) + sizeof(uint16_t));
	*tmem_gdtlimit = hwm_cpu_gdtr_limit;
	*tmem_gdtbase = hwm_cpu_gdtr_base;
}

void _impl__casm__xorl_eax_eax(void){
	hwm_cpu_gprs_eax = 0;
}

void _impl__casm__xorl_edx_edx(void){
	hwm_cpu_gprs_edx = 0;
}

void _impl__casm__sidt_mesp(int index){
	uint32_t *tmem_idtbase;
	uint16_t *tmem_idtlimit;
	tmem_idtlimit = (uint16_t *)((uint32_t)((int)hwm_cpu_gprs_esp + (int)index));
	tmem_idtbase = (uint32_t *)((uint32_t)((int)hwm_cpu_gprs_esp + (int)index) + sizeof(uint32_t));
	*tmem_idtlimit = hwm_cpu_idtr_limit;
	*tmem_idtbase = hwm_cpu_idtr_base;
}

void _impl__casm__getsec(void){
	//XXX:TODO
	if(hwm_cpu_gprs_ebx == 0)
		hwm_cpu_gprs_eax = 0;

}

void _impl__casm__str_ax(void){
	hwm_cpu_gprs_eax &= 0xFFFF0000UL;
	hwm_cpu_gprs_eax |= (uint16_t)hwm_cpu_tr_selector;
}

void _impl__casm__addl_eax_ecx(void){
	hwm_cpu_gprs_ecx += hwm_cpu_gprs_eax;
}

void _impl__casm__addl_eax_esp(void){
	hwm_cpu_gprs_esp += hwm_cpu_gprs_eax;
}

void _impl__casm__movl_mecx_eax(int index){
	uint32_t *value_mecx;
	value_mecx = (uint32_t *)((uint32_t)((int)hwm_cpu_gprs_ecx + (int)index));
	hwm_cpu_gprs_eax = *value_mecx;
}

void _impl__casm__movl_mecx_edx(int index){
	uint32_t *value_mecx;
	value_mecx = (uint32_t *)((uint32_t)((int)hwm_cpu_gprs_ecx + (int)index));
	hwm_cpu_gprs_edx = *value_mecx;
}


void _impl__casm__addl_imm_ecx(uint32_t value){
	hwm_cpu_gprs_ecx += value;
}

void _impl__casm__addl_imm_eax(uint32_t value){
	hwm_cpu_gprs_eax += value;
}



void _impl__casm__movl_edx_ecx(void){
	hwm_cpu_gprs_ecx = hwm_cpu_gprs_edx;
}

void _impl__casm__movl_eax_ecx(void){
	hwm_cpu_gprs_ecx = hwm_cpu_gprs_eax;
}

void _impl__casm__andl_imm_edx(uint32_t value){
	hwm_cpu_gprs_edx &= value;
}

void _impl__casm__andl_imm_ecx(uint32_t value){
	hwm_cpu_gprs_ecx &= value;
}

void _impl__casm__shl_imm_ecx(uint32_t value){
	hwm_cpu_gprs_ecx = hwm_cpu_gprs_ecx << value;
}

void _impl__casm__orl_imm_eax(uint32_t value){
	hwm_cpu_gprs_eax |= value;
}

void _impl__casm__shr_imm_eax(uint32_t value){
	hwm_cpu_gprs_eax = hwm_cpu_gprs_eax >> value;
}

void _impl__casm__orl_ecx_eax(void){
	hwm_cpu_gprs_eax = hwm_cpu_gprs_eax | hwm_cpu_gprs_ecx;
}

void _impl__casm__orl_edx_eax(void){
	hwm_cpu_gprs_eax = hwm_cpu_gprs_eax | hwm_cpu_gprs_edx;
}

void _impl__casm__inb_dx_al(void){
	hwm_cpu_gprs_eax &= 0xFFFFFF00UL;
        //XXX:TODO nondetu8 in lower 8 bits
}

void _impl__casm__inl_dx_eax(void){
	uint16_t port = (uint16_t)hwm_cpu_gprs_edx;
        if(port == PCI_CONFIG_ADDR_PORT){
		hwm_cpu_gprs_eax = hwm_pci_config_addr_port;
        }else{
		hwm_cpu_gprs_eax = 0UL;
		//XXX:TODO nondetu32
        }
}

void _impl__casm__movl_eax_mesp(int index){
	uint32_t *value_mesp;
	value_mesp = (uint32_t *)((uint32_t)((int)hwm_cpu_gprs_esp + (int)index));
	*value_mesp = hwm_cpu_gprs_eax;
}

void _impl__casm__movl_imm_mesp(uint32_t value, int index){
	uint32_t *value_mesp;
	value_mesp = (uint32_t *)((uint32_t)((int)hwm_cpu_gprs_esp + (int)index));
	*value_mesp = value;
}

void _impl__casm__invept_mesp_edx(int index){
	uint32_t *value_mesp;
	value_mesp = (uint32_t *)((uint32_t)((int)hwm_cpu_gprs_esp + (int)index));
        //XXX: TODO invept logic
}

void _impl__casm__invvpid_mesp_edx(int index){
	uint32_t *value_mesp;
	value_mesp = (uint32_t *)((uint32_t)((int)hwm_cpu_gprs_esp + (int)index));
        //XXX: TODO invvpid logic
}


void _impl__casm__movw_mesp_ax(int index){
	uint16_t *value_mesp;
	value_mesp = (uint16_t *)((uint32_t)((int)hwm_cpu_gprs_esp + (int)index));
	hwm_cpu_gprs_eax &= 0xFFFF0000UL;
	hwm_cpu_gprs_eax |= (uint16_t)*value_mesp;
}

void _impl__casm__invvpid_mesp_ecx(int index){
	uint32_t *value_mesp;
	value_mesp = (uint32_t *)((uint32_t)((int)hwm_cpu_gprs_esp + (int)index));
        //XXX: TODO invvpid logic
	hwm_cpu_eflags &= ~(EFLAGS_CF);
	hwm_cpu_eflags &= ~(EFLAGS_ZF);

}

void _impl__casm__movl_imm_eax(uint32_t value){
	hwm_cpu_gprs_eax = value;
}

void _impl__casm__movl_imm_esp(uint32_t value){
	hwm_cpu_gprs_esp = value;
}

void _impl__casm__movl_imm_esi(uint32_t value){
	hwm_cpu_gprs_esi = value;
}

void _impl__casm__movl_imm_edi(uint32_t value){
	hwm_cpu_gprs_edi = value;
}

void _impl__casm__movl_imm_ecx(uint32_t value){
	hwm_cpu_gprs_ecx = value;
}

void _impl__casm__movl_imm_edx(uint32_t value){
	hwm_cpu_gprs_edx = value;
}

void _impl__casm__movl_imm_ebx(uint32_t value){
	hwm_cpu_gprs_ebx = value;
}


void _impl__casm__inw_dx_ax(void){
	hwm_cpu_gprs_eax &= 0xFFFF0000UL;
	//TODO: nondetu16
}

void _impl__casm__lgdt_mecx(int index){
	uint16_t *gdtlimit;
	uint32_t *gdtbase;
	gdtlimit = (uint16_t *)((uint32_t)((int)hwm_cpu_gprs_ecx + (int)index));
	gdtbase = (uint32_t *)((uint32_t)((int)hwm_cpu_gprs_ecx + (int)index + sizeof(uint16_t)));
        hwm_cpu_gdtr_base = *gdtbase;
        hwm_cpu_gdtr_limit = *gdtlimit;
}

void _impl__casm__lidt_mecx(int index){
	uint16_t *idtlimit;
	uint32_t *idtbase;
	idtlimit = (uint16_t *)((uint32_t)((int)hwm_cpu_gprs_ecx + (int)index));
	idtbase = (uint32_t *)((uint32_t)((int)hwm_cpu_gprs_ecx + (int)index + sizeof(uint16_t)));
        hwm_cpu_idtr_base = *idtbase;
        hwm_cpu_idtr_limit = *idtlimit;
}

void _impl__casm__ltr_ax(void){
	hwm_cpu_tr_selector = (uint16_t)(hwm_cpu_gprs_eax & 0x0000FFFFUL);
}

void _impl__casm__outb_al_dx(void){
	//TODO: output al to dx
}

void _impl__casm__outl_eax_dx(void){
	uint16_t port = (uint16_t)hwm_cpu_gprs_edx;

	if(port == PCI_CONFIG_ADDR_PORT){
                hwm_pci_config_addr_port = hwm_cpu_gprs_eax;
	}else{
		//TODO: output eax to dx
	}
}

void _impl__casm__outw_ax_dx(void){
	//TODO: output ax to dx
}

void _impl__casm__pause(void){

}


void _impl__casm__wrmsr(void){
	if(hwm_cpu_gprs_ecx == MSR_EFER){
                hwm_cpu_msr_efer = (uint64_t)hwm_cpu_gprs_edx << 32 |  (uint64_t)hwm_cpu_gprs_eax;
	}else if (hwm_cpu_gprs_ecx == MSR_APIC_BASE){
                hwm_cpu_msr_apic_base = (uint64_t)hwm_cpu_gprs_edx << 32 |  (uint64_t)hwm_cpu_gprs_eax;

	}else if (hwm_cpu_gprs_ecx == IA32_SYSENTER_CS_MSR){
                hwm_cpu_msr_sysenter_cs = (uint64_t)hwm_cpu_gprs_edx << 32 |  (uint64_t)hwm_cpu_gprs_eax;

	}else if (hwm_cpu_gprs_ecx == IA32_SYSENTER_EIP_MSR){
                hwm_cpu_msr_sysenter_eip = (uint64_t)hwm_cpu_gprs_edx << 32 |  (uint64_t)hwm_cpu_gprs_eax;

	}else if (hwm_cpu_gprs_ecx == IA32_SYSENTER_ESP_MSR){
                hwm_cpu_msr_sysenter_esp_hi = hwm_cpu_gprs_edx;
                hwm_cpu_msr_sysenter_esp_lo = hwm_cpu_gprs_eax;

	}
	//XXX: wrmsr logic
}

void _impl__casm__rdmsr(void){
	//TODO: rdmsr emulation
	if(hwm_cpu_gprs_ecx == MSR_APIC_BASE){
		hwm_cpu_gprs_edx = (uint32_t) ((uint64_t)hwm_cpu_msr_apic_base >> 32);
		hwm_cpu_gprs_eax = (uint32_t)hwm_cpu_msr_apic_base | 0x100;
	}else if (hwm_cpu_gprs_ecx == MSR_EFER){
		hwm_cpu_gprs_edx = (uint32_t) ((uint64_t)hwm_cpu_msr_efer >> 32);
		hwm_cpu_gprs_eax = (uint32_t)hwm_cpu_msr_efer;
	}else if (hwm_cpu_gprs_ecx == IA32_VMX_PROCBASED_CTLS2_MSR){
		hwm_cpu_gprs_edx = (uint32_t) ((uint64_t)hwm_cpu_msr_vmx_procbased_ctls2_msr >> 32);
		hwm_cpu_gprs_eax = (uint32_t)hwm_cpu_msr_vmx_procbased_ctls2_msr;

	}else if(hwm_cpu_gprs_ecx == IA32_MTRRCAP){
		hwm_cpu_gprs_edx = (uint32_t) ((uint64_t)hwm_cpu_msr_mtrrcap >> 32);
		hwm_cpu_gprs_eax = (uint32_t)hwm_cpu_msr_mtrrcap;


	}else if (hwm_cpu_gprs_ecx == IA32_SYSENTER_CS_MSR){
		hwm_cpu_gprs_edx = (uint32_t) ((uint64_t)hwm_cpu_msr_sysenter_cs >> 32);
		hwm_cpu_gprs_eax = (uint32_t)hwm_cpu_msr_sysenter_cs;

	}else if (hwm_cpu_gprs_ecx == IA32_SYSENTER_EIP_MSR){
		hwm_cpu_gprs_edx = (uint32_t) ((uint64_t)hwm_cpu_msr_sysenter_eip >> 32);
		hwm_cpu_gprs_eax = (uint32_t)hwm_cpu_msr_sysenter_eip;

	}else if (hwm_cpu_gprs_ecx == IA32_SYSENTER_ESP_MSR){
		hwm_cpu_gprs_edx = hwm_cpu_msr_sysenter_esp_hi;
		hwm_cpu_gprs_eax = hwm_cpu_msr_sysenter_esp_lo;

	}else{

	}

}

void _impl__casm__rdtsc(void){
	hwm_cpu_gprs_edx = (uint32_t) ((uint64_t)hwm_cpu_msr_rdtsc >> 32);
	hwm_cpu_gprs_eax = (uint32_t)hwm_cpu_msr_rdtsc;
	hwm_cpu_msr_rdtsc++;
}

void _impl__casm__movl_cr0_eax(void){
	hwm_cpu_gprs_eax = hwm_cpu_cr0;
}

void _impl__casm__movl_cr2_eax(void){
	hwm_cpu_gprs_eax = hwm_cpu_cr2;
}

void _impl__casm__movl_cr3_eax(void){
	hwm_cpu_gprs_eax = hwm_cpu_cr3;
}

void _impl__casm__movl_cr4_eax(void){
	hwm_cpu_gprs_eax = hwm_cpu_cr4;
}

void _impl__casm__movl_esp_eax(void){
	hwm_cpu_gprs_eax = hwm_cpu_gprs_esp;

}

void _impl__casm__movl_esp_ecx(void){
	hwm_cpu_gprs_ecx = hwm_cpu_gprs_esp;

}


void _impl__casm__pushfl(void){
	hwm_cpu_gprs_esp -= sizeof(uint32_t);
	*((uint32_t *)hwm_cpu_gprs_esp) = hwm_cpu_eflags;
}

void _impl__casm__movl_cs_eax(void){
	hwm_cpu_gprs_eax = hwm_cpu_cs_selector;
}

void _impl__casm__movl_ds_eax(void){
	hwm_cpu_gprs_eax = hwm_cpu_ds_selector;
}

void _impl__casm__movl_es_eax(void){
	hwm_cpu_gprs_eax = hwm_cpu_es_selector;
}

void _impl__casm__movl_fs_eax(void){
	hwm_cpu_gprs_eax = hwm_cpu_fs_selector;
}

void _impl__casm__movl_gs_eax(void){
	hwm_cpu_gprs_eax = hwm_cpu_gs_selector;
}

void _impl__casm__movl_ss_eax(void){
	hwm_cpu_gprs_eax = hwm_cpu_ss_selector;
}


void _impl__casm__btl_imm_mecx(uint32_t value, int index){
	uint32_t *value_mecx;
	value_mecx = (uint32_t *)((uint32_t)((int)hwm_cpu_gprs_ecx + (int)index));
	//store bit specified by value in *value_mecx into CF
        if( *value_mecx & (1UL << value))
		hwm_cpu_eflags |= EFLAGS_CF;
	else
		hwm_cpu_eflags &= ~(EFLAGS_CF);
}

void _impl__casm__btrl_imm_mecx(uint32_t value, int index){
	uint32_t *value_mecx;
	value_mecx = (uint32_t *)((uint32_t)((int)hwm_cpu_gprs_ecx + (int)index));
	//store bit specified by value in *value_mecx into CF and clear that bit
        if( *value_mecx & (1UL << value)){
		hwm_cpu_eflags |= EFLAGS_CF;
		*value_mecx = *value_mecx & ~((1UL << value));
        }else{
		hwm_cpu_eflags &= ~(EFLAGS_CF);
        }
}

void _impl__casm__btsl_imm_mecx(uint32_t value, int index){
	uint32_t *value_mecx;
	value_mecx = (uint32_t *)((uint32_t)((int)hwm_cpu_gprs_ecx + (int)index));
	//store bit specified by value in *value_mecx into CF and set that bit
        if( *value_mecx & (1UL << value)){
		hwm_cpu_eflags |= EFLAGS_CF;
        }else{
		hwm_cpu_eflags &= ~(EFLAGS_CF);
		*value_mecx = *value_mecx | ((1UL << value));
        }
}


void _impl__casm__vmxon_mesp(int index){
	uint64_t *value_mesp;
	value_mesp = (uint32_t *)((uint32_t)((int)hwm_cpu_gprs_esp + (int)index));
	//TODO: vmxon emulation
	hwm_cpu_eflags &= ~(EFLAGS_CF);
	hwm_cpu_eflags &= ~(EFLAGS_ZF);
}

void _impl__casm__vmwrite_eax_ecx(void){
        hwm_vdriver_cpu_vmwrite(hwm_cpu_gprs_ecx, hwm_cpu_gprs_eax);
	//ecx=encoding, eax=value
	if(hwm_cpu_gprs_ecx == VMCS_HOST_RIP){
                hwm_cpu_vmcs_host_rip = hwm_cpu_gprs_eax;
	}else if(hwm_cpu_gprs_ecx == VMCS_HOST_RSP){
                //@assert 1;
                hwm_cpu_vmcs_host_rsp = hwm_cpu_gprs_eax;
	}else if(hwm_cpu_gprs_ecx == VMCS_HOST_CR3){
                //@assert 1;
                hwm_cpu_vmcs_host_cr3 = hwm_cpu_gprs_eax;

	}else{

	}
}

void _impl__casm__vmread_ecx_eax(void){
	//ecx=encoding, eax=value
	if(hwm_cpu_gprs_ecx == VMCS_HOST_RIP){
                hwm_cpu_gprs_eax = hwm_cpu_vmcs_host_rip;
	}else if(hwm_cpu_gprs_ecx == VMCS_HOST_RSP){
                hwm_cpu_gprs_eax = hwm_cpu_vmcs_host_rsp;
	}else if(hwm_cpu_gprs_ecx == VMCS_HOST_CR3){
                hwm_cpu_gprs_eax = hwm_cpu_vmcs_host_cr3;

	}else{

	}

}

void _impl__casm__vmclear_mesp(int index){
	uint64_t *value_mesp;
	value_mesp = (uint32_t *)((uint32_t)((int)hwm_cpu_gprs_esp + (int)index));

}

void _impl__casm__vmptrld_mesp(int index){
	uint64_t *value_mesp;
	value_mesp = (uint32_t *)((uint32_t)((int)hwm_cpu_gprs_esp + (int)index));

}

void _impl__casm__wbinvd(void){
	//XXX: wbinvd logic
}

void _impl__casm__movl_eax_cr0(void){
	hwm_cpu_cr0 = hwm_cpu_gprs_eax;
}

void _impl__casm__movl_eax_cr3(void){
	hwm_vdriver_cpu_writecr3(hwm_cpu_cr3, hwm_cpu_gprs_eax);
	hwm_cpu_cr3 = hwm_cpu_gprs_eax;
}

void _impl__casm__movl_ebx_cr3(void){
	hwm_vdriver_cpu_writecr3(hwm_cpu_cr3, hwm_cpu_gprs_ebx);
	hwm_cpu_cr3 = hwm_cpu_gprs_ebx;
}


void _impl__casm__movl_eax_cr4(void){
	hwm_cpu_cr4 = hwm_cpu_gprs_eax;
}


void _impl__casm__popfl(void){
	uint32_t value = *((uint32_t *)hwm_cpu_gprs_esp);
	hwm_cpu_gprs_esp += sizeof(uint32_t);
	hwm_cpu_eflags = value;
}


void _impl__casm__xgetbv(void){
	if(hwm_cpu_gprs_ecx == 1){
		hwm_cpu_gprs_eax = (uint32_t)hwm_cpu_xcr0;
		hwm_cpu_gprs_edx = (uint32_t)((uint64_t)hwm_cpu_xcr0 >> 32);
	}else{
		//XXX: TODO: GPF
	}
}

void _impl__casm__xsetbv(void){
	if(hwm_cpu_gprs_ecx == 1){
		hwm_cpu_xcr0 = ((uint64_t)hwm_cpu_gprs_edx << 32) |
			hwm_cpu_gprs_eax;
	}else{
		//XXX: TODO: GPF
	}

}

void _impl__casm__pushl_edi(void){
	hwm_cpu_gprs_esp -= sizeof(uint32_t);
	*((uint32_t *)hwm_cpu_gprs_esp) = hwm_cpu_gprs_edi;
}

void _impl__casm__movl_mesp_edi(int index){
	uint32_t *value;
	value = (uint32_t *)((uint32_t)((int)hwm_cpu_gprs_esp + (int)index));
	hwm_cpu_gprs_edi = *value;
}

void _impl__casm__cld(void){
	hwm_cpu_eflags &= ~(EFLAGS_DF);
}



void _impl__casm__popl_edi(void){
	uint32_t value = *((uint32_t *)hwm_cpu_gprs_esp);
	hwm_cpu_gprs_esp += sizeof(uint32_t);
	hwm_cpu_gprs_edi = value;
}


void _impl__casm__andl_imm_eax(uint32_t value){
	hwm_cpu_gprs_eax &= value;
}




void _impl__casm__pushl_ebp(void){
	hwm_cpu_gprs_esp -= sizeof(uint32_t);
	*((uint32_t *)hwm_cpu_gprs_esp) = hwm_cpu_gprs_ebp;
}

void _impl__casm__movl_esp_edx(void){
	hwm_cpu_gprs_edx = hwm_cpu_gprs_esp;

}

void _impl__casm__pushl_eax(void){
	hwm_cpu_gprs_esp -= sizeof(uint32_t);
	*((uint32_t *)hwm_cpu_gprs_esp) = hwm_cpu_gprs_eax;
}

void _impl__casm__pushl_edx(void){
	hwm_cpu_gprs_esp -= sizeof(uint32_t);
	*((uint32_t *)hwm_cpu_gprs_esp) = hwm_cpu_gprs_edx;
}

void _impl__casm__pushl_esp(void){
	uint32_t value = hwm_cpu_gprs_esp;
	hwm_cpu_gprs_esp -= sizeof(uint32_t);
	*((uint32_t *)hwm_cpu_gprs_esp) = value;
}


void _impl__casm__pushl_imm(uint32_t value){
	hwm_cpu_gprs_esp -= sizeof(uint32_t);
	*((uint32_t *)hwm_cpu_gprs_esp) = value;
}


void _impl__casm__pushl_ecx(void){
	hwm_cpu_gprs_esp -= sizeof(uint32_t);
	*((uint32_t *)hwm_cpu_gprs_esp) = hwm_cpu_gprs_ecx;
}



void _impl__casm__popl_ebp(void){
	uint32_t value = *((uint32_t *)hwm_cpu_gprs_esp);
	hwm_cpu_gprs_esp += sizeof(uint32_t);
	hwm_cpu_gprs_ebp = value;
}





void _impl__casm__vmlaunch(void){
	hwm_vdriver_slabep();

	//hwm_cpu_eflags |= EFLAGS_CF;
}

void  _impl__casm__vmresume(void){
	hwm_vdriver_slabep();

}



void _impl__casm__pushal(void){
	uint32_t value = hwm_cpu_gprs_esp;
	_impl__casm__pushl_eax();
	_impl__casm__pushl_ecx();
	_impl__casm__pushl_edx();
	_impl__casm__pushl_ebx();
	_impl__casm__pushl_imm(value);
	_impl__casm__pushl_ebp();
	_impl__casm__pushl_esi();
	_impl__casm__pushl_edi();

}

void _impl__casm__movw_imm_ax(uint16_t value){
	hwm_cpu_gprs_eax &= 0xFFFF0000UL;
	hwm_cpu_gprs_eax |= value;
}

void  _impl__casm__movw_ax_ds(void){
	hwm_cpu_ds_selector = hwm_cpu_gprs_eax & 0x0000FFFFUL;
}

void  _impl__casm__movw_ds_ax(void){
	uint16_t val = hwm_cpu_ds_selector;
        hwm_cpu_gprs_eax &= 0xFFFF0000UL;
        hwm_cpu_gprs_eax |= val;
}


void  _impl__casm__movw_ax_es(void){
	hwm_cpu_es_selector = hwm_cpu_gprs_eax & 0x0000FFFFUL;
}

void  _impl__casm__movw_ax_fs(void){
	hwm_cpu_fs_selector = hwm_cpu_gprs_eax & 0x0000FFFFUL;
}

void  _impl__casm__movw_ax_gs(void){
	hwm_cpu_gs_selector = hwm_cpu_gprs_eax & 0x0000FFFFUL;
}

void  _impl__casm__movw_ax_ss(void){
	hwm_cpu_ss_selector = hwm_cpu_gprs_eax & 0x0000FFFFUL;
}


void _impl__casm__iretl(void){
	//XXX: TODO IRETL logic
	hwm_vdriver_slabep();
}


void _impl__casm__mull_ecx(void){
        hwm_cpu_gprs_eax = hwm_cpu_gprs_eax * hwm_cpu_gprs_ecx;
}

void _impl__casm__addl_ecx_eax(void){
	hwm_cpu_gprs_eax += hwm_cpu_gprs_ecx;
}





//////////////////////////////////////////////////////////////////////////////
//
// System memory/MMIO interfaces
//
//////////////////////////////////////////////////////////////////////////////


physmem_extent_t hwm_sysmemaccess_physmem_extents[32];
uint32_t hwm_sysmemaccess_physmem_extents_total=0;

static bool hwm_sysmemaccess_checkextents(uint32_t addr_start, uint32_t size){
	uint32_t index;
	bool within_extents=false;
	for(index=0; index < hwm_sysmemaccess_physmem_extents_total; index++){
		if(addr_start >= hwm_sysmemaccess_physmem_extents[index].addr_start
		&& (addr_start + size) <= hwm_sysmemaccess_physmem_extents[index].addr_end){
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

void _impl__casm__rep_movsb(void){
	if(hwm_cpu_eflags & EFLAGS_DF){
		//reverse, TODO

	}else{
		//increment
		if(hwm_sysmemaccess_checkextents(hwm_cpu_gprs_edi,
						hwm_cpu_gprs_ecx)){
			//copy to sysmem is havoc
		}else{
			rep_movsb_memcpy(hwm_cpu_gprs_edi, hwm_cpu_gprs_esi,
				hwm_cpu_gprs_ecx);
		}
                hwm_cpu_gprs_edi += hwm_cpu_gprs_ecx;
                hwm_cpu_gprs_esi += hwm_cpu_gprs_ecx;
	}
}



static uint64_t _impl_hwm_cpu_sysmemread(uint32_t sysmemaddr, sysmem_read_t readsize){
	bool hwmdevstatus=false;
	uint64_t read_result=0;

	hwmdevstatus = _impl_hwm_e1000_read(sysmemaddr, readsize, &read_result);
        if(hwmdevstatus)
		return read_result;

	hwmdevstatus = _impl_hwm_txt_read(sysmemaddr, readsize, &read_result);
        if(hwmdevstatus)
		return read_result;

	hwmdevstatus = _impl_hwm_bios_read(sysmemaddr, readsize, &read_result);
        if(hwmdevstatus)
		return read_result;

	hwmdevstatus = _impl_hwm_mem_read(sysmemaddr, readsize, &read_result);
        if(hwmdevstatus)
		return read_result;

	hwmdevstatus = _impl_hwm_vtd_read(sysmemaddr, readsize, &read_result);
        if(hwmdevstatus)
		return read_result;

	hwmdevstatus = _impl_hwm_lapic_read(sysmemaddr, readsize, &read_result);
        if(hwmdevstatus)
		return read_result;

	//@assert 0;
	return read_result;
}


static void _impl_hwm_cpu_sysmemwrite(uint32_t sysmemaddr, sysmem_write_t writesize, uint64_t write_value){
	bool hwmdevstatus=false;

	hwmdevstatus = _impl_hwm_e1000_write(sysmemaddr, writesize, write_value);
        if(hwmdevstatus)
		return;

	hwmdevstatus = _impl_hwm_txt_write(sysmemaddr, writesize, write_value);
        if(hwmdevstatus)
		return;

	hwmdevstatus = _impl_hwm_bios_write(sysmemaddr, writesize, write_value);
        if(hwmdevstatus)
		return;

	hwmdevstatus = _impl_hwm_vtd_write(sysmemaddr, writesize, write_value);
        if(hwmdevstatus)
		return;

	hwmdevstatus = _impl_hwm_lapic_write(sysmemaddr, writesize, write_value);
        if(hwmdevstatus)
		return;

	hwmdevstatus = _impl_hwm_mem_write(sysmemaddr, writesize, write_value);
		if(hwmdevstatus)
		return;

	//@assert 0;
	return;
}

static void _impl_hwm_cpu_sysmemcopy(sysmem_copy_t sysmemcopy_type,
		uint32_t dstaddr, uint32_t srcaddr, uint32_t size){
	bool hwmdevstatus=false;

	hwmdevstatus = _impl_hwm_txt_sysmemcopy(sysmemcopy_type,
			dstaddr, srcaddr, size);
        if(hwmdevstatus)
		return;

	hwmdevstatus = _impl_hwm_bios_sysmemcopy(sysmemcopy_type,
			dstaddr, srcaddr, size);
        if(hwmdevstatus)
		return;


	hwmdevstatus = _impl_hwm_mem_sysmemcopy(sysmemcopy_type,
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
uint8_t _impl_hwm_lapic_mmiospace[PAGE_SIZE_4K];

static uint32_t _impl_hwm_gethwmaddrforsysmem(uint32_t sysmemaddr){
	if(sysmemaddr >= MMIO_APIC_BASE && sysmemaddr <
		(MMIO_APIC_BASE+ PAGE_SIZE_4K)){
		return (uint32_t)&_impl_hwm_lapic_mmiospace;
	}else
		return 0;
}*/


void _impl__casm__rep_movsb_sysmem(sysmem_copy_t sysmemcopy_type){
	if(hwm_cpu_eflags & EFLAGS_DF){
		//reverse, TODO
		//@assert 0;
	}else{
		//increment
		_impl_hwm_cpu_sysmemcopy(sysmemcopy_type,
					hwm_cpu_gprs_edi,
					hwm_cpu_gprs_esi,
					hwm_cpu_gprs_ecx);

                hwm_cpu_gprs_edi += hwm_cpu_gprs_ecx;
                hwm_cpu_gprs_esi += hwm_cpu_gprs_ecx;
	}
}


void _impl__casm__movl_mesi_eax(int index){
	//uint32_t *value_mesi;
	//value_mesi = (uint32_t *)_impl_hwm_gethwmaddrforsysmem(((uint32_t)((int)hwm_cpu_gprs_esi + (int)index)));
	uint32_t sysmemaddr = ((uint32_t)((int)hwm_cpu_gprs_esi + (int)index));
	//hwm_cpu_gprs_eax = *value_mesi;
	hwm_cpu_gprs_eax = _impl_hwm_cpu_sysmemread(sysmemaddr, SYSMEMREADU32);
}

void _impl__casm__movl_mesi_edx(uint32_t index){
	//uint32_t *value_mesi;
	//value_mesi = (uint32_t *)((uint32_t)((int)hwm_cpu_gprs_esi + (int)index));
	uint32_t sysmemaddr = (uint32_t)(hwm_cpu_gprs_esi + index);
	//hwm_cpu_gprs_edx = *value_mesi;
	hwm_cpu_gprs_edx = _impl_hwm_cpu_sysmemread(sysmemaddr, SYSMEMREADU32);
}

void _impl__casm__movl_eax_mesi(int index){
	//uint32_t *value;
	//value = (uint32_t *)((uint32_t)((int)hwm_cpu_gprs_esi + (int)index));
	uint32_t sysmemaddr = ((uint32_t)((int)hwm_cpu_gprs_esi + (int)index));
	// *value = hwm_cpu_gprs_eax;
	_impl_hwm_cpu_sysmemwrite(sysmemaddr, SYSMEMWRITEU32, hwm_cpu_gprs_eax);
}

void _impl__casm__movl_edx_mesi(int index){
	//uint32_t *value;
	//value = (uint32_t *)((uint32_t)((int)hwm_cpu_gprs_esi + (int)index));
	uint32_t sysmemaddr = ((uint32_t)((int)hwm_cpu_gprs_esi + (int)index));
	// *value = hwm_cpu_gprs_edx;
	_impl_hwm_cpu_sysmemwrite(sysmemaddr, SYSMEMWRITEU32, hwm_cpu_gprs_edx);
}

void _impl__casm__movb_al_mesi(int index){
	//uint32_t *value_mesi;
	//value_mesi = (uint32_t *)((uint32_t)((int)hwm_cpu_gprs_esi + (int)index));
	uint32_t sysmemaddr = ((uint32_t)((int)hwm_cpu_gprs_esi + (int)index));
	// *value_mesi |= (hwm_cpu_gprs_eax & 0x000000FFUL);
	_impl_hwm_cpu_sysmemwrite(sysmemaddr, SYSMEMWRITEU8, (hwm_cpu_gprs_eax & 0x000000FFUL));
}

void _impl__casm__movw_ax_mesi(int index){
	//uint32_t *value_mesi;
	//value_mesi = (uint32_t *)((uint32_t)((int)hwm_cpu_gprs_esi + (int)index));
	uint32_t sysmemaddr = ((uint32_t)((int)hwm_cpu_gprs_esi + (int)index));
	// *value_mesi |= (hwm_cpu_gprs_eax & 0x0000FFFFUL);
	_impl_hwm_cpu_sysmemwrite(sysmemaddr, SYSMEMWRITEU16, (hwm_cpu_gprs_eax & 0x0000FFFFUL));
}
