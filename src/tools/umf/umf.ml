(*
	uberspark tool for manifest parsing
	author: amit vasudevan (amitvasudevan@acm.org)
*)

open Uslog
open Libusmf
open Sys
open Str
open Unix

(*
module Self = Plugin.Register
	(struct
		let name = "US manifest parser"
		let shortname = "umf"
		let help = "UberSpark manifest parsing plugin"
	end)


module Cmdopt_slabsfile = Self.String
	(struct
		let option_name = "-umf-uobjlist"
		let default = ""
		let arg_name = "uobjlist-file"
		let help = "uobj list file"
	end)

module Cmdopt_uobjconfigurescript = Self.String
	(struct
		let option_name = "-umf-uobjconfigurescript"
		let default = ""
		let arg_name = "uobjconfigurescript"
		let help = "uobj configuration script"
	end)



module Cmdopt_outputfile_slabinfotable = Self.String
	(struct
		let option_name = "-umf-outuobjinfotable"
		let default = ""
		let arg_name = "outuobjinfotable-file"
		let help = "output uobj info table filename"
	end)

module Cmdopt_outputfile_linkerscript = Self.String
	(struct
		let option_name = "-umf-outlinkerscript"
		let default = ""
		let arg_name = "outlinkerscript-file"
		let help = "output linker script filename"
	end)

module Cmdopt_loadaddr = Self.String
	(struct
		let option_name = "-umf-loadaddr"
		let default = ""
		let arg_name = "load-address"
		let help = "load memory address of binary"
	end)

module Cmdopt_loadmaxsize = Self.String
	(struct
		let option_name = "-umf-loadmaxsize"
		let default = ""
		let arg_name = "loadmax-size"
		let help = "max load memory address of binary"
	end)

module Cmdopt_totaluhslabs = Self.String
	(struct
		let option_name = "-umf-totaluhuobjs"
		let default = ""
		let arg_name = "total-uhuobjs"
		let help = "total number of unverified uobjs"
	end)

module Cmdopt_maxincldevlistentries = Self.String
	(struct
		let option_name = "-umf-maxincldevlistentries"
		let default = ""
		let arg_name = "max-incldevlistentries"
		let help = "total number of INCL device list entries"
	end)

module Cmdopt_maxexcldevlistentries = Self.String
	(struct
		let option_name = "-umf-maxexcldevlistentries"
		let default = ""
		let arg_name = "max-excldevlistentries"
		let help = "total number of EXCL device list entries"
	end)

module Cmdopt_maxmemoffsetentries = Self.String
	(struct
		let option_name = "-umf-maxmemoffsetentries"
		let default = ""
		let arg_name = "max-memoffsetentries"
		let help = "total number of MEMOFFSET entries"
	end)

module Cmdopt_memoffsets = Self.False
	(struct
		let option_name = "-umf-memoffsets"
		(* let default = false *)
		let help = "when on (off by default), include absolute memory offsets in MEMOFFSETS list"
	end)

*)

(*
	**************************************************************************
	global variables
	**************************************************************************
*)

(*	command line inputs *)
let g_slabsfile = ref "";;	(* argv 0 *)
let g_uobjconfigurescript = ref "";; (* argv 1 *)
let g_outputfile_slabinfotable = ref "";; (* argv 2 *)
let g_outputfile_linkerscript = ref "";; (* argv 3 *)
let g_loadaddr = ref 0x0;; (* argv 4 *)
let g_loadmaxsize = ref 0x0;; (* argv 5 *)
let g_totaluhslabs = ref 0;; (* argv 6 *)
let g_maxincldevlistentries = ref 0;;  (* argv 7 *)
let g_maxexcldevlistentries = ref 0;;  (* argv 8 *)
let g_maxmemoffsetentries = ref 0;;  (* argv 9 *)
let g_memoffsets = ref false;; (*argv 10 *)
let g_ppflags = ref "";; (*argv 11 *)



(* other global variables *)
let g_totalslabmempgtblsets = ref 0;;
let g_totalslabiotblsets = ref 0;;
let g_uhslabcounter = ref 0;;
let g_ugslabcounter = ref 0;;
let g_rootdir = ref "";;
let i = ref 0;;
let g_memmapaddr = ref 0x0;;
(* let fh : in_channel;; *)
let g_totaluhslabmempgtblsets = ref 0;;
let g_totaluvslabiotblsets = ref 0;;


(* global hash table variables *)
let slab_idtodata_addrstart = ((Hashtbl.create 32) : ((int,string)  Hashtbl.t));;
let slab_idtodata_addrend = ((Hashtbl.create 32) : ((int,string)  Hashtbl.t));;
let slab_idtocode_addrstart = ((Hashtbl.create 32) : ((int,string)  Hashtbl.t));;
let slab_idtocode_addrend = ((Hashtbl.create 32) : ((int,string)  Hashtbl.t));;
let slab_idtostack_addrstart = ((Hashtbl.create 32) : ((int,string)  Hashtbl.t));;
let slab_idtostack_addrend = ((Hashtbl.create 32) : ((int,string)  Hashtbl.t));;
let slab_idtodmadata_addrstart = ((Hashtbl.create 32) : ((int,string)  Hashtbl.t));;
let slab_idtodmadata_addrend = ((Hashtbl.create 32) : ((int,string)  Hashtbl.t));;


