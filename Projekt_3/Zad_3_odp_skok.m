clear all

%% Inicjalizacja zmienych

T = 0.5; %Czas próbkowania
t_sym = 200; %Czas symulacji (w sekundach)

kp = 7; %Krok początkowy startu symulacji
kk = t_sym/T; %Krok końcowy

U(1:kp,1) = 0;
U(kp:kk,1) = 1;
Y(1:kp,1) = 0;


%% Symulacja obiektu

for k = kp:kk
    Y(k) = symulacja_obiektu1y_p3(U(k-5),U(k-6),Y(k-1),Y(k-2));
end

s = Y(kp+1:end);

%% Plot
set(0,'DefaultStairLineWidth',1);
stairs(s)
xlabel("k")
ylabel("y")
set(get(gca,'ylabel'),'rotation',0)
title("Skok jednostkowy")
% save("odp_skok.mat", "s");
% exportgraphics(gca,'skok_jedn.pdf')