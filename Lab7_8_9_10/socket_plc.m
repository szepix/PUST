%%Socket Communication demo script
delete(instrfindall)
pause(2);

close all;
clear all; 
  
t = tcpip('192.168.127.250',4000, 'NetworkRole', 'client');

t.OutputBufferSize = 3000;
t.InputBufferSize = 3000;
 
fopen(t);
u1 = [];
u2 = [];
y1 = [];
y2 = [];
yz1 = [];
yz2 = [];

figure(1);
while (length(y1) < 1000)
    if (t.BytesAvailable ~= 0)
        temp = fscanf(t);
        %disp(temp);
        eval(temp);
        u1 = [u1; U1];
        u2 = [u2; U2];
        y1 = [y1; Y1];
        y2 = [y2; Y2];
        yz1 = [yz1; YZ1];
        yz2 = [yz2; YZ2];
%         dlmwrite('Y1_skok_u2_20.txt', Y1, '-append');
%         dlmwrite('Y2_skok_u2_20.txt', Y2, '-append');
%         dlmwrite('U1_skok_u2_20.txt', U1, '-append');
%         dlmwrite('U2_skok_u2_20.txt', U2, '-append');
        subplot(2,1,1); plot(y1); hold on; plot(y2); hold off; title('Wyjœcie'); xlabel('iteracja');
        legend(["Y1", "Y2"], "Location", 'bestoutside');
        subplot(2,1,2); stairs(u1); hold on; stairs(u2); hold off; title('Sterowanie'); xlabel('iteracja');
        legend(["U1", "U2"], "Location", 'bestoutside');
        drawnow
    end
    pause(0.05);
end

fclose(t);
delete(t);
clear t;

