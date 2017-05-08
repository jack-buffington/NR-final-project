function [accumulator, rolledOver] = addToAccumulator(addValue, currentValue, maxValue)
   currentValue = currentValue + addValue;
   rolledOver = false;
   if currentValue >= maxValue
      rolledOver = true;
      accumulator = currentValue - maxValue;
   else
      accumulator = currentValue;
   end
end