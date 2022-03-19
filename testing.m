% This script is used to run through each of the tests individually by
% calling the funcitons on top with the parameters being set on top as
% well.

% It is recommended to run each test function individually as running
% multiple could have overwhelming outputs.

% These tests call functions from other files that are accompanied on the
% github

clc,clear
% This sound file is used for tests 1-8
[Sound,Fs] = loadSound('Training_Data/'); 
% This sound file is used for test 7 and 8
[Sound2,Fs2] = loadSound('Test_Data/');
% These sounds files are seperate folders meant for test 9
[trainingSound9,Fs91] = loadSound('Training_Data_Test9/');
[testingSound9,Fs92] = loadSound('Test_Data_Test9/');
% These sound files are seperate folders meant for test 10
[trainingSound10,Fs101] = loadSound('Test10 Folder/training/');
[testingSound10,Fs102] = loadSound('Test10 Folder/testing/');


% Test Parameters
N = 256;
M = 100;
K = 20;
% Dimensions to plot in Test5 nad Test6
d1 = 3;
d2 = 4;
% Distortion error and number of centroids for part 6
e = 0.01;
Q = 8;

% For Test 2, N and M can be arrays of desired values
%N = [128 256 512];
%M = [50 100 200];

% Run the tests here
% It is recommended to only run one at a time
%Test1(Sound,N,M,Fs);
%Test2(Sound,N,M,Fs);
%Test3(Sound,N,M,K,Fs);
%Test4(Sound,N,M,K,Fs);
%Test5(Sound,N,M,K,Fs,d1,d2)
%Test6(Sound,N,M,K,Fs,d1,d2,e,Q)
%Test7(Sound,Sound2,N,M,K,Fs,Fs2,e,Q)
%Test8(Sound,Sound2,N,M,K,Fs,Fs2,e,Q)
%Test9(trainingSound9,testingSound9,N,M,K,Fs91,Fs92,e,Q)
%Test10(trainingSound10,testingSound10,N,M,K,Fs101,Fs102,e,Q)

% Test 1
function T = Test1(Sound,N,M,Fs)
    % First find the overlap
    oL = N-M;
    % Create a window 
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
    % Get the mel spaced filterbank
    m = melfb(K, N, Fs);
    % Find the overlap
    oL = N-M;
    win = hamming(N,'periodic');

    figure(1)
    plot(linspace(0,Fs/2,length(m)),m)
    title('Mel-spaced filterbank'),xlabel('Frequency (Hz)')
    
    % Plot the spectrum before and after the filterbank is added
    figure(2)
    for n = 1:length(Sound)  
        % Take the short time fourier transform
        [s,f,t] = stft(Sound{n},Fs,'Window',win,'OverlapLength',oL,'FFTLength',N,'FrequencyRange','onesided');
        % Normalize the power
        power = s.*conj(s);
        power = power./ max(max(abs(power)));
        % Apply the filterbanks
        for i = 1:size(power,2)
            n2 = 1 + floor(N/2);
            z(i,:) = m * power(1:n2,i);
        end
        % Only plot the first three sound files 
        if(n < 4)
            subplot(3,2,n*2-1)
            imagesc(t,f,pow2db(power))
            title('Before Filterbank s' + string(n)),ylabel('Frequency (Hz)'),xlabel('Time (s)')
            set(gca,'YDir','normal')
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

% Test 7
function Test7(trainingSound,testingSound,N,M,K,Fs1,Fs2,e,Q)
    
    GT = csvread('Test_Data/GT.txt');
    result = predition(trainingSound,testingSound,N,M,K,Fs2,Q,e);
    disp('Test7:')
    disp(['The accarcy for orinigal 8 test samples is ', num2str(mean(result==GT(:,2)))])
    [trainingSound,Fs1] = loadSound('Training_Data_Test7/'); % Use for folder
    [testingSound,Fs2] = loadSound('Test_Data_Test7/'); % Use for folder
    GT = csvread('Test_Data_test7/GT.txt');
    result = predition(trainingSound,testingSound,N,M,K,Fs2,Q,e);
    disp(['The accarcy for orinigal 8 + 2 addition test samples is ', num2str(mean(result==GT(:,2)))])
