#' @title showflow
#'
#' @description
#' Parse repository, document flows, and optionally show flows
#' Uses special code annotation to document flows
#'
#' @param repo Directory/top-level of repository. Default is working directory.
#' @param dir Sub-directory of R scripts. Default is R sub-directory of working directory.
#'
#' @export
showflow <- function(repo = ".",
                     dir = "R",

  ## repository/top level
  repo <- normalizePath(repo, mustWork = T)

  ## file path to repository of R scripts
  r_dir <- file.path(repo, dir)

  ## list R scripts
  files <- list.files(r_dir, "\\.R$", recursive = T, full.names = T)

  ## get showflow blocks
  blocks <- get_blocks(files)
  cli::cli_alert_success("Files parsed for showflow blocks")

  ## create attributes dataframe
  attrs <- get_attributes(blocks)
  cli::cli_alert_success("showflow block attributes extracted")

  ## turn to network elements
  nw_elements <- process_attributes(attrs)
  cli::cli_alert_success("showflow block dependencies and flows compiled")

  ## visnetwork of elements
  visnetwork <- get_visnetwork(nw_elements)

  print(visnetwork)
  return(visnetwork)
}

