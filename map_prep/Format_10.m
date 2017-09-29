% Reimport Excel
uiuc_topo = xlsread('Englewood-1.xlsx');
a = size(uiuc_topo);
uiuc = zeros(a(1),a(2));

for s1 = 1:a(1)
    for s2 = 1:a(2)
        loc = uiuc_topo(s1,s2);
        if loc == 2 || loc == 3 || loc == 5 % If Road, Empty Space, or Park mark as 0
            uiuc(s1,s2) = 0;
        elseif loc == 1 % If Building, mark as 1
            uiuc(s1,s2) = 1;
        else % If something else/unassigned, mark as 3
            uiuc(s1,s2) = 3;
        end
    end
end

% Write to new excel
xlswrite('Englewood-1-10.xlsx', uiuc)
%savefile = 'uiuc_topo.mat';
%save(savefile, 'uiuc_topo');