(*
let umf_process_cmdline () =
	g_slabsfile := Cmdopt_slabsfile.get();
	g_uobjconfigurescript := Cmdopt_uobjconfigurescript.get();
	g_outputfile_slabinfotable := Cmdopt_outputfile_slabinfotable.get();
	g_outputfile_linkerscript := Cmdopt_outputfile_linkerscript.get();
	g_loadaddr := int_of_string (Cmdopt_loadaddr.get());
	g_loadmaxsize := int_of_string (Cmdopt_loadmaxsize.get());
	g_totaluhslabs := int_of_string (Cmdopt_totaluhslabs.get());
	g_maxincldevlistentries := int_of_string (Cmdopt_maxincldevlistentries.get());
	g_maxexcldevlistentries := int_of_string (Cmdopt_maxexcldevlistentries.get());
	g_maxmemoffsetentries := int_of_string (Cmdopt_maxmemoffsetentries.get());
	if Cmdopt_memoffsets.get() then g_memoffsets := true else g_memoffsets := false;

	
	Uslog.logf "umfparse" Uslog.Info "g_slabsfile=%s\n" !g_slabsfile;
	Uslog.logf "umfparse" Uslog.Info "g_uobjconfigscript=%s\n" !g_uobjconfigurescript;
	Uslog.logf "umfparse" Uslog.Info "g_outputfile_slabinfotable=%s\n" !g_outputfile_slabinfotable;
	Uslog.logf "umfparse" Uslog.Info "g_outputfile_linkerscript=%s\n" !g_outputfile_linkerscript;
	Uslog.logf "umfparse" Uslog.Info "g_loadaddr=0x%x\n" !g_loadaddr;
	Uslog.logf "umfparse" Uslog.Info "g_loadmaxsize=0x%x\n" !g_loadmaxsize;
	Uslog.logf "umfparse" Uslog.Info "g_totaluhslabs=%d\n" !g_totaluhslabs;
	Uslog.logf "umfparse" Uslog.Info "g_maxincldevlistentries=%d\n" !g_maxincldevlistentries;
	Uslog.logf "umfparse" Uslog.Info "g_maxexcldevlistentries=%d\n" !g_maxexcldevlistentries;
	Uslog.logf "umfparse" Uslog.Info "g_maxmemoffsetentries=%d\n" !g_maxmemoffsetentries;
	Uslog.logf "umfparse" Uslog.Info "g_memoffsets=%b\n" !g_memoffsets;
	()
*)



let umf_process_cmdline () =
	let len = Array.length Sys.argv in
		Uslog.logf "umfparse" Uslog.Info "cmdline len=%u" len;

		if len = 13 then
	    	begin
					g_slabsfile := Sys.argv.(1);
					g_uobjconfigurescript := Sys.argv.(2);
					g_outputfile_slabinfotable := Sys.argv.(3);
					g_outputfile_linkerscript := Sys.argv.(4);
					g_loadaddr := int_of_string (Sys.argv.(5));
					g_loadmaxsize := int_of_string (Sys.argv.(6));
					g_totaluhslabs := int_of_string (Sys.argv.(7));
					g_maxincldevlistentries := int_of_string (Sys.argv.(8));
					g_maxexcldevlistentries := int_of_string (Sys.argv.(9));
					g_maxmemoffsetentries := int_of_string (Sys.argv.(10));
					if int_of_string (Sys.argv.(11)) = 1 then g_memoffsets := true else g_memoffsets := false;
					g_ppflags := Sys.argv.(12) ^ " -D__ASSEMBLY__";

					Uslog.logf "umfparse" Uslog.Info "g_slabsfile=%s" !g_slabsfile;
					Uslog.logf "umfparse" Uslog.Info "g_uobjconfigscript=%s" !g_uobjconfigurescript;
					Uslog.logf "umfparse" Uslog.Info "g_outputfile_slabinfotable=%s" !g_outputfile_slabinfotable;
					Uslog.logf "umfparse" Uslog.Info "g_outputfile_linkerscript=%s" !g_outputfile_linkerscript;
					Uslog.logf "umfparse" Uslog.Info "g_loadaddr=0x%x" !g_loadaddr;
					Uslog.logf "umfparse" Uslog.Info "g_loadmaxsize=0x%x" !g_loadmaxsize;
					Uslog.logf "umfparse" Uslog.Info "g_totaluhslabs=%d" !g_totaluhslabs;
					Uslog.logf "umfparse" Uslog.Info "g_maxincldevlistentries=%d" !g_maxincldevlistentries;
					Uslog.logf "umfparse" Uslog.Info "g_maxexcldevlistentries=%d" !g_maxexcldevlistentries;
					Uslog.logf "umfparse" Uslog.Info "g_maxmemoffsetentries=%d" !g_maxmemoffsetentries;
					Uslog.logf "umfparse" Uslog.Info "g_memoffsets=%b" !g_memoffsets;
					Uslog.logf "umfparse" Uslog.Info "g_ppflags=%s" !g_ppflags;
					
				end
		else
				begin
					Uslog.logf "umfparse" Uslog.Info "umf_process_cmdline: Insufficient Parameters!";
					ignore(exit 1);
				end
		;

()



