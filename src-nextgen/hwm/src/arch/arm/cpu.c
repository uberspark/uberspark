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
 * arm cpu hardware model implementation
 * author: ethan joseph (ethanj217@gmail.com)
*/


#include <uberspark/include/uberspark.h>
// #include <stdint.h>

uint32_t hwm_cpu_gprs_r0 = 0;  // General purpose
uint32_t hwm_cpu_gprs_r1 = 0;  // General purpose
uint32_t hwm_cpu_gprs_r2 = 0;  // General purpose
uint32_t hwm_cpu_gprs_r3 = 0;  // General purpose
uint32_t hwm_cpu_gprs_r4 = 0;  // General purpose
uint32_t hwm_cpu_gprs_r5 = 0;  // General purpose
uint32_t hwm_cpu_gprs_r6 = 0;  // General purpose
uint32_t hwm_cpu_gprs_r7 = 0;  // Holds Syscall Number
uint32_t hwm_cpu_gprs_r8 = 0;  // General purpose
uint32_t hwm_cpu_gprs_r9 = 0;  // General purpose
uint32_t hwm_cpu_gprs_r10 = 0;  // General purpose
uint32_t hwm_cpu_gprs_r11 = 0;  // FP // Frame Pointer

// special purpose
uint32_t hwm_cpu_gprs_r12 = 0;  // IP // Intra Procedural Call
uint32_t hwm_cpu_gprs_r13 = 0;  // SP // Stack Pointer
uint32_t hwm_cpu_gprs_r14 = 0;  // LR //Link Register
uint32_t hwm_cpu_gprs_r15 = 0;  // PC //Program Counter
uint32_t hwm_cpu_gprs_CPSR = 0; // Current Program Status Register

// coprocessor registers
uint32_t hwm_cpu_cprs_c0 = 0;
uint32_t hwm_cpu_cprs_c1 = 0;
uint32_t hwm_cpu_cprs_c2 = 0;
uint32_t hwm_cpu_cprs_c3 = 0;
uint32_t hwm_cpu_cprs_c4 = 0;
uint32_t hwm_cpu_cprs_c5 = 0;
uint32_t hwm_cpu_cprs_c6 = 0;
uint32_t hwm_cpu_cprs_c7 = 0;
uint32_t hwm_cpu_cprs_c8 = 0;
uint32_t hwm_cpu_cprs_c9 = 0;
uint32_t hwm_cpu_cprs_c10 = 0;
uint32_t hwm_cpu_cprs_c11 = 0;
uint32_t hwm_cpu_cprs_c12 = 0;
uint32_t hwm_cpu_cprs_c13 = 0;
uint32_t hwm_cpu_cprs_c14 = 0;

// system coprocessor special registers
uint32_t hwm_cpu_ssrs_cpsr = 0;
uint32_t hwm_cpu_ssrs_elrhyp = 0;
uint32_t hwm_cpu_ssrs_spsrhyp = 0;
uint32_t hwm_cpu_ssrs_spsrcxsf = 0;

// bool for operating mode (1 for thumb)
uint8_t hwm_cpu_isthumb = 0;

enum CPSR_FLAGS {
	CPSR_FLAGS_M = 1U << 4,
	CPSR_FLAGS_T = 1U << 5,
	CPSR_FLAGS_F = 1U << 6,
	CPSR_FLAGS_I = 1U << 7,
	CPSR_FLAGS_A = 1U << 8,
	CPSR_FLAGS_E = 1U << 9,
	CPSR_FLAGS_IT = 1U << 15,
	CPSR_FLAGS_GE = 1U << 19,
	CPSR_FLAGS_J = 1U << 24,
	CPSR_FLAGS_IT2 = 1U << 26,
	CPSR_FLAGS_Q = 1U << 27,
	CPSR_FLAGS_V = 1U << 28,
	CPSR_FLAGS_C = 1U << 29,
	CPSR_FLAGS_Z = 1U << 30,
	CPSR_FLAGS_N = 1U << 31,
};

// add
void _impl__casm__add_imm_r1_r0(uint32_t value) {
	hwm_cpu_gprs_r1 = hwm_cpu_gprs_r0 + value;
}

void _impl__casm__add_imm_r4_r3(uint32_t value) {
	hwm_cpu_gprs_r4 = hwm_cpu_gprs_r3 + value;
}

