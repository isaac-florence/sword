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