let umf_compute_memory_map () =
	i := 0;
	g_memmapaddr := !g_loadaddr;

	Uslog.logf "umfparse" Uslog.Info "Proceeding to compute memory map...\n";
	
	while (!i < !Libusmf.g_totalslabs) do
	    if ((compare (Hashtbl.find Libusmf.slab_idtosubtype !i) "XRICHGUEST") <> 0) then
	    	begin
			    Hashtbl.add slab_idtocode_addrstart !i  (Printf.sprintf "0x%08x" !g_memmapaddr);
		    	g_memmapaddr := !g_memmapaddr + (Hashtbl.find Libusmf.slab_idtocodesize !i);
		    	Hashtbl.add slab_idtocode_addrend !i (Printf.sprintf "0x%08x" !g_memmapaddr);
		
			    Hashtbl.add slab_idtodata_addrstart !i (Printf.sprintf "0x%08x" !g_memmapaddr);
		    	g_memmapaddr := !g_memmapaddr + (Hashtbl.find Libusmf.slab_idtodatasize !i);
		    	Hashtbl.add slab_idtodata_addrend !i (Printf.sprintf "0x%08x" !g_memmapaddr);
		
			    Hashtbl.add slab_idtostack_addrstart !i (Printf.sprintf "0x%08x" !g_memmapaddr);
		    	g_memmapaddr := !g_memmapaddr + (Hashtbl.find Libusmf.slab_idtostacksize !i);
		    	Hashtbl.add slab_idtostack_addrend !i (Printf.sprintf "0x%08x" !g_memmapaddr);
		
		    	Hashtbl.add slab_idtodmadata_addrstart !i (Printf.sprintf "0x%08x" !g_memmapaddr);
		    	g_memmapaddr := !g_memmapaddr + (Hashtbl.find Libusmf.slab_idtodmadatasize !i);
		    	Hashtbl.add slab_idtodmadata_addrend !i (Printf.sprintf "0x%08x" !g_memmapaddr);	
			end	
	    else
	    	begin
			    Hashtbl.add slab_idtocode_addrstart !i (Printf.sprintf "0x%08x" (Hashtbl.find Libusmf.slab_idtocodesize !i));
			    Hashtbl.add slab_idtocode_addrend !i (Printf.sprintf "0x%08x" (Hashtbl.find Libusmf.slab_idtodatasize !i));
			
			    Hashtbl.add slab_idtodata_addrstart !i (Printf.sprintf "0x%08x" (Hashtbl.find Libusmf.slab_idtostacksize !i));
			    Hashtbl.add slab_idtodata_addrend !i (Printf.sprintf "0x%08x" (Hashtbl.find Libusmf.slab_idtodmadatasize !i));
			
			    Hashtbl.add slab_idtostack_addrstart !i (Printf.sprintf "0x%08x" 0);
			    Hashtbl.add slab_idtostack_addrend !i (Printf.sprintf "0x%08x" 0);
			
			    Hashtbl.add slab_idtodmadata_addrstart !i (Printf.sprintf "0x%08x" 0);
			    Hashtbl.add slab_idtodmadata_addrend !i (Printf.sprintf "0x%08x" 0);
			end	    	
	    ;
		

    	i := !i + 1;
	done;

	Uslog.logf "umfparse" Uslog.Info "Computed memory map\n";

	i := 0;
	while (!i < !Libusmf.g_totalslabs) do
	    Uslog.logf "umfparse" Uslog.Info "slabname: %s \n" (Hashtbl.find Libusmf.slab_idtoname !i);
	    Uslog.logf "umfparse" Uslog.Info "code    - addrstart= %s, addrend=%s \n" (Hashtbl.find slab_idtocode_addrstart !i) (Hashtbl.find slab_idtocode_addrend !i);
	    Uslog.logf "umfparse" Uslog.Info "data    - addrstart= %s, addrend=%s \n" (Hashtbl.find slab_idtodata_addrstart !i) (Hashtbl.find slab_idtodata_addrend !i);
	    Uslog.logf "umfparse" Uslog.Info "stack   - addrstart= %s, addrend=%s \n" (Hashtbl.find slab_idtostack_addrstart !i) (Hashtbl.find slab_idtostack_addrend !i);
	    Uslog.logf "umfparse" Uslog.Info "dmadata - addrstart= %s, addrend=%s \n" (Hashtbl.find slab_idtodmadata_addrstart !i) (Hashtbl.find slab_idtodmadata_addrend !i);
		i := !i + 1;
	done;


	()



let umf_configure_slabs () =
	let l_cmdline = ref "" in
	
	Uslog.logf "umfparse" Uslog.Info "Proceeding to configure slabs...\n";
	Uslog.logf "umfparse" Uslog.Info "g_memoffsets=%b" !g_memoffsets;

	if (!g_memoffsets) then
		begin
			(* no configuration needed when doing real build *)
		end
	else
		begin
		    i := 0;
		    while (!i < !Libusmf.g_totalslabs) do
		        Uslog.logf "umfparse" Uslog.Info "Configuring slab: %s with type: %s:%s ...\n" (Hashtbl.find Libusmf.slab_idtodir !i) (Hashtbl.find Libusmf.slab_idtotype !i) (Hashtbl.find Libusmf.slab_idtosubtype !i);
		        l_cmdline := 	(Printf.sprintf "cd %s && %s " (Hashtbl.find Libusmf.slab_idtodir !i) !g_uobjconfigurescript) ^
		                	 	(Printf.sprintf " --with-slabtype=%s" (Hashtbl.find Libusmf.slab_idtotype !i)) ^
		                		(Printf.sprintf " --with-slabsubtype=%s" (Hashtbl.find Libusmf.slab_idtosubtype !i)) ^
		                		(Printf.sprintf " --with-slabcodestart=%s" (Hashtbl.find slab_idtocode_addrstart !i)) ^
		                		(Printf.sprintf " --with-slabcodeend=%s" (Hashtbl.find slab_idtocode_addrend !i)) ^
		                		(Printf.sprintf " --with-slabdatastart=%s" (Hashtbl.find slab_idtodata_addrstart !i)) ^
		                		(Printf.sprintf " --with-slabdataend=%s" (Hashtbl.find slab_idtodata_addrend !i)) ^
		                		(Printf.sprintf " --with-slabstackstart=%s" (Hashtbl.find slab_idtostack_addrstart !i)) ^
		                		(Printf.sprintf " --with-slabstackend=%s" (Hashtbl.find slab_idtostack_addrend !i)) ^
		                		(Printf.sprintf " --with-slabdmadatastart=%s" (Hashtbl.find slab_idtodmadata_addrstart !i)) ^
		                		(Printf.sprintf " --with-slabdmadataend=%s" (Hashtbl.find slab_idtodmadata_addrend !i)) ^
		                		(Printf.sprintf " >/dev/null 2>&1");
		        ignore(Sys.command !l_cmdline);
		        i := !i + 1;
		    done;

		end
	;

	Uslog.logf "umfparse" Uslog.Info "Slabs configured.\n";
	()
	


