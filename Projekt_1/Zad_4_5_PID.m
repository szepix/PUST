clear all; clc

%% Inicjalizacja zmienych

T = 0.5; %Czas próbkowania
t_sym = 300; %Czas symulacji (w sekundach)

kp = 150; %Krok początkowy startu symulacji
kk = 650; %Krok końcowy

Upp = 0.5;
Ypp = 4;

err = 0;

Umin = 0.3;
Umax = 0.7;

U(1:kp,1) = Upp;
Y(1:kp,1) = Ypp;
e(1:kp) = 0;

%Zmiana wartości zadanej
y_zad(1:kp+10) = 4;
y_zad(kp+10:350) = 4.2;
y_zad(350:kk) = 3.8;

%% Parametry Regulatora

Kp = 0.6291;
Ti = 7.5975;
Td = 4.0725e-08;

r0 = Kp*(1 + T/(2*Ti) + Td/T);
r1 = Kp*(T/(2*Ti) - (2*Td)/T -1);
r2 = Kp*Td/T;


%% Symulacja obiektu

for k = kp:kk
    Y(k) = symulacja_obiektu1Y_p1(U(k-10),U(k-11),Y(k-1),Y(k-2));
  
    e(k) = y_zad(k) - Y(k);
    U_now = U(k-1) + r0*e(k) + r1*e(k-1) + r2*e(k-2);
    dU = U_now - U(k-1);
    if dU > 0.05
        dU = 0.05;
    elseif dU < -0.05
        dU = -0.05;
    end
    U_now = U(k-1) + dU;

    if U_now < 0.3
        U_now = 0.3;
    elseif U_now > 0.7
        U_now = 0.7;
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
