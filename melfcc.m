function [mfcc,mfcc4,mfcc3] = melfcc(filename,N1,M1,K1)

% Find the window and overlap length
N = N1;
M = M1;
oL = N-M;
K = K1;
Window = hamming(N,'periodic');

L = 1 + floor(N/2);

% Go through each training wav file
[SpeakerTrain,Fs] = audioread(filename);
% Turn signal into mono if it isn't
SpeakerTrainOld = SpeakerTrain;
sz = size(SpeakerTrain);
if(sz(2) == 2)
    SpeakerTrain = (SpeakerTrainOld(:,1)+SpeakerTrainOld(:,2))/2;
    
end
% Normalize the signal to make power range for all signals the same
SpeakerTrain = SpeakerTrain/max(SpeakerTrain);
numFrames = 1 + ceil((length(SpeakerTrain)-N)/M);
Speaker = zeros(numFrames*M + oL,1);
Speaker(1:length(SpeakerTrain)) = SpeakerTrain;
m = melfb(K, N, Fs);


for k = 1:K-1
    for n = 1:numFrames   
        frame1{1,n} = Speaker(1+((n-1)*M):N+(n-1)*M);
        frame2{1,n} = frame1{1,n}.*Window;
        frame3{1,n} = abs(fft(frame2{1,n}));
        frame4{1,n}(k,1) = full(sum(m(k+1,:)*((frame3{1,n}(1:L,:)).^2)));
        frame5{1,n} = dct(frame4{1,n});
    end
end

mfcc = frame5;
mfcc4 = frame4;
mfcc3 = frame3;
%{
[Sound,Fs] = loadSound('Training_Data/'); % Use for folder
[Sound1,Fs] = audioread('Training_Data\s1.wav');
[Sound2,Fs] = audioread('Training_Data\s6.wav');

figure(1)
subplot(2,2,1)
plot(Sound1)
title('Raw Sound Speaker 1')
subplot(2,2,2)
plot(Sound{1})
title('Normalized and Cropped Speaker 1')
subplot(2,2,3)
plot(Sound2)
title('Normalized Speaker 6')
subplot(2,2,4)
plot(Sound{6})
title('Normalized and Cropped Speaker 6')
%}

