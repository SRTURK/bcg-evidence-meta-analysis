summarize_fit <- function(f,label) {
 pr<-predict(f,transf=exp)
 data.frame(analysis=label,k=f$k,RR=pr$pred,ci_low=pr$ci.lb,ci_high=pr$ci.ub,tau2=f$tau2,I2=f$I2)
}
dl <- rma(yi,vi,data=d,method='DL',test='knha')
random_only <- rma(yi,vi,data=d[d$alloc=='random',],method='REML',test='knha')
sensitivity <- rbind(summarize_fit(fit,'All studies REML / KH'),summarize_fit(dl,'All studies DL / KH'),summarize_fit(random_only,'Random allocation subset REML / KH'))
save_table(sensitivity,'sensitivity')
loo <- do.call(rbind,lapply(seq_len(nrow(d)),function(i){
 f<-rma(yi,vi,data=d[-i,],method='REML',test='knha')
 cbind(omitted_trial=d$trial[i],summarize_fit(f,paste('Omit',d$author[i],d$year[i])))
}))
save_table(loo,'leave_one_out')
check('13 leave-one-out fits',nrow(loo)==13&&all(loo$k==12))
# One pre-declared exploratory study-level moderator; no causal interpretation.
moderator <- rma(yi,vi,mods=~I(ablat/10),data=d,method='REML',test='knha')
moderator_table <- data.frame(term=c('Intercept','Absolute latitude +10 degrees'),log_RR=as.numeric(coef(moderator)),
 ci_low=moderator$ci.lb,ci_high=moderator$ci.ub,p=moderator$pval)
save_table(moderator_table,'exploratory_meta_regression')
check('random subset count reconciles',random_only$k==sum(d$alloc=='random'))
print(sensitivity)
