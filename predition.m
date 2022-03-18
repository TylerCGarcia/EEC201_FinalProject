function result = predition(trainingSounds,testingSounds,N,M,K,Fs,Q,distortion_eps)
    codebook = generateCodebook(trainingSounds,N,M,K,Fs,Q,distortion_eps);
    result = predictUsingCodebook(codebook,testingSounds,N,M,K,Fs,Q,distortion_eps);
end
