#' @name get_visnetwork
#'
#' @noRd
#'
#' @param nw_elements List of interpreted sword blocks' attributes
get_visnetwork <- function(nw_elements = NULL){

  edges <- nw_elements$dependencies %>%
    dplyr::mutate(dashes = dplyr::if_else(dep_type == "uses", FALSE, TRUE))

  nodes <- nw_elements$attributes %>%
    dplyr::mutate(shape = "icon",
                  icon.code = dplyr::case_when(
                    type == "load"     ~ "f1c0",
                    type == "load_file"~ "f15b",
                    type == "load_db"  ~ "f1c0",
                    type == "save"     ~ "f0ab",
                    type == "save_file"~ "f15b",
                    type == "save_db"  ~ "f1c0",
                    type == "process"  ~ "f111",
                    type == "cloud"    ~ "f0c2",
                    type == "setup"    ~ "f0c8",
                    type == "if"       ~ "f059",
                    type == "loop"     ~ "f01e"))

  visnetwork <- visNetwork::visNetwork(
    nodes, edges,
    main = list(text = paste(nw_elements$flows$title),
                style = "font-family:Georgia;font-weight:bold;font-size:20px;text-align:center;"),
    footer = list(text = paste(nw_elements$flows$description),
                  style = "font-family:serif;font-size:16px;text-align:left;"),
    width = "80%", height = "800px"
  ) %>%
    visNetwork::visEdges(
      arrows = "to", width = 2,
      smooth = list(type = "cubicBezier",
                    forceDirection = "horizontal")
    ) %>%
    visNetwork::visHierarchicalLayout(direction = "LR", sortMethod = "directed") %>%
    visNetwork::visOptions(highlightNearest = FALSE) %>%
    visNetwork::addFontAwesome()
}
