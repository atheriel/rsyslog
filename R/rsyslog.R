#' Write Messages to the System Log
#'
#' @rdname syslog
#' @export
#' @useDynLib rsyslog rsyslog_openlog
open_syslog <- function(name, open_immediately = FALSE, include_pid = FALSE, errors_to_console = FALSE) {
  stopifnot(is.character(name))
  stopifnot(is.logical(open_immediately))
  stopifnot(is.logical(include_pid))
  stopifnot(is.logical(errors_to_console))
  .Call(rsyslog_openlog, name, open_immediately, include_pid, errors_to_console)
  invisible(NULL)
}

#' @rdname syslog
#' @export
#' @useDynLib rsyslog rsyslog_syslog
syslog <- function(message, level = "INFO") {
  stopifnot(is.character(level))
  levelno <- syslog_levels[level]
  if (is.na(levelno)) {
    stop("Unknown syslog level '", level, "'.")
  }
  stopifnot(is.character(message))
  .Call(rsyslog_syslog, message, levelno)
  invisible(NULL)
}

#' @rdname syslog
#' @export
#' @useDynLib rsyslog rsyslog_closelog
close_syslog <- function() {
  .Call(rsyslog_closelog)
  invisible(NULL)
}

# See RFC 5424: https://tools.ietf.org/html/rfc5424#page-11
syslog_levels <- c(
  "DEBUG" = 7L, "INFO" = 6L, "NOTICE" = 5L, "WARNING" = 4L, "ERR" = 3L,
  "CRITICAL" = 2L, "ALERT" = 1L, "EMERG" = 0L
)
