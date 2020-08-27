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

// XMHF HWM MMIO VTd decls.
//author: amit vasudevan (amitvasudevan@acm.org)

#ifndef __HWM_DEVICE_IOMMU_INTEL__VTD_H___
#define __HWM_DEVICE_IOMMU_INTEL__VTD_H___

#define VTD_DMAR_SIGNATURE  (0x52414D44) //"DMAR"
#define VTD_MAX_DRHD   8		//maximum number of DMAR h/w units

//VT-d register offsets (sec. 10.4, Intel_VT_for_Direct_IO)
#define VTD_VER_REG_OFF 		0x000				//arch. version (32-bit)
#define VTD_CAP_REG_OFF 		0x008				//h/w capabilities (64-bit)
#define VTD_ECAP_REG_OFF  	0x010				//h/w extended capabilities (64-bit)
#define VTD_GCMD_REG_OFF  	0x018				//global command (32-bit)
#define VTD_GSTS_REG_OFF  	0x01C				//global status (32-bit)
#define VTD_RTADDR_REG_OFF  0x020				//root-entry table address (64-bit)
#define VTD_CCMD_REG_OFF  	0x028				//manage context-entry cache (64-bit)
#define VTD_FSTS_REG_OFF  	0x034				//report fault/error status (32-bit)
#define VTD_FECTL_REG_OFF 	0x038				//interrupt control (32-bit)

#define VTD_PMEN_REG_OFF  	0x064				//enable DMA protected memory regions (32-bits)

#define VTD_PLMBASE_REG_OFF	0x068				//protected low memory base register (32-bits)
#define VTD_PLMLIMIT_REG_OFF	0x6C			//protected low memory limit register (32-bits)

#define VTD_PHMBASE_REG_OFF	0x070				//protected high memory base register (64-bits)
#define VTD_PHMLIMIT_REG_OFF	0x78			//protected high memory limit register (64-bits)

#define VTD_IVA_REG_OFF  		0x0DEAD  		//invalidate address register (64-bits)
																				//note: the offset of this register is computed
                                    		//at runtime for a specified DMAR device
#define VTD_IOTLB_REG_OFF   0x0BEEF     //IOTLB invalidate register (64-bits)
																				//note: the offset is VTD_IVA_REG_OFF + 8 and
																				//computed at runtime for a specified DMAR device


//VT-d register access types (custom definitions)
#define VTD_REG_READ  			0xaa				//read VTD register
#define VTD_REG_WRITE 			0xbb				//write VTD register

//Vt-d register access widths (custom definitions)
#define VTD_REG_32BITS  		0x32ff
#define VTD_REG_64BITS  		0x64ff

//Vt-d page-table bits
#define VTD_RET_PRESENT                     (1UL << 0)
#define VTD_CET_PRESENT                     (1UL << 0)
#define VTD_PAGE_READ						(1UL << 0)
#define VTD_PAGE_WRITE						(1UL << 1)
#define VTD_PAGE_EXECUTE                    (1UL << 2)
#define VTD_PAGE_SUPER      			    (1UL << 7)

//vt-d page table page walk lengths
#define VTD_PAGEWALK_3LEVEL     (0x3)
#define VTD_PAGEWALK_4LEVEL     (0x4)
#define VTD_PAGEWALK_NONE       (0x0)

#define VTD_RET_MAXPTRS         (256)
#define VTD_CET_MAXPTRS         (256)

//vt-d page table max entries
#define VTD_PTRS_PER_PML4T          1
#define VTD_MAXPTRS_PER_PML4T       512

#define VTD_PTRS_PER_PDPT           4
#define VTD_MAXPTRS_PER_PDPT        512

#define VTD_PTRS_PER_PDT            512

#define VTD_PTRS_PER_PT             512



#ifndef __ASSEMBLY__

//Vt-d DMAR structure
//sizeof(VTD_DMAR) = 48 bytes
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
  uint8_t hostaddresswidth;
  uint8_t flags;
  uint8_t rsvdz[10];
}__attribute__ ((packed)) VTD_DMAR;



//VT-d DMAR table DRHD structure
//sizeof(VTD_DMAR_DRHD) = 16 bytes
typedef struct{
  uint16_t type;
  uint16_t length;
  uint8_t flags;
  uint8_t rsvdz0;
  uint16_t pcisegment;
  uint64_t regbaseaddr;
}__attribute__ ((packed)) VTD_DMAR_DRHD;


