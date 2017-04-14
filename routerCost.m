function [cost] = routerCost(routers,topography,costAdj,distPenalty)
%routerCost: Calculates the cost of placing routers at their positions
%given topography. costAdj is the cost of placing a router adjacent to a
%building, costDist is the cost of placing it non-adjacent to a building.
    
    [m,n] = size(topography);
    N = size(routers,1);
    cost = 0;
    for k = 1:N
        x = routers(k,1);
        y = routers(k,2);
        go = true;
        if (x-1 >= 1)
            if (topography(x-1,y) == 1)
                cost = cost + costAdj;
                go = false;
            end
            if (y-1 >= 1 && go)
                if (topography(x-1,y-1) == 1)
                    cost = cost + costAdj;
                    go = false;
                end
            end
        end
        
        % Top and top right diagonal
        if (y-1 >= 1 && go)
            if (topography(x,y-1) == 1)
                cost = cost + costAdj;
                go = false;
            end
            if (x+1 <= m && go)
                if (topography(x+1,y-1) == 1)
                    cost = cost + costAdj;
                    go = false;
                end
            end
        end
        
        % Right and bottom right diagonal
        if (x+1 <= m && go)
            if (topography(x+1,y) == 1)
                cost = cost + costAdj;
                go = false;
            end
            if (y+1 <= n && go)
                if (topography(x+1,y+1) == 1)
                    cost = cost + costAdj;
                    go = false;
                end
            end
        end
        
        % Bottom and bottom left diagonal
        if (y+1 <= n && go)
            if (topography(x,y+1) == 1)
                cost = cost + costAdj;
                go = false;
            end
            if (x-1 >= 1 && go)
                if (topography(x-1,y+1) == 1)
                    cost = cost + costAdj;
                    go = false;
                end
            end
        end
        
        % router is non-adjacent
        if (go)
            cost = cost + distPenalty*costAdj;
        end
    end
        
    

end

