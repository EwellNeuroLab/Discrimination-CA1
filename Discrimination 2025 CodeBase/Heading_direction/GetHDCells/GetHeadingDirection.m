%% function to calculate heading direction relative to the most northern corner of the maze
function [HDir, Rew, RefPoint, rotXY, theta] = GetHeadingDirection(XY, event, filtSize)

[RefPoint, rotXY, theta, Rew] = GetReferencePoint(XY,event);

% calculate heading-direction
filt_XY(:,1) = movmean(rotXY(:,1), filtSize);
filt_XY(:,2) = movmean(rotXY(:,2), filtSize);
z = [0; diff(filt_XY(:,1)) ] + 1i* [0; diff(filt_XY(:,2))];
H = angle(z); % on the interval of [-pi; +pi]

%calculate angle between reference point and mouse
z = (RefPoint(1)- filt_XY(:,1)) + 1i* (RefPoint(2)-filt_XY(:,2));
alpha = angle(z);

%now get relative position
HDir = rad2deg(mod((alpha-H)+pi,2*pi)-pi); %[-pi; +pi]

end


% %show example of rotation
% figure
% tiledlayout(1,2)
% 
% nexttile;
% plot(XY(:,1), XY(:,2), 'b.')
% box off
% axis square
% hold on
% xline(0,"r--", LineWidth=2)
% yline(0,"r--", LineWidth=2)
% title("Original orientation")
% 
% nexttile;
% plot(rotXY(:,1), rotXY(:,2), 'b.')
% box off
% axis square
% hold on
% 
% 
% for ang = 0:45:360
%     plot([0 20*cosd(ang)],[0 20*sind(ang)], "k-", LineWidth=2)
% end
% 
% for i = 1:2
%     plot(Rew.Loc(i,1), Rew.Loc(i,2), 'ro', "MarkerFaceColor","r")
% end
% plot(RefPoint(1), RefPoint(2), "mp", "MarkerFaceColor","m", "MarkerSize",8)
% title("Rotated orientation")

% %show examples
% example_ang = -pi:deg2rad(45):pi;
% L = 20;
% figure
% tiledlayout("flow")
% for i =1:length(example_ang)
%      [~,idx]= min(abs(gamma-example_ang(i)));
%      nexttile;
%      hold on
%      plot(filt_XY(idx,1), filt_XY(idx,2), 'k.')
%      x2 = filt_XY(idx,1)+L*cos(H(idx));
%      y2 = filt_XY(idx,2)+L*sin(H(idx));
% 
% 
%      plot([filt_XY(idx,1) x2], [filt_XY(idx,2) y2], "r-")
%      plot([filt_XY(idx,1) RefPoint(1)], [filt_XY(idx,2) RefPoint(2)], "k--")
%      plot(RefPoint(1), RefPoint(2), "kp", "MarkerFaceColor","k")
%      xlim([-20 20])
%      ylim([-20 20])
%      title(num2str(rad2deg(example_ang(i))))
%      box off
%      axis square
% end


