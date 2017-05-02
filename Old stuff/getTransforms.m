function [translation, rotation] = getTransforms(bagSelect, fileOffset)
   % gets the TransForms from the tf 'sensor'
   messageList = bagSelect.MessageList;
   
   
   %TODO: Change this to a binary search because it takes a long time.    
   for I = 1:size(messageList,1)
      thisFileOffset = table2array(messageList(I,4));
      if thisFileOffset == fileOffset
         whichMessage = I;
         break
      end
   end
   
   msgs = readMessages(bagSelect,whichMessage); 
   t = msgs{1}.Transforms.Transform.Translation;
   r = msgs{1}.Transforms.Transform.Rotation;
   translation = [t.X t.Y t.Z];
   rotation = [r.W r.X r.Y r.Z];
end