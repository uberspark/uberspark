/*
 * @UBERSPARK_LICENSE_HEADER_START@
 *
 * uberSpark
 * Copyright (c) 2016-2019 Carnegie Mellon University
 * Copyright (c) 2017-2019 Carnegie Mellon University / SEI
 * Copyright (c) 2016-2019 Amit Vasudevan
 * All Rights Reserved.
 *
 * Developed by: uberSpark Team
 *               Carnegie Mellon University / SEI
 *               http://uberspark.org
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
 * Neither the names of Carnegie Mellon or SEI, nor the names of
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

#ifndef __USLOADER_LINUX_UM_H__
#define __USLOADER_LINUX_UM_H__


#ifndef __ASSEMBLY__
extern uint32_t sample_interface(uint32_t num);

extern bool usloader_linux_um_getpagesize(uint32_t *phugepagesize);

extern bool usloader_linux_um_loaduobjcoll(uint8_t *uobjcoll_filename,
		uint32_t *uobjcoll_load_addr,
		uint32_t *uobjcoll_load_size);

extern bool usloader_linux_um_unloaduobjcoll(uint32_t i_uobjcoll_load_addr,
		uint32_t i_uobjcoll_load_size);

#endif /* __ASSEMBLY__ */

#endif /*__USLOADER_LINUX_UM_H__ */
