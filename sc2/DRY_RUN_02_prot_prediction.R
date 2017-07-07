path <- "/"

# load saved models
load(paste0(path,"model_storage/SAVE_WEIGHT_HGSC_ALL_PROT_RNA_microarray_fold10_ite10.Rdata"))

# take common patients
common_patient <- intersect(colnames(HGSC_prot_EVAL),colnames(HGSC_rna_EVAL))
HGSC_prot_EVAL <- HGSC_prot_EVAL[ ,common_patient] ; HGSC_rna_EVAL <- HGSC_rna_EVAL[ ,common_patient]

# take common proteins and common predictors
common_protein <- intersect(rownames(weight), rownames(HGSC_prot_EVAL))
weight <- weight[common_protein, ]
HGSC_prot_EVAL <- HGSC_prot_EVAL[ common_protein , ]

common_feature <- intersect(colnames(weight), rownames(HGSC_rna_EVAL))
weight <- weight[ , common_feature]
HGSC_rna_EVAL <- HGSC_rna_EVAL[ common_feature , ]

# matrix multiplication to make the prediction
weight <- as.matrix(weight) ; HGSC_rna_EVAL <- as.matrix(HGSC_rna_EVAL)
prediction_ovarian <- weight %*% HGSC_rna_EVAL

# save the prediction matrix
write.table(prediction_ovarian, file = paste0(path,"output/predictions.tsv"), sep="\t",quote = F)

