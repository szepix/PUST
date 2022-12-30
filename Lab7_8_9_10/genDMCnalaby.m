clear all
load('Y1_skok_u1_20.txt')
load('Y2_skok_u1_20.txt')
load('Y2_skok_u2_20.txt')
load('Y1_skok_u2_20.txt')
s11 = Y1_skok_u1_20(15:end);
s21 = Y2_skok_u1_20(15:end);
s12 = Y1_skok_u2_20(7:end);
s22 = Y2_skok_u2_20(7:end);
s11 = s11 - s11(1);
s12 = s12 - s12(1);
s21 = s21 - s21(1);
s22 = s22 - s22(1);
du = 20;
s11 = s11/du;
s12 = s12/du;
s21 = s21/du;
s22 = s22/du;

figure;
hold on;
plot(s11);
plot(s12);
plot(s21);
plot(s22);
legend('s11','s12','s21','s22');

ssize = max(size(s11));
s = cell(0);
row = 2;
col = 2;
for i = 1 : ssize
    snew(1,1) = s11(i);
    snew(1,2) = s12(i);
    snew(2,1) = s21(i);
    snew(2,2) = s22(i);
    s = [s snew];
end
s30 = s(1:end);

nu = 2;
ny = 2;
lambda = [ 1 1];
psi = [ 1 1 ];
D = 430; %tak wychodzi mniej wiecej z rysunkow 
N = 40;
Nu = 40;
% [Ke15, Ku15] = gen_DMC_cheap(nu,ny,lambda,psi,s15,N,Nu,D);
[Ke30, Ku30] = gen_DMC_cheap(nu,ny,lambda,psi,s,N,Nu,D);

for i = 1 :length(Ku30)
    format longG
    Ku1 = "Ku1["+i+"] :=" + sprintf('%.6f',Ku30(1,i)) +";";
%     dlmwrite('KU1.txt', Ku1, '-append');
    writelines(Ku1,"KU1.txt",WriteMode="append");
end

for i = 1 :length(Ku30)
    format longG
    Ku2 = "Ku2["+i+"] :=" +sprintf('%.6f',Ku30(2,i)) + ";";
%     dlmwrite('KU2.txt', Ku2, '-append');
writelines(Ku2,"KU2.txt",WriteMode="append");
end
