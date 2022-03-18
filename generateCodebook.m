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