%%
%  COURSE NAME: Project & Thesis
%    COURSE NO: ETE 400
% THESIS TITLE: Machine Learning Based Speaker Identification Using Cochleagram
%    OBJECTIVE: To identify speaker under noisy and mismatched conditions
%         DATE: 16 July, 2021
%%
%%
% Set the location of the data
datafolder = 'C:\Users\sabbir\Desktop\yoho_clean\training';

% Create an image datstore containig all the files.
imds = imageDatastore(datafolder,'IncludeSubfolders',true,...
                                 'FileExtensions','.png',...
                                 'LabelSource','foldernames');

%Splitting the images into training and test data
rng(1);
[trainXImgs,validationXImgs] = splitEachLabel(imds, 0.90, 'randomized');

trainYImgs      = trainXImgs.Labels;
validationYImgs = validationXImgs.Labels;

% Creating an augmented image datastore
% Image preprocessing to meet the network requirements
%auds = augmentedImageDatastore([875 656 3],imds);
imageSize = [500, 400, 3];

train_auds      = augmentedImageDatastore(imageSize, trainXImgs);
validation_auds = augmentedImageDatastore(imageSize, validationXImgs);

% Define the layers
numF = 8;
layers = [imageInputLayer(imageSize)
          convolution2dLayer(3, numF, 'Padding', 'same',...
                             'WeightL2Factor', 3,...
                             'BiasL2Factor', 3)
          batchNormalizationLayer
          reluLayer
          
          maxPooling2dLayer(3,'Stride',2,'Padding','same');
          
          convolution2dLayer(3, numF, 'Padding', 'same',...
                             'WeightL2Factor', 3,...
                             'BiasL2Factor', 3)
          batchNormalizationLayer
          reluLayer
          
          maxPooling2dLayer(3,'Stride',2,'Padding','same');
          
          convolution2dLayer(3, 2*numF,'Padding', 'same',...
                             'WeightL2Factor', 3,...
                             'BiasL2Factor', 3)
          batchNormalizationLayer
          reluLayer
                
          maxPooling2dLayer(3,'Stride',2,'Padding','same');
          
          convolution2dLayer(3, 4*numF,'Padding', 'same',...
                             'WeightL2Factor', 3,...
                             'BiasL2Factor', 3)
          batchNormalizationLayer
          reluLayer
                
          maxPooling2dLayer(3,'Stride',2,'Padding','same');
                
          convolution2dLayer(3, 4*numF,'Padding', 'same',...
                             'WeightL2Factor', 3,...
                             'BiasL2Factor', 3)
          batchNormalizationLayer
          reluLayer
          
          fullyConnectedLayer(129)
          softmaxLayer
          classificationLayer];
      
% Adding some trainig options
miniBatchSize = 64;
validationFrequency = floor(numel(trainXImgs.Labels)/miniBatchSize);
train_options = trainingOptions(...
                 'sgdm',...
                 'Plots', 'training-progress',...
                 'InitialLearnRate', 1e-3,...
                 'GradientThreshold',10,...
                 'Shuffle', 'every-epoch',...
                 'Verbose', false,...
                 'MaxEpochs', 20,...
                 'MiniBatchSize', miniBatchSize,...
                 'ValidationData', {validation_auds,validationYImgs},...
                 'ValidationFrequency', validationFrequency,...
                 'L2Regularization', 0.09,...
                 'ExecutionEnvironment', 'gpu');
                            
% Train the network
classifier = trainNetwork(train_auds,layers,train_options);

% Testing network on the test data
preds = classify(classifier,test_auds);

% Checking the accuracy (how many predictions were correct)
correct_preds = nnz(testYImgs == preds)

% Shows the confusion matrix
figure,
confusion_matrix = confusionchart(testYImgs,preds)

% Calculating the accuracy of testing data
testAcc = correct_preds / length(preds);
fprintf('Test data accuracy: %.2f%%\n', testAcc*100)
