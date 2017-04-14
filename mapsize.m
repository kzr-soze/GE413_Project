%% mapresize.m
% Create 1/4, 1/3, and 1/2 representations of the topo map
% Resize by sampling every x number of nodes in each row and column.
clear all; clc; close all;
load map_prep/uiuc_topo.mat

%% Resizing loops
[m,n] = size(uiuc_topo);

uiuc_topo_qtr = uiuc_topo(1:4:m, 1:4:n);

uiuc_topo_thr = uiuc_topo(1:3:m, 1:3:n);

uiuc_topo_half = uiuc_topo(1:2:m, 1:2:n);

%% Comvert to Matlab image and display
t4 = topo2rgb(uiuc_topo_qtr);
t3 = topo2rgb(uiuc_topo_thr);
t2 = topo2rgb(uiuc_topo_half);
t1 = topo2rgb(uiuc_topo);

figure(1); imshow(t4);
figure(2); imshow(t3);
figure(3); imshow(t2);
figure(4); imshow(t1);
