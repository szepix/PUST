function [w1,w2,w3] = zadL_aktywacja(w)
    % w1-3 wspolczynniki
    % wejscie
    x=30:0.01:55;
    range = linspace(30,55,3);
    y1 = gaussmf(x, [5 range(1)]);
    y2 = gaussmf(x, [5 range(2)]);
    y3 = gaussmf(x, [5 range(3)]);
    figure
    plot(x,y1);
    hold on;
    plot(x,y2);
    plot(x,y3);
    sum=y1+y2+y3;
    w1=y1/sum;
    w2=y2/sum;
    w3=y3/sum;