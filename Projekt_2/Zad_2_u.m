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
f = figure;
hold on
for zad = -2:1:2
    U(1:kp,1) = Upp;
    Y(1:kp,1) = Ypp;
    Z(1:kk) = Zpp;
    for k = kp:kk
        Y(k) = symulacja_obiektu1y_p2(U(k-6),U(k-7),Z(k-3),Z(k-4),Y(k-1),Y(k-2));
        U(k) = zad;
    end
    stairs(1:kk,Y)
end
%% Plot

xlabel("k")
ylabel("y")
title("Odpowiedz wyjscia w torze wejscia")
for i=1:5
    lgd{i} = strcat('u = ',num2str(i-3)) ;
end
legend(lgd,Location="northoutside",Orientation="horizontal")
exportgraphics(f,'odp_skok_u.pdf')