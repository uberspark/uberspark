.. include:: /macros.rst


.. _frontend-cli-intro:

|uspark| Front-end Tool
=======================

The |uberspark| front-end command line interface (CLI) consists of a single executable |ubersparkexecf| that
is invoked with a set of options towards a specific task (e.g., managing bridges, building and verifying
|uobj| and |uobjcoll|, managing staging environments etc.)


Top-level CLI
--------------

The |ubersparkexecf| front-end tool top-level command line options and their 
usage and description are as shown below:

.. highlight:: none

::

    SYNOPSIS
        uberspark [COMMAND...] [OPTIONS]...

    COMMANDS
        bridge
            Manage uberspark bridges

        staging
            Manage uberspark staging

        uobj
            Verify, build and/or manage uobjs

        uobjcoll
            Verify, build and/or manage uobj collections

    COMMON OPTIONS
        These options are common to all commands.

        --help[=FMT] (default=auto)
            Show this help in format FMT. The value FMT must be one of `auto',
            `pager', `groff' or `plain'. With `auto', the format is `pager` or
            `plain' whenever the TERM env var is `dumb' or undefined.

        --log-level=VAL (absent=4)
            Set output logging level to VAL. All output log messages less than

            or equal to VAL will be printed to the standard output. VAL can be
            `5' (Debug), `4' (Info), `3' (Warn), `2' (Error), `1' (Stdoutput),
            or `0' (None)

        -q, --quiet
            Suppress all output logging. Same as `--log-level=0'

        --root-dir=DIR, --rd=DIR
            Use root directory DIR as namespace root folder.

        -v, --verbose
            Give verbose output. Same as `--log-level=5'

        --version
            Show version information.

    MORE HELP
        Use `uberspark COMMAND --help' for help on a single command.
        E.g., `uberspark uobj --help' for help on uobject related options.

    EXIT STATUS
        0   on success.

        1   on general errors.

        124 on command line parsing errors.

        125 on unexpected internal errors.



.. highlight:: default


.. _frontend-cli-bridges:


Bridge Management CLI
---------------------

The |ubersparkexecf| front-end tool bridge management command line options and their 
usage and description are as shown below:


::

    SYNOPSIS
        uberspark bridge ACTION [ACTION_OPTIONS]... [OPTIONS]... [ PATH or
        NAMESPACE]

    DESCRIPTION
        The bridge command provides several actions to manage the uberspark
        code bridge settings, optionally qualified by PATH or NAMESPACE.

    ARGUMENTS
        ACTION (required)

            The action to perform. ACTION must be one of one of `config',
            `create', `dump' or `remove'.

        PATH or NAMESPACE
            The bridge namespace uri.

    ACTIONS
        config
            configure a bridge specified by the NAMESPACE argument; only valid
            for bridges backed by containers. Uses the following action
            options: -ar, -as, -cc, -ld, -pp, -vf, and --build

        create
            create a new bridge namespaces from a file PATH argument. Uses the
            following action options: -ar, -as, -cc, -ld, -pp, -vf, and --bare

        dump
            store a bridge configuration specified by the NAMESPACE argument to
            the specified output directory. Uses the following action options:
            -ar, -as, -cc, -ld, -pp, -vf, --bridge-exectype, and
            --output-directory

        remove
            remove a bridge configuration namespace specified by the NAMESPACE
            argument. Uses the following action options: -ar, -as, -cc, -ld,
            -pp, -vf, and --bridge-exectype

    ACTION OPTIONS
        These options qualify the aforementioned actions.

        --ar-bridge, --ar
            Select archiver (ar) bridge namespace prefix.

        --as-bridge, --as
            Select assembler (as) bridge namespace prefix.

        -b, --build
            Build the bridge if bridge execution type is 'container'

        --bridge-exectype=TYPE, --bet=TYPE
            Select bridge execution TYPE.

        --cc-bridge, --cc
            Select compiler (cc) bridge namespace prefix.

        --ld-bridge, --ld
            Select linker (ld) bridge namespace prefix.

        -o DIR, --output-directory=DIR
            Select output directory, DIR.

        --pp-bridge, --pp
            Select pre-processor (pp) bridge namespace prefix.

        --vf-bridge, --vf
            Select verification (vf) bridge namespace prefix.

    COMMON OPTIONS
        These options are common to all commands.

        --help[=FMT] (default=auto)
            Show this help in format FMT. The value FMT must be one of `auto',
            `pager', `groff' or `plain'. With `auto', the format is `pager` or
            `plain' whenever the TERM env var is `dumb' or undefined.

        --log-level=VAL (absent=4)
            Set output logging level to VAL. All output log messages less than
            or equal to VAL will be printed to the standard output. VAL can be
            `5' (Debug), `4' (Info), `3' (Warn), `2' (Error), `1' (Stdoutput),
            or `0' (None)

        -q, --quiet
            Suppress all output logging. Same as `--log-level=0'

        --root-dir=DIR, --rd=DIR
            Use root directory DIR as namespace root folder.

        -v, --verbose
            Give verbose output. Same as `--log-level=5'

        --version
            Show version information.

    EXIT STATUS
        0   on success.

        1   on general errors.

        124 on command line parsing errors.

        125 on unexpected internal errors.


Staging Management CLI
----------------------

The |ubersparkexecf| front-end tool staging management command line options and their 
usage and description are as shown below:


::


    SYNOPSIS
        uberspark staging ACTION [ACTION_OPTIONS]... [OPTIONS]... [NAMESPACE]

    DESCRIPTION
        The staging command provides several actions to manage the uberspark
        staging settings, optionally qualified by NAMESPACE.

    ARGUMENTS
        ACTION (required)
            The action to perform. ACTION must be one of one of `create',
            `switch', `list', `remove', `config-set' or `config-get'.

        NAMESPACE
            The staging namespace.

    ACTIONS
        create
            create a new staging with a name specified via the NAMESPACE
            argument. Uses the following action options: --from-existing

        switch
            switch to a staging specified by the NAMESPACE argument.

        list
            print a list of all available stagings.

        remove
            Remove a staging specified by the NAMESPACE argument.

        config-set
            change configuration settings within the current staging. Uses the
            following action options: --setting-name, --setting-value, and
            --from-file

        config-get
            dump configuration settings within the current staging. Uses the
            following action options: --setting-name, --setting-value, and
            --to-file

    ACTION OPTIONS
        These options qualify the aforementioned actions.

        --from-existing=NAME
            Create a new staging from an existing staging specified by NAME.
        --from-file=NAME
            Set staging configuration settings from file specified by NAME.

        --setting-name=NAME
            Select staging configuration setting with NAME.

        --setting-value=VALUE
            Set staging configuration setting specified by --setting-name to
            VALUE. VALUE can be a string or integer.

        --to-file=NAME
            Store staging configuration settings to file specified by NAME.

    COMMON OPTIONS
        These options are common to all commands.

        --help[=FMT] (default=auto)
            Show this help in format FMT. The value FMT must be one of `auto',
            `pager', `groff' or `plain'. With `auto', the format is `pager` or
            `plain' whenever the TERM env var is `dumb' or undefined.

        --log-level=VAL (absent=4)
            Set output logging level to VAL. All output log messages less than
            or equal to VAL will be printed to the standard output. VAL can be
            `5' (Debug), `4' (Info), `3' (Warn), `2' (Error), `1' (Stdoutput),
            or `0' (None)

        -q, --quiet
            Suppress all output logging. Same as `--log-level=0'

        --root-dir=DIR, --rd=DIR
            Use root directory DIR as namespace root folder.

        -v, --verbose
            Give verbose output. Same as `--log-level=5'

        --version
            Show version information.

    EXIT STATUS
        0   on success.

        1   on general errors.

        124 on command line parsing errors.

        125 on unexpected internal errors.


|uobj| Management CLI
---------------------

The |ubersparkexecf| front-end tool |uobj| management command line options and their 
usage and description are as shown below:


::

    SYNOPSIS
        uberspark uobj ACTION [ACTION_OPTIONS]... [OPTIONS]... PATH or
        NAMESPACE

    DESCRIPTION
        The uobj command provides several actions to verify, build and manage
        uobjs specified by PATH or NAMESPACE.

    ARGUMENTS
        ACTION (required)
            The action to perform. ACTION must be one of `build'.

        PATH or NAMESPACE (required)
            The path to the uobj sources or a uobj namespace.

    ACTIONS
        build
            build the uobj binary.

    ACTION OPTIONS
        These options qualify the aforementioned actions.

        -a ARCH, --arch=ARCH
            Specify uobj target ARCH.

        -c CPU, --cpu=CPU
            Specify uobj target CPU.
    
        -p PLATFORM, --platform=PLATFORM
            Specify uobj target PLATFORM.

    COMMON OPTIONS
        These options are common to all commands.

        --help[=FMT] (default=auto)
            Show this help in format FMT. The value FMT must be one of `auto',
            `pager', `groff' or `plain'. With `auto', the format is `pager` or
            `plain' whenever the TERM env var is `dumb' or undefined.

        --log-level=VAL (absent=4)
            Set output logging level to VAL. All output log messages less than
            or equal to VAL will be printed to the standard output. VAL can be
            `5' (Debug), `4' (Info), `3' (Warn), `2' (Error), `1' (Stdoutput),
            or `0' (None)

        -q, --quiet
            Suppress all output logging. Same as `--log-level=0'

        --root-dir=DIR, --rd=DIR
            Use root directory DIR as namespace root folder.

        -v, --verbose
            Give verbose output. Same as `--log-level=5'

        --version
            Show version information.

    EXIT STATUS
        0   on success.

        1   on general errors.

        124 on command line parsing errors.

        125 on unexpected internal errors.



|uobjcoll| Management CLI
-------------------------

The |ubersparkexecf| front-end tool |uobjcoll| management command line options and their 
usage and description are as shown below:


::

    SYNOPSIS
        uberspark uobjcoll ACTION [ACTION_OPTIONS]... [OPTIONS]... PATH or
        NAMESPACE

    DESCRIPTION
        The uobjcoll command provides several actions to verify, build and
        manage uobj collections specified by PATH or NAMESPACE.

    ARGUMENTS
        ACTION (required)
            The action to perform. ACTION must be one of `build'.

        PATH or NAMESPACE (required)
            The path to the uobj collection sources or a uobj collection
            namespace.

    ACTIONS
        build
            build the uobj collection binary.

    ACTION OPTIONS
        These options qualify the aforementioned actions.

        -a ARCH, --arch=ARCH
            Specify uobj collection target ARCH.

        -c CPU, --cpu=CPU
            Specify uobj collection target CPU.

        -p PLATFORM, --platform=PLATFORM
            Specify uobj collection target PLATFORM.

    COMMON OPTIONS
        These options are common to all commands.

        --help[=FMT] (default=auto)
            Show this help in format FMT. The value FMT must be one of `auto',
            `pager', `groff' or `plain'. With `auto', the format is `pager` or
            `plain' whenever the TERM env var is `dumb' or undefined.

        --log-level=VAL (absent=4)
            Set output logging level to VAL. All output log messages less than
            or equal to VAL will be printed to the standard output. VAL can be
            `5' (Debug), `4' (Info), `3' (Warn), `2' (Error), `1' (Stdoutput),
            or `0' (None)

        -q, --quiet
            Suppress all output logging. Same as `--log-level=0'

        --root-dir=DIR, --rd=DIR
            Use root directory DIR as namespace root folder.

        -v, --verbose
            Give verbose output. Same as `--log-level=5'

        --version
            Show version information.

    EXIT STATUS
        0   on success.

        1   on general errors.

        124 on command line parsing errors.

        125 on unexpected internal errors.

