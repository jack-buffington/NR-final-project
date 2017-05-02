function [translation, rotation] = getTransforms02(bagSelect, fileOffset)
   % gets the TransForms from the lilred_velocity_controller/odom 'sensor'
   messageList = bagSelect.MessageList;
   
   
   %TODO: Change this to a binary search because it takes a long time.    
   for I = 1:size(messageList,1)
      thisFileOffset = table2array(messageList(I,4));
      if thisFileOffset == fileOffset
         whichMessage = I;
         break
      end
   end
   
   % To get to things quickly:
% msgs = readMessages(bs3,1)
% position = msgs{1}.Pose.Pose.Position
% quaternion = msgs{1}.Pose.Pose.Orientation
   
   msgs = readMessages(bagSelect,whichMessage); 
   t = msgs{1}.Pose.Pose.Position;
   r = msgs{1}.Pose.Pose.Orientation;
   translation = [t.X t.Y t.Z];
   rotation = [r.W r.X r.Y r.Z];
end