% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/clusterList.R
\name{clusterList}
\alias{clusterList}
\title{clusterList}
\usage{
clusterList(MAE, clusterData, fitCluster, miR_IDs, mRNA_IDs)
}
\arguments{
\item{MAE}{MultiAssayExperiment which will store the results from
createClusters.}

\item{clusterData}{A dataframe which contains cluster-pathway fit scores
and is stored as an assay within the MAE used in the createClusters2 function.}

\item{fitCluster}{Integer from 0-1. How well should genes fit into a
cluster? Default is 0.5.}

\item{miR_IDs}{miR_ensembl or miR_entrez. Use a getIDsMir function to
acquire this. This will be stored as an assay in the MAE used in a getIdsMir
function.}

\item{mRNA_IDs}{mRNA_ensembl or mRNA_entrez. Use a getIDsMrna function to
acquire this. This will be stored as an assay in the MAE used in a getIdsMrna
function.}
}
\value{
A list containing the genes which fit to each cluster.
}
\description{
clusterList will transform clusters created by createClusters2
into lists based on which genes associate most to each cluster. Genes which
associate with a cluster are determined by the fitCluster parameter in the
function.
}
\examples{
library(org.Hs.eg.db)

data(long_data)

miRNA <- long_data[c(1:105),]

mRNA <- long_data[-c(1:105),]

MAE <- startObject(miR = miRNA, mRNA = mRNA)

MAE <- getIdsMir(MAE, assay(MAE, 1), orgDB = org.Hs.eg.db, 'hsa')

MAE <- getIdsMrna(MAE, assay(MAE, 2), mirror = 'useast', 'hsapiens',
                  orgDB = org.Hs.eg.db)

MAE <- combineGenes(MAE, miR_data = assay(MAE, 1),
                    mRNA_data = assay(MAE, 2))

MAE <- createClusters2(MAE = MAE, genetic_data = assay(MAE, 9),
                       noClusters =2)

MAE <- clusterList(MAE = MAE, clusterData = assay(MAE, 11), fitCluster = 0.5,
                   miR_IDs = assay(MAE, 3),
                   mRNA_IDs = assay(MAE, 7))
}
