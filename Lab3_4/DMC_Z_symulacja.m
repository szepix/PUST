clear
%Okres próbkowania
Tp = 1;
values = importdata("skok_46.txt");
s = zeros(1,500);

for i = 1:500
    s(i) = (values(i) - values(1))/20;
end

values_z = importdata("skok_z_30.txt");
s_z = zeros(1,400);
for i=1:400
    s_z(i) = (values(i) - values(1))/30;
end

%Parametry modelu
b2 = 0.0015;
b1 = 9.7778e-04;
a2 = 0.3195;
a1 = -1.3121;

%Horyzonty
D = 400; %Horyzont Dynamiki
Dz = 400; %Horyzont Dynamiki toru Z
N= 20;    %Horyzont predykcji
Nu = 20; %Horyzont sterowania

%Współczynnik kary
lamb = 0.3;

kk = 1401; %koniec symulacji
kp = max(13,D+1); %początek symulacji
ks = max(19,D+7); %chwila skoku wartosci zadania
k = D+1;
%War początkowe
u(1:kp) = 0; y(1:kp) = 0;
yzad(k:500+k) = 1;
yzad(500+k:1000+k) = 1;
e(1:kp) = 0;

%Macierz M
M=zeros(N,Nu);
for i=1:N
   for j=1:Nu
      if (i>=j)
         M(i,j)=s(i-j+1);
      end
   end
end

%Macierz MP
MP=zeros(N,D-1);
for i=1:N
   for j=1:D-1
      if i+j<=D
         MP(i,j)=s(i+j)-s(j);
      else
         MP(i,j)=s(D)-s(j);
      end      
   end
end

MZP = zeros(N, Dz-1);
for i=1:N
   for j=1:Dz-1
      if i+j<=Dz
      MZP(i,j)=s_z(i+j)-s_z(j);
      else
      MZP(i,j)=s(Dz)-s(j);
      end
   end
end

K = ((M'*M + lamb * eye(Nu))^(-1))* M';
DUp = zeros(D-1, 1);
dZ = zeros(Dz-1, 1);
Z = zeros(k+1000,1);
Z(k+300:k+450) = 30;

T1 = 5.7461;
T2 = 77.9459;
K=0.1415;
Td=10;
alpha1 = exp(-1/T1);
alpha2 = exp(-1/T2);
a1_z = -alpha1-alpha2;
a2_z = alpha1 * alpha2;
b1_z = K*(T1*(1-alpha1)-T2*(1-alpha2))/(T1-T2);
b2_z = K*(alpha1*T2*(1-alpha2)-alpha2*T1*(1-alpha1))/(T1-T2);


Y = zeros(N,1);
%główne wykonanie programu
for k=kp:kk
    for n=1:N
    %yzad dla horyzontu predykcji
        Y_zad(n,1) = yzad(k);
    end
    %symulacja obiektu
    y(k)=b1*u(k-Td - 1)+b2*u(k-Td - 2)-a1*y(k-1)-a2*y(k-2)+b1_z*Z(k-Td - 1)+b2_z*Z(k-Td - 2);
%     y(k) = y(k) + y_z(k);

    %stała trajektoria referencyjna
    for n=1:N
        Y(n) = y(k);
    end
    %DMC
    for n = 1:D-1
        DUp(n) = u(k-n) - u(k-n-1);
    end
    for n = 1:Dz-1
        dZ(n) = Z(k-n) - Z(k-n-1); 
    end
    Yo = MP*DUp+Y+MZP*dZ;
    DU = K*(Y_zad - Yo);
    u(k)=u(k-1)+DU(1); 
    if(u(k)> 100)
        u(k) = 100;
    end
    if(u(k)< 0)
        u(k) = 0;
    end
    wejscie_u(k)=u(k);
    wyjscie_y(k)=y(k); 
end


iteracja = 0:1:kk-1;  
%Plot wyjście
figure;
stairs(iteracja, wyjscie_y)
hold on;
stairs(iteracja, yzad);
hold off;
title("Odpowiedź skokowa układu z regulatorem DMC" + newline + "D = " + D + " N = " + N + " Nu = " + Nu +  " lambda = " + lamb); 
xlabel('k'); ylabel("y");
legend("Opowiedź z regulatorem","Wartość zadana", "Location", "southeast")
name1 = "zad5_DMC_y_D"+D+"_N"+N+"_Nu"+Nu+"_L"+lamb;
% print(name1,'-dpng','-r400')

%Plot sterowanie
figure;
stairs(iteracja, wejscie_u)
title("Sterowanie układu z regulatorem DMC" + newline + "D = " + D + " N = " + N + " Nu = " + Nu + " lambda = " + lamb); 
xlabel('k'); ylabel("u");
legend("Sterowanie regulatora", "Location", "best")
name2 = "zad5_DMC_u_D"+D+"_N"+N+"_Nu"+Nu+"_L"+lamb;
% print(name2,'-dpng','-r400')
figure
plot(Z)