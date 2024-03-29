clear all; clc

draw = true;
sa = true;


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

%% Zmiana wartości zadanej

y_zad(1:kp) = 0;
y_zad(kp:350) = 11;
y_zad(350:600) = -0.1;
y_zad(600:kk) = 5;


%% Prametry fukncji przyneleznosci

il = 5; %Ilosc regualtorów

% w = zeros(il,kk);

%Zmienne zadaniowe
u_min = -1;
u_max = 1;


d = (u_max-u_min)/(il-1); %szerokości funkcji przynależnośći
spread = d/4;

%Wybranie punktu pracy
ur0 = ones(1,il);
ur0(1) = u_min;
    for i = 2:il-1
        ur0(i) = ur0(i-1) + d;
    end
ur0(il) = ur0(il-1) + d;

%% Rysowanie funkcji przyneleżności
if draw
    u = (u_min:0.01:u_max)';
    figure
    hold on
    %Plotter funkcji przynaleznosci
    for i = 1:il
        if i == 1
            plot(u,gaussmf(u,[spread, ur0(1)]));
        elseif i == il
            plot(u,gaussmf(u,[spread, ur0(i)]));
        else
            plot(u,gaussmf(u,[spread, ur0(i)]));        
        end
    end
    xlabel("u"); ylabel("Funkcja przynależności");
    title(sprintf("Funkcja przynaleznosci dla %i zbiorów rozmytych",il))
    hold off
end

%% Parametry Regulatora 1

Kp1 = 1.4;
Ti1 = 0.5;
Td1 = 2;

%% Parametry Regulatora 2

Kp2 = 0.02;
Ti2 = 0.5;
Td2 = 8;


%% Parametry Regulatora 3

Kp3 = 0.06;
Ti3 = 1;
Td3 = 2;

%% Parametry Regulatora 4

Kp4 = 0.01;
Ti4 = 1.5;
Td4 = 1;


%% Parametry Regulatora 5

Kp5 = 0.03;
Ti5 = 0.1;
Td5 = 1;






r01 = Kp1*(1 + T/(2*Ti1) + Td1/T);
r11 = Kp1*(T/(2*Ti1) - (2*Td1)/T -1);
r21 = Kp1*Td1/T;

r02 = Kp2*(1 + T/(2*Ti2) + Td2/T);
r12 = Kp2*(T/(2*Ti2) - (2*Td2)/T -1);
r22 = Kp2*Td2/T;

r03 = Kp3*(1 + T/(2*Ti3) + Td3/T);
r13 = Kp3*(T/(2*Ti3) - (2*Td3)/T -1);
r23 = Kp3*Td3/T;

r04 = Kp4*(1 + T/(2*Ti4) + Td4/T);
r14 = Kp4*(T/(2*Ti4) - (2*Td4)/T -1);
r24 = Kp4*Td4/T;

r05 = Kp5*(1 + T/(2*Ti5) + Td5/T);
r15 = Kp5*(T/(2*Ti5) - (2*Td5)/T -1);
r25 = Kp5*Td5/T;


%% Symulacja obiektu

for k = kp:kk
    Y(k) = symulacja_obiektu1y_p3(U(k-5),U(k-6),Y(k-1),Y(k-2));
  
    for i = 1:il
        if i == 1
            w(1,k) = gaussmf(U(k-1),[spread, ur0(1)]);
        elseif i == il
            w(il,k) = gaussmf(U(k-1),[spread, ur0(il)]);
        else
            w(i,k) = gaussmf(U(k-1),[spread, ur0(i)]);   
        end
    end
    
    
    e(k) = y_zad(k) - Y(k);

    %U1
    U_1 = U(k-1) + r01*e(k) + r11*e(k-1) + r21*e(k-2);

    %U2
    U_2 = U(k-1) + r02*e(k) + r12*e(k-1) + r22*e(k-2);

    %U3
    U_3 = U(k-1) + r03*e(k) + r13*e(k-1) + r23*e(k-2);
    
    %U4
    U_4 = U(k-1) + r04*e(k) + r14*e(k-1) + r24*e(k-2);

    %U5
    U_5 = U(k-1) + r05*e(k) + r15*e(k-1) + r25*e(k-2);

    if il == 2
        U_now = (U_1 * w(1,k) + U_2 * w(2,k))/(sum(w(:,k)));
    elseif il == 3
        U_now = (U_1 * w(1,k) + U_2 * w(2,k) + U_3 * w(3,k))/(sum(w(:,k)));
    elseif il == 4
        U_now = (U_1 * w(1,k) + U_2 * w(2,k) + U_3 * w(3,k) + U_4 * w(4,k))/(sum(w(:,k)));
    elseif il == 5
        U_now = (U_1 * w(1,k) + U_2 * w(2,k) + U_3 * w(3,k) + U_4 * w(4,k) + U_5 * w(5,k))/(sum(w(:,k)));
    end


    if U_now < -1
        U_now = 1;
    elseif U_now > 1
        U_now = 1;
    end
    
    
    U(k) = U_now;

    err = err + (y_zad(k) - Y(k))^2;

end

display(err)

iteracja = 0:1:kk-1;
if draw
display(err)
figure;
stairs(1:kk,Y)
hold on
stairs(1:kk,y_zad,"--")
hold off
legend("y(k)","y_z_a_d(k)")
title("Odpowiedz obiektu na regulacje z rozmytym regulatorem PID");
name = sprintf("PIDF_%f_%f_%f_przeb_5reg_brzydkie.pdf",Kp1,Kp2,Kp3);
if sa
    exportgraphics(gca,name);
end

figure;
stairs(iteracja, U)
title("Sterowanie rozmytego regulatora PID");
xlabel('k'); ylabel("u");
% legend("Sterowanie regulatora", "Location", "best")
name = sprintf("PIDF_%f_%f_%f_ster_5reg_brzydkie.pdf",Kp1,Kp2,Kp3);
end
if sa
    exportgraphics(gca,name)
end