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
    //hugepagesize = gethugepagesize();


    //in case of error print out a warning and return false
    //if(hugepagesize == -1){
    if(gethugepagesizes(&hugepagesize, 1) == -1){
    	printf("\n%s: gethugepagesize error: %s\n", __FUNCTION__, strerror(errno));
        return false;
    }

    //store huge page size in the provided output parameter
    *phugepagesize = hugepagesize;

    return true;
}


//usloader_linux_um_loaduobjcoll
bool usloader_linux_um_loaduobjcoll(uint8_t *i_uobjcoll_filename,
		uint32_t *o_uobjcoll_load_addr,
		uint32_t *o_uobjcoll_load_size){
	FILE *fp;
	uint32_t uobjcoll_filename_size;
	void *uobjcoll_vaddr;
	uint32_t pagesize;
	uint32_t num_pages;
	uobjcoll_hdr_t uobjcoll_hdr;
	uint32_t uobjcoll_load_addr;
	uint32_t bytesread;


	//sanity check params
	if(i_uobjcoll_filename == NULL ||
		o_uobjcoll_load_addr == NULL ||
		o_uobjcoll_load_size == NULL)
		return false;

    //get memory backing page size
	if(!usloader_linux_um_getpagesize(&pagesize)){
        printf("\n%s: error in obtaining pagesize\n", __FUNCTION__);
        return false;
	}

	//open the uobjcoll image file
	fp=fopen(i_uobjcoll_filename, "rb");
	if(fp == NULL){
		return false;
	}

	//compute file size in bytes
	fseek(fp, 0, SEEK_END);
	uobjcoll_filename_size = ftell(fp);
    printf("\n%s: file size=%u (%08x)\n", __FUNCTION__,
    		uobjcoll_filename_size, uobjcoll_filename_size);

	//rewind fp to beginning of file
	fseek(fp, 0, SEEK_SET);

	//read header
	fread(&uobjcoll_hdr, sizeof(uobjcoll_hdr_t), 1, fp);

    printf("\n%s: magic=0x%08x, load_addr=0x%08x\n", __FUNCTION__,
    		uobjcoll_hdr.magic, uobjcoll_hdr.load_addr);

    //compute number of pages needed to hold image
    if( (uobjcoll_filename_size / pagesize) == 0)
    	num_pages = 1;
    else{
    	if (uobjcoll_filename_size % pagesize)
    		num_pages = (uobjcoll_filename_size / pagesize) + 1;
    	else
    		num_pages = (uobjcoll_filename_size / pagesize);
    }

    printf("\n%s: num_pages=%u\n", __FUNCTION__,
    		num_pages);


    //mmap a huge page
    uobjcoll_load_addr = mmap(uobjcoll_hdr.load_addr,
    		(num_pages * pagesize), (PROT_READ | PROT_WRITE | PROT_EXEC),
    		MAP_PRIVATE | (MAP_FIXED | MAP_ANONYMOUS | MAP_HUGETLB), -1 , 0);

    //bail out if we could not mmap
    if(uobjcoll_load_addr == MAP_FAILED){
        printf("\n%s: mmap error: %s\n", __FUNCTION__, strerror(errno));
        return false;
    }

    //sanity check mmaped address with va
    if(uobjcoll_load_addr != uobjcoll_hdr.load_addr){
        printf("\n%s: inconsistent load warning!\n", __FUNCTION__);
    }

	//rewind fp to beginning of file
	fseek(fp, 0, SEEK_SET);

	//read image file into allocated uobjcoll virtual address
	bytesread = fread(uobjcoll_load_addr, uobjcoll_filename_size, 1, fp);
	if(bytesread != uobjcoll_filename_size && ferror(fp)){
        printf("\n%s: inconsistent file read warning: read %u bytes out of %u!\n",
        		__FUNCTION__, bytesread, uobjcoll_filename_size);
        perror("error follows");
	}

	//close uobjcoll image file
	fclose(fp);

    //return results
    *o_uobjcoll_load_addr = uobjcoll_load_addr;
    *o_uobjcoll_load_size = (num_pages * pagesize);

	return true;
}


bool usloader_linux_um_unloaduobjcoll(uint32_t i_uobjcoll_load_addr,
		uint32_t i_uobjcoll_load_size){

    //now unmap the uobj va space
    if(munmap(i_uobjcoll_load_addr, i_uobjcoll_load_size) == -1){
        printf("\n%s: error in munmap :%s\n", __FUNCTION__, strerror(errno));
        return false;
    }else
    	return true;

}




uint32_t sample_interface(uint32_t num){
	return num++;
}
