# EEC201_FinalProject
##### The A- Team: Tyler Garcia, Lambert Lihe
### Abstract
The goal of this project is to design a system that can accurately accomplish speaker recognition. It does this using mel-frequency cepstrum coefficients and vector quantization with an LGB algorithm. To obtain the mel-frequency cepstrum coefficients, our program uses a frame size of 256 samples, with each following frame beginning 100 samples after. A hamming window is used with this frame size and following the fast fourier transform, a mel-spaced filter bank conisting of 20 filter banks was used. After the dct of the logged spectrum was found, the accoustic vectors were broken into 8 regions with 8 unique codewords, found with the LBG algorithm. Finding the distorition between the codebooks of the training set and the test set, our program could accurately determine the correct speaker 75% of the time, which is significantly higher than what was found as the human perception's recognition rate.  

### Introduction
This project hopes to consistently identify speakers from one another. Throughout this report, the reasoning and results of the different steps taken to accomplish this are provided. Along with this report are a number of files that are used to accomplish this. To find the Mel-Frequency Cepstrum Coefficients(MFCC), the MFCC.m file is used as a function. Similarly to accomplish vector quantizetion, the LBG.m file is used as a function. To try out each test individually, testing.m is used containing a number of functions that apply to each of the tests. The other matlab files used for this project include loadSound.m and norm_crop_sound.m, which are both used throughout to organize the sound files in the desired fasion.

### A. Speech Data Files (Test 1)
The initial step for this project was to get a database of speech files. This database consisted of two folders full of speech files. The first one was initially with 11 speech files, named 'Training_Data' for training the VQ codebook and the second one, named 'Test_Data', initially had 8 speech files for testing the speaker recognition. Between these two folders, speakers 1 through 8 correlated to each other. To set a benchmark for this speaker recognition project, our own ability to match the speakers correctly was tested with an accuracy of 31.25%. 

### B. Speech Preprocessing (Test 2, Test 3, Test 4)
To be able to correctly identify a speaker, first you must extract features to compare the speakers. Since speech is mostly stationary over periods of time less than around 100 msec, Short-Time Fourier Transform(STFT) can be used to extract speech characteristics that are mostly stationary. STFT is done by breaking the sound file into overlapping frames, applying a window to those frames, then taking the Fast Fourier Transform(FFT) of the windowed frames. The purpose of windowing is to reduce spectral leakage and the distortion caused by it. However, before this could be done, the sounds is first normalized and cropped to put more emphasis on the part of speech with the key characteristics. This cropping is done by removing all of the sound on either end of the sound file that falls below a certain power threshold. The raw sound file is plotted below in Figure 1, along with the normalized and cropped version of that sound file. As can be seen this operation makes a large difference and signficantly improves the functionality of this speaker recognition project.

<p align = "center"> 
  <b>TEST 2</b>
  <br>
  <img src = "https://user-images.githubusercontent.com/74210189/158871886-f2260f15-83d8-401a-a3e3-5895c9494100.png" width = 750>
  <br>
  <em>Figure 1: Sound in the Time Domain</em>
</p>
  
For our project each frames consisted of 256 samples, with each following frame starting 100 samples after, giving the frames an overlap of 156 samples between them. Along with this, the type of window we used was a hamming window of the same size as each frame. Applying this STFT to generate spectograms of the 11 training files gives the results shown below in Figure 2. These spectograms show the unique frequency characteristics of the different speakers. Below this plot in Figure 3 and Figure 4 it can be seen what the affect is when the frame sizes are changed. Figure 3 shows the results with a smaller frame size of 128, with the following frames starting 50 samples after and Figure 4 shows the results with a larger frame size of 512, with the following frames starting 200 samples after. From these plots it can be seen that with smaller frames the frequency components become more dense, but can become less distinguishable. While with larger frames the frequency components can become very spread out and less prominent.

<p align = "center"> 
  <b>TEST 2</b>
  <br>
  <img src = "https://user-images.githubusercontent.com/74210189/158883488-451b46c2-1ee2-4c2f-a341-7d387c71e6cb.png" width = 750>
  <br>
  <em>(Test 2) Figure 2: Spectogram With Frame Size of 256 </em>
