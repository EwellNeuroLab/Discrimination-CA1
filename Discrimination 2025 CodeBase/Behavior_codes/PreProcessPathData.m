function pos = PreProcessPathData(pos, fix, center, rot, convert)

    if fix.run == 1
        %set nans to zero
        pos(isnan(pos(:,3)),2:3) = 0;
        pos(isnan(pos(:,2)),2:3) = 0;
        pos = fixZeroPosGT(pos);
    elseif fix.run 
        [pos, ~] = fixPosDataGT(pos, fix.Threshold,fix.MaxDuration,fix.ShowPlots);
    end

    if center.run 
        shift.x = ((max(pos(:,2))-min(pos(:,2)))/2+min(pos(:,2)));
        shift.y = ((max(pos(:,3))-min(pos(:,3)))/2+min(pos(:,3)));
        pos(:,2) = pos(:,2) - shift.x;
        pos(:,3) = pos(:,3) - shift.y;
        %set pos data to show the right directions
        pos(:,3) = -pos(:,3); % flip along y axis
    end

    if rot.run
        %rotate all [X Y]
        for i = 1:length(pos(:,2))
            pos(i,2:3) = pos(i,2:3)*rot.R';
        end
    end

    if convert.run 
        %convert it to cm
        pos(:,2:3) = pos(:,2:3)./convert.pix2cm;

    end
    
end