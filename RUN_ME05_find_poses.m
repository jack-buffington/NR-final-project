% This file generates a series of poses using LIDAR data only.
% Old comment below.  No longer necessary but might be useful for
% comparison
% run processTransforms before running this so that it can load correctedOdometry.mat
clear
load('velodyne.mat');
%load('correctedOdometry.mat'); % loads 'odom' which is [X Y heading]

close all
global XYZ
global lastXYZ

numberOfkeyFrames = 100;
poses = zeros(numberOfkeyFrames,4); % [X Y rotation time]


   startTime = velodyne.StartTime;
   stopTime = velodyne.EndTime;
   totalTime = stopTime - startTime;


   lastDistances = zeros(1440,1);
   
   %lastMean  = [0 0 0];
   firstTime  = true;
   
   lastTranslationVector = [0 0];
   
   totalTranslation = [0 0 0];
   for I = 10:numberOfkeyFrames-10
      timeOffset = (totalTime / numberOfkeyFrames)*I;
      [time,XYZ] = getOneStripeOfLidarAroundTime(startTime + timeOffset,velodyne); 

      
      % Try to figure out a rotation and translation without using odometry
      % at all.  
      
      % find the median for all of the points
      XYZmean = mean(XYZ);

      % Find the distances from the median to each point and plot that out.  
      XYZdistances = zeros(size(XYZ,1),1); 

      for J = 1:size(XYZ,1)
         XYZdistances(J,1) = pdist([XYZmean(1:2); XYZ(J,1:2)]);
      end
      
      
      % figure out the angles to the mean
      XYZangles = zeros(size(XYZ,1),1); 
      for J = 1:size(XYZ,1)
         deltaY = XYZmean(2) - XYZ(J,2);
         deltaX =  XYZmean(1) - XYZ(J,1);
         XYZangles(J,1) = atan2(deltaY, deltaX) + pi;
      end
      
      % sort them by angle
      [XYZangles, index] = sort(XYZangles);
      XYZdistances = XYZdistances(index);
      
      

      % create a vector that gives a distance for every 1/4 of a degree
      % so that I can use it to directly compare different scans.  The
      % scans have dropouts that I am getting rid of.  That is why this is
      % necessary
      desiredFs = 720/pi; % should give me a sample every 1/4 degree
      [XYZdistances, XYZangles] = resample(XYZdistances,XYZangles,desiredFs);

      % enforce that the output is exactly 1440 values wide
      XYZdistances = imresize(XYZdistances, [1440 1], 'nearest');
      

      if firstTime == true
         lastDistances = XYZdistances;
         lastMean = XYZmean;
         firstTime = false;
         lastXYZ = XYZ;
         XYZ2 = XYZ;
         poses(1,4) = time;
      else
         % try to find the angle between scans
         index = findOffsetIndex(lastDistances,XYZdistances);
         
         % adjust XYZdistances to match lastDistances         
         XYZdistances = [XYZdistances(index:1440); XYZdistances(1:index-1)];
         
         % figure out the offset angle
         offsetAngle = double(index);
         offsetAngle = offsetAngle / size(XYZdistances,1); % should be in range of 0->1
         offsetAngle = offsetAngle * 2 * pi; % now it is in radians

         % Correct the rotation
         rotm = eul2rotm([offsetAngle 0 0]);
         XYZ = XYZ * rotm;
         
         
         
      options = optimset('Display', 'off') ; % suppress the fmincon messages
      translationVector = fmincon(@scoringFunction, lastTranslationVector,[],[],[],[],[],[],[],options);
         

      %translationVector = fmincon(@scoringFunction, lastTranslationVector);
      
      translationVector2 = [translationVector 0];
      
         XYZ2 = zeros(size(XYZ));
         
         for J = 1:size(XYZ,1) 
           XYZ2(J,:) = XYZ(J,:) + translationVector2 + totalTranslation;
         end
         
         totalTranslation = totalTranslation + translationVector2;
         
         
         % save the pose for further use
         poses(I,1:2) = totalTranslation (1:2);
         poses(I,3) = offsetAngle;
         poses(I,4) = time;
         
         % save the rotated but untranslated points
         lastXYZ = XYZ;  % to use for next time

         lastDistances = XYZdistances;
         lastMean = XYZmean;
         
      end % of if else it wasn't the first time
      
      % draw what it is doing.
%       figure(1)
%       plot3(XYZ2(:,1),XYZ2(:,2),XYZ2(:,3),'.');
%       title('Original scans');
%       hold on
%       axis equal
%       drawnow
   end % of going through the requested number of scans

   axis equal
   fprintf('\n');
   
   save('poses.mat','poses');
   
   for I = 1:10
      beep
      pause(.1)
   end
