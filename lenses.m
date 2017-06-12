clc;
clear all;
data = importdata('lenses.data.txt',' ',0);
[m,n] = size(data);
indices = randperm(m);data = data(indices,:);
%above can be used to randomise the data-set
%% partition training and testing matrix
training = ceil(0.7*m);    testing = m - training;
trainingMatrix = data(1:training,2:n) ; testingMatrix = data(training+1:m,2:n);

%% make frequency table
freqMatrix = zeros(3,12);%colm 1-4 class1, colm 5-8 class2, colm 9-12 class3
classCount = [0 0 0];% index 1 holds count of class1 , index2 of class2, index3 of class3
for i=1:training
    classCount(trainingMatrix(i,5)) = classCount(trainingMatrix(i,5))+1;
    ptr = (trainingMatrix(i,5)-1)*4; 
    freqMatrix(trainingMatrix(i,1),ptr+1) = freqMatrix(trainingMatrix(i,1),ptr+1)+1;
    freqMatrix(trainingMatrix(i,2),ptr+2) = freqMatrix(trainingMatrix(i,2),ptr+2)+1;
    freqMatrix(trainingMatrix(i,3),ptr+3) = freqMatrix(trainingMatrix(i,3),ptr+3)+1;
    freqMatrix(trainingMatrix(i,4),ptr+4) = freqMatrix(trainingMatrix(i,4),ptr+4)+1;
end
P1 = classCount(1)/training; P2 = classCount(2)/training; P3 = classCount(3)/training;%probability of each class
%% take data for testing and classify them
correctPred = 0;%counter for correct classification (prediction)
for i=1:testing
    a = testingMatrix(i,1); b=testingMatrix(i,2);c=testingMatrix(i,3); d=testingMatrix(i,4);
    tmp = [P1 P2 P3];    
    [p,q] = sort(tmp,'descend');
    predClass = q(1);
    
    tmp(1) = tmp(1)*(freqMatrix(a,1)/classCount(1));
    tmp(1) = tmp(1)*(freqMatrix(b,2)/classCount(1));
    tmp(1) = tmp(1)*(freqMatrix(c,3)/classCount(1));
    tmp(1) = tmp(1)*(freqMatrix(d,4)/classCount(1));
    
    tmp(2) = tmp(2)*(freqMatrix(a,5)/classCount(2));
    tmp(2) = tmp(2)*(freqMatrix(b,6)/classCount(2));
    tmp(2) = tmp(2)*(freqMatrix(c,7)/classCount(2));
    tmp(2) = tmp(2)*(freqMatrix(d,8)/classCount(2));
    
    tmp(3) = tmp(3)*(freqMatrix(a,9)/classCount(3));
    tmp(3) = tmp(3)*(freqMatrix(b,10)/classCount(3));
    tmp(3) = tmp(3)*(freqMatrix(c,11)/classCount(3));
    tmp(3) = tmp(3)*(freqMatrix(d,12)/classCount(3));
    
    [p,q] = sort(tmp,'descend');
    % do not change the predicted class if all cond. probabilities are 0
    if p(1)~=0
        predClass = q(1);
    end
    %if prediction is correct add to correct prediction counter
    if predClass == testingMatrix(i,5);
        correctPred=correctPred+1;
    end
        
end
disp(correctPred/testing);
