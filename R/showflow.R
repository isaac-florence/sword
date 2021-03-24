#' @title showflow
#'
#' @description
#' Parse repository, document flows, and optionally show flows
#' Uses special code annotation to document flows
#'
#' @param dir Directory/top-level of repository. Default is R sub-directory of working directory.
#'
#' @export
showflow <- function(dir = "./R"){

  dir <- normalizePath(dir, mustWork = T)

  files <- list.files(dir, "\\.R$", recursive = T, full.names = T)

  ## get showflow blocks
  blocks <- get_blocks(files)
  ## check blocks have minimum requirements
  check_blocks(blocks)
  cli::cli_alert_success("Files parsed for showflow blocks")

  ## create attributes dataframe
  attrs <- get_attributes(blocks)
  cli::cli_alert_success("showflow block attributes extracted")

  cli::cli_alert_success("showflow block dependencies and flows compiled")

  return(attrs)
}

