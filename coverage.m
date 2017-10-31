function [frontier,distances,tr] = coverage( routers,topography,range, PT, TrafficLimit, ScaleFactor )
% FUNCTION COVERAGE
% Determines which squares in topgraphy are covered by a router using
% Dijkstra's algorithm. Outputs:
% frontier: m by n matrix of explored points
% distances: m by n matrix of distances at each point to the nearest
%   router. Infinity if unexplored.
    k = size(routers,1);
    [m,n] = size(topography);
    frontier = zeros(m,n)-1;
    distances = zeros(m,n)+m*n;
    tr = zeros(k);
    % Find all nodes within distance range of each router
    for i = 1:k
        x = round(routers(i,1));
        y = round(routers(i,2));
        frontier(x,y) = 1;
        distances(x,y) = 0;
        
        % Initialize the frontier around each router
        % left and top left diagonal
        if (x-1 >= 1)
            if (topography(x-1,y) ~= 1)
                frontier(x-1,y) = 0;
                distances(x-1,y) = 1;
            end
            if (y-1 >= 1)
                if (topography(x-1,y-1) ~= 1)
                    frontier(x-1,y-1) = 0;
                    distances(x-1,y-1) = sqrt(2);
                end
            end
        end
        
        % Top and top right diagonal
        if (y-1 >= 1)
            if (topography(x,y-1) ~= 1)
                frontier(x,y-1) = 0;
                distances(x,y-1) = 1;
            end
            if (x+1 <= m)
                if (topography(x+1,y-1) ~= 1)
                    frontier(x+1,y-1) = 0;
                    distances(x+1,y-1) = sqrt(2);
                end
            end
        end
        
        % Right and bottom right diagonal
        if (x+1 <= m)
            if (topography(x+1,y) ~= 1)
                frontier(x+1,y) = 0;
                distances(x+1,y) = 1;
            end
            if (y+1 <= n)
                if (topography(x+1,y+1) ~= 1)
                    frontier(x+1,y+1) = 0;
                    distances(x+1,y+1) = sqrt(2);
                end
            end
        end
        
        % Bottom and bottom left diagonal
        if (y+1 <= n)
            if (topography(x,y+1) ~= 1)
                frontier(x,y+1) = 0;
                distances(x,y+1) = 1;
            end
            if (x-1 >= 1)
                if (topography(x-1,y+1) ~= 1)
                    frontier(x-1,y+1) = 0;
                    distances(x-1,y+1) = sqrt(2);
                end
            end
        end
        
        while (sum(frontier(:)==0)>0)
            logical = frontier==0;
            front = logical.*distances;
            point = [-1,-1];
            M = intmax;
            
            for l=1:m % Find smallest element in frontier
                for j=1:n
                    if (front(l,j) > 0 && front(l,j) < M)
                        point = [l,j];
                        M = front(l,j);
                    end
                end
            end
            if (M < intmax)
                [frontier,distances,tr] = rNeighbors(topography,range,distances,frontier,point, PT, TrafficLimit, ScaleFactor, tr,i);         
            end
        end
    end  
end

