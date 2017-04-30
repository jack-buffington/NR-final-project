% run processTransforms before running this so that it can load correctedOdometry.mat
clear
load('velodyne.mat');
load('correctedOdometry.mat'); % loads 'odom' which is [X Y heading]





   startTime = velodyne.StartTime;
   stopTime = velodyne.EndTime;
   totalTime = stopTime - startTime;

   numScans = 50;

   lastDistances = zeros(1440,1);
   
   lastMean  = [0 0 0];
   firstTime  = true;
   %for I = 1:numScans
   for I = 20:21
      timeOffset = (totalTime / numScans)*I;
      [time,XYZ] = getLidarAroundTime(startTime + timeOffset,velodyne); 
      
      
      
      
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
      
%       figure(10)
%       mm = subplot(2,3,1);
%       cla(mm)
%       plot(lastDistances, 'b');
%       hold on
%       plot(XYZdistances, 'r');
%       title('unmodified');
      
      
      % PLAN:
      % 1. Find the angular offset and remove it from XYZangles.
      % 2. sort the angles and distances
      % 3. verify that they are lining up.
      % 4. Convert the angles and distances back into points.   
      % 5. Points from like angles should be roughly the same point in space
      %    so base the translation on their differences.  
      
      if firstTime == true
         lastDistances = XYZdistances;
         lastMean = XYZmean;
         firstTime = false;
      else
         % try to find the angle between scans
         index = findOffsetIndex(lastDistances,XYZdistances)
         
         % adjust XYZdistances to match lastDistances         
         XYZdistances = [XYZdistances(index:1440); XYZdistances(1:index-1)];
         
         % figure out the offset angle
         offsetAngle = double(index);
         offsetAngle = offsetAngle / 4; % the angle in degrees
         offsetAngle = offsetAngle * (pi/180); % now it is in radians
         
         
         
         
%          nn = subplot(2,3,2);
%          cla(nn)
%          plot(lastDistances, 'b');
%          hold on
%          plot(XYZdistances, 'r');
%          title('lastDistances: B  XYZdistances: R');
         
         % at this point, index is how many quarters of a degree to rotate

         % Correct the rotation
         rotm = eul2rotm([offsetAngle 0 0]);
         XYZ = XYZ * rotm;
         
%          for J = 1:size(XYZ,1)
%             XYZ(J,:) = XYZ(J,:) - lastMean;
%          end
         
         lastDistances = XYZdistances;
         lastMean = XYZmean;
         
      end % of if it was the first time
      

%       subplot(2,3,3)
      plot3(XYZ(:,1),XYZ(:,2),XYZ(:,3),'.');
      title('Original scans');
      hold on
      axis equal
      drawnow
   end % of going through the requested number of scans

   axis equal

