%% function to get probabilities regarding running toward ports

function [ProbReward, ProbNReward] =  GetProbsPorts(Prob, RZ_ID)

    ProbReward = zeros(length(Prob.To),3); %to, away, neutral
    ProbNReward = zeros(length(Prob.To),3);
    
    
    for i = 1:length(Prob.To)
        ProbReward(i,1)  = Prob.To(i,RZ_ID(i));
        ProbReward(i,2)  = Prob.Away(i,RZ_ID(i));
        ProbReward(i,3)  = Prob.Neutral(i,RZ_ID(i));
    
        idx = setxor([1 2],RZ_ID(i));
        ProbNReward(i,1)  = Prob.To(i,idx);
        ProbNReward(i,2)  = Prob.Away(i,idx);
        ProbNReward(i,3)  = Prob.Neutral(i,idx);
    end

end