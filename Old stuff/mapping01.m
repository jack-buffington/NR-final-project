% RUN THIS FIRST
% It takes a while to run
clear;
disp('starting');
bag = rosbag('C:\Big stuff\highbay.bag');
disp('done');


bs = select(bag,'Topic','velodyne_packets');
msgs = readMessages(bs,1);  % read only the first velodyne packet


save('messages.mat','msgs');



% Run this then 
% extractRawData.m then
% convertExtractedDatatoXYZ



