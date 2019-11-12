function NecMatrix = NecMatrixCalculation(r, l, th0, d)

    A = zeros(17,9);  % coordinates matrix mxn
    m = size(A,1);  % number of rows
    n = size(A,2);  % number of columns
    
    A(:,1) = (1:m)'; % 1st column: 1,2,3,...,m
    
    Nseg_disc = 12;
    Nseg_cone = 20;
    % 2nd column: number of segments for the disc and the cone respectively
    A(:,2) = [linspace(Nseg_disc,Nseg_disc,8) 1 linspace(Nseg_cone,Nseg_cone,8)]';
    
    % last column: the wire's diameter 
    A(:,end) = linspace(0.01, 0.01, m)';
    
    % (x,y)_initial = (0,0) for both the disc and the cone
    A(:,3) = zeros(m,1);
    A(:,4) = zeros(m,1);
    
    % z_initial_cone = -d = -wl/20
    A(:,5) = [zeros(9,1); linspace(-d, -d, 8)'];
    
    ph = 0;   
    for i = 1:8
        
        % (x,y,z) disc
        A(i,6) = r*cosd(ph);
        A(i,7) = r*sind(ph);
        A(i,8) = 0;
        % (x,y,z) cone
        A(i+9,6) = l*cosd(ph)*sind(th0);
        A(i+9,7) = l*sind(ph)*sind(th0);
        A(i+9,8) = -d-l*cosd(th0);
        
        ph = ph + 45;
        
    end
    
    A(9,6) = 0;
    A(9,7) = 0;
    A(9,8) = -d;
    
    NecMatrix = A;
                   
end

