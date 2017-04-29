% msgs = readMessages(odom,1);
% X = msgs{1}.Pose.Pose.Position.X;

load('odom.mat');

X = zeros(odom.NumMessages,1);
Y = zeros(odom.NumMessages,1);
Z = zeros(odom.NumMessages,1);

for I = 1:odom.NumMessages
   msgs = readMessages(odom,I);
   X(I) = msgs{1}.Pose.Pose.Position.X;
   Y(I) = msgs{1}.Pose.Pose.Position.Y;
   Z(I) = msgs{1}.Pose.Pose.Position.Z;
end
figure
plot3(X,Y,Z);