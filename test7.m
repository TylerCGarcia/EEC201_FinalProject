clear
clc
N = 256;
M = 100;
K = 20;
Q = 8;
e = 0.01;
% [trainingSound,Fs1] = loadSound('Training_Data/'); % Use for folder
% [testingSound,Fs2] = loadSound('Test_Data/'); % Use for folder
% [trainingSound,Fs1] = loadSound('eight/training/'); % Use for folder
% [testingSound,Fs2] = loadSound('eight/testing/'); % Use for folder
% result = predition(trainingSound,testingSound,N,M,K,Fs2,Q,e);
Test7();
%Test8();
function T = Test7()
    N = 256;
    M = 100;
    K = 20;
    Q = 8;
    e = 0.01;
    [trainingSound,Fs1] = loadSound('Training_Data/'); % Use for folder
    [testingSound,Fs2] = loadSound('Test_Data/'); % Use for folder
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
function T = Test8()
    %this function will run about 1 to 4 mins depanding on machine used
    N = 256;
    M = 100;
    K = 20;
    Q = 8;
    e = 0.01;
    [trainingSound,Fs1] = loadSound('Training_Data/'); % Use for folder
    [testingSound,Fs2] = loadSound('Test_Data/'); % Use for folder
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


function result = predition(trainingSounds,testingSounds,N,M,K,Fs,Q,distortion_eps)
    codebook = generateCodebook(trainingSounds,N,M,K,Fs,Q,distortion_eps);
    result = predictUsingCodebook(codebook,testingSounds,N,M,K,Fs,Q,distortion_eps);
end
function codebook = generateCodebook(trainingSounds,N,M,K,Fs,Q,distortion_eps)
    m = melfb(K, N, Fs);
    oL = N-M;
    Window = hamming(N,'periodic'); 
    codebook = cell(length(trainingSounds),1);
    if(iscell(trainingSounds))
        for j = 1:length(trainingSounds) 
            cept = MFCC(K,N,M,trainingSounds{j},Fs);
            [codebook{j}, clusterID, D] = LBG(cept, Q, distortion_eps);
        end
        %now we have codebook ready
    end
end
function result = predictUsingCodebook(codebook,testingSounds,N,M,K,Fs,Q,distortion_eps)
    m = melfb(K, N, Fs);
    oL = N-M;
    Window = hamming(N,'periodic'); 
    result = zeros(length(testingSounds),1);
    if(iscell(testingSounds))
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
             result(j) = mode(index);
%              if j==10
%                 distance
%                 Min
%                 index
%              end
             result(j) = mode(index);
        end 
    end
end
% function result = predition(trainingSounds,testingSounds,N,M,K,Fs,Q,distortion_eps)
%     m = melfb(K, N, Fs);
%     oL = N-M;
%     Window = hamming(N,'periodic'); 
%     codebook = cell(length(trainingSounds),1);
%     result = zeros(length(testingSounds),1);
%     if(iscell(trainingSounds))
%         for j = 1:length(trainingSounds) 
%             cept = MFCC(K,N,M,trainingSounds{j},Fs);
%             [codebook{j}, clusterID, D] = LBG(cept, Q, distortion_eps);
%         end
%         %now we have codebook ready
%         
%         for j = 1:length(testingSounds) 
% %             figure
%             cept = MFCC(K,N,M,testingSounds{j},Fs);
%             [codebookTest{j}, clusterID, D] = LBG(cept, Q, distortion_eps);
%              distance = zeros(length(codebook),Q);
% %             hold on
%             for i = 1:length(codebook)
%                 distance(i,:) = sum((codebook{i} - codebookTest{j}).^2,2);
%                 %plot(codebook{i}(:,3),codebook{i}(:,4),'o')
%                 
%             end
% %             plot(codebookTest{j}(:,3),codebookTest{j}(:,4),'*')
% %             hold off
%             
%              [Min,index] = min(distance);
%              result(j) = mode(index);
% %              if j==10
% %                 distance
% %                 Min
% %                 index
% %              end
%         end 
%     end
% end