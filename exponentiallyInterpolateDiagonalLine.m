function buffer = exponentiallyInterpolateDiagonalLine(X,Y,values,buffer)
   deltaX = X(2) - X(1);
   deltaY = Y(2) - Y(1);

   originalX = X;
   
   deltaX = abs(deltaX);
   deltaY = abs(deltaY);
   
   accumulator = 0;
   if deltaX > deltaY
      % then it moves more horizontally
      

      
      [X1,I1] = min(X);
      [X2,I2] = max(X);
      
      pixels = exponentialInterpolateBetweenTwoPoints(values(I1),values(I2),deltaX+1);
      
      if Y(I1,1) > Y(I2,1)
         shouldAdd = false;
      else
         shouldAdd = true;
      end
      
      currentY = Y(I1,1);
      index = 1;
      for X = X1:X2
         [accumulator, rolledOver] = addToAccumulator(deltaY, accumulator, deltaX);
         buffer(currentY,X) = pixels(index); % matlab indexes things as row,column
         index = index + 1;
         if rolledOver == true
            if shouldAdd == true
               currentY = currentY + 1;
            else
               currentY = currentY - 1;
            end
         end
      end
   else
      % it moves more vertically
      
      [Y1,I1] = min(Y);
      [Y2,I2] = max(Y);
      value1 = values(I1);
      value2 = values(I2);
      
      pixels = exponentialInterpolateBetweenTwoPoints(value1,value2,deltaY+1);
      
      if X(I1,1) > X(I2,1)
         shouldAdd = false;
      else
         shouldAdd = true;
      end
      
      currentX = X(I1,1);
      index = 1;
      for Y = Y1:Y2
         [accumulator, rolledOver] = addToAccumulator(deltaX, accumulator, deltaY);
         buffer(Y,currentX) = pixels(index); % matlab indexes things as row,column
         index = index + 1;
         if rolledOver == true
            if shouldAdd == true
               currentX = currentX + 1;
            else
               currentX = currentX - 1;
            end
         end
      end
   end
   
   
   
   
   
   
   
   
   
   
   
   

end % of exponentiallyInterpolateDiagonalLine