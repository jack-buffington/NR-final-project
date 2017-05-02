% run processTransforms before running this so that it can load correctedOdometry.mat
clear
load('velodyne.mat');
load('correctedOdometry.mat'); % loads 'odom' which is [X Y heading]

close all
global XYZ
global lastXYZ



   startTime = velodyne.StartTime;
   stopTime = velodyne.EndTime;
   totalTime = stopTime - startTime;

   numScans = 50;

   lastDistances = zeros(1440,1);
   
   %lastMean  = [0 0 0];
   firstTime  = true;
   
   lastTranslationVector = [0 0];
   
   totalTranslation = [0 0 0];
   %for I = 1:numScans
   for I = 1:28
      timeOffset = (totalTime / numScans)*I;
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
         lastXYZ = XYZ;
         XYZ2 = XYZ;
      else
         % try to find the angle between scans
         index = findOffsetIndex(lastDistances,XYZdistances);
         
         % adjust XYZdistances to match lastDistances         
         XYZdistances = [XYZdistances(index:1440); XYZdistances(1:index-1)];
         
         % figure out the offset angle
         offsetAngle = double(index);
         offsetAngle = offsetAngle / size(XYZdistances,1); % should be in range of 0->1
         offsetAngle = offsetAngle * 2 * pi; % now it is in radians
         
         
         
         % Translation strategy
         % find the differences in the distances
         % Fit a sine wave to it that passes within some metric of the most
         % points.
         % Figure out the phase shift.  That is the angle to move.
         % figure out the amplitude, that is the distance to move
         differences = lastDistances - XYZdistances;
         
         
%          close all
%          plot(differences,'b')
%          hold on
%          [envHigh, envLow] = envelope(differences,20,'peak');
%          envMean = (envHigh+envLow)/2;
%          plot(envMean,'r');
%          plot([1;size(XYZ,1)],[0 0], 'k');
         
         % maybe try making a histogram of the differences and 
         
         
         
         
%          figure(20);
%          plot(lastDistances, 'b');
%          hold on
%          plot(XYZdistances, 'r');
%          plot([1;size(XYZ,1)],[0 0], 'k');
%          %plot(differences * 15,'g');
%          %plot(envMean,'y');
%          
%          title('lastDistances: B  XYZdistances: R');
%          drawnow

%          newExtrema = findExtrema(XYZdistances);
%          oldExtrema = findExtrema(lastDistances);
%          
%          for M = 1:size(newExtrema,1)
%             line([newExtrema(M);newExtrema(M)],[1;max(XYZdistances)],'Color',[1 .4 .4]);
%          end 
%          
%          for M = 1:size(oldExtrema,1)
%             line([oldExtrema(M);oldExtrema(M)],[1;max(XYZdistances)],'Color',[.4 .4 1]);
%          end
         
         % at this point, index is how many quarters of a degree to rotate

         % Correct the rotation
         rotm = eul2rotm([offsetAngle 0 0]);
         XYZ = XYZ * rotm;
         
         
%          % correct the translation.   
%          % Failed Strategy: 
%          % Use findClosestPoint for all points.   It returns a vector that
%          % translates that point to the nearest point.   Given that this
%          % room is roughly rectangular, I would expect that I will get a
%          % rectangle back with big clusters at two corners.  Find the mean
%          % of those two cluster and move the sum of those two vectors.  
%          
%          vectors = zeros(size(XYZ,1),2);
%          fprintf('Finding the closest point to point 0000');
%          for J = 10:10:size(XYZ)
%             fprintf('\b\b\b\b%04d',J);
%             vectors(J/10,:) = findClosestPoint(XYZ(J,:),lastXYZ);
%          end
%          
%          figure(22)
%          % plot the vectors
%          plot(vectors(:,1),vectors(:,2),'.');
%          
%          [groupNumbers, centroids] = kmeans(vectors,2);
%          
%          translationVector = sum(centroids);
%          
         

      % Correct the translations
      % Strategy: 
      % For one of the points in the new point cloud, translate it to
      % overlay each of the points from the old point cloud.  Pick Every Nth point 
      % in the new point cloud and find the distance to the closest point
      % in the old point cloud.  Sum all of those distances.  The lowest
      % distance wins.  
      
      % To make this better, I should probably try several points from the
      % new data set in case I have found a point that isn't seen in both.
      
      
      
      
      
      
%       % ###################################################
%       % This mostly works...
%       p1 = XYZ(300,1:2);
%       lowestSum = realmax; % the maximum possible double
%       lowestIndex = 0;
%       lowestVector = [0 0];
%       fprintf('\nChecking for fit using point #0000');
%       for J = 1:size(lastXYZ,1)
%          fprintf('\b\b\b\b%04d',J);
%          p2 = lastXYZ(J,1:2);
%          %dif = p2-p1;
%          dif = [p2-p1 0];
%          theSum = 0;
%          for K = 1:100:size(XYZ,1)
%             %tempPoint = XYZ(K,1:2) + dif;
%             tempPoint = XYZ(K,:) + dif;
%             theSum = theSum + findDistanceToClosestPoint(tempPoint,lastXYZ);
%          end
%          if theSum < lowestSum
%             lowestSum  = theSum;
%             lowestIndex = J;
%             lowestVector = dif;
%          end
%       end
%       
%       translationVector = lowestVector;
%       % #######################################################
      
      
      
      % Alternate Correct the translations
      % Strategy;
      % Find the directional derivative of the sum of the distances
      % step in that direction
      % Repeat until error doesn't decrease.
      % This version should be more robust to picking a bad point.
      % I should perhaps randomly pick N points each time to lessen that
      % effect even further.  
      
      
      %initialTranslationVector = [0 0];
      
      % TODO:   initial translation vector could be what worked best last
      % time
      translationVector = fmincon(@scoringFunction, lastTranslationVector);
      
      translationVector2 = [translationVector 0];
      
         XYZ2 = zeros(size(XYZ));
         
         for I = 1:size(XYZ,1)
           %XYZ2(I,1) = XYZ(I,1) + translationVector(1) + totalTranslation(1);
           %XYZ2(I,2) = XYZ(I,2) + translationVector(2) + totalTranslation(2);  
           XYZ2(I,:) = XYZ(I,:) + translationVector2 + totalTranslation;
         end
         
         totalTranslation = totalTranslation + translationVector2;
         
         % save the rotated but untranslated points
         lastXYZ = XYZ;  % to use for next time
         
  
         lastDistances = XYZdistances;
         lastMean = XYZmean;
         
      end % of if else it wasn't the first time
      

      figure(1)
      plot3(XYZ2(:,1),XYZ2(:,2),XYZ2(:,3),'.');
      title('Original scans');
      hold on
      axis equal
      drawnow
   end % of going through the requested number of scans

   axis equal
   fprintf('\n');
