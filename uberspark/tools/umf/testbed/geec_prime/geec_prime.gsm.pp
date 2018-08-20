{
	"uobj-name": "geec_prime",
	"uobj-type": "VfT_SLAB",
	"uobj-subtype": "PRIME",

	"uobj-uapifunctions":[],

	"uobj-callees": "	uapi_slabmempgtbl
						",

	"uobj-uapicallees":[
		{ 
			"uobj-name": "uapi_slabmempgtbl",
			"uobj-uapifunctionid": "1", 
			"opt1" : "(void)0;",
			"opt2" : "(1)" 
		},
		{ 
			"uobj-name": "uapi_slabmempgtbl",
			"uobj-uapifunctionid": "0", 
			"opt1" : "(void)0;",
			"opt2" : "(1)" 
		}
	],	


	"uobj-resource-devices":[
		{ 
			"type": "include",
			"opt1" : "0x0000",
			"opt2" : "0x0000" 
		},
		{ 
			"type": "include",
			"opt1" : "0x0000",
			"opt2" : "0x0000" 
		},
		{ 
			"type": "include",
			"opt1" : "0x0000",
			"opt2" : "0x0000" 
		},
		{ 
			"type": "include",
			"opt1" : "0x0000",
			"opt2" : "0x0000" 
		}
	],	

	"uobj-resource-memory":[],	

	"uobj-exportfunctions": "",


	"uobj-binary-sections":[
		{ 
			"section-name": "code",
			"section-size": "0x200000"
		},
		{ 
			"section-name": "data",
			"section-size": "0x3800000"
		},
		{ 
			"section-name": "stack",
			"section-size": "0xe00000"
		},
		{ 
			"section-name": "dmadata",
			"section-size": "0x200000"
		}
	],	

	
	"c-files":	"",
		
	"v-harness": []
		
	
}



