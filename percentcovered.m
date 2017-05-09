function [ output_args ] = percentcovered( file,topography,factor,range,costAdj,distPenalty )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    cover = 14425;
    [m,n] = size(topography);
    filename = ['results/',file];
    temp = (load(filename));
    rnew = temp.x;
    [frontier,distances] = coverage(rnew,topography,range);
    
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

end

