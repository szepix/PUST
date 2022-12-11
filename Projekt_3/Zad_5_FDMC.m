clear; clc;
%% Parametry programu
draw = true;
sa = false;
draw_f_przyn = true;

set(0,'DefaultStairLineWidth',1);
Umax = 1;
Umin = -1;

%% Parametry regulatora
Nu = 2.000;
N = 16.000;
D = 40;
lamb = 0.1614;

%liczba regulatorów
il_fun = 3;
lamb = lamb*ones(1,il_fun);


ku = zeros(il_fun,D-1);
ke = zeros(1,il_fun);

%% Liczenie poszczególnych regulatorów

for r = 1:il_fun
%     s = Zad_4_generate_step(y);
        
    M=zeros(N,Nu);
        for i=1:N
           for j=1:Nu
              if (i>=j)
                 M(i,j)=s(i-j+1);
              end
           end
        end
        

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
    
    K = ((M'*M + lamb(r) * eye(Nu))^(-1))* M';
    ku(r,:) = K(1,:)*MP;
    ke(r) = sum(K(1,:));
end

%% Symulacja obiektu

%warunki_początkowe
kp = D/T + 2;
ks = max(19,D+100); %chwila skoku wartosci zadania
kk = t_sym/T;
v1(1:kp) = v1_0;
v2(1:kp) = v2_0;
h2(1:kp) = h2_0;
h1(1:kp) = h1_0;
F1in(1:T:kp) = F1;
FD = 15;
FDc(1:T:t_sym/T) = FD;

%Skok wartosci zadanej:
yzad(1:ks)=38.44; 
yzad(ks:5000)=30;
yzad(5000:10000)=80;
yzad(10000:15000)=20;
yzad(15000:20000)=40;


error = 0;
w = zeros(1,il_fun);
Du = zeros(il_fun,1);
DUp = zeros(1,D-1);
Y = zeros(N,1);
err_cur = 0;
err_sum = 0;

%główne wykonanie programu
for k=kp:kk
    for n=1:N


    end
    %symulacja obiektu
    v1(k) = v1(k-1) + T*(F1in(k-1-(tau/T)) + FDc(k-1) - ap1*sqrt(h1(k-1)));
    v2(k) = v2(k-1) + T*(ap1*sqrt(h1(k-1)) - ap2*(sqrt(h2(k-1))));
    h1(k) = v1(k)/A1;
    h2(k) = sqrt(v2(k)/C2);
    
    %Liczenie błędu
    err_cur = yzad(k) - h2(k);
    err_sum = err_sum + norm((yzad(k) - h2(k)))^2;


    %Liczenie wartości przyrostu sterowania
    for i = 1:il_fun

        Du(i) = ke(i)*err_cur-ku(i,:)*DUp';

        if i == 1
            w(i) = trapmf(h2(k),[0 0 c(1)-nach/2 c(1)+ nach/2]);
        elseif i == il_fun
            w(i) = trapmf(h2(k),[c(il_fun-1)-nach/2 c(il_fun-1)+nach/2 h_max h_max]);
        else
            w(i) = trapmf(h2(k),[c(i-1)-nach/2 c(i-1)+ nach/2 c(i)-nach/2 c(i)+ nach/2]);
        end
    end
    
    %Sprawdzenie liczenia wag
    w_over_time(:,k) = w;

    %Ogranieczenia przyrostu sterowania
    DUfin = w * Du / sum(w);
    
    if DUfin > DUmax
        DUfin = DUmax;
    elseif DUfin < -DUmax
        DUfin = -DUmax;
    end

    for i = D-1:-1:2
      DUp(i) = DUp(i-1);
    end
    DUp(1) = DUfin;

    F1in(k) = F1in(k-1) + DUp(1);

    %Ograniczenia sterowania
    if F1in(k) > Umax
        F1in(k) = Umax;
    elseif F1in(k) < Umin
        F1in(k) = Umin;
    end

end

if draw
iteracja = 0:1:kk-1;
%Plot wyjście
figure;
stairs(iteracja, h2)
hold on;
stairs(iteracja, yzad,"--");
hold off;
xlabel('k'); ylabel("h");
legend("h_2","h_2_z_a_d")
% exportgraphics(gca,'DMC_rozm_zmiana_wart.pdf')

%Plot sterowanie
figure;
stairs(iteracja, F1in)
legend("F_1_i_n")
xlabel('k'); ylabel("F_1_i_n");
% exportgraphics(gca,'DMC_rozm_zmiana_ster.pdf')
end

display(err_sum)

