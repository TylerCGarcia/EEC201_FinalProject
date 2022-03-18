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