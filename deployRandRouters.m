function [routers] = deployRandRouters(topography, k)
%% Function deployRandRouters
% Initial router position initialization
% Randomly initialize router positions, then check that they are on open
% spaces.
% Use as the population creation function in the GA.
% Returns vector with all x coordinates followed by all y coordinates.

[m,n] = size(topography);
routersmat = [randi(m,k,1),randi(n,k,1)];

% Perform check
index = 1;
while index <= k
    t = topography(routersmat(index,1),routersmat(index,2));
    if (t == 0 || t == 2)
        index = index + 1;
    else
        routersmat(index,1) = randi(m);
        routersmat(index,2) = randi(n);
    end
end

% Turn into row vector
routers = routersmat(:)';

end