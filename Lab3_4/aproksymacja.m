function Blad = aproksymacja(zmienne)
values = importdata("skok_z_30.txt");
s = zeros(1,400);

for i = 1:400
    s(i) = (values(i) - values(1))/20;
end
y=zeros(1,500);
T1= zmienne(1)
T2= zmienne(2)
K= zmienne(3)
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
    e = s' - y;
    Blad=(norm(e))^2
end