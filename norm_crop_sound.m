% clear
% [Speaker3,Fs] = audioread("Training_Data/s6.wav");
% Speaker3_crop = norm_crop_sound1(Speaker3,0.0001,128);
% sound(Speaker3_crop,Fs)
% subplot 211
% plot(Speaker3_crop);
% subplot 212
% plot(Speaker3);
function croped_norm_sound = norm_crop_sound(sound,cutoff,windowSize)
    % sound is sound file, cutoff is cutoff power recommand 0.001,
    % windowsize control the window of the function. recommand 128 or 256
    sz = size(sound);
    if(sz(2) == 2)
        sound = (sound(:,1)+sound(:,2))/2;
    end
    sound = sound./max(sound);
    sound = sound - mean(sound);
    startLocation = 1;
    endLocation = size(sound,1);
    %temp = [];
    %find startPoint
    for i = 1:floor(size(sound,1)/windowSize)-1
        power = sum(abs(sound(startLocation:startLocation+windowSize)).^2);
        power = power./windowSize;
        %temp(end+1) = power;
        if power >= cutoff
            break
        end
        startLocation = startLocation + windowSize;
    end 
    for i = 1:floor(size(sound,1)/windowSize)-1
        power = sum(sound(endLocation-windowSize:endLocation).^2);
        power = power./windowSize;
        if power >= cutoff
            break
        end
        endLocation = endLocation - windowSize;
    end 
    croped_norm_sound = sound(startLocation:endLocation);
end