%% function to get reference point, Gergely Tarcsay, 2025.
% First the position is rotated based on difference of the expected and
% observed position of the mouse when at getting the reward (head position)
% Next the reference point is taken as [0 20] - northern corner
function [RefPoint,XY, theta, Rew] =GetReferencePoint(XY,event)

%% very first thing -  position data has to be flipped along Y axis
XY(:,2) = XY(:,2)*(-1);

[TrialStart, TrialStop, ZoneTriggered, context] = ParseTrials(event);
[Correct, ~, ~, ~, ~, ~, ~] = GetTrialOutcome(event,TrialStart,TrialStop,ZoneTriggered);
[RZ_XY, RZ_loc] = GetRewardLocation(XY, event, Correct, context); % reward location(s)

%get the angle that the first reward location should face (measured from center of maze)
n=1;
alpha_ports = [22.5 67.5 112.5 157.5 -22.5 -67.5 -112.5 -157.5];
labels = ["E", "NE", "N", "NW", "SE", "S", "SW", "W"];
expected_angle = alpha_ports(strcmp(labels, RZ_loc(n)));

%now calculate the actual angle measured from [0 0] and calculate the
%rotation angle
observed_angle = atan2d(RZ_XY(n,2),RZ_XY(n,1));
theta = (expected_angle-observed_angle)*(-1);

%rotate position data
R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
for i = 1:length(XY(:,1))
    XY(i,:) = XY(i,:)*R;
end

%recalculate reward location
[RZ_XY, ~] = GetRewardLocation(XY, event, Correct, context);

RefPoint = [0 20];
Rew.Loc = RZ_XY;
Rew.Label = RZ_loc;

% calculate angle of reward with respect to reference point
Nrew = length(Rew.Loc(:,1));
for r=  1:Nrew
   Rew.Alpha(r) = rad2deg(mod((angle(RefPoint(1)+1j*RefPoint(2))-angle(Rew.Loc(r,1)+1j*Rew.Loc(r,2)))+pi,2*pi)-pi);
end

end