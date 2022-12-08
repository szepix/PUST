clear all

%% Inicjalizacja zmienych

T = 0.5; %Czas próbkowania
t_sym = 50; %Czas symulacji (w sekundach)

kp = 8; %Krok początkowy startu symulacji
kk = t_sym/T; %Krok końcowy

Upp = 0;
Ypp = 0;

U(1:kk,1) = Upp;
Y(1:kp,1) = Ypp;


%% Symulacja obiektu

for k = kp:kk
    Y(k) = symulacja_obiektu1y_p3(U(k-5),U(k-6),Y(k-1),Y(k-2));
end

%% Plot

stairs(1:kk,Y)
hold on
legend("y(k)")
xlabel("k"); ylabel("y");
title("Sprawdzenie punktu pracy")
exportgraphics(gca,'y_p_p.pdf')