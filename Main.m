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

k = 130;                         % Number of routers
range = 8;                      % Range broadcast range 

factor = .5;                    % Scalar to determine if high-service areas are covered
costAdj = 1;                    % Cost of placing a router adjacent to a building
distPenalty = 2;                % penalty factor for placing routers non-adjacent to a building
pop = 20;
generations = 100;              % maximum number of generations

% Map is 2.15 km east-west, 2 km north-south.
% Router range is 0.09144 km (300 ft).
% Each node space is 0.0028 km, so router range should be ~32 spaces on the
% base map of 734x758 nodes.

% Create random router locations
routers = deployRandRouters(topography, k);
for i = 2:pop
    routers = [routers;deployRandRouters(topography,k)];
end

%% Run coverage

% Function coverage returns which squares are covered (frontier matrix, 1
% and -1 values) and the distance/strength of the coverage at each node.

% w = 1;
% cvr = @(routers) -w*squaresCovered(routers,topography,range,factor) %+ (1-w)*routerCost(routers,topography,costAdj,distPenalty);
% 
% options = optimset('Display','iter','DiffMinChange',1);
% 
% % [routers,fval] = fminunc(cvr,routers,options);
% 


% Anonymous function in order to pass the topography into objective
% function separate from the router positions.

%% Run GA on router placement to maximize coverage
objfun = @(rtr) -1*squaresCovered(rtr, topography, range, factor);
LB = ones(1, 2*k);
UB = [m*ones(1,k), n*ones(1,k)];
IntCon = [1 1]';
options = optimoptions(@ga, ... %'UseVectorized', true, ...
    'InitialPopulationMatrix', routers, 'Display', 'iter', ...
    'PopulationSize', pop, 'MaxGenerations',generations);
nvars = 2*k;

[x,fval,exitflag,output,population,scores] = ...
    ga(objfun, nvars,[],[],[],[],LB,UB,[], IntCon, options);

rnew = reshape(x,[k 2]);
[frontier,distances] = coverage(rnew,topography,range);

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
disp(['Cost: $',num2str(routerCost(x,topography,costAdj,distPenalty))]);

imshow(img);

