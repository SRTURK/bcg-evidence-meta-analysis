# 数据与来源

来源：`metadat` 1.6-0的`dat.bcg`，13项BCG与结核历史研究汇总，分析包`metafor`5.2-1。[数据维护者说明及原研究书目](https://wviechtb.github.io/metadat/reference/dat.bcg.html)。基础文献集合由该数据包维护；本项目未独立复核全部原始全文。

| 字段 | 含义 |
|---|---|
| trial / author / year | 研究标识、作者、年份 |
| tpos / tneg | 接种组结核事件 / 非事件 |
| cpos / cneg | 对照组结核事件 / 非事件 |
| ablat | 绝对纬度，研究层面特征 |
| alloc | random、alternate或systematic分配 |
| yi / vi | log(RR)及估计方差，由escalc生成并手算校验 |

共7项random、2项alternate、4项systematic。357,347为各研究两组报告人数之和，不声称去重后的跨研究独立患者总数。研究设计、疾病定义和随访差异可能造成异质性。

从安装包导出`data/raw/bcg.csv`并比对MD5；原始快照忽略不上传，衍生效应表用于复核。metadat/metafor许可见各包DESCRIPTION；本项目MIT代码许可不改变数据原始归属。[metafor模型文档](https://wviechtb.github.io/metafor/reference/rma.uni.html)解释REML与knha设置。
