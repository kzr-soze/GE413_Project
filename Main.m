%% main.m
% Our main script. For parameters given inside, it initializes a population
% of random router placements and implements a genetic algorithm to
% maximize the amount of coverage they provide based on their placement.
% The algorithm used is specified by algo.


clear all; clc; close all;

format long;

tic;

load loop;
topography = loop;

load traffic;
PT = traffic;
% Topography matrix values: 
% -1 no service
% 0  general space
% 1  buildings
% 2  high service

%% Initialize Parameters

[m,n] = size(topography);      % Dimensions of topography                 
% Number of nodes to cover (0 and 2)
cover = 0;
for i = 1:m
    for j = 1:n
        if (topography(i,j) == 0 || topography(i,j) == 2)
            cover = cover + PT(i,j);
        end
    end
end 
disp(cover);
k = 6;                         % Number of routers
range = 25;                    % Range broadcast range 


TrafficLimit = 35;           % Limit on router capacity
ScaleFactor = (1000*3)/(600);            %Estimate number of cells for each street
factor = .5;                   % Scalar to determine if high-service areas are covered
costAdj = 1;                   % Cost of placing a router adjacent to a building
distPenalty = 2;               % penalty factor for placing routers non-adjacent to a building
pop = 2;                       % population for GA
generations = 1;               % maximum number of generations for GA
maxStall = 25;                 % maximum number of stalled generations for GA

algo = 2;                      % Specifies which representation of routers to use in column vector

% Map is 2.15 km east-west, 2 km north-south.
% Router range is 0.09144 km (300 ft).
% Each node space is 0.0028 km, so router range should be ~32 spaces on the
% base map of 734x758 nodes.

% Create random router locations
routers = deployRandRouters(topography, k,algo);
for i = 2:pop
    routers = [routers;deployRandRouters(topography,k,algo)];
end


%% Run GA on router placement to maximize coverage
if (algo == 1)
    objfun = @(rtr) -1*squaresCovered(rtr, topography, range, factor, algo, PT, TrafficLimit, ScaleFactor);
    LB = ones(1, 2*k);
    UB = [m*ones(1,k), n*ones(1,k)];
    IntCon = []';
elseif (algo == 2)
    objfun = @(rtr) -1*squaresCovered(rtr, topography, range, factor, algo, PT, TrafficLimit, ScaleFactor);
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

% Reshape final vector into more natural matrix shape
if (algo==1)
    rnew = reshape(x,[k 2]);
elseif (algo==2)
    rnew = reshape(x,[2,k])';
end
[frontier,distances,tr] = coverage(rnew,topography,range, PT, TrafficLimit, ScaleFactor);

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
            adequate = adequate + PT(i,j);
        elseif (topography(i,j) == 2 && distances(i,j) <= (factor*range))
            adequate = adequate + PT(i,j);
        end
    end
end
    
    
disp([num2str(adequate),' of ',num2str(cover),' areas covered'])
disp([num2str(100*adequate/cover),'% coverage!']);
disp(['Cost: $',num2str(routerCost(rnew,topography,costAdj,distPenalty))]);
disp(['Elapsed Computational Time: ',num2str(toc),' seconds']);


imshow(img);