let umf_output_infotable () =
    let oc = open_out !g_outputfile_slabinfotable in

	Printf.fprintf oc "\n/* autogenerated uobj info table */";
	Printf.fprintf oc "\n/* author: amit vasudevan (amitvasudevan@acm.org) */";
	Printf.fprintf oc "\n";
	Printf.fprintf oc "\n";
	Printf.fprintf oc "\n#include <xmhf.h>";
	Printf.fprintf oc "\n#include <xmhfgeec.h>";
	Printf.fprintf oc "\n#include <xmhf-debug.h>";
	Printf.fprintf oc "\n";
	Printf.fprintf oc "\n";
	Printf.fprintf oc "\n__attribute__(( section(\".data\") )) __attribute__((aligned(4096))) xmhfgeec_slab_info_t xmhfgeec_slab_info_table[] = {";

	i := 0;
	while (!i < !Libusmf.g_totalslabs ) do
		(* slab name *)

		(* Uslog.logf "umfparse" Uslog.Info "Looping for slab %d..." !i; *)
		Printf.fprintf oc "\n";
	    Printf.fprintf oc "\n	//%s" (Hashtbl.find Libusmf.slab_idtoname !i);
	    Printf.fprintf oc "\n	{";
	
	    (* slab_inuse *)
	    Printf.fprintf oc "\n	    true,";

		(* slab type *)
	    if ( (compare (Hashtbl.find Libusmf.slab_idtotype !i) "VfT_SLAB") = 0 && 
	    	 (compare (Hashtbl.find Libusmf.slab_idtosubtype !i) "PRIME") = 0 ) then 
        	Printf.fprintf oc "\n	        XMHFGEEC_SLABTYPE_VfT_PROG,"
	    else if( (compare (Hashtbl.find Libusmf.slab_idtotype !i) "VfT_SLAB") = 0 && 
	    	     (compare (Hashtbl.find Libusmf.slab_idtosubtype !i) "SENTINEL") = 0) then
	        Printf.fprintf oc "\n	        XMHFGEEC_SLABTYPE_VfT_SENTINEL,"
	    else if( (compare (Hashtbl.find Libusmf.slab_idtotype !i) "VfT_SLAB") = 0 && 
	    	     (compare (Hashtbl.find Libusmf.slab_idtosubtype !i) "INIT") = 0) then
	        Printf.fprintf oc "\n	        XMHFGEEC_SLABTYPE_VfT_PROG,"
	    else if( (compare (Hashtbl.find Libusmf.slab_idtotype !i) "VfT_SLAB") = 0 && 
	    	     (compare (Hashtbl.find Libusmf.slab_idtosubtype !i) "XCORE") = 0 ) then
	        Printf.fprintf oc "\n	        XMHFGEEC_SLABTYPE_VfT_PROG,"
	    else if( (compare (Hashtbl.find Libusmf.slab_idtotype !i) "VfT_SLAB") = 0 && 
	    	     (compare (Hashtbl.find Libusmf.slab_idtosubtype !i) "XHYPAPP") = 0) then
	        Printf.fprintf oc "\n	        XMHFGEEC_SLABTYPE_VfT_PROG,"
	    else if( (compare (Hashtbl.find Libusmf.slab_idtotype !i) "VfT_SLAB") = 0 && 
	    		 (compare (Hashtbl.find Libusmf.slab_idtosubtype !i) "UAPI") = 0) then
	        Printf.fprintf oc "\n	        XMHFGEEC_SLABTYPE_VfT_PROG,"
	    else if( (compare (Hashtbl.find Libusmf.slab_idtotype !i) "VfT_SLAB") = 0  && 
	    	     (compare (Hashtbl.find Libusmf.slab_idtosubtype !i) "EXCEPTION") = 0) then
	        Printf.fprintf oc "\n	        XMHFGEEC_SLABTYPE_VfT_PROG,"
	    else if( (compare (Hashtbl.find Libusmf.slab_idtotype !i) "VfT_SLAB") = 0 && 
	    		 (compare (Hashtbl.find Libusmf.slab_idtosubtype !i) "INTERCEPT") = 0) then
	        Printf.fprintf oc "\n	        XMHFGEEC_SLABTYPE_VfT_PROG,"
	    else if( (compare (Hashtbl.find Libusmf.slab_idtotype !i) "uVT_SLAB") = 0 && 
	    	     (compare (Hashtbl.find Libusmf.slab_idtosubtype !i) "INIT") = 0) then
	        Printf.fprintf oc "\n	        XMHFGEEC_SLABTYPE_uVT_PROG,"
	    else if( (compare (Hashtbl.find Libusmf.slab_idtotype !i) "uVT_SLAB") = 0 && 
	    	     (compare (Hashtbl.find Libusmf.slab_idtosubtype !i) "XCORE") = 0 ) then
	        Printf.fprintf oc "\n	        XMHFGEEC_SLABTYPE_uVT_PROG,"
	    else if( (compare (Hashtbl.find Libusmf.slab_idtotype !i) "uVT_SLAB") = 0 && 
	             (compare (Hashtbl.find Libusmf.slab_idtosubtype !i) "XHYPAPP") = 0) then
	        Printf.fprintf oc "\n	        XMHFGEEC_SLABTYPE_uVT_PROG,"
	    else if( (compare (Hashtbl.find Libusmf.slab_idtotype !i) "uVU_SLAB") = 0 && 
	    		 (compare (Hashtbl.find Libusmf.slab_idtosubtype !i) "XCORE") = 0 ) then
	        Printf.fprintf oc "\n	        XMHFGEEC_SLABTYPE_uVU_PROG,"
	    else if( (compare (Hashtbl.find Libusmf.slab_idtotype !i) "uVU_SLAB") = 0 && 
	    	     (compare (Hashtbl.find Libusmf.slab_idtosubtype !i) "XHYPAPP") = 0) then
	        Printf.fprintf oc "\n	        XMHFGEEC_SLABTYPE_uVU_PROG,"
	    else if( (compare (Hashtbl.find Libusmf.slab_idtotype !i) "uVU_SLAB") = 0 && 
	    	     (compare (Hashtbl.find Libusmf.slab_idtosubtype !i) "XGUEST") = 0) then
	        Printf.fprintf oc "\n	        XMHFGEEC_SLABTYPE_uVU_PROG_GUEST,"
	    else if( (compare (Hashtbl.find Libusmf.slab_idtotype !i) "uVT_SLAB") = 0 && 
	    	     (compare (Hashtbl.find Libusmf.slab_idtosubtype !i) "XGUEST") = 0) then
	        Printf.fprintf oc "\n	        XMHFGEEC_SLABTYPE_uVT_PROG_GUEST,"
	    else if( (compare (Hashtbl.find Libusmf.slab_idtotype !i) "uVU_SLAB") = 0 && 
	    	     (compare (Hashtbl.find Libusmf.slab_idtosubtype !i) "XRICHGUEST") = 0 ) then
	        Printf.fprintf oc "\n	        XMHFGEEC_SLABTYPE_uVU_PROG_RICHGUEST,"
	    else
	    	begin
	        	Uslog.logf "umfparse" Uslog.Info "Error: Unknown slab type!\n";
	        	ignore(exit 1);
	    	end
	    ;


