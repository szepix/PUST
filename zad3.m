values = importdata("skok_46.txt");
s = zeros(1,length(values));

for i = 1:length(values)
    s(i) = (values(i) - values(1))/20;
end


plot(s)
xlim([0, 500]);
title("Odpowiedz skokowa")
ylabel("T [C]")
xlabel("t [s]")
set(get(gca,'ylabel'),'rotation',0)
exportgraphics(gca,'odp_skok.pdf')