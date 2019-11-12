clear;clc

M = 8; % number of array antenna elements
N = 6; % total number of incident waves
th = [50 70 100 110 130 160]; % elevation angles 
Ps = 1; % Power of signals [Watt]
Pn = 0.01; % Power of noise [Watt]
a = 0.98; Q = 50;
A = SteeringMatrix(M,N,th);

% (1) weight calculation
Rxinv = 1e6*eye(M); % initialize Rxx inverse matrix
w = zeros(M,1);
Wtot = zeros(length(w),Q); % store the weights in each iteration
for q = 2:Q
    gd = normrnd(0,sqrt(Ps)); % g desired
    g = [gd normrnd(0,sqrt(Ps),[1,N-1])]';  % Information Modulating Vector
    n = normrnd(0,sqrt(Pn),[1,M])';
    x = A*g + n;
    h = (Rxinv*x)/(a+x'*Rxinv*x);
    Rxinv = (q/(q-1)/a)*(Rxinv-h*x'*Rxinv);
    w = w + h*(gd-x'*w);
    Wtot(:,q) = w;   
end
w = w/max(abs(w)); 

% (2) Array Factor plot
ths = 0:0.1:180; % theta-scaning
AF = zeros(length(ths),1);
for i = 1:length(ths) 
    AF(i) = w'*SteeringMatrix(M,1,ths(i));
end

AFn = 20*log10(abs(AF)/max(abs(AF))); % normalized Array Factor
figure, plot(ths,AFn)
xlabel('\theta'), ylabel('AF(\theta) [dB]')
title(['RLS (M=8, N=5): \theta_d=', num2str(th(1)), ', \theta_i=(',num2str(th(2:end)),') [deg]'])

% |w| plot
figure
for i = 1:3
    plot(1:Q,abs(Wtot(i,:)));
    hold on
end
legend('|w_1|','|w_2|','|w_3|')
xlabel('iterations'), ylabel('|w|')

% (3) deviation between the actual and computed direction of arrival

% theta -> interference signals
[~, id] = findpeaks(-AFn);
thpks = ths(id);
dth = zeros(1,length(th));
for i = 2:length(th)
    dth(i) = min(abs(th(i)-thpks));
end
% theta -> desired signal
[~, id] = findpeaks(AFn);
thpks = ths(id);
dth(1) = min(abs(th(1)-thpks));