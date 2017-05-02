function [distances, center] = findAnglesAndDistances(XYZ)
% finds the mean (center) location and then finds the distances for
% all points from that point 

% There should be 1812 points in XYZ

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
   [~, index] = sort(XYZangles);
   distances = XYZdistances(index);
   center = XYZmean;

end


