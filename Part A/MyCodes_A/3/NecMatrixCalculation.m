function NecMatrix = NecMatrixCalculation(ls, wl, Nr, theta, d0, d1, d2, d3)

    A = zeros(Nr+21,9);  % coordinates matrix mxn
    m = size(A,1);  % number of rows
    n = size(A,2);  % number of columns
    
    z = [d0 d0+d1 -d0 -d0-d1]';

    A(:,1) = (1:m)'; % 1st column: 1,2,3,...,m
    
    % 2nd column
    A(1:5,2) = 1;
    A(6:21,2) = ceil(wl/4/ls);
    A(22:end,2) = ceil(d3/ls);
    
    % 3rd column
    A(1:21,3) = 0;
    A(22:end,3) = -wl/4;
    
    % 4th column
    A(1:5,4) = -ls/2;
    for i = 6:4:18
        A(i,4) = ls/2;
        A(i+1,4) = ls/2;
        A(i+2,4) = -ls/2;
        A(i+3,4) = -ls/2;
    end
    A(22:end,4) = -d3/2;
    
    % 5th column
    A(1,5) = 0;
    A(2:5,5) = z;
    j = 0;
    for i = 6:4:18
        j = j + 1;
        A(i:i+3,5) = z(j);
    end
    A(22:end,5) = linspace(-d2/2,d2/2,Nr)';
    
    % 6th column
    A(1:21,6) = 0;
    A(22:end,6) = -wl/4;
    
    % 7th column
    A(1:5,7) = ls/2;
    for i = 6:4:18
        A(i,7) = ls/2 + (wl/4)*cosd(theta/2);
        A(i+1,7) = ls/2 + (wl/4)*cosd(theta/2);
        A(i+2,7) = - ls/2 - (wl/4)*cosd(theta/2);
        A(i+3,7) = - ls/2 - (wl/4)*cosd(theta/2);
    end
    A(22:end,7) = d3/2;
    
    % 8th column
    A(1,8) = 0;
%     A(2,8) = d1;
%     A(3,8) = d1+wl/2;
%     A(4,8) = -d1;
%     A(5,8) = -d1-wl/2;
    A(2:5,8) = z;
    j = 0;
    for i = 6:4:18
        j = j + 1;
        A(i,8) = z(j) + (wl/4)*sind(theta/2);
        A(i+1,8) = z(j) - (wl/4)*sind(theta/2);
        A(i+2,8) = z(j) + (wl/4)*sind(theta/2);
        A(i+3,8) = z(j) - (wl/4)*sind(theta/2);
    end
    A(22:end,8) = linspace(-d2/2,d2/2,Nr)';
    
    % last column: the wire's diameter 
    A(:,end) = linspace(wl/100, wl/100, m)';
    
    NecMatrix = A;
end

