[X] = fmincon(@aproksymacja, [1, 2, 3], [], []);
X
T1 = X(1);
T2 = X(2);
K=X(3);
Td=10;
y(1:450) = 0;
u(1:450) = 1;

values = importdata("skok_z_30.txt");
s = zeros(1,450);

for i = 1:450
    s(i) = (values(i) - values(1))/30;
end

alpha1 = exp(-1/T1);
alpha2 = exp(-1/T2);
a1 = -alpha1-alpha2;
a2 = alpha1 * alpha2;
b1 = K*(T1*(1-alpha1)-T2*(1-alpha2))/(T1-T2);
b2 = K*(alpha1*T2*(1-alpha2)-alpha2*T1*(1-alpha1))/(T1-T2);
%dziala 6.8000   77.7994    0.1415
for k = Td+3:450
    y(k) = b1*u(k - Td - 1) + b2*u(k-Td-2)-a1*y(k-1)-a2*y(k-2);
end
plot(s)
hold on
plot(y)

