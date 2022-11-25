clear all; clc

A = [1 0 0;0 1 0;0 0 1];
B = [100 ; 100 ; 10000];
opts = optimoptions('ga','PlotFcn',@gaplotbestf);
intcon = 1;
x = ga(@fun_DMC,3,A,B,[],[],[2 2 0.1], [100 100 100],[],[1 2]);
display(x)