void _impl__casm__add_imm_lr_lr(uint32_t value) {
	hwm_cpu_gprs_r14 = hwm_cpu_gprs_r14 + value;
}

void _impl__casm__add_sp_sp_r3() {
	hwm_cpu_gprs_r13 = hwm_cpu_gprs_r13 + hwm_cpu_gprs_r3;
}

void _impl__casm__add_sp_sp_r6() {
	hwm_cpu_gprs_r13 = hwm_cpu_gprs_r13 + hwm_cpu_gprs_r6;
}

// and
void _impl__casm__and_imm_r7_r7(uint32_t value) {
	hwm_cpu_gprs_r7 = hwm_cpu_gprs_r7 & value;
}

void _impl__casm__and_imm_r0_r0(uint32_t value) {
	hwm_cpu_gprs_r0 = hwm_cpu_gprs_r0 & value;
}

void _impl__casm__and_imm_r3_r3(uint32_t value) {
	hwm_cpu_gprs_r3 = hwm_cpu_gprs_r3 & value;
}

// bic
void _impl__casm__bic_imm_r7_r7(uint32_t value) {
	hwm_cpu_gprs_r7 = hwm_cpu_gprs_r7 & ~value;
}

void _impl__casm__bic_imm_r9_r9(uint32_t value) {
	hwm_cpu_gprs_r9 = hwm_cpu_gprs_r9 & ~value;
}

// bne

uint32_t _impl__casm__b_eq() {
	return hwm_cpu_gprs_CPSR & CPSR_FLAGS_N;
}


//
void _impl__casm__bx_lr() {
	hwm_cpu_isthumb = hwm_cpu_gprs_r14 & 1U;
	if(1) goto *hwm_cpu_gprs_r14;
}


// cmp
void _impl__casm__cmp_imm_r7(uint32_t value) {
	// also can modify z c v flags, do we need checks for that?
	if (hwm_cpu_gprs_r7 - value < 0) {
		hwm_cpu_gprs_CPSR |= CPSR_FLAGS_N;
	} else {
		hwm_cpu_gprs_CPSR &= ~CPSR_FLAGS_N;
	}
}

// eor
void _impl__casm__eor_imm_r9_r9(uint32_t value) {
	hwm_cpu_gprs_r9 = hwm_cpu_gprs_r9 ^ value;
}

// eret (https://developer.arm.com/documentation/dui0489/h/arm-and-thumb-instructions/eret)
// MOVS PC, LR 

//ldr //needs work
void _impl__casm__ldr_imm_r0_r0(uint32_t offset) {
	hwm_cpu_gprs_r0 = *((uint32_t*)hwm_cpu_gprs_r0 + offset);
}

void _impl__casm__ldrex_imm_r2_r0(uint32_t offset) {
	hwm_cpu_gprs_r2 = *((uint32_t*)hwm_cpu_gprs_r0 + offset);
}

// void _impl__casm__ldr_psuedo_sp(uint32_t addr) {
// } in cpu.h

// lsr
void _impl__casm__lsr_imm_r7_r7(uint32_t value) {
	hwm_cpu_gprs_r7 = hwm_cpu_gprs_r7 >> value;
}

