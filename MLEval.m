% Train and test (evaluate) ML models using generated data

clear all;
close all;
fclose all;

% Define variables
numFile = 9; % To be updated!! (9) *****
mainDir = pwd;
featuresDir = '/ExtractedFeatures';

% For each feature file (9), perform machine learning algorithm
accuracyFile = fullfile(mainDir,'/ML_Accuracy.txt');
afileID = fopen(accuracyFile, 'w');
fprintf(afileID, 'Report of Cross-Validation Accuracy for ML Classifiers\n\n');

cd(fullfile(mainDir,featuresDir))

features_all = [];
labels_all = [];

for num = 1:numFile      
    % Load data from feature files (.csv)
    featureFile = sprintf('features%d.csv', num-1);
    featureData = load(featureFile);
    
    % Form feature and label matrices
    features = featureData(:,1:size(featureData,2)-1);
    labels = featureData(:,size(featureData,2));
    
    % Generate a matrix with all features and all labels (labels should all be the same)
    features_all = [features_all, features];
    
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
        fprintf(afileID, '%s CV Accuracy (%d) = %f\n', classifier(1,c), num-1, accuracy(1,c));
    end

end
fclose(afileID);

cd(mainDir)
