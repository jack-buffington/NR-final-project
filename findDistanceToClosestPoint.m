function lowestDistance = findDistanceToClosestPoint(p, points)
   % returns the vector to the closest point to p from the set of 'points'
   % This vector when added to p will make it be at that location.  
   
   lowestDistance = 1000000000;

   
   for I = 1:size(points,1)
      pp = points(I,:);
      
      deltaX = p(1) - pp(1);
      deltaY = p(2) - pp(2);
      distance1 = sqrt(deltaX * deltaX + deltaY * deltaY);

%       delta = p-pp; % this is slightly slower
%       distance2 = sqrt(delta(1)^2 + delta(2)^2);
      
      
      if distance1 < lowestDistance
         lowestDistance = distance1;
      end
   end % of going through all of the points
   
end