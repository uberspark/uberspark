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
 * armv8_32 cpu hardware model implementation
 * author: ethan joseph (ethanj217@gmail.com)
*/


// #include <uberspark/include/uberspark.h>
#include <stdint.h>

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

enum CPSR_FLAGS {
	CPSR_FLAGS_M = 1 << 4,
	CPSR_FLAGS_T = 1 << 5,
	CPSR_FLAGS_F = 1 << 6,
	CPSR_FLAGS_I = 1 << 7,
	CPSR_FLAGS_A = 1 << 8,
	CPSR_FLAGS_E = 1 << 9,
	CPSR_FLAGS_IT = 1 << 15,
	CPSR_FLAGS_GE = 1 << 19,
	CPSR_FLAGS_J = 1 << 24,
	CPSR_FLAGS_IT2 = 1 << 26,
	CPSR_FLAGS_Q = 1 << 27,
	CPSR_FLAGS_V = 1 << 28,
	CPSR_FLAGS_C = 1 << 29,
	CPSR_FLAGS_Z = 1 << 30,
	CPSR_FLAGS_N = 1 << 31,
};

// add
void _impl__casm__add_imm_r1_r0(uint32_t value) {
	hwm_cpu_gprs_r1 = hwm_cpu_gprs_r0 + value;
}

void _impl__casm__add_imm_r4_r3(uint32_t value) {
	hwm_cpu_gprs_r4 = hwm_cpu_gprs_r3 + value;
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
void _impl__casm__ldr_r0_r0() {
	hwm_cpu_gprs_r0 = *((uint32_t*)hwm_cpu_gprs_r0);
}

// void _impl__casm__ldr_psuedo_sp(uint32_t addr) {
// } in cpu.h

// lsr
void _impl__casm__lsr_imm_r7(uint32_t value) {
	hwm_cpu_gprs_r7 = hwm_cpu_gprs_r7 >> value;
}

// mcr/mcrr (might need to have different versions for the different opcodes)
// void _impl__casm__mcr

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

//mrc/mrrc

// mrs/msr

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

// sev

// str
void _impl__casm__str_r1_r0(uint32_t offset) {
	*((uint32_t *)(hwm_cpu_gprs_r0 + offset)) = hwm_cpu_gprs_r1;
}

// strex eq

//svc

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
	// also can modify z c flags, do we need checks for that?
	// logic might be wrong lol
	if (hwm_cpu_gprs_r3 == value) {
		hwm_cpu_gprs_CPSR |= CPSR_FLAGS_N;
	} else {
		hwm_cpu_gprs_CPSR &= ~CPSR_FLAGS_N;
	}
}

// tst

void _impl__casm__tst_imm_r9(uint32_t value) {
	// also can modify z c flags, do we need checks for that?
	// logic might be wrong lol
	if (hwm_cpu_gprs_r3 & value) {
		hwm_cpu_gprs_CPSR |= CPSR_FLAGS_N;
	} else {
		hwm_cpu_gprs_CPSR &= ~CPSR_FLAGS_N;
	}
}

//wfe ne