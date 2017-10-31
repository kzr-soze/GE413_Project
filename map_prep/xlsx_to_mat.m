traffic = xlsread('Loop-Traffic.xlsx');
% Dim: 734x758, which is correct.
savefile = 'traffic.mat';
save(savefile, 'traffic');
