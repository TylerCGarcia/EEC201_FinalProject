clear
[Speaker3,Fs] = audioread("Training_Data/s3.wav");
Speaker3_crop = norm_crop_sound(Speaker3,0.001,128);

a3 = MFCC(20,256,100,Speaker3_crop,Fs);
[Speaker10,Fs] = audioread("Training_Data/s10.wav");

Speaker10_crop = norm_crop_sound(Speaker10,0.001,128);

a10 = MFCC(20,256,100,Speaker10_crop,Fs);
figure
subplot 221
plot(Speaker3)
subplot 222
plot(Speaker10)
subplot 223
plot(Speaker3_crop)
subplot 224
plot(Speaker10_crop)
[codebook3, clusterID, D] = LBG(a3, 4, 0.01);
[codebook10, clusterID, D] = LBG(a10, 4, 0.01);
figure
plot(a3(:,4),a3(:,7),'.',a10(:,4),a10(:,7),'.',codebook3(:,4),codebook3(:,7),'o',codebook10(:,4),codebook10(:,7),'o')

% for i = 1:size(power,2)
%         frame = Speaker(i*M+1:i*M+Num_of_sample)';
%         frame = frame.*Window';
%         frameFFT = fft(frame);
%         n2 = 1 + floor(Num_of_sample/2);
%         z = mel_banks * abs(frameFFT(1:n2)).^2';
%         mel_scale_spectrum(i,:) = z;
%         for n = 0:Num_Bank-1
%             mel_scale_ceptrum(i,n+1) = 0;
%             for k = 1:Num_Bank
%                 mel_scale_ceptrum(i,n+1) = mel_scale_ceptrum(i,n+1) + log(z(k))*cos(n*(k-0.5)*(pi/Num_Bank));
%             end 
%         end
% 
%     end