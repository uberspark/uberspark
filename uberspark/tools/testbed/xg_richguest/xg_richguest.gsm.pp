{
 "uobj-name": "xg_richguest",
 "uobj-type": "uVU_SLAB",
 "uobj-subtype": "XRICHGUEST",
 "uobj-uapifunctions":[],
 "uobj-callees": "",
 "uobj-uapicallees":[],
 "uobj-resource-devices":[
  {
   "type": "include",
   "opt1" : "0xffff",
   "opt2" : "0xffff"
  },
  {
   "type": "exclude",
   "opt1" : "0x8086",
   "opt2" : "0x10b9"
  }
 ],
 "uobj-resource-memory":[
  {
   "access-type" : "read",
   "uobj-name" : "xc_init"
  },
  {
   "access-type" : "read",
   "uobj-name" : "xc_ihub"
  },
  {
   "access-type" : "write",
   "uobj-name" : "xc_init"
  },
  {
   "access-type" : "write",
   "uobj-name" : "xc_ihub"
  },
  {
   "access-type" : "read",
   "uobj-name" : "xh_syscalllog"
  },
  {
   "access-type" : "read",
   "uobj-name" : "xh_ssteptrace"
  }
 ],
 "uobj-exportfunctions": "",
 "uobj-binary-sections":[
  {
   "section-name": "code",
   "section-size": "0x0"
  },
  {
   "section-name": "data",
   "section-size": "0x03200000"
  },
  {
   "section-name": "stack",
   "section-size": "0x1F400000"
  },
  {
   "section-name": "dmadata",
   "section-size": "0xFFFFFFFF"
  }
 ],
 "c-files": "",
 "v-harness": []
}
