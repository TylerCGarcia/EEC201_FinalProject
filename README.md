# EEC201_FinalProject
##### The A- Team: Tyler Garcia, Lambert Lihe
### Abstract
The goal of this project is to design a system that can accurately accomplish speaker recognition. It does this using mel-frequency spectrum coefficients and vector quantization with an LGB algorithm. ***Will finish when we have final results

### Introduction
This project hopes to consistently identify speakers from one another. Throughout this report, the reasoning and results of the different steps taken to accomplish this are provided. Along with this report are a number of files that are used to accomplish this. To find the Mel-Frequency Cepstrum Coefficients(MFCC), the MFCC.m file is used as a function. Similarly to accomplish vector quantizetion, the LGB.m file is used as a function. For the intermediate steps of test 1 through test 6,  testing.m is used containing a number of functions that apply to each of the tests. For test 7, test7.m can be used. The other matlab files used for this project include loadSound.m and norm_crop_sound.m, which are both used throughout to organize the sound files in the desired fasion.

### A. Speech Data Files
The initial step for this project was to get a database of speech files. This database consisted of two folders full of speech files. The first one was initially with 11 speech files, named 'Training_Data' for training the VQ codebook and the second one, named 'Test_Data', initially had 8 speech files for testing the speaker recognition. Between these two folders, speakers 1 through 8 correlated to each other. To set a benchmark for this speaker recognition project, our own ability to match the speakers correctly was tested with an accuracy of 31.25%. 

### B. Speech Preprocessing
To be able to correctly identify a speaker, first you must extract features to compare the speakers. Since speech is mostly stationary over periods of time less than around 100 msec, Short-Time Fourier Transform(STFT) can be used to extract speech characteristics that are mostly stationary. STFT is done by breaking the sound file into overlapping frames, applying a window to those frames, then taking the Fast Fourier Transform(FFT) of the windowed frames. The purpose of windowing is to reduce spectral leakage and the distortion caused by it. However, before this could be done, the sounds is first normalized and cropped to put more emphasis on the part of speech with the key characteristics. This cropping is done by removing all of the sound on either end of the sound file that falls below a certain power threshold. The raw sound file is plotted below in Figure 1, along with the normalized and cropped version of that sound file. As can be seen this operation makes a large difference and signficantly improves the functionality of this speaker recognition project.

<p align = "center"> 
  <img src = "https://user-images.githubusercontent.com/74210189/158871886-f2260f15-83d8-401a-a3e3-5895c9494100.png" width = 750>
  <br>
  <em>Figure 1: Sound in the Time Domain</em>
</p>
  
For our project each frames consisted of 256 samples, with each following frame starting 100 samples after, giving the frames an overlap of 156 samples between them. Along with this, the type of window we used was a hamming window of the same size as each frame. Applying this STFT to generate spectograms of the 11 training files gives the results shown below in Figure 2. These spectograms show the unique frequency characteristics of the different speakers. Below this plot in Figure 3 and Figure 4 it can be seen what the affect is when the frame sizes are changed. Figure 3 shows the results with a smaller frame size of 128, with the following frames starting 50 samples after and Figure 4 shows the results with a larger frame size of 512, with the following frames starting 200 samples after. From these plots it can be seen that with smaller frames the frequency components become more dense, but can become less distinguishable. While with larger frames the frequency components can become very spread out and less prominent.

<p align = "center"> 
  <img src = "https://user-images.githubusercontent.com/74210189/158883488-451b46c2-1ee2-4c2f-a341-7d387c71e6cb.png" width = 750>
  <br>
  <em>Figure 2: Spectogram With Frame Size of 256</em>
</p>

<p align = "center"> 
  <img src = "https://user-images.githubusercontent.com/74210189/158883633-2e381940-eb55-4867-8196-2973c9c19fa0.png" width = 750>
  <br>
  <em>Figure 3: Spectogram With Frame Size of 128</em>
</p>

<p align = "center"> 
  <img src = "https://user-images.githubusercontent.com/74210189/158883713-b314d244-a58e-4bb2-aaa4-41f970d3f35f.png" width = 750>
  <br>
  <em>Figure 4: Spectogram With Frame Size of 512</em>
</p>

Once the STFT of a signal is taken, mel-frequency wrapping is applied to the spectrum of the STFT. This is using a mel-spaced filter bank response, which can be seen below in Figure 5. The idea of behind these mel-spaced filter banks is that human perception of sound is only linear for up to around 1000 Hz, after which it follows a more logarithmic spacing scale. The mel-spaced filter banks follow this scaling. Applying this scaling 

<p align = "center"> 
  <img src = "https://user-images.githubusercontent.com/74210189/158887221-cfed3bc7-c075-4a3f-bdfa-e1b94ed1a700.png" width = 750>
  <br>
  <em>Figure 5: Mel-Spaced Filterbank</em>
</p>

<p align = "center"> 
  <img src = "https://user-images.githubusercontent.com/74210189/158887778-5c6b9fb8-adcd-4a17-8779-614b3c8aee15.png" width = 750>
  <br>
  <em>Figure 6: Mel-Spectrum </em>
</p>



### C. Vector Quantization

