# Configuration file for the Sphinx documentation builder.
#
# This file only contains a selection of the most common options. For a full
# list see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Path setup --------------------------------------------------------------

# If extensions (or modules to document with autodoc) are in another directory,
# add these directories to sys.path here. If the directory is relative to the
# documentation root, use os.path.abspath to make it absolute, like shown here.
#
# import os
# import sys
# sys.path.insert(0, os.path.abspath('.'))


# -- Project information -----------------------------------------------------

# source_suffix = ['.rst', '.md']
source_suffix = '.rst'

# The master toctree document.
master_doc = 'index'

project = 'überSpark Documentation'
copyright = '2020, Amit Vasudevan'
author = 'https://uberspark.org'
release = 'Version: 6.0.0; Release Series: "Nexus Prime"'

# -- General configuration ---------------------------------------------------

# Add any Sphinx extension module names here, as strings. They can be
# extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
# ones.

extensions = [
    'sphinx.ext.autosectionlabel',
    'sphinxjsondomain',
    'breathe'
]
autosectionlabel_prefix_document = True
autosectionlabel_maxdepth = 4

breathe_order_parameters_first = True

breathe_implementation_filename_extensions = ['.c', '.cS']
breathe_projects = { "uobjrtl-crt": "_build/breathe/doxygen/uobjrtl-crt/xml/",
                    "uobjrtl-crypto": "_build/breathe/doxygen/uobjrtl-crypto/xml/",
                    "uobjrtl-hw": "_build/breathe/doxygen/uobjrtl-hw/xml/",
                   }
breathe_doxygen_config_options = {'ALIASES':    ( ' details_begin="\par Details ^^ \\verbatim embed:rst:leading-asterisk ^^"'
                                                  ' details_end="\endverbatim ^^"'
                                                  ' headers_begin="\par Headers(s) ^^ \\verbatim embed:rst:leading-asterisk ^^"'
                                                  ' headers_end="\endverbatim ^^"'
                                                  ' comments_begin="\par Comment(s) ^^ \\verbatim embed:rst:leading-asterisk ^^"'
                                                  ' comments_end="\endverbatim ^^"'
                                                  ' uobjrtl_namespace{1}="\par üobjrtl Namespace ^^ <em> \\1 </em> ^^"'
                                                ),
                                   'EXTENSION_MAPPING': ('cS=C'),
                                   'FILE_PATTERNS':  'cS',
                                   'EXTRACT_ALL' : 'YES',
                                   'MACRO_EXPANSION': 'YES',
                                 }
