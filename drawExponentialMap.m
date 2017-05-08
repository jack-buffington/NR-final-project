function image = drawExponentialMap(tri,X,Y,intensities, width,height,numPoints)
   % now create a new image that will be the exponential rendering
   image = ones(height,width)* -1;  % -1 to indicate if nothing is there. 

   % fill in the triangles
   disp('filling in triangles exponentially');
   for I = 1:size(tri,1) 
      % don't draw the extra edge triangles
      if tri(I,1) <= numPoints && ... 
            tri(I,2) <= numPoints && ...
            tri(I,3) <= numPoints
         %fprintf('Working on triangle %d.\n',I);
         xPts = [X(tri(I,1)); X(tri(I,2)); X(tri(I,3))];
         yPts = [Y(tri(I,1)); Y(tri(I,2)); Y(tri(I,3))];
         iPts = [intensities(tri(I,1)); intensities(tri(I,2)); intensities(tri(I,3))];
         image = exponentiallyInterpolateTriangle(xPts,yPts,iPts,image);
      end
   end

%    % Give the places that it didn't have data a value within the range that
%    % was seen.5
%    image(image == -1) = intensities(1);


end