function [s] = Zad_5_generate_step(u_pp)

%% Wymierzanie skoku jednostkowego

pl = false;

D = 100;

%skok wartosci F1
du = u_pp;
if du == 0
    du = 0.1;
end

t_sym = 220; %czas symulacji


%warunki_początkowe
T = 0.5; %Czas próbkowania

kp = 8; %Krok początkowy startu symulacji
kk = t_sym/T; %Krok końcowy

Upp = 0;
Ypp = 0;

U(1:kk,1) = Upp;
Y(1:kp,1) = Ypp;


%Symulacja obiektu w punkcie pracy
for k = kp:kk
    if k >= kp+99
        U(k) = Upp + du;
    end
    Y(k) = symulacja_obiektu1y_p3(U(k-5),U(k-6),Y(k-1),Y(k-2));
end

%Skalowanei odp skokowej
s = (Y(kp+100:end) - Y(kp+99)*ones(1, length(Y(kp+100:end))))/du;


%% Plot
if pl
    stairs(s)
    hold on
    legend("y(k)")
    xlabel("k"); ylabel("y");
    title("Odpowiedz skokowa")
end

end