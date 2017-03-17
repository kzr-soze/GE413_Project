clear all

topography = round((xlsread('uiuc.xlsx')-.25));
% -1 no service
% 0  general space
% 1  buildings
% 2  high service

%%Parameters
cover = sum(topography(:)==0);  % Number of non-building spaces to be covered
[m,n] = size(topography);       % Dimensions of topography
k = 30;                         % Number of routers
range = 15;                     

% Randomly initialize router positions, then check that they are on open
% spaces.
routers = [randi(m,k,1),randi(n,k,1)];

index = 1;
while index <= k
    if (topography(routers(index,1),routers(index,2)) == 0)
        index = index + 1;
    else
        routers(index,1) = randi(m);
        routers(index,2) = randi(n);
    end
end

[frontier,distances] = coverage(routers,topography,range);

img = zeros(m,n);
for i=1:m
    for j=1:n
        if (frontier(i,j) == 1)
            img(i,j) = 0.5;
        elseif (topography(i,j) == 1)
            img(i,j) = 1;
        end
    end
end

imshow((img-1)*-1);

% Anonymous function in order to pass the topography into objective
% function separate from the router positions.
% cvr = @(x) coverage(x,topgraphy)


        


%imshow(top);