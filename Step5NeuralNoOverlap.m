clc;
close all;
clear all;
tic;
%% Importing Data
imageURL = 'D:\DATA\Voice images\ILD images';
labelURL = 'D:\DATA\Voice images\IPD labels';
outputFolder = 'D:\DATA\Voice images';
imgDir = fullfile(outputFolder,'ILD images');
labelDir = fullfile(outputFolder,'IPD labels');

%% Defining Classes and network
imageSize = [1024 64];
numClasses = 2;

classes = [
    "Source_1"
    "Source_2"
    ];
labelIDs   = [255 0];
encoderDepth = 1;
lgraph = unetLayers(imageSize,numClasses,'EncoderDepth',encoderDepth)
plot(lgraph)
%% Defining Classes and network
imageSize = [1024 64];
numClasses = 2;

classes = [
    "Source_1"
    "Source_2"
    ];
labelIDs   = [255 0];
encoderDepth = 1;
lgraph = unetLayers(imageSize,numClasses,'EncoderDepth',encoderDepth)
plot(lgraph)
%% edited
layer2=convolution2dLayer([3 3],64,'Stride',3,'Padding','same','Name','Encoder-Stage-1-Conv-1');
lgraph=replaceLayer(lgraph,'Encoder-Stage-1-Conv-1',layer2);
% layer3=convolution2dLayer([3 3],64,'NumChannels',64,'Stride',3,'Padding','same','Name','Encoder-Stage-1-ReLU-1');
% lgraph=replaceLayer(lgraph,'Encoder-Stage-1-ReLU-1',layer3);
layer4=convolution2dLayer([3 3],128,'NumChannels','auto','Stride',3,'Padding','same','Name','Encoder-Stage-1-Conv-2');
lgraph=replaceLayer(lgraph,'Encoder-Stage-1-Conv-2',layer4);
% layer5=convolution2dLayer([3 3],128,'NumChannels',128,'Stride',3,'Padding','same','Name','Encoder-Stage-1-ReLU-2');
% lgraph=replaceLayer(lgraph,'Encoder-Stage-1-ReLU-2',layer5);
layer16=convolution2dLayer([3 3],128,'NumChannels','auto','Stride',3,'Padding','same','Name','Decoder-Stage-1-Conv-1');
lgraph=replaceLayer(lgraph,'Decoder-Stage-1-Conv-1',layer16);
% layer17=convolution2dLayer([3 3],128,'NumChannels',128,'Stride',3,'Padding','same','Name','Decoder-Stage-1-ReLU-1');
% lgraph=replaceLayer(lgraph,'Decoder-Stage-1-ReLU-1',layer17);
layer18=convolution2dLayer([3 3],64,'NumChannels','auto','Stride',3,'Padding','same','Name','Decoder-Stage-1-Conv-2');
lgraph=replaceLayer(lgraph,'Decoder-Stage-1-Conv-2',layer18);
% layer19=convolution2dLayer([3 3],64,'NumChannels',64,'Stride',3,'Padding','same','Name','Decoder-Stage-1-ReLU-2');
% lgraph=replaceLayer(lgraph,'Decoder-Stage-1-ReLU-2',layer19);
%% current
options = trainingOptions('sgdm', ... % This is the solver's name; sgdm: stochastic gradient descent with momentum
    'Momentum',0.95, ...              % Contribution of the gradient step from the previous iteration to the current iteration of the training; 0 means no contribution from the previous step, whereas a value of 1 means maximal contribution from the previous step.
    'InitialLearnRate', 0.01, ...     % low rate will give long training times and quick rate will give suboptimal results 
    'L2Regularization', 0.0001, ...   % Weight decay - This term helps in avoiding overfitting
    'MaxEpochs', 2,...                 % An iteration is one step taken in the gradient descent algorithm towards minimizing the loss function using a mini batch. An epoch is the full pass of the training algorithm over the entire training set.
    'ExecutionEnvironment', 'gpu', ...     
    'MiniBatchSize', 8, ...           % A mini-batch is a subset of the training set that is used to evaluate the gradient of the loss function and update the weights.
    'Shuffle', 'every-epoch', ...     % Shuffle the training data before each training epoch and shuffle the validation data before each network validation.
    'Verbose', false,...        
    'Plots','training-progress');  

%% DATA STORES
 
imds = imageDatastore('D:\DATA\Voice images\ILD images', 'IncludeSubfolders', false, 'LabelSource', 'foldernames', 'FileExtensions', '.mat', 'ReadFcn', @matRead);
pxds = pixelLabelDatastore(labelDir,classes,labelIDs);

lgraph = segnetLayers(imageSize,numClasses,2)
 pximds = pixelLabelImageDatastore(imds,pxds);
 
%% Helper function for Partition of Training & Testing Data
            rng(0);
            numFiles = numel(imds.Files);
            % Returns a row vector containing a random permutation of the integers from 1 to n inclusive.
            shuffledIndices = randperm(numFiles);
            
            % Use n% of the images for training.
            N = round(0.98 * numFiles);
            trainingIdx = shuffledIndices(1:N);
            
            % Use the rest for testing.
            testIdx = shuffledIndices(N+1:end);
            
            % Create image datastores for training and test.
            trainingImages = imds.Files(trainingIdx);
            testImages = imds.Files(testIdx);
            imdsTrain = imageDatastore(trainingImages,'FileExtensions','.mat');
            imdsTest = imageDatastore(testImages,'FileExtensions','.mat');
            
            % Extract class and label IDs info
            classes = pxds.ClassNames;
%             labelIDs = 1:numel(pxds.ClassNames);
            
            % Create pixel label datastores for training and test.
            trainingLabels = pxds.Files(trainingIdx);
            testLabels = pxds.Files(testIdx);
            pxdsTrain = pixelLabelDatastore(trainingLabels, classes, labelIDs);
            pxdsTest = pixelLabelDatastore(testLabels, classes, labelIDs);
            imdsTrain.ReadFcn=@matRead;
            imdsTest.ReadFcn=@matRead;
            
%% Network Training

numTrainingImages = numel(imdsTrain.Files)
numTestingImages = numel(imdsTest.Files)
 datasource = pixelLabelImageSource(imdsTrain,pxdsTrain);

  net = trainNetwork(datasource,lgraph,options)
  
  
clear imdsTrain;
clear pxdsTrain;
ildnet90=net;
save ildnet90;



  %% NETWORK TESTING
  doTest = true;
if doTest
    pxdsResults = semanticseg(imdsTest,net,'WriteLocation',tempdir,'Verbose',false,'MiniBatchSize',8);
    
    % Evaluate semantic segmentation data set against ground truth
    metrics = evaluateSemanticSegmentation(pxdsResults,pxdsTest,'Verbose',false);
  metrics = evaluateSemanticSegmentation(pxdsResults,pxdsTest,'Verbose',false);
else
    warning off MATLAB:datastoreio:pathlookup:fileNotFound
    load('metrics.mat')
end
metrics.DataSetMetrics
metrics.ClassMetrics
save 'metrics';

toc;