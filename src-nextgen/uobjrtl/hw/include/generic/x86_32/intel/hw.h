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

#ifndef __UOBJRTL_HW__GENERIC_x86_32_INTEL_HW_H__
#define __UOBJRTL_HW__GENERIC_x86_32_INTEL_HW_H__


// include hardware model
#include <uberspark/include/uberspark.h>

#include <uberspark/hwm/include/arch/x86_32/intel/hwm.h>

#include <uberspark/hwm/include/device/iommu/intel/hwm.h>
#include <uberspark/hwm/include/device/net/ethernet/intel/e1000/hwm.h>
#include <uberspark/hwm/include/device/pci/hwm.h>

#include <uberspark/hwm/include/platform/pc/hwm.h>


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
int uberspark_uobjrtl_hw__generic_x86_32_intel__fls(int mask);

/*@
  assigns \nothing;
@*/
uint32_t uberspark_uobjrtl_hw__generic_x86_32_intel__getsec_capabilities(uint32_t index);

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
void uberspark_uobjrtl_hw__generic_x86_32_intel__getsec_parameters(uint32_t index, int* param_type, uint32_t* peax, uint32_t* pebx, uint32_t* pecx);


/*@
  assigns \nothing;
@*/
void uberspark_uobjrtl_hw__generic_x86_32_intel__getsec_senter(uint32_t sinit_base, uint32_t sinit_size);

/*@
  assigns \nothing;
@*/
void uberspark_uobjrtl_hw__generic_x86_32_intel__getsec_sexit(void);

/*@
  assigns \nothing;
@*/
void uberspark_uobjrtl_hw__generic_x86_32_intel__getsec_smctrl(void);

/*@
  assigns \nothing;
@*/
void uberspark_uobjrtl_hw__generic_x86_32_intel__getsec_wakeup(void);


/*@
  assigns \nothing;
@*/
uint32_t uberspark_uobjrtl_hw__generic_x86_32_intel__getcpuvendor(void);


/*@
  assigns \nothing;
@*/
bool uberspark_uobjrtl_hw__generic_x86_32_intel__cpuhasxsavefeature(void);

/*@
  assigns \nothing;
@*/
void uberspark_uobjrtl_hw__generic_x86_32_intel__set_all_mtrrs(bool enable);


/*@
	requires \valid(saved_state);
	requires 0 <= saved_state->num_var_mtrrs < MAX_VARIABLE_MTRRS;
	assigns \nothing;
@*/
void uberspark_uobjrtl_hw__generic_x86_32_intel__restore_mtrrs(mtrr_state_t *saved_state);


/*@
	requires \valid(saved_state);
	assigns saved_state->mtrr_def_type;
	assigns saved_state->num_var_mtrrs;
	assigns saved_state->mtrr_physbases[0 .. MAX_VARIABLE_MTRRS-1];
	assigns saved_state->mtrr_physmasks[0 .. MAX_VARIABLE_MTRRS-1];
@*/
void uberspark_uobjrtl_hw__generic_x86_32_intel__save_mtrrs(mtrr_state_t *saved_state);


bool uberspark_uobjrtl_hw__generic_x86_32_intel__set_mem_type(uint32_t base, uint32_t size, uint32_t mem_type);

/*@
	requires \valid(saved_state);
	requires 0 <= saved_state->num_var_mtrrs < MAX_VARIABLE_MTRRS;
	assigns \nothing;
@*/
bool uberspark_uobjrtl_hw__generic_x86_32_intel__validate_mtrrs(mtrr_state_t *saved_state);





/*@
	assigns \nothing;
@*/
uint64_t uberspark_uobjrtl_hw__generic_x86_32_intel__get_bios_data_size(uint32_t heap_memaddr, uint32_t heap_size);


/*@
	assigns \nothing;
@*/
uint32_t uberspark_uobjrtl_hw__generic_x86_32_intel__get_bios_data_start(uint32_t heap_memaddr, uint32_t heap_size);



/*@
	assigns \nothing;
@*/
uint32_t uberspark_uobjrtl_hw__generic_x86_32_intel__get_txt_heap(void);


/*@
	assigns \nothing;
@*/
uint64_t uberspark_uobjrtl_hw__generic_x86_32_intel__get_os_mle_data_size(uint32_t heap_memaddr, uint32_t heap_size);


/*@
	assigns \nothing;
@*/
uint32_t uberspark_uobjrtl_hw__generic_x86_32_intel__get_os_mle_data_start(uint32_t heap_memaddr, uint32_t heap_size);

