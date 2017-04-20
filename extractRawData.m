% RUN THIS SECOND

% This script extracts data from the Velodyne 
clear;
load('messages.mat');  % loads the msgs variable
a = msgs{1}.Packets; % 151x1 velodyne packets

% set up the extractedData structure
ed(1812).azimuth = 0;
ed(1812).azimuthRadians = 0;
ed(1812).strongest(16) = 0;  % stored as milllimeters
ed(1812).last(16) = 0; % stored as millimeters


edIndex = 1;
for I = 1:151  % 151 data packets per velodyne data
   b = a(I).Data;
   loc = 1;
   for K = 1:12 % 12 angles per packet
      loc = loc + 2; % skip over the flag bytes
      % azimuth is reported as 0-360 degrees
      ed(edIndex).azimuth = ((double(b(loc+1)) * 256) + double(b(loc))) / 100;
      ed(edIndex).azimuthRadians = 2 * pi * (ed(edIndex).azimuth / 360);
      
      loc = loc + 2;
      
      % get the strongest return
      for J = 1:16
         ed(edIndex).strongest(J) = (2 * (uint16(b(loc+1)) * 256)) + uint16(b(loc));
         loc = loc + 3; % skip over the reflectivity byte
      end

      % get the last return
      for J = 1:16
         ed(edIndex).last(J) = (2 * (uint16(b(loc+1)) * 256)) + uint16(b(loc));
         loc = loc + 3; % skip over the reflectivity byte
      end
      edIndex = edIndex + 1;
   end
end


save('extractedData.mat','ed');


%{
Our data structure
Numbers are 1-based

Azimuth [byte 3 byte 4]
Angle in radians (we compute)
Distance 1   [byte5 byte6 byte 54 byte 55]
Distance 2
…
Distance 16
%}


