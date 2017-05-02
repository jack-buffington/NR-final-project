function vector = findVectorToClosestPoint(p, points)
   % returns the vector to the closest point to p from the set of 'points'
   % This vector when added to p will make it be at that location.  
   
   lowestDistance = 1000000000;
   vector = [0 0];
   
   for I = 1:size(points,1)
      pp = points(I,1:2); % only use X & Y
      distance = pdist([p(1) p(2); pp(1) pp(2)], 'euclidean');
      
      if distance < lowestDistance
         lowestDistance = distance;
         vector = [pp(1) - p(1) pp(2) - p(2)];
      end
   end % of going through all of the points
   
end