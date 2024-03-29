#' @name get_flows
#' @noRd
#'
#' @param nw_elements a network elements object
#' @param flows vector of flows to retain
#' @importFrom rlang .data
get_flows <- function(nw_elements = NULL,
                      flows = NULL) {
  nw <- igraph::graph_from_data_frame(
    vertices = nw_elements$attributes[, c("id", "label")],
    nw_elements$dependencies[, c("to", "from")],
    directed = T
  )

  nws <- igraph::clusters(nw)

  flow <- tibble::tibble(
    id = names(nws$membership),
    flow_id = nws$membership
  )

  nw_elements$attributes <- nw_elements$attributes %>%
    dplyr::left_join(flow, by = "id") %>%
    dplyr::group_by(.data$flow_id) %>%
    dplyr::mutate(flow = dplyr::first(flow)) %>%
    dplyr::ungroup() %>%
    dplyr::select(-.data$flow_id) %>%
    dplyr::filter(flow %in% flows)

  return(nw_elements)
}
