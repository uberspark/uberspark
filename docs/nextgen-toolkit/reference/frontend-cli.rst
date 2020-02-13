.. include:: /macros.rst


.. _frontend-cli-intro:

|uspark| Front-end Tool
=======================

The |uberspark| front-end command line interface (CLI) consists of a single executable |ubersparkexecf| that
is invoked with a set of options towards a specific task (e.g., managing bridges, building and verifying
|uobj| and |uobjcoll|, managing staging environments etc.)



Top-level CLI
--------------

The |ubersparkexecf| front-end tool top-level command line options is as given below

.. highlight:: scdoc

::

    SYNOPSIS
        uberspark [COMMAND...] [OPTIONS]...

    COMMANDS
        bridge
            Manage uberspark code bridges

        staging
            Manage uberspark staging

        uobj
            verify, build and/or manage uobjs

        uobjcoll
            verify, build and/or manage uobj collections

    COMMON OPTIONS
        These options are common to all commands.

        --help[=FMT] (default=auto)
            Show this help in format FMT. The value FMT must be one of `auto`,
            `pager`, `groff` or `plain`. With `auto`, the format is `pager` or
            `plain` whenever the TERM env var is `dumb` or undefined.

        --log-level=VAL (absent=4)
            Set output logging level to VAL. All output log messages less than
            or equal to VAL will be printed to the standard output. VAL can be
            `5` (Debug), `4` (Info), `3` (Warn), `2` (Error), `1` (Stdoutput),
            or `0` (None)

        --quiet, -q
            Suppress all output logging. Same as `--log-level=0`

        --root-dir=DIR, --rd=DIR
            Use root directory DIR as namespace root folder.

        -v, --verbose
            Give verbose output. Same as `--log-level=5`

        --version
            Show version information.

    MORE HELP
        Use `uberspark COMMAND --help` for help on a single command.
        E.g., `uberspark uobj --help` for help on uobject related options.

    ISSUES
        Visit https://forums.uberspark.org to discuss issues and find potential

    EXIT STATUS
        0   on success.

        1   on general errors.

        124 on command line parsing errors.

        125 on unexpected internal errors.


.. highlight:: default