//VT-d DRHD structure
typedef struct{
  uint16_t type;
  uint16_t length;
  uint8_t flags;
  uint8_t rsvdz0;
  uint16_t pcisegment;
  uint64_t regbaseaddr;
  uint32_t iotlb_regaddr;    //not part of ACPI structure
  uint32_t iva_regaddr;      //not part of ACPI structure
}__attribute__ ((packed)) VTD_DRHD;

typedef uint32_t vtd_drhd_handle_t;

typedef struct {
    uint64_t qwords[2];
} __attribute__((packed)) vtd_ret_entry_t;

//#define vtd_make_rete(paddr, flags) \
//  ((uint64_t)(paddr) & (~(((uint64_t)PAGE_SIZE_4K - 1)))) | (uint64_t)(flags)

#define vtd_make_rete(paddr, flags) \
  ((uint64_t)(paddr) & (0xFFFFFFFFFFFFF000ULL)) | (uint64_t)(flags)

typedef struct {
    uint64_t qwords[2];
} __attribute__((packed)) vtd_cet_entry_t;

//#define vtd_make_cete(paddr, flags) \
//  ((uint64_t)(paddr) & (~(((uint64_t)PAGE_SIZE_4K - 1)))) | (uint64_t)(flags)

#define vtd_make_cete(paddr, flags) \
  ((uint64_t)(paddr) & (0x7FFFFFFFFFFFF000ULL)) | (uint64_t)(flags)

//#define vtd_make_cetehigh(address_width, domain_id) \
//  (((uint64_t)domain_id & 0x000000000000FFFFULL) << 7) | ((uint64_t)(address_width) & 0x0000000000000007ULL)

#define vtd_make_cetehigh(address_width, domain_id) \
  (((uint64_t)domain_id) * 256) | ((uint64_t)(address_width) & 0x0000000000000007ULL)

//#define vtd_make_cetehigh(address_width, domain_id) \
//  (((uint64_t)1) * 256) | ((uint64_t)(address_width) & 0x0000000000000007ULL)

typedef uint64_t vtd_pml4te_t;
typedef uint64_t vtd_pdpte_t;
typedef uint64_t vtd_pdte_t;
typedef uint64_t vtd_pte_t;


/* make a pml4 entry from individual fields */
//#define vtd_make_pml4te(paddr, flags) \
//  ((uint64_t)(paddr) & (~(((uint64_t)PAGE_SIZE_4K - 1)))) | (uint64_t)(flags)

#define vtd_make_pml4te(paddr, flags) \
  ((uint64_t)(paddr) & (0x7FFFFFFFFFFFF000ULL)) | (uint64_t)(flags)

/* make a page directory pointer entry from individual fields */
//#define vtd_make_pdpte(paddr, flags) \
//  ((uint64_t)(paddr) & (~(((uint64_t)PAGE_SIZE_4K - 1)))) | (uint64_t)(flags)

#define vtd_make_pdpte(paddr, flags) \
  ((uint64_t)(paddr) & (0x7FFFFFFFFFFFF000ULL)) | (uint64_t)(flags)

/* make a page directory entry for a 4KB page from individual fields */
//#define vtd_make_pdte(paddr, flags) \
//  ((uint64_t)(paddr) & (~(((uint64_t)PAGE_SIZE_4K - 1)))) | (uint64_t)(flags)

#define vtd_make_pdte(paddr, flags) \
  ((uint64_t)(paddr) & (0x7FFFFFFFFFFFF000ULL)) | (uint64_t)(flags)


/* make a page table entry from individual fields */
//#define vtd_make_pte(paddr, flags) \
//  ((uint64_t)(paddr) & (~(((uint64_t)PAGE_SIZE_4K - 1)))) | (uint64_t)(flags)

#define vtd_make_pte(paddr, flags) \
  ((uint64_t)(paddr) & (0x7FFFFFFFFFFFF000ULL)) | (uint64_t)(flags)



//------------------------------------------------------------------------------
//VT-d register structure definitions

/*//VTD_VER_REG (sec. 10.4.1)
typedef union {
  uint32_t value;
  struct
  {
    uint32_t min : 4;			//minor version no.
    uint32_t max : 4;			//major version no.
    uint32_t rsvdz : 24;		//reserved
  } __attribute__((packed)) bits;
} __attribute__ ((packed)) VTD_VER_REG;
*/

