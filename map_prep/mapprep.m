%% mapprep.m
% GE 413 Project - S. Cai, T. Murray
% 
% Process b&w UIUC building map into usable graph for project. First accept
% image and reprocess to leave building footprings only - get rid of text
% and roads. Then process to define types:
% 0 - outdoor, basic (moderate) service level
% 1 - building
% -1 - outdoor, lowest service level
% 2 - outdoor, highest service level 
%% Initial Read
map_covered = imread('images\uiuc-map_covered.png');
map_cbw = rgb2gray(map_covered);

%% Initial Processing
% Need to get rid of streets, labels, extraneous items.
% First set everything under 100 to zero (black)
m1 = map_cbw;
m1(m1 <= 100) = 0;

% Try setting everything over 200 to 255 (white)
m1(m1>= 200) = 255; % still looks ok

% Try setting everything under 200 to zero (black) - now full b&w
m1(m1<200) = 0;

% Export to excel for fine-tuning
m1xls = m1;
m1xls(m1xls == 0) = 1;
m1xls(m1xls == 255) = 0;
xlswrite('m1xls.xlsx', m1xls)


%% Re-import to Matlab
% Cleaned up map and added levels of service in Excel
% Excel file has conditional formatting for coloring

uiuc_topo = xlsread('uiuc.xlsx');
% Dim: 734x758, which is correct.
savefile = 'uiuc_topo.mat';
save(savefile, 'uiuc_topo');


