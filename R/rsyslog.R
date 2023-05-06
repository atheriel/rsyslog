#' Write Messages to the System Log
#'
#' Write messages to the system log via the POSIX syslog interface. Since this
#' is a thin wrapper around that interface, you may also want to take a look at
#' \href{https://man7.org/linux/man-pages/man3/syslog.3.html}{its
#' documentation}. Note that neither \code{open_syslog()} nor
#' \code{close_syslog()} is actually required, but using them is good practice.
#'
#' @param identifier A string identifying the application.
#' @param open_immediately When \code{TRUE}, the connection will be opened
#'   immediately (equivalent to using \code{LOG_NDELAY}). Otherwise it will be
#'   opened when the first message is written to the log (equivalent to using
#'   \code{LOG_ODELAY}).
#' @param include_pid When \code{TRUE}, include the process ID in the log
#'   message. Equivalent to using \code{LOG_PID}.
#' @param fallback_to_console Write to the system console (e.g.
#'   \code{/dev/console}) if there is an error while sending to the system
#'   logger. Equivalent to using \code{LOG_CONS}.
#' @param echo Also log the message to standard error. Equivalent to using
#'   \code{LOG_PERROR}. Note that this is not actually part of the POSIX
#'   specification, and may not be available on your platform. If that is the
#'   case, setting this to \code{TRUE} will generate a warning.
#' @param facility The type of program doing the logging, according to the
#'   guidelines in \href{https://datatracker.ietf.org/doc/html/rfc5424#page-10}{RFC 5424}.
#'   Generally one of \code{"USER"} or \code{"LOCAL0"} through \code{"LOCAL7"}.
#'   When this is \code{NULL}, fall back on the default.
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
open_syslog <- function(identifier, open_immediately = FALSE,
                        include_pid = FALSE, fallback_to_console = FALSE,
                        echo = FALSE, facility = NULL) {
  stopifnot(is.character(identifier))
  stopifnot(is.logical(open_immediately))
  stopifnot(is.logical(include_pid))
  stopifnot(is.logical(fallback_to_console))
  if (!is.null(facility)) {
    facility <- match.arg(facility, names(syslog_facilities))
    facility <- syslog_facilities[facility]
  }
  .Call(
    rsyslog_openlog, identifier, open_immediately, include_pid, fallback_to_console,
    echo, facility
  )
  invisible(NULL)
}

#' @param message The message to write to the system log.
#' @param level The priority level of the message. One of \code{"DEBUG"},
#'   \code{"INFO"}, \code{"NOTICE"}, \code{"WARNING"}, \code{"ERR"},
#'   \code{"CRITICAL"}, \code{"ALERT"}, or \code{"EMERGE"} -- in that order of
#'   priority. See \href{https://datatracker.ietf.org/doc/html/rfc5424#page-11}{RFC 5424}
#'   for the basis of this schema.
#'
#' @rdname syslog
#' @export
#' @useDynLib rsyslog rsyslog_syslog
syslog <- function(message, level = "INFO", facility = NULL) {
  stopifnot(is.character(level))
  level <- match.arg(level, names(syslog_levels))
  if (!is.null(facility)) {
    facility <- match.arg(facility, names(syslog_facilities))
    facility <- syslog_facilities[facility]
  }
  stopifnot(is.character(message))
  .Call(
    rsyslog_syslog, message, syslog_levels[level], facility
  )
  invisible(NULL)
}

#' @rdname syslog
#' @export
#' @useDynLib rsyslog rsyslog_closelog
close_syslog <- function() {
  .Call(rsyslog_closelog)
  invisible(NULL)
}

#' Set the System Log Priority Mask
#'
#' \code{set_syslog_mask} can be used to prevent messages below a priority
#' level from being written to the system log.
#'
#' @param level Mask (hide) messages below this priority level. One of
#'   \code{"DEBUG"}, \code{"INFO"}, \code{"NOTICE"}, \code{"WARNING"},
#'   \code{"ERR"}, \code{"CRITICAL"}, or \code{"ALERT"} -- in that order of
#'   priority. See \href{https://datatracker.ietf.org/doc/html/rfc5424#page-11}{RFC 5424}
#'   for the basis of this schema.
#'
#' @examples
#' \dontrun{
#' open_syslog("my_script")
#' syslog("This message is visible.", level = "INFO")
#' set_syslog_mask("WARNING")
#' syslog("No longer visible.", level = "INFO")
#' syslog("Still visible.", level = "WARNING")
#' close_syslog()
#' }
#'
#' @export
#' @useDynLib rsyslog rsyslog_setlogmask
set_syslog_mask <- function(level) {
  stopifnot(is.character(level))
  level <- match.arg(level, names(syslog_levels))
  .Call(rsyslog_setlogmask, syslog_levels[level])
  invisible(NULL)
}

# See RFC 5424: https://datatracker.ietf.org/doc/html/rfc5424#page-11
syslog_levels <- c(
  "DEBUG" = 7L, "INFO" = 6L, "NOTICE" = 5L, "WARNING" = 4L, "ERR" = 3L,
  "CRITICAL" = 2L, "ALERT" = 1L, "EMERG" = 0L
)

# See RFC 5424: https://datatracker.ietf.org/doc/html/rfc5424#page-10
syslog_facilities <- c(
  "KERN" = 0L, "USER" = 1L, "MAIL" = 2L, "DAEMON" = 3L, "AUTH" = 4L,
  "SYSLOG" = 5L, "LPR" = 6L, "NEWS" = 7L, "UUCP" = 8L, "CRON" = 9L,
  "AUTHPRIV" = 10L, "FTP" = 11L, "LOCAL0" = 16L, "LOCAL1" = 17L, "LOCAL2" = 18L,
  "LOCAL3" = 19L, "LOCAL4" = 20L, "LOCAL5" = 21L, "LOCAL6" = 22L, "LOCAL7" = 23L
)
