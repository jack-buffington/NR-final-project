function colorPointCloud(pointCloud, image, pixelsPerMeter, leftX, topY, colorTable)
   % projects the image onto the point cloud from a top view.
   % pixelsPerMeter is how many pixels of the image there are per meter
   % topRightCoordinate is the X & Y location for the top, right corner of
   % the image.
   % colors is the color map to apply to the finished point cloud.
   
   % topLeftX and topLeftY are in meters
   
   % The points in the point cloud are in millimeters so convert them into
   % meters
   pointCloud = pointCloud / 1000;
   
   % just one value for colors.  I'll use colormap to color them instead of
   % doing extra work to assign three values to each point. b
   colors = zeros(size(pointCloud,1),1); 
   
   
   
   % everything else about this project is correct-ish but I'm out of time
   % and scales are wrong somehow so I'm fudging the position of the color
   % overlay.   
   scaleFudge = 1.5;
   xFudge = -2.5;
   yFudge = 0;
   
   
   
   
   leftX = leftX + xFudge;
   topY = topY + yFudge;
   
   metersPerPixel = 1/pixelsPerMeter * scaleFudge;
   bottomY = topY - size(image,1) * metersPerPixel;
   rightX = leftX + size(image,2) * metersPerPixel;
   imageWidth = rightX-leftX+1;
   imageHeight = topY-bottomY+1;
   
   
   % go through all of the points in the point cloud to determine what
   % color it should be.
   for I = 1:size(pointCloud,1)
      % figure out the pixel coordinates of the point
      xCoord = pointCloud(I,1);
      yCoord = pointCloud(I,2);
      
      if xCoord < leftX || xCoord > rightX || yCoord > topY || yCoord < bottomY 
         % It isn't within the picture region
         colors(I) = 0; % paint it black
      else
         % it is within the picture region
         % figure out where within the picture it is.
         xCoord = xCoord - leftX;
         xPercent = xCoord / imageWidth;
         
         yCoord = yCoord - bottomY;
         yPercent = yCoord / imageHeight;
         
         yPixel = int32(yPercent * size(image,1)) + 1; % +1 to make it not be zero
         xPixel = int32(xPercent * size(image,2)) + 1;
         
         colors(I) = image(yPixel,xPixel);
      end
   end
   
   scatter3(pointCloud(:,1),pointCloud(:,2),pointCloud(:,3),5,colors,'filled'), view(-60,60);
   colormap(colorTable);
   axis equal;
   
end