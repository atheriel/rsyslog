## Release Summary

This is a new submission.

## Test Environments

* ubuntu 16.04, R 3.4.4
* win-builder (devel)

Note that while the package will compile on Windows, it won't actually do
anything, because Windows does not support the POSIX syslog API. Instead it
will surface an error to the user if they try to call any of the functions.

The `SystemRequirements` field in the DESCRIPTION file also lists
"POSIX.1-2001" to indicate this dependency, and the `OS_type` is "unix" as
well.

## R CMD check Results

There were no ERRORs or WARNINGs.

There was 1 NOTE:

* checking CRAN incoming feasibility ... NOTE
Maintainer: 'Aaron Jacobs <atheriel@gmail.com>'

New submission

## Downstream Dependencies

There are currently no downstream dependencies for this package.
