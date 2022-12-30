function [Ke, Ku] = gen_DMC_cheap(nu,ny,lambda,psi,s,N,Nu,D)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
struct = gen_DMC(nu,ny,lambda,psi,s,N,Nu,D);
N=struct.N;
Nu = struct.Nu;
K = struct.K;
Mp = struct.Mp;
nu = nu;
ny = ny;
KeTemp = K(1:nu,:);
Ku =KeTemp * Mp ;
KeTempLen = max(size(KeTemp));
MpTemp = Mp(1:nu,:);
for i = 1:nu
    for j = 1:ny
        Ke(i,j) = sum(KeTemp(i,j:ny:N*ny));
    end
end

end

