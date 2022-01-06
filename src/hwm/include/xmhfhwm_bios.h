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

// XMHF HWM sysmem BIOS areas
// author: amit vasudevan (amitvasudevan@acm.org)

#ifndef __XMHFHWM_BIOS_H__
#define __XMHFHWM_BIOS_H__

#define ACPI_RSDP_SIGNATURE  (0x2052545020445352ULL) //"RSD PTR "
#define ACPI_FADT_SIGNATURE  (0x50434146)  //"FACP"
#define ACPI_MADT_SIGNATURE	 (0x43495041)			//"APIC"

#define ACPI_GAS_ASID_SYSMEMORY		0x0
#define ACPI_GAS_ASID_SYSIO				0x1
#define ACPI_GAS_ASID_PCI					0x2
#define ACPI_GAS_ASID_EC					0x3
#define ACPI_GAS_ASID_SMBUS				0x4
#define ACPI_GAS_ASID_FFHW				0x7F

#define ACPI_GAS_ACCESS_UNDEF			0x0
#define ACPI_GAS_ACCESS_BYTE			0x1
#define ACPI_GAS_ACCESS_WORD			0x2
#define ACPI_GAS_ACCESS_DWORD			0x3
#define ACPI_GAS_ACCESS_QWORD			0x4

//maximum number of RSDT entries we support
#define	ACPI_MAX_RSDT_ENTRIES		(64)


#define XMHFHWM_BIOS_BDA_BASE			0x400
#define XMHFHWM_BIOS_BDA_SIZE			256

#define XMHFHWM_BIOS_EBDA_BASE			0x9ec00
#define XMHFHWM_BIOS_EBDA_SIZE			1100

#define XMHFHWM_BIOS_ROMBASE			0xE0000
#define XMHFHWM_BIOS_ROMSIZE                    0x20020

#define XMHFHWM_BIOS_ACPIRSDPBASE		0xE0000

#define XMHFHWM_BIOS_ACPIRSDTBASE		0xd87ef028UL
#define XMHFHWM_BIOS_ACPIRSDTENTRIESBASE	(XMHFHWM_BIOS_ACPIRSDTBASE + 0x24)
#define XMHFHWM_BIOS_VTDDMARTABLEBASE		0xd87feea8UL
#define XMHFHWM_BIOS_VTDDMARTABLEREMAPPINGSTRUCTBASE		(XMHFHWM_BIOS_VTDDMARTABLEBASE+48)

#ifndef __ASSEMBLY__

//ACPI GAS, Generic Address Structure
typedef struct {
	uint8_t address_space_id;
	uint8_t register_bit_width;
	uint8_t register_bit_offset;
	uint8_t access_size;
	uint64_t address;
} __attribute__ ((packed)) ACPI_GAS;


//ACPI RSDP structure
typedef struct {
  uint64_t signature;
  uint8_t checksum;
  uint8_t oemid[6];
  uint8_t revision;
  uint32_t rsdtaddress;
  uint32_t length;
  uint64_t xsdtaddress;
  uint8_t xchecksum;
  uint8_t rsvd0[3];
} __attribute__ ((packed)) ACPI_RSDP;

//ACPI XSDT structure
typedef struct {
	uint32_t signature;
	uint32_t length;
	uint8_t revision;
	uint8_t checksum;
	uint8_t oemid[6];
	uint64_t oemtableid;
	uint32_t oemrevision;
	uint32_t creatorid;
	uint32_t creatorrevision;
} __attribute__ ((packed)) ACPI_XSDT;


//ACPI RSDT structure
typedef struct {
	uint32_t signature;
	uint32_t length;
	uint8_t revision;
	uint8_t checksum;
	uint8_t oemid[6];
	uint64_t oemtableid;
	uint32_t oemrevision;
	uint32_t creatorid;
	uint32_t creatorrevision;
} __attribute__ ((packed)) ACPI_RSDT;


/*
//ACPI RSDT structure for hwm
typedef struct {
	uint32_t signature;
	uint32_t length;
	uint8_t revision;
	uint8_t checksum;
	uint8_t oemid[6];
	uint64_t oemtableid;
	uint32_t oemrevision;
	uint32_t creatorid;
	uint32_t creatorrevision;
	uint32_t entries[ACPI_MAX_RSDT_ENTRIES];
} __attribute__ ((packed)) ACPI_RSDT_HWM;
*/



//ACPI MADT structure
typedef struct {
  uint32_t signature;
  uint32_t length;
  uint8_t revision;
  uint8_t checksum;
  uint8_t oemid[6];
  uint64_t oemtableid;
	uint32_t oemrevision;
	uint32_t creatorid;
	uint32_t creatorrevision;
	uint32_t lapicaddress;
	uint32_t mapicflags;
} __attribute__ ((packed)) ACPI_MADT;

