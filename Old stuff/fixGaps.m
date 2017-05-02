
function XYZ = fixGaps(XYZ)
   % searches through the data looking for gaps.   When it finds a gap, it
   % linearly interpolates over the gap.  
   lastData = scanForData(XYZ,1);
   firstData = lastData;
   
   stillWorking = true;
   
   % discover and fix gaps in the middle of the data
   while stillWorking == true
      gapStart = scanForGaps(XYZ, lastData);
      if gapStart == -1
         % It didn't find any gaps.
         lastData = size(XYZ,1);
         stillWorking = false;
      else
         % it found a gap
         % search for the next good data
         gapEnd = scanForData(XYZ,gapStart + 1);
         if gapEnd == -1
            % the gap ran to the end of the data file
            stillWorking = false;
            lastData = gapStart;
         else % it found an end to the gap
            lastData = gapEnd;
            disp('Found gap in middle.');
            % linearly interpolate between the two values
            V=linspace(0,1,gapEnd-gapStart + 1);
            interp = (kron(1-V,XYZ(gapStart,:)') + kron(V,XYZ(gapEnd,:)'))';
            XYZ(gapStart:gapEnd,:) = interp;
         end
      end
   end % of while still working
   
   
   
   
   % Fix gaps at the beginning, end or both.
   if firstData ~= 1
      if lastData ~= size(XYZ,1)
         % the gap wraps around both ends
         disp('Found gap that wraps around.');
         V=linspace(0,1,size(XYZ,1)-lastData + 1 + firstData);
         interp = (kron(1-V,XYZ(lastData,:)') + kron(V,XYZ(firstData,:)'))';
         XYZ(lastData:end,:) = interp(1:size(XYZ,1)-lastData + 1,:);
         XYZ(1:firstData,:) = interp(size(XYZ,1)-lastData + 2:end,:);
      else
         % the gap is only at the beginning.
         disp('Found gap at beginning.');
         V=linspace(0,1,firstData+1);
         interp = (kron(1-V,XYZ(end,:)') + kron(V,XYZ(firstData,:)'))';
         XYZ(1:firstData,:) = interp(2:end,:);
      end
   else
      if lastData ~= size(XYZ,1)
         % there was a gap at the end only
         disp('Found gap at the end.');
         V=linspace(0,1,size(XYZ,1)-lastData + 2);
         interp = (kron(1-V,XYZ(lastData,:)') + kron(V,XYZ(1,:)'))';
         XYZ(lastData:size(XYZ,1),:) = interp(1:end-1,:);
      end
   end
end


function index = scanForData(XYZ, startIndex)
   % returns the index of the first good data if it finds good data
   % returns -1 if it didn't
   index = -1;
   for I = startIndex:size(XYZ,1)
      if XYZ(I,1) ~= 0 || ...
         XYZ(I,2) ~= 0 || ...
         XYZ(I,3) ~= 0
         
         index = I;
         break
      end
   end
end

function index = scanForGaps(XYZ, startIndex)
   % returns the index of the last good data if it finds a gap
   % returns -1 if it didn't find a gap 
   index = 0;
   for I = startIndex:size(XYZ,1)
      if XYZ(I,1) == [0 0 0]
         index = I;
         break
      end
   end
   index = index - 1;
end




