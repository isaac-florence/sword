
#' @name get_blocks
#' @noRd
#'
#' @param files files to interpret for sword blocks
#'
#' @keywords internal
get_blocks <- function(files = NULL) {
  return_blocks <- list()

  for (i in files) return_blocks <- c(return_blocks, file_blocks(i))

  return(return_blocks)
}




#' @name file_blocks
#' @noRd
#'
#' @param file file to interpret for sword blocks
#'
#' @keywords internal
#'
#' @importFrom readr read_lines
file_blocks <- function(file = NULL) {

  ## each line as element
  contents <- readr::read_lines(file)
  ## short file name
  file_name <- basename(file)
  ## sword comment lines
  comments <- contents[grep("^\\s*#-", contents)]
  ## beginning of each sword comment block
  com_head_ref <- grep("@name", comments)
  com_head_ref <- c(grep("@title", comments), com_head_ref)
  ## init file blocks return
  blocks <- list()

  ## if one block in a file, simple
  if (length(com_head_ref) == 1) {
    blocks <- c(make_block(comments, file_name))

    ## if more than one, some manipulation required
  } else if (length(com_head_ref) > 1) {
    ## add index of end of sword blocks in file
    com_head_ref <- c(com_head_ref, length(comments) + 1)
    ## for each head of sword block
    for (i in 1:(length(com_head_ref) - 1)) {
      ## get block
      block <- comments[com_head_ref[i]:(com_head_ref[i + 1] - 1)]
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
make_block <- function(block = NULL, file_name = NULL, i = 1) {

  ## split into sword tag element heads and body eg name = example, type = load
  block <- gsub("#\\-\\s*", "", unlist(strsplit(paste(block, collapse = " "), "#\\-\\s*@")))

  ## vector of tag heads
  block_head <- sub("(^\\w+)\\s.+", "\\1", block)

  ## vector of cleaned tag bodies
  block_body <- sub("^(\\w+)\\s+", "", block)
  block_body <- sub("\\s*$", "", block_body)

  ## checks
  if ((!"name" %in% block_head | !"type" %in% block_head) & !"title" %in% block_head) {
    stop(sprintf("sword block %s in '%s.R' must have @name and @type elements", i, file_name))
  } else if ("name" %in% block_head & "title" %in% block_head) {
    stop(sprintf("sword block %s in '%s.R' cannot have both a @title and a @name element", i, file_name))
  }

  ## rearrange blocks
  block_head <- c(block_head, "filename")
  block_body <- c(block_body, file_name)

  ## list with tag heads as names
  block <- as.list(block_body, file_name)
  names(block) <- block_head

  ## remove empty blocks
  block <- purrr::keep(block, ~ .x != "")

  ## further checks
  if (!any(grepl("setup|load", block[["type"]])) & !any(grepl("uses|relies", block_head)) & !"title" %in% block_head) {
    stop(sprintf("sword block %s in '%s' is not @type setup or load and so requires @uses or @relies", i, file_name))
  }

  ## put into list for appending with file name and block number
  into_blocks <- list(block)
  if ("name" %in% block_head) {
    names(into_blocks) <- block_body[which(block_head == "name")]
  } else if ("title" %in% block_head) {
    names(into_blocks) <- block_body[which(block_head == "title")]
  }

  return(into_blocks)
}
