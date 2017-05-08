function theColors = makeLookupTable()
   % make a color lookup table
   theColors = zeros(256,3);
   
   theColors(1,:) = [0 0 0]; 
   
   % this is a simple color wheel
   
   for I = 1:51 % violet to blue   2:52
      theColors(I+1,:) = [.5-((I/51)*.5) 0 .7+(I/51)*.3];
   end
   
   for I = 1:25 % blue to aquamarine   53:77
      theColors(I+52,:) = [0 I/25 1];
   end
   for I = 1:26 % aquamarine to green   77:103
      theColors(I+77,:) = [0 1 (1-I/26)];
   end
   
   for I = 1:51 % green to yellow   104:154
      theColors(I+103,:) = [I/51 1 0];
   end
   for I = 1:102 % yellow to orange to red 155:205
      theColors(I+154,:) = [1 1-(I/102) 0];
   end
end