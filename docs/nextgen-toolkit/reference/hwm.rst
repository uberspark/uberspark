.. include:: /macros.rst


.. _reference-hwm-intro:

|uspark| Hardware Model
=======================

The |uberspark| HWM consists of various hardware component models such as the CPU, memory, I/O devices, and associated hardware-conduit end-points. 

Below are the currently modeled hardware components and their interfaces (indicated by a bullet point).

Architecture specific modeling
------------------------------
``arch``
    ``x86``
        ``generic``
            * ``Generic x86 CPU Model``
                * ``void _impl__casm__hlt(void)``
                * ``void _impl__casm__pushl_mesp(int index)``
                * ``void _impl__casm__pushl_mem(uint32_t value)``
                * ``uint32_t _impl__casm__popl_mem(void)``
                * ``void _impl__casm__addl_imm_esp(uint32_t value)``
                * ``void _impl__casm__movl_mesp_eax(uint32_t index)``
                * ``void _impl__casm__movl_mesp_ebx(int index)``
                * ``void _impl__casm__cmpl_imm_meax(uint32_t value, int index)``
                * ``void _impl__casm__movl_imm_meax(uint32_t value, int index)``
                * ``void _impl__casm__movl_meax_edx(int index)``
                * ``void _impl__casm__movl_meax_ecx(int index)``
                * ``void _impl__casm__movl_ecx_meax(int index)``
                * ``void _impl__casm__movl_edx_meax(int index)``
                * ``void _impl__casm__bsrl_mesp_eax(int index)``
                * ``void _impl__casm__pushl_ebx(void)``
                * ``void _impl__casm__pushl_esi(void)``
                * ``void _impl__casm__movl_mesp_ecx(int index)``
                * ``void _impl__casm__movl_mesp_edx(int index)``
                * ``void _impl__casm__movl_eax_ebx(void)``
                * ``void _impl__casm__movl_eax_edi(void)``
                * ``void _impl__casm__movl_mebx_ebx(int index)``
                * ``void _impl__casm__movl_mecx_ecx(int index)``
                * ``void _impl__casm__movl_medx_edx(int index)``
                * ``void _impl__casm__cpuid(void)``
                * ``void _impl__casm__movl_mesp_esi(int index)``
                * ``void _impl__casm__movl_eax_mesi(int index)``
                * ``void _impl__casm__movl_ebx_mesi(int index)``
                * ``void _impl__casm__movl_ecx_mesi(int index)``
                * ``void _impl__casm__movl_edx_mesi(int index)``
                * ``void _impl__casm__popl_eax(void)``
                * ``void _impl__casm__popl_esi(void)``
                * ``void _impl__casm__popl_ebx(void)``
                * ``void _impl__casm__cli(void)``
                * ``void _impl__casm__sti(void)``
                * ``void _impl__casm__subl_imm_esp(uint32_t value)``
                * ``void _impl__casm__sgdt_mesp(int index)``
                * ``void _impl__casm__xorl_eax_eax(void)``
                * ``void _impl__casm__xorl_edx_edx(void)``
                * ``void _impl__casm__sidt_mesp(int index)``
                * ``void _impl__casm__getsec(void)``
                * ``void _impl__casm__str_ax(void)``
                * ``void _impl__casm__addl_eax_ecx(void)``
                * ``void _impl__casm__addl_eax_esp(void)``
                * ``void _impl__casm__movl_mecx_eax(int index)``
                * ``void _impl__casm__movl_mecx_edx(int index)``
                * ``void _impl__casm__addl_imm_ecx(uint32_t value)``
                * ``void _impl__casm__movl_edx_ecx(void)``
                * ``void _impl__casm__movl_eax_ecx(void)``
                * ``void _impl__casm__andl_imm_edx(uint32_t value)``
                * ``void _impl__casm__andl_imm_ecx(uint32_t value)``
                * ``void _impl__casm__shl_imm_ecx(uint32_t value)``
                * ``void _impl__casm__shr_imm_eax(uint32_t value)``
                * ``void _impl__casm__orl_imm_eax(uint32_t value)``
                * ``void _impl__casm__orl_ecx_eax(void)``
                * ``void _impl__casm__orl_edx_eax(void)``
                * ``void _impl__casm__inb_dx_al(void)``
                * ``void _impl__casm__inl_dx_eax(void)``
                * ``void _impl__casm__movl_eax_mesp(int index)``
                * ``void _impl__casm__movl_imm_mesp(uint32_t value, int index)``
                * ``void _impl__casm__invept_mesp_edx(int index)``
                * ``void _impl__casm__invvpid_mesp_edx(int index)``
                * ``void _impl__casm__movw_mesp_ax(int index)``
                * ``void _impl__casm__movl_imm_eax(uint32_t value)``
                * ``void _impl__casm__movl_imm_esp(uint32_t value)``
                * ``void _impl__casm__movl_imm_esi(uint32_t value)``
                * ``void _impl__casm__movl_imm_ecx(uint32_t value)``
                * ``void _impl__casm__movl_imm_edx(uint32_t value)``
                * ``void _impl__casm__movl_imm_ebx(uint32_t value)``
                * ``void _impl__casm__invvpid_mesp_ecx(int index)``
                * ``void _impl__casm__inw_dx_ax(void)``
                * ``void _impl__casm__lgdt_mecx(int index)``
                * ``void _impl__casm__lidt_mecx(int index)``
                * ``void _impl__casm__ltr_ax(void)``
                * ``void _impl__casm__outb_al_dx(void)``
                * ``void _impl__casm__outl_eax_dx(void)``
                * ``void _impl__casm__outw_ax_dx(void)``
                * ``void _impl__casm__pause(void)``
                * ``void _impl__casm__rdmsr(void)``
                * ``void _impl__casm__rdtsc(void)``
                * ``void _impl__casm__movl_cr0_eax(void)``
                * ``void _impl__casm__movl_cr2_eax(void)``
                * ``void _impl__casm__movl_cr3_eax(void)``
                * ``void _impl__casm__movl_cr4_eax(void)``
                * ``void _impl__casm__movl_esp_eax(void)``
                * ``void _impl__casm__pushfl(void)``
                * ``void _impl__casm__movl_cs_eax(void)``
                * ``void _impl__casm__movl_ds_eax(void)``
                * ``void _impl__casm__movl_es_eax(void)``
                * ``void _impl__casm__movl_fs_eax(void)``
                * ``void _impl__casm__movl_gs_eax(void)``
                * ``void _impl__casm__movl_ss_eax(void)``
                * ``void _impl__casm__btl_imm_mecx(uint32_t value, int index)``
                * ``void _impl__casm__btrl_imm_mecx(uint32_t value, int index)``
                * ``void _impl__casm__btsl_imm_mecx(uint32_t value, int index)``
                * ``void _impl__casm__vmxon_mesp(int index)``
                * ``void _impl__casm__vmwrite_eax_ecx(void)``
                * ``void _impl__casm__vmread_ecx_eax(void)``
                * ``void _impl__casm__vmclear_mesp(int index)``
                * ``void _impl__casm__vmptrld_mesp(int index)``
                * ``void _impl__casm__wbinvd(void)``
                * ``void _impl__casm__movl_eax_cr0(void)``
                * ``void _impl__casm__movl_eax_cr3(void)``
                * ``void _impl__casm__movl_ebx_cr3(void)``
                * ``void _impl__casm__movl_eax_cr4(void)``
                * ``void _impl__casm__popfl(void)``
                * ``void _impl__casm__wrmsr(void)``
                * ``void _impl__casm__xgetbv(void)``
                * ``void _impl__casm__xsetbv(void)``
                * ``void _impl__casm__pushl_edi(void)``
                * ``void _impl__casm__movl_mesp_edi(int index)``
                * ``void _impl__casm__cld(void)``
                * ``void _impl__casm__rep_movsb(void)``
                * ``void _impl__casm__popl_edi(void)``
                * ``void _impl__casm__andl_imm_eax(uint32_t value)``
                * ``void _impl__casm__movl_mesi_eax(int index)``
                * ``void _impl__casm__movl_mesi_edx(uint32_t index)``
                * ``void _impl__casm__movb_al_mesi(int index)``
                * ``void _impl__casm__movw_ax_mesi(int index)``
                * ``void _impl__casm__pushl_ebp(void)``
                * ``void _impl__casm__movl_esp_edx(void)``
                * ``void _impl__casm__pushl_eax(void)``
                * ``void _impl__casm__pushl_edx(void)``
                * ``void _impl__casm__pushl_edx(void)``
                * ``void _impl__casm__movl_edx_esp(void)``
                * ``void _impl__casm__popl_ebp(void)``
                * ``void _impl__casm__pushl_ecx(void)``
                * ``void _impl__casm__movl_eax_esp(void)``
                * ``void _impl__casm__pushl_esp(void)``
                * ``void _impl__casm__pushl_imm(uint32_t value)``
                * ``void _impl__casm__popl_edx(void)``
                * ``void _impl__casm__movl_esp_ecx(void)``
                * ``void _impl__casm__vmlaunch(void)``
                * ``void _impl__casm__pushal(void)``
                * ``void _impl__casm__movw_imm_ax(uint16_t value)``
                * ``void  _impl__casm__movw_ax_ds(void)``
                * ``void  _impl__casm__movw_ax_es(void)``
                * ``void  _impl__casm__movw_ax_fs(void)``
                * ``void  _impl__casm__movw_ax_gs(void)``
                * ``void  _impl__casm__movw_ax_ss(void)``
                * ``void _impl__casm__movl_meax_edi(int index)``
                * ``void _impl__casm__movl_meax_ebp(int index)``
                * ``void _impl__casm__movl_meax_ebx(int index)``
                * ``void _impl__casm__movl_meax_eax(int index)``
                * ``void _impl__casm__movl_meax_esp(int index)``
                * ``void  _impl__casm__vmresume(void)``
                * ``void _impl__casm__movl_meax_esi(int index)``
                * ``void _impl__casm__iretl(void)``
                * ``void  _impl__casm__movw_ds_ax(void)``
                * ``void _impl__casm__addl_imm_eax(uint32_t value)``
                * ``void _impl__casm__rep_movsb_sysmem(sysmem_copy_t sysmemcopy_type)``
                * ``void _impl__casm__mull_ecx(void)``
                * ``void _impl__casm__addl_ecx_eax(void)``
            * ``Generic x86 Lapic Model`` 
                * ``bool _impl_hwm_lapic_read(uint32_t sysmemaddr, sysmem_read_t readsize, uint64_t *read_result)``
                * ``bool _impl_hwm_lapic_write(uint32_t sysmemaddr, sysmem_write_t writesize, uint64_t write_value)``

            * ``Generic x86 Memory Model`` 
                * ``_impl_hwm_mem_read(uint32_t sysmemaddr, sysmem_read_t readsize, uint64_t *read_result)``
                * ``_impl_hwm_mem_write(uint32_t sysmemaddr, sysmem_write_t writesize, uint64_t write_value)``
                * ``_impl_hwm_mem_sysmemcopy(sysmem_copy_t sysmemcopy_type, uint32_t dstaddr, uint32_t srcaddr, uint32_t size)``

            * ``Generic x86 CASM Instructions Model``

    ``x86_32``
        ``intel``
            * ``Intel 32-bit TXT Model``
                * ``bool _impl_hwm_txt_read(uint32_t sysmemaddr, sysmem_read_t readsize, uint64_t *read_result)``
                * ``bool _impl_hwm_txt_write(uint32_t sysmemaddr, sysmem_write_t writesize, uint64_t write_value)``
                * ``bool _impl_hwm_txt_sysmemcopy(sysmem_copy_t sysmemcopy_type, uint32_t dstaddr, uint32_t srcaddr, uint32_t size)``

