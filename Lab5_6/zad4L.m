addpath ('D:\SerialCommunication'); % add a path
initSerialControl COM2 % initialise com port

Ypp = 32;
Upp = 26;

simulationTime = 1200;
start = 3;

K1 = 10;
Ti1 = 20;
Td1 = 10;

K2 = 15;
Ti2 = 5;
Td2 = 10;

K3 = 12;
Ti3 = 15;
Td3 = 15;
T = 1;

UMin = 0;
UMax = 100;
uMin = UMin-Upp; 
uMax = UMax-Upp; 

YZad = zeros(simulationTime,1);
YZad(1:simulationTime/3) = Ypp;  
YZad(simulationTime/3:simulationTime*2/3)= Ypp+5;
YZad(simulationTime*2/3:end)= Ypp+15;
yZad = YZad-Ypp;
    
    
Y = ones(simulationTime,1)*Ypp;
y = zeros(simulationTime,1);
U = ones(simulationTime,1)*Upp;
u = zeros(simulationTime,1);
	
    
r01 = K1 * (1 + T/(2*Ti1) + Td1/T);
r11 = K1 * (T/(2*Ti1) - 2*Td1/T - 1);
r21 = K1 * Td1/T;

r02 = K2 * (1 + T/(2*Ti2) + Td2/T);
r12 = K2 * (T/(2*Ti2) - 2*Td2/T - 1);
r22 = K2 * Td2/T;

r03 = K3 * (1 + T/(2*Ti3) + Td3/T);
r13 = K3 * (T/(2*Ti3) - 2*Td3/T - 1);
r23 = K3 * Td3/T;


errorR0 = 0;
errorR1 = 0;
errorR2 = 0;

h = animatedline('Marker','o');
for k = start : 1 : simulationTime
    Y(k) = readMeasurements (1) ; % read measurements T1
    y(k) = Y(k)- Ypp;
    errorR0 = yZad(k) - y(k);
        
	% PID eqation
    [w1 w2 w3] = zadL_aktywacja(y(k));
    u1 = u(k-1) + r01 * errorR0 + r11 * errorR1 + r21 * errorR2;
    u2 = u(k-1) + r02 * errorR0 + r12 * errorR1 + r22 * errorR2;
    u3 = u(k-1) + r03 * errorR0 + r13 * errorR1 + r23 * errorR2;
	u(k) = u1*w1 + u2*w2 + u3*w3;
        
	% limitations
    du = u(k)-u(k-1);

    % Prawo regulacji
    u(k) = u(k-1) + du;

    if u(k)> uMax
		u(k) = uMax; 
    end
    if u(k)< uMin
        u(k) = uMin;
    end
    
    
    U(k)=u(k)+Upp;
    dlmwrite('PID_ROZMYTY.txt', readMeasurements(1), '-append');
    dlmwrite('PID_ROZMYTY_STEROWANIE.txt', U(k), '-append');
    disp(readMeasurements(1)); % process measurements
    disp(U(k));
    addpoints(h,k,readMeasurements(1));
    drawnow;
    
        
    sendNonlinearControls(U(k));
    errorR2 = errorR1;
    errorR1 = errorR0;
    waitForNewIteration ();
end

E = sum((yZad-Y).^2);
