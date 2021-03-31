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
 * arm XMHF HWM CPU declarations
 * author: ethan joseph (ethanj217@gmail.com)
*/

#ifndef __HWM_ARCH_ARM_GENERIC__CPU_H__
#define __HWM_ARCH_ARM_GENERIC__CPU_H__

#include <uberspark/include/uberspark.h>

#define CASM_RET_LR	0xDEADBEEF

// #define __casm__add(RD, RN, OP2) \
// 	__builtin_annot("add "#RD", "#RN", "#OP2); \
// 	_impl__casm__add(RD, RN, OP2); 

extern void _impl__casm__add_imm_r1_r0(uint32_t value);
extern void _impl__casm__add_imm_r4_r3(uint32_t value);
extern void _impl__casm__add_sp_sp_r3(uint32_t value);
extern void _impl__casm__add_sp_sp_r6(uint32_t value);
extern void _impl__casm__and_imm_r7_r7(uint32_t value); 
extern void _impl__casm__and_imm_r0_r0(uint32_t value);
extern void _impl__casm__and_imm_r3_r3(uint32_t value);
extern void _impl__casm__b_eq();
extern void _impl__casm__add_imm_lr_lr();
extern void _impl__casm__bx_lr();
extern void _impl__casm__bic_imm_r7_r7(uint32_t value);
extern void _impl__casm__bic_imm_r9_r9(uint32_t value);
extern void _impl__casm__cmp_imm_r7(uint32_t value);
extern void _impl__casm__eor_imm_r9_r9(uint32_t value);
extern void _impl__casm__ldr_imm_r0_r0(uint32_t offset);
extern void _impl__casm__ldr_pseudo_sp(uint32_t value);
extern void _impl__casm__ldrex_imm_r2_r0(uint32_t offset);
extern void _impl__casm__lsr_imm_r7_r7(uint32_t value);
extern void _impl__casm__mcr_p15_0_r7_c14_c3_1();
extern void _impl__casm__mcr_p15_4_r7_c1_c1_1();
extern void _impl__casm__mcr_p15_4_r7_c1_c1_2();
extern void _impl__casm__mcr_p15_4_r7_c14_c1_0();
extern void _impl__casm__mcr_p15_0_r0_c1_c0_0();
extern void _impl__casm__mcr_p15_0_r0_c1_c0_1();
extern void _impl__casm__mcr_p15_0_r0_c12_c0_0();
extern void _impl__casm__mcr_p15_4_r0_c1_c0_0();
extern void _impl__casm__mcr_p15_4_r0_c1_c1_0();
extern void _impl__casm__mcr_p15_4_r0_c1_c1_1();
extern void _impl__casm__mcr_p15_4_r0_c1_c1_2();
extern void _impl__casm__mcr_p15_4_r0_c1_c1_3();
extern void _impl__casm__mcr_p15_4_r0_c12_c0_0();
extern void _impl__casm__mcr_p15_4_r0_c2_c1_2();
extern void _impl__casm__mcr_p15_0_r0_c10_c2_0();
extern void _impl__casm__mcr_p15_0_r0_c10_c2_1();
extern void _impl__casm__mcr_p15_0_r0_c2_c0_0();
extern void _impl__casm__mcr_p15_0_r0_c2_c0_1();
extern void _impl__casm__mcr_p15_0_r0_c2_c0_2();
extern void _impl__casm__mcr_p15_0_r0_c3_c0_0();
extern void _impl__casm__mcr_p15_0_r0_c7_c5_0();
extern void _impl__casm__mcr_p15_0_r0_c7_c8_0();
extern void _impl__casm__mcr_p15_0_r0_c7_c8_6();
extern void _impl__casm__mcr_p15_0_r0_c8_c3_0();
extern void _impl__casm__mcr_p15_4_r0_c10_c2_0();
extern void _impl__casm__mcr_p15_4_r0_c10_c2_1();
extern void _impl__casm__mcr_p15_4_r0_c14_c2_0();
extern void _impl__casm__mcr_p15_4_r0_c14_c2_1();
extern void _impl__casm__mcr_p15_4_r0_c2_c0_2();
extern void _impl__casm__mcr_p15_4_r0_c8_c0_1();
extern void _impl__casm__mcr_p15_4_r0_c8_c7_0();
extern void _impl__casm__mcrr_p15_4_r0_r1_c2();
extern void _impl__casm__mcrr_p15_6_r0_r1_c2();
extern void _impl__casm__mcrr_p15_4_r7_r7_c14();
extern void _impl__casm__mrc_p15_0_r7_c0_c1_1();
extern void _impl__casm__mrc_p15_0_r7_c14_c3_1();
extern void _impl__casm__mrc_p15_4_r7_c1_c1_1();
extern void _impl__casm__mrc_p15_4_r7_c14_c1_0();
extern void _impl__casm__mrc_p15_0_r0_c0_c0_5();
extern void _impl__casm__mrc_p15_0_r3_c0_c0_5();
extern void _impl__casm__mrc_p15_0_r0_c0_c2_4();
extern void _impl__casm__mrc_p15_0_r0_c1_c0_0();
extern void _impl__casm__mrc_p15_0_r0_c1_c0_1();
extern void _impl__casm__mrc_p15_0_r0_c1_c1_0();
extern void _impl__casm__mrc_p15_0_r0_c12_c0_0();
extern void _impl__casm__mrc_p15_4_r0_c1_c0_0();
extern void _impl__casm__mrc_p15_4_r0_c1_c1_0();
extern void _impl__casm__mrc_p15_4_r0_c1_c1_1();
extern void _impl__casm__mrc_p15_4_r0_c1_c1_2();
extern void _impl__casm__mrc_p15_4_r0_c1_c1_3();
extern void _impl__casm__mrc_p15_4_r0_c12_c0_0();
extern void _impl__casm__mrc_p15_4_r0_c2_c1_2();
extern void _impl__casm__mrc_p15_4_r0_c5_c2_0();
extern void _impl__casm__mrc_p15_0_r0_c10_c2_0();
extern void _impl__casm__mrc_p15_0_r0_c10_c2_1();
extern void _impl__casm__mrc_p15_0_r0_c2_c0_0();
extern void _impl__casm__mrc_p15_0_r0_c2_c0_1();
extern void _impl__casm__mrc_p15_0_r0_c2_c0_2();
extern void _impl__casm__mrc_p15_0_r0_c3_c0_0();
extern void _impl__casm__mrc_p15_0_r0_c7_c4_0();
extern void _impl__casm__mrc_p15_4_r0_c10_c2_0();
extern void _impl__casm__mrc_p15_4_r0_c10_c2_1();
extern void _impl__casm__mrc_p15_4_r0_c14_c2_0();
extern void _impl__casm__mrc_p15_4_r0_c14_c2_1();
extern void _impl__casm__mrc_p15_4_r0_c2_c0_2();
extern void _impl__casm__mrc_p15_4_r0_c6_c0_0();
extern void _impl__casm__mrc_p15_4_r0_c6_c0_4();
extern void _impl__casm__mrrc_p15_0_r0_r1_c14();
extern void _impl__casm__mrrc_p15_6_r0_r1_c2();
extern void _impl__casm__mrrc_p15_4_r0_r1_c2();
extern void _impl__casm__mrs_r0_elrhyp();
extern void _impl__casm__mrs_r0_spsrhyp();
extern void _impl__casm__mrs_r0_cpsr();
extern void _impl__casm__mrs_r9_cpsr();
extern void _impl__casm__msr_spsrcxsf_r9();
extern void _impl__casm__msr_elrhyp_r0();
extern void _impl__casm__msr_elrhyp_r3();
extern void _impl__casm__msr_cpsr_r0();
extern void _impl__casm__mov_r0_sp();
extern void _impl__casm__mov_imm_r1(uint32_t value);
extern void _impl__casm__mov_imm_r2(uint32_t value);
extern void _impl__casm__mov_imm_r5(uint32_t value);
extern void _impl__casm__mov_imm_r7(uint32_t value);
extern void _impl__casm__mul_r3_r2_r1();
extern void _impl__casm__mul_r6_r4_r5();
extern void _impl__casm__orr_imm_r7_r7(uint32_t value);
extern void _impl__casm__orr_imm_r9_r9(uint32_t value);
extern void _impl__casm__pop_lr();
extern void _impl__casm__pop_r0();
extern void _impl__casm__pop_r1();
extern void _impl__casm__pop_r2();
extern void _impl__casm__pop_r3();
extern void _impl__casm__pop_r4();
extern void _impl__casm__pop_r5();
extern void _impl__casm__pop_r6();
extern void _impl__casm__pop_r7();
extern void _impl__casm__pop_r8();
extern void _impl__casm__pop_r9();
extern void _impl__casm__pop_r10();
extern void _impl__casm__pop_r11();
extern void _impl__casm__pop_r12();
extern void _impl__casm__push_lr();
extern void _impl__casm__push_r0();
extern void _impl__casm__push_r1();
extern void _impl__casm__push_r2();
extern void _impl__casm__push_r3();
extern void _impl__casm__push_r4();
extern void _impl__casm__push_r5();
extern void _impl__casm__push_r6();
extern void _impl__casm__push_r7();
extern void _impl__casm__push_r8();
extern void _impl__casm__push_r9();
extern void _impl__casm__push_r10();
extern void _impl__casm__push_r11();
extern void _impl__casm__push_r12();
extern void _impl__casm__str_r1_r0(uint32_t offset);
extern void _impl__casm__strex_eq_r3_r1_r0(uint32_t offset);
extern void _impl__casm__teq_imm_r2(uint32_t value);
extern void _impl__casm__teq_eq_imm_r3(uint32_t value);
extern void _impl__casm__tst_imm_r9(uint32_t value);