/*@
	assigns \nothing;
@*/
uint64_t uberspark_uobjrtl_hw__generic_x86_32_intel__get_os_sinit_data_size(uint32_t heap_memaddr, uint32_t heap_size);

/*@
	assigns \nothing;
@*/
uint32_t uberspark_uobjrtl_hw__generic_x86_32_intel__get_os_sinit_data_start(uint32_t heap_memaddr, uint32_t heap_size);

/*@
	assigns \nothing;
@*/
uint64_t uberspark_uobjrtl_hw__generic_x86_32_intel__get_sinit_mle_data_size(uint32_t heap_memaddr, uint32_t heap_size);

/*@
	assigns \nothing;
@*/
uint32_t uberspark_uobjrtl_hw__generic_x86_32_intel__get_sinit_mle_data_start(uint32_t heap_memaddr, uint32_t heap_size);

/*@
	assigns \nothing;
@*/
bool uberspark_uobjrtl_hw__generic_x86_32_intel__txt_is_launched(void);

/*@
	assigns \nothing;
@*/
uint64_t uberspark_uobjrtl_hw__generic_x86_32_intel__read_priv_config_reg(uint32_t reg);


/*@
	assigns \nothing;
@*/
uint64_t uberspark_uobjrtl_hw__generic_x86_32_intel__read_pub_config_reg(uint32_t reg);

/*@
	assigns \nothing;
@*/
void uberspark_uobjrtl_hw__generic_x86_32_intel__write_priv_config_reg(uint32_t reg, uint64_t val);

/*@
	assigns \nothing;
@*/
void uberspark_uobjrtl_hw__generic_x86_32_intel__write_pub_config_reg(uint32_t reg, uint64_t val);




/*@
	assigns \nothing;
@*/
void uberspark_uobjrtl_hw__generic_x86_32_intel__reboot(void);



/*@
	assigns \nothing;
@*/
uint32_t uberspark_uobjrtl_hw__generic_x86_32_intel__getcpulapicid(void);


/*@
	assigns \nothing;
@*/
bool uberspark_uobjrtl_hw__generic_x86_32_intel__lapic_isbsp(void);



/*@
	assigns \nothing;
@*/
bool uberspark_uobjrtl_hw__generic_x86_32_intel__bus_init(void);


/*@
	requires \valid(value);
	assigns *value;
	ensures 0 <= (*value) <= 0xFFFFFFFFUL;
@*/
void uberspark_uobjrtl_hw__generic_x86_32_intel__pci_type1_read(uint32_t bus, uint32_t device, uint32_t function, uint32_t index, uint32_t len, uint32_t *value);

/*@
	assigns \nothing;
@*/
void uberspark_uobjrtl_hw__generic_x86_32_intel__pci_type1_write(uint32_t bus, uint32_t device, uint32_t function, uint32_t index, uint32_t len, uint32_t value);


/*@
	assigns \nothing;
@*/
void uberspark_uobjrtl_hw__generic_x86_32_intel__udelay(uint32_t usecs);


/*@
	requires \valid(rsdp);
	assigns \nothing;
@*/
uint32_t uberspark_uobjrtl_hw__generic_x86_32_intel__acpi_getRSDP(ACPI_RSDP *rsdp);


/*@
	requires \valid(drhd);
	assigns \nothing;
@*/
void uberspark_uobjrtl_hw__generic_x86_32_intel__vtd_drhd_disable_pmr(VTD_DRHD *drhd);

/*@
	requires \valid(drhd);
	assigns \nothing;
@*/
void uberspark_uobjrtl_hw__generic_x86_32_intel__vtd_drhd_disable_translation(VTD_DRHD *drhd);

/*@
	requires \valid(drhd);
	assigns \nothing;
@*/
void uberspark_uobjrtl_hw__generic_x86_32_intel__vtd_drhd_enable_translation(VTD_DRHD *drhd);

/*@
	requires \valid(drhd);
	assigns \nothing;
@*/
bool uberspark_uobjrtl_hw__generic_x86_32_intel__vtd_drhd_initialize(VTD_DRHD *drhd);

/*@
	requires \valid(drhd);
	assigns \nothing;
@*/
bool uberspark_uobjrtl_hw__generic_x86_32_intel__vtd_drhd_invalidatecaches(VTD_DRHD *drhd);

/*@
	requires \valid(dmardevice);
	assigns \nothing;
@*/
uint64_t uberspark_uobjrtl_hw__generic_x86_32_intel__vtd_reg_read(VTD_DRHD *dmardevice, uint32_t reg);

