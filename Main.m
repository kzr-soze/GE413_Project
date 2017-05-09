%% main.m
clear all; clc; close all;

format long;

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
disp(cover);
[m,n] = size(topography);       % Dimensions of topography                 

k = 350;                         % Number of routers
range = 8;                      % Range broadcast range 

factor = .5;                    % Scalar to determine if high-service areas are covered
costAdj = 1;                    % Cost of placing a router adjacent to a building
distPenalty = 2;                % penalty factor for placing routers non-adjacent to a building
pop = 20;                       % population for GA
generations = 100;              % maximum number of generations for GA
maxStall = 25;                  % maximum number of stalled generations for GA

algo = 2;

% Map is 2.15 km east-west, 2 km north-south.
% Router range is 0.09144 km (300 ft).
% Each node space is 0.0028 km, so router range should be ~32 spaces on the
% base map of 734x758 nodes.

% Create random router locations
routers = deployRandRouters(topography, k,algo);
for i = 2:pop
    routers = [routers;deployRandRouters(topography,k,algo)];
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
if (algo == 1)
    objfun = @(rtr) -1*squaresCovered(rtr, topography, range, factor,algo);
    LB = ones(1, 2*k);
    UB = [m*ones(1,k), n*ones(1,k)];
    IntCon = [1 1]';
elseif (algo == 2)
    objfun = @(rtr) -1*squaresCovered(rtr, topography, range, factor,algo);
    LB = ones(1, 2*k);
    UB = [m,n];
    IntCon = [];
    for index = 2:k
        UB = [UB,m,n];
    end
end
options = optimoptions(@ga, ... %'UseVectorized', true, ...
    'InitialPopulationMatrix', routers, 'Display', 'iter', ...
    'PopulationSize', pop, 'MaxGenerations',generations,'MaxStallGenerations',...
    maxStall,'CrossoverFcn',@crossovertwopoint);
nvars = 2*k;

[x,fval,exitflag,output,population,scores] = ...
    ga(objfun, nvars,[],[],[],[],LB,UB,[], IntCon, options);
if (algo==1)
    rnew = reshape(x,[k 2]);
elseif (algo==2)
    rnew = reshape(x,[2,k])';
end
[frontier,distances] = coverage(rnew,topography,range);

% Draw covered radii around each router in blue.

img = topo2rgb(topography);
for i=1:m
    for j=1:n
        if (frontier(i,j) == 1 && topography(i,j) ~= 2)
            img(i,j,1) = 0;
            img(i,j,2) = 0;
            img(i,j,3) = 1;
        elseif (frontier(i,j) == 1 && distances(i,j) <= range*factor)
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
disp(['Cost: $',num2str(routerCost(rnew,topography,costAdj,distPenalty))]);

imshow(img);

