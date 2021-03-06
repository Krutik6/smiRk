% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/addPrefix.R
\name{addPrefix}
\alias{addPrefix}
\title{addPrefix}
\usage{
addPrefix(MAE, gene_df, prefixString = '')
}
\arguments{
\item{MAE}{MultiAssayExperiment to store output of addPrefix.
It is recommended to use the MAE object which stores output from startObject.}

\item{gene_df}{Dataframe of mRNA or miR results from differential expression
analysis. Will be stored as an assay within the MAE used in the startObject
function.}

\item{prefixString}{Prefix to be added e.g. "miR" or "mRNA".}
}
\value{
Dataframe which has a specific prefix infront of each column name.
Will be stored as an assay in the input MAE.
}
\description{
Adds 'miR_' or 'mRNA_' genetypes to colnames of dataframes.
Resulting colnames should be in the following naming system:
'genetype_timepoint.resulttype'.
This function is essential for separate analysis of miR-mRNA DE data. If
using the combined analysis, there is no need to use addPrefix.
}
\examples{
data(mm_miR)

data(mm_mRNA)

MAE <- startObject(miR = mm_miR, mRNA = mm_mRNA)

MAE <- addPrefix(MAE = MAE, gene_df = assay(MAE, 1),
                 prefixString = "miR")

MAE <- addPrefix(MAE = MAE, gene_df = assay(MAE, 2),
                 prefixString = "mRNA")
}