breathe_projects_source = {
     "uobjrtl-crt" : ( "../src-nextgen/uobjrtl/crt", ["src/memcmp.c", 
                                                      "src/memcpy.c",
                                                      "src/memmove.c",
                                                      "src/memset.c",
                                                      "src/strchr.c",
                                                      "src/strcmp.c",
                                                      "src/strlen.c",
                                                      "src/strncmp.c",
                                                      "src/strncpy.c",
                                                      "src/strnlen.c",
                                                      "include/string.h",
                                                      "include/stdint.h"
                                                    ] ),

     "uobjrtl-crypto" : ( "../src-nextgen/uobjrtl/crypto", ["src/ciphers/aes/aes.c", 
                                                            "src/ciphers/aes/aes_cbc.c",
                                                            "src/ciphers/aes/aes_tab.c",
                                                            "src/hashes/sha1/sha1.c",
                                                            "src/mac/hmacsha1/hmacsha1.c",
                                                            "include/basedefs.h",
                                                            "include/ciphers/aes/aes.h",
                                                            "include/hashes/sha1/sha1.h",
                                                            "include/mac/hmacsha1/hmacsha1.h"
                                                        ] ),
    
     "uobjrtl-hw" : ( "../src-nextgen/uobjrtl/hw", ["src/generic/x86_32/intel/cpu_bsrl.cS",
                                                    "src/generic/x86_32/intel/cpu_cpuid.cS",
                                                    "src/generic/x86_32/intel/cpu_disableintr.cS",
                                                    "src/generic/x86_32/intel/cpu_enableintr.cS",
                                                    "src/generic/x86_32/intel/cpu_fls.c",
                                                    "src/generic/x86_32/intel/cpu_getgdtbase.cS",
                                                    "src/generic/x86_32/intel/cpu_getidtbase.cS",
                                                    "src/generic/x86_32/intel/cpu_getseccaps.c",
                                                    "src/generic/x86_32/intel/cpu_getsec.cS",
                                                    "src/generic/x86_32/intel/cpu_getsecparams.c",
                                                    "src/generic/x86_32/intel/cpu_getsecsenter.c",
                                                    "src/generic/x86_32/intel/cpu_getsecsexit.c",
                                                    "src/generic/x86_32/intel/cpu_getsecsmctrl.c",
                                                    "src/generic/x86_32/intel/cpu_getsecwakeup.c",
                                                    "src/generic/x86_32/intel/cpu_gettssbase.cS",
                                                    "src/generic/x86_32/intel/cpu_getvendor.c",
                                                    "src/generic/x86_32/intel/cpu_hasxsave.c",
                                                    "src/generic/x86_32/intel/cpu_hlt.cS",
                                                    "src/generic/x86_32/intel/cpu_inb.cS",
                                                    "src/generic/x86_32/intel/cpu_inl.cS",
                                                    "src/generic/x86_32/intel/cpu_invept.cS",
                                                    "src/generic/x86_32/intel/cpu_invvpid.cS",
                                                    "src/generic/x86_32/intel/cpu_inw.cS",
                                                    "src/generic/x86_32/intel/cpu_loadgdt.cS",
                                                    "src/generic/x86_32/intel/cpu_loadidt.cS",
                                                    "src/generic/x86_32/intel/cpu_loadtr.cS",
                                                    "src/generic/x86_32/intel/cpu_mtrrenabledisable.c",
                                                    "src/generic/x86_32/intel/cpu_mtrrrestore.c",
                                                    "src/generic/x86_32/intel/cpu_mtrrsave.c",
                                                    "src/generic/x86_32/intel/cpu_mtrrsetmemtype.c",
                                                    "src/generic/x86_32/intel/cpu_mtrrvalidate.c",
                                                    "src/generic/x86_32/intel/cpu_outb.cS",
                                                    "src/generic/x86_32/intel/cpu_outl.cS",
                                                    "src/generic/x86_32/intel/cpu_outw.cS",
                                                    "src/generic/x86_32/intel/cpu_pause.cS",
                                                    "src/generic/x86_32/intel/cpu_rdmsr.cS",
                                                    "src/generic/x86_32/intel/cpu_rdtsc.cS",
                                                    "src/generic/x86_32/intel/cpu_readcr0.cS",
                                                    "src/generic/x86_32/intel/cpu_readcr2.cS",
                                                    "src/generic/x86_32/intel/cpu_readcr3.cS",
                                                    "src/generic/x86_32/intel/cpu_readcr4.cS",
                                                    "src/generic/x86_32/intel/cpu_readcs.cS",
                                                    "src/generic/x86_32/intel/cpu_readds.cS",
                                                    "src/generic/x86_32/intel/cpu_readeflags.cS",
                                                    "src/generic/x86_32/intel/cpu_reades.cS",
                                                    "src/generic/x86_32/intel/cpu_readesp.cS",
                                                    "src/generic/x86_32/intel/cpu_readfs.cS",
                                                    "src/generic/x86_32/intel/cpu_readgs.cS",
                                                    "src/generic/x86_32/intel/cpu_readrsp.cS",
                                                    "src/generic/x86_32/intel/cpu_readss.cS",
                                                    "src/generic/x86_32/intel/cpu_readtr.cS",
                                                    "src/generic/x86_32/intel/cpu_reloadcs.cS",
                                                    "src/generic/x86_32/intel/cpu_reloaddsregs.cS",
                                                    "src/generic/x86_32/intel/cpu_spinlock.cS",
                                                    "src/generic/x86_32/intel/cpu_spinunlock.cS",
                                                    "src/generic/x86_32/intel/cpu_txtgetbiosdatasize.c",
                                                    "src/generic/x86_32/intel/cpu_txtgetbiosdatastart.c",
                                                    "src/generic/x86_32/intel/cpu_txtgetheap.c",
                                                    "src/generic/x86_32/intel/cpu_txtgetosmledatasize.c",
                                                    "src/generic/x86_32/intel/cpu_txtgetosmledatastart.c",
                                                    "src/generic/x86_32/intel/cpu_txtgetossinitdatasize.c",
                                                    "src/generic/x86_32/intel/cpu_txtgetossinitdatastart.c",
                                                    "src/generic/x86_32/intel/cpu_txtgetsinitmledatasize.c",
                                                    "src/generic/x86_32/intel/cpu_txtgetsinitmledatastart.c",
                                                    "src/generic/x86_32/intel/cpu_txtislaunched.c",
                                                    "src/generic/x86_32/intel/cpu_txtreadprivcr.c",
                                                    "src/generic/x86_32/intel/cpu_txtreadpubcr.c",
                                                    "src/generic/x86_32/intel/cpu_txtwriteprivcr.c",
                                                    "src/generic/x86_32/intel/cpu_txtwritepubcr.c",
                                                    "src/generic/x86_32/intel/cpu_vmclear.cS",
                                                    "src/generic/x86_32/intel/cpu_vmptrld.cS",
                                                    "src/generic/x86_32/intel/cpu_vmread.cS",
                                                    "src/generic/x86_32/intel/cpu_vmwrite.cS",
                                                    "src/generic/x86_32/intel/cpu_vmxon.cS",
                                                    "src/generic/x86_32/intel/cpu_wbinvd.cS",
                                                    "src/generic/x86_32/intel/cpu_writecr0.cS",
                                                    "src/generic/x86_32/intel/cpu_writecr3.cS",
                                                    "src/generic/x86_32/intel/cpu_writecr4.cS",
                                                    "src/generic/x86_32/intel/cpu_writeeflags.cS",
                                                    "src/generic/x86_32/intel/cpu_wrmsr.cS",
                                                    "src/generic/x86_32/intel/cpu_xgetbv.cS",
                                                    "src/generic/x86_32/intel/cpu_xsetbv.cS",
                                                    "src/generic/x86_32/intel/keyb_reboot.c",
                                                    "src/generic/x86_32/intel/lapic_getid.c",
                                                    "src/generic/x86_32/intel/lapic_isbsp.c",
                                                    "src/generic/x86_32/intel/pci_initbus.c",
                                                    "src/generic/x86_32/intel/pci_read.c",
                                                    "src/generic/x86_32/intel/pci_write.c",
                                                    "src/generic/x86_32/intel/pit_udelay.c",
                                                    "src/generic/x86_32/intel/sysmem_bcopy.cS",
                                                    "src/generic/x86_32/intel/sysmem_getacpirsdp.c",
                                                    "src/generic/x86_32/intel/sysmem_obj2sys.cS",
                                                    "src/generic/x86_32/intel/sysmem_readu16.cS",
                                                    "src/generic/x86_32/intel/sysmem_readu32.cS",
                                                    "src/generic/x86_32/intel/sysmem_readu64.cS",
                                                    "src/generic/x86_32/intel/sysmem_readu8.cS",
                                                    "src/generic/x86_32/intel/sysmem_sys2obj.cS",
                                                    "src/generic/x86_32/intel/sysmem_writeu16.cS",
                                                    "src/generic/x86_32/intel/sysmem_writeu32.cS",
                                                    "src/generic/x86_32/intel/sysmem_writeu64.cS",
                                                    "src/generic/x86_32/intel/sysmem_writeu8.cS",
                                                    "src/generic/x86_32/intel/vtd_disablepmr.c",
                                                    "src/generic/x86_32/intel/vtd_disabletrans.c",
                                                    "src/generic/x86_32/intel/vtd_enabletrans.c",
                                                    "src/generic/x86_32/intel/vtd_initdrhd.c",
                                                    "src/generic/x86_32/intel/vtd_invlcaches.c",
                                                    "src/generic/x86_32/intel/vtd_readreg.c",
                                                    "src/generic/x86_32/intel/vtd_setphm.c",
                                                    "src/generic/x86_32/intel/vtd_setplm.c",
                                                    "src/generic/x86_32/intel/vtd_setret.c",
                                                    "src/generic/x86_32/intel/vtd_writereg.c",
                                                    "include/generic/x86_32/intel/hw.h",
                                                ] ),

     }

