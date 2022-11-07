clear all

values = importdata("Punkt_Pracy.txt");

plot(values)
title("Punktu pracy")
ylabel("T [C]")
xlabel("t [s]")
set(get(gca,'ylabel'),'rotation',0)
exportgraphics(gca,'Punkt_Pracy.pdf')