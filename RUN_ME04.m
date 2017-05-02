% run processTransforms before running this so that it can load correctedOdometry.mat
clear
load('velodyne.mat');
load('correctedOdometry.mat'); % loads 'odom' which is [X Y heading]


close all


   startTime = velodyne.StartTime;
   stopTime = velodyne.EndTime;
   totalTime = stopTime - startTime;

   numScans = 4;

   
  

   figure(1)
   hold on
   
   
   
   
   
   
   for I = 1:numScans
      timeOffset = (totalTime / numScans)*I;
      [time,XYZ] = getLidarAroundTime(startTime + timeOffset,velodyne); 
      
      
      % Mean isn't going to work because there will be more points close to
      % the LIDAR unit 
      % find the median for all of the points
      XYZmean = mean(XYZ);

      % Find the distances from the median to each point and plot that out.  
      XYZdistances = zeros(size(XYZ,1),1);

      for J = 1:size(XYZ,1)
         XYZdistances(J) = pdist([XYZmean(1:2); XYZ(J,1:2)]);
      end
      figure
      plot(XYZdistances);
   
      for J = 1: size(XYZ,1)
         XYZ(J,:) = XYZ(J,:) - XYZmean;
      end
%       [translation, rotm] = getTransformsAtTime(time);
%       
%       
%       % try to figure out a rotation and translation without using odometry
%       % at all.  
%       
%       % Create a histogram of angles between points for each scan and find
%       % the highest peak.   Rotate the points by that angle
%       histogram = zeros(121,1);
%       for J = 1:size(XYZ,1)-10
%          offsets = XYZ(J+10,:) - XYZ(J,:);
%          angle = atan2(offsets(2),offsets(1)); % -pi to pi
%          % figure out what bin it will go in.
%          angle = angle / (2*pi);
%          angle = angle + .5;  % get it in the range of 0->1
%          angle = int32(angle * 120)+1; % +1 prevents having an index of zero
% 
%          histogram(angle) = histogram(angle) +1;
% 
%       end
% %       histogram(181) = 0; % get rid of the peak
%       figure;
%       plot(histogram);
%       
%       
%       
%       %rotate the translation
%       translation = [translation 0];
%       transRot = eul2rotm([pi * .5 0 0]);
%       translation = translation * transRot; 
%       
%       
% %       %adjust things based on the transforms
% %       for J = 1:size(XYZ,1)
% %          % rotate first
% %          XYZ(J,:) = XYZ(J,:) * rotm;
% %          % translate
% %          XYZ(J,1) = XYZ(J,1) - translation(1) * 1000 ; % convert to mm from meters
% %          XYZ(J,2) = XYZ(J,2) - translation(2) * 1000 ;
% %       end
       figure(1)
       plot3(XYZ(:,1),XYZ(:,2),XYZ(:,3),'.');
       axis equal
       
%       %plot3(XYZ(:,1),XYZ(:,2),XYZ(:,3));
%       axis equal
      
      
      
%       for J = 1:size(XYZ,1)-1
%       plot3(XYZ(J:J+1,1),XYZ(J:J+1,2),XYZ(J:J+1,3));
%       pause(.003)
%       drawnow
%       end
      
      drawnow
   end

   %axis equal

