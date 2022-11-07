

plot([16 26 36 46],[30.25,33.3,36,39.37])
title("Charakterystyka statyczna")
ylabel("T [C]")
xlabel("G_1")
set(get(gca,'ylabel'),'rotation',0)
xlim([16, 46])
exportgraphics(gca,'char_stat.pdf')
