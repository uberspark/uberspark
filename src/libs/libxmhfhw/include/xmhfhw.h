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

#ifndef __XMHFHW_H__
#define __XMHFHW_H__


//////xmhfhw_cpu

//#define MAX_LCP_PO_DATA_SIZE     64*1024  /* 64k */
#define MAX_LCP_PO_DATA_SIZE     64

#ifndef __ASSEMBLY__

typedef struct {
    mtrr_def_type_t	    mtrr_def_type;
    uint32_t	                num_var_mtrrs;
    mtrr_physbase_t     mtrr_physbases[MAX_VARIABLE_MTRRS];
    mtrr_physmask_t     mtrr_physmasks[MAX_VARIABLE_MTRRS];
} __attribute__((packed)) mtrr_state_t;


/*
 * OS/loader to MLE structure
 *   - private to tboot (so can be any format we need)
 */

typedef struct {
    uint32_t          version;           /* currently 2 */
    mtrr_state_t      saved_mtrr_state;  /* saved prior to changes for SINIT */
    //multiboot_info_t* mbi;               /* needs to be restored to ebx */
    void *mbi;
    uint32_t          saved_misc_enable_msr;  /* saved prior to SENTER */
                                         /* PO policy data */
    uint8_t           lcp_po_data[MAX_LCP_PO_DATA_SIZE];
} __attribute__ ((packed)) os_mle_data_t;


/*
 * TXT heap data format and field accessor fns
 */

/*
 * offset                 length                      field
 * ------                 ------                      -----
 *  0                      8                          bios_data_size
 *  8                      bios_data_size - 8      bios_data
 *
 *  bios_data_size      8                          os_mle_data_size
 *  bios_data_size +    os_mle_data_size - 8       os_mle_data
 *   8
 *
 *  bios_data_size +    8                          os_sinit_data_size
 *   os_mle_data_size
 *  bios_data_size +    os_sinit_data_size - 8     os_sinit_data
 *   os_mle_data_size +
 *   8
 *
 *  bios_data_size +    8                          sinit_mle_data_size
 *   os_mle_data_size +
 *   os_sinit_data_size
 *  bios_data_size +    sinit_mle_data_size - 8    sinit_mle_data
 *   os_mle_data_size +
 *   os_sinit_data_size +
 *   8
 */



//////xmhfhw_mmio_vtd

#ifndef __ASSEMBLY__

typedef struct {
    vtd_pml4te_t pml4t[PAE_MAXPTRS_PER_PML4T];
    vtd_pdpte_t pdpt[PAE_MAXPTRS_PER_PDPT];
    vtd_pdte_t pdt[PAE_PTRS_PER_PDPT][PAE_PTRS_PER_PDT];
    vtd_pte_t pt[PAE_PTRS_PER_PDPT][PAE_PTRS_PER_PDT][PAE_PTRS_PER_PT];
}__attribute__((packed)) vtd_slpgtbl_t;

typedef struct {
    uint64_t addr_vtd_pml4t;
    uint64_t addr_vtd_pdpt;
}__attribute__((packed)) vtd_slpgtbl_handle_t;

#endif //__ASSEMBLY__





/*@
  assigns \nothing;
@*/
int fls(int mask);

/*@
  assigns \nothing;
@*/
uint32_t __getsec_capabilities(uint32_t index);

/*@
	requires \valid(param_type);
	requires \valid(peax);
	requires \valid(pebx);
	requires \valid(pecx);
	assigns *param_type;
	assigns *peax;
	assigns *pebx;
	assigns *pecx;
@*/
void __getsec_parameters(uint32_t index, int* param_type, uint32_t* peax, uint32_t* pebx, uint32_t* pecx);


/*@
  assigns \nothing;
@*/
void __getsec_senter(uint32_t sinit_base, uint32_t sinit_size);

/*@
  assigns \nothing;
@*/
void __getsec_sexit(void);

/*@
  assigns \nothing;
@*/
void __getsec_smctrl(void);

