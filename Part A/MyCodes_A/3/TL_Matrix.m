function TLM = TL_Matrix(Z1)

    A = zeros(4,10);
    
    % 1st column: start-wire of TL
    A(1,1) = 1;
    A(2,1) = 2;
    A(3,1) = 1;
    A(4,1) = 4;
    
    % 2nd column: start-segment of TL
    A(:,2) = 1;
    
    % 3rd column: end-wire of TL
    A(:,3) = (2:5)';
    
    % 4th column: end-segment of TL
    A(:,4) = 1;
    
    % 5th column
    A(:,5) = [Z1 -Z1 Z1 -Z1]';
    
    % the rest elements are zero
    A(:,6:end) = 0;
    
    TLM = A;
 
end

