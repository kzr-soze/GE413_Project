% Reads Map
map_color = imread('Loop-3.png');
a = size(map_color);
rroada = 257;
rbuildinga = 249;
rspacea = 225;
rwatera = 165;
groada = 257;
gbuildinga = 238;
gspacea = 225;
gwatera = 206;
broada = 257;
bbuildinga = 217;
bspacea = 225;
bwatera = 257;

rroadm = 253;
rbuildingm = 245;
rspacem = 221;
rwaterm = 161;
groadm = 253;
gbuildingm = 234;
gspacem = 221;
gwaterm = 202;
broadm = 253;
bbuildingm = 213;
bspacem = 221;
bwaterm = 252;
% Converts Map to Grayscale
%map_gray = rgb2gray(map_color);
m1 = map_color;
x = zeros(a(1),a(2));
for s1 = 1:a(1)
    for s2 = 1:a(2)
        r = m1(s1,s2,1);
        g = m1(s1,s2,2);
        b = m1(s1,s2,3);
        if(r>rroadm && r<rroada) && (g>groadm && g<groada) && (b>broadm && b<broada)
            x(s1,s2) = 2;
        elseif (r>230 && r<234 ) && (g>222  && g<226 ) && (b>211  && b<215 )
            x(s1,s2) = 3;
        elseif (r>rspacem && r<rspacea) && (g>gspacem && g<gspacea) && (b>bspacem && b<bspacea)
            x(s1,s2) = 3;
        elseif (r>rwaterm && r<rwatera) && (g>gwaterm && g<gwatera) && (b>bwaterm && b<bwatera)
            x(s1,s2) = 4;
        elseif (r==203) && (g==230) && (b==163)
            x(s1,s2) = 5;
        elseif (r>253 && r<257 ) && (g>210  && g<214 )
            x(s1,s2) = 2;
        elseif (r>250 && r<257 ) && (g>230  && g<240 )
            x(s1,s2) = 2;
        else
            x(s1,s2) = 1;
        end
    end
end
% Everything under 100 to 0 (Black)
%m1(m1 <= 100) = 0;

% Everything over 200 to 255 (White)
%m1(m1 >= 200) = 255;

% Everything under 200 to 0 (Black)
%m1(m1 < 200) = 0;

% Export to Excel
%xls = x;
%xls(xls == 0) = 1; % Buildings = 1
%xls(xls == 255) = 0; % Outide = 0
xlswrite('loop1.xlsx', x)

% Reimport Excel (In this case the sample)
%uiuc_topo = xlsread('uiuc.xlsx');
%savefile = 'uiuc_topo.mat';
%save(savefile, 'uiuc_topo');