function [frontier,distances] = coverage( routers,topography,range )
%Determines which squares in topgraphy are covered by a router using
%   Dijkstra's algorithm.
    k = size(routers,1);
    [m,n] = size(topography);
    frontier = zeros(m,n)-1;
    distances = zeros(m,n)+m*n;
    
    % Find all nodes within distance range of each router
    for i = 1:k
        disp(['Router: ',num2str(i)]);
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
        if (x+1 >= 1)
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
            if (x-1 >= 0)
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
                [frontier,distances] = rNeighbors(topography,range,distances,frontier,point);         
            end
        end
    end  
  %  disp(distances);
  %  disp(frontier);
end

