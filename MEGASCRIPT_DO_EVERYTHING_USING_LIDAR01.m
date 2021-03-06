disp('Extracting data from bag file.');
extractAllData('C:\Big Stuff\bag files\Sat\catacombs.bag');  % saves out velodyne and xbee data

disp('Finding Poses');
RUN_ME05_find_poses; % saves out poses

clear
load('velodyne.mat');
load('poses.mat');

disp('Making Point cloud');
pointCloud = makePointCloud(velodyne, poses, 'testPointCloud01.mat', 5); % use every 5th pose

load('testPointCloud01.mat');
disp('Combining XBee with pose');
xbeeReadings = combineXBeeWithPose();

% the XBee reading positions are in millimeters.  Convert them to meters
xbeeReadings(:,1:2) = xbeeReadings(:,1:2) / 1000;
pixelsPerMeter = 10;
disp('Making signal strength map.');
[map, topLeftX, topLeftY] = ssid2map(xbeeReadings, pixelsPerMeter);

% scale the map so that it is in the range of 0-1 so that it can be
% properly colored in the point cloud
minXbee = min(xbeeReadings(:,3));
maxXbee = max(xbeeReadings(:,3));
map2 = map - minXbee;
map2 = map2 / maxXbee; % now in the range of 0->1

for I = 1:size(map2,1)
   for J = 1:size(map2,2)
      map2(I,J) = real(sqrt(map2(I,J)));
   end
end

map2(map == -1) = 0;

% make a reference chart saying what the colors represent
xBeeRange = maxXbee-minXbee;
disp('Black: no interpolated value');
violetVal = minXbee;
fprintf('Violet: %d milliwatts\n',violetVal);
blueVal =  (.2^2)*xBeeRange+minXbee;
fprintf('Blue: %d milliwatts\n',blueVal);
greenVal = (.4^2)*xBeeRange+minXbee;
fprintf('Green: %d milliwatts\n',greenVal);
yellowVal = (.6^2)*xBeeRange+minXbee;
fprintf('Yellow: %d milliwatts\n',yellowVal);
orangeVal = (.8^2)*xBeeRange+minXbee;
fprintf('Orange: %d milliwatts\n',orangeVal);
redVal = maxXbee;
fprintf('Red: %d milliwatts\n',redVal);





% make a color map 
% black(only the first value) violet, blue, green, yellow, orange, red
disp('Making color lookup table');
colors = makeLookupTable();

disp('Coloring the point cloud.');
colorPointCloud(pointCloud, map2, pixelsPerMeter, topLeftX, topLeftY, colors);

