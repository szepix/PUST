

plot([20 30 40 50 60 70 80],[29.62 34.25 38.43 42.5 45 47.2 49.12])
hold on

title("Charakterystyka statyczna")
ylabel("T [C]")
xlabel("G")
set(get(gca,'ylabel'),'rotation',0)
xlim([20, 80])
% exportgraphics(gca,'char_stat.pdf')
for x=10:80
y(x) = 17.98214 + 0.6414405*x - 0.003156476*x^2
end
plot(y)