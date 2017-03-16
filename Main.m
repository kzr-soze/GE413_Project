clear all

topography = (xlsread('uiuc.xlsx')-1)*-1;

%%Parameters
cover = sum(topography(:)==0);  % Number of non-building spaces to be covered
[m,n] = size(topography);       % Dimensions of topography
k = 50;                         % Number of routers
range = 40;                     


imshow(top);