(*
	    (* mempgtbl_cr3 and iotbl_base *)
    	if ( (compare (Hashtbl.find Libusmf.slab_idtotype !i) "VfT_SLAB") = 0) then
    		begin
				(* mempgtbl_cr3 for VfT_SLAB points to verified hypervisor slab page table base *)
				(* iotbl_base for VfT_SLAB is not-used *)
		        Printf.fprintf oc "\n        %s  + (2 * 4096)," (Hashtbl.find slab_idtodata_addrstart (Hashtbl.find Libusmf.slab_nametoid "geec_prime") );
	    	    Printf.fprintf oc "\n        0x00000000UL,";
			end
		
	    else if ( ((compare (Hashtbl.find Libusmf.slab_idtotype !i) "uVU_SLAB") = 0 && (compare (Hashtbl.find Libusmf.slab_idtosubtype !i) "XGUEST") = 0) ||
				  ((compare (Hashtbl.find Libusmf.slab_idtotype !i) "uVT_SLAB") = 0 && (compare (Hashtbl.find Libusmf.slab_idtosubtype !i) "XGUEST") = 0) ||
				  ((compare (Hashtbl.find Libusmf.slab_idtotype !i) "uVU_SLAB") = 0 && (compare (Hashtbl.find Libusmf.slab_idtosubtype !i) "XRICHGUEST") = 0) ) then
			begin
				(* mempgtbl_cr3 for unverified guest slabs point to their corresponding page table base within uapi_slabmempgtbl *)
				(* iotbl_base for unverified guest slabs point to their corresponding io table base within uapi_slabiotbl *)
		        if (!g_ugslabcounter > 1) then
		        	begin 
		        		(* TODO: need to bring this in via a conf. variable when we support multiple guest slabs *)
						Uslog.logf "umfparse" Uslog.Info "Error: Too many unverified guest slabs (max=1)!\n";
						ignore(exit 1);
					end
				else
					begin
						Printf.fprintf oc "\n        %s  + (%d * 4096)," (Hashtbl.find slab_idtodata_addrstart (Hashtbl.find Libusmf.slab_nametoid "uapi_slabmempgtbl"))  !g_ugslabcounter;
						Printf.fprintf oc "\n        %s  + (3*4096) + (%d * 4096) + (%d *(3*4096)) + (%d * (3*4096))," (Hashtbl.find slab_idtodata_addrstart (Hashtbl.find Libusmf.slab_nametoid "geec_prime")) !g_totaluhslabs !g_totaluhslabs !g_ugslabcounter;
						g_ugslabcounter := !g_ugslabcounter + 1;
					end
				;
			end
			
	    else
			begin
				(* mempgtbl_cr3 for unverified hypervisor slabs point to their corresponding page table base within prime *)
				(* iotbl_base *)
		        if(!g_uhslabcounter >=  !g_totaluhslabmempgtblsets) then
		        	begin
						Uslog.logf "umfparse" Uslog.Info "Error: Too many unverified hypervisor slabs (max=%d)!\n" !g_totaluhslabmempgtblsets;
						ignore(exit 1);
					end
		        else
		        	begin
						Printf.fprintf oc "\n        %s + (3*4096) + (%d * 4096)," (Hashtbl.find slab_idtodata_addrstart (Hashtbl.find Libusmf.slab_nametoid "geec_prime")) !g_uhslabcounter;
						Printf.fprintf oc "\n        %s + (3*4096) + (%d *4096) + (%d * (3*4096)), " (Hashtbl.find slab_idtodata_addrstart (Hashtbl.find Libusmf.slab_nametoid "geec_prime")) !g_totaluhslabs !g_uhslabcounter;
						g_uhslabcounter := !g_uhslabcounter + 1;
		        	end
		        ;
			end
	    ;
*)


	    (* slab_tos *)
	    Printf.fprintf oc "\n	        {";
	    Printf.fprintf oc "\n	            %s + (1*XMHF_SLAB_STACKSIZE)," (Hashtbl.find slab_idtostack_addrstart !i);
	    Printf.fprintf oc "\n	            %s + (2*XMHF_SLAB_STACKSIZE)," (Hashtbl.find slab_idtostack_addrstart !i);
	    Printf.fprintf oc "\n	            %s + (3*XMHF_SLAB_STACKSIZE)," (Hashtbl.find slab_idtostack_addrstart !i);
	    Printf.fprintf oc "\n	            %s + (4*XMHF_SLAB_STACKSIZE)," (Hashtbl.find slab_idtostack_addrstart !i);
	    Printf.fprintf oc "\n	            %s + (5*XMHF_SLAB_STACKSIZE)," (Hashtbl.find slab_idtostack_addrstart !i);
	    Printf.fprintf oc "\n	            %s + (6*XMHF_SLAB_STACKSIZE)," (Hashtbl.find slab_idtostack_addrstart !i);
	    Printf.fprintf oc "\n	            %s + (7*XMHF_SLAB_STACKSIZE)," (Hashtbl.find slab_idtostack_addrstart !i);
	    Printf.fprintf oc "\n	            %s + (8*XMHF_SLAB_STACKSIZE)," (Hashtbl.find slab_idtostack_addrstart !i);
	    Printf.fprintf oc "\n	        },";


	    (* slab_callcaps *)
	    if (Hashtbl.mem Libusmf.slab_idtocallmask !i) then
	    	begin
	    	    Printf.fprintf oc "\n\t0x%08xUL, " (Hashtbl.find Libusmf.slab_idtocallmask !i);
	    	end
	    else
	    	begin
	    		Uslog.logf "umfparse" Uslog.Info "No callcaps for slab id %d, using 0\n" !i;
	    		Printf.fprintf oc "\n\t0x00000000UL, ";
	    	end
	    ;

	
	    (* slab_uapisupported *)
	    if( (compare (Hashtbl.find Libusmf.slab_idtotype !i) "VfT_SLAB") = 0 && 
	        (compare (Hashtbl.find Libusmf.slab_idtosubtype !i) "UAPI") = 0) then
	        Printf.fprintf oc "\n       true,"
	    else
	        Printf.fprintf oc "\n       false,"
	    ;

	
	    (* slab_uapicaps *)
	    Printf.fprintf oc "\n       {\n";
	    Printf.fprintf oc "%s" (Hashtbl.find Libusmf.slab_idtouapifnmaskstring !i);
	    Printf.fprintf oc "\n       },";


	    (* slab_memgrantreadcaps *)
	    if(Hashtbl.mem Libusmf.slab_idtomemgrantreadcaps !i) then
	        Printf.fprintf oc "\n       0x%08x," (Hashtbl.find Libusmf.slab_idtomemgrantreadcaps !i)
	    else
	        Printf.fprintf oc "\n       0x00000000UL,"
	    ;


	    (* slab_memgrantwritecaps *)
	    if(Hashtbl.mem Libusmf.slab_idtomemgrantwritecaps !i) then
	        Printf.fprintf oc "\n       0x%08x," (Hashtbl.find Libusmf.slab_idtomemgrantreadcaps !i)
	    else
	        Printf.fprintf oc "\n       0x00000000UL,"
	    ;


    	(* incl_devices *)
    	Printf.fprintf oc "\n\n%s" (Hashtbl.find Libusmf.slab_idtordinclentries !i);


    	(* incl_devices_count *)
    	Printf.fprintf oc "\n0x%08x," (Hashtbl.find Libusmf.slab_idtordinclcount !i);


    	(* excl_devices *)
    	Printf.fprintf oc "\n\n%s" (Hashtbl.find Libusmf.slab_idtordexclentries !i);


    	(* excl_devices_count *)
    	Printf.fprintf oc "\n0x%08x," (Hashtbl.find Libusmf.slab_idtordexclcount !i);


	    (* slab_physmem_extents *)
	    Printf.fprintf oc "\n	    {";
	    Printf.fprintf oc "\n	        {.addr_start = %s, .addr_end = %s, .protection = 0}," (Hashtbl.find slab_idtocode_addrstart !i) (Hashtbl.find slab_idtocode_addrend !i);
	    Printf.fprintf oc "\n	        {.addr_start = %s, .addr_end = %s, .protection = 0}," (Hashtbl.find slab_idtodata_addrstart !i) (Hashtbl.find slab_idtodata_addrend !i);
	    Printf.fprintf oc "\n	        {.addr_start = %s, .addr_end = %s, .protection = 0}," (Hashtbl.find slab_idtostack_addrstart !i) (Hashtbl.find slab_idtostack_addrend !i);
	    Printf.fprintf oc "\n	        {.addr_start = %s, .addr_end = %s, .protection = 0}," (Hashtbl.find slab_idtodmadata_addrstart !i) (Hashtbl.find slab_idtodmadata_addrend !i);
	    Printf.fprintf oc "\n	    },";

