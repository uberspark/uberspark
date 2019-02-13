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

#include <uberspark.h>
#include "usloader-linux-um.h"

#include <stdio.h>
#include <sys/mman.h>
#include <asm/mman.h>
#include <errno.h>
#include <hugetlbfs.h>

bool usloader_linux_um_getpagesize(uint32_t *phugepagesize){
	uint32_t hugepagesize;

	//sanity check input parameter
    if(phugepagesize == NULL)
    	return false;

	//grab huge page size of system
    hugepagesize = gethugepagesize();

    //in case of error print out a warning and return false
    if(hugepagesizes == -1){
        printf("\n%s: gethugepagesizes error: %s\n", __FUNCTION__, strerror(errno));
        return false;
    }

    //store huge page size in the provided output parameter
    *phugepagesize = hugepagesize;

}


//usloader_linux_um_loaduobjcoll
bool usloader_linux_um_loaduobjcoll(uint8_t *uobjcoll_filename){
	FILE *fp;
	uint32_t uobjcoll_filename_size;
	void *uobjcoll_vaddr;
	uint32_t pagesize;

#if 0
	//open the uobjcoll image file
	fp=fopen(uobjcoll_filename, "r");
	if(fp == NULL){
		return false;
	}

	//compute file size in bytes
	fseek(fp, 0, SEEK_END);
	uobjcoll_filename_size = ftell(fp);

	//rewind fp to beginning of file
	fseek(f, 0, SEEK_SET);

	//read image file into allocated uobjcoll virtual address
	fread(uobjcoll_vaddr, uobjcoll_filename_size, 1, fp);

	//close uobjcoll image file
	fclose(fp);
#endif

	if(!usloader_linux_um_getpagesize(&pagesize)){
        printf("\n%s: error in obtaining pagesize\n", __FUNCTION__);
        return false;
	}

	return true;
}

uint32_t sample_interface(uint32_t num){
	return num++;
}
