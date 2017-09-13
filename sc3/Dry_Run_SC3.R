path <- "/"

# load package and functions
library(randomForest)
predictRF <- function(model,newx) {
  return(predict(model,newdata=newx,type="response"))
}

# load saved models
load(paste0(path,"model_storage/Model_ALL.rda"))

# load testing data, to check data name go to this page: https://www.synapse.org/#!Synapse:syn8228304/wiki/448379
features  <- read.csv(paste0(path,"evaluation_data/prospective_ova_pro.txt"), row.names= 1, sep="\t", check.names = F )

# select features used in trained model
features<-features[match(protein.subset,rownames(features)), ]
rownames(features) <- NULL

prediction <- c()
for(i in 1:length(out.new)) {
  fit <- out.new[[i]]
  test_pred <- predictRF(fit, t(features) )
  prediction <- rbind(prediction, test_pred)
}
rownames(prediction) <- phosphoID

# prediction[which(apply(prediction, 1, var) == 0),  ] <- features[ , 1:length(which(apply(prediction, 1, var) == 0)) ]
prediction <- cbind(phosphoID = phosphoID, prediction)

# save the prediction matrix
write.table(prediction, file = paste0(path,"output/predictions.tsv"), sep="\t",row.names=F )
# save the confidence matrix 
write.table(prediction, file = paste0(path,"output/confidence.tsv"), sep="\t" ,row.names=F)
