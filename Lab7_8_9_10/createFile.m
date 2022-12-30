

close all
fileID = fopen('output.txt','w');

for i=1:2*(D-1)
    fprintf(fileID,'Ku1[%d]:=%f;\n',i, Ku30(1, i));
end
    
for i=1:D
    fprintf(fileID,'Ku2[%d]:=%f;\n',i, Ku30(2, i));
end
    