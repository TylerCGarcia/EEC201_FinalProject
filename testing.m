% Program to show side plots with EEC 201 Final Project

% Test 1
%{

%}
%Test2('Training_Data\s11.wav',256,100);
T = Test3('Training_Data\s1.wav',256,100,20);
% Test 2
function Test2(audio2,N2,M2)
    [Sound,Fs] = audioread(audio2);
    N = N2;
    M = M2;
    oL = N-M;
    
    Window = hamming(N,'periodic');
    
    sz = size(Sound);
    if(sz(2) == 2)
        SpeakerTrain = (Sound(:,1)+Sound(:,2))/2;
        %SpeakerTrain = (Sound(:,2));
    else
        SpeakerTrain = Sound;
    end
    SpeakerTrain = SpeakerTrain/max(SpeakerTrain);
    T2 = stft(SpeakerTrain,Fs,'Window',Window,'OverlapLength',oL);
    figure(1)
    stft(SpeakerTrain,Fs,'Window',Window,'OverlapLength',oL);
end

% Test 3
function T = Test3(audio3,N3,M3,K3)
    [Sound,Fs] = audioread(audio3);
    N = N3;
    M = M3;
    K = K3;
    m = melfb(K, N, Fs);
    figure(1)
    plot(linspace(0,Fs/2,length(m)),m)
    title('Mel-spaced filterbank'),xlabel('Frequency (Hz)')
    
    win = hamming(N,'periodic');
    mel_banks = melfb(K, N, Fs);
    [s,f,t] = stft(Sound,Fs,'Window',win,'OverlapLength',N-M,'FFTLength',N);
    power = s.*conj(s);
   
    power = power./ max(max(abs(power))); % power norm
    cepstrum = zeros(size(power,2),K);
    for i = 1:size(power,2)
        n2 = 1 + floor(N/2);
        z(i,:) = mel_banks * power(1:n2,i);
        cepstrum(i,:) = dct(log10(z(i,:)));

    end
    cepstrum = cepstrum./ max(max(abs(cepstrum))); %power norm
    T = power;
    figure(2)
    imagesc(t,f,power)
    title('Before Filterbank'),xlabel('Frequency (Hz)')
    figure(3)
    imagesc(t.*1e3,f.1e3,z)
    title('After Filterbank'),xlabel('Frequency (Hz)')
    %figure(4)
    %plot(cepstrum)

    %{
    for k = 1:K-1
        sum4(k,1) = sum(mfcc4{:,1}(k,1));
    end
    for n = 1:length(mfcc3{1,1})
        sum3(n,1) = sum(mfcc3{:,1}(n,1));
    end
    figure(3)
    stem(sum3)
    title('Before Filter Bank'),xlabel('Frequency (Hz)')
    figure(4)
    stem(sum4)
    title('After Filter Bank'),xlabel('Frequency (Hz)')
    full(m)
    %}
end

% Test 4 



% Test 5

% Test 6

% Test 7

% Test 8

% Test 9

% Test 10
