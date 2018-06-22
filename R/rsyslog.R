#' Write Messages to the System Log
#'
#' Write messages to the system log via the POSIX syslog interface.
#'
#' @param name A string identifying the application.
#' @param open_immediately When \code{TRUE}, the connection will be opened
#'   immediately. Otherwise it will be opened when the first message is
#'   written to the log.
#' @param include_pid When \code{TRUE}, include the process ID in the log
#'   message. This may be redundant.
#' @param errors_to_console Write to the console if there is an error while
#'   sending to the system logger.
#'
#' @examples
#' \dontrun{
#' open_syslog("my_script")
#' syslog("Running script.", level = "INFO")
#' syslog("Possible issue.", level = "WARNING")
#' close_syslog()
#'
#' # Opening the syslog is not strictly necessary. You can
#' # simply write a message and it will open the log with the
#' # process name (likely "R") as the default.
#'
#' syslog("Hello from R!", level = "WARNING")
#' close_syslog()
#' }
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

#' @param message The message to write to the system log.
#' @param level The priority level of the message. One of \code{"DEBUG"},
#'   \code{"INFO"}, \code{"NOTICE"}, \code{"WARNING"}, \code{"ERR"},
#'   \code{"CRITICAL"}, \code{"ALERT"}, or \code{"EMERGE"} -- in that order of
#'   priority. See \href{RFC 5424: https://tools.ietf.org/html/rfc5424#page-11}{RFC 5424}
#'   for the basis of this schema.
#'
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
