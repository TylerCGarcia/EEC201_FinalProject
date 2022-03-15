[Speaker,Fs] = audioread("Training_Data/s3.wav");
win = hamming(256,'periodic'); %window
plot(Speaker)
s = stft(Speaker,Fs,'Window',win,'OverlapLength',156,'FFTLength',256);
stft(Speaker,Fs,'Window',win,'OverlapLength',156,'FFTLength',256)


Speaker_crop = Speaker(abs(Speaker)>0.02);
plot(Speaker_crop)
%imshow(power);
% mel_scale_ceptrum1 = mel_scale_ceptrum;
% 
% [ceptrum,dummy,dummy2] = melfcc("Training_Data/s3.wav",Num_of_sample,M,Num_Bank+1);
% 
% [codebook, clusterID, D] = LBG(mel_scale_ceptrum1, 16, 0.01);
% c = [ceptrum{1}'];
% for i = 2: length(ceptrum)
%     c = [c;ceptrum{i}'];
% end
% plot(mel_scale_ceptrum1(:,1),mel_scale_ceptrum1(:,2),'.',codebook(:,1),codebook(:,2),'x',c(:,1),c(:,2),'.')
% 
