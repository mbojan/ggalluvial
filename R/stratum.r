#' Variable axes and strata
#' 
#' \code{stat_stratum} calculates the centers of the levels at each axis. 
#' \code{geom_stratum} stacks a box for each level of a variable at its axis.
#' 
#' @name stratum
#' @import ggplot2
#' @seealso \code{\link{alluvium}} for inter-axis flows and
#'   \code{\link{ggalluvial}} for a shortcut method.
#' @usage NULL
#' @export
#' @inheritParams layer
#' @param axis_width The width of each variable axis, as a proportion of the 
#'   separation between axes.
#' @example inst/examples/stratum.r
StatStratum <- ggproto(
    "StatStratum", Stat,
    setup_data = function(data, params) {
        if (is.null(data$weight)) data$weight <- rep(1, nrow(data))
        data <- aggregate(
            formula = as.formula(paste("weight ~",
                                       paste(setdiff(names(data), "weight"),
                                             collapse = "+"))),
            data = data,
            FUN = sum
        )
        axis_ind <- get_axes(names(data))
        # stack axis-aggregated data with cumulative frequencies
        res_data <- do.call(rbind, lapply(unique(data$PANEL), function(p) {
            p_data <- subset(data, PANEL == p)
            do.call(rbind, lapply(1:length(axis_ind), function(i) {
                agg <- aggregate(x = p_data$weight, by = p_data[axis_ind[i]],
                                 FUN = sum)
                names(agg) <- c("label", "weight")
                cbind(pos = i, agg, cumweight = cumsum(agg$weight), PANEL = p)
            }))
        }))
        # add group
        cbind(res_data, group = 1:nrow(res_data))
    },
    compute_group = function(data, scales,
                             axis_width = 1/3) {
        rownames(data) <- NULL
        rect_data <- data.frame(x = data$pos,
                                y = (data$cumweight - data$weight / 2),
                                width = axis_width)
        data.frame(data, rect_data)
    }
)

#' @rdname alluvium
#' @usage NULL
#' @export
stat_stratum <- function(mapping = NULL, data = NULL, geom = "stratum",
                          na.rm = FALSE, show.legend = NA,
                          inherit.aes = TRUE, ...) {
    layer(
        stat = StatStratum, data = data, mapping = mapping, geom = geom,
        position = "identity", show.legend = show.legend,
        inherit.aes = inherit.aes,
        params = list(na.rm = na.rm, ...)
    )
}

#' @rdname alluvium
#' @usage NULL
#' @export
GeomStratum <- ggproto(
    "GeomStratum", GeomRect,
    default_aes = aes(size = .5, linetype = 1,
                      colour = "black", fill = "white", alpha = 1),
    setup_data = function(data, params) {
        transform(data,
                  xmin = x - width / 2, xmax = x + width / 2,
                  ymin = y - weight / 2, ymax = y + weight / 2)
    },
    draw_key = draw_key_polygon
)

#' @rdname alluvium
#' @usage NULL
#' @export
geom_stratum <- function(mapping = NULL, data = NULL, stat = "stratum",
                          na.rm = FALSE, show.legend = NA, inherit.aes = TRUE,
                          ...) {
    layer(
        geom = GeomStratum, mapping = mapping, data = data, stat = stat,
        position = "identity", show.legend = show.legend,
        inherit.aes = inherit.aes, params = list(na.rm = na.rm, ...)
    )
}
