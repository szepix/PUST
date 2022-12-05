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
    k = 3;
    yzad(k:300+k) = 32;
    yzad(300+k:600+k) = 37;
    yzad(600+k:900+k) = 32+15;
    yzad(900+k:1200+k) = 32;
    e(1:3) = 0;
    U(1:2) = 26;
    Error = 0;
%     addpoints(h,1:1000,y_zad);
    while(1)
        %% obtaining measurements
        measurements = readMeasurements(1); % read measurements from 1 to 7
        
        
        %% processing of the measurements and new control values calculation
        Y(k) = measurements;
        e(k) = yzad(k) - Y(k);
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
        dlmwrite('PID_NIELINIOWY.txt', measurements, '-append');
        dlmwrite('PID_NIELINIOWY_STEROWANIE.txt', U_now, '-append');
        disp(measurements); % process measurements
        disp(U(k));
        Error = Error + norm((yzad(k)-Y(k)))^2;
        %% sending new values of control signals
        sendControls([ 1, 2, 3, 4, 6], ... send for these elements
                     [W1, 0, 0, 0, 0]);  % new corresponding control values
        sendNonlinearControls(U(k));
        %%36 26 46 26 16
        addpoints(h,k,measurements);
        drawnow;
        k = k + 1;
        %% synchronising with the control process
        waitForNewIteration(); % wait for new batch of measurements to be ready
    end


%% Symulacja obiektu

