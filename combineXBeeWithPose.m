function xbeeReadings = combineXBeeWithPose()
   % returns xbeeReadings which is [X Y reading]

   load('poses.mat'); % [X Y orientation time];
   load('xbee.mat'); % this is a bag select.

   

   msgs = readMessages(xbee,1:size(xbee.MessageList,1));
   readings = zeros(size(msgs,1),1);
   
   for I = 1:size(msgs,1)
      readings(I) = double(msgs{I}.Range_);
   end
   
   times = table2array(xbee.MessageList(:,1));

   xbeeReadings = zeros(size(poses,1),3);
   
   % for each pose, find the XBee reading that is closest in time and
   % combine the two
   for I = 1:size(poses,1)
      poseTime = poses(I,4);
      timeDifferences = abs(times - repmat(poseTime,size(times,1),1));
      [~,whichReading] = min(timeDifferences);
      xbeeReadings(I,1:2) = poses(I,1:2);
      xbeeReadings(I,3) = readings(whichReading);
   end


end