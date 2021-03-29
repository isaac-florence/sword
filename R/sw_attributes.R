#' @name get_attributes
#' @noRd
#'
#' @param blocks
#'
#' @importFrom tibble enframe
#' @importFrom tidyr unnest_longer
get_attributes <- function(blocks = NULL){

  elements <- c()
  for(i in names(blocks)){
    elements <- c(elements, names(blocks[[i]]))
  }
  elements <- c(c("name", "type", "uses"), setdiff(c("name", "type", "uses"), elements))

  attrs <- blocks %>%
    tibble::enframe() %>%
    tidyr::unnest_longer(col = value) %>%
    dplyr::rename(block = "name") %>%
    tidyr::pivot_wider(names_from = value_id, values_from = value)

  return(attrs)
}



#' @name process_attributes
#' @noRd
#'
#' @param attrs
process_attributes <- function(attrs = NULL){

  ## get title of flow(s)
  flows <- attrs %>%
    dplyr::filter(!is.na(title)) %>%
    dplyr::select(title, description)

  if(nrow(flows) == 0){
    cli::cli_alert_warning("No sword title provided.")
  }

  ## flow parts
  attrs <- attrs %>%
    dplyr::filter(is.na(title)) %>%
    dplyr::select(-title, -description)

  ## relies & uses dependencies
  deps <- attrs %>%
    dplyr::select(block, relies, uses) %>%
    tidyr::pivot_longer(cols = relies:uses, names_to = "dep_type", values_to = "from") %>%
    dplyr::mutate(from = strsplit(from, " ")) %>%
    tidyr::unnest_longer(from) %>%
    dplyr::filter(!is.na(from)) %>%
    dplyr::rename("to" ="block")

  ## warning
  if(nrow(deps) < 3)
    cli::cli_alert_warning("Few dependencies found. Is sword markup complete?")

  attrs <- attrs %>%
    dplyr::select(-relies, -uses) %>%
    dplyr::rename("id" = "block",
                  "label" = "name")

  ## output
  nw_elements <- list(attrs, deps, flows)
  names(nw_elements) <- c("attributes", "dependencies", "flows")

  return(nw_elements)
}
