clear all
clc

load map_prep/uiuc_topo.mat;
topography = uiuc_topo;
% -1 no service
% 0  general space
% 1  buildings
% 2  high service

%%Parameters
cover = sum(topography(:)==0)+sum(topography(:)==2);  % Number of non-building spaces to be covered
[m,n] = size(topography);       % Dimensions of topography
k = 50;                         % Number of routers
range = 13;                     
factor = .5;                    % Scalar to determine if high-service areas are covered

% Randomly initialize router positions, then check that they are on open
% spaces.
routers = [randi(m,k,1),randi(n,k,1)];

index = 1;
while index <= k
    t = topography(routers(index,1),routers(index,2));
    if (t == 0 || t == 2)
        index = index + 1;
    else
        routers(index,1) = randi(m);
        routers(index,2) = randi(n);
    end
end

[frontier,distances] = coverage(routers,topography,range);

img = topo2rgb(topography);
for i=1:m
    for j=1:n
        if (frontier(i,j) == 1)
            img(i,j,1) = 0;
            img(i,j,2) = 0;
            img(i,j,3) = 1;
        end
    end
end

adequate = 0;
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

imshow(img);

% Anonymous function in order to pass the topography into objective
% function separate from the router positions.
% cvr = @(x) coverage(x,topgraphy)


        


%imshow(top);