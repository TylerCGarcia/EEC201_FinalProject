N = 256;
M = 100;
K = 20;

[trainingSound,Fs] = loadSound('Training_Data/'); % Use for folder
[testingSound,Fs] = loadSound('Training_Data/'); % Use for folder
result = predition(trainingSound,testingSound,N,M,K,Fs);
function result = predition(trainingSound,testingSound,N,M,K,Fs)
    
end