function [w1,w2,w3] = zadL_aktywacja(w)
    % w1-3 wspolczynniki
    % wejscie
    x=30:0.01:55;
    y1 = gbellmf(x,[8 5 36]);
    y2 = gbellmf(x,[2 5 47]);
    y3 = gbellmf(x,[2 5 51]);
%     figure
%     plot(x,y1);
%     hold on;
%     plot(x,y2);
%     plot(x,y3);
    sum=y1+y2+y3;
    w1=y1/sum;
    w2=y2/sum;
    w3=y3/sum;