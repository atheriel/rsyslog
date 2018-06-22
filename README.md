
<!-- README.md is generated from README.Rmd. Please edit that file. -->
`rsyslog`
=========

**rsyslog** is a very simple R package to interface with `syslog` -- a system logging interface available on all POSIX-compatible operating systems.

Usage
-----

Messages are sent to the system log with the `syslog()` function. You can also (optionally) configure how messages are written with `open_syslog()` and close any open connection with `close_syslog()`.

``` r
open_syslog("my_script")
syslog("Running script.", level = "INFO")
syslog("Possible issue.", level = "WARNING")
close_syslog()

# Opening the syslog is not strictly necessary. You can
# simply write a message and it will open the log with the
# process name (likely "R") as the default.
syslog("Hello from R!", level = "WARNING")
close_syslog()
```

Since `syslog` is such a simple interface, this is actually the entirety of the package API.
