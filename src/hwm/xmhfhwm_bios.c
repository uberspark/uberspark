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
 * x86 bios implementation
 * author: amit vasudevan (amitvasudevan@acm.org)
*/


#include <uberspark.h>

uint16_t xmhfhwm_bios_ebdaseg = (XMHFHWM_BIOS_EBDA_BASE >> 4);
ACPI_RSDP xmhfhwm_bios_acpi_rsdp = {
	0x2052545020445352ULL,
	0x10,
	{0x44, 0x45, 0x4c, 0x4c, 0x20, 0x20},
	0x02,
	XMHFHWM_BIOS_ACPIRSDTBASE,
        0x24,
        0x00000000d87ef028ULL,
	0x6,
	{0x44, 0x45, 0x4c},
};


ACPI_RSDT xmhfhwm_bios_acpi_rsdt = {
	0x0000006a54445352ULL,
	0x28,
	0x1,
	0xc3,
	{0x44, 0x45, 0x4c, 0x4c, 0x20, 0x20},
	0x0020202033584243ULL,
	0x01072009UL,
	0x5446534dUL,
	0x00010013UL,
};

uint32_t xmhfhwm_bios_acpi_rsdtentries[] ={
	XMHFHWM_BIOS_VTDDMARTABLEBASE
};



VTD_DMAR xmhfhwm_bios_vtd_dmar = {
	0x0000003052414d44ULL,
	(48 + (2*16)),
	0x01,
	0x8d,
	{0x49, 0x4e, 0x54, 0x45, 0x4c, 0x20},
	0x0000000020575348ULL,
	0x00000001UL,
	0x4c544e49UL,
	0x00000001UL,
	0x26,
	0x01,
	{0x49, 0x4e, 0x54, 0x45, 0x4c, 0x20, 0x48, 0x53, 0x57, 0x20},
};

  uint16_t type;
  uint16_t length;
  uint8_t flags;
  uint8_t rsvdz0;
  uint16_t pcisegment;
  uint64_t regbaseaddr;


VTD_DMAR_DRHD xmhfhwm_bios_vtd_dmar_drhd[] = {
	{
		0x0,
		16,
		0x0,
		0x0,
		0x0,
		0x00000000fed90000ULL,
	},

	{
		0x0,
		16,
		0x0,
		0x0,
		0x0,
		0x00000000fed91000ULL,
	},

};












static unsigned char *xmhfhwm_bios_memcpy(unsigned char *dst, const unsigned char *src, size_t n)
{
	const unsigned char *p = src;
	unsigned char *q = dst;

	while (n) {
		*q++ = *p++;
		n--;
	}

	return dst;
}


bool _impl_xmhfhwm_bios_read(uint32_t sysmemaddr, sysmem_read_t readsize, uint64_t *read_result){
	bool retval = true;

	if(sysmemaddr == (XMHFHWM_BIOS_BDA_BASE+0xE)){
		//@assert (readsize == SYSMEMREADU32);
		*read_result = (uint64_t)xmhfhwm_bios_ebdaseg;
	}else{
		retval= false;
	}

	return retval;
}

bool _impl_xmhfhwm_bios_write(uint32_t sysmemaddr, sysmem_write_t writesize, uint64_t write_value){
	bool retval = false;

	if(sysmemaddr == XMHFHWM_BIOS_VTDDMARTABLEBASE){
		//@assert writesize == SYSMEMWRITEU32;
		//TODO: emulate ZAPping of DMAR table
		retval = true;
	}else if (sysmemaddr >= XMHFHWM_BIOS_BDA_BASE && sysmemaddr < (XMHFHWM_BIOS_BDA_BASE+XMHFHWM_BIOS_BDA_SIZE)){
		/*@assert ( (writesize == SYSMEMWRITEU8) &&
		 	 	    (sysmemaddr >= XMHFHWM_BIOS_BDA_BASE) &&
		 	 	    (sysmemaddr < (XMHFHWM_BIOS_BDA_BASE+XMHFHWM_BIOS_BDA_SIZE)) )
		 	 	    ||
				  ( (writesize == SYSMEMWRITEU16) &&
		 	 	    (sysmemaddr >= XMHFHWM_BIOS_BDA_BASE) &&
		 	 	    (sysmemaddr < (XMHFHWM_BIOS_BDA_BASE+XMHFHWM_BIOS_BDA_SIZE-sizeof(uint16_t))) )
		 	 	    ;
		 */
		retval = true;
	}else{


	}

	return retval;
}