//VTD_CAP_REG (sec. 10.4.2)
typedef struct {
    uint32_t nd      ;//: 3;    		//no. of domains
    uint32_t afl     ;//: 1;			//advanced fault logging
    uint32_t rwbf    ;//: 1;			//required write-buffer flushing
    uint32_t plmr    ;//: 1;			//protected low-memory region
    uint32_t phmr    ;//: 1;			//protected high-memory region
    uint32_t cm      ;//: 1;				//caching mode
    uint32_t sagaw   ;//: 5;			//supported adjuested guest address widths
    uint32_t rsvdz0  ;//: 3;		//reserved
    uint32_t mgaw    ;//: 6;			//maximum guest address width
    uint32_t zlr     ;//: 1;				//zero length read
    uint32_t isoch   ;//: 1;			//isochrony
    uint32_t fro     ;//: 10;			//fault-recording register offset
    uint32_t sps     ;//: 4;			//super-page support
    uint32_t rsvdz1  ;//: 1;		//reserved
    uint32_t psi     ;//: 1;				//page selective invalidation
    uint32_t nfr     ;//: 8;				//no. of fault-recording registers
    uint32_t mamv    ;//: 6;			//max. address mask value
    uint32_t dwd     ;//: 1;				//DMA write draining
    uint32_t drd     ;//: 1;				//DMA read draining
    uint32_t rsvdz2  ;//: 8;		//reserved
} __attribute__ ((packed)) VTD_CAP_REG;


#define pack_VTD_CAP_REG(s) \
    (uint64_t)( \
    (((uint64_t)(s)->rsvdz2 &   0x00000000000000FFULL) << 56) | \
    (((uint64_t)(s)->drd    &   0x0000000000000001ULL) << 55) | \
    (((uint64_t)(s)->dwd    &   0x0000000000000001ULL) << 54) | \
    (((uint64_t)(s)->mamv   &   0x000000000000003FULL) << 48) | \
    (((uint64_t)(s)->nfr    &   0x00000000000000FFULL) << 40) | \
    (((uint64_t)(s)->psi    &   0x0000000000000001ULL) << 39) | \
    (((uint64_t)(s)->rsvdz1 &   0x0000000000000001ULL) << 38) | \
    (((uint64_t)(s)->sps    &   0x000000000000000FULL) << 34) | \
    (((uint64_t)(s)->fro    &   0x00000000000003FFULL) << 24) | \
    (((uint64_t)(s)->isoch  &   0x0000000000000001ULL) << 23) | \
    (((uint64_t)(s)->zlr    &   0x0000000000000001ULL) << 22) | \
    (((uint64_t)(s)->mgaw   &   0x000000000000003FULL) << 16) | \
    (((uint64_t)(s)->rsvdz0 &   0x0000000000000007ULL) << 13) | \
    (((uint64_t)(s)->sagaw  &   0x000000000000001FULL) << 8 ) | \
    (((uint64_t)(s)->cm     &   0x0000000000000001ULL) << 7 ) | \
    (((uint64_t)(s)->phmr   &   0x0000000000000001ULL) << 6 ) | \
    (((uint64_t)(s)->plmr   &   0x0000000000000001ULL) << 5 ) | \
    (((uint64_t)(s)->rwbf   &   0x0000000000000001ULL) << 4 ) | \
    (((uint64_t)(s)->afl    &   0x0000000000000001ULL) << 3 ) | \
    (((uint64_t)(s)->nd     &   0x0000000000000007ULL) << 0 )  \
    )

#define unpack_VTD_CAP_REG(s, value) \
    (s)->rsvdz2     = (uint32_t)(((uint64_t)value >>  56 ) & 0x00000000000000FFULL); \
    (s)->drd        = (uint32_t)(((uint64_t)value >>  55 ) & 0x0000000000000001ULL); \
    (s)->dwd        = (uint32_t)(((uint64_t)value >>  54 ) & 0x0000000000000001ULL); \
    (s)->mamv       = (uint32_t)(((uint64_t)value >>  48 ) & 0x000000000000003FULL); \
    (s)->nfr        = (uint32_t)(((uint64_t)value >>  40 ) & 0x00000000000000FFULL); \
    (s)->psi        = (uint32_t)(((uint64_t)value >>  39 ) & 0x0000000000000001ULL); \
    (s)->rsvdz1     = (uint32_t)(((uint64_t)value >>  38 ) & 0x0000000000000001ULL); \
    (s)->sps        = (uint32_t)(((uint64_t)value >>  34 ) & 0x000000000000000FULL); \
    (s)->fro        = (uint32_t)(((uint64_t)value >>  24 ) & 0x00000000000003FFULL); \
    (s)->isoch      = (uint32_t)(((uint64_t)value >>  23 ) & 0x0000000000000001ULL); \
    (s)->zlr        = (uint32_t)(((uint64_t)value >>  22 ) & 0x0000000000000001ULL); \
    (s)->mgaw       = (uint32_t)(((uint64_t)value >>  16 ) & 0x000000000000003FULL); \
    (s)->rsvdz0     = (uint32_t)(((uint64_t)value >>  13 ) & 0x0000000000000007ULL); \
    (s)->sagaw      = (uint32_t)(((uint64_t)value >>  8  ) & 0x000000000000001FULL); \
    (s)->cm         = (uint32_t)(((uint64_t)value >>  7  ) & 0x0000000000000001ULL); \
    (s)->phmr       = (uint32_t)(((uint64_t)value >>  6  ) & 0x0000000000000001ULL); \
    (s)->plmr       = (uint32_t)(((uint64_t)value >>  5  ) & 0x0000000000000001ULL); \
    (s)->rwbf       = (uint32_t)(((uint64_t)value >>  4  ) & 0x0000000000000001ULL); \
    (s)->afl        = (uint32_t)(((uint64_t)value >>  3  ) & 0x0000000000000001ULL); \
    (s)->nd         = (uint32_t)(((uint64_t)value >>  0  ) & 0x0000000000000007ULL);



