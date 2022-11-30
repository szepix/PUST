clear all

%% Inicjalizacja zmienych

T = 0.5; %Czas próbkowania
t_sym = 75; %Czas symulacji (w sekundach)

kp = 8; %Krok początkowy startu symulacji
kk = t_sym/T; %Krok końcowy

Upp = 0;
Ypp = 0;
Zpp = 0;



U(1:kk,1) = Upp;
Y(1:kp,1) = Ypp;
Z(1:kk,1) = Zpp;

%Skok jednostkowy
Z(kp:kk,1) = 1;

%% Symulacja obiektu

for k = kp:kk
    Y(k) = symulacja_obiektu1y_p2(U(k-6),U(k-7),Z(k-3),Z(k-4),Y(k-1),Y(k-2));
end

%% Plot
set(0,'DefaultStairLineWidth',1);
stairs(1:kk,Y)
xlabel("k")
ylabel("y")
set(get(gca,'ylabel'),'rotation',0)
title("Skok jednostkowy toru zaklocenia")
save("Odp_skokowe\odp_skok_z.mat", "Y");

% exportgraphics(gca,'skok_jedn_z.pdf')