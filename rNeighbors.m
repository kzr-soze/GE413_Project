function [frontier,distances] = rNeighbors(topography,range,distances,frontier,point)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    % left and top left diagonal
    x = point(1);
    y = point(2);
    
    dist = distances(x,y);
    [m,n] = size(topography);
    frontier(x,y) = -1; % Mark point as out of range
    if(dist <= range)
        frontier(x,y) = 1; % Mark point as explored
        if (x-1 >= 1)
            if (topography(x-1,y) < 1 && distances(x-1,y) > 1 + dist) 
                frontier(x-1,y) = 0;
                distances(x-1,y) = 1 + dist;
            end
            if (y-1 >= 1)
                if (topography(x-1,y-1) < 1 && distances(x-1,y-1) > sqrt(2)+dist)
                    frontier(x-1,y-1) = 0;
                    distances(x-1,y-1) = dist + sqrt(2);
                end
            end
        end

        % Top and top right diagonal
        if (y-1 >= 1)
            if (topography(x,y-1) < 1 && distances(x,y-1) > dist+1)
                frontier(x,y-1) = 0;
                distances(x,y-1) = dist+1;
            end
            if (x+1 <= m)
                if (topography(x+1,y-1) < 1 && distances(x+1,y-1) > dist+sqrt(2))
                    frontier(x+1,y-1) = 0;
                    distances(x+1,y-1) = dist+sqrt(2);
                end
            end
        end

        % Right and bottom right diagonal
        if (x+1 <= m)
            if (topography(x+1,y) < 1 && distances(x+1,y) > dist+1)
                frontier(x+1,y) = 0;
                distances(x+1,y) = dist+1;
            end
            if (y+1 <= n)
                if (topography(x+1,y+1) < 1 && distances(x+1,y+1) > dist + sqrt(2))
                    frontier(x+1,y+1) = 0;
                    distances(x+1,y+1) = dist+sqrt(2);
                end
            end
        end

        % Bottom and bottom left diagonal
        if (y+1 <= n)
            if (topography(x,y+1) < 1 && distances(x,y+1) > dist + 1)
                frontier(x,y+1) = 0;
                distances(x,y+1) = dist+1;
            end
            if (x-1 >= 1)
                if (topography(x-1,y+1) < 1 && distances(x-1,y+1) > dist+sqrt(2))
                    frontier(x-1,y+1) = 0;
                    distances(x-1,y+1) = dist+sqrt(2);
                end
            end
        end
    end
end