/*@
  assigns \nothing;
@*/
void __getsec_wakeup(void);


/*@
  assigns \nothing;
@*/
uint32_t xmhf_baseplatform_arch_getcpuvendor(void);


/*@
  assigns \nothing;
@*/
bool xmhf_baseplatform_arch_x86_cpuhasxsavefeature(void);

/*@
  assigns \nothing;
@*/
void set_all_mtrrs(bool enable);


/*@
	requires \valid(saved_state);
	requires 0 <= saved_state->num_var_mtrrs < MAX_VARIABLE_MTRRS;
	assigns \nothing;
@*/
void xmhfhw_cpu_x86_restore_mtrrs(mtrr_state_t *saved_state);


/*@
	requires \valid(saved_state);
	assigns saved_state->mtrr_def_type;
	assigns saved_state->num_var_mtrrs;
	assigns saved_state->mtrr_physbases[0 .. MAX_VARIABLE_MTRRS-1];
	assigns saved_state->mtrr_physmasks[0 .. MAX_VARIABLE_MTRRS-1];
@*/
void xmhfhw_cpu_x86_save_mtrrs(mtrr_state_t *saved_state);


bool set_mem_type(uint32_t base, uint32_t size, uint32_t mem_type);

/*@
	requires \valid(saved_state);
	requires 0 <= saved_state->num_var_mtrrs < MAX_VARIABLE_MTRRS;
	assigns \nothing;
@*/
bool validate_mtrrs(mtrr_state_t *saved_state);





/*@
	assigns \nothing;
@*/
uint64_t get_bios_data_size(uint32_t heap_memaddr, uint32_t heap_size);


/*@
	assigns \nothing;
@*/
uint32_t get_bios_data_start(uint32_t heap_memaddr, uint32_t heap_size);



/*@
	assigns \nothing;
@*/
uint32_t get_txt_heap(void);


/*@
	assigns \nothing;
@*/
uint64_t get_os_mle_data_size(uint32_t heap_memaddr, uint32_t heap_size);


/*@
	assigns \nothing;
@*/
uint32_t get_os_mle_data_start(uint32_t heap_memaddr, uint32_t heap_size);

/*@
	assigns \nothing;
@*/
uint64_t get_os_sinit_data_size(uint32_t heap_memaddr, uint32_t heap_size);

/*@
	assigns \nothing;
@*/
uint32_t get_os_sinit_data_start(uint32_t heap_memaddr, uint32_t heap_size);

/*@
	assigns \nothing;
@*/
uint64_t get_sinit_mle_data_size(uint32_t heap_memaddr, uint32_t heap_size);

/*@
	assigns \nothing;
@*/
uint32_t get_sinit_mle_data_start(uint32_t heap_memaddr, uint32_t heap_size);

/*@
	assigns \nothing;
@*/
bool txt_is_launched(void);

/*@
	assigns \nothing;
@*/
uint64_t read_priv_config_reg(uint32_t reg);


/*@
	assigns \nothing;
@*/
uint64_t read_pub_config_reg(uint32_t reg);

/*@
	assigns \nothing;
@*/
void write_priv_config_reg(uint32_t reg, uint64_t val);

/*@
	assigns \nothing;
@*/
void write_pub_config_reg(uint32_t reg, uint64_t val);




/*@
	assigns \nothing;
@*/
void xmhf_baseplatform_arch_x86_reboot(void);



/*@
	assigns \nothing;
@*/
uint32_t xmhf_baseplatform_arch_x86_getcpulapicid(void);


/*@
	assigns \nothing;
@*/
bool xmhfhw_lapic_isbsp(void);



/*@
	assigns \nothing;
@*/
bool xmhfhw_platform_bus_init(void);


/*@
	requires \valid(value);
	assigns *value;
	ensures 0 <= (*value) <= 0xFFFFFFFFUL;
@*/
void xmhf_baseplatform_arch_x86_pci_type1_read(uint32_t bus, uint32_t device, uint32_t function, uint32_t index, uint32_t len, uint32_t *value);

