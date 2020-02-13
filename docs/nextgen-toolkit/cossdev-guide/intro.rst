.. include:: /macros.rst

Introduction
============

The |uberspark| |cosslong| (|coss|) Developer's Guide describes the various framework elements and 
development and verification work-flow and aims to enable seamless integration into an existing 
|coss| source-code base. 

This guide is intended for |coss| stack developers who are interested in refactoring their existing
legacy code-base to take advantage of |uberspark|'s capabilities.

we assume that we have done user-guide installation 

identify |coss| functionality -- hello world which has two functions; main and hello world;
    take the listing from example
     hello world returns the integer
    goal is to pare away hello world into a uobj
    prep a folder called helouobjcoll (fref uobjcoll)
    within that folder add another directory called hello uobj (fref uobj)

prep staging
    refer to staging in the gen guide

create uobjs   -- describe uobj singleton uobj
    describe a uobj manifest example; take it from test uobj 
    describe uobj manifest nodes in the context of hello world
    talk about sources that we add
    talk about cli; refs to manifest and cli

create uobjcoll -- describe collection
    describe uobjcollection manifest example; take it from test uobj
    talk about public method and sentinel
    also talk about interobjcoll and legacy calls
    select load address within address space
    specify loader

re-integrate uobj into |coss|
    plug in uberspark_loaduobjcoll interface
        if uberspark is found then it will bind sentinels; else it will just select the call
    link with uberspark |coss| library to get uberspark_loaduobjcoll resolved
    link with uobjcoll library to get existing hello_world resolved correctly
    include uberspark, include uobjcoll/xxx
 
prep install and/or package manager 
    change install target to use uberspark; if not then copy files to ~/uberspark/staging/current/uberspark/
   package installer should take into account and copy collection into ...
    see: genuser guide installing and executing