(*
	    (* slab memoffset entries *)
	    Printf.fprintf oc "\n	    {";
	    if (!g_memoffsets && ((compare (Hashtbl.find Libusmf.slab_idtosubtype !i) "XRICHGUEST") <> 0) ) then
	        Printf.fprintf oc "%s" (Hashtbl.find Libusmf.slab_idtomemoffsetstring !i)
	    else
	        Printf.fprintf oc "0"
	    ;
	    Printf.fprintf oc "\n	    },";
*)


	    (* slab_entrystub *)
	    Printf.fprintf oc "\n	    %s" (Hashtbl.find slab_idtocode_addrstart !i);


	    Printf.fprintf oc "\n	},";
		Printf.fprintf oc "\n";

	
		i := !i + 1;
	done;
	

	Printf.fprintf oc "\n};";

	close_out oc;
	()


let umf_output_linkerscript () =
    let oc = open_out !g_outputfile_linkerscript in

	Printf.fprintf oc "\n/* autogenerated XMHF linker script */";
	Printf.fprintf oc "\n/* author: amit vasudevan (amitvasudevan@acm.org) */";
	
	Printf.fprintf oc "\n#include <xmhf.h>";
	Printf.fprintf oc "\n";
	Printf.fprintf oc "\n";
	Printf.fprintf oc "\nOUTPUT_ARCH(\"i386\")";
	Printf.fprintf oc "\n";
	Printf.fprintf oc "\nMEMORY";
	Printf.fprintf oc "\n{";
	Printf.fprintf oc "\n  all (rwxai) : ORIGIN = 0x%08x, LENGTH = 0x%08x" !g_loadaddr !g_loadmaxsize;
	Printf.fprintf oc "\n  unaccounted (rwxai) : ORIGIN = 0, LENGTH = 0 /* see section .unaccounted at end */";
	Printf.fprintf oc "\n}";
	Printf.fprintf oc "\nSECTIONS";
	Printf.fprintf oc "\n{";
	Printf.fprintf oc "\n	. = 0x%08x;" !g_loadaddr;
	Printf.fprintf oc "\n";


	i := 0;
	while (!i < !Libusmf.g_totalslabs) do

	    if ( (compare (Hashtbl.find Libusmf.slab_idtosubtype !i) "XRICHGUEST") <> 0 ) then
	    	begin
			    Printf.fprintf oc "\n	.slab_%s : {" (Hashtbl.find Libusmf.slab_idtoname !i);
			    Printf.fprintf oc "\n		. = ALIGN(1);";
			    Printf.fprintf oc "\n		_objs_slab_%s/%s.slo(.slabcode)" (Hashtbl.find Libusmf.slab_idtoname !i) (Hashtbl.find Libusmf.slab_idtoname !i);
			    Printf.fprintf oc "\n		. = ALIGN(1);";
			    Printf.fprintf oc "\n		_objs_slab_%s/%s.slo(.slabdata)" (Hashtbl.find Libusmf.slab_idtoname !i) (Hashtbl.find Libusmf.slab_idtoname !i);
			    Printf.fprintf oc "\n		. = ALIGN(1);";
			    Printf.fprintf oc "\n		_objs_slab_%s/%s.slo(.slabstack)" (Hashtbl.find Libusmf.slab_idtoname !i) (Hashtbl.find Libusmf.slab_idtoname !i);
			    Printf.fprintf oc "\n		. = ALIGN(1);";
			    Printf.fprintf oc "\n		_objs_slab_%s/%s.slo(.slabdmadata)" (Hashtbl.find Libusmf.slab_idtoname !i) (Hashtbl.find Libusmf.slab_idtoname !i);
			    Printf.fprintf oc "\n		. = ALIGN(1);";
			    Printf.fprintf oc "\n	} >all=0x0000";
			    Printf.fprintf oc "\n";
			end
		;		
		
	    i := !i + 1;
	done;

	Printf.fprintf oc "\n";
	Printf.fprintf oc "\n	/* this is to cause the link to fail if there is";
	Printf.fprintf oc "\n	* anything we didn't explicitly place.";
	Printf.fprintf oc "\n	* when this does cause link to fail, temporarily comment";
	Printf.fprintf oc "\n	* this part out to see what sections end up in the output";
	Printf.fprintf oc "\n	* which are not handled above, and handle them.";
	Printf.fprintf oc "\n	*/";
	Printf.fprintf oc "\n	.unaccounted : {";
	Printf.fprintf oc "\n	*(*)";
	Printf.fprintf oc "\n	} >unaccounted";
	Printf.fprintf oc "\n}";
	Printf.fprintf oc "\n";


	close_out oc;
	()