/*@
	assigns \nothing;
@*/
void xmhf_baseplatform_arch_x86_pci_type1_write(uint32_t bus, uint32_t device, uint32_t function, uint32_t index, uint32_t len, uint32_t value);


/*@
	assigns \nothing;
@*/
void xmhf_baseplatform_arch_x86_udelay(uint32_t usecs);


/*@
	requires \valid(rsdp);
	assigns \nothing;
@*/
uint32_t xmhfhw_platform_x86pc_acpi_getRSDP(ACPI_RSDP *rsdp);


/*@
	requires \valid(drhd);
	assigns \nothing;
@*/
void xmhfhw_platform_x86pc_vtd_drhd_disable_pmr(VTD_DRHD *drhd);

/*@
	requires \valid(drhd);
	assigns \nothing;
@*/
void xmhfhw_platform_x86pc_vtd_drhd_disable_translation(VTD_DRHD *drhd);

/*@
	requires \valid(drhd);
	assigns \nothing;
@*/
void xmhfhw_platform_x86pc_vtd_drhd_enable_translation(VTD_DRHD *drhd);

/*@
	requires \valid(drhd);
	assigns \nothing;
@*/
bool xmhfhw_platform_x86pc_vtd_drhd_initialize(VTD_DRHD *drhd);

/*@
	requires \valid(drhd);
	assigns \nothing;
@*/
bool xmhfhw_platform_x86pc_vtd_drhd_invalidatecaches(VTD_DRHD *drhd);

/*@
	requires \valid(dmardevice);
	assigns \nothing;
@*/
uint64_t _vtd_reg_read(VTD_DRHD *dmardevice, uint32_t reg);

/*@
	requires \valid(drhd);
	assigns \nothing;
@*/
void xmhfhw_platform_x86pc_vtd_drhd_set_phm_base_and_limit(VTD_DRHD *drhd, uint64_t base, uint64_t limit);

/*@
	requires \valid(drhd);
	assigns \nothing;
@*/
void xmhfhw_platform_x86pc_vtd_drhd_set_plm_base_and_limit(VTD_DRHD *drhd, uint32_t base, uint32_t limit);

/*@
	requires \valid(drhd);
	assigns \nothing;
@*/
bool xmhfhw_platform_x86pc_vtd_drhd_set_root_entry_table(VTD_DRHD *drhd,  uint64_t ret_addr);

/*@
	requires \valid(dmardevice);
	assigns \nothing;
@*/
void _vtd_reg_write(VTD_DRHD *dmardevice, uint32_t reg, uint64_t value);








/*@
  assigns \nothing;
@*/
CASM_FUNCDECL(uint32_t bsrl(uint32_t mask));


/*@
	requires \valid(eax);
	requires \valid(ebx);
	requires \valid(ecx);
	requires \valid(edx);
	assigns *eax;
	assigns *ebx;
	assigns *ecx;
	assigns *edx;
@*/
CASM_FUNCDECL(void xmhfhw_cpu_getsec(uint32_t *eax, uint32_t *ebx, uint32_t *ecx, uint32_t *edx));


/*@
	requires \valid(eax);
	requires \valid(ebx);
	requires \valid(ecx);
	requires \valid(edx);
	assigns *eax;
	assigns *ebx;
	assigns *ecx;
	assigns *edx;
@*/
CASM_FUNCDECL(void xmhfhw_cpu_cpuid(uint32_t op, uint32_t *eax, uint32_t *ebx, uint32_t *ecx, uint32_t *edx));


/*@
  assigns \nothing;
@*/
CASM_FUNCDECL(void wrmsr64(uint32_t msr, uint32_t newval_lo, uint32_t newval_hi));


/*@
  assigns \nothing;
@*/
CASM_FUNCDECL(uint64_t rdmsr64(uint32_t msr));


/*@
  assigns \nothing;
@*/
CASM_FUNCDECL(uint8_t xmhfhw_sysmemaccess_readu8(uint32_t addr));


