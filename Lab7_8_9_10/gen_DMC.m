function [struct] = gen_DMC(nu,ny,lambda,psi,s,N,Nu,D)
% Generacja struktury z wymaganymi do DMC gratami
% nu - liczba wej??
% ny - liczba wyj??
% lambdy - wektor lambd
% psi - wektor psi
% s - wektor komórek s o wymiarach ny x nu
% N - wiadomo
% Nu - wiadomo
% D - wiadomo. Ca?a trójca jest wspólna dla wszystkich

ssize = max(size(s));

for i=1:N           
        for j=1:Nu
            if i>=j
                %oblicznie M
                M(i,j)=s(i-j+1);
            else
                M(i,j)={zeros(ny,nu)};
            end
        end
end


for i=1:N
        for j=1:D-1
            if i+j<ssize
                %oblicznie Mp
                Mp(i,j)={cell2mat(s(i+j))-cell2mat(s(j))};
            else
                Mp(i,j)={cell2mat(s(D))-cell2mat(s(j))};
            end
        end
end
Mp = cell2mat(Mp);

lambdatemp = {diag(lambda)};
for i = 1 : Nu
    for j = 1:Nu
        if i == j
            l(i,j) = lambdatemp;
        else
            l(i,j) = { zeros(nu,nu) };
        end
    end
end

psitemp = {diag(psi)};

for i = 1 : N
    for j = 1:N
        if i == j
            p(i,j) = psitemp;
        else
            p(i,j) = { zeros(ny,ny) };
        end
    end
end

K = (cell2mat(M)'*cell2mat(p)*cell2mat(M)+cell2mat(l))^(-1) *cell2mat(M)'*cell2mat(p);

struct.N = N;
struct.Nu = Nu;
struct.K = K;
struct.Mp = Mp;

end

