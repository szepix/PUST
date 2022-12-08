

plot([10 20 30],[34.4,36,37.6])
title("Charakterystyka statyczna")
ylabel("T [C]")
xlabel("Z")
set(get(gca,'ylabel'),'rotation',0)
xlim([10, 30])
exportgraphics(gca,'char_stat.pdf')
