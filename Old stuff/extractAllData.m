fn = 'C:\Big stuff\bag files\highbay.bag'; 

%A = extractDataFromBagFile(fn,'/lilred_velocity_controller/odom','odom','odom');
% B = extractDataFromBagFile(fn,'/imu3dm/filter','imuFilter','imuFilter');
% C = extractDataFromBagFile(fn,'/imu3dm/imu','imu','imu');
% D = extractDataFromBagFile(fn,'/xbee_rssi','xbee','xbee');
E = extractDataFromBagFile(fn,'/velodyne_packets','velodyne','velodyne');
% F = extractDataFromBagFile(fn,'/tf','tf','tf');


% /lilred_velocity_controller/odom
% /imu3dm/filter
% /imu3dm/imu
% /xbee_rssi
% /velodyne_packets
% /tf
