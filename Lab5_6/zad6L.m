%% wybór i strojenie regulatora

liczbaOdpowiedzi=2; % 2,3,4,5 lub 6

% Symulacja rozmytego algorytmu DMC. 
addpath ('F:\SerialCommunication'); % add a path
initSerialControl COM19 % initialise com port
Upp=33; %punkt pracy do zmiany
Ypp=38.5;

sendControls (1,50);
Umin =0; Umax = 100;
umin = Umin-Upp;
umax = Umax-Upp;
simulationTime = 1200;
YZad = zeros(simulationTime,1);
YZad(1:simulationTime/3) = Ypp;  
YZad(simulationTime/3:simulationTime*2/3)= Ypp+5;
YZad(simulationTime*2/3:end)= Ypp+15;
yzad = YZad-Ypp;

Y = ones(simulationTime,1)*Ypp;
y = zeros(simulationTime,1);
U = ones(simulationTime,1)*Upp;
u = zeros(simulationTime,1);


D = 300;
N = 300;
Nu = 300;


%% odpowiedzi skokowe
load("odpowiedziSkokowe/odp_skokowe.mat");
s1=odp_skokowe(2).s;
s2=odp_skokowe(3).s;
s3=odp_skokowe(4).s;
s4=odp_skokowe(5).s;
s5=odp_skokowe(6).s;
s6=odp_skokowe(7).s;

lambda1=1;
lambda2=1;

if liczbaOdpowiedzi>2
    lambda3=1;
end
if liczbaOdpowiedzi>3
    lambda4=1;
end
if liczbaOdpowiedzi>4
    lambda5=1;
end
if liczbaOdpowiedzi>5
    lambda6=1;
end
%% inicjalizacja

if liczbaOdpowiedzi==2
    [M1,Mp1,K1]=macierzMMPiK(s1,N,Nu,D,lambda1);
    [M2,Mp2,K2]=macierzMMPiK(s6,N,Nu,D,lambda2);
elseif liczbaOdpowiedzi==3
    [M1,Mp1,K1]=macierzMMPiK(s1,N,Nu,D,lambda1);
    [M2,Mp2,K2]=macierzMMPiK(s3,N,Nu,D,lambda2);
    [M3,Mp3,K3]=macierzMMPiK(s6,N,Nu,D,lambda3);
elseif liczbaOdpowiedzi==4
    [M1,Mp1,K1]=macierzMMPiK(s1,N,Nu,D,lambda1);
    [M2,Mp2,K2]=macierzMMPiK(s2,N,Nu,D,lambda2);
    [M3,Mp3,K3]=macierzMMPiK(s4,N,Nu,D,lambda3);
    [M4,Mp4,K4]=macierzMMPiK(s6,N,Nu,D,lambda4);
    
elseif liczbaOdpowiedzi==5
   [M1,Mp1,K1]=macierzMMPiK(s1,N,Nu,D,lambda1);
   [M2,Mp2,K2]=macierzMMPiK(s2,N,Nu,D,lambda2);
   [M3,Mp3,K3]=macierzMMPiK(s3,N,Nu,D,lambda3);
   [M4,Mp4,K4]=macierzMMPiK(s4,N,Nu,D,lambda4);
   [M5,Mp5,K5]=macierzMMPiK(s6,N,Nu,D,lambda5);
else
    [M1,Mp1,K1]=macierzMMPiK(s1,N,Nu,D,lambda1);
    [M2,Mp2,K2]=macierzMMPiK(s2,N,Nu,D,lambda2);
    [M3,Mp3,K3]=macierzMMPiK(s3,N,Nu,D,lambda3);
    [M4,Mp4,K4]=macierzMMPiK(s4,N,Nu,D,lambda4);
    [M5,Mp5,K5]=macierzMMPiK(s5,N,Nu,D,lambda5);
    [M6,Mp6,K6]=macierzMMPiK(s6,N,Nu,D,lambda6);
end

%% petla regulacji
sendControls ([ 1, 5], [ 50, Upp]) ;

for k=2:simulation_time
    Y(k) = readMeasurements(1);
    w=aktywacjaDMC(liczbaOdpowiedzi,Y(k));
    y(k)=Y(k)-Ypp;
    

    if liczbaOdpowiedzi==2
        dU1=dmc_inny(Mp1,K1,N,y(k),yzad(k),duPop);
        dU2=dmc_inny(Mp2,K2,N,y(k),yzad(k),duPop);
        du=dU1*w(1)+dU2*w(2);
        
    elseif liczbaOdpowiedzi==3
        dU1=dmc_inny(Mp1,K1,N,y(k),yzad(k),duPop);
        dU2=dmc_inny(Mp2,K2,N,y(k),yzad(k),duPop);
        dU3=dmc_inny(Mp3,K3,N,y(k),yzad(k),duPop);
        du=dU1*w(1)+dU2*w(2)+dU3*w(3);
    elseif liczbaOdpowiedzi==4
        dU1=dmc_inny(Mp1,K1,N,y(k),yzad(k),duPop);
        dU2=dmc_inny(Mp2,K2,N,y(k),yzad(k),duPop);
        dU3=dmc_inny(Mp3,K3,N,y(k),yzad(k),duPop);
        dU4=dmc_inny(Mp4,K4,N,y(k),yzad(k),duPop);
        du=dU1*w(1)+dU2*w(2)+dU3*w(3)+dU4*w(4);

    elseif liczbaOdpowiedzi==5
        dU1=dmc_inny(Mp1,K1,N,y(k),yzad(k),duPop);
        dU2=dmc_inny(Mp2,K2,N,y(k),yzad(k),duPop);
        dU3=dmc_inny(Mp3,K3,N,y(k),yzad(k),duPop);
        dU4=dmc_inny(Mp4,K4,N,y(k),yzad(k),duPop);       
        dU5=dmc_inny(Mp5,K5,N,y(k),yzad(k),duPop);
        du=dU1*w(1)+dU2*w(2)+dU3*w(3)+dU4*w(4)+dU5*w(5);
    else
        dU1=dmc_inny(Mp1,K1,N,y(k),yzad(k),duPop);
        dU2=dmc_inny(Mp2,K2,N,y(k),yzad(k),duPop);
        dU3=dmc_inny(Mp3,K3,N,y(k),yzad(k),duPop);
        dU4=dmc_inny(Mp4,K4,N,y(k),yzad(k),duPop);       
        dU5=dmc_inny(Mp5,K5,N,y(k),yzad(k),duPop);
        dU5=dmc_inny(Mp6,K6,N,y(k),yzad(k),duPop);
        du=dU1*w(1)+dU2*w(2)+dU3*w(3)+dU4*w(4)+dU5*w(5)+dU6*w(6);
    end
    
    u(k)=u(k-1)+du;
    
    if u(k)> uMax
		u(k) = uMax; 
    end
    if u(k)< uMin
        u(k) = uMin;
    end
    
    du = u(k) - u(k-1);
    
    duPop = [du; duPop(1:end-1)];
    
    U(k)=u(k)+Upp;
    sendNonlinearControls(U(k));
    
    
    figure(1);
    subplot(2,1,1)
    plot(1:k, Y(1:k),'LineWidth', 1.1); % Wyjscie obiektu
    hold on
    plot(1:k, Yzad(1:k),'LineWidth', 1.1); % zadana
    hold off
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












