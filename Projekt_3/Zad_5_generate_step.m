function [s] = Zad_4_generate_step(step_point, u_pp)

%% Wymierzanie skoku jednostkowego


D = 100;

%skok wartosci F1
du = 0.02;

t_sym = 120; %czas symulacji


%warunki_początkowe
T = 0.5; %Czas próbkowania
t_sym = 50; %Czas symulacji (w sekundach)

kp = 8; %Krok początkowy startu symulacji
kk = t_sym/T; %Krok końcowy

Upp = u_pp;
Ypp = step_point;

U(1:kk,1) = Upp;
Y(1:kp,1) = Ypp;


%Symulacja obiektu w punkcie pracy
for k = kp:kk
    if k >= kp+5
        U(k) = Upp + du;
    end
    Y(k) = symulacja_obiektu1y_p3(U(k-5),U(k-6),Y(k-1),Y(k-2));
end

%Skalowanei odp skokowej
s = (Y(kp+5:kk) - Ypp*ones(1, kk-(kp+4)))/du;

%% Plot
stairs(kp+5:kk,s)
hold on
legend("y(k)")
xlabel("k"); ylabel("y");
title("Odpowiedz skokowa")

end