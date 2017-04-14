function [ adequate ] = squaresCovered( routers,topography,range,factor )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

    [frontier,distances] = coverage(routers,topography,range);
    [m,n] = size(topography);
    
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
    
end

