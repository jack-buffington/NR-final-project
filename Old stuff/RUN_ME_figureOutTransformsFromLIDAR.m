% run processTransforms before running this so that it can load correctedOdometry.mat
clear
load('velodyne.mat');
load('correctedOdometry.mat'); % loads 'odom' which is [X Y heading]

close all
adjustedPlotFigure = figure( 'Position', [501 40 500 400]);
unadjustedPlotFigure = figure( 'Position', [501 440 500 400]);
unalignedDistances = figure( 'Position', [1 440 500 400]);
alignedDistances = figure('Position', [1 40 500 400]);


   startTime = velodyne.StartTime;
   stopTime = velodyne.EndTime;
   totalTime = stopTime - startTime;

   numScans = 50;

   lastDistances = zeros(1812,1);
   
   lastMean  = [0 0 0];
   firstTime  = true;
   
   % PLAN:
      % 1. Find the angular offset and remove it from XYZangles.
      % 2. sort the angles and distances
      % 3. verify that they are lining up.
      % 4. Convert the angles and distances back into points.   
      % 5. Points from like angles should be roughly the same point in space
      %    so base the translation on their differences.  
%       
%       lastOffsetAngle = 0;
   
   
   for I = 1:numScans
   %for I = 17:21
      timeOffset = (totalTime / numScans)*I;
      [time,XYZ] = getOneStripeOfLidarAroundTime(startTime + timeOffset,velodyne); 
      
      XYZ = fixGaps(XYZ);  % this linearly interpolates when data is missing
      
      figure(unadjustedPlotFigure)
      plot3(XYZ(:,1),XYZ(:,2),XYZ(:,3),'.');
      view(0, 90);
      axis equal
      hold on;
      title('Original scans');
      
      [XYZdistances, XYZmean] = findAnglesAndDistances(XYZ);
      
      if firstTime == true
         lastDistances = XYZdistances;
         lastMean = XYZmean;
         firstTime = false;
      else
         % try to find the angle between scans
         index = findOffsetIndex(lastDistances,XYZdistances);
         
         
         figure(unalignedDistances)
         clf
         plot(lastDistances, 'b');
         hold on
         plot(XYZdistances, 'r');
         title('lastDistances: B  XYZdistances: R');
         
         % adjust XYZdistances to match lastDistances         
         XYZdistances = [XYZdistances(index:end); XYZdistances(1:index-1)];
         
         figure(alignedDistances)
         clf
         plot(lastDistances, 'b');
         hold on
         plot(XYZdistances, 'r');
         title('lastDistances: B  XYZdistances: R');
         
         
         
         % figure out the offset angle   
         offsetAngle = double(index);
         offsetAngle = offsetAngle / size(XYZ,1); % now in the range of 0-1
         offsetAngle = offsetAngle * 2 * pi; % now it is in radians
         
%          offsetAngle = offsetAngle - lastOffsetAngle;
%          lastOffsetAngle = offsetAngle;
         
         
         
         
         % at this point, index is how many quarters of a degree to rotate

         % Correct the rotation
         rotm = eul2rotm([offsetAngle 0 0]);
         XYZ = XYZ * rotm;
         
         
         lastDistances = XYZdistances;
         lastMean = XYZmean;
         
      end % of if it was the first time
      

%       subplot(2,3,3)
      figure(adjustedPlotFigure);
      
      plot3(XYZ(:,1),XYZ(:,2),XYZ(:,3),'.');
      view(0, 90);
      title('Adjusted scans');
      hold on
      axis equal
      drawnow
   end % of going through the requested number of scans

   axis equal