// mcr/mcrr (might need to have different versions for the different opcodes)
// i cant find any concrete documentation on what the opcodes do and the second cp register
void _impl__casm__mcr_p15_0_r7_c14_c3_1() {
	hwm_cpu_cprs_c14 = hwm_cpu_gprs_r7;
}
void _impl__casm__mcr_p15_4_r7_c1_c1_1() {
	hwm_cpu_cprs_c1 = hwm_cpu_gprs_r7;
}
void _impl__casm__mcr_p15_4_r7_c1_c1_2() {
	hwm_cpu_cprs_c1 = hwm_cpu_gprs_r7;
}
void _impl__casm__mcr_p15_4_r7_c14_c1_0() {
	hwm_cpu_cprs_c14 = hwm_cpu_gprs_r7;
}
void _impl__casm__mcr_p15_0_r0_c1_c0_0() {
	hwm_cpu_cprs_c1 = hwm_cpu_gprs_r0;
}
void _impl__casm__mcr_p15_0_r0_c1_c0_1() {
	hwm_cpu_cprs_c1 = hwm_cpu_gprs_r0;
}
void _impl__casm__mcr_p15_0_r0_c12_c0_0() {
	hwm_cpu_cprs_c12 = hwm_cpu_gprs_r0;
}
void _impl__casm__mcr_p15_4_r0_c1_c0_0() {
	hwm_cpu_cprs_c1 = hwm_cpu_gprs_r0;
}
void _impl__casm__mcr_p15_4_r0_c1_c1_0() {
	hwm_cpu_cprs_c1 = hwm_cpu_gprs_r0;
}
void _impl__casm__mcr_p15_4_r0_c1_c1_1() {
	hwm_cpu_cprs_c1 = hwm_cpu_gprs_r0;
}
void _impl__casm__mcr_p15_4_r0_c1_c1_2() {
	hwm_cpu_cprs_c1 = hwm_cpu_gprs_r0;
}
void _impl__casm__mcr_p15_4_r0_c1_c1_3() {
	hwm_cpu_cprs_c1 = hwm_cpu_gprs_r0;
}
void _impl__casm__mcr_p15_4_r0_c12_c0_0() {
	hwm_cpu_cprs_c12 = hwm_cpu_gprs_r0;
}
void _impl__casm__mcr_p15_4_r0_c2_c1_2() {
	hwm_cpu_cprs_c2 = hwm_cpu_gprs_r0;
}
void _impl__casm__mcr_p15_0_r0_c10_c2_0() {
	hwm_cpu_cprs_c10 = hwm_cpu_gprs_r0;
}
void _impl__casm__mcr_p15_0_r0_c10_c2_1() {
	hwm_cpu_cprs_c10 = hwm_cpu_gprs_r0;
}
void _impl__casm__mcr_p15_0_r0_c2_c0_0() {
	hwm_cpu_cprs_c2 = hwm_cpu_gprs_r0;
}
void _impl__casm__mcr_p15_0_r0_c2_c0_1() {
	hwm_cpu_cprs_c2 = hwm_cpu_gprs_r0;
}
void _impl__casm__mcr_p15_0_r0_c2_c0_2() {
	hwm_cpu_cprs_c2 = hwm_cpu_gprs_r0;
}
void _impl__casm__mcr_p15_0_r0_c3_c0_0() {
	hwm_cpu_cprs_c3 = hwm_cpu_gprs_r0;
}
void _impl__casm__mcr_p15_0_r0_c7_c5_0() {
	hwm_cpu_cprs_c7 = hwm_cpu_gprs_r0;
}
void _impl__casm__mcr_p15_0_r0_c7_c8_0() {
	hwm_cpu_cprs_c7 = hwm_cpu_gprs_r0;
}
void _impl__casm__mcr_p15_0_r0_c7_c8_6() {
	hwm_cpu_cprs_c7 = hwm_cpu_gprs_r0;
}
void _impl__casm__mcr_p15_0_r0_c8_c3_0() {
	hwm_cpu_cprs_c8 = hwm_cpu_gprs_r0;
}
void _impl__casm__mcr_p15_4_r0_c10_c2_0() {
	hwm_cpu_cprs_c10 = hwm_cpu_gprs_r0;
}
void _impl__casm__mcr_p15_4_r0_c10_c2_1() {
	hwm_cpu_cprs_c10 = hwm_cpu_gprs_r0;
}
void _impl__casm__mcr_p15_4_r0_c14_c2_0() {
	hwm_cpu_cprs_c14 = hwm_cpu_gprs_r0;
}
void _impl__casm__mcr_p15_4_r0_c14_c2_1() {
	hwm_cpu_cprs_c14 = hwm_cpu_gprs_r0;
}
void _impl__casm__mcr_p15_4_r0_c2_c0_2() {
	hwm_cpu_cprs_c2 = hwm_cpu_gprs_r0;
}
void _impl__casm__mcr_p15_4_r0_c8_c0_1() {
	hwm_cpu_cprs_c8 = hwm_cpu_gprs_r0;
}
void _impl__casm__mcr_p15_4_r0_c8_c7_0() {
	hwm_cpu_cprs_c8 = hwm_cpu_gprs_r0;
}