//ACPI MADT APIC structure
typedef struct {
	uint8_t type;
	uint8_t length;
	uint8_t procid;
	uint8_t lapicid;
	uint32_t flags;
} __attribute__ ((packed)) ACPI_MADT_APIC;

//FADT structure
typedef struct{
  uint32_t signature;
  uint32_t length;
  uint8_t revision;
  uint8_t checksum;
  uint8_t oemid[6];
  uint64_t oemtableid;
	uint32_t oemrevision;
	uint32_t creatorid;
	uint32_t creatorrevision;
	uint32_t firmware_ctrl;
	uint32_t dsdt;
	uint8_t rsvd0;
	uint8_t preferred_pm_profile;
	uint16_t sci_int;
	uint32_t smi_cmd;
	uint8_t acpi_enable;
	uint8_t acpi_disable;
	uint8_t s4bios_req;
	uint8_t pstate_cnt;
	uint32_t pm1a_evt_blk;
	uint32_t pm1b_evt_blk;
	uint32_t pm1a_cnt_blk;
	uint32_t pm1b_cnt_blk;
	uint32_t pm2_cnt_blk;
	uint32_t pm_tmr_blk;
	uint32_t gpe0_blk;
	uint32_t gpe1_blk;
	uint8_t pm1_evt_len;
	uint8_t pm1_cnt_len;
	uint8_t pm2_cnt_len;
	uint8_t pm_tmr_len;
	uint8_t gpe0_blk_len;
	uint8_t gpe1_blk_len;
	uint8_t gpe1_base;
	uint8_t cst_cnt;
	uint16_t p_lvl2_lat;
	uint16_t p_lvl3_lat;
	uint16_t flushsize;
	uint16_t flushstride;
	uint8_t duty_offset;
	uint8_t duty_width;
	uint8_t day_alrm;
	uint8_t mon_alrm;
	uint8_t century;
	uint16_t iapc_boot_arch;
	uint8_t rsvd1;
	uint32_t flags;
	uint8_t reset_reg[12];
	uint8_t reset_value;
	uint8_t rsvd2[3];
	uint64_t x_firmware_ctrl;
	uint64_t x_dsdt;
	uint8_t x_pm1a_evt_blk[12];
	uint8_t x_pm1b_evt_blk[12];
	uint8_t x_pm1a_cnt_blk[12];
	uint8_t x_pm1b_cnt_blk[12];
	uint8_t x_pm2_cnt_blk[12];
	uint8_t x_pm_tmr_blk[12];
	uint8_t x_gpe0_blk[12];
	uint8_t x_gpe1_blk[12];
}__attribute__ ((packed)) ACPI_FADT;




#endif	//__ASSEMBLY__

//from _biosdata.h

#ifndef __ASSEMBLY__

//SMP configuration table signatures on x86 platforms
#define MPFP_SIGNATURE 					(0x5F504D5FUL) //"_MP_"
#define MPCONFTABLE_SIGNATURE 			(0x504D4350UL)  //"PCMP"

typedef struct {
  uint32_t signature;
  uint32_t paddrpointer;
  uint8_t length;
  uint8_t spec_rev;
  uint8_t checksum;
  uint8_t mpfeatureinfo1;
  uint8_t mpfeatureinfo2;
  uint8_t mpfeatureinfo3;
  uint8_t mpfeatureinfo4;
  uint8_t mpfeatureinfo5;
} __attribute__ ((packed)) MPFP;

typedef struct{
  uint32_t signature;
  uint16_t length;
  uint8_t spec_rev;
  uint8_t checksum;
  uint8_t oemid[8];
  uint8_t productid[12];
  uint32_t oemtableptr;
  uint16_t oemtablesize;
  uint16_t entrycount;
  uint32_t lapicaddr;
  uint16_t exttablelength;
  uint16_t exttablechecksum;
} __attribute__ ((packed)) MPCONFTABLE;

typedef struct {
  uint8_t entrytype;
  uint8_t lapicid;
  uint8_t lapicver;
  uint8_t cpuflags;
  uint32_t cpusig;
  uint32_t featureflags;
  uint32_t res0;
  uint32_t res1;
} __attribute__ ((packed)) MPENTRYCPU;


bool _impl_xmhfhwm_bios_read(uint32_t sysmemaddr, sysmem_read_t readsize, uint64_t *read_result);
bool _impl_xmhfhwm_bios_write(uint32_t sysmemaddr, sysmem_write_t writesize, uint64_t write_value);
bool _impl_xmhfhwm_bios_sysmemcopy(sysmem_copy_t sysmemcopy_type,
				uint32_t dstaddr, uint32_t srcaddr, uint32_t size);



#endif	//__ASSEMBLY__



#endif //__XMHFHWM_BIOS_H__
