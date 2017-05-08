function image = exponentiallyInterpolateTriangle(X,Y,values,image)
   % linearly interpolates to fill in a triangle given by the three arrays
    % X,Y,values are Nx1 arrays
    % image is a matrix that the triangle will be drawn into
    
   % draw into a buffer first and then copy it into the image
   buffer = ones(max(Y)-min(Y)+1, max(X)-min(X)+1) * -1;
   
   minX = min(X);
   minY = min(Y);
   
   X = X - minX + 1;
   Y = Y - minY + 1;
   
   % draw the first line segment of the triangle
   % first determine if it is more horizontal or more vertical
   buffer = exponentiallyInterpolateDiagonalLine(X(1:2,1),Y(1:2,1),values(1:2,1),buffer);
   buffer = exponentiallyInterpolateDiagonalLine(X(2:3,1),Y(2:3,1),values(2:3,1),buffer);
   buffer = exponentiallyInterpolateDiagonalLine([X(1,1);X(3,1)],[Y(1,1);Y(3,1)],[values(1,1);values(3,1)],buffer);
   
   % now fill in all of the gaps between filled in pixels
    buffer = exponentiallyFillInTheGaps(buffer);

   % copy all of the non-zero values from the buffer into the image
   for X = 1:size(buffer,2)
      for Y = 1:size(buffer,1)
         if buffer(Y,X) ~= -1
            image(Y+minY, X+minX) = buffer(Y,X);
         end
      end % of going through Y
   end % of going through X
   
end  


   
