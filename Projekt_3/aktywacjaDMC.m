function [w]=aktywacjaDMC(iloscOdpowiedzi,y)
% y-wejscie ukladu
% w-wektor wspolczynnikow
% y=-4:0.01:1;
% iloscOdpowiedzi=3;


if iloscOdpowiedzi==2
    
    w1=gbellmf(y,[2 3 -3]);
    w2=gbellmf(y,[2 3 0]);
    w(1)=w1; w(2)=w2;
    
elseif iloscOdpowiedzi==3
    
    w1=gbellmf(y,[2 3 -3]);
    w2=gbellmf(y,[2 3 -1]);
    w3=gbellmf(y,[2 3 0]);
    w(1)=w1; w(2)=w2; w(3)=w3; 
    
elseif iloscOdpowiedzi==4  
    w1=gbellmf(y,[2 3 -3]);
    w2=gbellmf(y,[2 3 -2]);
    w3=gbellmf(y,[2 3 -1]);
    w4=gbellmf(y,[2 3 0]);
    w(1)=w1; w(2)=w2; w(3)=w3; w(4)=w4;
elseif iloscOdpowiedzi==5
    w1=gbellmf(y,[2 3 -4]);
    w2=gbellmf(y,[2 3 -3]);
    w3=gbellmf(y,[2 3 -2]);
    w4=gbellmf(y,[2 3 -1]);
    w5=gbellmf(y,[2 3 0]);
    w(1)=w1; w(2)=w2; w(3)=w3; w(4)=w4; w(5)=w5;
else
    w1=gbellmf(y,[2 3 -3]);
    w2=gbellmf(y,[2 3 -2.5]);
    w3=gbellmf(y,[2 3 -2]);
    w4=gbellmf(y,[2 3 -1]);
    w5=gbellmf(y,[2 3 -0.5]);
    w6=gbellmf(y,[2 3 0]);
    w(1)=w1; w(2)=w2; w(3)=w3; w(4)=w4; w(5)=w5; w(6)=w6;
end

% plot(y,w1);
% hold on
% plot(y,w2);
% plot(y,w3);
% plot(y,w4);
% plot(y,w5);
% plot(y,w6);

w=w/sum(w);

end