# Add any paths that contain templates here, relative to this directory.
templates_path = ['_templates']

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
# This pattern also affects html_static_path and html_extra_path.
exclude_patterns = ['_themes', '_temp']


# -- Options for HTML output -------------------------------------------------

# The theme to use for HTML and HTML Help pages.  See the documentation for
# a list of builtin themes.
#

html_theme = 'rtd_uberspark'
html_theme_path = ["_themes", ]
html_theme_options = {
    'repository' : 'https://github.com/uberspark/uberspark',
    'style_external_links': True,
    'collapse_navigation' : False,
    'navigation_depth': 4,

    'current_language' : 'en',
    'current_version' : 'latest',

    'languages' : {
        'en' : ''
    },

    'versions' : {
        'latest' : ''
    },

    'downloads' : {
        'PDF' : ''
    }

}    


# -- Options for LaTeX output ---------------------------------------------

latex_engine = 'pdflatex'
latex_elements = {
    'papersize': 'letterpaper',
    'figure_align':'htbp',
    'pointsize': '12pt',
}

# Grouping the document tree into LaTeX files. List of tuples
# (source start file, target name, title,
#  author, documentclass [howto, manual, or own class]).
latex_documents = [
    (master_doc, 'uberspark_documentation.tex', project,
     author, 'manual')
]



