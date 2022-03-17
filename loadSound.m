% [sounds,Fs] = loadSound1("Training_Data/")
function [sound,constantFs] = loadSound(folder)
    %% Read file
    mask=dir(strcat(folder,"/*wav"));
    numOfFiles=size(mask,1); % total number of .wav files in training_data folder
    constantFs = 12500;
    sound = cell(1,numOfFiles);
    for i=1:numOfFiles
        file_name=strcat(folder,'s', num2str(i), '.wav');
        [file, Fs] = audioread(file_name);
        file = resample(file,constantFs,Fs); % resample if it is not in constantFs
        file = norm_crop_sound(file,0.0005,256);
        sound{i} = file(:,1);   
    end
end