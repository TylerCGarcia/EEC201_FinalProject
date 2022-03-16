function croped_norm_sound = norm_crop(sound,cutoff)
    sz = size(sound);
    if(sz(2) == 2)
        sound = (sound(:,1)+sound(:,2))/2;
    end
    sound = sound./max(sound);
    croped_norm_sound = sound(abs(sound)>cutoff);
end