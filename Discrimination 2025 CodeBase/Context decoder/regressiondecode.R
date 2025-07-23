library(readxl)
library(tibble)
library(lmtest)
library(lmer4)

results<-read_excel("decoder_results_deltas.xlsx",col_types=c("text","text","text","numeric","numeric"))
as_tibble(results)

lmres<-lm(I(D_valid_score-G_valid_score) ~ 1+Cohort,data=results,subset=results$IncludeCells=="All")
coeftest(lmres)