// mcrr
void _impl__casm__mcrr_p15_4_r7_r7_c14() {
	hwm_cpu_cprs_c14 = hwm_cpu_gprs_r7;
}
void _impl__casm__mcrr_p15_4_r0_r1_c2() {
	hwm_cpu_cprs_c2 = hwm_cpu_gprs_r0;
}
void _impl__casm__mcrr_p15_6_r0_r1_c2() {
	hwm_cpu_cprs_c2 = hwm_cpu_gprs_r0;
}

//mrc
void _impl__casm__mrc_p15_0_r7_c0_c1_1() {
	hwm_cpu_gprs_r7 = hwm_cpu_cprs_c0;
}
void _impl__casm__mrc_p15_0_r7_c14_c3_1() {
	hwm_cpu_gprs_r7 = hwm_cpu_cprs_c14;
}
void _impl__casm__mrc_p15_4_r7_c1_c1_1() {
	hwm_cpu_gprs_r7 = hwm_cpu_cprs_c1;
}
void _impl__casm__mrc_p15_4_r7_c14_c1_0() {
	hwm_cpu_gprs_r7 = hwm_cpu_cprs_c14;
}
void _impl__casm__mrc_p15_0_r0_c0_c0_5() {
	hwm_cpu_gprs_r0 = hwm_cpu_cprs_c0;
}
void _impl__casm__mrc_p15_0_r3_c0_c0_5() {
	hwm_cpu_gprs_r3 = hwm_cpu_cprs_c0;
}
void _impl__casm__mrc_p15_0_r0_c0_c2_4() {
	hwm_cpu_gprs_r0 = hwm_cpu_cprs_c0;
}
void _impl__casm__mrc_p15_0_r0_c1_c0_0() {
	hwm_cpu_gprs_r0 = hwm_cpu_cprs_c1;
}
void _impl__casm__mrc_p15_0_r0_c1_c0_1() {
	hwm_cpu_gprs_r0 = hwm_cpu_cprs_c1;
}
void _impl__casm__mrc_p15_0_r0_c1_c1_0() {
	hwm_cpu_gprs_r0 = hwm_cpu_cprs_c1;
}
void _impl__casm__mrc_p15_0_r0_c12_c0_0() {
	hwm_cpu_gprs_r0 = hwm_cpu_cprs_c12;
}
void _impl__casm__mrc_p15_4_r0_c1_c0_0() {
	hwm_cpu_gprs_r0 = hwm_cpu_cprs_c1;
}
void _impl__casm__mrc_p15_4_r0_c1_c1_0() {
	hwm_cpu_gprs_r0 = hwm_cpu_cprs_c1;
}
void _impl__casm__mrc_p15_4_r0_c1_c1_1() {
	hwm_cpu_gprs_r0 = hwm_cpu_cprs_c1;
}
void _impl__casm__mrc_p15_4_r0_c1_c1_2() {
	hwm_cpu_gprs_r0 = hwm_cpu_cprs_c1;
}
void _impl__casm__mrc_p15_4_r0_c1_c1_3() {
	hwm_cpu_gprs_r0 = hwm_cpu_cprs_c1;
}
void _impl__casm__mrc_p15_4_r0_c12_c0_0() {
	hwm_cpu_gprs_r0 = hwm_cpu_cprs_c12;
}
void _impl__casm__mrc_p15_4_r0_c2_c1_2() {
	hwm_cpu_gprs_r0 = hwm_cpu_cprs_c2;
}
void _impl__casm__mrc_p15_4_r0_c5_c2_0() {
	hwm_cpu_gprs_r0 = hwm_cpu_cprs_c5;
}
void _impl__casm__mrc_p15_0_r0_c10_c2_0() {
	hwm_cpu_gprs_r0 = hwm_cpu_cprs_c10;
}
void _impl__casm__mrc_p15_0_r0_c10_c2_1() {
	hwm_cpu_gprs_r0 = hwm_cpu_cprs_c10;
}
void _impl__casm__mrc_p15_0_r0_c2_c0_0() {
	hwm_cpu_gprs_r0 = hwm_cpu_cprs_c2;
}
void _impl__casm__mrc_p15_0_r0_c2_c0_1() {
	hwm_cpu_gprs_r0 = hwm_cpu_cprs_c2;
}
void _impl__casm__mrc_p15_0_r0_c2_c0_2() {
	hwm_cpu_gprs_r0 = hwm_cpu_cprs_c2;
}
void _impl__casm__mrc_p15_0_r0_c3_c0_0() {
	hwm_cpu_gprs_r0 = hwm_cpu_cprs_c3;
}
void _impl__casm__mrc_p15_0_r0_c7_c4_0() {
	hwm_cpu_gprs_r0 = hwm_cpu_cprs_c7;
}
void _impl__casm__mrc_p15_4_r0_c10_c2_0() {
	hwm_cpu_gprs_r0 = hwm_cpu_cprs_c10;
}
void _impl__casm__mrc_p15_4_r0_c10_c2_1() {
	hwm_cpu_gprs_r0 = hwm_cpu_cprs_c10;
}
void _impl__casm__mrc_p15_4_r0_c14_c2_0() {
	hwm_cpu_gprs_r0 = hwm_cpu_cprs_c14;
}
void _impl__casm__mrc_p15_4_r0_c14_c2_1() {
	hwm_cpu_gprs_r0 = hwm_cpu_cprs_c14;
}
void _impl__casm__mrc_p15_4_r0_c2_c0_2() {
	hwm_cpu_gprs_r0 = hwm_cpu_cprs_c2;
}
void _impl__casm__mrc_p15_4_r0_c6_c0_0() {
	hwm_cpu_gprs_r0 = hwm_cpu_cprs_c6;
}
void _impl__casm__mrc_p15_4_r0_c6_c0_4() {
	hwm_cpu_gprs_r0 = hwm_cpu_cprs_c6;
}

