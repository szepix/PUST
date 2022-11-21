clear all
addpath('D:\SerialCommunication'); % add a path to the functions
initSerialControl COM2% initialise com port
W1 = 50;
G1 = 26;
i = 0;

h = animatedline('Marker','o');
%% Parametry Regulatora

Tp = 1;
values = importdata("skok_46.txt");

s = zeros(1,500);

for i = 1:500
    s(i) = (values(i) - values(1))/20;
end

values_z = importdata("skok_z_30.txt");
s_z = zeros(1,400);
for i=1:400
    s_z(i) = (values(i) - values(1))/30;
end

%Horyzonty
D = 400; %Horyzont Dynamiki
Dz = 400; %Horyzont Dynamiki toru Z
N= 40;    %Horyzont predykcji
Nu = 40; %Horyzont sterowania

%Współczynnik kary
lamb = 0.35;
k = D+1;
%War początkowe
u(1:k) = 26; y(1:k) = 32;
yzad(k:300+k) = 35;
yzad(300+k:600+k) = 38;
e(1:k) = 0;

%Macierz M
M=zeros(N,Nu);
for i=1:N
   for j=1:Nu
      if (i>=j)
         M(i,j)=s(i-j+1);
      end
   end
end

%Macierz MP
MP=zeros(N,D-1);
for i=1:N
   for j=1:D-1
      if i+j<=D
         MP(i,j)=s(i+j)-s(j);
      else
         MP(i,j)=s(D)-s(j);
      end      
   end
end

MZP = zeros(N, Dz-1);
for i=1:N
   for j=1:Dz-1
      if i+j<=Dz
      MZP(i,j)=s_z(i+j)-s_z(j);
      else
      MZP(i,j)=s(Dz)-s(j);
      end
   end
end

K = ((M'*M + lamb * eye(Nu))^(-1))* M';
DUp = zeros(D-1, 1);
dZ = zeros(Dz-1, 1);
Z = zeros(k,1);
Y = zeros(N,1);
Z_war = 0;
while(1)
    %% obtaining measurements
    measurements = readMeasurements(1); % read measurements from 1 to 7
    %% processing of the measurements and new control values calculation
    
    for n=1:N
    %yzad dla horyzontu predykcji
        Y_zad(n,1) = yzad(k);
    end
    %symulacja obiektu
    y(k)=measurements;
    %zakłócenie
    if(y(k) >= yzad(k))
        Z_war = 30;
    end
    Z(k) = Z_war;
    disp(Z_war);
    %stała trajektoria referencyjna
    for n=1:N
        Y(n) = y(k);
    end

    
    %DMC
    for n = 1:D-1
        DUp(n) = u(k-n) - u(k-n-1);
    end
    for n = 1:Dz-1
        dZ(n) = Z(k-n) - Z(k-n-1); 
    end
%     dz=Z(k)-Z(k-1);
    Yo = MP*DUp+Y+MZP*dZ;
%     Yo = MP*DUp+Y;
    DU = K*(Y_zad - Yo);

    u(k)=u(k-1)+DU(1); 
    if(u(k)> 100)
        u(k) = 100;
    end
    if(u(k)< 0)
        u(k) = 0;
    end
    wejscie_u(k)=u(k);
    wyjscie_y(k)=y(k); 
    

    %% sending new values of control signals
%     sendControlsToG1AndDisturbance
%     dlmwrite('DMC_NASTAWY_2_Z30.txt', measurements, '-append');
%     dlmwrite('DMC_NASTAWY_2_Z30_STEROWANIE.txt', wejscie_u(k), '-append');
    sendControls([ 1, 2, 3, 4, 6], ... send for these elements
                 [W1, 0, 0, 0, 0]);  % new corresponding control values
    sendControlsToG1AndDisturbance(wejscie_u(k), Z(k));
    %%36 26 46 26 16
    addpoints(h,k-400,measurements);
    drawnow;
    disp(measurements);
    disp(wejscie_u(k));
    k = k + 1;
    %% synchronising with the control process
    waitForNewIteration(); % wait for new batch of measurements to be ready
end


%% Symulacja obiektu