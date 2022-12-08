
% Symulacja rozmytego algorytmu DMC. 
addpath ('D:\SerialCommunication'); % add a path
initSerialControl COM2 % initialise com port
W1 = 50;
sendControls (1,50);
Umin =0; Umax = 100;
simulationTime = 1200;
Ypp = 32;
YZad(1:300) = Ypp;  
YZad(300:600)= Ypp+5;
YZad(600:900)= Ypp+15;
YZad(900:1200) = Ypp;
    

Y = ones(simulationTime,1);
u = ones(simulationTime,1);


D = 300;
N = 300;
Nu = 300;


%% odpowiedzi skokowe
values = importdata("skok_G_30.txt");
values2 = importdata("skok_G_60.txt");
values3 = importdata("skok_G_80.txt");

s1 = zeros(1,350);
s2 = zeros(1,350);
s3 = zeros(1,350);
for i = 1:350
    s1(i) = (values(i) - values(1))/10;
end
for i = 1:350
    s2(i) = (values2(i) - values2(1))/10;
end
for i = 1:350
    s3(i) = (values2(i) - values2(1))/10;
end
lambda1=1;
lambda2=1;
lambda3=1;
[M1,MP1,K1]=macierzMMPiK(s1,N,Nu,D,lambda1);
[M2,MP2,K2]=macierzMMPiK(s2,N,Nu,D,lambda2);
[M3,MP3,K3]=macierzMMPiK(s3,N,Nu,D,lambda3);
%% inicjalizacja

%% petla regulacji

for k=2:simulation_time
    Y(k) = readMeasurements(1);
    [w1 w2 w3] = zadL_aktywacja(y(k));
    for n=1:N
        Y(n) = y(k);
    end
    %DMC
    for n = 1:D-1
        DUp(n) = u(k-n) - u(k-n-1);
    end
    Yo1 = MP1*DUp+Y;
    DU1 = K1*(YZad - Yo1);

    Yo2 = MP2*DUp+Y;
    DU2 = K2*(YZad - Yo2);

    Yo3 = MP3*DUp+Y;
    DU1 = K3*(YYZad - Yo3);

    du=DU1*w1+DU2*w2+DU3*w3;
 
    u(k)=u(k-1)+du;
    
    if u(k)> Umax
		u(k) = Umax; 
    end
    if u(k)< Umin
        u(k) = Umin;
    end
    
    du = u(k) - u(k-1);
    
    
    dlmwrite('DMC_ROZMYTY.txt', readMeasurements(1), '-append');
    dlmwrite('DMC_ROZMYTY_STEROWANIE.txt', u(k), '-append');
    disp(readMeasurements(1)); % process measurements
    disp(Y(k));
    addpoints(h,k,readMeasurements(1));
    drawnow;
    
    sendControls([ 1, 2, 3, 4, 6], ... send for these elements
                     [W1, 0, 0, 0, 0]);  % new corresponding control values
    sendNonlinearControls(U(k));

    drawnow
    waitForNewIteration (); % wait for new iteration  
end












