[zmienne] = fmincon(@aproksymacja, [1, 2, 3], [], []);
zmienne
T1 = zmienne(1);
T2 = zmienne(2);
K=zmienne(3);
Td=0;
y(1:80) = 0;
u(1:80) = 1;
x = [20 30 40 50 60 70 80]
values = [29.62 34.25 38.43 42.5 45 47.2 49.12]

alpha1 = exp(-1/T1);
alpha2 = exp(-1/T2);
a1 = -alpha1-alpha2;
a2 = alpha1 * alpha2;
b1 = K*(T1*(1-alpha1)-T2*(1-alpha2))/(T1-T2);
b2 = K*(alpha1*T2*(1-alpha2)-alpha2*T1*(1-alpha1))/(T1-T2);
for k = 20:10:80
    y(k) = b1*u(k - Td - 1) + b2*u(k-Td-2)-a1*y(k-1)-a2*y(k-2);
end
plot(s)
hold on
plot(y)
xlim([0 300]);