</p>

<p align = "center"> 
  <b>TEST 2</b>
  <br>
  <img src = "https://user-images.githubusercontent.com/74210189/158883633-2e381940-eb55-4867-8196-2973c9c19fa0.png" width = 750>
  <br>
  <em>(Test 2) Figure 3: Spectogram With Frame Size of 128 </em>
</p>

<p align = "center"> 
  <b>TEST 2</b>
  <br>
  <img src = "https://user-images.githubusercontent.com/74210189/158883713-b314d244-a58e-4bb2-aaa4-41f970d3f35f.png" width = 750>
  <br>
  <em>Figure 4: Spectogram With Frame Size of 512</em>
</p>

Once the STFT of a signal is taken, mel-frequency wrapping is applied to the spectrum of the STFT. This is using a mel-spaced filter bank response, which can be seen below in Figure 5. The idea of behind these mel-spaced filter banks is that human perception of sound is only linear for up to around 1000 Hz, after which it follows a more logarithmic spacing scale. The mel-spaced filter banks follow this scaling. Applying this scaling gives more of an emphsis on the lower frequency components of the spectrum as can be seen with Figure 6. As can be seen in these figures, the number of filter banks we chose to use was 20, however different numbers of filter banks can also be used to varying effects.

<p align = "center"> 
  <b>TEST 3</b>
  <br>
  <img src = "https://user-images.githubusercontent.com/74210189/158887221-cfed3bc7-c075-4a3f-bdfa-e1b94ed1a700.png" width = 750>
  <br>
  <em>Figure 5: Mel-Spaced Filterbank</em>
</p>

<p align = "center"> 
  <b>TEST 3</b>
  <br>
  <img src = "https://user-images.githubusercontent.com/74210189/158887778-5c6b9fb8-adcd-4a17-8779-614b3c8aee15.png" width = 750>
  <br>
  <em>Figure 6: Mel-Spectrum </em>
</p>

The last step of the MFCC process is converting the spectrum into a cepstrum. This is done by taking the log of the spectrum and then applying the Discrete Cosine Transform(DCT) to it. What this does is converts the spectrum of the data back to the time domain. What is left at the end of this is the Mel-Frequency Cepstrum Coefficients, which represent an array of accoustic vectors that apply to each speaker. 

<p align = "center"> 
  <br>
  <b>This procedure completes TEST 4 and finishes up MFCC.m.</b>
  <br>
</p>

### C. Vector Quantization (Test 5, Test6)
The accoustic vectors in the MFCC are 20-dimensional and therefore can not be directly observed. However, it is possible to plot two of these dimensions against each other to get an idea of how these vectors are shaped. Figure 7 shows the accoustic vectors for each training set plotted over two dimensions. Figure 8 takes three of these speakers and using the same dimensions, plots them on the same graph. From these plots it can be easily seen that these vectors can look quite different from one speaker to another. 

<p align = "center"> 
  <b>TEST 5</b>
  <br>
  <img src = "https://user-images.githubusercontent.com/74210189/158907846-2b0ef65b-3d35-4dd2-9295-9840fa72cd45.png" width = 750>
  <br>
  <em>Figure 7: All Speakers Plotted Over Two Dimensions </em>
</p>

<p align = "center"> 
  <b>TEST 5</b>
  <br>
  <img src = "https://user-images.githubusercontent.com/74210189/158907967-cebb097e-98c6-47c8-b7eb-25eed42ac801.png" width = 750>
  <br>
  <em>Figure 8: Speakers 3, 5, and 10 Plotted Against Each Other </em>
</p>

To take these MFCC's and identify a speaker from them, a method called Vector Quantization(VQ) is used. What this does is map the accoustic vectors from the MFCC's into different regions called clusters. Each centroid for each cluster is called a codeword, and the collection of these codewords make up a codebook for each speaker. To create these codebooks, the Linde-Buzo-Gray(LBG) algorithm is used. For our program we chose to use 8 codewords to make up each codebook, Figure 9 shows how effective this algoirthm is at finding the codeword for each cluser. Figure 10 shows the codebooks for three different speakers plotted against each other in two dimensions. Both of these plots show how different the codebook for each speaker can be.

