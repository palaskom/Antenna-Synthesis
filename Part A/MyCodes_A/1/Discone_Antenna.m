wl = 1;  % wavelength [m]

r = 0.3*wl; % radius of the disk [m]
l = 0.5*wl; % length of the cone wires [m]
th0 = 75;
d = wl/20;   % length of each segment 

NecMatrix = NecMatrixCalculation(r, l, th0, d);

file = fopen('discone75.nec','w');
for k=1:size(NecMatrix,1)
    fprintf(file,'%s %d %d %12.4f %12.4f %12.4f %12.4f %12.4f %12.4f %12.4f\r\n','GW', NecMatrix(k,:));
end
fprintf(file,'%s %d\r\n','GE',0);
fprintf(file,'%s %d %d %d %d %d %d\r\n','EX',0,9,1,0,1,0);