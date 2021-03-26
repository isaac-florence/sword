
get_visnetwork <- function(nw_elements = NULL){

  edges <- nw_elements$dependencies %>%
    dplyr::mutate(dashes = dplyr::if_else(dep_type == "uses", FALSE, TRUE))

  nodes <- nw_elements$attributes %>%
    dplyr::mutate(shape = "icon",
                  icon.code = dplyr::case_when(
                    type == "load"    ~ "f1c0",
                    type == "save"    ~ "f0ab",
                    type == "process" ~ "f111",
                    type == "setup"   ~ "f0c8"))

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
