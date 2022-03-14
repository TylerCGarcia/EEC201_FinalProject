% Speaker Recognition Training

K = 20;
N = 256;
M = 100;
numTraining = 11;


for i=1:numTraining
    a = string(i);
    filename = "Training_Data\s" + a + ".wav";
    TrainFrame = melfcc(filename,N,M,K);
    TrainingLength(i) = length(TrainFrame);
    for n = 1:length(TrainFrame)
        TotalTraining{i,n} = TrainFrame{1,n};
    end
end


%{
% Find the window and overlap length
l = 1;
N = 256*l;
M = 100*l;
oL = N-M;
K = 20;

Window = hamming(N,'periodic');

L = 1 + floor(N/2);


for i = 1:11
    % Go through each training wav file
    a = string(i);
    filename = "Training_Data\s" + a + ".wav";
    [SpeakerTrain,Fs] = audioread(filename);
    % Turn signal into mono if it isn't
    SpeakerTrainOld = SpeakerTrain;
    sz = size(SpeakerTrain);
    if(sz(2) == 2)
        SpeakerTrain = (SpeakerTrainOld(:,1)+SpeakerTrainOld(:,2))/2;
    end
    %wavmax = max(SpeakerTrain)
    % Set 
    numFrames = 1 + ceil((length(SpeakerTrain)-N)/M);
    Speaker = zeros(numFrames*M + oL,1);
    Speaker(1:length(SpeakerTrain)) = SpeakerTrain;
    m = melfb(K, N, Fs);
    for k = 1:K-1
        for n = 1:numFrames 
            TrainFrame1{i,n} = Speaker(1+((n-1)*M):N+(n-1)*M);
            TrainFrame2{i,n} = TrainFrame1{i,n}.*Window;
            TrainFrame3{i,n} = abs(fft(TrainFrame2{i,n}));
            TrainFrame4{i,n}(k,1) = full(sum(m(k+1,:)*((TrainFrame3{i,n}(1:L,:)).^2)));
            TrainFrame5{i,n} = dct(TrainFrame4{i,n}); 
        end    
    end
end

%}
