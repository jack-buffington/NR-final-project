function extractAllData(fn)
% fn is the file name
%fn = 'C:\Big Stuff\bag files\Sat\one.bag'; 

%A = extractDataFromBagFile(fn,'/lilred_velocity_controller/odom','velocityControllerOdom','velocityControllerOdom');
% B = extractDataFromBagFile(fn,'/imu3dm/filter','imuFilter','imuFilter');
% C = extractDataFromBagFile(fn,'/imu3dm/imu','imu','imu');
 D = extractDataFromBagFile(fn,'/xbee_rssi','xbee','xbee');
 E = extractDataFromBagFile(fn,'/velodyne_packets','velodyne','velodyne');
% F = extractDataFromBagFile(fn,'/tf','tf','tf');

% This appears to be the gyro.  AngularVelocity.Z
%G = extractDataFromBagFile(fn,'/fog','fog','fog'); 
%H = extractDataFromBagFile(fn,'/lilred/odom','odom','odom');
%I = extractDataFromBagFile(fn,'/lilred/odom_ekf','odomEKF','odomEKF');



   for I = 1:10
      beep
      pause(.1)
   end
% /lilred_velocity_controller/odom
% /imu3dm/filter
% /imu3dm/imu
% /xbee_rssi
% /velodyne_packets
% /tf
% /fog
% started 12:41 - 1:00  

end