bool _impl_xmhfhwm_bios_sysmemcopy(sysmem_copy_t sysmemcopy_type,
				uint32_t dstaddr, uint32_t srcaddr, uint32_t size){
	bool retval = true;

	if(sysmemcopy_type == SYSMEMCOPYSYS2OBJ){
		//dstaddr = obj address space
		//srcaddr = BIOS address space
		if(srcaddr >= XMHFHWM_BIOS_EBDA_BASE &&
			(srcaddr + size) < (XMHFHWM_BIOS_EBDA_BASE+XMHFHWM_BIOS_EBDA_SIZE)){
			//@assert \valid((unsigned char *)dstaddr + (0..(size-1)));

		}else if(srcaddr >= XMHFHWM_BIOS_ROMBASE &&
			(srcaddr + size) < (XMHFHWM_BIOS_ROMBASE+XMHFHWM_BIOS_ROMSIZE)){
			//@assert \valid((unsigned char *)dstaddr + (0..(size-1)));
			if(srcaddr == XMHFHWM_BIOS_ACPIRSDPBASE){
				ACPI_RSDP *rsdp = (ACPI_RSDP *)dstaddr;
                                rsdp->signature = xmhfhwm_bios_acpi_rsdp.signature;
				rsdp->checksum = xmhfhwm_bios_acpi_rsdp.checksum;
				rsdp->oemid[0] = xmhfhwm_bios_acpi_rsdp.oemid[0];
				rsdp->oemid[1] = xmhfhwm_bios_acpi_rsdp.oemid[1];
				rsdp->oemid[2] = xmhfhwm_bios_acpi_rsdp.oemid[2];
				rsdp->oemid[3] = xmhfhwm_bios_acpi_rsdp.oemid[3];
				rsdp->oemid[4] = xmhfhwm_bios_acpi_rsdp.oemid[4];
				rsdp->oemid[5] = xmhfhwm_bios_acpi_rsdp.oemid[5];
				rsdp->revision = xmhfhwm_bios_acpi_rsdp.revision;
				rsdp->rsdtaddress = xmhfhwm_bios_acpi_rsdp.rsdtaddress;
				rsdp->length = xmhfhwm_bios_acpi_rsdp.length;
				rsdp->xsdtaddress = xmhfhwm_bios_acpi_rsdp.xsdtaddress;
				rsdp->xchecksum = xmhfhwm_bios_acpi_rsdp.xchecksum;
                                rsdp->rsvd0[0] = xmhfhwm_bios_acpi_rsdp.rsvd0[0];
                                rsdp->rsvd0[1] = xmhfhwm_bios_acpi_rsdp.rsvd0[1];
                                rsdp->rsvd0[2] = xmhfhwm_bios_acpi_rsdp.rsvd0[2];
			}

		}else if(srcaddr == XMHFHWM_BIOS_ACPIRSDTBASE){
			//@assert \valid((unsigned char *)dstaddr + (0..(size-1)));
			//@assert (size <= sizeof(ACPI_RSDT));
			xmhfhwm_bios_memcpy((unsigned char *)dstaddr,
					&xmhfhwm_bios_acpi_rsdt, size);

		}else if(srcaddr >= XMHFHWM_BIOS_ACPIRSDTENTRIESBASE &&
			(srcaddr+size-1) < (XMHFHWM_BIOS_ACPIRSDTENTRIESBASE+sizeof(xmhfhwm_bios_acpi_rsdtentries))){
			//@assert \valid((unsigned char *)dstaddr + (0..(size-1)));
			xmhfhwm_bios_memcpy((unsigned char *)dstaddr,
					((uint32_t)&xmhfhwm_bios_acpi_rsdtentries+(srcaddr - XMHFHWM_BIOS_ACPIRSDTENTRIESBASE)), size);

		}else if(srcaddr >= XMHFHWM_BIOS_VTDDMARTABLEBASE &&
			(srcaddr+size-1) < (XMHFHWM_BIOS_VTDDMARTABLEBASE+sizeof(xmhfhwm_bios_vtd_dmar))){
			//@assert \valid((unsigned char *)dstaddr + (0..(size-1)));
			xmhfhwm_bios_memcpy((unsigned char *)dstaddr,
					((uint32_t)&xmhfhwm_bios_vtd_dmar+(srcaddr - XMHFHWM_BIOS_VTDDMARTABLEBASE)), size);

		}else if(srcaddr >= XMHFHWM_BIOS_VTDDMARTABLEREMAPPINGSTRUCTBASE &&
			(srcaddr+size-1) < (XMHFHWM_BIOS_VTDDMARTABLEREMAPPINGSTRUCTBASE+sizeof(xmhfhwm_bios_vtd_dmar_drhd))){
			//@assert \valid((unsigned char *)dstaddr + (0..(size-1)));
			xmhfhwm_bios_memcpy((unsigned char *)dstaddr,
					((uint32_t)&xmhfhwm_bios_vtd_dmar_drhd+(srcaddr - XMHFHWM_BIOS_VTDDMARTABLEREMAPPINGSTRUCTBASE)), size);

		}else{
			retval = false;
		}

	}else{
		retval = false;
	}

	return retval;
}

