% % this code loads one lidar scan and colors the points based on a
% provided image.

% XYZ coordinates are in millimeters
clear; 
load('bag.mat');



bs = select(bag,'Topic','velodyne_packets');
bs2 = select(bag,'Topic','tf'); % These are geometry transforms



% I can work around the lack of time information by scanning through the
% messages to find what I am looking for.

numberOfMessages = size(bag.MessageList,1);

desiredLidarScans = 1;

offsetIncrement = numberOfMessages/desiredLidarScans;

currentOffset = 1;

tfFileOffsets = zeros(desiredLidarScans,1);
velodyneFileOffsets = zeros(desiredLidarScans,1);



   currentOffset = 1;
   messageType = ' ';
   % find the next Veoldyne message 
   while messageType ~= '/velodyne_packets'
      currentOffset = currentOffset + 1;
      messageType = bag.MessageList(currentOffset,2).Topic;
   end
   
   velodyneFileOffsets(1) = table2array(bag.MessageList(currentOffset,4));
   fprintf('Velodyne message found at offset %d \n',currentOffset);
   

% load an image
image = imread('eye.jpg');

% For each point in the point cloud, color it using the image.

pixelsPerMeter = 5;
% center the image
xOffset = 140;  % pixels
yOffset = 84; % pixels


% How to calculate which pixel to use to color a point:
% * Take the X & Y coordinates and divide them by 1000 to get them into
%   meters
% * Multiply those values by pixelsPerMeter to get the pixel offset
% * Add xOffset or yOffset to get the actual pixel location
% * Check to see if this is in the bounds of the image.  If so, then use
%   that pixel's value.






% At this point the velodyneFileOffsets and tfFileOffsets arrays have been
% populated.   Now get the combine the two of them together to get a final
% map.

for I = 1:desiredLidarScans
   ed = extractDataFromMessages(bs,velodyneFileOffsets(I));    
   XYZ = convertRawDataToXYZpoints(ed);
   numberOfPoints = size(XYZ,1);
   colors = zeros(numberOfPoints,3);
      
   for J = 1:size(XYZ,1)
      

      xLoc = (XYZ(J,1)*pixelsPerMeter)/1000;
      yLoc = (XYZ(J,2)*pixelsPerMeter)/1000;
      xLoc = int32(xLoc + xOffset);
      yLoc = int32(yLoc + yOffset);

      if xLoc > 0 && yLoc > 0 && xLoc < size(image,2)+1 && yLoc < size(image,1) + 1
         pixelValue = double(image(yLoc,xLoc));
         pixelValue = pixelValue / 256; % should be in the range of 0->1
         colors(J,:) = [pixelValue pixelValue pixelValue];
      else
         colors(J,:) = [0 0 0];
      end
   end
%    colorIndex = numberOfPoints/3;
%    pointsPerSector = colorIndex;
%    %color1start  = 1;
%    color2start = pointsPerSector;
%    color3start = pointsPerSector*2;
%    color3end = numberOfPoints;
%    
%    
%    colors(1:color2start-1,:) = repmat([1 0 0],color2start-1,1);  
%    colors(color2start:color3start-1,:) = repmat([0 1 0],color3start-color2start,1);
%    colors(color3start:color3end,:) = repmat([0 0 1],color3end-color3start+1,1);
   
   scatter3(XYZ(:,1),XYZ(:,2),XYZ(:,3),10,colors,'filled'), view(-60,60);
   hold on
   drawnow
end
axis equal
%colormap(colors);




