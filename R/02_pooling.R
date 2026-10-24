fit <- rma(yi,vi,data=d,method=config$method,test=config$inference)
pred <- predict(fit,transf=exp)
pooled <- data.frame(studies=fit$k,RR=pred$pred,ci_low=pred$ci.lb,ci_high=pred$ci.ub,
 prediction_low=pred$pi.lb,prediction_high=pred$pi.ub,tau2=fit$tau2,I2=fit$I2,Q=fit$QE,Q_p=fit$QEp,p=fit$pval)
save_table(pooled,'pooled_effect')
# Independent inverse-variance mean at the fitted tau^2; checks parameter interpretation.
w <- 1/(d$vi+fit$tau2)
check('pooled mean matches inverse variance formula',abs(as.numeric(coef(fit))-sum(w*d$yi)/sum(w))<1e-10)
d$weight_percent <- 100*w/sum(w)
check('weights sum to 100',abs(sum(d$weight_percent)-100)<1e-10)
check('weights match package',max(abs(d$weight_percent-as.numeric(weights(fit))))<1e-8)
save_table(d[c('trial','author','year','alloc','RR','ci_low','ci_high','weight_percent')],'forest_table')
check('pooled RR within interval',pooled$ci_low<pooled$RR&&pooled$RR<pooled$ci_high)
print(pooled)
