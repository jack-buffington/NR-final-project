function returnArray = exponentialInterpolateBetweenTwoPoints(startValue, endValue, numberOfSteps)
   
   isFlipped = false;
   if endValue > startValue
      isFlipped = true;
      temp = endValue;
      endValue = startValue;
      startValue = temp;
   end

   
   % this prevents an error where it returns nan for all values
   if endValue ==0
      endValue = .000001;
   end
   
   
   

   divisions = numberOfSteps; % how many points to use
   
   % Figure out at what value you should end at if you start at 1 to have
   % the same percent remaining
   percentRemaining = endValue / startValue; % when compared to original value
   
   % prevent an error when it is interpolating between the same value and
   % it would otherwise return an empty array
   if percentRemaining == 1
      percentRemaining = .9999999;
   end
   
   
   startPoint = 1;
   endPoint = sqrt(1/percentRemaining);

   stepSize = (endPoint-startPoint)/(divisions-1) ;
   
   I = startPoint:stepSize:endPoint;

   returnArray = 1 ./ (I .^ 2);
   returnArray = returnArray * startValue;
   
   if isFlipped == true
      returnArray = fliplr(returnArray);
   end


end
