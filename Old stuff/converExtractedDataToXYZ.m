% RUN THIS THIRD

clear;
load('extractedData.mat'); % loads as 'ed'

% ed is a 1x1812 struct with azimuth, azimuthRadians, strongest, and last
% strongest and last are 1x16 arrays 

% go through all angles and interpolate the radians
% this could be improved.  it is inefficient
for I = 2:size(ed,1)-2
  
   t = ed(I-1).azimuthRadians;
   if ed(I).azimuthRadians == t
      ed(I).azimuthRadians = (ed(I+1).azimuthRadians + t)/2; %#ok<*SAGROW>
   end
   
   % special case for end of revolution
   ed(1812).azimuthRadians = (ed(1811).azimuthRadians + ed(1).azimuthRadians)/2; 
end


% Now calculate XYZ values for each reading
% First make a lookup table for the angle of each laser because putting
% them in order would make far too much sense...
angles = [-15,1,-13,-3,-11,5,-9,7,-7,9,-5,11,-3,13,-1,15];

% Convert to radians
angles = (angles / 360)* 2 * pi ;

XYZ = zeros(size(ed,1),3);
XYZ2 = zeros(size(ed,1),3);

disp('calculating XYZ values');
index = 1;
for I = 1:size(ed,2)
   for J = 1:16
   XYZ(index,1) = double(ed(I).last(J)) * cos(angles(J)) * sin(ed(I).azimuthRadians);
   XYZ(index,2) = double(ed(I).last(J)) * cos(angles(J)) * cos(ed(I).azimuthRadians);
   XYZ(index,3) = double(ed(I).last(J)) * sin(angles(J));
   index = index + 1;
   end
end

disp('plotting');
clf;
axis equal
plot3(XYZ(:,1),XYZ(:,2),XYZ(:,3),'.');
%hold on
%plot3(XYZ2(:,1),XYZ2(:,2),XYZ2(:,3),'.');
