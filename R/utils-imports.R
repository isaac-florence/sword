#' Pipe operator
#'
#' See \code{magrittr::\link[magrittr:pipe]{\%>\%}} for details.
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
NULL

#' Tee Pipe operator
#'
#' See \code{magrittr::\link[magrittr:tee]{\%T>\%}} for details.
#'
#' @details The tee pipe works like %>%, except the return value is lhs itself, and not the result of rhs function/expression.
#' @name %T>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %T>%
#' @usage lhs \%T>\% rhs
NULL
