clear all

values = importdata("DMC_NASTAWY_POPRAWIONE7_STEROWANIE.txt");
y_zad(1:500) = 35;
y_zad(500:1000) = 30;
for i=1:length(values)
e(i) = values(i) - y_zad(i);
end
Blad=(norm(e))^2
plot(values)
% hold on
% plot(y_zad)
% hold off
ylabel("Y")
xlabel("k")
% title("E = " + Blad); 
set(get(gca,'ylabel'),'rotation',0)
exportgraphics(gca,'DMC_NASTAWY_POPRAWIONE7_STEROWANIE.pdf')