% msgs = readMessages(odom,1);
% X = msgs{1}.Pose.Pose.Position.X;
clear
load('tf.mat');

X = zeros(tf.NumMessages,1);
Y = zeros(tf.NumMessages,1);
Z = zeros(tf.NumMessages,1);

%for I = 1:int32(tf.NumMessages/300):tf.NumMessages
for I = 1:1000
   msgs = readMessages(tf,I);
   X(I) = msgs{1}.Transforms(1).Transform.Translation.X;
   Y(I) = msgs{1}.Transforms(1).Transform.Translation.Y;
   Z(I) = msgs{1}.Transforms(1).Transform.Translation.Z;
end

plot3(X,Y,Z);
drawnow

% for I = 1:int32(tf.NumMessages/300):tf.NumMessages
%    msgs = readMessages(tf,I);
%    X(I) = msgs{1}.Transforms(2).Transform.Translation.X;
%    Y(I) = msgs{1}.Transforms(2).Transform.Translation.Y;
%    Z(I) = msgs{1}.Transforms(2).Transform.Translation.Z;
% end
% 
% plot3(X,Y,Z);
% drawnow