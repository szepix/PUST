clear all

%% Inicjalizacja zmienych

T = 0.5; %Czas próbkowania
t_sym = 250; %Czas symulacji (w sekundach)

kp = 12; %Krok początkowy startu symulacji
kk = t_sym/T; %Krok końcowy

Upp = 0.5;
Ypp = 4;

wart_u = 0.3:0.01:0.7;
char_stat = zeros(length(wart_u),1);

for i = 1 : length(wart_u)
    Y = zeros(kk,1);
    U = wart_u(i) * ones(kk,1);

    for k = 12:kk
        Y(k) = symulacja_obiektu1Y_p1(U(k-10),U(k-11),Y(k-1),Y(k-2));
    end
    char_stat(i) = Y(kk);
end

plot(wart_u,char_stat);
title("Charakterystyka statyczna")
xlabel("u")
ylabel("y")
set(get(gca,'ylabel'),'rotation',0)
exportgraphics(gca,'charakterystyka_statyczna.pdf')