// blank implementations:
#define __casm__dmb_ish() \
	__builtin_annot("dmb ish");

#define __casm__dsb() \
	__builtin_annot("dsb");

#define __casm__dsb_st() \
	__builtin_annot("dsb st");

#define __casm__dsb_ish() \
	__builtin_annot("dsb ish");

#define __casm__dsb_ishst() \
	__builtin_annot("dsb ishst");

#define __casm__isb() \
	__builtin_annot("isb");

#define __casm__sev() \
	__builtin_annot("sev");
	
#define __casm__wfe_ne() \
	__builtin_annot("wfene");

#define __casm__eret() \
	__builtin_annot("eret");

#define __casm__hvc() \
	__builtin_annot("hvc #0");

#define __casm__svc() \
	__builtin_annot("svc #0");

/// a ///
#define __casm__add_imm_r1_r0(x) \
	__builtin_annot("add r1, r0, "#x); \
	_impl__casm__add_imm_r1_r0(x);

#define __casm__add_imm_r4_r3(x) \
	__builtin_annot("add r4, r3, "#x); \
	_impl__casm__add_imm_r4_r3(x);

#define __casm__add_sp_sp_r3(x) \
	__builtin_annot("add sp, sp, r3"); \
	_impl__casm__add_sp_sp_r3(x);

#define __casm__add_sp_sp_r6(x) \
	__builtin_annot("add sp, sp, r6"); \
	_impl__casm__add_sp_sp_r6(x);

#define __casm__and_imm_r7_r7(x) \
	__builtin_annot("and r7, r7, "#x); \
	_impl__casm__and_imm_r7_r7(x); 

// #define __casm__and_imm_r7_r7(x) \
// 	__builtin_annot("and r7, r7, "#x); \
// 	_impl__casm__and_imm_r7_r7(x);

#define __casm__and_imm_r0_r0(x) \
	__builtin_annot("and r0, r0, "#x); \
	_impl__casm__and_imm_r0_r0(x);

#define __casm__and_imm_r3_r3(x) \
	__builtin_annot("and r3, r3, "#x); \
	_impl__casm__and_imm_r3_r3(x);


/// b ///
#define __casm__b(x) \
	__builtin_annot("b "#x); \
	if(1) goto x; \

#define __casm__b_ne(x) \
	__builtin_annot("bne "#x); \
	if(!_impl__casm__b_eq()) goto x;

// might need to double check this
#define __casm__bl(x) \
	__builtin_annot("bl "#x); \
	_impl__casm__add_imm_lr_lr(sizeof(uint32_t)); \
	if(1) goto x; \

#define __casm__bx_lr() \
	__builtin_annot("bx lr"); \
	_impl__casm__bx_lr();

#define __casm_bic_imm_r7_r7(x) \
	__builtin_annot("bic r7, r7, "#x); \
	_impl__casm__bic_imm_r7_r7(x);

#define __casm_bic_imm_r9_r9(x) \
	__builtin_annot("bic r9, r9, "#x); \
	_impl__casm__bic_imm_r9_r9(x);


/// c ///
#define __casm__cmp_imm_r7_r7(x) \
	__builtin_annot("cmp r7, r7, "#x); \
	_impl__casm__cmp_imm_r7(x);


/// d ///
// dmb
// dsb

/// e ///
// eret
#define __casm__eor_imm_r9_r9(x) \
	__builtin_annot("eor r9, r9, "#x); \
	_impl__casm__eor_imm_r9_r9(x);


/// h ///
// hvc

/// i ///
// isb


/// l ///
#define __casm__ldr_imm_r0_r0(x) \
	__builtin_annot("ldr r0, [r0, "#x"]"); \
	_impl__casm__ldr_imm_r0_r0(x);

#define __casm__ldrex_imm_r2_r0(x) \
	__builtin_annot("ldrex r2, [r0, "#x"]"); \
	_impl__casm__ldrex_imm_r2_r0(x);

#define __casm__ldr_pseudo_sp(x) \
	__builtin_annot("ldr sp, ="#x); \
	_impl__casm__ldr_pseudo_sp(&x);

#define __casm__lsr_imm_r7_r7(x) \
	__builtin_annot("lsr r7, r7, "#x); \
	_impl__casm__lsr_imm_r7_r7(x);


/// m ///
#define __casm__mcr_p15_0_r7_c14_c3_1() \
	__builtin_annot("mcr p15, 0, r7, c14, c3, 1"); \
	_impl__casm__mcr_p15_0_r7_c14_c3_1();

#define __casm__mcr_p15_4_r7_c1_c1_1() \
	__builtin_annot("mcr p15, 4, r7, c1, c1, 1"); \
	_impl__casm__mcr_p15_4_r7_c1_c1_1();

#define __casm__mcr_p15_4_r7_c1_c1_2() \
	__builtin_annot("mcr p15, 4, r7, c1, c1, 2"); \
	_impl__casm__mcr_p15_4_r7_c1_c1_2();

#define __casm__mcr_p15_4_r7_c14_c1_0() \
	__builtin_annot("mcr p15, 4, r7, c14, c1, 0"); \
	_impl__casm__mcr_p15_4_r7_c14_c1_0();

#define __casm__mcr_p15_0_r0_c1_c0_0() \
	__builtin_annot("mcr p15, 0, r0, c1, c0, 0"); \
	_impl__casm__mcr_p15_0_r0_c1_c0_0();

#define __casm__mcr_p15_0_r0_c1_c0_1() \
	__builtin_annot("mcr p15, 0, r0, c1, c0, 1"); \
	_impl__casm__mcr_p15_0_r0_c1_c0_1();

#define __casm__mcr_p15_0_r0_c12_c0_0() \
	__builtin_annot("mcr p15, 0, r0, c12, c0, 0"); \
	_impl__casm__mcr_p15_0_r0_c12_c0_0();

#define __casm__mcr_p15_4_r0_c1_c0_0() \
	__builtin_annot("mcr p15, 4, r0, c1, c0, 0"); \
	_impl__casm__mcr_p15_4_r0_c1_c0_0();

#define __casm__mcr_p15_4_r0_c1_c1_0() \
	__builtin_annot("mcr p15, 4, r0, c1, c1, 0"); \
	_impl__casm__mcr_p15_4_r0_c1_c1_0();

#define __casm__mcr_p15_4_r0_c1_c1_1() \
	__builtin_annot("mcr p15, 4, r0, c1, c1, 1"); \
	_impl__casm__mcr_p15_4_r0_c1_c1_1();

#define __casm__mcr_p15_4_r0_c1_c1_2() \
	__builtin_annot("mcr p15, 4, r0, c1, c1, 2"); \
	_impl__casm__mcr_p15_4_r0_c1_c1_2();

#define __casm__mcr_p15_4_r0_c1_c1_3() \
	__builtin_annot("mcr p15, 4, r0, c1, c1, 3"); \
	_impl__casm__mcr_p15_4_r0_c1_c1_3();

#define __casm__mcr_p15_4_r0_c12_c0_0() \
	__builtin_annot("mcr p15, 4, r0, c12, c0, 0"); \
	_impl__casm__mcr_p15_4_r0_c12_c0_0();

#define __casm__mcr_p15_4_r0_c2_c1_2() \
	__builtin_annot("mcr p15, 4, r0, c2, c1, 2"); \
	_impl__casm__mcr_p15_4_r0_c2_c1_2();

#define __casm__mcr_p15_0_r0_c10_c2_0() \
	__builtin_annot("mcr p15, 0, r0, c10, c2, 0"); \
	_impl__casm__mcr_p15_0_r0_c10_c2_0();

#define __casm__mcr_p15_0_r0_c10_c2_1() \
	__builtin_annot("mcr p15, 0, r0, c10, c2, 1"); \
	_impl__casm__mcr_p15_0_r0_c10_c2_1();

#define __casm__mcr_p15_0_r0_c2_c0_0() \
	__builtin_annot("mcr p15, 0, r0, c2, c0, 0"); \
	_impl__casm__mcr_p15_0_r0_c2_c0_0();

#define __casm__mcr_p15_0_r0_c2_c0_1() \
	__builtin_annot("mcr p15, 0, r0, c2, c0, 1"); \
	_impl__casm__mcr_p15_0_r0_c2_c0_1();

#define __casm__mcr_p15_0_r0_c2_c0_2() \
	__builtin_annot("mcr p15, 0, r0, c2, c0, 2"); \
	_impl__casm__mcr_p15_0_r0_c2_c0_2();

#define __casm__mcr_p15_0_r0_c3_c0_0() \
	__builtin_annot("mcr p15, 0, r0, c3, c0, 0"); \
	_impl__casm__mcr_p15_0_r0_c3_c0_0();

#define __casm__mcr_p15_0_r0_c7_c5_0() \
	__builtin_annot("mcr p15, 0, r0, c7, c5, 0"); \
	_impl__casm__mcr_p15_0_r0_c7_c5_0();

#define __casm__mcr_p15_0_r0_c7_c8_0() \
	__builtin_annot("mcr p15, 0, r0, c7, c8, 0"); \
	_impl__casm__mcr_p15_0_r0_c7_c8_0();

#define __casm__mcr_p15_0_r0_c7_c8_6() \
	__builtin_annot("mcr p15, 0, r0, c7, c8, 6"); \
	_impl__casm__mcr_p15_0_r0_c7_c8_6();

#define __casm__mcr_p15_0_r0_c8_c3_0() \
	__builtin_annot("mcr p15, 0, r0, c8, c3, 0"); \
	_impl__casm__mcr_p15_0_r0_c8_c3_0();

#define __casm__mcr_p15_4_r0_c10_c2_0() \
	__builtin_annot("mcr p15, 4, r0, c10, c2, 0"); \
	_impl__casm__mcr_p15_4_r0_c10_c2_0();

#define __casm__mcr_p15_4_r0_c10_c2_1() \
	__builtin_annot("mcr p15, 4, r0, c10, c2, 1"); \
	_impl__casm__mcr_p15_4_r0_c10_c2_1();

#define __casm__mcr_p15_4_r0_c14_c2_0() \
	__builtin_annot("mcr p15, 4, r0, c14, c2, 0"); \
	_impl__casm__mcr_p15_4_r0_c14_c2_0();

#define __casm__mcr_p15_4_r0_c14_c2_1() \
	__builtin_annot("mcr p15, 4, r0, c14, c2, 1"); \
	_impl__casm__mcr_p15_4_r0_c14_c2_1();

#define __casm__mcr_p15_4_r0_c2_c0_2() \
	__builtin_annot("mcr p15, 4, r0, c2, c0, 2"); \
	_impl__casm__mcr_p15_4_r0_c2_c0_2();

#define __casm__mcr_p15_4_r0_c8_c0_1() \
	__builtin_annot("mcr p15, 4, r0, c8, c0, 1"); \
	_impl__casm__mcr_p15_4_r0_c8_c0_1();

#define __casm__mcr_p15_4_r0_c8_c7_0() \
	__builtin_annot("mcr p15, 4, r0, c8, c7, 0"); \
	_impl__casm__mcr_p15_4_r0_c8_c7_0();


#define __casm__mcrr_p15_4_r0_r1_c2(); \
	__builtin_annot("mcrr p15, 4, r0, r1, c2"); \
	_impl__casm__mcrr_p15_4_r0_r1_c2();

#define __casm__mcrr_p15_6_r0_r1_c2(); \
	__builtin_annot("mcrr p15, 6, r0, r1, c2"); \
	_impl__casm__mcrr_p15_6_r0_r1_c2();

#define __casm__mcrr_p15_4_r7_r7_c14(); \
	__builtin_annot("mcrr p15, 4, r7, r7, c14"); \
	_impl__casm__mcrr_p15_4_r7_r7_c14();

#define __casm__mrc_p15_0_r7_c0_c1_1() \
	__builtin_annot("mrc p15, 0, r7, c0, c1, 1"); \
	_impl__casm__mrc_p15_0_r7_c0_c1_1();
	
#define __casm__mrc_p15_0_r7_c14_c3_1() \
	__builtin_annot("mrc p15, 0, r7, c14, c3, 1"); \
	_impl__casm__mrc_p15_0_r7_c14_c3_1();
	
#define __casm__mrc_p15_4_r7_c1_c1_1() \
	__builtin_annot("mrc p15, 4, r7, c1, c1, 1"); \
	_impl__casm__mrc_p15_4_r7_c1_c1_1();
	
#define __casm__mrc_p15_4_r7_c14_c1_0() \
	__builtin_annot("mrc p15, 4, r7, c14, c1, 0"); \
	_impl__casm__mrc_p15_4_r7_c14_c1_0();
	
#define __casm__mrc_p15_0_r0_c0_c0_5() \
	__builtin_annot("mrc p15, 0, r0, c0, c0, 5"); \
	_impl__casm__mrc_p15_0_r0_c0_c0_5();
	
#define __casm__mrc_p15_0_r3_c0_c0_5() \
	__builtin_annot("mrc p15, 0, r3, c0, c0, 5"); \
	_impl__casm__mrc_p15_0_r3_c0_c0_5();
	
#define __casm__mrc_p15_0_r0_c0_c2_4() \
	__builtin_annot("mrc p15, 0, r0, c0, c2, 4"); \
	_impl__casm__mrc_p15_0_r0_c0_c2_4();
	
#define __casm__mrc_p15_0_r0_c1_c0_0() \
	__builtin_annot("mrc p15, 0, r0, c1, c0, 0"); \
	_impl__casm__mrc_p15_0_r0_c1_c0_0();
	
#define __casm__mrc_p15_0_r0_c1_c0_1() \
	__builtin_annot("mrc p15, 0, r0, c1, c0, 1"); \
	_impl__casm__mrc_p15_0_r0_c1_c0_1();
	
#define __casm__mrc_p15_0_r0_c1_c1_0() \
	__builtin_annot("mrc p15, 0, r0, c1, c1, 0"); \
	_impl__casm__mrc_p15_0_r0_c1_c1_0();
	
#define __casm__mrc_p15_0_r0_c12_c0_0() \
	__builtin_annot("mrc p15, 0, r0, c12, c0, 0"); \
	_impl__casm__mrc_p15_0_r0_c12_c0_0();
	
#define __casm__mrc_p15_4_r0_c1_c0_0() \
	__builtin_annot("mrc p15, 4, r0, c1, c0, 0"); \
	_impl__casm__mrc_p15_4_r0_c1_c0_0();
	
#define __casm__mrc_p15_4_r0_c1_c1_0() \
	__builtin_annot("mrc p15, 4, r0, c1, c1, 0"); \
	_impl__casm__mrc_p15_4_r0_c1_c1_0();
	
#define __casm__mrc_p15_4_r0_c1_c1_1() \
	__builtin_annot("mrc p15, 4, r0, c1, c1, 1"); \
	_impl__casm__mrc_p15_4_r0_c1_c1_1();
	
#define __casm__mrc_p15_4_r0_c1_c1_2() \
	__builtin_annot("mrc p15, 4, r0, c1, c1, 2"); \
	_impl__casm__mrc_p15_4_r0_c1_c1_2();
	
#define __casm__mrc_p15_4_r0_c1_c1_3() \
	__builtin_annot("mrc p15, 4, r0, c1, c1, 3"); \
	_impl__casm__mrc_p15_4_r0_c1_c1_3();
	
#define __casm__mrc_p15_4_r0_c12_c0_0() \
	__builtin_annot("mrc p15, 4, r0, c12, c0, 0"); \
	_impl__casm__mrc_p15_4_r0_c12_c0_0();
	
#define __casm__mrc_p15_4_r0_c2_c1_2() \
	__builtin_annot("mrc p15, 4, r0, c2, c1, 2"); \
	_impl__casm__mrc_p15_4_r0_c2_c1_2();
	
#define __casm__mrc_p15_4_r0_c5_c2_0() \
	__builtin_annot("mrc p15, 4, r0, c5, c2, 0"); \
	_impl__casm__mrc_p15_4_r0_c5_c2_0();
	
#define __casm__mrc_p15_0_r0_c10_c2_0() \
	__builtin_annot("mrc p15, 0, r0, c10, c2, 0"); \
	_impl__casm__mrc_p15_0_r0_c10_c2_0();
	
#define __casm__mrc_p15_0_r0_c10_c2_1() \
	__builtin_annot("mrc p15, 0, r0, c10, c2, 1"); \
	_impl__casm__mrc_p15_0_r0_c10_c2_1();
	
#define __casm__mrc_p15_0_r0_c2_c0_0() \
	__builtin_annot("mrc p15, 0, r0, c2, c0, 0"); \
	_impl__casm__mrc_p15_0_r0_c2_c0_0();
	
#define __casm__mrc_p15_0_r0_c2_c0_1() \
	__builtin_annot("mrc p15, 0, r0, c2, c0, 1"); \
	_impl__casm__mrc_p15_0_r0_c2_c0_1();
	
#define __casm__mrc_p15_0_r0_c2_c0_2() \
	__builtin_annot("mrc p15, 0, r0, c2, c0, 2"); \
	_impl__casm__mrc_p15_0_r0_c2_c0_2();
	
#define __casm__mrc_p15_0_r0_c3_c0_0() \
	__builtin_annot("mrc p15, 0, r0, c3, c0, 0"); \
	_impl__casm__mrc_p15_0_r0_c3_c0_0();
	
#define __casm__mrc_p15_0_r0_c7_c4_0() \
	__builtin_annot("mrc p15, 0, r0, c7, c4, 0"); \
	_impl__casm__mrc_p15_0_r0_c7_c4_0();
	
#define __casm__mrc_p15_4_r0_c10_c2_0() \
	__builtin_annot("mrc p15, 4, r0, c10, c2, 0"); \
	_impl__casm__mrc_p15_4_r0_c10_c2_0();
	
#define __casm__mrc_p15_4_r0_c10_c2_1() \
	__builtin_annot("mrc p15, 4, r0, c10, c2, 1"); \
	_impl__casm__mrc_p15_4_r0_c10_c2_1();
	
#define __casm__mrc_p15_4_r0_c14_c2_0() \
	__builtin_annot("mrc p15, 4, r0, c14, c2, 0"); \
	_impl__casm__mrc_p15_4_r0_c14_c2_0();
	
#define __casm__mrc_p15_4_r0_c14_c2_1() \
	__builtin_annot("mrc p15, 4, r0, c14, c2, 1"); \
	_impl__casm__mrc_p15_4_r0_c14_c2_1();
	
#define __casm__mrc_p15_4_r0_c2_c0_2() \
	__builtin_annot("mrc p15, 4, r0, c2, c0, 2"); \
	_impl__casm__mrc_p15_4_r0_c2_c0_2();
	
#define __casm__mrc_p15_4_r0_c6_c0_0() \
	__builtin_annot("mrc p15, 4, r0, c6, c0, 0"); \
	_impl__casm__mrc_p15_4_r0_c6_c0_0();
	
#define __casm__mrc_p15_4_r0_c6_c0_4() \
	__builtin_annot("mrc p15, 4, r0, c6, c0, 4"); \
	_impl__casm__mrc_p15_4_r0_c6_c0_4();

#define __casm__mrrc_p15_0_r0_r1_c14() \
	__builtin_annot("mrrc p15,0,r0,r1,c14"); \
	_impl__casm__mrrc_p15_0_r0_r1_c14();

#define __casm__mrrc_p15_6_r0_r1_c2() \
	__builtin_annot("mrrc p15,6,r0,r1,c2"); \
	_impl__casm__mrrc_p15_6_r0_r1_c2();

#define __casm__mrrc_p15_4_r0_r1_c2() \
	__builtin_annot("mrrc p15,4,r0,r1,c2"); \
	_impl__casm__mrrc_p15_4_r0_r1_c2();


#define __casm__mrs_r9_cpsr(); \
	__builtin_annot("mrs r9, cpsr"); \
	_impl__casm__mrs_r9_cpsr();

#define __casm__mrs_r0_elrhyp(); \
	__builtin_annot("mrs r0, ELR_hyp"); \
	_impl__casm__mrs_r0_elrhyp();

#define __casm__mrs_r0_spsrhyp(); \
	__builtin_annot("mrs r0, SPSR_hyp"); \
	_impl__casm__mrs_r0_spsrhyp();

#define __casm__mrs_r0_cpsr(); \
	__builtin_annot("mrs r0, cpsr"); \
	_impl__casm__mrs_r0_cpsr();

#define __casm__msr_spsrcxsf_r9() \
	__builtin_annot("msr spsr_cxsf, r9"); \
	_impl__casm__msr_spsrcxsf_r9();

#define __casm__msr_elrhyp_r0() \
	__builtin_annot("msr ELR_hyp, r0"); \
	_impl__casm__msr_elrhyp_r0();

#define __casm__msr_elrhyp_r3() \
	__builtin_annot("msr ELR_hyp, r3"); \
	_impl__casm__msr_elrhyp_r3();

#define __casm__msr_cpsr_r0() \
	__builtin_annot("msr cpsr, r0"); \
	_impl__casm__msr_cpsr_r0();


#define __casm__mov_r0_sp(x) \
	__builtin_annot("mov r0, sp"); \
	_impl__casm__mov_r0_sp();

#define __casm__mov_imm_r1(x) \
	__builtin_annot("mov r1, "#x); \
	_impl__casm__mov_imm_r1(x);

#define __casm__mov_imm_r2(x) \
	__builtin_annot("mov r2, "#x); \
	_impl__casm__mov_imm_r2(x);

#define __casm__mov_imm_r5(x) \
	__builtin_annot("mov r5, "#x); \
	_impl__casm__mov_imm_r5(x);

#define __casm__mov_imm_r7(x) \
	__builtin_annot("mov r7, "#x); \
	_impl__casm__mov_imm_r7(x);

#define __casm__mul_r3_r2_r1() \
	__builtin_annot("mul r3, r2, r1"); \
	_impl__casm__mul_r3_r2_r1();

#define __casm__mul_r6_r4_r5() \
	__builtin_annot("mul r6, r4, r5"); \
	_impl__casm__mul_r6_r4_r5();


/// o
#define __casm__orr_imm_r7_r7(x) \
	__builtin_annot("orr r7, r7, "#x); \
	_impl__casm__orr_imm_r7_r7(x);

#define __casm__orr_imm_r9_r9(x) \
	__builtin_annot("orr r9, r9, "#x); \
	_impl__casm__orr_imm_r9_r9(x);


/// p ///
#define __casm__pop_lr() \
	__builtin_annot("pop {lr}"); \
	_impl__casm__pop_lr();

#define __casm__pop_r0() \
	__builtin_annot("pop {r0}"); \
	_impl__casm__pop_r0();

#define __casm__pop_r1() \
	__builtin_annot("pop {r1}"); \
	_impl__casm__pop_r1();

#define __casm__pop_r2() \
	__builtin_annot("pop {r2}"); \
	_impl__casm__pop_r2();

#define __casm__pop_r3() \
	__builtin_annot("pop {r3}"); \
	_impl__casm__pop_r3();

#define __casm__pop_r4() \
	__builtin_annot("pop {r4}"); \
	_impl__casm__pop_r4();

#define __casm__pop_r5() \
	__builtin_annot("pop {r5}"); \
	_impl__casm__pop_r5();

#define __casm__pop_r6() \
	__builtin_annot("pop {r6}"); \
	_impl__casm__pop_r6();

#define __casm__pop_r7() \
	__builtin_annot("pop {r7}"); \
	_impl__casm__pop_r7();

#define __casm__pop_r8() \
	__builtin_annot("pop {r8}"); \
	_impl__casm__pop_r8();

#define __casm__pop_r9() \
	__builtin_annot("pop {r9}"); \
	_impl__casm__pop_r9();

#define __casm__pop_r10() \
	__builtin_annot("pop {r10}"); \
	_impl__casm__pop_r10();

#define __casm__pop_r11() \
	__builtin_annot("pop {r11}"); \
	_impl__casm__pop_r11();

#define __casm__pop_r12() \
	__builtin_annot("pop {r12}"); \
	_impl__casm__pop_r12();

#define __casm__push_lr() \
	__builtin_annot("push {lr}"); \
	_impl__casm__push_lr();

#define __casm__push_r0() \
	__builtin_annot("push {r0}"); \
	_impl__casm__push_r0();

#define __casm__push_r1() \
	__builtin_annot("push {r1}"); \
	_impl__casm__push_r1();

#define __casm__push_r2() \
	__builtin_annot("push {r2}"); \
	_impl__casm__push_r2();

#define __casm__push_r3() \
	__builtin_annot("push {r3}"); \
	_impl__casm__push_r3();

#define __casm__push_r4() \
	__builtin_annot("push {r4}"); \
	_impl__casm__push_r4();

#define __casm__push_r5() \
	__builtin_annot("push {r5}"); \
	_impl__casm__push_r5();

#define __casm__push_r6() \
	__builtin_annot("push {r6}"); \
	_impl__casm__push_r6();

#define __casm__push_r7() \
	__builtin_annot("push {r7}"); \
	_impl__casm__push_r7();

#define __casm__push_r8() \
	__builtin_annot("push {r8}"); \
	_impl__casm__push_r8();

#define __casm__push_r9() \
	__builtin_annot("push {r9}"); \
	_impl__casm__push_r9();

#define __casm__push_r10() \
	__builtin_annot("push {r10}"); \
	_impl__casm__push_r10();

#define __casm__push_r11() \
	__builtin_annot("push {r11}"); \
	_impl__casm__push_r11();

#define __casm__push_r12() \
	__builtin_annot("push {r12}"); \
	_impl__casm__push_r12();


/// s ///
// sev
// svc
#define __casm__str_r1_r0(x) \
	__builtin_annot("str r1, [r0, "#x"]"); \
	_impl__casm__str_r1_r0(x);

#define __casm__strex_eq_r3_r1_r0(x) \
	__builtin_annot("strexeq r3, r1, [r0, "#x"]"); \
	_impl__casm__strex_eq_r3_r1_r0(x);

/// t ///
#define __casm__teq_imm_r2(x) \
	__builtin_annot("teq r2, "#x); \
	_impl__casm__teq_imm_r2(x);

#define __casm__teq_eq_imm_r3(x) \
	__builtin_annot("teqeq r3, "#x); \
	_impl__casm__teq_eq_imm_r3(x);

#define __casm__tst_imm_r9(x) \
	__builtin_annot("tst r9, "#x); \
	_impl__casm__tst_imm_r9(x);


/// w ///
// wfene

#endif /* __HWM_ARCH_ARM_GENERIC__CPU_H__ */