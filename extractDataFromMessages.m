%function ed = extractDataFromMessages(bagSelect, whichMessage)
 
function ed = extractDataFromMessages(bagSelect, fileOffset)
   % figure out which message has the required file offset
   messageList = bagSelect.MessageList;
   for I = 1:size(messageList,1)
      thisFileOffset = table2array(messageList(I,4));
      if thisFileOffset == fileOffset
         whichMessage = I;
         break
      end
   end

   msgs = readMessages(bagSelect,whichMessage); 
   a = msgs{1}.Packets; % 151x1 velodyne packets
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
   end % of going through all 151 packets
end
  