//VTD_ECAP_REG (sec. 10.4.3)
typedef struct {
    uint32_t c       ;//:1;					//coherency
    uint32_t qi      ;//:1;					//queued invalidation support
    uint32_t di      ;//:1;					//device IOTLB support
    uint32_t ir      ;//:1;					//interrupt remapping support
    uint32_t eim     ;//:1;				//extended interrupt mode
    uint32_t ch      ;//:1;					//caching hints
    uint32_t pt      ;//:1;					//pass through
    uint32_t sc      ;//:1;					//snoop control
    uint32_t iro     ;//:10;				//IOTLB register offset
    uint32_t rsvdz0  ;//: 2;		//reserved
    uint32_t mhmv    ;//: 4;			//maximum handle mask value
    uint32_t rsvdz1  ;//: 32;		//reserved
    uint32_t rsvdz2  ;//: 8;		//reserved
} __attribute__ ((packed)) VTD_ECAP_REG;

#define pack_VTD_ECAP_REG(s) \
    (uint64_t)( \
    (((uint64_t)(s)->rsvdz2 &   0x00000000000000FFULL) << 56) | \
    (((uint64_t)(s)->rsvdz1 &   0x00000000FFFFFFFFULL) << 24) | \
    (((uint64_t)(s)->mhmv   &   0x000000000000000FULL) << 20) | \
    (((uint64_t)(s)->rsvdz0 &   0x0000000000000003ULL) << 18) | \
    (((uint64_t)(s)->iro    &   0x00000000000003FFULL) << 8 ) | \
    (((uint64_t)(s)->sc     &   0x0000000000000001ULL) << 7 ) | \
    (((uint64_t)(s)->pt     &   0x0000000000000001ULL) << 6 ) | \
    (((uint64_t)(s)->ch     &   0x0000000000000001ULL) << 5 ) | \
    (((uint64_t)(s)->eim    &   0x0000000000000001ULL) << 4 ) | \
    (((uint64_t)(s)->ir     &   0x0000000000000001ULL) << 3 ) | \
    (((uint64_t)(s)->di     &   0x0000000000000001ULL) << 2 ) | \
    (((uint64_t)(s)->qi     &   0x0000000000000001ULL) << 1 ) | \
    (((uint64_t)(s)->c      &   0x0000000000000001ULL) << 0 )  \
    )

#define unpack_VTD_ECAP_REG(s, value) \
    (s)->rsvdz2     = (uint32_t)(((uint64_t)value >>  56 ) & 0x00000000000000FFULL); \
    (s)->rsvdz1     = (uint32_t)(((uint64_t)value >>  24 ) & 0x00000000FFFFFFFFULL); \
    (s)->mhmv       = (uint32_t)(((uint64_t)value >>  20 ) & 0x000000000000000FULL); \
    (s)->rsvdz0     = (uint32_t)(((uint64_t)value >>  18 ) & 0x0000000000000003ULL); \
    (s)->iro        = (uint32_t)(((uint64_t)value >>  8  ) & 0x00000000000003FFULL); \
    (s)->sc         = (uint32_t)(((uint64_t)value >>  7  ) & 0x0000000000000001ULL); \
    (s)->pt         = (uint32_t)(((uint64_t)value >>  6  ) & 0x0000000000000001ULL); \
    (s)->ch         = (uint32_t)(((uint64_t)value >>  5  ) & 0x0000000000000001ULL); \
    (s)->eim        = (uint32_t)(((uint64_t)value >>  4  ) & 0x0000000000000001ULL); \
    (s)->ir         = (uint32_t)(((uint64_t)value >>  3  ) & 0x0000000000000001ULL); \
    (s)->di         = (uint32_t)(((uint64_t)value >>  2  ) & 0x0000000000000001ULL); \
    (s)->qi         = (uint32_t)(((uint64_t)value >>  1  ) & 0x0000000000000001ULL); \
    (s)->c          = (uint32_t)(((uint64_t)value >>  0  ) & 0x0000000000000001ULL);




