/*
 * @UBERSPARK_LICENSE_HEADER_START@
 *
 * überSpark
 * Copyright (c) 2013-2016 Carnegie Mellon University / CyLab
 * Copyright (c) 2013-2016 Amit Vasudevan (amitvasudevan@acm.org)
 * All Rights Reserved.
 * 
 * Developed by: überSpark Team
 *               https://uberspark.org
 *	 			 https://forums.uberspark.org 				
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
 * Neither the names of Carnegie Mellon or CyLab, nor the names of 
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
 * @UBERSPARK_LICENSE_HEADER_END@
 */

/*
	author: amit vasudevan (amitvasudevan@acm.org)
*/

#ifndef __UBERSPARK_H__
#define __UBERSPARK_H__


#include <uberspark/uobjrtl/crt/include/stdint.h>
#include <uberspark/uobjrtl/crt/include/stdbool.h>
#include <uberspark/uobjrtl/crt/include/stddef.h>
#include <uberspark/uobjrtl/crt/include/stdarg.h>
#include <uberspark/uobjrtl/crt/include/string.h>


#include <uberspark/include/basedefs.h>

#ifdef __ASSEMBLY__


#else // not __ASSEMBLY__

#define UBERSPARK_UOBJ_PUBLICMETHOD(x) __attribute__ ((section (".uobj_pm_"#x))) x

#endif //__ASSEMBLY__


#endif //__UBERSPARK_H__
