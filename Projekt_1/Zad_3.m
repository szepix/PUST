clear all

%% Inicjalizacja zmienych

T = 0.5; %Czas próbkowania
t_sym = 60; %Czas symulacji (w sekundach)

kp = 12; %Krok początkowy startu symulacji
kk = t_sym/T; %Krok końcowy

U(1:kp,1) = 0;
U(kp:kk,1) = 1;
Y(1:kp,1) = 0;


%% Symulacja obiektu

for k = kp:kk
    Y(k) = symulacja_obiektu1Y_p1(U(k-10),U(k-11),Y(k-1),Y(k-2));
end

%% Plot
set(0,'DefaultStairLineWidth',1);
stairs(1:kk,Y)
xlabel("k")
ylabel("y")
set(get(gca,'ylabel'),'rotation',0)
title("Skok jednostkowy")
save("odp_skok.mat", "Y");
% ylim([3.4, 4.6])
% exportgraphics(gca,'skok_jedn.pdf')