#' @title sword
#'
#' @description
#' Parse repository, document flows, and show DAGs
#' Uses special code annotation to document flows
#'
#' @param repo Directory/top-level of repository. Default is working directory.
#' @param dir Sub-directory of R scripts. Default is R sub-directory of working directory.
#' @param flows Optional, which flows to show
#'
#' @export
sword <- function(repo = ".",
                  dir = "R",
                  flows = NULL) {

  ## repository/top level
  repo <- normalizePath(repo, mustWork = T)

  ## file path to repository of R scripts
  r_dir <- file.path(repo, dir)

  ## list R scripts
  files <- list.files(r_dir, "\\.R$", recursive = T, full.names = T)

  ## get sword blocks
  blocks <- get_blocks(files)
  cli::cli_alert_success("Files parsed for sword blocks")

  ## create attributes dataframe
  attrs <- get_attributes(blocks)
  cli::cli_alert_success("sword block attributes extracted")

  ## turn to network elements
  nw_elements <- process_attributes(attrs)
  cli::cli_alert_success("sword block dependencies and flows compiled")

  ## assign flows
  if (!is.null(flows)) {
    nw_elements <- get_flows(nw_elements, flows)
  }

  ## visnetwork of elements
  visnetwork <- get_visnetwork(nw_elements)

  print(visnetwork)
  return(visnetwork)
}