/*@
	requires \valid(drhd);
	assigns \nothing;
@*/
void uberspark_uobjrtl_hw__generic_x86_32_intel__vtd_drhd_set_phm_base_and_limit(VTD_DRHD *drhd, uint64_t base, uint64_t limit);

/*@
	requires \valid(drhd);
	assigns \nothing;
@*/
void uberspark_uobjrtl_hw__generic_x86_32_intel__vtd_drhd_set_plm_base_and_limit(VTD_DRHD *drhd, uint32_t base, uint32_t limit);

/*@
	requires \valid(drhd);
	assigns \nothing;
@*/
bool uberspark_uobjrtl_hw__generic_x86_32_intel__vtd_drhd_set_root_entry_table(VTD_DRHD *drhd,  uint64_t ret_addr);

/*@
	requires \valid(dmardevice);
	assigns \nothing;
@*/
void uberspark_uobjrtl_hw__generic_x86_32_intel__vtd_reg_write(VTD_DRHD *dmardevice, uint32_t reg, uint64_t value);








/*@
  assigns \nothing;
@*/
CASM_FUNCDECL(uint32_t uberspark_uobjrtl_hw__generic_x86_32_intel__bsrl(uint32_t mask));


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
CASM_FUNCDECL(void uberspark_uobjrtl_hw__generic_x86_32_intel__getsec(uint32_t *eax, uint32_t *ebx, uint32_t *ecx, uint32_t *edx));


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
CASM_FUNCDECL(void uberspark_uobjrtl_hw__generic_x86_32_intel__cpuid(uint32_t op, uint32_t *eax, uint32_t *ebx, uint32_t *ecx, uint32_t *edx));


/*@
  assigns \nothing;
@*/
CASM_FUNCDECL(void uberspark_uobjrtl_hw__generic_x86_32_intel__wrmsr64(uint32_t msr, uint32_t newval_lo, uint32_t newval_hi));


/*@
  assigns \nothing;
@*/
CASM_FUNCDECL(uint64_t uberspark_uobjrtl_hw__generic_x86_32_intel__rdmsr64(uint32_t msr));


/*@
  assigns \nothing;
@*/
CASM_FUNCDECL(uint8_t uberspark_uobjrtl_hw__generic_x86_32_intel__sysmemaccess_readu8(uint32_t addr));


/*@
  assigns \nothing;
@*/
CASM_FUNCDECL(uint16_t uberspark_uobjrtl_hw__generic_x86_32_intel__sysmemaccess_readu16(uint32_t addr));


/*@
  assigns \nothing;
@*/
CASM_FUNCDECL(uint32_t uberspark_uobjrtl_hw__generic_x86_32_intel__sysmemaccess_readu32(uint32_t addr));

/*@
  assigns \nothing;
@*/
CASM_FUNCDECL(uint64_t uberspark_uobjrtl_hw__generic_x86_32_intel__sysmemaccess_readu64(uint32_t addr));

/*@
  assigns \nothing;
@*/
CASM_FUNCDECL(void uberspark_uobjrtl_hw__generic_x86_32_intel__sysmemaccess_writeu8(uint32_t addr, uint8_t val));

/*@
  assigns \nothing;
@*/
CASM_FUNCDECL(void uberspark_uobjrtl_hw__generic_x86_32_intel__sysmemaccess_writeu16(uint32_t addr, uint16_t val));

/*@
  assigns \nothing;
@*/
CASM_FUNCDECL(void uberspark_uobjrtl_hw__generic_x86_32_intel__sysmemaccess_writeu32(uint32_t addr, uint32_t val));

/*@
  assigns \nothing;
@*/
CASM_FUNCDECL(void uberspark_uobjrtl_hw__generic_x86_32_intel__sysmemaccess_writeu64(uint32_t addr, uint32_t val_lo, uint32_t val_hi));


/*@
  assigns \nothing;
@*/
CASM_FUNCDECL(void uberspark_uobjrtl_hw__generic_x86_32_intel__sysmemaccess_copy(uint8_t *dest, uint8_t *src, uint32_t size));


/*@
  assigns \nothing;
@*/
CASM_FUNCDECL(void uberspark_uobjrtl_hw__generic_x86_32_intel__sysmem_copy_sys2obj(uint8_t *objdst, uint8_t *syssrc, uint32_t size));


/*@
  assigns \nothing;
@*/
CASM_FUNCDECL(void uberspark_uobjrtl_hw__generic_x86_32_intel__sysmem_copy_obj2sys(uint8_t *sysdst, uint8_t *objsrc, uint32_t size));


