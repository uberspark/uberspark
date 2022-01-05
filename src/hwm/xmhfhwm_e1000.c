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
 * e1000 hardware model implementation
 * author: amit vasudevan (amitvasudevan@acm.org)
*/


#include <uberspark.h>

uint32_t xmhfhwm_e1000_tctl=0; 	//transmit control register, E1000_TCTL
uint32_t xmhfhwm_e1000_tdt=0; 	//transmit descriptor tail, E1000_TDT
uint32_t xmhfhwm_e1000_tdh=0; 	//transmit descriptor head, E1000_TDH
uint32_t xmhfhwm_e1000_tdbah;		//E1000_TDBAH, high-32bits of transmit descriptor base address
uint32_t xmhfhwm_e1000_tdbal;		//E1000_TDBAL, low-32bits of transmit descriptor base address
uint32_t xmhfhwm_e1000_tdlen;		//E1000_TDLEN, descroptor length
uint32_t xmhfhwm_e1000_swsm;		//E1000_SWSM, sw semaphore
uint32_t xmhfhwm_e1000_eecd;		//E1000_EECD, eeprom/flash control

bool xmhfhwm_e1000_status_transmitting = false; // true if transmitting, false if not


bool _impl_xmhfhwm_e1000_read(uint32_t sysmemaddr, sysmem_read_t readsize, uint64_t *read_result){

	if(sysmemaddr >= E1000_HWADDR_BASE && sysmemaddr < (E1000_HWADDR_BASE + E1000_HWADDR_SIZE)){
		switch((sysmemaddr - E1000_HWADDR_BASE)){
			case E1000_TCTL:{
				*read_result = (uint64_t)xmhfhwm_e1000_tctl;
				return true;
			}

			case E1000_TDT:{
				*read_result = (uint64_t)xmhfhwm_e1000_tdt;
				return true;
			}


			case E1000_TDH:{
				if(xmhfhwm_e1000_status_transmitting){
					xmhfhwm_e1000_tdh = xmhfhwm_e1000_tdt;
					xmhfhwm_e1000_status_transmitting=false;
				}
				*read_result = (uint64_t)xmhfhwm_e1000_tdh;
				return true;
			}

			case E1000_TDBAH:{
				*read_result = (uint64_t)xmhfhwm_e1000_tdbah;
				return true;
			}

			case E1000_TDBAL:{
				*read_result = (uint64_t)xmhfhwm_e1000_tdbal;
				return true;
			}


			case E1000_TDLEN:{
				*read_result = (uint64_t)xmhfhwm_e1000_tdlen;
				return true;
			}

			case E1000_SWSM:{
				*read_result = (uint64_t)xmhfhwm_e1000_swsm;
				return true;
			}

			case E1000_EECD:{
				*read_result = (uint64_t)xmhfhwm_e1000_eecd;
				return true;
			}


			default:
				return true;
		}
	}else{
		return false;
	}
}


bool _impl_xmhfhwm_e1000_write(uint32_t sysmemaddr, sysmem_write_t writesize, uint64_t write_value){

	if(sysmemaddr >= E1000_HWADDR_BASE && sysmemaddr < (E1000_HWADDR_BASE + E1000_HWADDR_SIZE)){
		switch((sysmemaddr - E1000_HWADDR_BASE)){
			case E1000_TCTL:{
				xmhfhwm_e1000_tctl = (uint32_t)write_value;
				return true;
			}

			case E1000_TDT:{
				cbhwm_e1000_write_tdt(xmhfhwm_e1000_tdt, (uint32_t)write_value);
				xmhfhwm_e1000_tdt = (uint32_t)write_value;
				if(xmhfhwm_e1000_tctl & E1000_TCTL_EN)
					xmhfhwm_e1000_status_transmitting = true;
				return true;
			}

			case E1000_TDH:{
				xmhfhwm_e1000_tdh = (uint32_t)write_value;
				return true;
			}

			case E1000_TDBAH:{
				cbhwm_e1000_write_tdbah(xmhfhwm_e1000_tdbah, (uint32_t)write_value);
				xmhfhwm_e1000_tdbah = (uint32_t)write_value;
				return true;
			}

			case E1000_TDBAL:{
				cbhwm_e1000_write_tdbal(xmhfhwm_e1000_tdbal, (uint32_t)write_value);
				xmhfhwm_e1000_tdbal = (uint32_t)write_value;
				return true;
			}

			case E1000_TDLEN:{
				cbhwm_e1000_write_tdlen(xmhfhwm_e1000_tdlen, (uint32_t)write_value);
				xmhfhwm_e1000_tdlen = (uint32_t)write_value;
				return true;
			}


			case E1000_SWSM:{
				xmhfhwm_e1000_swsm = (uint32_t)write_value;
				return true;
			}


			case E1000_EECD:{
				xmhfhwm_e1000_eecd = (uint32_t)write_value;
				if(xmhfhwm_e1000_eecd & E1000_EECD_REQ)
					xmhfhwm_e1000_eecd |= E1000_EECD_GNT;

				return true;
			}

			default:
				return true;
		}

	}else{
		return false;
	}

}



