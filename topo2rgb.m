function [topocolor] = topo2rgb(topo)
% FUNCTION TOPO2COLOR
% Accepts the UIUC topography matrix, which has values of -1, 0, 1, and 2
% to denote service areas.
% Converts to RGB colors for easy use with imshow

% -1: no service (red) [255 0 0]
% 0: general (white) [255 255 255]
% 1: buildings (black) [0 0 0]
% 2: high service (green) [0 255 0]

[m,n] = size(topo);
topocolor = zeros(m,n,3);
% Initialize as black.

% Red first - only need to change first matrix along dim3
tempred = topo==-1;
tempred(tempred == 1) = 255;
topocolor(:, :, 1) = tempred;

% Green next - change 2nd matrix along dim3
tempgrn = topo==2;
tempgrn(tempgrn == 1) = 255;
topocolor(:, :, 2) = tempgrn;

% White last - change all matrices along dim3 by addition
tempwht = topo == 0;
tempwht(tempwht == 1) = 255; 
topocolor(:,:,1) = topocolor(:,:,1) + tempwht;
topocolor(:,:,2) = topocolor(:,:,2) + tempwht;
topocolor(:,:,3) = topocolor(:,:,3) + tempwht;
end

