%predefine port
function [error_type, pairs] =  GetWrongChoice(event, reward_ports, Incorrect)
ports= ["W", "SW", "S", "SE", "E", "NE", "N", "NW"];
error_type = [0 0 0];

pairs = strings(length(Incorrect(:,1)),2);
for i = 1:length(Incorrect(:,1))
%% get correct port
msg = string(event{Incorrect(i,2),1});
msg_parsed = split(msg,"_");
correct_port = string(msg_parsed(2));
pairs(i,1) = correct_port;
%% get wrong choice
poke = event{Incorrect(i,2)-1,1};
poke_parsed = split(poke,"_");
wrong_choice =  string(poke_parsed(2));
pairs(i,2) = wrong_choice;
%% get the relative position of the two pokes
correct_idx = find(strcmp(ports, correct_port));
choice_idx =  find(strcmp(ports, wrong_choice));
%% error type 1 - error is the other reward port (context error)
if sum(strcmp(reward_ports, wrong_choice)) == 1
    error_type(1) = error_type(1)+1;

%% error type 2 - error is on the neighbouring port
elseif abs(correct_idx-choice_idx) == 1
    error_type(2) = error_type(2)+1;

%take care of the cyclical property
elseif (choice_idx == 1 && correct_idx == 8) || (choice_idx == 8 && correct_idx == 1)
    error_type(2) = error_type(2)+1;


%% error type 3 - everything else
else
    error_type(3) = error_type(3)+1;
end


%normalize to all errors

end
error_type = error_type./length(Incorrect)*100;

end
