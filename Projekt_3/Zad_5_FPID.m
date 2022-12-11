clear all; clc

draw = true;
sa = false;


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

%% Zmiana wartości zadanej
y_zad(1:kp) = 0;
y_zad(kp:350) = 10;
y_zad(350:kk-100) = 5;
y_zad(kk-100:kk) = -0.25;


%% Prametry fukncji przyneleznosci
il = 3; %Ilosc regualtorów
% w = zeros(il,kk);

y_max = 12;
y_min = -1;

d = (y_max-y_min)/(il+1); %szerokości funkcji przynależnośći
spread = d/2;

%Wybranie punktu pracy
yr0 = ones(1,il);
yr0(1) = d/2;
    for i = 2:il-1
        yr0(i) = yr0(i-1) + d;
    end
yr0(il) = yr0(il-1) + d;

%% Rysowanie funkcji przyneleżności
if draw
    y = (y_min:0.1:y_max)';
    figure
    hold on
    %Plotter funkcji przynaleznosci
    for i = 1:il
        if i == 1
            plot(y,gaussmf(y,[spread, yr0(1)]));
        elseif i == il
            plot(y,gaussmf(y,[spread, yr0(i)]));
        else
            plot(y,gaussmf(y,[spread, yr0(i)]));        
        end
    end
    xlim([-1 12])
    xlabel("y"); ylabel("Funkcja przynależności");
    title(sprintf("Funkcja przynaleznosci dla %i zbiorów rozmytych",il))
    if sa
        print(sprintf('funkcja_przynelznosci_%i.png',il_fun),'-dpng','-r400')
    end
    hold off
end

%% Parametry Regulatora 1

Kp1 = 0.7;
Ti1 = 0.2;
Td1 = 0.1;

r01 = Kp1*(1 + T/(2*Ti1) + Td1/T);
r11 = Kp1*(T/(2*Ti1) - (2*Td1)/T -1);
r21 = Kp1*Td1/T;

%% Parametry Regulatora 2

Kp2 = 1.1;
Ti2 = 0.5;
Td2 = 0.25;

r02 = Kp2*(1 + T/(2*Ti2) + Td2/T);
r12 = Kp2*(T/(2*Ti2) - (2*Td2)/T -1);
r22 = Kp2*Td2/T;

%% Parametry Regulatora 3

Kp3 = 1.4;
Ti3 = 0.5;
Td3 = 0.25;

r03 = Kp3*(1 + T/(2*Ti3) + Td3/T);
r13 = Kp3*(T/(2*Ti3) - (2*Td3)/T -1);
r23 = Kp3*Td3/T;



%% Symulacja obiektu

for k = kp:kk
    Y(k) = symulacja_obiektu1y_p3(U(k-5),U(k-6),Y(k-1),Y(k-2));
  
    for i = 1:il
        if i == 1
            w(1,k) = gaussmf(Y(k),[spread, yr0(1)]);
        elseif i == il
            w(il,k) = gaussmf(Y(k),[spread, yr0(il)]);
        else
            w(i,k) = gaussmf(Y(k),[spread, yr0(i)]);   
        end
    end
    
    
    e(k) = y_zad(k) - Y(k);

    %U1
    U_1 = U(k-1) + r01*e(k) + r11*e(k-1) + r21*e(k-2);

    %U2
    U_2 = U(k-1) + r02*e(k) + r12*e(k-1) + r22*e(k-2);

    %U3
    U_3 = U(k-1) + r03*e(k) + r13*e(k-1) + r23*e(k-2);
    
    
    U_now = (U_1 * w(1,k) + U_2 * w(2,k) + U_3 * w(3,k))/sum(w(:,k)*3);


    if U_now < -1
        U_now = 1;
    elseif U_now > 1
        U_now = 1;
    end
    
    
    U(k) = U_now;

    err = err + (y_zad(k) - Y(k))^2;

end

display(err)

figure;
stairs(1:kk,Y)
hold on
stairs(1:kk,y_zad,"--")
hold off
legend("y(k)","y_z_a_d(k)")
title("Rozmyty regulator PID, error = " + sum(err))
% exportgraphics(gca,'y_p_p.pdf')