// mrrc
// mrrc is used to access 64 bit registers?
// do we need 64 bit variants for the cprs?
void _impl__casm__mrrc_p15_0_r0_r1_c14() {
	hwm_cpu_gprs_r0 = hwm_cpu_cprs_c14;
}
void _impl__casm__mrrc_p15_6_r0_r1_c2() {
	hwm_cpu_gprs_r0 = hwm_cpu_cprs_c2;
}
void _impl__casm__mrrc_p15_4_r0_r1_c2() {
	hwm_cpu_gprs_r0 = hwm_cpu_cprs_c2;
}

// mrs

void _impl__casm__mrs_r9_cpsr() {
	hwm_cpu_gprs_r9 = hwm_cpu_ssrs_cpsr;
}

void _impl__casm__mrs_r0_elrhyp() {
	hwm_cpu_gprs_r0 = hwm_cpu_ssrs_elrhyp;
}

void _impl__casm__mrs_r0_spsrhyp() {
	hwm_cpu_gprs_r0 = hwm_cpu_ssrs_spsrhyp;
}

void _impl__casm__mrs_r0_cpsr() {
	hwm_cpu_gprs_r0 = hwm_cpu_ssrs_cpsr;
}

// msr

void _impl__casm__msr_spsrcxsf_r9() {
	hwm_cpu_ssrs_spsrcxsf = hwm_cpu_gprs_r9;
}

void _impl__casm__msr_elrhyp_r0() {
	hwm_cpu_ssrs_elrhyp = hwm_cpu_gprs_r0;
}

void _impl__casm__msr_elrhyp_r3() {
	hwm_cpu_ssrs_elrhyp = hwm_cpu_gprs_r3;
}

void _impl__casm__msr_cpsr_r0() {
	hwm_cpu_ssrs_cpsr = hwm_cpu_gprs_r0;
}

// mov
void _impl__casm__mov_imm_r7(uint32_t value) {
	hwm_cpu_gprs_r7 = value;
}

void _impl__casm__mov_r0_sp(uint32_t value) {
	hwm_cpu_gprs_r0 = hwm_cpu_gprs_r13;
}

void _impl__casm__mov_imm_r1(uint32_t value) {
	hwm_cpu_gprs_r1 = value;
}

void _impl__casm__mov_imm_r2(uint32_t value) {
	hwm_cpu_gprs_r2 = value;
}

void _impl__casm__mov_imm_r5(uint32_t value) {
	hwm_cpu_gprs_r5 = value;
}

//mul

void _impl__casm__mul_r3_r2_r1() {
	hwm_cpu_gprs_r3 = hwm_cpu_gprs_r2 * hwm_cpu_gprs_r1;
}

void _impl__casm__mul_r6_r4_r5() {
	hwm_cpu_gprs_r6 = hwm_cpu_gprs_r4 * hwm_cpu_gprs_r5;
}

