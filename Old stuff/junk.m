%  v = linspace(1,1.5,20);
%  A = kron(v,[1 2 3]')';
%  
%  A(18:20,:) = 0;  % make a gap
%  A(1:2,:) = 0;  % make a gap
%  
%  B = fixGaps(A);
%  
%  figure(1)
%  plot(B)
%  
%  
%  
 




% x = 0:.01:2*pi 
% 
% distances = sin(3*x)';
% 
% figure
% plot(distances);
% hold on
% extrema = findExtrema(distances);
% 
% for M = 1:size(extrema,1)
%    line([extrema(M,1);extrema(M,1)],[min(distances);max(distances)],'Color',[.8 .8 0]);
% end


noise = rand(30,2);

points = zeros(60,2);

for I = 1:30
   points(I,:) = noise(I,:) + [10 4];
   points(I+30,:) = noise(I,:) + [4 10]; 
end

plot(points(:,1), points(:,2),'.');

[groupNumbers, centroids] = kmeans(points,2)


