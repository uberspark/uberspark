#define CASM_RET_LR	0xDEADBEEF

#define __casm__add(RD, RN, OP2) \
	__builtin_annot("add "#RD", "#RN", "#OP2); \
	_impl__casm__add(RD, RN, OP2); \

#define __casm__b(x) \
	__builtin_annot("b "#x" "); \
	if(1) goto x; \

/// needs work
#define __casm__bl(x) \
	__builtin_annot("bl "#x" "); \
	_impl__casm__pushl_lr(CASM_RET_LR); \
	if(1) goto x; \


#define __casm__ldr_psuedo_sp(x) \
	__builtin_annot("ldr sp, ="#x" "); \
	hwm_cpu_gprs_r13 = &&x; \
