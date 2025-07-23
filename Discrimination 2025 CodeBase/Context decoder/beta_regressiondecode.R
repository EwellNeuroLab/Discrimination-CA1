library(readxl)
library(tibble)
library(lmtest)

results<-read_excel("decoder_results_deltas.xlsx",col_types=c("text","text","text","numeric","numeric"))
as_tibble(results)

lmres<-lm(D_valid_score-G_valid_score ~ 1,data=results,subset=results$IncludeCells=="All")
coeftest(lmres)
