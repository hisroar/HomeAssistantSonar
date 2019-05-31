clear all;
close all;
fclose all;
%clc

% Define variables
numFile = 9; % To be updated!! (9) *****
mainDir = pwd;
featuresDir = '/ExtractedFeatures';
featuresDirOld = [featuresDir 'Old'];

% Clean up Old instances of ExtractedFeatures --> make ExtractedFeaturesOld folder if does not exist
oldFeatures = fullfile(mainDir,featuresDirOld);
if ~isfolder(oldFeatures)
    mkdir(oldFeatures);
end

% Check if ExtractedFeatures directory already exists --> if so, rename and move to Old folder
eFeatures = fullfile(mainDir,featuresDir);
notCopied = true;
numCount = 1;
if isfolder(eFeatures)
    while notCopied
        efNum = fullfile(mainDir,featuresDirOld,num2str(numCount));
        if ~isfolder(efNum)
            % Rename/move to next available folder number
            movefile(eFeatures, efNum)
            mkdir(eFeatures);
            notCopied = false;
        end
        numCount = numCount + 1;
    end
else
    mkdir(eFeatures);
end

% Run feature extraction for label = 0 data
FeatureExtract(sprintf('trials_nobody_1'), featuresDir, 0);
FeatureExtract(sprintf('trials_nobody_2'), featuresDir, 0);

% Run feature extraction for label = 1 data
FeatureExtract(sprintf('trials_dennis_couch'), featuresDir, 1);
FeatureExtract(sprintf('trials_dennis_couch_sitting'), featuresDir, 1);

% For each feature file (8), perform machine learning algorithm
accuracyFile = fullfile(mainDir,'/ML_Accuracy.txt');
afileID = fopen(accuracyFile, 'w');
fprintf(afileID, 'Report of Cross-Validation Accuracy for ML Classifiers\n\n');

cd(fullfile(mainDir,featuresDir))

features_all = [];
labels_all = [];

for num = 1:numFile      
    % Load data from feature files
    featureFile = sprintf('features%d.txt', num-1);
    featureData = load(featureFile);
    
    % Form feature and label matrices
    features = featureData(:,1:size(featureData,2)-1);
    labels = featureData(:,size(featureData,2));
    
    % Generate a matrix with all features and all labels (labels should all
    % be the same)
    features_all = [features_all, features];
    
    % Define classifier and accuracy matrix --> ML models to be used
    classifier = ["SVM", "KNN"];
    accuracy = zeros(size(classifier));
    
    % Train and cross validate machine learning models --> estimate error and accuracy
    % SVM
    svmMdl = fitcsvm(features, labels);
    svmCvMdl = crossval(svmMdl);
    svmError = kfoldLoss(svmCvMdl);
    accuracy(1,1) = 1 - svmError;
    %disp(accuracy);
    
    % KNN
    knnMdl = fitcknn(features, labels);
    knnCvMdl = crossval(knnMdl);
    knnError = kfoldLoss(knnCvMdl);
    accuracy(1,2) = 1 - knnError;
    %disp(accuracy);
    
    % Print the accuracy to text file
    for c = 1:size(classifier,2)
        fprintf(afileID, '%s CV Accuracy (%d) = %f\n', classifier(1,c), num-1, accuracy(1,c));
    end

end
fclose(afileID);

cd(mainDir)
