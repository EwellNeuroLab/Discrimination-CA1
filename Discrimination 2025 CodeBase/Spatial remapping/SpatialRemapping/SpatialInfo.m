%% function to calculate spatial information in bit/min

function I_score = SpatialInfo(occupancy, ActivityRate)
%define t - linearized occupancy
t = occupancy(:);

%calculated summed occupany
t_sum = sum(t);
Ncells =length(ActivityRate);
I_score = zeros(Ncells,1);

for c=1:Ncells
    %define lambda - linearized map
    lambda = ActivityRate{c}(:);

    %calculate lambda mean
    lambda_mean = 0;

    %loop on every bin
    for i = 1:length(lambda)
        if isnan(lambda(i))
            continue; % skip non-occupied bins
        end
        p_i = t(i)/t_sum;
        lambda_mean = lambda_mean + p_i*lambda(i);
    end


    % now calculate information content

    for i = 1:length(lambda)
        if isnan(lambda(i))
            continue; % skip non-occupied bins
        end
        p_i = t(i)/t_sum;
        I_score(c) = I_score(c) + ((p_i*lambda(i)/lambda_mean)*(log2(lambda(i)/lambda_mean))); 
    end
end

end

