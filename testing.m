% This script is used to run through each of the tests individually by
% calling the funcitons on top with the parameters being set on top as
% well.

% It is recommended to run each test function individually as running
% multiple could have overwhelming outputs.

% The first three tests are using parts of MFCC to get their results

clc,clear
% Pick sound files
[Sound,Fs] = loadSound('Training_Data/'); % Use for folder


% Test Parameters
N = 256;
M = 100;
K = 20;
% Dimensions to plot in Test5 nad Test6
d1 = 3;
d2 = 4;
% Distortion error and number of centroids for part 6
e = 0.01;
Q = 5;

% For Test 2, N and M can be arrays of desired values
%N = [128 256 512];
%M = [50 100 200];

% Run the tests
%Test1(Sound,N,M,Fs);
%Test2(Sound,N,M,Fs);
Test3(Sound,N,M,K,Fs);
%Test4(Sound,N,M,K,Fs);
%Test5(Sound,N,M,K,Fs,d1,d2)
%Test6(Sound,N,M,K,Fs,d1,d2,e,Q)

% Test 1
function T = Test1(Sound,N,M,Fs)
    % First find the overlap
    oL = N-M;
    Window = hamming(N,'periodic'); 
    for i = 1:length(Sound) 
        % Apply STFT with the given window
        s = stft(Sound{i},Fs,'Window',Window,'OverlapLength',oL,'FFTLength',N,'FrequencyRange','onesided');
        % Normalize the power
        power{i} = s.*conj(s);
        T{i} = power{i}./ max(max(abs(power{i}))); % 
    end
end

% Test 2
function Test2(Sound,N,M,Fs)
% Run iteration for every different window size chosen
    for n = 1:length(N)
        figure(n)
        for i = 1:length(Sound)
            % Find overlap for that given frame size
            oL = N(n)-M(n);
            Window = hamming(N(n),'periodic'); 
            % Compute STFT for that given window
            [s,f,t] = stft(Sound{i},Fs,'Window',Window,'OverlapLength',oL,'FFTLength',N(n),'FrequencyRange','onesided');
            % Normalize the Power
            power = s.*conj(s);
            power = power./ max(max(abs(power)));
            % Plot the spectrograms of the different data
            subplot(3,4,i)
            imagesc(t,f,pow2db(power))
            title('STFT s'+string(i)+' N='+string(N(n))+' M='+ string(M(n))),ylabel('Frequency (Hz)'),xlabel('Time (s)')
            set(gca,'YDir','normal')
        end
    end
end

% Test 3
function Test3(Sound,N,M,K,Fs)
    m = melfb(K, N, Fs);
    oL = N-M;
    win = hamming(N,'periodic');
    figure(1)
    plot(linspace(0,Fs/2,length(m)),m)
    title('Mel-spaced filterbank'),xlabel('Frequency (Hz)')
    
    figure(2)
    for n = 1:length(Sound)                  
        [s,f,t] = stft(Sound{n},Fs,'Window',win,'OverlapLength',oL,'FFTLength',N,'FrequencyRange','onesided');
        power = s.*conj(s);
       
        power = power./ max(max(abs(power))); % power norm
        for i = 1:size(power,2)
            n2 = 1 + floor(N/2);
            z(i,:) = m * power(1:n2,i);
        end
        %figure(2*n)
        if(n < 4)
            subplot(3,2,n*2-1)
            imagesc(t,f,pow2db(power))
            title('Before Filterbank s' + string(n)),ylabel('Frequency (Hz)'),xlabel('Time (s)')
            set(gca,'YDir','normal')
            %figure(2*n + 1)
            subplot(3,2,n*2)
            imagesc(t,f,pow2db(z'))
            title('After Filterbank s' + string(n)),ylabel('Frequency (Hz)'),xlabel('Time (s)')
            set(gca,'YDir','normal')
        end
        
    end
    
end

% Test 4 
function T = Test4(Sound,N,M,K,Fs) 
    for j = 1:length(Sound) 
        cept{j} = MFCC(K,N,M,Sound{j},Fs);
    end
    T = cept;
end

% Test 5
function Test5(Sound,N,M,K,Fs,d1,d2)
    figure
    for j = 1:length(Sound) 
        cepstrum{j} = MFCC(K,N,M,Sound{j},Fs);
        subplot(3,4,j)
        plot(cepstrum{j}(:,d1),cepstrum{j}(:,d2),'.')
        title('s'+string(j)+' Dimension '+string(d1)+' vs '+string(d2))
        xlabel('Dimension ' + string(d1)),ylabel('Dimension '+string(d2))
    end
    figure
    hold on
    for j = 1:length(Sound) 
        plot(cepstrum{j}(:,d1),cepstrum{j}(:,d2),'.')
    end
    hold off
    title('Dimension '+string(d1)+' vs '+string(d2) + ' of all sound')
    xlabel('Dimension ' + string(d1)),ylabel('Dimension '+string(d2))
    %plot sound 3 6 10
    figure
    plot(cepstrum{3}(:,d1),cepstrum{3}(:,d2),...
        '.',cepstrum{5}(:,d1),cepstrum{5}(:,d2),'X',...
        cepstrum{10}(:,d1),cepstrum{10}(:,d2),'o')
    title('plot for s3 s5 s10')
    xlabel('Dimension ' + string(d1)),ylabel('Dimension '+string(d2))
    
end

% Test 6
function Test6(Sound,N,M,K,Fs,d1,d2,e,Q) 
    figure
    for j = 1:length(Sound) 
        cepstrum{j} = MFCC(K,N,M,Sound{j},Fs);
        [codebook{j},clusterID,D] = LBG(cepstrum{j},Q,e);
        %figure(j)
        subplot(3,4,j)
        plot(cepstrum{j}(:,d1),cepstrum{j}(:,d2),'.',codebook{j}(:,d1),codebook{j}(:,d2),'o')
        title('s'+string(j)+' Dimension '+string(d1)+' vs '+string(d2))
        xlabel('Dimension ' + string(d1)),ylabel('Dimension '+string(d2))
    end
    figure
    hold on
    for j = 1:length(Sound)
        plot(codebook{j}(:,d1),codebook{j}(:,d2),'.')
        title('Plot of All code book')
    end
    hold off
    figure
    plot(codebook{3}(:,d1),codebook{3}(:,d2),...
        'o',codebook{5}(:,d1),codebook{5}(:,d2),'o',...
        codebook{10}(:,d1),codebook{10}(:,d2),'o')
    title('codebook plot for s3 s5 s10')
    xlabel('Dimension ' + string(d1)),ylabel('Dimension '+string(d2))
end
