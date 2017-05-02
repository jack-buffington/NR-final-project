function extrema = findExtrema(distances)
   % finds the indexes for the local minimums and maximums
   
   numVals = size(distances,1);
   
   range = 50; % how far away to search
   
   extrema = [];
   
   distances = [distances; distances(1:range * 2)];
   
   
   for I = range+1:size(distances,1) - range
      testDist = distances(I);
      a = [distances(I-range:I-1);distances(I+1:I+range)];
      
      isMax = true;
      isMin = false;
      for j = 1:size(a)
         if a(j) > testDist
            isMax = false;
            break;
         end
      end
      

      
      if isMax == false
         isMin = true;
         for j = 1:size(a)
            if a(j) < testDist
               isMin = false;
               break;
            end
         end   
      end
      
      if isMax == true || isMin == true
         %extrema(I,1) = 1;
         extrema = [extrema;I];
      end
   end % of going through all of the points

   % now just fix the extrema values so that they are in the correct
   % positions
   %extrema = extrema - range;
   
   for I = 1:size(extrema,1)
      if extrema(I) > numVals
         extrema(I) = extrema(I) - numVals;
      end
   end
end