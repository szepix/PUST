%% Inicjalizacja potrzebnych zmiennych, inicjalizacja stanowiska grzej?cego ( a dok?adnie wiatraka )
addpath ('F:\SerialCommunication'); % add a path
initSerialControl COM19 % initialise com port
Upp = 33;
sendControls ([ 1, 5], [ 50, Upp]) ;
%Tablica kolejnych warto?ci sterowania do sprawdzenia
simulation_time  = 300;
%Generuj? du?? tablic? kolejnyc warto?ci sterowania w danej chwili i
Y(1) = readMeasurements(1);
for k=2:simulation_time
    Y(k) = readMeasurements(1); % read measurements T1
    sendNonlinearControls(Upp(k));
    waitForNewIteration (); % wait for new iteration
end
