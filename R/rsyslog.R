#' Write Messages to the System Log
#'
#' Write messages to the system log via the POSIX syslog interface. Since this
#' is a thin wrapper around that interface, you may also want to take a look at
#' \href{man7.org/linux/man-pages/man3/syslog.3.html}{its documentation}.
#'
#' @param name A string identifying the application.
#' @param open_immediately When \code{TRUE}, the connection will be opened
#'   immediately (equivalent to using \code{LOG_NDELAY}). Otherwise it will be
#'   opened when the first message is written to the log (equivalent to using
#'   \code{LOG_ODELAY}).
#' @param include_pid When \code{TRUE}, include the process ID in the log
#'   message. Equivalent to using \code{LOG_PID}.
#' @param fallback_to_console Write to the system console (e.g.
#'   \code{dev/console}) if there is an error while sending to the system
#'   logger. Equivalent to using \code{LOG_CONS}.
#' @param echo Also log the message to standard error. Equivalent to using
#'   \code{LOG_PERROR}.
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
open_syslog <- function(name, open_immediately = FALSE, include_pid = FALSE,
                        fallback_to_console = FALSE, echo = FALSE) {
  stopifnot(is.character(name))
  stopifnot(is.logical(open_immediately))
  stopifnot(is.logical(include_pid))
  stopifnot(is.logical(fallback_to_console))
  .Call(
    rsyslog_openlog, name, open_immediately, include_pid, fallback_to_console,
    echo
  )
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
