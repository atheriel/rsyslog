# rsyslog 1.0.3

* Fixes compiler warnings on CRAN surfaced by `-Wstrict-prototypes`.
* Fixes URL warnings on CRAN due to redirects.

# rsyslog 1.0.2

* Removes the `LazyData` field from the `DESCRIPTION` file, which was generating
  a NOTE in CRAN's automated checking.

# rsyslog 1.0.1

* Fixes an issue where compilation would fail on some POSIX platforms that do
  not support the `LOG_PERROR` option (notably Solaris). Calling
  `open_syslog(echo = TRUE)` on those platforms will now issue a warning.

# rsyslog 1.0.0

* Initial public release. Allows R users to write messages to the 'syslog'
  system logger API, available on all 'POSIX'-compatible operating systems.
* Features include tagging messages with a priority level and application type,
  as well as masking (hiding) messages below a given priority level.
