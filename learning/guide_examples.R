# Extracted from the tutorial; run from repository root.
if (.Platform$OS.type == 'windows') invisible(Sys.setlocale('LC_CTYPE','English_United States.utf8'))
if(dir.exists('.Rlibrary')) .libPaths(c(normalizePath('.Rlibrary'),.libPaths()))
options(stringsAsFactors=FALSE)
args <- character()
out <- 'learning/my_output'
dir.create(out,recursive=TRUE,showWarnings=FALSE)
source('config.R',encoding='UTF-8')
source('R/helpers.R',encoding='UTF-8')
set.seed(config$seed)
library(metafor)


preview <- metadat::dat.bcg
print(preview)
table(preview$alloc)


a <- 10; b <- 90; c <- 20; dd <- 80
toy_rr <- (a/(a+b))/(c/(c+dd))
toy_logrr <- log(toy_rr)
toy_var <- 1/a-1/(a+b)+1/c-1/(c+dd)
print(c(RR=toy_rr,logRR=toy_logrr,variance=toy_var))


source('R/01_data.R',encoding='UTF-8')
print(d[c('trial','tpos','tneg','cpos','cneg','yi','vi','RR')])
stopifnot(max(abs(d$manual_yi-d$yi))<1e-12)


my_fit <- rma(yi,vi,data=d,method='REML',test='knha')
print(my_fit)
print(predict(my_fit,transf=exp))


source('R/02_pooling.R',encoding='UTF-8')
my_weights <- 1/(d$vi+fit$tau2)
my_pooled_logrr <- sum(my_weights*d$yi)/sum(my_weights)
print(exp(my_pooled_logrr))
print(sum(d$weight_percent))


print(pooled[c('tau2','I2','Q','Q_p','prediction_low','prediction_high')])


source('R/03_sensitivity.R',encoding='UTF-8')
print(sensitivity)
print(loo)


print(moderator_table)


source('R/04_outputs.R',encoding='UTF-8')
finish(config$packages)
