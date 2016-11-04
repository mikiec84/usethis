% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/github.R
\name{use_github}
\alias{use_github}
\title{Connect a local repo with GitHub.}
\usage{
use_github(auth_token = github_pat(), private = FALSE, pkg = ".",
  host = "https://api.github.com", protocol = c("ssh", "https"),
  credentials = NULL)
}
\arguments{
\item{auth_token}{Provide a personal access token (PAT) from
\url{https://github.com/settings/tokens}. Defaults to the \code{GITHUB_PAT}
environment variable.}

\item{private}{If \code{TRUE}, creates a private repository.}

\item{pkg}{Path to package. See \code{\link{as.package}} for more
information.}

\item{host}{GitHub API host to use. Override with the endpoint-root for your
GitHub enterprise instance, for example,
"https://github.hostname.com/api/v3".}

\item{protocol}{transfer protocol, either "ssh" (the default) or "https"}

\item{credentials}{A \code{\link[git2r]{cred_ssh_key}} specifying specific
ssh credentials or NULL for default ssh key and ssh-agent behaviour.
Default is NULL.}
}
\description{
If the current repo does not use git, calls \code{\link{use_git}}
automatically. \code{\link{use_github_links}} is called to populate the
\code{URL} and \code{BugReports} fields of DESCRIPTION.
}
\section{Authentication}{


  A new GitHub repo will be created via the GitHub API, therefore you must
  provide a GitHub personal access token (PAT) via the argument
  \code{auth_token}, which defaults to the value of the \code{GITHUB_PAT}
  environment variable. Obtain a PAT from
  \url{https://github.com/settings/tokens}. The "repo" scope is required
  which is one of the default scopes for a new PAT.

  The argument \code{protocol} reflects how you wish to authenticate with
  GitHub for this repo in the long run. For either \code{protocol}, a remote
  named "origin" is created, an initial push is made using the specified
  \code{protocol}, and a remote tracking branch is set. The URL of the
  "origin" remote has the form \code{git@github.com:<USERNAME>/<REPO>.git}
  (\code{protocol = "ssh"}, the default) or
  \code{https://github.com/<USERNAME>/<REPO>.git} (\code{protocol =
  "https"}). For \code{protocol = "ssh"}, it is assumed that public and
  private keys are in the default locations, \code{~/.ssh/id_rsa.pub} and
  \code{~/.ssh/id_rsa}, respectively, and that \code{ssh-agent} is configured
  to manage any associated passphrase.  Alternatively, specify a
  \code{\link[git2r]{cred_ssh_key}} object via the \code{credentials}
  parameter.
}
\examples{
\dontrun{
## to use default ssh protocol
create("testpkg")
use_github(pkg = "testpkg")

## or use https
create("testpkg2")
use_github(pkg = "testpkg2", protocol = "https")
}
}
\seealso{
Other git infrastructure: \code{\link{use_git_hook}},
  \code{\link{use_github_links}}, \code{\link{use_git}}
}