//VTD_GCMD_REG (sec. 10.4.4)
typedef struct {
    uint32_t rsvdz0  ;//: 23;		//reserved
    uint32_t cfi     ;//: 1;				//compatibility format interrupt
    uint32_t sirtp   ;//: 1;			//set interrupt remap table pointer
    uint32_t ire     ;//:1;				//interrupt remapping enable
    uint32_t qie     ;//:1;				//queued invalidation enable
    uint32_t wbf     ;//:1;				//write buffer flush
    uint32_t eafl    ;//:1;				//enable advanced fault logging
    uint32_t sfl     ;//:1;				//set fault log
    uint32_t srtp    ;//:1;				//set root table pointer
    uint32_t te      ;//:1;					//translation enable
} __attribute__ ((packed)) VTD_GCMD_REG;

#define pack_VTD_GCMD_REG(s) \
    (uint32_t)( \
    (((uint32_t)(s)->te       & 0x00000001UL) << 31) | \
    (((uint32_t)(s)->srtp     & 0x00000001UL) << 30) | \
    (((uint32_t)(s)->sfl      & 0x00000001UL) << 29) | \
    (((uint32_t)(s)->eafl     & 0x00000001UL) << 28) | \
    (((uint32_t)(s)->wbf      & 0x00000001UL) << 27) | \
    (((uint32_t)(s)->qie      & 0x00000001UL) << 26) | \
    (((uint32_t)(s)->ire      & 0x00000001UL) << 25) | \
    (((uint32_t)(s)->sirtp    & 0x00000001UL) << 24) | \
    (((uint32_t)(s)->cfi      & 0x00000001UL) << 23) | \
    (((uint32_t)(s)->rsvdz0   & 0x007FFFFFUL) << 0 ) \
    )

#define unpack_VTD_GCMD_REG(s, value) \
    (s)->te         = (uint32_t)(((uint32_t)value >> 31) & 0x00000001UL); \
    (s)->srtp       = (uint32_t)(((uint32_t)value >> 30) & 0x00000001UL); \
    (s)->sfl        = (uint32_t)(((uint32_t)value >> 29) & 0x00000001UL); \
    (s)->eafl       = (uint32_t)(((uint32_t)value >> 28) & 0x00000001UL); \
    (s)->wbf        = (uint32_t)(((uint32_t)value >> 27) & 0x00000001UL); \
    (s)->qie        = (uint32_t)(((uint32_t)value >> 26) & 0x00000001UL); \
    (s)->ire        = (uint32_t)(((uint32_t)value >> 25) & 0x00000001UL); \
    (s)->sirtp      = (uint32_t)(((uint32_t)value >> 24) & 0x00000001UL); \
    (s)->cfi        = (uint32_t)(((uint32_t)value >> 23) & 0x00000001UL); \
    (s)->rsvdz0     = (uint32_t)(((uint32_t)value >> 0 ) & 0x007FFFFFUL);




//VTD_GSTS_REG (sec. 10.4.5)
typedef struct {
    uint32_t rsvdz0  ; //: 23;		//reserved
    uint32_t cfis    ; //:1;				//compatibility interrupt format status
    uint32_t irtps   ; //:1;			//interrupt remapping table pointer status
    uint32_t ires    ; //:1;				//interrupt remapping enable status
    uint32_t qies    ; //:1;				//queued invalidation enable status
    uint32_t wbfs    ; //:1;				//write buffer flush status
    uint32_t afls    ; //:1;				//advanced fault logging status
    uint32_t fls     ; //:1;				//fault log status
    uint32_t rtps    ; //:1;				//root table pointer status
    uint32_t tes     ; //:1;				//translation enable status
} __attribute__ ((packed)) VTD_GSTS_REG;