/*@
  assigns \nothing;
@*/
CASM_FUNCDECL(uint16_t xmhfhw_sysmemaccess_readu16(uint32_t addr));


/*@
  assigns \nothing;
@*/
CASM_FUNCDECL(uint32_t xmhfhw_sysmemaccess_readu32(uint32_t addr));

/*@
  assigns \nothing;
@*/
CASM_FUNCDECL(uint64_t xmhfhw_sysmemaccess_readu64(uint32_t addr));

/*@
  assigns \nothing;
@*/
CASM_FUNCDECL(void xmhfhw_sysmemaccess_writeu8(uint32_t addr, uint8_t val));

/*@
  assigns \nothing;
@*/
CASM_FUNCDECL(void xmhfhw_sysmemaccess_writeu16(uint32_t addr, uint16_t val));

/*@
  assigns \nothing;
@*/
CASM_FUNCDECL(void xmhfhw_sysmemaccess_writeu32(uint32_t addr, uint32_t val));

/*@
  assigns \nothing;
@*/
CASM_FUNCDECL(void xmhfhw_sysmemaccess_writeu64(uint32_t addr, uint32_t val_lo, uint32_t val_hi));


/*@
  assigns \nothing;
@*/
CASM_FUNCDECL(void xmhfhw_sysmemaccess_copy(uint8_t *dest, uint8_t *src, uint32_t size));


/*@
  assigns \nothing;
@*/
CASM_FUNCDECL(void xmhfhw_sysmem_copy_sys2obj(uint8_t *objdst, uint8_t *syssrc, uint32_t size));


/*@
  assigns \nothing;
@*/
CASM_FUNCDECL(void xmhfhw_sysmem_copy_obj2sys(uint8_t *sysdst, uint8_t *objsrc, uint32_t size));


/*@
  assigns \nothing;
@*/
CASM_FUNCDECL(uint64_t read_config_reg(uint32_t config_regs_base, uint32_t reg));

/*@
  assigns \nothing;
@*/
CASM_FUNCDECL(void write_config_reg(uint32_t config_regs_base, uint32_t reg, uint64_t val));




/*@
  assigns \nothing;
@*/
CASM_FUNCDECL(void outl(uint32_t val, uint32_t port));

/*@
  assigns \nothing;
@*/
CASM_FUNCDECL(void outw (uint32_t value, uint32_t port));


/*@
  assigns \nothing;
@*/
CASM_FUNCDECL(void outb (uint32_t value, uint32_t port));

/*@
  assigns \nothing;
@*/
CASM_FUNCDECL(uint32_t inl(uint32_t port));

/*@
  assigns \nothing;
@*/
CASM_FUNCDECL(uint16_t inw (uint32_t port));

/*@
  assigns \nothing;
  ensures 0 <= \result <= 255;
@*/
CASM_FUNCDECL(uint8_t inb (uint32_t port));





CASM_FUNCDECL(void xmhfhw_cpu_disable_intr(void *noparam));
CASM_FUNCDECL(void enable_intr(void *noparam));
CASM_FUNCDECL(uint32_t xmhf_baseplatform_arch_x86_getgdtbase(void *noparam));
CASM_FUNCDECL(uint32_t xmhf_baseplatform_arch_x86_getidtbase(void *noparam));
CASM_FUNCDECL(uint64_t  xmhf_baseplatform_arch_x86_gettssbase(void *noparam));


/*@
  assigns \nothing;
@*/
CASM_FUNCDECL(void xmhfhw_cpu_hlt(void *noparam));



CASM_FUNCDECL(void cpu_relax(void *noparam));


CASM_FUNCDECL(uint64_t rdtsc64(void *noparam));
CASM_FUNCDECL(uint32_t read_eflags(void *noparam));

CASM_FUNCDECL(void write_eflags(uint32_t eflags));

CASM_FUNCDECL(uint64_t read_cr0(void *noparam));