Device specific modeling
------------------------
``device``
    ``iommu``
        ``intel``
            * ``Intel VT-d Model``
                * ``bool _impl_hwm_vtd_read(uint32_t sysmemaddr, sysmem_read_t readsize, uint64_t *read_result)``
                * ``bool _impl_hwm_vtd_write(uint32_t sysmemaddr, sysmem_write_t writesize, uint64_t write_value)``
    ``net``
        ``ethernet``
            ``intel``
                * ``Intel E1000 Device Model``
                    * ``bool _impl_hwm_e1000_read(uint32_t sysmemaddr, sysmem_read_t readsize, uint64_t *read_result)``
                    * ``bool _impl_hwm_e1000_write(uint32_t sysmemaddr, sysmem_write_t writesize, uint64_t write_value)``
    ``pci``
        * ``Legacy I/O PCI Model``



Platform specific modeling
--------------------------

``platform``
    ``pc``
        * ``PC BIOS Model``
            * ``bool _impl_hwm_bios_read(uint32_t sysmemaddr, sysmem_read_t readsize, uint64_t *read_result)``
            * ``bool _impl_hwm_bios_write(uint32_t sysmemaddr, sysmem_write_t writesize, uint64_t write_value)``
            * ``bool _impl_hwm_bios_sysmemcopy(sysmem_copy_t sysmemcopy_type, uint32_t dstaddr, uint32_t srcaddr, uint32_t size)``

