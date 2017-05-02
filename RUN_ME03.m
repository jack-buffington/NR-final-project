% run processTransforms before running this so that it can load correctedOdometry.mat
clear
load('velodyne.mat');
load('correctedOdometry.mat'); % loads 'odom' which is [X Y heading]





   startTime = velodyne.StartTime;
   stopTime = velodyne.EndTime;
   totalTime = stopTime - startTime;

   numScans = 20;

   A = figure;
   hold on

   for I = 1:numScans
      timeOffset = (totalTime / numScans)*I;
      [time,XYZ] = getLidarAroundTime(startTime + timeOffset,velodyne); 
      [translation, rotm] = getTransformsAtTime(time)
      
      %rotate the translation
      translation = [translation 0];
      transRot = eul2rotm([pi * .5 0 0]);
      translation = translation * transRot 
      
      
      % adjust things based on the transforms
      for J = 1:size(XYZ,1)
         % rotate first
         %XYZ(J,:) =  (rotm * XYZ(J,:)')'; 
         XYZ(J,:) = XYZ(J,:) * rotm;
         % translate
         XYZ(J,1) = XYZ(J,1) - translation(1) * 1000 ; % convert to mm from meters
         XYZ(J,2) = XYZ(J,2) - translation(2) * 1000 ;
      end
      plot3(XYZ(:,1),XYZ(:,2),XYZ(:,3),'.');
      axis equal
      drawnow
   end

   axis equal