CASM_FUNCDECL(void write_cr0(uint32_t val));

CASM_FUNCDECL(uint32_t read_cr2(void *noparam));
CASM_FUNCDECL(uint64_t read_cr3(void *noparam));
CASM_FUNCDECL(uint64_t read_rsp(void *noparam));
CASM_FUNCDECL(uint32_t read_esp(void *noparam));

CASM_FUNCDECL(void write_cr3(uint32_t val));

CASM_FUNCDECL(uint64_t read_cr4(void *noparam));

CASM_FUNCDECL(void write_cr4(uint32_t val));
//void skinit(unsigned long eax));

CASM_FUNCDECL(uint32_t read_segreg_cs(void *noparam));
CASM_FUNCDECL(uint32_t read_segreg_ds(void *noparam));
CASM_FUNCDECL(uint32_t read_segreg_es(void *noparam));
CASM_FUNCDECL(uint32_t read_segreg_fs(void *noparam));
CASM_FUNCDECL(uint32_t read_segreg_gs(void *noparam));
CASM_FUNCDECL(uint32_t read_segreg_ss(void *noparam));
CASM_FUNCDECL(uint32_t read_tr_sel(void *noparam));

CASM_FUNCDECL(void wbinvd(void *noparam));



CASM_FUNCDECL(uint64_t xgetbv(uint32_t xcr_reg));
CASM_FUNCDECL(void xsetbv(uint32_t xcr_reg, uint32_t value_lo, uint32_t value_hi));
//void sysexitq(uint64_t rip, uint64_t rsp));

/*@
  requires \valid(lock);
  assigns *lock;
@*/
CASM_FUNCDECL(void spin_lock(volatile uint32_t *lock));

/*@
  requires \valid(lock);
  assigns *lock;
@*/
CASM_FUNCDECL(void spin_unlock(volatile uint32_t *lock));

CASM_FUNCDECL(void xmhfhw_cpu_loadGDT(arch_x86_gdtdesc_t *gdt_addr));
CASM_FUNCDECL(void xmhfhw_cpu_loadTR(uint32_t tr_selector));
CASM_FUNCDECL(void xmhfhw_cpu_loadIDT(arch_x86_idtdesc_t *idt_addr));



uint32_t xmhf_baseplatform_arch_getcpuvendor(void);


CASM_FUNCDECL(void xmhfhw_cpu_reloadcs(uint32_t cs_sel));
CASM_FUNCDECL(void xmhfhw_cpu_reloaddsregs(uint32_t ds_sel));





#endif //__ASSEMBLY__



//////xmhfhw_cpu_paging


#ifndef __ASSEMBLY__

CASM_FUNCDECL(void cache_wbinvd(void *noparam));
CASM_FUNCDECL(void tlb_invlpg(uint64_t addr));

#endif //__ASSEMBLY__





//////xmhfhw_cpu_vmx

#ifndef __ASSEMBLY__

CASM_FUNCDECL(bool __vmx_vmxon(uint64_t vmxonregion_paddr));
CASM_FUNCDECL(void xmhfhw_cpu_x86vmx_vmwrite(uint32_t encoding, uint32_t value));
CASM_FUNCDECL(uint32_t xmhfhw_cpu_x86vmx_vmread(uint32_t encoding));
CASM_FUNCDECL(uint32_t __vmx_vmclear(uint64_t vmcs));
CASM_FUNCDECL(uint32_t __vmx_vmptrld(uint64_t vmcs));


CASM_FUNCDECL(void xmhfhw_cpu_invvpid(uint32_t invalidation_type, uint32_t vpid, uint32_t linear_addr_lo, uint32_t linear_addr_hi));

/*@
	assigns \nothing;
@*/
CASM_FUNCDECL(uint32_t __vmx_invept(uint32_t invalidation_type_lo, uint32_t invalidation_type_hi, uint32_t eptp_lo, uint32_t eptp_hi));

#endif //__ASSEMBLY__


















#endif // __XMHFHW_H__
