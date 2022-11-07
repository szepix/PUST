clear all

values = importdata("Wartosc_Z1.txt");

plot(values)
title("Punkt pracy")
ylabel("T [℃]")
xlabel("t [s]")
set(get(gca,'ylabel'),'rotation',0)
exportgraphics(gca,'punkt_pracy.pdf')