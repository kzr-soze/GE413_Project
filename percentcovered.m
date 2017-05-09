function [ output_args ] = percentcovered( file,topography,factor,range,costAdj,distPenalty,algo)
%percentcovered: loads a router placement from a file and calculates the
%   percent of the topography it covers for the other given parameters.
%   Operates on the quarter-size topography.

    cover = 14425;
    [m,n] = size(topography);
    filename = ['results/',file];
    temp = (load(filename));
    rnew = temp.x;
    k = size(rnew,2)/2;
    disp(k);
    if (algo==1)
        rnew = reshape(rnew,[k 2]);
    elseif (algo==2)
        rnew = reshape(rnew,[2,k])';
    end
    
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

