%% Gergely Tarcsay, 2024 Ewell lab. Function to calculate daily performance - total, ctxt A and ctxt B

function Performance = GetPerformance(TrialType, context, all_outcome)

%create table for each trial
Ctxt = context';
Outcome =  all_outcome(:,1); 
Outcome_tbl = table(TrialType, Ctxt, Outcome );

%get ctxt notations
temp = unique(Outcome_tbl.Ctxt);
labels = temp(2:3);


%get # of trial
NTrials(1) = length(find(Outcome_tbl.TrialType == 1));
NTrials(2) = length(find(Outcome_tbl.TrialType== 1 & Outcome_tbl.Ctxt == labels(1)));
NTrials(3) = length(find(Outcome_tbl.TrialType == 1 & Outcome_tbl.Ctxt == labels(2)));

%get # of correct trials
CorrTrials(1) = length(find(Outcome_tbl.TrialType == 1 & Outcome_tbl.Outcome == 0));
CorrTrials(2) = length(find(Outcome_tbl.TrialType== 1 & Outcome_tbl.Ctxt == labels(1) & Outcome_tbl.Outcome == 0));
CorrTrials(3) = length(find(Outcome_tbl.TrialType == 1 & Outcome_tbl.Ctxt == labels(2) & Outcome_tbl.Outcome == 0));

Performance = CorrTrials./NTrials*100;

end