function pointCloud = makePointCloud(bagSelect, poses, fileName, skip)
   % makes a point cloud out of the velodyne data in the bagSelect.
   % It uses poses to align them.   
   % poses is [X Y rotation time]
   % filename is the name of the output point cloud.
   % skip is an integer that lets you skip every Nth location in poses
   
   pointCloud = [];
   fprintf('Processing pose #0000');
   for I = 1:skip:size(poses,1)
      fprintf('\b\b\b\b%04d',I);
      [time, XYZ] = getLidarAroundTime(poses(I,4), bagSelect);
      
      
      rotm = eul2rotm([poses(I,3) 0 0]);
      XYZ = XYZ * rotm;
      translationVector = [poses(I,1:2) 0];   
      
      XYZ = XYZ + repmat(translationVector,size(XYZ,1),1);
      
      pointCloud = [pointCloud; XYZ];
   end % of going through all lof the poses
   
   fprintf('\nDone.\n');
   save(fileName,'pointCloud');
   
   
   
end