let file_copy input_name output_name =
	let buffer_size = 8192 in
	let buffer = Bytes.create buffer_size in
  let fd_in = openfile input_name [O_RDONLY] 0 in
  let fd_out = openfile output_name [O_WRONLY; O_CREAT; O_TRUNC] 0o666 in
  let rec copy_loop () = match read fd_in buffer 0 buffer_size with
    |  0 -> ()
    | r -> ignore (write fd_out buffer 0 r); copy_loop ()
  in
  copy_loop ();
  close fd_in;
  close fd_out;

()


(* preprocess all uobj manifests *)
let umf_preprocess_uobjs uobj_rootdir ppflags =
	let i = ref 0 in
	let pp_cmdline_base = ref "" in
	let pp_cmdline = ref "" in
	let uobj_dir = ref "" in
	let uobj_mf_file = ref "" in
	let uobj_temp_mf_file = ref "" in
	let uobj_temp_mf_pp_file = ref "" in
		
		pp_cmdline_base := "ccomp -E -P " ^ ppflags;
		
		(* now iterate through all the uobjs *)
		i := 0;
		while (!i < !Libusmf.g_totalslabs) do
	    	begin
					uobj_dir := uobj_rootdir ^ (Hashtbl.find Libusmf.slab_idtoname !i) ^ "/";
					uobj_mf_file := !uobj_dir ^ (Hashtbl.find Libusmf.slab_idtoname !i) ^ ".gsm";
					uobj_temp_mf_file := !uobj_dir ^ (Hashtbl.find Libusmf.slab_idtoname !i) ^ ".gsm.c";
					uobj_temp_mf_pp_file := !uobj_dir ^ (Hashtbl.find Libusmf.slab_idtoname !i) ^ ".gsm.pp";

					file_copy !uobj_mf_file !uobj_temp_mf_file;
					
					pp_cmdline := !pp_cmdline_base ^ " ";
					pp_cmdline := !pp_cmdline ^ !uobj_temp_mf_file;
					pp_cmdline := !pp_cmdline ^ " > ";
					pp_cmdline := !pp_cmdline ^ !uobj_temp_mf_pp_file;
					
					
					Uslog.logf "umf" Uslog.Info "Pre-processing uobj: %s\n" (Hashtbl.find Libusmf.slab_idtoname !i);      			
					Sys.command !pp_cmdline;
					
					Sys.remove !uobj_temp_mf_file;
					
	    		i := !i + 1;
			end
		done;

