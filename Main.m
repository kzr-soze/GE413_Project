%% main.m
clear all; clc; close all;

load map_prep/uiuc_topo_qtr.mat;
topography = uiuc_topo_qtr;
% Topography matrix values: 
% -1 no service
% 0  general space
% 1  buildings
% 2  high service

%% Initialize Parameters
% Number of nodes to cover (0 and 2)
cover = sum(topography(:)==0)+sum(topography(:)==2);  
[m,n] = size(topography);       % Dimensions of topography                 
k = 5;                         % Number of routers
range = 8;                      % Range broadcast range 
factor = .5;                    % Scalar to determine if high-service areas are covered
costAdj = 1;                    % Cost of placing a router adjacent to a building
distPenalty = 2;                % penalty factor for placing routers non-adjacent to a building

% Map is 2.15 km east-west, 2 km north-south.
% Router range is 0.09144 km (300 ft).
% Each node space is 0.0028 km, so router range should be ~32 spaces on the
% base map of 734x758 nodes.

%% Initial router position initialization
% Randomly initialize router positions, then check that they are on open
% spaces.
routers = [randi(m,k,1),randi(n,k,1)];
index = 1;
while index <= k
    t = topography(routers(index,1),routers(index,2));
    if (t == 0 || t == 2)
        index = index + 1;
    else
        routers(index,1) = randi(m);
        routers(index,2) = randi(n);
    end
end

%% Run coverage
% Function coverage returns which squares are covered (frontier matrix, 1
% and -1 values) and the distance/strength of the coverage at each node.

w = 1;
cvr = @(routers) -w*squaresCovered(routers,topography,range,factor) %+ (1-w)*routerCost(routers,topography,costAdj,distPenalty);

options = optimset('Display','iter','DiffMinChange',1);

[routers,fval] = fminunc(cvr,routers,options);

[frontier,distances] = coverage(routers,topography,range);

% Draw covered radii around each router in blue.
img = topo2rgb(topography);
for i=1:m
    for j=1:n
        if (frontier(i,j) == 1)
            img(i,j,1) = 0;
            img(i,j,2) = 0;
            img(i,j,3) = 1;
        end
    end
end

%% Calculate percent cover
adequate = 0; % total points with adequate coverage. 
for i = 1:m
    for j = 1:n
        if (topography(i,j) == 0 && distances(i,j) <= range)
            adequate = adequate + 1;
        elseif (topography(i,j) == 2 && distances(i,j) <= (factor*range))
            adequate = adequate + 1;
        end
    end
end
disp([num2str(adequate),' of ',num2str(cover),' areas covered'])
disp([num2str(100*adequate/cover),'% coverage!']);
disp(['Cost: $',num2str(routerCost(routers,topography,costAdj,distPenalty))]);

imshow(img);

% Anonymous function in order to pass the topography into objective
% function separate from the router positions.

        


%imshow(top);