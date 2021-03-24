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
    cli::cli_alert_warning("No showflow title provided. Default to 'showflow'")
  }

  ## flow parts
  attrs <- attrs %>%
    dplyr::filter(is.na(title)) %>%
    dplyr::select(-title, -description)

  ## relies & uses dependencies
  deps <- attrs %>%
    dplyr::select(block, relies, uses) %>%
    tidyr::separate(relies, c("relies_a", "relies_b", "relies_c"), sep = " ", fill = "right") %>%
    tidyr::separate(uses, c("uses_a", "uses_b", "uses_c"), sep = " ", fill = "right") %>%
    tidyr::pivot_longer(c(uses_a, uses_b, uses_c, relies_a, relies_b, relies_c), names_to = "from", values_to = "from_type") %>%
    dplyr::filter(!is.na(from_type)) %>%
    dplyr::mutate(from = gsub("_\\D", "", from))

  ## warning
  if(nrow(deps) < 3){
    cli::cli_alert_warning("Few dependencies found. Is showflow markup complete?")
  }

  attrs <- attrs %>%
    dplyr::select(-relies, -uses)

  ## output
  nw_elements <- list(attrs, deps, flows)
  names(nw_elements) <- c("attributes", "dependencies", "flows")

  return(nw_elements)

}
