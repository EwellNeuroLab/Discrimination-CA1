%% Function to calculate Pearson's correlation and Fisher's z-score between two maps

function [Pearsons, Fishers] = GetPearsons(mapI,mapII)

[~,~,N_cell] = size(mapI);
Pearsons= zeros(N_cell,1);
Fishers = zeros(N_cell,1);
for i = 1:N_cell
    Pearsons(i) = nancorr(mapI(:,:,i), mapII(:,:,i));
    Fishers(i) = atanh(Pearsons(i));

end
end