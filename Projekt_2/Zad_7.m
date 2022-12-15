clear all; clc;
%% Parametry Regulatora

Tp = 0.5; %Czas próbkowania
D = 150; %Horyzont Dynamiki
Dz = 70; %Horyzont Dynamiki toru Z
N= 30;    %Horyzont predykcji
Nu = 3; %Horyzont sterowania

s = load("Odp_skokowe\odp_skok_u.mat").Y;
s_z = load("Odp_skokowe\odp_skok_z.mat").Y;

%Współczynnik kary
lamb = 7;


sav = true;

%Czas trwania symulacji
kp = D+1; %początek symulacji
kk = 800; %koniec symulacji

%Warunki początkowe
u(1:kp) = 0; 
y(1:kp) = 0;
z(1:kk) = 0;

%Skoki wart zadanej
yzad(1:kp) = 0;
yzad(kp+50:kk) = 1;

%Skoki zakłócenia
% Z(1:kk)=sin(linspace(0,pi*10,kk));
z(1:kk) = 0;
% zaklocenie = wgn(1,kk,-40);
Z(1:kk) = 0;
% z(400:kk) = 1;

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

%Macierz MZP
MZP = zeros(N, Dz-1);
for i=1:N
   for j=1:Dz-1
      if i+j<=Dz
      MZP(i,j)=s_z(i+j)-s_z(j);
      else
      MZP(i,j)=s_z(Dz)-s_z(j);
      end
   end
end

K = ((M'*M + lamb * eye(Nu))^(-1))* M';
DUp = zeros(D-1, 1);
dz = zeros(Dz-1, 1);
Y = zeros(N,1);

e = 0;
reached = 0;
when_reached = 1;
moc = 3;
%% Głowne wykonanie programu

for k=kp:kk
    
    for n=1:N
    %yzad dla horyzontu predykcji
        Y_zad(n,1) = yzad(k);
    end

    %symulacja obiektu
    y(k) = symulacja_obiektu1y_p2(u(k-6),u(k-7),z(k-3),z(k-4),y(k-1),y(k-2));
    
    %stała trajektoria referencyjna
    for n=1:N
        Y(n) = y(k);
    end
    if(y(k)>yzad(k) && k>kp+50 && reached == 0)
        z(k:kk) = 1;
        zaklocenie = load("Odp_skokowe/prbs").ans*moc;
        Z(k:kk) = zaklocenie(k:kk);
        reached = 1;
    end
    if(reached == 1)
        Z(k) = z(k)+Z(k);
    end
    %DMC
    for n = 1:D-1
        DUp(n) = u(k-n) - u(k-n-1);
    end
    
    for n = 1:Dz-1
        dz(n) = Z(k-n) - Z(k-n-1); 
    end

    Yo = MP*DUp+Y+MZP*dz;
%     Yo = MP*DUp+Y;

    DU = K*(Y_zad - Yo);
    u(k)=u(k-1)+DU(1);  
    
    e = e + (yzad(k) - y(k))^2;

end
display(e)

%Plot sterowanie

f = figure;
subplot(3,1,1)
stairs(1:kk,y)
hold on
stairs(1:kk,yzad,"--")
xlabel("k")
ylabel("y")
title("Odpowiedz skokowa ukladu z regulatorem DMC oraz z zakloceniem sinusoidalnym" + newline + "D = " + D + " N = " + N + " Nu = " + Nu +  " lambda = " + lamb + " error = " + e + " Dz = " + Dz + newline+ "Wzmocnienie szumu = " + moc)

subplot(3,1,2)
stairs(1:kk,u)
xlabel("k")
ylabel("u")
title("Sterowanie")

subplot(3,1,3)
stairs(1:kk,Z)
xlabel("k")
ylabel("z")
title("Zaklocenie")
ylim([-1 2])
if sav
    name = sprintf("Zakl_DMC_prbs_Dz_%i_moc_%i.pdf",Dz, moc);
    exportgraphics(f,name)
end