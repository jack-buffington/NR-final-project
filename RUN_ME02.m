% % this code loads one map and colors the points based on a provided map
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
   





% At this point the velodyneFileOffsets and tfFileOffsets arrays have been
% populated.   Now get the combine the two of them together to get a final
% map.

for I = 1:desiredLidarScans
   ed = extractDataFromMessages(bs,velodyneFileOffsets(I));    
   XYZ = convertRawDataToXYZpoints(ed);
   
   
   numberOfPoints = size(XYZ,1);
   colors = zeros(numberOfPoints,3);
   
   colorIndex = numberOfPoints/3;
   pointsPerSector = colorIndex;
   %color1start  = 1;
   color2start = pointsPerSector;
   color3start = pointsPerSector*2;
   color3end = numberOfPoints;
   
   
   colors(1:color2start-1,:) = repmat([1 0 0],color2start-1,1);  
   colors(color2start:color3start-1,:) = repmat([0 1 0],color3start-color2start,1);
   colors(color3start:color3end,:) = repmat([0 0 1],color3end-color3start+1,1);
   
   scatter3(XYZ(:,1),XYZ(:,2),XYZ(:,3),10,colors,'filled'), view(-60,60);
   hold on
   drawnow
end
axis equal
colormap(colors);




