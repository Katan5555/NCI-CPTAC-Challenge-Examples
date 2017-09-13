
# path <- "/Users/miyang/Documents/RWTH_Aachen/DREAM_CPTAC/DOCKER_STORAGE/docker_R_sc2/"
path <- "/"

# load package and functions
library(glmnet)
predictEN <- function(model, lambda, feat) {
  return(predict(model,type="response",newx=feat)[,model$lambda == lambda])
}

# load saved models
load(paste0(path,"model_storage/SAVE_MODEL_ElasticNet_HGSC_ALL_PROT_microarray_fold5_ite10.Rdata"))

# load testing data
HGSC_rna_EVAL  <- read.csv(paste0(path,"evaluation_data/prospective_ova_rna_seq_sort_common_gene_15121.txt"), row.names= 1, sep="\t", check.names = F )
features <- t(HGSC_rna_EVAL)

prediction <- c()
for(i in 1:length(model)) {
  fit <- model[[i]]
  test_pred <- predictEN(fit,fit$lambda, features ) 
  prediction <- rbind(prediction, test_pred)
}
rownames(prediction) <- names(model)

prediction[which(apply(prediction, 1, var) == 0),  ] <- features[names(which(apply(prediction, 1, var) == 0)), ]
prediction <- cbind(proteinID = rownames(prediction),prediction)

# save the prediction matrix
write.table(prediction, file = paste0(path,"output/predictions.tsv"), sep="\t",row.names=F )

# save the confidence matrix 
write.table(prediction, file = paste0(path,"output/confidence.tsv"), sep="\t",row.names=F )

