addpath ('D:\SerialCommunication'); % add a path
initSerialControl COM2 % initialise com port

Umin =0; Umax = 100;
simulationTime = 1200;
YZad = zeros(simulationTime,1);
YZad(1:300) = Ypp;  
YZad(300:600)= Ypp+5;
YZad(600:900)= Ypp+15;
YZad(900:1200) = Ypp;
    

Y = zeros(simulationTime,1);
U = zeros(simulationTime,1);


D = 300;
N = 300;
Nu = 300;
lambda = 1;
values = importdata("skok_46.txt");

s = zeros(1,500);

for i = 1:500
    s(i) = (values(i) - values(1))/20;
end

[M,Mp,K]=macierzMMPiK(s,N,Nu,D,lambda);
duPop = zeros(D(1)-1,1);

for k = 2:simulationTime 
    Y(k) = readMeasurements(1) ;
    y(k) = Y(k) - Ypp;
    du = dmc_inny(Mp,K,N,y(k),yzad(k),duPop);
    
    u(k) = u(k-1) + du;

    if u(k)> uMax
		u(k) = uMax; 
    end
    if u(k)< uMin
        u(k) = uMin;
    end
    
    du = u(k) - u(k-1);
    
    % Zapis przeszlych przyrostow sterowania
    duPop = [du; duPop(1:end-1)];
      
    % Dodanie wartosci punktu pracy
    U(k) = u(k) + Upp;
    sendNonlinearControls(U(k));
    
    subplot(2,1,1)
    plot(1:k, Y(1:k),'LineWidth', 1.1); % Wyjscie obiektu
    hold on
    plot(1:k, Yzad(1:k),'LineWidth', 1.1); % zadana
    hold off
    title('Sygnal wyjsciowy');
    xlabel('Numer probki (k)');
    grid on;
    subplot(2,1,2)
    plot(1:k, U(1:k),'LineWidth', 1.1); % sterowanie
    title('Sygnal sterujacy');
    xlabel('Numer probki (k)');
    grid on;
    drawnow
    waitForNewIteration(); 
    
    
end