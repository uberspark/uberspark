AC_INIT([uberspark], [5.0])

######
# simple configuration of tools. (just looks for matching binary on PATH)
######
AC_CHECK_PROG([MAKE], [make], [make])
AC_CHECK_PROG([OCAMLC], [ocamlc], [ocamlc])
AC_CHECK_PROG([OCAMLOPT], [ocamlopt], [ocamlopt])
AC_CHECK_PROG([FRAMAC], [frama-c], [frama-c])
AC_CHECK_PROG([CCERT], [ccomp], [ccomp])
AC_CHECK_PROG([CC], [gcc -m32], [gcc -m32])
AC_CHECK_PROG([AS], [as], [as])
AC_CHECK_PROG([AR], [ar], [ar])
AC_CHECK_PROG([LD], [ld], [ld])
AC_CHECK_PROG([RM], [rm -f], [rm -f])
AC_CHECK_PROG([CP], [cp], [cp])
AC_CHECK_PROG([MKDIR], [mkdir], [mkdir])
AC_CHECK_PROG([CAT], [cat], [cat])


######
# uberspark specific configure options
######

# target cpu
AC_SUBST([TARGET_CPU])
AC_ARG_WITH([target_cpu],
        AS_HELP_STRING([--with-target-cpu=@<:@CPU@:>@],
                [select target cpu (x86)]),
                , [with_target_cpu=x86])
TARGET_CPU=$[]with_target_cpu

# target container
AC_SUBST([TARGET_CONTAINER])
AC_ARG_WITH([target_container],
        AS_HELP_STRING([--with-target-container=@<:@CONTAINER@:>@],
                [select target container (vmx)]),
                , [with_target_container=vmx])
TARGET_CONTAINER=$[]with_target_container

# target platform
AC_SUBST([TARGET_PLATFORM])
AC_ARG_WITH([target_platform],
        AS_HELP_STRING([--with-target-platform=@<:@PLATFORM@:>@],
                [select target platform (x86pc)]),
                , [with_target_platform=x86pc])
TARGET_PLATFORM=$[]with_target_platform

######
# autoconf variable substitutions
######


AC_SUBST([prefix])
AC_SUBST([ubersparkbindir], ['/bin'])
AC_SUBST([ubersparkhomedir], ['/AC_PACKAGE_NAME/experimental-toolchain'])
AC_SUBST([ubersparkincludedir], ['/include'])
AC_SUBST([ubersparkbuildshimsdir], ['/buildshims'])
AC_SUBST([ubersparkloadersdir], ['/loaders'])
AC_SUBST([ubersparksentinelsdir], ['/sentinels'])
AC_SUBST([ubersparktoolsdir], ['/tools'])
AC_SUBST([ubersparkuobjcolldir], ['/uobjcoll'])

AC_SUBST([uberspark_config_hw_platform_default], ['generic'])
AC_SUBST([uberspark_config_hw_arch_default], ['generic'])
AC_SUBST([uberspark_config_hw_cpu_default], ['generic'])


######
# autoconf output generation
######

AC_CONFIG_FILES(
			[uberspark-common.mk]
			[Makefile]
			[src/tools/libs/usconfig/usconfig.ml]
			)


AC_OUTPUT
