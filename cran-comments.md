## Release Summary

This is a bugfix release. On some platforms (notably Solaris), the `LOG_PERROR`
symbol is not defined in `syslog.h`, which would cause compilation to fail.
This is no longer the case.

In additon, using `LOG_PERROR` functionality on those platforms will now issue
a warning.

## Test Environments

* ubuntu 16.04, R 3.4.4
* win-builder (devel)

## R CMD check Results

There were no ERRORs or WARNINGs.

There was 1 NOTE:

* checking CRAN incoming feasibility ... NOTE
Maintainer: 'Aaron Jacobs <atheriel@gmail.com>'

Days since last update: 1

## Downstream Dependencies

There are currently no downstream dependencies for this package.
