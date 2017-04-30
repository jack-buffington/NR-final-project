function index = findOffsetIndex(vec1, vec2)
   % Repeatedly rotates vec2 up and finds the sum of the
   % differences between vec1 and vec2
   % index is the value that should be in position 1
 

   results = zeros(size(vec1));
   
   for I = 1:size(vec1,1)
      temp = vec1 - vec2;
      results(I) = sum(temp .* temp);
      vec2 = [vec2(2:end);vec2(1)];
   end
%    subplot(2,3,4)
%    plot(results)
   [~, index] = min(results); 
end