// orr

void _impl__casm__orr_imm_r7_r7(uint32_t value) {
	hwm_cpu_gprs_r7 = hwm_cpu_gprs_r6 | value;
}

void _impl__casm__orr_imm_r9_r9(uint32_t value) {
	hwm_cpu_gprs_r9 = hwm_cpu_gprs_r9 | value;
}

// pop
void _impl__casm__pop_lr() {
	hwm_cpu_gprs_r14 = *((uint32_t *)hwm_cpu_gprs_r13);
	hwm_cpu_gprs_r13 += sizeof(uint32_t);
}

void _impl__casm__pop_r0() {
	hwm_cpu_gprs_r0 = *((uint32_t *)hwm_cpu_gprs_r13);
	hwm_cpu_gprs_r13 += sizeof(uint32_t);
}

void _impl__casm__pop_r1() {
	hwm_cpu_gprs_r1 = *((uint32_t *)hwm_cpu_gprs_r13);
	hwm_cpu_gprs_r13 += sizeof(uint32_t);
}


void _impl__casm__pop_r2() {
	hwm_cpu_gprs_r2 = *((uint32_t *)hwm_cpu_gprs_r13);
	hwm_cpu_gprs_r13 += sizeof(uint32_t);
}


void _impl__casm__pop_r3() {
	hwm_cpu_gprs_r3 = *((uint32_t *)hwm_cpu_gprs_r13);
	hwm_cpu_gprs_r13 += sizeof(uint32_t);
}


void _impl__casm__pop_r4() {
	hwm_cpu_gprs_r4 = *((uint32_t *)hwm_cpu_gprs_r13);
	hwm_cpu_gprs_r13 += sizeof(uint32_t);
}


void _impl__casm__pop_r5() {
	hwm_cpu_gprs_r5 = *((uint32_t *)hwm_cpu_gprs_r13);
	hwm_cpu_gprs_r13 += sizeof(uint32_t);
}


void _impl__casm__pop_r6() {
	hwm_cpu_gprs_r6 = *((uint32_t *)hwm_cpu_gprs_r13);
	hwm_cpu_gprs_r13 += sizeof(uint32_t);
}


void _impl__casm__pop_r7() {
	hwm_cpu_gprs_r7 = *((uint32_t *)hwm_cpu_gprs_r13);
	hwm_cpu_gprs_r13 += sizeof(uint32_t);
}


void _impl__casm__pop_r8() {
	hwm_cpu_gprs_r8 = *((uint32_t *)hwm_cpu_gprs_r13);
	hwm_cpu_gprs_r13 += sizeof(uint32_t);
}


void _impl__casm__pop_r9() {
	hwm_cpu_gprs_r9 = *((uint32_t *)hwm_cpu_gprs_r13);
	hwm_cpu_gprs_r13 += sizeof(uint32_t);
}


void _impl__casm__pop_r10() {
	hwm_cpu_gprs_r10 = *((uint32_t *)hwm_cpu_gprs_r13);
	hwm_cpu_gprs_r13 += sizeof(uint32_t);
}


void _impl__casm__pop_r11() {
	hwm_cpu_gprs_r11 = *((uint32_t *)hwm_cpu_gprs_r13);
	hwm_cpu_gprs_r13 += sizeof(uint32_t);
}


void _impl__casm__pop_r12() {
	hwm_cpu_gprs_r12 = *((uint32_t *)hwm_cpu_gprs_r13);
	hwm_cpu_gprs_r13 += sizeof(uint32_t);
}

// push
void _impl__casm__push_lr() {
	hwm_cpu_gprs_r13 -= sizeof(uint32_t);
	*((uint32_t *)hwm_cpu_gprs_r13) = hwm_cpu_gprs_r14;
}

void _impl__casm__push_r0() {
	hwm_cpu_gprs_r0 -= sizeof(uint32_t);
	*((uint32_t *)hwm_cpu_gprs_r13) = hwm_cpu_gprs_r0;
}

void _impl__casm__push_r1() {
	hwm_cpu_gprs_r1 -= sizeof(uint32_t);
	*((uint32_t *)hwm_cpu_gprs_r13) = hwm_cpu_gprs_r1;
}


