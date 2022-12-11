clear; clc;

file = load("odp_skok.mat");
s = file.Y;

%% Parametry regulatora
Nu = 2.000;
N = 16.000;
D = 60;
lamb = 0.1614;

%% Wyznaczanie macierzy oraz innych parametrów regulatora

%Wyznaczanie macierzy M
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

K = ((M'*M + lamb * eye(Nu))^(-1))* M';
DUp = zeros(D-1, 1);
Y = zeros(N,1);

%% Warunki początkowe symulacji

kp = 150; %początek symulacji
kk = 650; %koniec symulacji

u(1:kp) = 0; 
y(1:kp) = 0;

yzad(1:kp) = 0;
yzad(kp:350) = 10;
yzad(350:kk-100) = 5;
yzad(kk-100:kk) = -0.25;


e = 0;

u_max = 1;
u_min = -1;

%% Głowne wykonanie programu

for k=kp:kk
    for n=1:N
    %yzad dla horyzontu predykcji
        Y_zad(n,1) = yzad(k);
    end
    %symulacja obiektu
    y(k) = symulacja_obiektu1y_p3(u(k-5),u(k-6),y(k-1),y(k-2));
    
    %stała trajektoria referencyjna
    for n=1:N
        Y(n) = y(k);
    end
    
    %DMC
    for n = 1:D-1
        DUp(n) = u(k-n) - u(k-n-1);
    end

    Yo = MP*DUp+Y;

    DU = K*(Y_zad - Yo);
        
    u(k)=u(k-1)+DU(1);  
    
    if u(k) > u_max
        u(k) = u_max;
    elseif u(k) < u_min
        u(k) = u_min;
    end

    e = e + (yzad(k) - y(k))^2;

end

display(e)

iteracja = 0:1:kk-1;  
%Plot wyjście
figure;
stairs(iteracja, y)
hold on;
stairs(iteracja, yzad,"--");
hold off;
title("Odpowiedź skokowa układu z regulatorem DMC" + newline + "D = " + D + " N = " + N + " Nu = " + Nu +  " lambda = " + lamb + " error = " + e ); 
xlabel('k'); ylabel("y");
legend("y","y_z_a_d", "Location", "northeast")

%Plot sterowanie
figure;
stairs(iteracja, u)
title("Sterowanie układu z regulatorem DMC" + newline + "D = " + D + " N = " + N + " Nu = " + Nu + " lambda = " + lamb); 
xlabel('k'); ylabel("u");
legend("Sterowanie regulatora", "Location", "best")