#' @useDynLib epicR, .registration=TRUE
#' @importFrom stats lm time
#' @importFrom Rcpp sourceCpp
#' @importFrom Rcpp evalCpp
#' @importFrom graphics barplot legend lines pie plot title
#' @importFrom stats aggregate binomial coefficients glm optim runif confint
#' @importFrom utils packageVersion
#' @importFrom utils write.csv
#' @import ggplot2
#' @import ggthemes
#' @import dplyr
#' @importFrom scales pretty_breaks
#' @import jsonlite
NULL

.onUnload <- function (libpath) {
  library.dynam.unload("epicR", libpath)
}

