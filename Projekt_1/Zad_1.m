clear all

%% Inicjalizacja zmienych

T = 0.5; %Czas próbkowania
t_sym = 50; %Czas symulacji (w sekundach)

kp = 12; %Krok początkowy startu symulacji
kk = t_sym/T; %Krok końcowy

Upp = 0.5;
Ypp = 4;

Umin = 0.3;
Umax = 0.7;

U(1:kp,1) = 0;
Y(1:kp,1) = 0;


%% Symulacja obiektu

for k = kp:kk
    Y(k) = symulacja_obiektu1Y_p1(U(k-10),U(k-11),Y(k-1),Y(k-2));
    U(k) = Upp;
end

%% Plot

stairs(1:kk,Y)
hold on
stairs(1:kk,U,"--")
hold off
legend("y(k)","u(k)")
exportgraphics(gca,'y_p_p.pdf')