clear all
addpath('D:\SerialCommunication'); % add a path to the functions
initSerialControl COM2% initialise com port
W1 = 50;
G1 = 26;
i = 0;
%% Parametry Regulatora

Tp = 1;
values = importdata("skok_46.txt");
s = zeros(1,500);

for i = 1:500
    s(i) = (values(i) - values(1))/20;
end

%Horyzonty
D = 400; %Horyzont Dynamiki
N= 20;    %Horyzont predykcji
Nu = 20; %Horyzont sterowania

%Współczynnik kary
lamb = 0.3;
k = D+1;
%War początkowe
u(1:k) = 26; y(1:k) = 32;
yzad(k:500+k) = 35;
yzad(500+k:1000+k) = 30;
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

K = ((M'*M + lamb * eye(Nu))^(-1))* M';
DUp = zeros(D-1, 1);
Y = zeros(N,1);
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
    %stała trajektoria referencyjna
    for n=1:N
        Y(n) = y(k);
    end
    %DMC
    for n = 1:D-1
        DUp(n) = u(k-n) - u(k-n-1);
    end
    Yo = MP*DUp+Y;
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
    sendControls([ 1, 2, 3, 4, 5, 6], ... send for these elements
                 [W1, 0, 0, 0, wejscie_u(k), 0]);  % new corresponding control values
    %%36 26 46 26 16
    k = k + 1;
    
    %% synchronising with the control process
    waitForNewIteration(); % wait for new batch of measurements to be ready
end


%% Symulacja obiektu