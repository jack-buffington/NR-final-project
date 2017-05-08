function buffer = exponentiallyFillInTheGaps(buffer)
   width = size(buffer,2);
   height = size(buffer,1);

   % scan through each row and find pixels that aren't -1 and interpolate
   % between them.
   for Y = 1:height
      pixelsFound = 0;
      for X = 1:width
         if buffer(Y,X) ~= -1
            if pixelsFound == 0
               pixel1 = X;
               pixelsFound = pixelsFound + 1;
            elseif pixelsFound == 1
               if pixel1 == X - 1 % keep shifting pixel1 if there are consecutive non -1 pixels
                  pixel1 = X;
               else
                  pixel2 = X;
                  pixelsFound = pixelsFound + 1;
               end
            end % of if pixelsFound == 0
         end % of if this isn't a -1 pixel
      end % of scanning through X
      
      % now do the interpolation
      
      

      % now do the interpolation
      if pixelsFound == 2
         pixel1Value = buffer(Y,pixel1);
         pixel2Value = buffer(Y,pixel2); 
         buffer(Y,pixel1:pixel2) = exponentialInterpolateBetweenTwoPoints(pixel1Value,pixel2Value,pixel2-pixel1+1);
      end
   end % of going through Y

end