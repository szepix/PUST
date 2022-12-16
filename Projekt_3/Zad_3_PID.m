clear all; clc

sav = true;

%% Inicjalizacja zmienych
Upp = 0;
Ypp = 0;

err = 0;

T = 0.5;

Umin = -1;
Umax = 1;

kp = 100;
kk = kp+800;

U(1:kp,1) = Upp;
Y(1:kp,1) = Ypp;
e(1:kp) = 0;

%Zmiana wartości zadanej


y_zad(1:kp) = 0;
y_zad(kp:350) = 11;
y_zad(350:600) = -0.1;
y_zad(600:kk) = 5;


%% Parametry Regulatora

Kp = 0.25;
Ti = 4;
Td = 1;


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

iteracja = 0:1:kk-1;

display(err)
figure;
stairs(1:kk,Y)
hold on
stairs(1:kk,y_zad,"--")
hold off
legend("y(k)","y_z_a_d(k)")
title("Odpowiedz obiektu na regulacje z regulatorem PID"  + newline + "K = " + Kp + " Ti = " + Ti + " Td = " + Td + "  error = " + err );
name = sprintf("PID_%f_%f_%f_przeb.pdf",Kp,Ti,Td);
if sav
    exportgraphics(gca,name);
end

figure;
stairs(iteracja, U)
title("Sterowanie regulatora PID"  + newline + "K = " + Kp + " Ti= " + Ti + " Td = " + Td + "  error = " + err );
xlabel('k'); ylabel("u");
% legend("Sterowanie regulatora", "Location", "best")
name = sprintf("PID_%f_%f_%f_ster.pdf",Kp,Ti,Td);
if sav
    exportgraphics(gca,name)
end