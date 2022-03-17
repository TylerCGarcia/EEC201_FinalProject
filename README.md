# EEC201_FinalProject
##### The A- Team: Tyler Garcia, Lambert Lihe
### Abstract
The goal of this project is to design a system that can accurately accomplish speaker recognition. It does this using 
mel-frequency spectrum coefficients and vector quantization with an LGB algorithm. ***Will finish when we have final results

### A. Speech Data Files
The initial step for this project was to get a database of speech files. This database consisted of two folders full of speech files. 
The first one was initially with 11 speech files, named 'Training_Data' for training the VQ codebook and the second one, named 'Test_Data', 
initially had 8 speech files for testing the speaker recognition. Between these two folders, speakers 1 through 8 correlated to each other. To
set a benchmark for this speaker recognition project, our own ability to match the speakers correctly was tested with an accuracy of 31.25%. 

### B. Speech Preprocessing
To be able to correctly identify a speaker, first you must extract features to compare the speakers. Since speech is mostly stationary over periods of time less than 
around 100 msec, Short-Time Fourier Transform(STFT) can be used to extract speech characteristics that are mostly stationary. STFT is done by breaking the sound file 
into overlapping frames, applying a window to those frames, then taking the Fast Fourier Transform(FFT) of the windowed frames. The purpose of windowing is to reduce 
spectral leakage and the distortion caused by it. For our project each frames consisted of 256 samples, with each following frame starting 100 samples after, giving the 
frames an overlap of 156 samples between them. Along with this, the type of window we used was a hamming window of the same size as each frame. However, before this 
could be done, the sounds is first normalized and cropped to put more emphasis on the part of speech with the key characteristics. The difference between the raw sound 
before being normalized and cropped, compared to after is shown below in Figure 1.

