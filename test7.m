clear
clc
N = 256;
M = 100;
K = 20;
Q = 8;
e = 0.01;
[trainingSound,Fs1] = loadSound('Training_Data/'); % Use for folder
[testingSound,Fs2] = loadSound('Test_Data/'); % Use for folder
result = predition(trainingSound,testingSound,N,M,K,Fs2,Q,e);
function result = predition(trainingSounds,testingSounds,N,M,K,Fs,Q,distortion_eps)
    m = melfb(K, N, Fs);
    oL = N-M;
    Window = hamming(N,'periodic'); 
    codebook = cell(length(trainingSounds),1);
    result = zeros(length(testingSounds),1);
    if(iscell(trainingSounds))
        for j = 1:length(trainingSounds) 
            cept = MFCC(K,N,M,trainingSounds{j},Fs);
            [codebook{j}, clusterID, D] = LBG(cept, Q, distortion_eps);
        end
        %now we have codebook ready
        
        for j = 1:length(testingSounds) 
%             figure
            cept = MFCC(K,N,M,testingSounds{j},Fs);
            [codebookTest{j}, clusterID, D] = LBG(cept, Q, distortion_eps);
             distance = zeros(length(codebook),Q);
%             hold on
            for i = 1:length(codebook)
                distance(i,:) = sum((codebook{i} - codebookTest{j}).^2,2);
                %plot(codebook{i}(:,3),codebook{i}(:,4),'o')
            end
%             plot(codebookTest{j}(:,3),codebookTest{j}(:,4),'*')
%             hold off

             [Min,index] = min(distance);
             if(j == 7)
                 distance;
                 index;
                 %min
             end
             result(j) = mode(index);
        end 
        
        
    end
end