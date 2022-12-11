clear all

%% Inicjalizacja zmienych


T = 0.5; %Czas próbkowania
t_sym = 250; %Czas symulacji (w sekundach)

kp = 8; %Krok początkowy startu symulacji
kk = t_sym/T; %Krok końcowy

Upp = 0;
Ypp = 0;
Zpp = 0;



%% Symulacja obiektu oraz tworzenie wykresu

set(0,'DefaultStairLineWidth',1);
U(1:kk,1) = Upp;
Y(1:kp,1) = Ypp;
Z(1:kp,1) = Zpp;

for i = 1:kk
    U(kp:kk)=i*0.01;
    
    for j = 1:kk
        Z(kp:kk)=i*0.01;

        for k = kp:kk
            Y(k) = symulacja_obiektu1y_p2(U(k-6),U(k-7),Z(k-3),Z(k-4),Y(k-1),Y(k-2));
        end

        z_stat(i, j) = Z(kk);
        y_stat(i,j) = Y(kk);
    end
    u_stat(i) = U(kk);

end
%% Plot

h = surf(u_stat,z_stat,y_stat);
set(h,'LineStyle','none')
colormap winter;
xlabel("u")
ylabel("z")
zlabel("y")
title("Odpowiedz statyczna")
exportgraphics(gca,'odp_stat.pdf')