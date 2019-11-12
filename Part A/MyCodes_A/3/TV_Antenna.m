clear;clc

f = 300e6;
c = 3e8;
wl = c/f;

ls = wl/30; % wire length
Z1 = 100;
Nr = 30;
theta = 60;

d0 = 0.5*wl;
d1 = 0.5*wl; 
d2 = 3*wl;
d3 = wl;

file = fopen('TVA.nec','w');

NecMatrix = NecMatrixCalculation(ls, wl, Nr, theta, d0, d1, d2, d3);
for k=1:size(NecMatrix,1)
    fprintf(file,'%s %d %d %12.4f %12.4f %12.4f %12.4f %12.4f %12.4f %12.4f\r\n','GW', NecMatrix(k,:));
end
fprintf(file,'%s %d\r\n','GE',0);

fprintf(file,'%s %d %d %d %d %d %d\r\n','EX',0,1,1,0,1,0);

TLM = TL_Matrix(Z1);
for k=1:size(TLM,1)
    fprintf(file,'%s %6d %6d %6d %6d %6d %10.2f %10.2f %10.2f %10.2f %10.2f\r\n','TL', TLM(k,:));
end
fprintf(file,'%s \r\n','EN');
