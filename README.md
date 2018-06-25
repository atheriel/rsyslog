
<!-- README.md is generated from README.Rmd. Please edit that file. -->
`rsyslog`
=========

**rsyslog** is a very simple R package to interface with [syslog](https://en.wikipedia.org/wiki/Syslog) -- a system logging interface available on all POSIX-compatible operating systems.

Installation
------------

**rsyslog** is not yet available on CRAN, so for now you'll have to install it from GitHub:

``` r
# install.packages("devtools")
devtools::install_github("atheriel/rsyslog")
```

Usage
-----

Using **rsyslog** closely resembles using the [syslog API](http://man7.org/linux/man-pages/man3/openlog.3.html), so it should be familiar if you have previous experience with syslog.

Messages are sent to the system log with the `syslog()` function. You can also (optionally) configure how messages are written with `open_syslog()` and close any open connection with `close_syslog()`.

``` r
open_syslog("my_script")
syslog("Running script.", level = "INFO")
syslog("Possible issue.", level = "WARNING")
close_syslog()
```

To see what this has printed to the system log on `systemd`-based Linux distributions (including Ubuntu), you can use the `journalctl` program:

``` shell
$ journalctl --identifier my_script
```

    -- Logs begin at Mon 2018-06-25 14:48:12 UTC, end at Mon 2018-06-25 15:35:02 UTC. --
    Jun 25 15:10:18 user my_script[4467]: Running script.
    Jun 25 15:10:18 user my_script[4467]: Possible issue.

Opening and closing the system log is not strictly necessary (though it is good practice). The following will work as well:

``` r
# Uses the process name (likely "R" or "rsession") as the identifier.
syslog("Hello from R!", level = "WARNING")
```

If you wish to control the visibility of messages by priority level (for example, to hide debug messages), use `set_syslog_mask()`:

``` r
open_syslog("my_script")
syslog("This message is visible.", level = "INFO")
set_syslog_mask("WARNING")
syslog("No longer visible.", level = "INFO")
syslog("Still visible.", level = "WARNING")
close_syslog()
```

License
-------

The package is licensed under the GPL, version 2 or later.
