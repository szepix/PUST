clear all

values_1 = importdata("skok_16.txt");
values_2 = importdata("skok_36.txt");
values_3 = importdata("skok_46.txt");

plot(values_1)
hold on
plot(values_2)
plot(values_3)
hold off
xlim([0, 500]);
title("Wielokrotne skoki")
ylabel("T [C]")
xlabel("t [s]")
legend("G_1 = 16","G_1 = 36","G_1 = 46",Location="northoutside")
set(get(gca,'ylabel'),'rotation',0)
exportgraphics(gca,'skok_all.pdf')