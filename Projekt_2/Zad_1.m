clear all

%% Inicjalizacja zmienych

T = 0.5; %Czas próbkowania
t_sym = 50; %Czas symulacji (w sekundach)

kp = 8; %Krok początkowy startu symulacji
kk = t_sym/T; %Krok końcowy

Upp = 0;
Ypp = 0;
Zpp = 0;

U(1:kk,1) = 0;
Y(1:kp,1) = 0;
Z(1:kk,1) = 0;


%% Symulacja obiektu

for k = kp:kk
    Y(k) = symulacja_obiektu1y_p2(U(k-6),U(k-7),Z(k-3),Z(k-4),Y(k-1),Y(k-2));
end

%% Plot

stairs(1:kk,Y)
hold on
legend("y(k)")
xlabel("k"); ylabel("y");
title("Sprawdzenie punktu pracy")
exportgraphics(gca,'y_p_p.pdf')