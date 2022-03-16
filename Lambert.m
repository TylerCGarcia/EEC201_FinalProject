clear
[Speaker3,Fs] = audioread("Training_Data/s3.wav");
Speaker3_crop = norm_crop_sound(Speaker3,0.05);
sound(Speaker3,Fs)