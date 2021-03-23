
#' @name get_blocks
#' @noRd
#'
#' @param files files to interpret for showflow blocks
#'
#' @keywords internal
get_blocks <- function(files = NULL){

  return_blocks <- list()

  for (i in files) return_blocks <- c(return_blocks, file_blocks(i))

  return(return_blocks)
}




#' @name file_blocks
#' @noRd
#'
#' @param file file to interpret for showflow blocks
#'
#' @keywords internal
#'
#' @importFrom readr read_lines
file_blocks <- function(file = NULL){

  ## each line as element
  contents <- readr::read_lines(file)
  ##short file name
  file_name <- basename(file)
  file_name <- sub("\\.R","", file_name)
  ## show flow comment lines
  comments <- contents[grep("^#-", contents)]
  ## beginning of each show flow comment block
  com_head_ref <- grep("@name", comments)
  ## init file blocks return
  blocks <- list()

  ## if one block in a file, simple
  if(length(com_head_ref) == 1){
    blocks <- c(make_block(comments, file_name))

    ## if more than one, some manipulation required
  } else if(length(com_head_ref) > 1) {
    ## add index of end of showflow blocks in file
    com_head_ref <- c(com_head_ref, length(comments)+1)
    ## for each head of showflow block
    for(i in 1:(length(com_head_ref)-1)){
      ## get block
      block <- comments[com_head_ref[i]:(com_head_ref[i+1]-1)]
      block <- make_block(block, file_name, i)
      ## append to file blocks return
      blocks <- c(blocks, block)
    }
  }
  return(blocks)
}




#' @name make_block
#' @noRd
#'
#' @param block Character vector to be turned into block list
#' @param file_name Character vector of tidied forename
#' @param i value of i if in loop
#'
#' @keywords internal
#'
#' @importFrom purrr keep
make_block <- function(block = NULL, file_name =NULL, i =1){

  ## split into showflow tag element heads and body eg name = example, type = load
  block <- gsub("#\\-\\s*", "", unlist(strsplit(paste(block, collapse = " "), "#\\-\\s*@")))
  ## vector of tag heads
  block_head <- sub("(^\\w+)\\s.+","\\1", block)
  ## vector of cleaned tag bodies
  block_body <- sub("^(\\w+)\\s+","", block)
  block_body <- sub("\\s*$","", block_body)
  ## list with tag heads as names
  block <- as.list(block_body)
  names(block) <- block_head
  ## remove empty blocks
  block <- purrr::keep(block, ~.x != "")
  ## put into list for appending with file name and block number
  into_blocks <- list(block)
  names(into_blocks) <- paste(file_name, i, sep = "_")

  return(into_blocks)
}




#' @name check_blocks
#' @noRd
#'
#' @param blocks blocks object
check_blocks <- function(blocks = NULL){
  ## for each block element
  for(i in names(blocks)){
    ## check elements have both @name and @type
    if(!all(c("name", "type") %in% names(blocks[[i]]))) stop(sprintf("%s requires both @name and @type elements", i))
    ## check non load or setup @type blocks have @use element
    if(!any(c("load", "setup") %in% blocks[[i]][["type"]])){
      if(!c("uses") %in% names(blocks[[i]])){
        stop(sprintf("%s is not type load or setup and so requires @uses element", i))
      }
    }
  }
}




#' @names get_attributes
#' @noRd
#'
#' @param blocks
#'
#' @import tibble enframe
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