/*@
  assigns \nothing;
@*/
CASM_FUNCDECL(uint64_t uberspark_uobjrtl_hw__generic_x86_32_intel__read_config_reg(uint32_t config_regs_base, uint32_t reg));

/*@
  assigns \nothing;
@*/
CASM_FUNCDECL(void uberspark_uobjrtl_hw__generic_x86_32_intel__write_config_reg(uint32_t config_regs_base, uint32_t reg, uint64_t val));




/*@
  assigns \nothing;
@*/
CASM_FUNCDECL(void uberspark_uobjrtl_hw__generic_x86_32_intel__outl(uint32_t val, uint32_t port));

/*@
  assigns \nothing;
@*/
CASM_FUNCDECL(void uberspark_uobjrtl_hw__generic_x86_32_intel__outw(uint32_t value, uint32_t port));


/*@
  assigns \nothing;
@*/
CASM_FUNCDECL(void uberspark_uobjrtl_hw__generic_x86_32_intel__outb(uint32_t value, uint32_t port));

/*@
  assigns \nothing;
@*/
CASM_FUNCDECL(uint32_t uberspark_uobjrtl_hw__generic_x86_32_intel__inl(uint32_t port));

/*@
  assigns \nothing;
@*/
CASM_FUNCDECL(uint16_t uberspark_uobjrtl_hw__generic_x86_32_intel__inw(uint32_t port));

/*@
  assigns \nothing;
  ensures 0 <= \result <= 255;
@*/
CASM_FUNCDECL(uint8_t uberspark_uobjrtl_hw__generic_x86_32_intel__inb(uint32_t port));





CASM_FUNCDECL(void uberspark_uobjrtl_hw__generic_x86_32_intel__disable_intr(void *noparam));
CASM_FUNCDECL(void uberspark_uobjrtl_hw__generic_x86_32_intel__enable_intr(void *noparam));
CASM_FUNCDECL(uint32_t uberspark_uobjrtl_hw__generic_x86_32_intel__getgdtbase(void *noparam));
CASM_FUNCDECL(uint32_t uberspark_uobjrtl_hw__generic_x86_32_intel__getidtbase(void *noparam));
CASM_FUNCDECL(uint64_t  uberspark_uobjrtl_hw__generic_x86_32_intel__gettssbase(void *noparam));


/*@
  assigns \nothing;
@*/
CASM_FUNCDECL(void uberspark_uobjrtl_hw__generic_x86_32_intel__hlt(void *noparam));



CASM_FUNCDECL(void uberspark_uobjrtl_hw__generic_x86_32_intel__relax(void *noparam));


CASM_FUNCDECL(uint64_t uberspark_uobjrtl_hw__generic_x86_32_intel__rdtsc64(void *noparam));
CASM_FUNCDECL(uint32_t uberspark_uobjrtl_hw__generic_x86_32_intel__read_eflags(void *noparam));

CASM_FUNCDECL(void uberspark_uobjrtl_hw__generic_x86_32_intel__write_eflags(uint32_t eflags));

CASM_FUNCDECL(uint64_t uberspark_uobjrtl_hw__generic_x86_32_intel__read_cr0(void *noparam));

CASM_FUNCDECL(void uberspark_uobjrtl_hw__generic_x86_32_intel__write_cr0(uint32_t val));

CASM_FUNCDECL(uint32_t uberspark_uobjrtl_hw__generic_x86_32_intel__read_cr2(void *noparam));
CASM_FUNCDECL(uint64_t uberspark_uobjrtl_hw__generic_x86_32_intel__read_cr3(void *noparam));
CASM_FUNCDECL(uint64_t uberspark_uobjrtl_hw__generic_x86_32_intel__read_rsp(void *noparam));
CASM_FUNCDECL(uint32_t uberspark_uobjrtl_hw__generic_x86_32_intel__read_esp(void *noparam));

CASM_FUNCDECL(void uberspark_uobjrtl_hw__generic_x86_32_intel__write_cr3(uint32_t val));

CASM_FUNCDECL(uint64_t uberspark_uobjrtl_hw__generic_x86_32_intel__read_cr4(void *noparam));

CASM_FUNCDECL(void uberspark_uobjrtl_hw__generic_x86_32_intel__write_cr4(uint32_t val));
//void skinit(unsigned long eax));

