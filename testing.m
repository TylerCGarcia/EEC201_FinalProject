% This script is used to run through each of the tests individually by
% calling the funcitons on top with the parameters being set on top as
% well.

% Each Test can be for either a single sound file by using the audioread
% function below or a folder of sound files by using the custom loadsound
% function below.

% It is recommended to run each test function individually as running
% multiple could have overwhelming outputs.

% Some of these tests are repeated from other functions used in this
% project such as the MFCC.m and LBG.m 

% The different functions are meant to be standalone functions for that
% specific test, therefore parts of each function are repeated and in
% general each function builds off the previous function however does not
% call that function

clc,clear
% Pick sound files
%[Sound,Fs] = audioread('Training_Data\s11.wav'); % Use for single file
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
%Test3(Sound,N,M,K,Fs);
%Test4(Sound,N,M,K,Fs);
%Test5(Sound,N,M,K,Fs,d1,d2)
%Test6(Sound,N,M,K,Fs,d1,d2,e,Q)
% figure
% for i = 1:11
%     subplot(3,4,i)
%     plot(Sound{i})
%     sound(Sound{i},Fs)
% end
% Test 1
function T = Test1(Sound,N,M,Fs)
    oL = N-M;
    Window = hamming(N,'periodic'); 
    if(iscell(Sound))
        for i = 1:length(Sound) 
            s = stft(Sound{i},Fs,'Window',Window,'OverlapLength',oL,'FFTLength',N,'FrequencyRange','onesided');
            power{i} = s.*conj(s);
            T{i} = power{i}./ max(max(abs(power{i}))); % power norm
        end
    else
            s = stft(Sound(:,1),Fs,'Window',Window,'OverlapLength',oL,'FFTLength',N,'FrequencyRange','onesided');
            power = s.*conj(s);
            T = power./ max(max(abs(power))); % power norm
    end
end

