[zmienne] = fmincon(@aproksymacja, [1, 2, 3], [], []);
zmienne
T1 = zmienne(1);
T2 = zmienne(2);
K=zmienne(3);
Td=14;
y(1:300) = 0;
u(1:300) = 1;

values = importdata("skok_z_30.txt");
s = zeros(1,300);

for i = 1:300
    s(i) = (values(i) - values(1))/30;
end

alpha1 = exp(-1/T1);
alpha2 = exp(-1/T2);
a1 = -alpha1-alpha2;
a2 = alpha1 * alpha2;
b1 = K*(T1*(1-alpha1)-T2*(1-alpha2))/(T1-T2);
b2 = K*(alpha1*T2*(1-alpha2)-alpha2*T1*(1-alpha1))/(T1-T2);
for k = Td+3:300
    y(k) = b1*u(k - Td - 1) + b2*u(k-Td-2)-a1*y(k-1)-a2*y(k-2);
end
plot(s)
hold on
plot(y)
xlim([0 300]);
