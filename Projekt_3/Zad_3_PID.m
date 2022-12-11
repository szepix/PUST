clear all; clc

%% Inicjalizacja zmienych

T = 0.5; %Czas próbkowania
t_sym = 300; %Czas symulacji (w sekundach)

kp = 150; %Krok początkowy startu symulacji
kk = 650; %Krok końcowy

Upp = 0;
Ypp = 0;

err = 0;

Umin = -1;
Umax = 1;

U(1:kp,1) = Upp;
Y(1:kp,1) = Ypp;
e(1:kp) = 0;

%Zmiana wartości zadanej
y_zad(1:kp) = 0;
y_zad(kp:350) = 10;
y_zad(350:kk-100) = 5;
y_zad(kk-100:kk) = -0.25;


%% Parametry Regulatora

Kp = 2;
Ti = 0.5;
Td = 0.05;

r0 = Kp*(1 + T/(2*Ti) + Td/T);
r1 = Kp*(T/(2*Ti) - (2*Td)/T -1);
r2 = Kp*Td/T;


%% Symulacja obiektu

for k = kp:kk
    Y(k) = symulacja_obiektu1y_p3(U(k-5),U(k-6),Y(k-1),Y(k-2));
  
    e(k) = y_zad(k) - Y(k);
    U_now = U(k-1) + r0*e(k) + r1*e(k-1) + r2*e(k-2);

    if U_now < -1
        U_now = 1;
    elseif U_now > 1
        U_now = 1;
    end
    
    
    U(k) = U_now;

    err = err + (y_zad(k) - Y(k))^2;

end

display(err)

stairs(1:kk,Y)
hold on
stairs(1:kk,y_zad,"--")
hold off
legend("y(k)","y_z_a_d(k)")
xlim([0 650])
% exportgraphics(gca,'y_p_p.pdf')
