clear all
    addpath('D:\SerialCommunication'); % add a path to the functions
    initSerialControl COM2% initialise com port
    W1 = 50;
    G1 = 26;
    h = animatedline('Marker','o');
    i = 0;
    %% Parametry Regulatora

    Kp = 5;
    Ti = 20;
    Td = 1;
    T = 1;
    
    r0 = Kp*(1 + T/(2*Ti) + Td/T);
    r1 = Kp*(T/(2*Ti) - (2*Td)/T -1);
    r2 = Kp*Td/T;
    
    y_zad(1:500) = 35;
    y_zad(500:1000) = 30;
    e(1:3) = 0;
    k = 3;
    U(1:2) = 26;
%     addpoints(h,1:1000,y_zad);
    while(1)
        %% obtaining measurements
        measurements = readMeasurements(1); % read measurements from 1 to 7
        
        
        %% processing of the measurements and new control values calculation
        Y(k) = measurements;
        e(k) = y_zad(k) - Y(k);
        U_now = U(k-1) + r0*e(k) + r1*e(k-1) + r2*e(k-2);
        
% 1. W1 – wentylator sterowany sygnałem 0-100 (co odpowiada mocy 0%-100% elementu),
% 2. W2 – wentylator sterowany sygnałem 0-100 (co odpowiada mocy 0%-100% elementu),
% 3. W3 – wentylator sterowany sygnałem 0-100 (co odpowiada mocy 0%-100% elementu),
% 4. W4 – wentylator sterowany sygnałem 0-100 (co odpowiada mocy 0%-100% elementu),
% 5. G1 – grzałka sterowana sygnałem 0-100 (co odpowiada mocy 0%-100% elementu),
% 6. G2 – grzałka sterowana sygnałem 0-100 (co odpowiada mocy 0%-100% elementu

        if U_now < 0
             U_now = 0;
         elseif U_now > 100
             U_now = 100;
        end
        U(k) = U_now;
        dlmwrite('PID_NASTAWY_6.txt', measurements, '-append');
        dlmwrite('PID_NASTAWY_6_STEROWANIE.txt', U_now, '-append');
        disp(measurements); % process measurements
        disp(U(k));
        %% sending new values of control signals
        sendControls([ 1, 2, 3, 4, 5, 6], ... send for these elements
                     [W1, 0, 0, 0, U(k), 0]);  % new corresponding control values
        %%36 26 46 26 16
        addpoints(h,k,measurements);
        drawnow;
        k = k + 1;
        %% synchronising with the control process
        waitForNewIteration(); % wait for new batch of measurements to be ready
    end


%% Symulacja obiektu

