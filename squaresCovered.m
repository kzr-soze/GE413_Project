function [adequate] = squaresCovered( routersv,topography,range,factor, algo, PT, TrafficLimit, ScaleFactor )
%squaresCovered: Calculates the number of cells in the topography matrix
%which receive adequate coverage. Initializes the covered areas around each
%router, then calls coverage to calculate the full value.

    % Reshape vector input for routers into k x 2 matrix
    k = numel(routersv) / 2;
    if (algo==1)
        routers = reshape(routersv, [k 2]);
    elseif (algo==2)
        routers = reshape(routersv, [2,k])';
    else
        error('Invalid algorithm');
    end

    [frontier,distances,tr] = coverage(routers,topography,range, PT, TrafficLimit, ScaleFactor);
    [m,n] = size(topography);
    
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
    
end

