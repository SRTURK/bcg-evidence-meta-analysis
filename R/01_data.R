library(metafor)
raw <- metadat::dat.bcg
input_snapshot(raw,'bcg','metadat')
check('13 studies',nrow(raw)==13,nrow(raw))
check('trial IDs unique',!anyDuplicated(raw$trial))
check('count data complete',!anyNA(raw[c('tpos','tneg','cpos','cneg')]))
check('nonnegative integer counts',all(as.matrix(raw[c('tpos','tneg','cpos','cneg')])>=0&as.matrix(raw[c('tpos','tneg','cpos','cneg')])%%1==0))
check('positive cells no correction needed',all(as.matrix(raw[c('tpos','tneg','cpos','cneg')])>0))
check('allocation labels valid',all(raw$alloc %in% c('random','alternate','systematic')))
d <- escalc(measure='RR',ai=tpos,bi=tneg,ci=cpos,di=cneg,data=raw,add=0)
d$nt <- d$tpos+d$tneg;d$nc<-d$cpos+d$cneg
d$manual_yi <- log((d$tpos/d$nt)/(d$cpos/d$nc))
d$manual_vi <- 1/d$tpos-1/d$nt+1/d$cpos-1/d$nc
check('log RR independently matches escalc',max(abs(d$manual_yi-d$yi))<1e-12)
check('variance independently matches escalc',max(abs(d$manual_vi-d$vi))<1e-12)
d$RR <- exp(d$yi);d$ci_low<-exp(d$yi-qnorm(.975)*sqrt(d$vi));d$ci_high<-exp(d$yi+qnorm(.975)*sqrt(d$vi))
save_table(as.data.frame(d),'study_effects')
save_table(as.data.frame(table(allocation=d$alloc)),'allocation_counts')
cat('Studies:',nrow(d),'reported participants:',sum(d$nt+d$nc),'\n')
