function A = SteeringMatrix(M,N,th)

% computes the SteeringMatrix (A) given: 
% (i) the number of array antenna elements
% (ii) the TOTAL number of incident waves **N = desired+undesired**
% (iii) the direction of the N incident waves

    A = zeros(M,N);
    for iw = 1:N % iw: incident wave
        A(:,iw) = exp(1i*(0:M-1)*pi*cosd(th(iw)));
    end

end

