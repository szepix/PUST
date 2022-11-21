options = gaoptimset("StallGenLimit", 100, "PopulationSize", 500);
% [zmienne] = fmincon(@aproksymacja, [1, 10, 5], [0 -1 0], 10)

values = importdata("skok_z_30.txt");
s = zeros(1,400);

for i = 1:400
    s(i) = (values(i) - values(1))/20;
end
y=zeros(1,400);
T1= 0.8851;
T2= 90.15;
K= 0.2208;
Td=10;
alpha1=exp(-1/T1);
alpha2=exp(-1/T2);
a1=-alpha1-alpha2;
a2=alpha1*alpha2;
b1=K/(T1-T2) * (T1*(1-alpha1)-T2*(1-alpha2));
b2=K/(T1-T2) * (alpha1*T1*(1-alpha2)-alpha2*T1*(1-alpha1));

u=ones(1,400);


for k=Td+3:400
    y(k)=b1*u(k-Td-1)+b2*u(k-Td-2)-a1*y(k-1)-a2*y(k-2);
end

plot(s)
hold on
plot(y)
xlim([0, 500]);
title("Odpowiedz skokowa")
ylabel("T [C]")
xlabel("t [s]")
legend("Odpowiedź obiektu", "Odpowiedź aproksymowana", "Location", "southeast");
set(get(gca,'ylabel'),'rotation',0)
exportgraphics(gca,'odp_skok_aproksymowana.pdf')

