#' as.ggplot
#'
#' Converts a MAgPIE object or a list of MAgPIE objects into a dataframe usable
#' for ggplot
#'
#'
#' @usage as.ggplot(x,scenario="default",asDate=T,rev=F,useDimNames=FALSE)
#' @param x MAgPIE object or list of MAgPIE objects. For a list of MAgPIE
#' objects the name of the list entry (has to be character) is used as scenario
#' name.
#' @param scenario position of the entry in the third dimension that contains the scenario name
#' (only if the scenario name is stored in the third dimension) or NULL
#' (automatic detection)
#' @param asDate Format the years as date (TRUE) or keep as is (FALSE);
#' deprecated (only kept for compatibility with older scripts)
#' @param rev reverse legend order (TRUE) or not (FALSE)
#' @param useDimNames Use dim names of 3rd dimension instead Data1, Data2,
#' Data3, Data4; works only if x is a MAgPIE object (no list) and scenario=NULL
#' @return Dataframe usable for ggplot
#' @author Ankit Saha, Miodrag Stevanovic
#' @examples
#'
#' \dontrun{
#' as.ggplot(croparea(gdx))}

#' @export
#' @importFrom magclass mstools magpiesets
#' @importFrom dplyr tidyr

as.ggplot <- function(x,scenario="default",asDate=T,rev=F,useDimNames=FALSE) {
  #require("dplyr", quietly = TRUE)
  #require("tidyr", quietly = TRUE)


if(is.numeric(scenario)) {
  temp <- x
  x <- list()
  for(scen in getItems(temp, dim= scenario)) {
    x[[scen]] <- collapseDim(temp[,,scen], dim = scenario)
  }
}


if (!is.list(x) & !is.null(scenario)) {
  temp <- x
  x <- list()
  x[[scenario]] <- temp
}

if (is.list(x)) {
  scenario_order <- names(x)
  if (hasCoords(x[[1]])) {
    region_order <- getItems(x[[1]], dim=1.3)
  } else region_order <- getItems(x, dim=1)
  data_dims <- NULL
} else {
  scenario_order <- getNames(x,dim=1)

  if(hasCoords(x)) {
    region_order <- getItems(x, dim=1.3)
  }
  else region_order <- getItems(x, dim=1)

  data_dims <- getItems(x, dim=3, split=TRUE)
  data_dims <- unlist(data_dims)
  capped <- grep("^[A-Z]", data_dims, invert = TRUE)
  substr(data_dims[capped], 1, 1) <- toupper(substr(data_dims[capped], 1, 1))
}


if (rev) scenario_order <- rev(scenario_order)

if (all(unlist(lapply(x,function(x) hasCoords(x))))) {

  if (!all(unlist(lapply(lapply(x,function(x) hasCoords(x)),identical,hasCoords(x[[1]])))))
    stop("Inconsistent coordinates")
} else if (any(unlist(lapply(x,function(x) hasCoords(x))))) {
  stop("Missing coordinates for some MAgPIE objects")
}

if (is.list(x)) x <- lapply(x,as.data.frame, rev = 2) else x <- as.data.frame(x)

if(is.numeric(scenario)) {
x <- bind_rows(
  lapply(x, \(d) mutate(d, across(where(is.factor), as.character))),
  .id = "scenario"
)
}

if(!is.numeric(scenario)) {
  x <- x$default

  if (!"scenario" %in% names(x)) {
    x <- x %>% mutate(scenario = "default")
  }

  x <- x %>%
    select(
      Scenario = scenario,
      Lon = x,
      Lat = y,
      Region = iso,
      Year = t,
      Data1 = kcr,
      Data2 = w,
      Value = .value
    )
} else {
  x <- x %>%
    select(
      Scenario = scenario,
      Lon = x,
      Lat = y,
      Region = iso,
      Year = t,
      Data1 = kcr,
      Data2 = w,
      Value = .value
    )
}
}
