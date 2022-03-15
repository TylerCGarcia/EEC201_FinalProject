[Speaker3,Fs] = audioread("Training_Data/s3.wav");
Speaker3_crop = norm_crop(Speaker3,0.05);

a3 = MFCC1(20,256,100,Speaker3,Fs);
[Speaker10,Fs] = audioread("Training_Data/s10.wav");

Speaker10_crop = norm_crop(Speaker10,0.05);

a10 = MFCC1(20,256,100,Speaker10,Fs);
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
function cepstrum = MFCC1(Num_Bank,K,M,SpeakerSound,Fs)
    win = hamming(K,'periodic');
%     numOfFrame = floor((length(Speaker)-Num_of_sample)/100);
%     mel_scale_spectrum = zeros(floor((length(Speaker)-Num_of_sample)/100),Num_Bank);
     mel_banks = melfb(Num_Bank, K, Fs);
%     mel_banks = full(mel_banks);
%     mel_scale_ceptrum = zeros(floor((length(Speaker)-Num_of_sample)/100),Num_Bank);
    s = stft(SpeakerSound,Fs,'Window',win,'OverlapLength',K-M,'FFTLength',K);
    power = s.*conj(s);
    power = power./ max(max(abs(power)));
    cepstrum = zeros(size(power,2),Num_Bank);
    for i = 1:size(power,2)
        n2 = 1 + floor(K/2);
        z = mel_banks * power(1:n2,i);
        cepstrum(i,:) = dct(log10(z));
%         for n = 0:Num_Bank-1
%             cepstrum(i,n+1) = 0;
%             for k = 1:Num_Bank
%                 cepstrum(i,n+1) = cepstrum(i,n+1) + log(z(k))*cos(n*(k-0.5)*(pi/Num_Bank));
%             end 
%         end
    end
    cepstrum = cepstrum./ max(max(abs(cepstrum)));
end
function croped_norm_sound = norm_crop(sound,cutoff)
    sz = size(sound);
    if(sz(2) == 2)
        sound = (sound(:,1)+sound(:,2))/2;
    end
    sound = sound./max(sound);
    croped_norm_sound = sound(abs(sound)>cutoff);
end

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