()




(*	
let run () =
	Uslog.logf "umfparse" Uslog.Info "Parsing manifest...\n";
	umf_process_cmdline ();

	g_rootdir := (Filename.dirname !g_slabsfile) ^ "/";
	Uslog.logf "umfparse" Uslog.Info "g_rootdir=%s\n" !g_rootdir;

	g_totaluhslabmempgtblsets := !g_totaluhslabs;
	g_totaluvslabiotblsets := !g_totaluhslabs;
	g_totalslabmempgtblsets := !g_totaluhslabmempgtblsets + 2;
	g_totalslabiotblsets := !g_totaluvslabiotblsets + 2;
	g_uhslabcounter := 0;
	g_ugslabcounter := 0;

	umfcommon_init !g_slabsfile !g_memoffsets !g_rootdir;
	Uslog.logf "umfparse" Uslog.Info "g_totalslabs=%d \n" !g_totalslabs;
	
	umf_compute_memory_map ();

	umf_configure_slabs ();

	umf_output_infotable ();
	
	umf_output_linkerscript ();
	
	Uslog.logf "umfparse" Uslog.Info "Done.\n";
	()


let () = Db.Main.extend run
*)



let main () =
	Uslog.current_level := Uslog.ord Uslog.Info;

	Uslog.logf "umfparse" Uslog.Info "Parsing manifest...";
	umf_process_cmdline ();

	g_rootdir := (Filename.dirname !g_slabsfile) ^ "/";
	Uslog.logf "umfparse" Uslog.Info "g_rootdir=%s" !g_rootdir;

	g_totaluhslabmempgtblsets := !g_totaluhslabs;
	g_totaluvslabiotblsets := !g_totaluhslabs;
	g_totalslabmempgtblsets := !g_totaluhslabmempgtblsets + 2;
	g_totalslabiotblsets := !g_totaluvslabiotblsets + 2;
	g_uhslabcounter := 0;
	g_ugslabcounter := 0;

	Libusmf.usmf_maxincldevlistentries := !g_maxincldevlistentries;  
	Libusmf.usmf_maxexcldevlistentries := !g_maxexcldevlistentries; 
	Libusmf.usmf_maxmemoffsetentries := !g_maxmemoffsetentries;


	Libusmf.usmf_parse_uobj_list !g_slabsfile !g_rootdir;
	Uslog.logf "umf" Uslog.Info "g_totalslabs=%d \n" !Libusmf.g_totalslabs;

	umf_preprocess_uobjs !g_rootdir !g_ppflags;
	Uslog.logf "umf" Uslog.Info "Preprocessed all uobjs\n";

	Libusmf.usmf_parse_uobjs !g_memoffsets;
	Uslog.logf "umf" Uslog.Info "Parsed all uobjs\n";
	
	umf_compute_memory_map ();

  Uslog.logf "umfparse" Uslog.Info "g_memoffsets=%b" !g_memoffsets;
	umf_configure_slabs ();

  Uslog.logf "umfparse" Uslog.Info "proceeding to output uobj info table...";
	umf_output_infotable ();
  Uslog.logf "umfparse" Uslog.Info "successfully generated uobj info table!";

  Uslog.logf "umfparse" Uslog.Info "proceeding to output linker script...";
	umf_output_linkerscript ();
  Uslog.logf "umfparse" Uslog.Info "successfully generated linker script";

	Uslog.logf "umfparse" Uslog.Info "Done.\n";
;;

		
main ();;