% Test 2
function Test2(Sound,N,M,Fs)
%assume the there is always 11 Souns

    if(iscell(Sound))
        for n = 1:length(N)
            figure(n)
            for i = 1:length(Sound)
                oL = N(n)-M(n);
                Window = hamming(N(n),'periodic'); 
                [s,f,t] = stft(Sound{i},Fs,'Window',Window,'OverlapLength',oL,'FFTLength',N(n),'FrequencyRange','onesided');
                power = s.*conj(s);
                power = power./ max(max(abs(power))); % power norm
                %stft(Sound(:,1),Fs,'Window',Window,'OverlapLength',oL,'FFTLength',N(n),'FrequencyRange','onesided');
                %figure((i-1)*length(N) + n)
                subplot(3,4,i)
                imagesc(t,f,pow2db(power))
                title('STFT s'+string(i)+' N='+string(N(n))+' M='+ string(M(n))),ylabel('Frequency (Hz)'),xlabel('Time (s)')
                set(gca,'YDir','normal')
            end
        end
    else
        for n = 1:length(N)
            oL = N(n)-M(n);
            Window = hamming(N(n),'periodic');
            
            [s,f,t] = stft(Sound(:,1),Fs,'Window',Window,'OverlapLength',oL,'FFTLength',N(n),'FrequencyRange','onesided');
            power = s.*conj(s);
               
            power = power./ max(max(abs(power))); % power norm
            figure(n)
            imagesc(t,f,pow2db(power))
            title('STFT N='+string(N(n))+' M='+ string(M(n))),ylabel('Frequency (Hz)'),xlabel('Time (s)')
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
    
    % iscell(A) to allow cell usage
    if(iscell(Sound))
        figure(1)
        for n = 1:length(Sound)                  
            [s,f,t] = stft(Sound{n},Fs,'Window',win,'OverlapLength',oL,'FFTLength',N,'FrequencyRange','onesided');
            power = s.*conj(s);
           
            power = power./ max(max(abs(power))); % power norm
            for i = 1:size(power,2)
                n2 = 1 + floor(N/2);
                z(i,:) = m * power(1:n2,i);
            end
            %figure(2*n)
            subplot(6,4,n*2-1)
            imagesc(t,f,pow2db(power))
            title('Before Filterbank s' + string(n)),ylabel('Frequency (Hz)'),xlabel('Time (s)')
            set(gca,'YDir','normal')
            %figure(2*n + 1)
            subplot(6,4,n*2)
            imagesc(t,f,pow2db(z'))
            title('After Filterbank s' + string(n)),ylabel('Frequency (Hz)'),xlabel('Time (s)')
            set(gca,'YDir','normal')
        end
    else
        [s,f,t] = stft(Sound(:,1),Fs,'Window',win,'OverlapLength',oL,'FFTLength',N,'FrequencyRange','onesided');
        power = s.*conj(s);
        power = power./ max(max(abs(power))); % power norm
        for i = 1:size(power,2)
            n2 = 1 + floor(N/2);
            z(i,:) = m * power(1:n2,i);
        end
        figure(2)
        imagesc(t,f,pow2db(power))
        title('Before Filterbank'),ylabel('Frequency (Hz)'),xlabel('Time (s)')
        set(gca,'YDir','normal')
        figure(3)
        imagesc(t,f,pow2db(z'))
        title('After Filterbank'),ylabel('Frequency (Hz)'),xlabel('Time (s)')
        set(gca,'YDir','normal')
    end
end

% Test 4 
function T = Test4(Sound,N,M,K,Fs)
    m = melfb(K, N, Fs);
    oL = N-M;
    Window = hamming(N,'periodic'); 
    if(iscell(Sound))
        for j = 1:length(Sound) 
            s = stft(Sound{j},Fs,'Window',Window,'OverlapLength',oL,'FFTLength',N,'FrequencyRange','onesided');
            power = s.*conj(s);
            power = power./ max(max(abs(power))); % power norm
            cepstrum{j} = zeros(size(power,2),K);
            for i = 1:size(power,2)
                n2 = 1 + floor(N/2);
                z = m * power(1:n2,i);
                cepstrum{j}(i,:) = dct(log10(z));
            end
            T = cepstrum;
        end
    else
        s = stft(Sound(:,1),Fs,'Window',Window,'OverlapLength',oL,'FFTLength',N,'FrequencyRange','onesided');
        power = s.*conj(s);
        power = power./ max(max(abs(power))); % power norm
        cepstrum = zeros(size(power,2),K);
        for i = 1:size(power,2)
            n2 = 1 + floor(N/2);
            z = m * power(1:n2,i);
            cepstrum(i,:) = dct(log10(z));
        end
        T = cepstrum;
    end
end

% Test 5
function Test5(Sound,N,M,K,Fs,d1,d2)
    m = melfb(K, N, Fs);
    oL = N-M;
    Window = hamming(N,'periodic'); 
    if(iscell(Sound))
        figure
        for j = 1:length(Sound) 
            
            s = stft(Sound{j},Fs,'Window',Window,'OverlapLength',oL,'FFTLength',N,'FrequencyRange','onesided');
            power = s.*conj(s);
            power = power./ max(max(abs(power))); % power norm
            cepstrum{j} = zeros(size(power,2),K);
            for i = 1:size(power,2)
                n2 = 1 + floor(N/2);
                z = m * power(1:n2,i);
                cepstrum{j}(i,:) = dct(log10(z));
            end
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
    else
        s = stft(Sound(:,1),Fs,'Window',Window,'OverlapLength',oL,'FFTLength',N,'FrequencyRange','onesided');
        power = s.*conj(s);
        power = power./ max(max(abs(power))); % power norm
        cepstrum = zeros(size(power,2),K);
        for i = 1:size(power,2)
            n2 = 1 + floor(N/2);
            z = m * power(1:n2,i);
            cepstrum(i,:) = dct(log10(z));
        end
        figure(1)
        plot(cepstrum(:,d1),cepstrum(:,d2),'.')
        title(' Dimension '+string(d1)+' vs '+string(d2))
        xlabel('Dimension ' + string(d1)),ylabel('Dimension '+string(d2))
    end
end

% Test 6
function Test6(Sound,N,M,K,Fs,d1,d2,e,Q)
    m = melfb(K, N, Fs);
    oL = N-M;
    Window = hamming(N,'periodic'); 
    if(iscell(Sound))
        figure
        for j = 1:length(Sound) 
            s = stft(Sound{j},Fs,'Window',Window,'OverlapLength',oL,'FFTLength',N,'FrequencyRange','onesided');
            power = s.*conj(s);
            power = power./ max(max(abs(power))); % power norm
            cepstrum{j} = zeros(size(power,2),K);
            for i = 1:size(power,2)
                n2 = 1 + floor(N/2);
                z = m * power(1:n2,i);
                cepstrum{j}(i,:) = dct(log10(z));
            end
            
            % codebook is numberOfCluster*Features
            codebook{j} = mean(cepstrum{j},1); %1*N vector
            % Compute distortion
            D = sum((cepstrum{j}-codebook{j}(1,:)).^2,'all');       
            D = D./size(cepstrum{j},1);% average of all words
            D_not = D;
            clusterID{j} = ones(size(cepstrum{j},1), 1); %trace which node belong to which cluster
            
            while size(codebook{j},1) < Q
                eps = 0.01;
                % split codebook
                codebook{j} = [codebook{j}.*(1-eps);codebook{j}.*(1+eps)];
                
                while(1) % converange 
                    %clusterID = zeros(size(cepstrum,1), 1);  
                    distance = zeros(size(cepstrum{j}, 1), size(codebook{j},1));
                    % find nearest nodes
                    for i=1:size(codebook{j},1)
                        distance(:,i) = sum(((cepstrum{j}-codebook{j}(i,:)).^2),2); % total distance at each dimentison
                    end
                    [~,clusterID{j}] = min(distance, [], 2); % find min of each node to the closest codebok
                    %find New
                    codebook{j} = zeros(size(codebook{j},1), size(cepstrum{j}, 2)); %empty the codebook
                    for i=1:size(codebook{j},1)
                        codebook{j}(i,:) = mean(cepstrum{j}(clusterID{j}==i,:)); %caculate the center of nodes with same ClusterID
                    end
                    % see new distance is in range yet?
                    Ds=zeros(size(codebook{j},1),1);    
                    for i=1:size(codebook{j},1)
                        Ds(i) = sum((cepstrum{j}(clusterID{j}==i,:)-codebook{j}(i,:)).^2,'all');       
                    end
                    D = sum(Ds)./size(cepstrum{j},1);
                    
                    if(abs(D_not-D)/D < e)
                        break
                    end
                    D_not = D;
                end
            end
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
    else
        s = stft(Sound(:,1),Fs,'Window',Window,'OverlapLength',oL,'FFTLength',N,'FrequencyRange','onesided');
        power = s.*conj(s);
        power = power./ max(max(abs(power))); % power norm
        cepstrum = zeros(size(power,2),K);
        for i = 1:size(power,2)
            n2 = 1 + floor(N/2);
            z = m * power(1:n2,i);
            cepstrum(i,:) = dct(log10(z));
        end
        % codebook is numberOfCluster*Features
        codebook = mean(cepstrum,1); %1*N vector
        % Compute distortion
        D = sum((cepstrum-codebook(1,:)).^2,'all');       
        D = D./size(cepstrum,1);% average of all words
        D_not = D;
        clusterID = ones(size(cepstrum,1), 1); %trace which node belong to which cluster
        
        while size(codebook,1) < Q
            eps = 0.01;
            % split codebook
            codebook = [codebook.*(1-eps);codebook.*(1+eps)];
            
            while(1) % converange 
                %clusterID = zeros(size(cepstrum,1), 1);  
                distance = zeros(size(cepstrum, 1), size(codebook,1));
                % find nearest nodes
                for i=1:size(codebook,1)
                    distance(:,i) = sum(((cepstrum-codebook(i,:)).^2),2); % total distance at each dimentison
                end
                [~,clusterID] = min(distance, [], 2); % find min of each node to the closest codebok
                %find New
                codebook = zeros(size(codebook,1), size(cepstrum, 2)); %empty the codebook
                for i=1:size(codebook,1)
                    codebook(i,:) = mean(cepstrum(clusterID==i,:)); %caculate the center of nodes with same ClusterID
                end
                % see new distance is in range yet?
                Ds=zeros(size(codebook,1),1);    
                for i=1:size(codebook,1)
                    Ds(i) = sum((cepstrum(clusterID==i,:)-codebook(i,:)).^2,'all');       
                end
                D = sum(Ds)./size(cepstrum,1);
                
                if(abs(D_not-D)/D < e)
                    break
                end
                D_not = D;
            end
        end
        figure(1)
        plot(cepstrum(:,d1),cepstrum(:,d2),'.',codebook(:,d1),codebook(:,d2),'o')
        title(' Dimension '+string(d1)+' vs '+string(d2) +' of all sound')
        xlabel('Dimension ' + string(d1)),ylabel('Dimension '+string(d2))
    end
end
