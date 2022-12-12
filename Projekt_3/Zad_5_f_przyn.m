clear all
clc

%Parametry programu
il = 3; %ilość regulatorów
draw = true;
sa = false;

%Zmienne zadaniowe
u_min = -1;
u_max = 1;
u = (u_min:0.01:u_max)';


d = (u_max-u_min)/(il-1); %szerokości funkcji przynależnośći
spread = d/4;

%Wybranie punktu pracy
ur0 = ones(1,il);
ur0(1) = u_min;
    for i = 2:il-1
        ur0(i) = ur0(i-1) + d;
    end
ur0(il) = ur0(il-1) + d;

if draw
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
    if sa
        print(sprintf('funkcja_przynelznosci_%i.png',il_fun),'-dpng','-r400')
    end
end

