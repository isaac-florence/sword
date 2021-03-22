#' @name showflow
#'
#' @description
#' Parse repository, document flows, and optionally show flows
#' Uses special code annotation to document flows
#'
#' @param dir Directory/top-level of repository
#'
#' @export
showflow <- function(dir = "./R"){

  dir <- normalizePath(dir, mustWork = T)

  files <- list.files(dir, "\\.R$", recursive = T, full.names = T)

  blocks <- get_blocks(files)

  # return(blocks)
}




#' @name
shfl_blocks <- function(file = NULL){

  contents <- readr::read_lines(file)

  comments <- contents[grep("^#'", contents)]

  com_head_ref <- grep("@name", comments)

  blocks <- list()

  if(length(com_head_ref) == 1)

  for(i in seq_along(com_head_ref)){
    blocks <- c(blocks,
                comments[
                  com_head_ref[i]:com_head_ref[i+1]-1
                  ])
  }

}
