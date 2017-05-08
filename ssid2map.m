% ssid2map.m
function [map, topLeftX, topLeftY] = ssid2map(readings, pixelsPerMeter)  
   % generates an inverse square interpolated image based on the values given
   % returns an image and the coordinates of the top left corner of the image.
   
   % readings is rows of  [X,Y, strength]
   X = readings(:,1);
   Y = readings(:,2);
   strength = readings(:,3);
   
   topLeftX = min(X);
   topLeftY = max(Y);
   
   % adjust the coordinates to be pixel coordinates
   X = X * pixelsPerMeter;
   Y = Y * pixelsPerMeter;
   
   X = round(X);
   Y = round(Y);
   
   % get things into pixel coordinates (1->maximum pixel coord)
   X = X - min(X) + 1;
   Y = Y - min(Y) + 1;
   
   mapWidth = max(X) - min(X) + 1;
   mapHeight = max(Y) - min(Y) + 1;
   
   numPoints = size(X,1);
   
   % add in four points around the edges so that the triangulation won't
   % create any strange sliver triangles around the edges
   lowX = min(X) - mapWidth;
   halfX = round(min(X) + mapWidth/2);
   highX = max(X) + mapWidth;
   
   lowY = min(Y) - mapHeight;
   halfY = round(min(Y) + mapHeight/2);
   highY = max(Y) + mapHeight;

   X = [X; lowX; halfX; highX; halfX];
   Y = [Y; halfY; lowY; halfY; highY];
   

   
   % triangulate the points
   tri = delaunay(X,Y);  
   


   
   map = drawExponentialMap(tri,X,Y,strength,mapWidth, mapHeight,numPoints);
   
   
   % DRAW THE TRIANGLES
   figure
   title('Triangulation ');
   %axis([0 size(map,1) 0 size(map,2)]);
   axis equal

   hold on
   xPoints = zeros(1,4);
   yPoints = zeros(1,4);

   for I = 1:size(tri,1) 
      % don't draw the extra edge triangles
      if tri(I,1) <= numPoints && ... 
            tri(I,2) <= numPoints && ...
            tri(I,3) <= numPoints

         xPoints(1) = X(tri(I,1));
         xPoints(2) = X(tri(I,2));
         xPoints(3) = X(tri(I,3));
         xPoints(4) = X(tri(I,1));

%          % flip the Y direction
%          yPoints(1) = size(map,1) - Y(tri(I,1));
%          yPoints(2) = size(map,1) - Y(tri(I,2));
%          yPoints(3) = size(map,1) - Y(tri(I,3));
%          yPoints(4) = size(map,1) - Y(tri(I,1));
         
         yPoints(1) = Y(tri(I,1));
         yPoints(2) = Y(tri(I,2));
         yPoints(3) = Y(tri(I,3));
         yPoints(4) = Y(tri(I,1));


         plot(xPoints, yPoints);
      end
   end 
   % make a new figure for the point cloud
   figure
   
end


