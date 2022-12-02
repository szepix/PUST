clear all; close all
name = "DMC_NASTAWY_POPRAWIONE4_Z30"
values = importdata(name + ".txt");
y_zad(1:300) = 35;
y_zad(300:601) = 38;
for i=1:length(values)
e(i) = values(i) - y_zad(i);
end
Blad=(norm(e))^2
plot(values)
hold on
plot(y_zad)
hold off
ylabel("T[C]")
xlabel("k")
xlim([1 601])
title("E = " + Blad); 
set(get(gca,'ylabel'),'rotation',0)
exportgraphics(gca,name +".pdf")

values = importdata(name + "_STEROWANIE.txt");
figure
plot(values);
ylabel("U")
xlabel("k")
xlim([1 600])
exportgraphics(gca,name + "_STEROWANIE.pdf")

% Z = zeros(600,1);
% Z(150:200) = 30;
% Z(450:500) = 30;
% figure
% plot(Z);
% ylabel("Z")
% xlabel("k")
% xlim([1 600])
% exportgraphics(gca,name + "_ZAKLOCENIE.pdf")