#define pack_VTD_GSTS_REG(s) \
    (uint32_t)( \
    (((uint32_t)(s)->tes      & 0x00000001UL) << 31) | \
    (((uint32_t)(s)->rtps     & 0x00000001UL) << 30) | \
    (((uint32_t)(s)->fls      & 0x00000001UL) << 29) | \
    (((uint32_t)(s)->afls     & 0x00000001UL) << 28) | \
    (((uint32_t)(s)->wbfs     & 0x00000001UL) << 27) | \
    (((uint32_t)(s)->qies     & 0x00000001UL) << 26) | \
    (((uint32_t)(s)->ires     & 0x00000001UL) << 25) | \
    (((uint32_t)(s)->irtps    & 0x00000001UL) << 24) | \
    (((uint32_t)(s)->cfis     & 0x00000001UL) << 23) | \
    (((uint32_t)(s)->rsvdz0   & 0x007FFFFFUL) << 0 ) \
    )

#define unpack_VTD_GSTS_REG(s, value) \
     (s)->tes       = (uint32_t)(((uint32_t)value >> 31) & 0x00000001UL); \
     (s)->rtps      = (uint32_t)(((uint32_t)value >> 30) & 0x00000001UL); \
     (s)->fls       = (uint32_t)(((uint32_t)value >> 29) & 0x00000001UL); \
     (s)->afls      = (uint32_t)(((uint32_t)value >> 28) & 0x00000001UL); \
     (s)->wbfs      = (uint32_t)(((uint32_t)value >> 27) & 0x00000001UL); \
     (s)->qies      = (uint32_t)(((uint32_t)value >> 26) & 0x00000001UL); \
     (s)->ires      = (uint32_t)(((uint32_t)value >> 25) & 0x00000001UL); \
     (s)->irtps     = (uint32_t)(((uint32_t)value >> 24) & 0x00000001UL); \
     (s)->cfis      = (uint32_t)(((uint32_t)value >> 23) & 0x00000001UL); \
     (s)->rsvdz0    = (uint32_t)(((uint32_t)value >> 0 ) & 0x007FFFFFUL);



//VTD_RTADDR_REG (sec. 10.4.6)
typedef struct {
    uint32_t rsvdz0  ; //: 12;		//reserved
    uint32_t rta     ; //: 32;			//root table address
    uint32_t rta_high ; // : 22;			//root table address
} __attribute__ ((packed)) VTD_RTADDR_REG;

#define pack_VTD_RTADDR_REG(s) \
    (uint64_t)( \
    (((uint64_t)(s)->rta_high &   0x00000000003FFFFFULL) << 44) | \
    (((uint64_t)(s)->rta      &   0x00000000FFFFFFFFULL) << 12) | \
    (((uint64_t)(s)->rsvdz0   &   0x0000000000000FFFULL) << 0 )  \
    )

#define unpack_VTD_RTADDR_REG(s, value) \
    (s)->rta_high    = (uint32_t)(((uint64_t)value >>  44 ) & 0x00000000003FFFFFULL); \
    (s)->rta         = (uint32_t)(((uint64_t)value >>  12 ) & 0x00000000FFFFFFFFULL); \
    (s)->rsvdz0      = (uint32_t)(((uint64_t)value >>  0  ) & 0x0000000000000FFFULL);




//VTD_CCMD_REG (sec. 10.4.7)
typedef struct {
    uint32_t did     ; //:16;				//domain id
    uint32_t sid     ; //:16;				//source id
    uint32_t fm      ; //:2;					//function mask
    uint32_t rsvdz0  ; //: 25;		//reserved
    uint32_t caig    ; //:2;				//context invalidation actual granularity
    uint32_t cirg    ; //:2;				//context invalidation request granularity
    uint32_t icc     ; //:1;				//invalidate context-cache
} __attribute__ ((packed)) VTD_CCMD_REG;

#define pack_VTD_CCMD_REG(s) \
    (uint64_t)( \
    (((uint64_t)(s)->icc    &   0x0000000000000001ULL) << 63) | \
    (((uint64_t)(s)->cirg   &   0x0000000000000003ULL) << 61) | \
    (((uint64_t)(s)->caig   &   0x0000000000000003ULL) << 59) | \
    (((uint64_t)(s)->rsvdz0 &   0x0000000001FFFFFFULL) << 34) | \
    (((uint64_t)(s)->fm     &   0x0000000000000003ULL) << 32) | \
    (((uint64_t)(s)->sid    &   0x000000000000FFFFULL) << 16) | \
    (((uint64_t)(s)->did    &   0x000000000000FFFFULL) << 0 )  \
    )

