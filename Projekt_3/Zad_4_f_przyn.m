clear all
clc

%Parametry programu
il = 3; %ilość regulatorów
draw = true;
sa = false;

%Zmienne zadaniowe
y_min = -1;
y_max = 12;
y = (y_min:0.1:y_max)';


d = (y_max-y_min)/il; %szerokości funkcji przynależnośći

%Wybranie punktu pracy
yr0 = ones(1,il);
yr0(1) = d/2;
yr0(il) = yr0(il-1) + d/2;
    for i = 2:il-1
        yr0(i) = yr0(i-1) + d/2;
    end


if draw
    figure
    hold on
    %Plotter funkcji przynaleznosci
    for i = 1:il
        if i == 1
            plot(gaussmf(y,[d/2, yr0(1)]));
        elseif i == il
            plot(gaussmf(y,[d/2, yr0(i)]));
        else
            plot(gaussmf(y,[d/2, yr0(i)]));        
        end
    end
    xlim([-10 120])
    xlabel("y"); ylabel("Funkcja przynależności");
    title(sprintf("Funkcja przynaleznosci dla %i zbiorów rozmytych",il))
    if sa
        print(sprintf('funkcja_przynelznosci_%i.png',il_fun),'-dpng','-r400')
    end
end

