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

% Check if feature_all file exists, return error and exit if not
allFeatureFile = fullfile(mainDir,featuresDir,'/features_all.csv');
if ~isfile(allFeatureFile)
    fprintf('Error: The feature_all.csv file does not exist.\n');
    return; % Exit the script
end
% Load data from feature_all file
allFeatureData = load(allFeatureFile);

% Form feature/label matrices for ML evaluation
features = allFeatureData(:,1:size(allFeatureData,2)-1);
labels = allFeatureData(:,size(allFeatureData,2));

% Unpruned feature matrix (labels should be the same)
unPrunedFile = fullfile(mainDir,featuresDir,'/features_unpruned.csv');
unPrunedData = load(unPrunedFile);
features_unpruned = unPrunedData(:,1:size(unPrunedData,2)-1);

% Binary labels matrix
labels_binary = zeros(size(labels,1),1);
for i = 1:size(labels,1)
    if labels(i) >= 1
        labels_binary(i) = 1;
    end
end

% Define classifier and accuracy matrix -> ML models to be used
classifier = ["Multi-Class SVM", "AdaboostM2", "Random Forest", "Subspace", "RUSBoost", "LPBoost", "TotalBoost"];
accuracy = zeros(size(classifier));

% Train and cross validate machine learning models -> estimate error and accuracy
% Multi-Class SVM (ECOC) [top 2]
mcSvmMdl = fitcecoc(features, labels);
mcSvmCvMdl = crossval(mcSvmMdl);
mcSvmError = kfoldLoss(mcSvmCvMdl);
accuracy(1,1) = 1 - mcSvmError;

% AdaboostM2 (Boosting - default) [top 3]
boostMdl = fitcensemble(features, labels);
boostCvMdl = crossval(boostMdl);
boostError = kfoldLoss(boostCvMdl);
accuracy(1,2) = 1 - boostError;

% Random Forest (Bagging) [top 1]
bagMdl = fitcensemble(features, labels, 'Method', 'Bag');
bagCvMdl = crossval(bagMdl);
bagError = kfoldLoss(bagCvMdl);
accuracy(1,3) = 1 - bagError;

% Subspace
subspaceMdl = fitcensemble(features, labels, 'Method', 'Subspace');
subspaceCvMdl = crossval(subspaceMdl);
subspaceError = kfoldLoss(subspaceCvMdl);
accuracy(1,4) = 1 - subspaceError;

% RUSBoost
rusBoostMdl = fitcensemble(features, labels, 'Method', 'RUSBoost');
rusBoostCvMdl = crossval(rusBoostMdl);
rusBoostError = kfoldLoss(rusBoostCvMdl);
accuracy(1,5) = 1 - rusBoostError;

% LPBoost (w/ optimization toolkit)
% lpBoostMdl = fitcensemble(features, labels, 'Method', 'LPBoost');
% lpBoostCvMdl = crossval(lpBoostMdl);
% lpBoostError = kfoldLoss(lpBoostCvMdl);
% accuracy(1,6) = 1 - lpBoostError;
% 
% % TotalBoost (w/ optimization toolkit)
% totalBoostMdl = fitcensemble(features, labels, 'Method', 'TotalBoost');
% totalBoostCvMdl = crossval(totalBoostMdl);
% totalBoostError = kfoldLoss(totalBoostCvMdl);
% accuracy(1,7) = 1 - totalBoostError;

% Binary classifiers (2 classes)
% classifier = ["SVM", "Random Forest", "KNN"];
% accuracy = zeros(size(classifier));
% % SVM
% svmMdl = fitcsvm(features, labels_binary);
% svmCvMdl = crossval(svmMdl);
% svmError = kfoldLoss(svmCvMdl);
% accuracy(1,1) = 1 - svmError; 
% % Random Forest (Bagging)
% bagMdl = fitcensemble(features, labels_binary, 'Method', 'Bag');
% bagCvMdl = crossval(bagMdl);
% bagError = kfoldLoss(bagCvMdl);
% accuracy(1,2) = 1 - bagError;
% % KNN
% knnMdl = fitcknn(features, labels_binary);
% knnCvMdl = crossval(knnMdl);
% knnError = kfoldLoss(knnCvMdl);
% accuracy(1,3) = 1 - knnError;

% Print the accuracy to text file
for c = 1:size(classifier,2)
    fprintf(afileID, '%s CV Accuracy = %f\n', classifier(1,c), accuracy(1,c));
end

fclose(afileID);
cd(mainDir)

% Save workspace variables to mat file
matFile = 'MLEval.mat';
if isfile(matFile)
    delete(matFile); % If file already exists, delete and make new one
end
save(matFile);
