FROM ubuntu

## Installing dependencies

RUN apt-get update && apt-get install r-base aptitude libcurl4-openssl-dev  libxml2-dev libxml2-dev
RUN echo "r <- getOption('repos'); r['CRAN'] <- 'http://cran.us.r-project.org'; options(repos = r);" > ~/.Rprofile
RUN Rscript -e "install.packages('glmnet')"

## Make sure all files that your execution scripts need are in the Docker image

COPY DRY_RUN_02_prot_prediction.R /DRY_RUN_02_prot_prediction.R
COPY score_sc2.sh /score_sc2.sh
COPY model_storage /model_storage
