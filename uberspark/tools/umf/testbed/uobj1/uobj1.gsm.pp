{
	"uobj-name": "uobj1",
	"uobj-type": "VfT_SLAB",
	"uobj-subtype": "PRIME",

	"uobj-uapifunctions":[],

	"uobj-callees": "uobj2",

	"uobj-uapicallees":[
		{ 
			"uobj-name": "uobj2",
			"uobj-uapifunctionid": "1", 
			"opt1" : "void {}",
			"opt2" : "(1)" 
		},
		{ 
			"uobj-name": "uobj2",
			"uobj-uapifunctionid": "2", 
			"opt1" : "void {}",
			"opt2" : "(1)" 
		}
	],	


	"uobj-resource-devices":[
		{ 
			"type": "include",
			"opt1" : "0xdead",
			"opt2" : "0xbeef" 
		},
		{ 
			"type": "include",
			"opt1" : "0xf00d",
			"opt2" : "0xdead" 
		}
	],	

	"uobj-resource-memory":[
		{ 
			"access-type": "read",
			"uobj-name": "uobj2"
		},
		{ 
			"access-type": "write",
			"uobj-name": "uobj2"
		}
	],	

	"uobj-exportfunctions": "__xmhf_exception_handler_0
							 __xmhf_exception_handler_1
							 __xmhf_exception_handler_2",


	"uobj-binary-sections":[
		{ 
			"section-name": "code",
			"section-size": "4096"
		},
		{ 
			"section-name": "data",
			"section-size": "4096"
		},
		{ 
			"section-name": "stack",
			"section-size": "4096"
		},
		{ 
			"section-name": "dmadata",
			"section-size": "4096"
		}
	],	

	
	"c-files":	"a1.c
				 a2.c
				 a3.c
				 a4.c		",
	
	
	"v-harness": [
	    { "file": "a1.c", "options" : "--option1" },
	    { "file": "a2.c", "options" : "--option2" },
	    { "file": "a3.c", "options" : "--option3" }
	  ]
		
	
}