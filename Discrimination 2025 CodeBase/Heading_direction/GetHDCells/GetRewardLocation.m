%% Function to get get reward location
function [RZ_XY, RZ_loc]  = GetRewardLocation(XY, event, Correct, context)

    if sum(ismember(context, 'A')) > 0
        context_labels = ["A", "A'"];
        Nrew = 2;
    else
        context_labels = ["B", "B'"];
        Nrew = 1;
        
    end
    RZ_XY = zeros(Nrew,2);
    RZ_loc = strings(1,Nrew);
    for r = 1:Nrew
        trials = find(context == context_labels(r));
        [~, ~, idx] = intersect(trials,Correct(:,1));
        RZ_frames = event{Correct(idx,2),2}+1; 
         RZ_Pos = XY(RZ_frames,:);
        % find and remove outliers (due to misdetecting the animal during reward consumption - unlikely with DLC)
        TF = isoutlier(RZ_Pos);
    
        outl = find(TF(:,1) == 1 | TF(:,2) == 1);
        RZ_Pos(outl,:) = [];
    
        RZ_XY(r,:) = mean(RZ_Pos);


        % now get reward location (as text)
         str = split(event{Correct(idx(1),2),1},"_");
        letters = regexp(str{2}, '[N E S W]','match');
        RZ_loc(r) = "";
        for l = 1:length(letters)
            RZ_loc(r) =strcat(RZ_loc(r), char(letters(l))); 
        end
       

    end
end