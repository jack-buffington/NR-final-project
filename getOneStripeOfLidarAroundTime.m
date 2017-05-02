function [time, XYZpoints] = getOneStripeOfLidarAroundTime(requestedTime, velodyne)
   % returns XYZ points from the velodyne message closest to the requested time.
   % returns the time that the message was associated with.
   % requestedTime is given in system time.
   
   times = table2array(velodyne.MessageList(:,1));
   timeDifferences = abs(times - requestedTime);
   [~,index] = min(timeDifferences);
   time = times(index);
   
   % 'index' now contains the index for the message with the closest time.
   velodyneMessage = readMessages(velodyne,index); 
   
   % convert the raw data into a sensible array
   a = velodyneMessage{1}.Packets; % 151x1 velodyne packets
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
            ed(edIndex).strongest(J) = double((2 * (uint16(b(loc+1)) * 256)) + uint16(b(loc)));
            loc = loc + 3; % skip over the reflectivity byte
         end

         % get the last return
         for J = 1:16
            ed(edIndex).last(J) = double((2 * (uint16(b(loc+1)) * 256)) + uint16(b(loc)));
            loc = loc + 3; % skip over the reflectivity byte
         end
         edIndex = edIndex + 1;
      end
   end % of going through all 151 packets
   
   % convert the raw readings into XYZ coordinates
   % ed is a 1x1812 struct with azimuth, azimuthRadians, strongest, and last
   % strongest and last are 1x16 arrays 

   % go through all angles and interpolate the radians
   % this could be improved.  it is inefficient
   for I = 2:size(ed,2)-2

      t = ed(I-1).azimuthRadians;
      u = ed(I).azimuthRadians;
      if u == t
         ed(I).azimuthRadians = (ed(I+1).azimuthRadians + t)/2; 
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

   XYZpoints = zeros(size(ed,1),3);
   %XYZ2 = zeros(size(ed,1),3);

   %disp('calculating XYZ values');
   index = 1;
   for I = 1:size(ed,2)
      for J = 1:16
         if J == 16 % only give me one line per point cloud
            XYZpoints(index,1) = double(ed(I).last(J)) * cos(angles(J)) * sin(ed(I).azimuthRadians);
            XYZpoints(index,2) = double(ed(I).last(J)) * cos(angles(J)) * cos(ed(I).azimuthRadians);
            XYZpoints(index,3) = double(ed(I).last(J)) * sin(angles(J));
            index = index + 1;
         end
      end
   end
end