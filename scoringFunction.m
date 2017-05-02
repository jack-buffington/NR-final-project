function score = scoringFunction(translationVector)
   % returns the sum of the distances to the closest point for all 

   global lastXYZ;
   global XYZ;
   
   translationVector = [translationVector 0];
   
   newPoints = XYZ + repmat(translationVector,size(XYZ,1),1);
   oldPoints = lastXYZ;
   
   score = 0;
   for I = 1:50:size(newPoints)
      score = score + findDistanceToClosestPoint(newPoints(I,:),oldPoints);
   end
end