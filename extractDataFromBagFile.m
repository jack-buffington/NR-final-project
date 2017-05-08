function data = extractDataFromBagFile(bagFilePath, topicName, outputFileName, variableName)
% extracts the specified topic from the bag file and then both saves it and 
% returns the same data.

% This script should only be run once because it takes a long time to run.

   bag = rosbag(bagFilePath);
   
   
   
   eval(sprintf('%s = select(bag,''Topic'',topicName);',variableName))

   eval(sprintf('save(outputFileName,''%s'');',variableName))
   
   eval(sprintf('data = %s;',variableName))
   
end



% lilred_velocity_controller/odom
% /imu3dm/filter
% /imu3dm/imu
% /xbee_rssi
% /velodyne_packets
%
