function [du] = dmc(Mp,K,N,yAktualne,yZadane, duPop)
	yk = ones(N,1) * yAktualne;
	y0 = yk + Mp * duPop';
	du = K * ( yZadane - y0);
	du = du(1,1);
end
