#' EDGE scores of species
#'
#' \code{myedge} provides Evolutionarily Distinct and Globally Endangered (EDGE)
#' species scores and rankings based on Jetz et al. (2014).
#'
#' EDGE scores are calculated from a species evolutionary distinctiveness (ED)
#' and Global IUCN Red List status (GE) using the following equation:
#'
#' \deqn{EDGE = ln(ED + 1) + GE * ln(2)}
#'
#' Where ED is defined as species-level measure representing the weighted sum of
#' the branch lengths along the path from the root of a tree to a given
#' tip/species, and GE is a rank scalar ranging from 0 (IUCN Red List
#' designation “Least Concern”) to 4 (IUCN Red List designation “Critically
#' Endangered”). See Jetz et al. (2014) for more details.
#'
#' It's important to note a few issues with the EDGE metric and the values
#' provided by this function. The EDGE score can be strongly influenced by the
#' taxonomy being used. This is particularly important if species with
#' relatively high ED values are considered multiple species by other authors;
#' this can considerably change evolutionary distinctiveness estimates.




myedge <- function(mydata, edge.cutoff = 9999) {

  data(edge)

  spp <- select(mydata, ScientificName, CommanName) %>%
    group_by(ScientificName) %>%
    summarise(n = n(), CommanName = unique(CommanName)) %>%
    select(ScientificName, CommanName)

  left_join(spp, edge, by = "ScientificName") %>%
    select(-CommmanName.y) %>%
    rename(CommanName = CommanName.x) %>%
    arrange(-EDGE.Score) %>%
    filter(EDGE.Rank <= edge.cutoff)
}
