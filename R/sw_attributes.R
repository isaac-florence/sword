#' @name get_attributes
#' @noRd
#'
#' @param blocks
#'
#' @importFrom tibble enframe
#' @importFrom tidyr unnest_longer
#' @importFrom rlang .data
get_attributes <- function(blocks = NULL) {
  elements <- c()
  for (i in names(blocks)) {
    elements <- c(elements, names(blocks[[i]]))
  }
  elements <- c(c("name", "type", "uses"), setdiff(c("name", "type", "uses"), elements))

  if (any(duplicated(blocks))) {
    offender <- names(blocks)[which(duplicated(blocks))]
    stop(sprintf("Cannot have duplicated block names. Offending block '%s'", offender))
  }

  attrs <- blocks %>%
    tibble::enframe() %>%
    tidyr::unnest_longer(col = .data$value) %>%
    dplyr::rename(block = "name") %>%
    tidyr::pivot_wider(names_from = .data$value_id, values_from = .data$value)

  return(attrs)
}



#' @name process_attributes
#' @noRd
#'
#' @param attrs
#' @importFrom rlang .data
process_attributes <- function(attrs = NULL) {

  ## get title of flow(s)
  flows <- attrs %>%
    dplyr::filter(!is.na(.data$title)) %>%
    dplyr::select(.data$title, .data$description)

  if (nrow(flows) == 0) {
    cli::cli_alert_warning("No sword title provided.")
  }

  ## flow parts
  attrs <- attrs %>%
    dplyr::filter(is.na(.data$title)) %>%
    dplyr::select(-.data$title, -.data$description)

  ## relies & uses dependencies
  deps <- attrs %>%
    dplyr::select(.data$block, .data$relies, .data$uses) %>%
    tidyr::pivot_longer(cols = .data$relies:.data$uses, names_to = "dep_type", values_to = "from") %>%
    dplyr::mutate(from = strsplit(.data$from, " ")) %>%
    tidyr::unnest_longer(.data$from) %>%
    dplyr::filter(!is.na(.data$from)) %>%
    dplyr::rename("to" = "block")

  ## warning
  if (nrow(deps) < 3) {
    cli::cli_alert_warning("Few dependencies found. Is sword markup complete?")
  }

  attrs <- attrs %>%
    dplyr::select(-.data$relies, -.data$uses) %>%
    dplyr::rename(
      "id" = "block",
      "label" = "name"
    )

  ## clean
  deps <- deps %>%
    dplyr::filter(.data$to %in% attrs$id) %>%
    dplyr::filter(.data$from %in% attrs$id)

  ## warning incomplete levels
  if ("level" %in% colnames(attrs)) {
    if (any(is.na(attrs$level))) {
      cli::cli_alert_danger("@level element in at least one sword block but not all")
    }
  }

  ## output
  nw_elements <- list(attrs, deps, flows)
  names(nw_elements) <- c("attributes", "dependencies", "flows")

  return(nw_elements)
}
