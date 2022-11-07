function MinimalWorkingExample()
    addpath('D:\SerialCommunication'); % add a path to the functions
    initSerialControl COM2% initialise com port
    while(1)
        %% obtaining measurements
        measurements = readMeasurements(1); % read measurements from 1 to 7
        
        dlmwrite('skok_36.txt', measurements, '-append');
        
        %% processing of the measurements and new control values calculation
        disp(measurements); % process measurements
        
% 1. W1 – wentylator sterowany sygnałem 0-100 (co odpowiada mocy 0%-100% elementu),
% 2. W2 – wentylator sterowany sygnałem 0-100 (co odpowiada mocy 0%-100% elementu),
% 3. W3 – wentylator sterowany sygnałem 0-100 (co odpowiada mocy 0%-100% elementu),
% 4. W4 – wentylator sterowany sygnałem 0-100 (co odpowiada mocy 0%-100% elementu),
% 5. G1 – grzałka sterowana sygnałem 0-100 (co odpowiada mocy 0%-100% elementu),
% 6. G2 – grzałka sterowana sygnałem 0-100 (co odpowiada mocy 0%-100% elementu
        %% sending new values of control signals
        sendControls([ 1, 2, 3, 4, 5, 6], ... send for these elements
                     [50, 0, 0, 0, 36, 0]);  % new corresponding control values
        %%36 26 46 26 16
        %% synchronising with the control process
        waitForNewIteration(); % wait for new batch of measurements to be ready
    end
end