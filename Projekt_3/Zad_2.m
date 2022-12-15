clear all

%% Inicjalizacja zmienych


T = 0.5; %Czas próbkowania
t_sym = 250; %Czas symulacji (w sekundach)

kp = 8; %Krok początkowy startu symulacji
kk = t_sym/T; %Krok końcowy

Upp = 0;
Ypp = 0;



%% Symulacja obiektu oraz tworzenie wykresu

set(0,'DefaultStairLineWidth',1);
f = figure;
hold on
for zad = -1:0.4:1
    U(1:kp,1) = Upp;
    Y(1:kp,1) = Ypp;
    for k = kp:kk
        Y(k) = symulacja_obiektu1y_p3(U(k-5),U(k-6),Y(k-1),Y(k-2));
        U(k) = zad;
    end
    stairs(1:kk,Y)
end
%% Plot

xlabel("k")
ylabel("y")
title("Odpowiedz wyjscia w torze wejscia")
for i=1:6
    lgd{i} = strcat('u = ',num2str(((i-1)*0.4-1)));
end
legend(lgd,Location="northoutside",Orientation="horizontal")
exportgraphics(f,'odp_skok_u.pdf')