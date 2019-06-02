% [4] Train and test/evaluate ML models using generated data (after GenerateFeatureMatrix)

clear all;
close all;
fclose all;

% Define variables
numFile = 9;
mainDir = pwd;
featuresDir = '/ExtractedFeatures';

% For each feature file (9), perform machine learning algorithm and report accuracy
accuracyFile = fullfile(mainDir,'/ML_Accuracy.txt');
afileID = fopen(accuracyFile, 'w');
fprintf(afileID, 'Report of Cross-Validation Accuracy for ML Classifiers\n\n');
   
% Load data from feature_all file
allFeatureFile = fullfile(mainDir,featuresDir,'/features_all.csv');
allFeatureData = load(allFeatureFile);

% Form feature/label matrices for ML evaluation
features = allFeatureData(:,1:size(allFeatureData,2)-1);
labels = allFeatureData(:,size(allFeatureData,2));

% Define classifier and accuracy matrix -> ML models to be used
classifier = ["SVM", "KNN"];
accuracy = zeros(size(classifier));

% Train and cross validate machine learning models -> estimate error and accuracy
% SVM
svmMdl = fitcsvm(features, labels);
svmCvMdl = crossval(svmMdl);
svmError = kfoldLoss(svmCvMdl);
accuracy(1,1) = 1 - svmError;

% KNN
knnMdl = fitcknn(features, labels);
knnCvMdl = crossval(knnMdl);
knnError = kfoldLoss(knnCvMdl);
accuracy(1,2) = 1 - knnError;

% Print the accuracy to text file
for c = 1:size(classifier,2)
    fprintf(afileID, '%s CV Accuracy = %f\n', classifier(1,c), accuracy(1,c));
end

fclose(afileID);
cd(mainDir)
