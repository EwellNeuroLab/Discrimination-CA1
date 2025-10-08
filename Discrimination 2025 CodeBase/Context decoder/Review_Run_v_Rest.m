% compare run/rest between discrimination and grouping

mouseID= [ "M119" "M120" "M292" "M319" "M231" "M314" "M316" "M318"];

RestRatio = zeros(length(mouseID),2);
medianSpeed = zeros(length(mouseID),2);

for i =1:length(mouseID)
    load(strcat("G:\Decoder input\",mouseID(i),"\trained\CaActivity.mat"), "States", "v")
    RestRatio(i,1) = sum(States.Run==0)/length(States.Run)*100;  
    medianSpeed(i,1) = median(v(v>2));
    clear States v

    load(strcat("G:\Decoder input\",mouseID(i),"\grouping\CaActivity.mat"), "States", "v")
    RestRatio(i,2) = sum(States.Run==0)/length(States.Run)*100;  
    medianSpeed(i,2) = median(v(v>2));
    clear States v
end

%%
figure
tiledlayout(1,2)
nexttile;
hold on

plot(ones(8,1), RestRatio(:,1), 'go', MarkerFaceColor='g')
plot(ones(8,1)+0.5, RestRatio(:,2), 'bo', MarkerFaceColor='b')

for i = 1:8
    plot([1 1.5], [RestRatio(i,1) RestRatio(i,2)], 'k-')
end
ylim([40 100])
xlim([.5 2])
ylabel("Time spent resting (%)")
xticks([1 1.5])
xticklabels({"Discrimination", "Generalization"})

nexttile;
hold on

plot(ones(8,1), medianSpeed(:,1), 'go', MarkerFaceColor='g')
plot(ones(8,1)+0.5, medianSpeed(:,2), 'bo', MarkerFaceColor='b')

for i = 1:8
    plot([1 1.5], [medianSpeed(i,1) medianSpeed(i,2)], 'k-')
end
ylim([0 20])
xlim([.5 2])
xticks([1 1.5])
xticklabels({"Discrimination", "Generalization"})
ylabel("Median speed (cm/s)")

%% mean difference of median speed 
spDiff = medianSpeed(:,1) - medianSpeed(:,2);

RestDiff = RestRatio(:,1) - RestRatio(:,2);