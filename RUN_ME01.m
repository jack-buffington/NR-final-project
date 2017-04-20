% % this attempts to display multiple LIDAR scans together
clear; 
load('bag.mat');


bs = select(bag,'Topic','velodyne_packets');
bs2 = select(bag,'Topic','tf'); % These are geometry transforms



% I can work around the lack of time information by scanning through the
% messages to find what I am looking for.

numberOfMessages = size(bag.MessageList,1);

desiredLidarScans = 3;

offsetIncrement = numberOfMessages/desiredLidarScans;

currentOffset = 1;

tfFileOffsets = zeros(desiredLidarScans,1);
velodyneFileOffsets = zeros(desiredLidarScans,1);


for I = 0:desiredLidarScans - 1
   currentOffset = uint32(I * offsetIncrement + 1);
   messageType = bag.MessageList(currentOffset,2).Topic;
   while messageType ~= '/tf'
      currentOffset = currentOffset + 1;
      messageType = bag.MessageList(currentOffset,2).Topic;
   end
   tfOffset = currentOffset;
   tfFileOffsets(I+1) = table2array(bag.MessageList(currentOffset,4));
   
   % find the next Veoldyne message after that.
   while messageType ~= '/velodyne_packets'
      currentOffset = currentOffset + 1;
      messageType = bag.MessageList(currentOffset,2).Topic;
   end
   
   velodyneFileOffsets(I+1) = table2array(bag.MessageList(currentOffset,4));
   fprintf('tf message found at offset %d \n',tfOffset);
   fprintf('Velodyne message found at offset %d \n',currentOffset);
   
end




% At this point the velodyneFileOffsets and tfFileOffsets arrays have been
% populated.   Now get the combine the two of them together to get a final
% map.

for I = 1:desiredLidarScans
   ed = extractDataFromMessages(bs,velodyneFileOffsets(I));    
   XYZ = convertRawDataToXYZpoints(ed);
   
   % Now get the transforms for the robot so that I can align the scans
   % properly
   [translation, rotation] = getTransforms(bs2, tfFileOffsets(I))
   
   euler = quat2eul(rotation);
   rotm = eul2rotm(euler);
   %rotm = quat2rotm(-rotation);
   XYZ = (rotm * XYZ')';
   
   for I = 1:size(XYZ,1)
      XYZ(I,:) = XYZ(I,:) + translation * 10000;
   end
   
   numberOfPoints = size(XYZ,1);
   colors = zeros(numberOfPoints,3);
   
   colorIndex = numberOfPoints/3;
   pointsPerSector = colorIndex;
   colors(1:colorIndex,:) = repmat([1 0 0],pointsPerSector,1);
   colors(colorIndex:colorIndex + pointsPerSector,:) = repmat([0 1 0],pointsPerSector,1);
   colorIndex = colorIndex + pointsPerSector;
   colors(colorIndex:end,:) = repmat([1 0 0],numberOfPoints-colorindex,1);
   
   
   plot3(XYZ(:,1),XYZ(:,2),XYZ(:,3),'.');   % Refer to junk01 to see how to color the points
   hold on
   drawnow
end
axis equal




