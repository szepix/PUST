clear all

values = importdata("skok_16.txt");

plot(values)
title("Skok G_1 = 16")
ylabel("T [C]")
xlabel("t [s]")
set(get(gca,'ylabel'),'rotation',0)
exportgraphics(gca,'skok_16.pdf')