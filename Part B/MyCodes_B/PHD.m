%% (a)
clear;clc

M = 8; % number of array antenna elements
N = 7; % total number of incident waves
th = [40 60 80 100 120 130 150]; % elevation angles 
Ps = 1; % Power of signals [Watt]
snr = 10;
Pn = Ps*10^(-snr/10); % Power of noise [Watt]

Rgg = Ps*eye(N);
Rnn = Pn*eye(M);
A = SteeringMatrix(M,N,th);

Rxx = A*Rgg*A' + Rnn;
[V,D] = eig(Rxx);
[~,id] = min(diag(D)); % id = index of the minimum eigenvalue

umin = V(:,id); % the eigenvector of the minimum eigenvalue

ths = 0:0.1:180; % theta-scaning
AF = zeros(length(ths),1);
for i = 1:length(ths) 
    AF(i) = 1/abs(SteeringMatrix(M,1,ths(i))'*umin)^2;
end
AFn = 20*log10(abs(AF)/max(abs(AF))); % normalized of the Array Factor 

plot(ths,AFn)
xlabel('\theta'), ylabel('AF(\theta) [dB]')
title(['RLS (M=8, N=7):  \theta_{DoA} = (',num2str(th),') [deg]'])

%% (b)
clear;clc

M = 8; % number of array antenna elements
N = 2; % total number of incident waves
Ps = 1; % Power of signals [Watt]
snr = 10;
Pn = Ps*10^(-snr/10); % Power of noise [Watt]

Rgg = Ps*eye(N);
Rnn = Pn*eye(M);

% From (a) we deduce that the PHD algorithm can distinguish two signals
% with an angle>10[deg] between them (120 and 130[deg] in the above example).
% Thus, we start our calculations from theta=85 (th=85, 180-th=95, so a 10
% [deg] angle between them)
for theta = 85:0.01:90
    th = [theta 180-theta]; % direction of signals
    
    A = SteeringMatrix(M,N,th);
    Rxx = A*Rgg*A' + Rnn;
    [V,D] = eig(Rxx);
    [~,id] = min(diag(D));
    umin = V(:,id);
    ths = 0:0.1:180; % theta-scaning
    AF = zeros(length(ths),1);
    for i = 1:length(ths) 
        AF(i) = 1/abs(SteeringMatrix(M,1,ths(i))'*umin)^2;
    end
    AFn = 20*log10(abs(AF)/max(abs(AF))); % normalized Array Factor 
       
    [AFpks,~] = findpeaks(AFn);
    S = sort(AFpks,'descend');
    % Having sorted the "peaks" in descending order, the first two values
    % (max1,max2) are close iff they correspond to the direction of each signal 
    if ( abs(S(1)-S(2))>100 ) % there aren't two distinguished peaks
        thres = th(2)-th(1); % resolution
        break;
    end
    
end

plot(ths,AFn)
