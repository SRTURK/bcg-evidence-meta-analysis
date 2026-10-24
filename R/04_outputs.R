open_png('forest.png',1700,1250)
par(mar=c(5,5,3,2))
forest(fit,slab=paste(d$author,d$year),atransf=exp,at=log(c(.1,.25,.5,1,2,4)),
 xlab='Tuberculosis risk ratio (BCG / control)',mlab='REML random effects, Hartung-Knapp CI',cex=.88,col='#176B87',header=c('Study','RR [95% CI]'))
title('BCG historical studies: heterogeneous evidence');dev.off()
open_png('funnel.png');funnel(fit,xlab='Log risk ratio',ylab='Standard error',pch=19,col='#176B87');title('Funnel plot: descriptive, not a publication-bias verdict');dev.off()
open_png('leave_one_out.png',1500,950)
par(mar=c(5,7,3,2));plot(loo$RR,seq_len(nrow(loo)),log='x',xlim=range(c(loo$ci_low,loo$ci_high,1)),yaxt='n',pch=19,col='#176B87',xlab='Pooled risk ratio after omitting one study',ylab='')
segments(loo$ci_low,seq_len(nrow(loo)),loo$ci_high,seq_len(nrow(loo)),col='#176B87');axis(2,at=seq_len(nrow(loo)),labels=paste('Omit trial',loo$omitted_trial),las=1);abline(v=1,lty=2);title('Leave-one-out sensitivity');dev.off()
write_report('BCG历史研究：可复现的荟萃分析',
 '对metadat公开汇总的13项研究进行统计复核。不是新完成的系统综述，未独立执行文献检索、双人筛选、全文数据提取或正式偏倚风险评估。',
 list(
 list(title='1. 研究集和效应定义',text=sprintf('13项研究共报告%d个组别参与者计数。结局为各研究随访窗口内结核事件，随访长度与人群不同；计算风险比而非发生率比。所有四格表计数均大于0，本数据不使用连续性校正。部分研究为交替/系统分配，不能统称13项随机对照试验。',sum(d$nt+d$nc)),table=as.data.frame(table(allocation=d$alloc))),
 list(title='2. 随机效应与森林图',text='先在log(RR)尺度按方差加权，REML估计研究间方差；Hartung-Knapp调整合并均值区间。CI针对平均真实效应，预测区间针对相似研究的真实效应，不是个体治疗效果。异质性明显时，不能把合并RR直接推广到所有地区。',table=pooled,image='forest.png'),
 list(title='3. 稳健性检查',text='同时报告DL方差估计、随机分配研究子集和逐研究剔除。随机分配标签不是完整偏倚风险评级；模型之间的差异不通过挑选显著结果解决。',table=sensitivity,image='leave_one_out.png'),
 list(title='4. 探索性异质性分析',text='以绝对纬度每10度为单一研究层面协变量。研究层面关联存在生态偏差和混杂，不能据此解释个体生物机制；仅13项研究，探索性结果不等于确证性发现。',table=moderator_table),
 list(title='5. 漏斗图与证据限制',text='漏斗图只作描述，非对称可能来自异质性、研究设计或小样本效应，不能据图断言发表偏倚。该数据是既有历史研究集合，不代表截至2026年的完整最新证据；项目不用于临床疫苗决策。',image='funnel.png')
 ))
