#' Increment package version
#'
#' @description `use_version()` increments the "Version" field in `DESCRIPTION`,
#'   adds a new heading to `NEWS.md` (if it exists), and commits those changes
#'   (if package uses Git).
#'
#' @description `use_dev_version()` increments to a development version, e.g.
#'   from 1.0.0 to 1.0.0.9000. If the existing version is already a development
#'   version with four components, it does nothing. Thin wrapper around
#'   `use_version()`.
#'
#' @param which A string specifying which level to increment, one of: "major",
#'   "minor", "patch", "dev". If `NULL`, user can choose interactively.
#'
#' @seealso The [version
#'   section](http://r-pkgs.had.co.nz/description.html#version) of [R
#'   Packages](http://r-pkgs.had.co.nz).
#'
#' @examples
#' \dontrun{
#' ## for interactive selection, do this:
#' use_version()
#'
#' ## request a specific type of increment
#' use_version("minor")
#' use_dev_version()
#' }
#'
#' @name use_version
NULL

#' @rdname use_version
#' @export
use_version <- function(which = NULL) {
  if (is.null(which) && !interactive()) {
    return(invisible(FALSE))
  }

  check_is_package("use_version()")
  check_uncommitted_changes()

  new_ver <- choose_version(which)
  if (is.null(new_ver)) {
    return(invisible(FALSE))
  }

  use_description_field("Version", new_ver, overwrite = TRUE)
  if (which == "dev") {
    use_news_heading("(development version)")
  } else {
    use_news_heading(new_ver)
  }

  git_ask_commit("Increment version number")
  invisible(TRUE)
}

#' @rdname use_version
#' @export
use_dev_version <- function() {
  check_is_package("use_dev_version()")
  ver <- desc::desc_get_version(proj_get())
  if (length(unlist(ver)) > 3) {
    return(invisible())
  }
  use_version(which = "dev")
}

choose_version <- function(which = NULL) {
  ver <- desc::desc_get_version(proj_get())
  versions <- bump_version(ver)

  if (is.null(which)) {
    choice <- utils::menu(
      choices = glue(
        "{format(names(versions), justify = 'right')} --> {versions}"
      ),
      title = glue(
        "Current version is {ver}.\n", "Which part to increment? (0 to exit)"
      )
    )
    if (choice == 0) {
      return(invisible())
    } else {
      which <- names(versions)[choice]
    }
  }

  which <- match.arg(which, c("major", "minor", "patch", "dev"))
  versions[which]
}

bump_version <- function(ver) {
  bumps <- c("major", "minor", "patch", "dev")
  vapply(bumps, bump_, character(1), ver = ver)
}

bump_ <- function(x, ver) {
  d <- desc::desc(text = paste0("Version: ", ver))
  suppressMessages(d$bump_version(x)$get("Version")[[1]])
}
