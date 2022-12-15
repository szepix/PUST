clear all

%% Inicjalizacja zmienych

T = 0.5; %Czas próbkowania
t_sym = 250; %Czas symulacji (w sekundach)

kp = 8; %Krok początkowy startu symulacji
kk = t_sym/T; %Krok końcowy

Upp = 0;
Ypp = 0;

wart_u = -1:0.01:1;
char_stat = zeros(length(wart_u),1);

for i = 1 : length(wart_u)
    Y = zeros(kk,1);
    U = wart_u(i) * ones(kk,1);

    for k = 12:kk
        Y(k) = symulacja_obiektu1y_p3(U(k-5),U(k-6),Y(k-1),Y(k-2));
    end
    char_stat(i) = Y(kk);
end

set(0,'defaultLineLineWidth',1);
plot(wart_u,char_stat);
title("Charakterystyka statyczna")
xlabel("u")
ylabel("y")
exportgraphics(gca,'charakterystyka_statyczna.pdf')