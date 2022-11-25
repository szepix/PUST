clear all
clc

x0  = [rand*rand*10 rand*rand*10 rand*rand*10];
[zmienne] = fmincon(@fun_PID,x0,[1 0 0; 0 -1 0;0 0 -1],[10 ; 0.001 ; 0 ]);
 