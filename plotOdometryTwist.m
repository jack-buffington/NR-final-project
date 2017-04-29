% msgs = readMessages(odom,1);
% X = msgs{1}.Pose.Pose.Position.X;

load('odom.mat');

X = zeros(odom.NumMessages,1);
Y = zeros(odom.NumMessages,1);
Z = zeros(odom.NumMessages,1);
T = zeros(odom.NumMessages,1);
R = zeros(odom.NumMessages,1);

msgs = readMessages(odom,1:odom.NumMessages);
for I = 1:odom.NumMessages
   T(I) = msgs{I}.Twist.Twist.Linear.X;
   R(I) = msgs{I}.Twist.Twist.Angular.Z;
end

% Convert T & R into XYZ coordinates
currentRotation = 0;
currentX = 0;
currentY = 0;

for I = 1:odom.NumMessages
   currentRotation = currentRotation + R(I)*0.02*.58; %.58 ~works for lawnmower
   deltaX = cos(currentRotation) * T(I)*0.02; % This makes spirals
   deltaY = sin(currentRotation) * T(I)*0.02;
   X(I) = currentX + deltaX;
   Y(I) = currentY + deltaY;
   currentX = currentX + deltaX;
   currentY = currentY + deltaY;
end
figure
plot(X,Y);
axis equal

save('correctedOdometry.mat','X','Y');

% clf
% plot(T);
% hold on
% plot(R);
%plot3(X,Y,Z);