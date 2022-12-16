clear; clc;

%% Parametry programu
draw = true;
sa = false;
draw_f_przyn = false;

set(0,'DefaultStairLineWidth',1);
DUmax = 1;
Umax = 120;
Umin = 0;

%% Parametry regulatora
Nu = 100;
N = 100;
D = 100;
lamb = 140;


%liczba regulatorów
il = 5;
lamb = lamb*ones(1,il);


%% Parametry modelu i symulacji

Upp = 0;
Ypp = 0;

err = 0;

Umin = -1;
Umax = 1;

DUmax = 0.01;
DUmin = -0.01;


kp = D+1;
kk = kp+800;

U(1:kp,1) = Upp;
Y(1:kp,1) = Ypp;
e(1:kp) = 0;

yzad(1:kp) = 0;
yzad(kp:350) = 11;
yzad(350:600) = -0.1;
yzad(600:kk) = 5;


%Zmienne zadaniowe
u_min = -1;
u_max = 1;


d = (u_max-u_min)/(il-1); %szerokości funkcji przynależnośći
spread = d/4;

%Wybranie punktu pracy
ur0 = ones(1,il);
ur0(1) = u_min;
    for i = 2:il-1
        ur0(i) = ur0(i-1) + d;
    end
ur0(il) = ur0(il-1) + d;

%% Rysowanie funkcji przyneleżności
if draw_f_przyn
    u = (u_min:0.01:u_max)';
    figure
    hold on
    %Plotter funkcji przynaleznosci
    for i = 1:il
        if i == 1
            plot(u,gaussmf(u,[spread, ur0(1)]));
        elseif i == il
            plot(u,gaussmf(u,[spread, ur0(i)]));
        else
            plot(u,gaussmf(u,[spread, ur0(i)]));        
        end
    end
    xlabel("u"); ylabel("Funkcja przynależności");
    title(sprintf("Funkcja przynaleznosci dla %i zbiorów rozmytych",il))
    hold off
end


ku = zeros(il,D-1);
ke = zeros(1,il);

%% Liczenie poszczególnych regulatorów

for r = 1:il
    s = Zad_5_generate_step(ur0(r));
        
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

error = 0;
w = zeros(1,il);
Du = zeros(il,1);
du = zeros(1,kp);
dUp = zeros(1,D-1);
err_cur = 0;
err_sum = 0;

%główne wykonanie programu
for k=kp:kk
    for n=1:N


    end
    %symulacja obiektu
    Y(k) = symulacja_obiektu1y_p3(U(k-5),U(k-6),Y(k-1),Y(k-2));

    for i=D-1:-1:2
        dUp(i) = dUp(i-1); 
    end
    
    dUp(1) = du(k-1);

    %Liczenie błędu
    err_cur = yzad(k) - Y(k);
    err_sum = err_sum + norm((yzad(k) - Y(k)))^2;


    %Liczenie wartości przyrostu sterowania
    for i = 1:il
        Du(i) = ke(i)*err_cur-ku(i,:)*dUp';
        if i == 1
            w(1,k) = gaussmf(U(k-1),[spread, ur0(1)]);
        elseif i == il
            w(il,k) = gaussmf(U(k-1),[spread, ur0(il)]);
        else
            w(i,k) = gaussmf(U(k-1),[spread, ur0(i)]);   
        end
    end
    

    %Ogranieczenia przyrostu sterowania
    du(k) = w(:,k)' * Du / sum(w(:,k));
    
    U(k) = du(k) + U(k-1);
    
    if(U(k) > Umax); U(k) = Umax; end
    if(U(k) < Umin); U(k) = Umin; end


    du(k) = U(k) - U(k-1);

end


iteracja = 0:1:kk-1;  
%Plot wyjście
figure;
stairs(iteracja, Y)
hold on;
stairs(iteracja, yzad,"--");
hold off;
title("Odpowiedź obiektu na regulację z rozmytym regulatorem DMC")
xlabel('k'); ylabel("y");
legend("y","y_z_a_d", "Location", "northeast")
name = sprintf("DMCF_%i_%i_%i_%2f_przeb.pdf",D,N,Nu,lamb(1));

if sa
    exportgraphics(gca,name)
end

%Plot sterowanie
figure;
stairs(iteracja, U)
title("Sterowanie rozmytego regulatora DMC");
xlabel('k'); ylabel("u");
% legend("Sterowanie regulatora", "Location", "best")
name = sprintf("DMCF_%i_%i_%i_%2f_ster.pdf",D,N,Nu,lamb(1));

if sa
    exportgraphics(gca,name)
end

display(err_sum)
