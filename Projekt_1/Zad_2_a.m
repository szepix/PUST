clear all

%% Inicjalizacja zmienych

T = 0.5; %Czas próbkowania
t_sym = 250; %Czas symulacji (w sekundach)

kp = 12; %Krok początkowy startu symulacji
kk = t_sym/T; %Krok końcowy

Upp = 0.5;
Ypp = 4;

Umin = 0.3;
Umax = 0.7;


U(1:kp,1) = 0.5;
Y(1:kp,1) = 4;

Uzad(1:100) = 0.5;
Uzad(100:200) = 0.6;
Uzad(200:300) = 0.4;
Uzad(300:400) = 0.7;
Uzad(400:kk) = 0.3;

%% Symulacja obiektu

for k = kp:kk
    Y(k) = symulacja_obiektu1Y_p1(U(k-10),U(k-11),Y(k-1),Y(k-2));
    U(k) = Uzad(k);
end

%% Plot

f = figure;
subplot(2,1,1)
stairs(1:kk,Y)
xlabel("k")
ylabel("y")
set(get(gca,'ylabel'),'rotation',0)
title("Y od k")
ylim([3.4, 4.6])

subplot(2,1,2)
stairs(1:kk,U)
xlabel("k")
ylabel("u")
set(get(gca,'ylabel'),'rotation',0)
title("U od k")
ylim([0.2, 0.8])
exportgraphics(f,'odp_skok.pdf')