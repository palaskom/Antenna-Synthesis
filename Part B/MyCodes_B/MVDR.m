clear;clc

M = 8; % number of the array antenna elements
N = 3; % total number of incident waves
th = zeros(1,N);

fmain = fopen('results.txt','w');
snr = [0 5 10 20]; %[dB]
for isnr = 1:length(snr)
    
    for dth_min = 2:2:10
        
        ftemp = fopen('AoAdev_SINR.txt','w');
        % Number of "thetas" for the statistical analysis
        for Nth = 1:1000 
            
            % (1)
            th(1) = unifrnd(30,150);
            i=2;  
            while ( i<=length(th) )
                R = unifrnd(30,150);
                if ( (abs(R-th(1:i-1)) >= dth_min) == ones(1,i-1) )
                    th(i) = R;
                    i = i+1;
                end
            end
            
            % (2i) weight calculation
            Ps = 1; % Power of signals [Watt]
            Pn = Ps*10^(-snr(i)/10); % Power of noise [Watt]

            Rgg = Ps*eye(N);
            Rnn = Pn*eye(M);
            A = SteeringMatrix(M,N,th);

            Rxx = A*Rgg*A' + Rnn;
            w = Rxx\A(:,1);
            
            % (2ii) Array Factor & SINR
            ths = 0:0.1:180; % theta-scaning
            AF = zeros(length(ths),1);
            for i = 1:length(ths) 
                AF(i) = w'*SteeringMatrix(M,1,ths(i));
            end
            AFn = -20*log10(abs(AF)/max(abs(AF))); % normalized of the Array Factor            
            
            Pyd = 10*log10(Ps*w'*A(:,1)*A(:,1)'*w);
            Pyu = 10*log10( w'* (A(:,2:end)*Rgg(2:end,2:end)*A(:,2:end)' + Rnn)* w);
            sinr = Pyd-Pyu; 
            
            % (2iii) deviations

            % theta -> interference signals
            [AFpks, id] = findpeaks(AFn);
            thpks = ths(id);
            dth = zeros(1,length(th));
            for i = 2:length(th)
                dth(i) = min(abs(th(i)-thpks));
            end
            % theta -> desired signal
            [~, id] = findpeaks(-AFn);
            thpks = ths(id);
            dth(1) = min(abs(th(1)-thpks));
            
            % (3)
            for i = 1:length(th)
                fprintf(ftemp,'%12.2f', th(i));
            end
            for i = 1:length(dth)
                fprintf(ftemp,'%12.2f', dth(i));
            end
            fprintf(ftemp,'%12.2f \n', sinr);
            
        end
        
        % (4)
        B = importdata('AoAdev_SINR.txt');
        % r1,r2,r3 -> [min, max, mean, std]
        r1 = zeros(1,4); % dth 0: 4th column of B
        r2 = zeros(1,4); % dth 1,2: 5-6th columns of B
        r3 = zeros(1,4); % SINR: 7th column of B
        
        r1(1) = min(B(:,4)); r1(2) = max(B(:,4)); r1(3) = mean(B(:,4)); r1(4) = std(B(:,4));
        r3(1) = min(B(:,7)); r3(2) = max(B(:,7)); r3(3) = mean(B(:,7)); r3(4) = std(B(:,7));

        r2(1) = min([B(:,5);B(:,6)]); r2(2) = max([B(:,5);B(:,6)]);
        r2(3) = mean([B(:,5);B(:,6)]); r2(4) = std([B(:,5);B(:,6)]);       

        fprintf(fmain,'%8.2f %8.2f %8.2f %8.2f', r1(1),r1(2),r1(3),r1(4));
        fprintf(fmain,'%8.2f %8.2f %8.2f %8.2f', r2(1),r2(2),r2(3),r2(4));
        fprintf(fmain,'%8.2f %8.2f %8.2f %8.2f', r3(1),r3(2),r3(3),r3(4));
        fprintf(fmain,'\n');

    end
    
end

results = importdata('results.txt');