CASM_FUNCDECL(uint32_t uberspark_uobjrtl_hw__generic_x86_32_intel__read_segreg_cs(void *noparam));
CASM_FUNCDECL(uint32_t uberspark_uobjrtl_hw__generic_x86_32_intel__read_segreg_ds(void *noparam));
CASM_FUNCDECL(uint32_t uberspark_uobjrtl_hw__generic_x86_32_intel__read_segreg_es(void *noparam));
CASM_FUNCDECL(uint32_t uberspark_uobjrtl_hw__generic_x86_32_intel__read_segreg_fs(void *noparam));
CASM_FUNCDECL(uint32_t uberspark_uobjrtl_hw__generic_x86_32_intel__read_segreg_gs(void *noparam));
CASM_FUNCDECL(uint32_t uberspark_uobjrtl_hw__generic_x86_32_intel__read_segreg_ss(void *noparam));
CASM_FUNCDECL(uint32_t uberspark_uobjrtl_hw__generic_x86_32_intel__read_tr_sel(void *noparam));

CASM_FUNCDECL(void uberspark_uobjrtl_hw__generic_x86_32_intel__wbinvd(void *noparam));



CASM_FUNCDECL(uint64_t uberspark_uobjrtl_hw__generic_x86_32_intel__xgetbv(uint32_t xcr_reg));
CASM_FUNCDECL(void uberspark_uobjrtl_hw__generic_x86_32_intel__xsetbv(uint32_t xcr_reg, uint32_t value_lo, uint32_t value_hi));
//void sysexitq(uint64_t rip, uint64_t rsp));

/*@
  requires \valid(lock);
  assigns *lock;
@*/
CASM_FUNCDECL(void uberspark_uobjrtl_hw__generic_x86_32_intel__spin_lock(volatile uint32_t *lock));

/*@
  requires \valid(lock);
  assigns *lock;
@*/
CASM_FUNCDECL(void uberspark_uobjrtl_hw__generic_x86_32_intel__spin_unlock(volatile uint32_t *lock));

CASM_FUNCDECL(void uberspark_uobjrtl_hw__generic_x86_32_intel__loadGDT(arch_x86_gdtdesc_t *gdt_addr));
CASM_FUNCDECL(void uberspark_uobjrtl_hw__generic_x86_32_intel__loadTR(uint32_t tr_selector));
CASM_FUNCDECL(void uberspark_uobjrtl_hw__generic_x86_32_intel__loadIDT(arch_x86_idtdesc_t *idt_addr));



uint32_t uberspark_uobjrtl_hw__generic_x86_32_intel__getcpuvendor(void);


CASM_FUNCDECL(void uberspark_uobjrtl_hw__generic_x86_32_intel__reloadcs(uint32_t cs_sel));
CASM_FUNCDECL(void uberspark_uobjrtl_hw__generic_x86_32_intel__reloaddsregs(uint32_t ds_sel));





#endif //__ASSEMBLY__



//////xmhfhw_cpu_paging


#ifndef __ASSEMBLY__

CASM_FUNCDECL(void uberspark_uobjrtl_hw__generic_x86_32_intel__cache_wbinvd(void *noparam));
CASM_FUNCDECL(void uberspark_uobjrtl_hw__generic_x86_32_intel__tlb_invlpg(uint64_t addr));

#endif //__ASSEMBLY__





//////xmhfhw_cpu_vmx

#ifndef __ASSEMBLY__

CASM_FUNCDECL(bool uberspark_uobjrtl_hw__generic_x86_32_intel__vmx_vmxon(uint64_t vmxonregion_paddr));
CASM_FUNCDECL(void uberspark_uobjrtl_hw__generic_x86_32_intel__vmx_vmwrite(uint32_t encoding, uint32_t value));
CASM_FUNCDECL(uint32_t uberspark_uobjrtl_hw__generic_x86_32_intel__vmx_vmread(uint32_t encoding));
CASM_FUNCDECL(uint32_t uberspark_uobjrtl_hw__generic_x86_32_intel__vmx_vmclear(uint64_t vmcs));
CASM_FUNCDECL(uint32_t uberspark_uobjrtl_hw__generic_x86_32_intel__vmx_vmptrld(uint64_t vmcs));


CASM_FUNCDECL(void uberspark_uobjrtl_hw__generic_x86_32_intel__invvpid(uint32_t invalidation_type, uint32_t vpid, uint32_t linear_addr_lo, uint32_t linear_addr_hi));

/*@
	assigns \nothing;
@*/
CASM_FUNCDECL(uint32_t uberspark_uobjrtl_hw__generic_x86_32_intel__vmx_invept(uint32_t invalidation_type_lo, uint32_t invalidation_type_hi, uint32_t eptp_lo, uint32_t eptp_hi));

#endif //__ASSEMBLY__


















#endif // __UOBJRTL_HW__GENERIC_x86_32_INTEL_HW_H__