#define unpack_VTD_CCMD_REG(s, value) \
    (s)->icc     = (uint32_t)(((uint64_t)value >>   63) & 0x0000000000000001ULL); \
    (s)->cirg    = (uint32_t)(((uint64_t)value >>   61) & 0x0000000000000003ULL); \
    (s)->caig    = (uint32_t)(((uint64_t)value >>   59) & 0x0000000000000003ULL); \
    (s)->rsvdz0  = (uint32_t)(((uint64_t)value >>   34) & 0x0000000001FFFFFFULL); \
    (s)->fm      = (uint32_t)(((uint64_t)value >>   32) & 0x0000000000000003ULL); \
    (s)->sid     = (uint32_t)(((uint64_t)value >>   16) & 0x000000000000FFFFULL); \
    (s)->did     = (uint32_t)(((uint64_t)value >>   0 ) & 0x000000000000FFFFULL);




//VTD_IOTLB_REG (sec. 10.4.8.1)

typedef struct {
    uint32_t rsvdz0  ; //: 32;		//reserved
    uint32_t did     ; //:16;				//domain-id
    uint32_t dw      ; //: 1;				//drain writes
    uint32_t dr      ; //:1;					//drain reads
    uint32_t rsvdz1  ; //: 7;		//reserved
    uint32_t iaig    ; //: 3;			//IOTLB actual invalidation granularity
    uint32_t iirg    ; //: 3;			//IOTLB request invalidation granularity
    uint32_t ivt     ; //: 1;				//invalidate IOTLB
} __attribute__ ((packed)) VTD_IOTLB_REG;

#define pack_VTD_IOTLB_REG(s) \
    (uint64_t)( \
    (((uint64_t)(s)->ivt &    0x0000000000000001ULL) << 63) | \
    (((uint64_t)(s)->iirg &   0x0000000000000007ULL) << 60) | \
    (((uint64_t)(s)->iaig &   0x0000000000000007ULL) << 57) | \
    (((uint64_t)(s)->rsvdz1 & 0x000000000000007FULL) << 50) | \
    (((uint64_t)(s)->dr &     0x0000000000000001ULL) << 49) | \
    (((uint64_t)(s)->dw &     0x0000000000000001ULL) << 48) | \
    (((uint64_t)(s)->did &    0x000000000000FFFFULL) << 32) | \
    (((uint64_t)(s)->rsvdz0 & 0x00000000FFFFFFFFULL) << 0 ) \
    )

#define unpack_VTD_IOTLB_REG(s, value) \
    (s)->ivt = (uint32_t)(((uint64_t)value >>    63) & 0x0000000000000001ULL); \
    (s)->iirg = (uint32_t)(((uint64_t)value >>   60) & 0x0000000000000007ULL); \
    (s)->iaig = (uint32_t)(((uint64_t)value >>   57) & 0x0000000000000007ULL); \
    (s)->rsvdz1 = (uint32_t)(((uint64_t)value >> 50) & 0x000000000000007FULL); \
    (s)->dr = (uint32_t)(((uint64_t)value >>     49) & 0x0000000000000001ULL); \
    (s)->dw = (uint32_t)(((uint64_t)value >>     48) & 0x0000000000000001ULL); \
    (s)->did = (uint32_t)(((uint64_t)value >>    32) & 0x000000000000FFFFULL); \
    (s)->rsvdz0 = (uint32_t)(((uint64_t)value >> 0 ) & 0x00000000FFFFFFFFULL);


/*//VTD_IVA_REG (sec. 10.4.8.2)
typedef union {
  uint64_t value;
  struct
  {
    uint32_t am: 6;				//address mask
    uint32_t ih:1;					//invalidation hint
    uint32_t rsvdz0: 5;		//reserved
    uint32_t addr:32;			//address
    uint32_t addr_high :20;			//address
  } __attribute__((packed)) bits;
} __attribute__ ((packed)) VTD_IVA_REG;
*/

/*
//VTD_FSTS_REG	(sec. 10.4.9)
typedef union {
  uint32_t value;
  struct
  {
    uint32_t pfo:1;				//fault overflow
    uint32_t ppf:1;				//primary pending fault
    uint32_t afo:1;				//advanced fault overflow
    uint32_t apf:1;				//advanced pending fault
    uint32_t iqe:1;				//invalidation queue error
    uint32_t ice:1;				//invalidation completion error
    uint32_t ite:1;				//invalidation time-out error
    uint32_t rsvdz0: 1;		//reserved
    uint32_t fri:8;				//fault record index
    uint32_t rsvdz1: 16;		//reserved
  } __attribute__((packed)) bits;
} __attribute__ ((packed)) VTD_FSTS_REG;
*/


