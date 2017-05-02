% % this attempts to display multiple LIDAR scans together
clear; 
load('bag.mat');


bs = select(bag,'Topic','velodyne_packets');
bs2 = select(bag,'Topic','tf'); % These are geometry transforms
bs3 = select(bag,'Topic','lilred_velocity_controller/odom');
% msgs = readMessages(bs3,1)
% A = msgs{1}
% B = A.Pose
% C = B.Pose
% D = C.Position
% D.X
% D.Y
% D.Z
% E = C.Orientation
% E.X
% E.Y
% E.Z
% E.W

% To get to things quickly:
% msgs = readMessages(bs3,1)
% position = msgs{1}.Pose.Pose.Position
% quaternion = msgs{1}.Pose.Pose.Orientation


% I can work around the lack of time information by scanning through the
% messages to find what I am looking for.

numberOfMessages = size(bag.MessageList,1);

desiredLidarScans = 3;

%offsetIncrement = numberOfMessages/desiredLidarScans;
offsetIncrement = 10000;

currentOffset = 1;

tfFileOffsets = zeros(desiredLidarScans,1);
velodyneFileOffsets = zeros(desiredLidarScans,1);


for I = 0:desiredLidarScans - 1
   currentOffset = uint32(I * offsetIncrement + 1);
   messageType = bag.MessageList(currentOffset,2).Topic;

   % I'm finding velodyne messages first because odometry messages come
   % five times more often so this will make the two of them be closer in
   % time.
   
   % find a Velodyne message.
   while messageType ~= '/velodyne_packets'
      currentOffset = currentOffset + 1;
      messageType = bag.MessageList(currentOffset,2).Topic;
   end
   velodyneFileOffsets(I+1) = table2array(bag.MessageList(currentOffset,4));
   velodyneOffset = currentOffset;
   
   % Now find a odometry message
   while messageType ~= '/lilred_velocity_controller/odom'   
      currentOffset = currentOffset + 1;
      messageType = bag.MessageList(currentOffset,2).Topic;
   end
   tfOffset = currentOffset;
   tfFileOffsets(I+1) = table2array(bag.MessageList(currentOffset,4));

   fprintf('Velodyne message found at offset %d \n',velodyneOffset);
   fprintf('Odometry message found at offset %d \n',tfOffset);
end




% At this point the velodyneFileOffsets and tfFileOffsets arrays have been
% populated.   Now get the combine the two of them together to get a final
% map.
figure
for I = 1:desiredLidarScans
   ed = extractDataFromMessages(bs,velodyneFileOffsets(I));    
   XYZ = convertRawDataToXYZpoints(ed);
   
   % Now get the transforms for the robot so that I can align the scans
   % properly
   [translation, rotation] = getTransforms02(bs3, tfFileOffsets(I));
   temp = translation(1);
   translation(1) = -translation(2);
   translation(2) = temp;
   
%    euler = quat2eul(rotation);
%    %euler(1) = euler(1) * -1;
%    rotm = eul2rotm(euler);
   
   rotm = quat2rotm(-rotation);
   
   
   XYZ = (rotm * XYZ')';
   
   for I = 1:size(XYZ,1)
      XYZ(I,:) = XYZ(I,:) + translation * 1000; % XYZ is in millimeters but translation is in meters
   end
   
   numberOfPoints = size(XYZ,1);

   
   plot3(XYZ(:,1),XYZ(:,2),XYZ(:,3),'.');   % Refer to junk01 to see how to color the points
   hold on
   drawnow
end
axis equal




