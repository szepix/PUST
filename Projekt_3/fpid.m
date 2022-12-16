%% wybor regulatora
 regulator='PID';
% regulator='DMC';

%% nastawy
E=0;
T = 0.5;  % okres probkowania

%dla 2 reg 1+6
%dla 3 reg 1+3+6
%dla 4 reg 1+3+4+6
%dla 5 reg 1+2+3+4+6
liczbaReg=2;

Kp1 = 5;    % wzmocnienie
Td1 = 50;   % czas wyprzedzenia
Ti1 = 1;   % czas zdwojenia

Kp2 = 8;    % wzmocnienie
Td2 = 50;   % czas wyprzedzenia
Ti2 = 1;    % czas zdwojenia

Kp3 = 0.2;    % wzmocnienie
Td3 = 0.8;   % czas wyprzedzenia
Ti3 = 3;    % czas zdwojenia

Kp4 = 0.1;    % wzmocnienie
Td4 = 1;   % czas wyprzedzenia
Ti4 = 4;    % czas zdwojenia

Kp5 = 1;    % wzmocnienie
Td5 = 1;   % czas wyprzedzenia
Ti5 = 0.375;    % czas zdwojenia

Kp6 = 0.15;    % wzmocnienie
Td6 = 1;   % czas wyprzedzenia
Ti6 = 3;    % czas zdwojenia


%% inicjalizacja 

len=1400; %dlugosc symulacji
delay = 7;
yZad=zeros(len,1);
yZad(1:200)=0;
yZad(201:400)=11;
yZad(401:600)=-0.1;
yZad(601:900)=5;


%pid
e=zeros(len,1);
y=zeros(len,1);
u=zeros(len,1);
u1=zeros(len,1);
u2=zeros(len,1);
u3=zeros(len,1);
%% wspolczynniki regulatora PID

r01= Kp1 * (1+ T/(2*Ti1) + Td1/T);
r11= Kp1 * (T/(2*Ti1) - 2*Td1/T - 1);
r21= Kp1 * Td1/T;

r02= Kp2 * (1+ T/(2*Ti2) + Td2/T);
r12= Kp2 * (T/(2*Ti2) - 2*Td2/T - 1);
r22= Kp2 * Td2/T;

r03= Kp3 * (1+ T/(2*Ti3) + Td3/T);
r13= Kp3 * (T/(2*Ti3) - 2*Td3/T - 1);
r23= Kp3 * Td3/T;

r04= Kp4 * (1+ T/(2*Ti4) + Td4/T);
r14= Kp4 * (T/(2*Ti4) - 2*Td4/T - 1);
r24= Kp4 * Td4/T;

r05= Kp5 * (1+ T/(2*Ti5) + Td5/T);
r15= Kp5 * (T/(2*Ti5) - 2*Td5/T - 1);
r25= Kp5 * Td5/T;

r06= Kp6 * (1+ T/(2*Ti6) + Td6/T);
r16= Kp6 * (T/(2*Ti6) - 2*Td6/T - 1);
r26= Kp6 * Td6/T;



%% petla regulacji

for k=delay:len
    if strcmp(regulator,'PID')
        
        y(k) = symulacja_obiektu1y_p3(u(k-5), u(k-6), y(k-1), y(k-2));
        
        w=aktywacjaDMC(liczbaReg,y(k));
        
        E=E+(yZad(k)-y(k))^2;
        e(k) = (yZad(k)-y(k));
        
        u1(k) = r21*e(k-2) + r11*e(k-1) + r01*e(k) + u(k-1);
        u2(k) = r22*e(k-2) + r12*e(k-1) + r02*e(k) + u(k-1);
        u3(k) = r23*e(k-2) + r13*e(k-1) + r03*e(k) + u(k-1);
        u4(k) = r24*e(k-2) + r14*e(k-1) + r04*e(k) + u(k-1);
        u5(k) = r25*e(k-2) + r15*e(k-1) + r05*e(k) + u(k-1);
        u6(k) = r26*e(k-2) + r16*e(k-1) + r06*e(k) + u(k-1);
        
    if liczbaReg==2
        u(k)=w(1)*u1(k)+w(2)*u6(k);
        
    elseif liczbaReg==3    
        u(k)=w(1)*u1(k)+w(2)*u3(k)+w(3)*u6(k);
        
    elseif liczbaReg==4

       u(k)=w(1)*u1(k)+w(2)*u3(k)+w(3)*u4(k)+w(4)*u6(k);

    elseif liczbaReg==5

       u(k)=w(1)*u1(k)+w(2)*u2(k)+w(3)*u3(k)+w(4)*u4(k)+w(5)*u6(k);
    else

       u(k)=w(1)*u1(k)+w(2)*u2(k)+w(3)*u3(k)+w(4)*u4(k)+w(5)*u5(k)+w(6)*u6(k);
    end
    
        

        
        if u(k) < -1
            u(k) = -1;
        elseif u(k)>1
            u(k) = 1;
        end
    end
end

plot(y);
hold on;
plot(yZad,"g--");

% if strcmp(regulator,'DMC')
% save(strcat('zad3P_',regulator,"_","N",num2str(N),"Nu",num2str(Nu),"D",num2str(D),"lamb",num2str(lambda),'.mat'),'y');
% end
% if strcmp(regulator,'PID')
% save(strcat('zad3P_',regulator,"_","K",num2str(Kp),"Td",num2str(Td),"Ti",num2str(Ti),'.mat'),'y');  
% end

E
