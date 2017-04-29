function [translation, rotm] = getTransformsAtTime(requestedTime)
% finds the odometryetry on either side of the requestedTime and linearlly
% interpolates to get the correct transforms for the requested time.

% you must run processTransforms before running this so that
% 'correctedOdometry.mat' can be loaded.  

   % odometry is [times X Y heading]
   load('correctedOdometry.mat');
   
   times = odometry(:,1);
   timeDifferences = abs(times - requestedTime);
   [minDif,index] = min(timeDifferences);
   
   if(minDif == 0)
      rotm = eul2rotm([0 0 odometry(index,4)]);  %  ###################### Fix this line
      translation = [odometry(index,2) odometry(index,3)];
   else    
      % figure out if the nearest time is less than or greater than the
      % desired time.
      if odometry(index,1) > requestedTime
         X1 = odometry(index-1,2);
         Y1 = odometry(index-1,3);
         heading1 = odometry(index-1,4);
         time1 = odometry(index-1,1);
         
         X2 = odometry(index,2);
         Y2 = odometry(index,3);
         heading2 = odometry(index,4);
         time2 = odometry(index,1);
      else
         X1 = odometry(index,2);
         Y1 = odometry(index,3);
         heading1 = odometry(index,4);
         time1 = odometry(index,1);
         
         X2 = odometry(index+1,2);
         Y2 = odometry(index+1,3);
         heading2 = odometry(index+1,4);
         time2 = odometry(index+1,1);
      end
      
      % linearly interpolate between the two samples
      totalTime = time2-time1;
      requestedTimeFromFirst = requestedTime - time1;
      percent = requestedTimeFromFirst / totalTime;
      
      X = X1 + (X2-X1) * percent;
      Y = Y1 + (Y2-Y1) * percent;
      heading = heading1 + (heading2-heading1) * percent;
      
      rotm = eul2rotm([-heading 0 0 ]);
      translation = [X Y];
   end % of if the requested time was between two time stamps
%    time = times(index);

end