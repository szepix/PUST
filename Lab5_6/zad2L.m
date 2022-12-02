%% Inicjalizacja potrzebnych zmiennych, inicjalizacja stanowiska grzej?cego ( a dok?adnie wiatraka )
addpath ('F:\SerialCommunication'); % add a path
initSerialControl COM19 % initialise com port
Upp = 33;
sendControls ([ 1, 5], [ 50, Upp]) ;
%Tablica kolejnych warto?ci sterowania do sprawdzenia
U_static_steps = [20:10:80];
%Zak?adam, ?e 5 minut starczy do stabilizacji warto?ci, zwykle starcza?o
simulation_time  = max(size(U_static_steps)) * 300;
U_steps = zeros(simulation_time,1);
%Generuj? du?? tablic? kolejnyc warto?ci sterowania w danej chwili i
for i = 1:simulation_time
    if i > 0 && i <= 300
        U_steps(i) = U_static_steps(1);
    elseif i > 300 && i <= 600
        U_steps(i) = U_static_steps(2);
    elseif i > 600 && i <= 900
        U_steps(i) = U_static_steps(3);
    elseif i > 900 && i <= 1200
        U_steps(i) = U_static_steps(4);
    elseif i > 1200 && i <= 1500
        U_steps(i) = U_static_steps(5);
    elseif i > 1500 && i <= 1800
        U_steps(i) = U_static_steps(6);
    elseif i > 1800 && i <= 2100
        U_steps(i) = U_static_steps(7);
    end
end
U_steps = [U_steps];
Y(1) = readMeasurements(1);
for k=2:simulation_time
    Y(k) = readMeasurements(1);
    sendNonlinearControls(U_steps(k));
    figure(1);
    subplot(2,1,1)
    plot(1:k, Y(1:k),'LineWidth', 1.1);
    title('Sygnal wyjsciowy');
    xlabel('Numer probki (k)');
    grid on;
    subplot(2,1,2)
    plot(1:k, U_steps(1:k),'LineWidth', 1.1); % sterowanie
    title('Sygnal sterujacy');
    xlabel('Numer probki (k)');
    grid on;
    drawnow
    waitForNewIteration (); % wait for new iteration
 end
