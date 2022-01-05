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

#include <stdint.h>
#include <string.h>


/*void *memcpy(void * to, const void * from, uint32_t n)
{
  size_t i;
  for(i=0; i<n; i++) {
    ((uint8_t*)to)[i] = ((const uint8_t*)from)[i];
  }
  return to;
}*/


/*@
    requires \separated(((unsigned char*)src)+(0..n-1), ((unsigned char*)dst)+(0..n-1));
    requires n >= 0;
    requires \valid(((unsigned char*)dst)+(0..n-1));
    requires \valid(((unsigned char*)src)+(0..n-1));
    assigns ((unsigned char*)dst)[0..n-1];
    ensures \forall integer i; 0 <= i < n ==> ((unsigned char*)dst)[i] == ((unsigned char*)src)[i];
    ensures \result == dst;
 */
unsigned char *memcpy(unsigned char *dst, const unsigned char *src, size_t n)
{
	const unsigned char *p = src;
	unsigned char *q = dst;

	/*@
		loop invariant 0 <= n <= \at(n,Pre);
		loop invariant p == ((unsigned char*)src)+(\at(n, Pre) - n);
		loop invariant q == ((unsigned char*)dst)+(\at(n, Pre) - n);
		loop invariant (unsigned char*)dst <= q <= (unsigned char*)dst+\at(n,Pre);
		loop invariant (unsigned char*)src <= p <= (unsigned char*)src+\at(n,Pre);
		loop invariant \forall integer i; 0 <= i < (\at(n, Pre) - n) ==> ((unsigned char*)dst)[i] == ((unsigned char*)src)[i];
		loop assigns n, q, p, ((unsigned char*)dst)[0..(\at(n,Pre)- n - 1)];
		loop variant n;
	*/
	while (n) {
		*q++ = *p++;
		n--;
	}

	return dst;
}