<p align = "center"> 
  <b>TEST 6</b>
  <br>
  <img src = "https://user-images.githubusercontent.com/74210189/158909442-fdb9abcb-b882-4876-a0f9-6754f633dc14.png" width = 750>
  <br>
  <em>Figure 9: All Speakers Plotted with Codewords </em>
</p>

<p align = "center"> 
  <b>TEST 6</b>
  <br>
  <img src = "https://user-images.githubusercontent.com/74210189/158909479-e4bc00c9-ff18-4a67-b55d-d3b8bee1e804.png" width = 750>
  <br>
  <em>Figure 10: Codebooks for Speakers 3, 5, and 10 </em>
</p>

### D. Full Test and Demonstration (Test 7, Test 8, Test 9, Test 10)
With the MFCC procedure and LBG algorithm discussed previously it is possible to train the dataset by creating a codebook for each of the initial 11 sound files in the training folder. Then the codebooks for the 8 testing sound files are found. For each test speaker, the total VQ distortion is found between them and the 11 training codebooks. The training codebook that generates the smallest distortion with that speaker is then identified as that speaker. Using this method with the initial 11 trainings files and 8 test files, our program was able to find 6 of the test speakers correctly, giving it an accuracy of 75%. The program is then run again after two new speakers each add a test and training sound file. With the addition of these two new speakers, the accuracy of the systems falls 70% with 7 out of the 10 test speakers being identified from the now 13 training files. These accuracies give the results for TEST 7.


Following these tests the robustness of our system is tested using a notch filter. A notch filter is a type of filter with a narrow stopband that removes certain frequencies from the spectrum. This filter is applied to all of the initial sound files and the system is tested using the previous procedure. The resulting accuracy is shown below in Figure 11. For this, a notch filter with with varying stopband bandwidths is found for four different center frequencies. The results show that the accuracy for the system stays high even with a loss in certain frequency ranges. The accuracy does go down with a large enough stop band however, it has to remove a large portion of the frequency range for that to happen. This means that the system is quite robust.

<p align = "center"> 
  <b>TEST 8</b>
  <br>
  <img src = "https://user-images.githubusercontent.com/74210189/158918411-696a1e55-aebf-4df1-8254-ade6e337e0bc.png" width = 750>
  <br>
  <em>Figure 11: Accuracy with Notch Filter Added
  </em>
</p>

The next test, TEST 9, takes the 13 training files and 10 test files of TEST 7, then replaces two of the speakers with two new speaker. This leaves the total number of speakers the same. The outcome of runing the test on these training and test files gives an accuracy of 80%, which is 8 out of the 10 test speakers identified correctly. This accuracy is higher than that of TEST 7, however around the same range, only guessing one more speaker correctly. 



The last test, TEST 10, involves using new sound files where a different phrase is said. Up until now, all of the sound files have said the word 'zero'. For TEST 10, the new sound files say the word 'eight'. This done is for 10 speakers, with 10 files to train a VQ-codebook and 10 sperate test files to test against against that codebook. The result of this test gives an accuracy of 80%, with the program correctly identifying 8 of the 10 speakers correctly.

### Results and Conclusion
This project gives an effective way to use mel-frequency cepstrum coefficients and vector quantization to achieve speaker recognition. Using a given folder of 11 training files and 8 test files, the speaker is identified 75% of the time. When two more speakers are added to each set that number drops to 70%. This makes sense, because there is now a larger pool of potential codebooks that each test speaker can match to. This program is then proven to be a robust solution to speaker recognition, by filtering out certain speech frequencies and remaining very accurate, only dropping in accuracy when the frequency range being cut out grows very large. After showing the systems robustness, two of the speakers are then replaces with two new speakers and giving an accuracy of 80%. This also makes sense, due to the number of speakers not going up, therefore the number of potential codebooks that each test speaker can match to stays low, giving an accuracy around what was initially found. The last part of this project has the sound files completely replaced with new speakers saying a different phrase. The accuracy of this being at 80%, showing that accuracy of the program does not depend on the word used.
