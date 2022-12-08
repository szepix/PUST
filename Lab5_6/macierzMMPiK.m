function [M,Mp,K]=macierzMMPiK(s,N,Nu,D,lambda)
        M=zeros(N,Nu); 
        Mp=zeros(N,D-1);
        for i=1:N           
            for j=1:Nu
                if i>=j
                M(i,j)=s(i-j+1); %oblicznie M
                end
            end
        end
        for i=1:N
            for j=1:D-1
                if i+j<D
                Mp(i,j)=s(i+j)-s(j); %oblicznie Mp
                else
                Mp(i,j)=s(D)-s(j);
                end
            end
        end
K=inv(M'*M+eye(Nu)*lambda)*M'; % macierz K


end