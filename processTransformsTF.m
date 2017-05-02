% loads in the tfetry, processes it, and outputs coordinates and heading,
% which are saved with the time.  

load('tf.mat');

%messagesToProcess = 5000;
messagesToProcess = tf.NumMessages;

odometry = zeros(messagesToProcess,8); % [time X Y Z QX QY QZ QW]

for I = 2:messagesToProcess
   msgs = readMessages(tf,I);
   odometry(I,1) = table2array(tf.MessageList(I,1));
   odometry(I,2) = msgs{1,1}.Transforms(1).Transform.Translation.X;
   odometry(I,3) = msgs{1,1}.Transforms(1).Transform.Translation.Y;
   odometry(I,4) = msgs{1,1}.Transforms(1).Transform.Translation.Z;
   odometry(I,5) = msgs{1,1}.Transforms(1).Transform.Rotation.X;
   odometry(I,6) = msgs{1,1}.Transforms(1).Transform.Rotation.Y;
   odometry(I,7) = msgs{1,1}.Transforms(1).Transform.Rotation.Z;
   odometry(I,8) = msgs{1,1}.Transforms(1).Transform.Rotation.W;
   
   
   % this gives me a diagonal line at about 45 degrees. 
   % process the odometry to get something valid
   odometry(I,2:4) = odometry(I,2:4) + odometry(I-1,2:4);
end



plot(odometry(:,2),odometry(:,3));
%save('correctedOdometry.mat','odometry');