end

% Test 8
function Test8(trainingSound,testingSound,N,M,K,Fs1,Fs2,e,Q)
    %this function will run about 1 to 4 mins depanding on machine used
    
    codebook = generateCodebook(trainingSound,N,M,K,Fs1,Q,e);
    figure
    for k= 2:2:200
        wo = 100/(Fs1/2);  
        bw = k/(Fs1/2);
        [b1,a1] = iirnotch(wo,bw);
        for i = 1:length(testingSound)
            testingSound1{i} =  filter(b1,a1,testingSound{i});
        end
        GT = csvread('Test_Data/GT.txt');
        result(k/2) = mean(predictUsingCodebook(codebook,testingSound1,N,M,K,Fs2,Q,e)==GT(:,2));
    end
    subplot 221
    plot(2:2:200,result)
    title('Notch filter centered at 100Hz BW 2~200HZ')
    xlabel('Bandwidth in HZ'),ylabel('Accracy')
    for k= 2:2:200
        wo = 250/(Fs1/2);  
        bw = k/(Fs1/2);
        [b1,a1] = iirnotch(wo,bw);
        for i = 1:length(testingSound)
            testingSound1{i} =  filter(b1,a1,testingSound{i});
        end
        GT = csvread('Test_Data/GT.txt');
        result(k/2) = mean(predictUsingCodebook(codebook,testingSound1,N,M,K,Fs2,Q,e)==GT(:,2));
    end
    subplot 222
    plot(2:2:200,result)
    title('Notch filter centered at 250Hz BW 2~200Hz')
    xlabel('Bandwidth in HZ'),ylabel('Accracy')
    for k= 5:5:500
        wo = 1000/(Fs1/2);  
        bw = k/(Fs1/2);
        [b1,a1] = iirnotch(wo,bw);
        for i = 1:length(testingSound)
            testingSound1{i} =  filter(b1,a1,testingSound{i});
        end
        GT = csvread('Test_Data/GT.txt');
        result(k/5) = mean(predictUsingCodebook(codebook,testingSound1,N,M,K,Fs2,Q,e)==GT(:,2));
    end
    subplot 223
    plot(5:5:500,result)
    title('Notch filter centered at 1000Hz BW 5~500HZ')
    xlabel('Bandwidth in HZ'),ylabel('Accracy')
    for k= 10:10:1000
        wo = 3000/(Fs1/2);  
        bw = k/(Fs1/2);
        [b1,a1] = iirnotch(wo,bw);
        for i = 1:length(testingSound)
            testingSound1{i} =  filter(b1,a1,testingSound{i});
        end
        GT = csvread('Test_Data/GT.txt');
        result(k/10) = mean(predictUsingCodebook(codebook,testingSound1,N,M,K,Fs2,Q,e)==GT(:,2));
    end
    subplot 224
    plot(10:10:1000,result)
    title('Notch filter centered at 3000Hz BW 10~1000HZ')
    xlabel('Bandwidth in HZ'),ylabel('Accracy')
end

% Test 9
function Test9(trainingSound,testingSound,N,M,K,Fs1,Fs2,e,Q)
%S8 in traning is replaced with sound of Tyler
%S13 is replaced with Lambert's roomate's sound
    
    GT = csvread('Test_Data_test9/GT.txt');
    result = predition(trainingSound,testingSound,N,M,K,Fs2,Q,e);
    disp('Test9:')
    disp(['The accarcy for replaced 8 + 2 addition test samples is ', num2str(mean(result==GT(:,2)))])
end

% Test 10
function Test10(trainingSound,testingSound,N,M,K,Fs1,Fs2,e,Q)
% For this test the sound files were replaced with the word 'eight' from 10
% speakers
    GT = csvread('Test10 Folder/testing/GT.txt');
    result = predition(trainingSound,testingSound,N,M,K,Fs2,Q,e);
    disp('Test10:')
    disp(['The accarcy for test 10 word EIGHT training is ', num2str(mean(result==GT(:,2)))])
end