//VTD_FECTL_REG	(sec. 10.4.10)
typedef struct {
    uint32_t rsvdp0  ; //:30;		//reserved
    uint32_t ip      ; //:1;					//interrupt pending
    uint32_t im      ; //:1;					//interrupt mask
} __attribute__ ((packed)) VTD_FECTL_REG;

#define pack_VTD_FECTL_REG(s) \
    (uint32_t)( \
    (((uint32_t)(s)->im & 0x00000001UL) << 31) | \
    (((uint32_t)(s)->ip & 0x00000001UL) << 30) | \
    (((uint32_t)(s)->rsvdp0 & 0x3FFFFFFFUL) << 0) \
    )

#define unpack_VTD_FECTL_REG(s, value) \
    (s)->im = (uint32_t)(((uint32_t)value >> 31) & 0x00000001UL); \
    (s)->ip = (uint32_t)(((uint32_t)value >> 30) & 0x00000001UL); \
    (s)->rsvdp0 = (uint32_t)(((uint32_t)value >> 0) & 0x3FFFFFFFUL);


//VTD_PMEN_REG (sec. 10.4.16)
typedef struct {
    uint32_t prs     ; // :1;			//protected region status
    uint32_t rsvdp   ; //:30;		//reserved
    uint32_t epm     ; //:1;			//enable protected memory
} __attribute__ ((packed)) VTD_PMEN_REG;

#define pack_VTD_PMEN_REG(s) \
    (uint32_t)( \
    (((uint32_t)(s)->epm & 0x00000001UL) << 31) | \
    (((uint32_t)(s)->rsvdp & 0x3FFFFFFFUL) << 1) | \
    (((uint32_t)(s)->prs & 0x00000001UL) << 0) \
    )

#define unpack_VTD_PMEN_REG(s, value) \
    (s)->epm = (uint32_t)(((uint32_t)value >> 31) & 0x00000001UL); \
    (s)->rsvdp = (uint32_t)(((uint32_t)value >> 1) & 0x3FFFFFFFUL); \
    (s)->prs = (uint32_t)(((uint32_t)value >> 0) & 0x00000001UL);



//VTD_PLMBASE_REG (sec. 10.4.17)
typedef struct {
  uint32_t value;
} __attribute__ ((packed)) VTD_PLMBASE_REG;

//VTD_PLMLIMIT_REG (sec. 10.4.18)
typedef struct {
  uint32_t value;
} __attribute__ ((packed)) VTD_PLMLIMIT_REG;

//VTD_PHMBASE_REG (sec. 10.4.19)
typedef struct {
  uint64_t value;
} __attribute__ ((packed)) VTD_PHMBASE_REG;

//VTD_PHMLIMIT_REG (sec. 10.4.20)
typedef struct {
  uint64_t value;
} __attribute__ ((packed)) VTD_PHMLIMIT_REG;


typedef enum {
	HWM_VTD_REG_ECAP,
	HWM_VTD_REG_UNKNOWN,
} hwm_vtd_regtype_t;

typedef struct {
	uint32_t reg_ver;
	uint32_t reg_gcmd;
	uint32_t reg_gsts;
	uint32_t reg_fsts;
	uint32_t reg_fectl;
	uint32_t reg_pmen;
	uint32_t reg_plmbase;
	uint32_t reg_plmlimit;

	uint32_t reg_cap_lo;
	uint32_t reg_cap_hi;
	uint32_t reg_ecap_lo;
	uint32_t reg_ecap_hi;
	uint32_t reg_rtaddr_lo;
	uint32_t reg_rtaddr_hi;
	uint32_t reg_ccmd_lo;
	uint32_t reg_ccmd_hi;
	uint32_t reg_phmbase_lo;
	uint32_t reg_phmbase_hi;
	uint32_t reg_phmlimit_lo;
	uint32_t reg_phmlimit_hi;
	uint32_t reg_iotlb_lo;
	uint32_t reg_iotlb_hi;
	uint32_t reg_iva_lo;
	uint32_t reg_iva_hi;

	uint64_t regbaseaddr;
	uint64_t iotlbaddr;
	uint64_t ivaaddr;
} hwm_vtd_drhd_state_t;

bool _impl_hwm_vtd_read(uint32_t sysmemaddr, sysmem_read_t readsize, uint64_t *read_result);
bool _impl_hwm_vtd_write(uint32_t sysmemaddr, sysmem_write_t writesize, uint64_t write_value);

extern hwm_vtd_drhd_state_t hwm_vtd_drhd_state[];


#endif //__ASSEMBLY__

#endif //__HWM_DEVICE_IOMMU_INTEL__VTD_H___