void _impl__casm__push_r2() {
	hwm_cpu_gprs_r2 -= sizeof(uint32_t);
	*((uint32_t *)hwm_cpu_gprs_r13) = hwm_cpu_gprs_r2;
}


void _impl__casm__push_r3() {
	hwm_cpu_gprs_r3 -= sizeof(uint32_t);
	*((uint32_t *)hwm_cpu_gprs_r13) = hwm_cpu_gprs_r3;
}


void _impl__casm__push_r4() {
	hwm_cpu_gprs_r4 -= sizeof(uint32_t);
	*((uint32_t *)hwm_cpu_gprs_r13) = hwm_cpu_gprs_r4;
}


void _impl__casm__push_r5() {
	hwm_cpu_gprs_r5 -= sizeof(uint32_t);
	*((uint32_t *)hwm_cpu_gprs_r13) = hwm_cpu_gprs_r5;
}


void _impl__casm__push_r6() {
	hwm_cpu_gprs_r6 -= sizeof(uint32_t);
	*((uint32_t *)hwm_cpu_gprs_r13) = hwm_cpu_gprs_r6;
}


void _impl__casm__push_r7() {
	hwm_cpu_gprs_r7 -= sizeof(uint32_t);
	*((uint32_t *)hwm_cpu_gprs_r13) = hwm_cpu_gprs_r7;
}


void _impl__casm__push_r8() {
	hwm_cpu_gprs_r8 -= sizeof(uint32_t);
	*((uint32_t *)hwm_cpu_gprs_r13) = hwm_cpu_gprs_r8;
}


void _impl__casm__push_r9() {
	hwm_cpu_gprs_r9 -= sizeof(uint32_t);
	*((uint32_t *)hwm_cpu_gprs_r13) = hwm_cpu_gprs_r9;
}


void _impl__casm__push_r10() {
	hwm_cpu_gprs_r10 -= sizeof(uint32_t);
	*((uint32_t *)hwm_cpu_gprs_r13) = hwm_cpu_gprs_r10;
}


void _impl__casm__push_r11() {
	hwm_cpu_gprs_r11 -= sizeof(uint32_t);
	*((uint32_t *)hwm_cpu_gprs_r13) = hwm_cpu_gprs_r11;
}


void _impl__casm__push_r12() {
	hwm_cpu_gprs_r12 -= sizeof(uint32_t);
	*((uint32_t *)hwm_cpu_gprs_r13) = hwm_cpu_gprs_r12;
}

// str
void _impl__casm__str_r1_r0(uint32_t offset) {
	*((uint32_t *)(hwm_cpu_gprs_r0 + offset)) = hwm_cpu_gprs_r1;
}

void _impl__casm__strex_eq_r3_r1_r0(uint32_t offset) {
	if (hwm_cpu_gprs_CPSR & CPSR_FLAGS_N) {
		hwm_cpu_gprs_r3 = 0U; // based off shared tlb, just setting to 0 for now
		*((uint32_t *)(hwm_cpu_gprs_r0 + offset)) = hwm_cpu_gprs_r1;
	}
}

// teq
void _impl__casm__teq_imm_r2(uint32_t value) {
	// also can modify z c flags, do we need checks for that?
	// logic might be wrong lol
	if (hwm_cpu_gprs_r2 == value) {
		hwm_cpu_gprs_CPSR |= CPSR_FLAGS_N;
	} else {
		hwm_cpu_gprs_CPSR &= ~CPSR_FLAGS_N;
	}
}

void _impl__casm__teq_eq_imm_r3(uint32_t value) {
	if (hwm_cpu_gprs_CPSR & CPSR_FLAGS_N) {
		if (hwm_cpu_gprs_r3 == value) {
			hwm_cpu_gprs_CPSR |= CPSR_FLAGS_N;
		} else {
			hwm_cpu_gprs_CPSR &= ~CPSR_FLAGS_N;
		}
	}
}

// tst

void _impl__casm__tst_imm_r9(uint32_t value) {
	// also can modify z c flags, do we need checks for that?
	// logic might be wrong lol
	if (hwm_cpu_gprs_r9 & value) {
		hwm_cpu_gprs_CPSR |= CPSR_FLAGS_N;
	} else {
		hwm_cpu_gprs_CPSR &= ~CPSR_FLAGS_N;
	}
}

//wfe ne