% SpeakerTest
SpeakerRecognitionTraining
d1 = 1;
d2 = 3;
s1 = 1;
s2 = 2;

% Test 5 
% Plot two dimensions against each other
for n = 1:TrainingLength(s1)
    dim1(n) = TotalTraining{s1,n}(d1);
end

for n = 1:TrainingLength(s1)
    dim2(n) = TotalTraining{s1,n}(d2);
end

figure(1)
scatter(dim1,dim2)



