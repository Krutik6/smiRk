#' @title makeMapp
#' @description Creates a dataframe which can be imported into pathvisio by use
#' of the the MAPP plugin. This will add the filtered miRs to the wikipathway of
#' interest on pathvisio. Follow instructions found in the vignette which show
#' how to save this file and further instructions found in the issues section
#' of the TimiRGeN gihub https://github.com/Krutik6/TimiRGeN/issues/2.
#' @param MAE MultiAssayExperiment to store the output of makeMapp. It
#' is recommended to use the same MAE which stores the output from
#' matrixFilter.
#' @param filt_df Dataframe of mined miR-mRNA interactions. This is output
#' of matrixFilter. It should be stored as an assay in the MAE used in the
#' matrixFilter function.
#' @param miR_IDs_adj Dataframes with adjusted gene IDs to account for -5p and
#' -3p specific miRs. miR_adjusted_entrez or miR_adjusted_ensembl. Should be
#' found as assays within the MAE used a getIdsMir function.
#' @param dataType String which represents the gene ID used in this analysis.
#' Either "En" (ensembl data) or "L" (entrez data).
#' @return A dataframe containing microRNAs and adjusted gene IDs which can be
#' saved as a text file to be imported into pathvisio via the MAPPapp. Output
#' will be saved as an assay in the input MAE.
#' @export
#' @usage makeMapp(MAE, filt_df, miR_IDs_adj, dataType = '')
#' @examples
#' library(org.Mm.eg.db)
#'
#' miR <- mm_miR[1:50,]
#'
#' mRNA <- mm_mRNA[1:100,]
#'
#' MAE <- startObject(miR = mm_miR, mRNA = mm_mRNA)
#'
#' MAE <- getIdsMir(MAE, assay(MAE, 1), orgDB = org.Mm.eg.db, 'mmu')
#'
#' MAE <- getIdsMrna(MAE, assay(MAE, 2), "useast", 'mmusculus', orgDB = org.Mm.eg.db)
#'
#' Filt_df <- data.frame(row.names = c("mmu-miR-320-3p:Acss1",
#'                                      "mmu-miR-27a-3p:Odc1"),
#'                       avecor = c(-0.9191653, 0.7826041),
#'                       miR = c("mmu-miR-320-3p", "mmu-miR-27a-3p"),
#'                       mRNA = c("Acss1", "Odc1"),
#'                       miR_Entrez = c(NA, NA),
#'                       mRNA_Entrez = c(68738, 18263),
#'                       TargetScan = c(1, 0),
#'                       miRDB = c(0, 0),
#'                       Predicted_Interactions = c(1, 0),
#'                       miRTarBase = c(0, 1),
#'                       Pred_Fun = c(1, 1))
#'
#' MAE <- makeMapp(MAE, filt_df = Filt_df, miR_IDs_adj = assay(MAE, 5),
#'                 dataType = 'L')
makeMapp <- function(MAE, filt_df, miR_IDs_adj, dataType){

    if (missing(MAE)) stop('MAE is missing. Add MAE. This will store the output of makeMapp. Please use matrixFilter first.')

    if (missing(filt_df)) stop('filt_df is missing. Add dataframe of filtered miR-mRNA interactions. Please use the matrixFilter function first. Output of matrixFilter should be stored as an assay within the MAE used in the matrixFilter function.')

    if (missing(miR_IDs_adj)) stop('miR_IDs_adj is missing. Add adjusted miR gene ID data. Please use the getIdsMir function first. Output of a getIdsMir function should be stored as an assay within the MAE used in the getIdsMir function.')

    if (missing(dataType)) stop('dataType is missing. Add a string. "En" for ensembl or "L" for entrez.')

    # Merge filtered data frame of interactions and adjusted miR IDs
    X <- merge(x = filt_df, y = miR_IDs_adj, by.x = "miR", by.y = "GENENAME")

    # For entrezgene IDs
    if (dataType == 'L') {

        MAPPdata <- data.frame("GENENAME" = X$miR, "ENTREZ" = X$ID,
                               "code" = 'L', ord = X$mRNA)
    # For ensmbl gene IDs
    } else if(dataType == 'En'){

        MAPPdata <- data.frame("GENENAME" = X$miR, "ENSEMBL" = X$ID,
                               "code" = 'En', ord = X$mRNA)

    } else {print('Enter L or En for data type of interest')}

    MAPPdata <- MAPPdata[order(MAPPdata$ord),]

    MAPPdata$ord <- NULL

    MAE2 <- suppressWarnings(suppressMessages(MultiAssayExperiment(list('MAPPdata' = MAPPdata))))

    MAE <- suppressWarnings(c(MAE, MAE2))

return(MAE)
}
