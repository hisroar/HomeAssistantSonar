clear all
close all
clc

% Define variables
numFile = 1; % To be updated!! *****

% Clean up Old instances of ExtractedFeatures --> make ExtractedFeaturesOld folder if does not exist
oldFeatures = ('/Users/seraphinegoh/Documents/MATLAB/EE209AS/ExtractedFeaturesOld');
if ~isfolder(oldFeatures)
    mkdir ExtractedFeaturesOld
end

% Check if ExtractedFeatures directory already exists --> if so, rename and move to Old folder
eFeatures = ('/Users/seraphinegoh/Documents/MATLAB/EE209AS/ExtractedFeatures');
notCopied = true;
numCount = 1;
if isfolder(eFeatures)
    while notCopied
        efNum = sprintf('/Users/seraphinegoh/Documents/MATLAB/EE209AS/ExtractedFeaturesOld/%d', numCount);
        if ~isfolder(efNum)
            % Rename/move to next available folder number
            movefile(eFeatures, efNum)
            notCopied = false;
        end
        numCount = numCount + 1;
    end
end

% Run feature extraction for label = 0 data
FeatureExtract(sprintf('Trials0'), 0);

% Run feature extraction for label = 1 data
FeatureExtract(sprintf('Trials1'), 1);

% Move extracted feature files to new directory
cd /Users/seraphinegoh/Documents/MATLAB/EE209AS
mkdir /Users/seraphinegoh/Documents/MATLAB/EE209AS/ExtractedFeatures
cd /Users/seraphinegoh/Documents/MATLAB/EE209AS/
for num = 1:numFile      
    fileNameFormat = sprintf('features%d_format.txt', num-1);
    movefile(fileNameFormat,"/Users/seraphinegoh/Documents/MATLAB/EE209AS/ExtractedFeatures")
    % Unformatted version
    fileName = sprintf('features%d.txt', num-1);
    movefile(fileName,"/Users/seraphinegoh/Documents/MATLAB/EE209AS/ExtractedFeatures")
end

% For each feature file (8), perform machine learning algorithm
cd /Users/seraphinegoh/Documents/MATLAB/EE209AS/ExtractedFeatures
for num = 1:numFile      
    % Load data from feature files
    featureFile = sprintf('features%d.txt', num-1);
    featureData = load(featureFile);
    
    % Form feature and label matrices
    features = featureData(:,1:size(featureData,2)-1);
    labels = featureData(:,size(featureData,2));
    
    % Define classifier and accuracy matrix --> ML models to be used
    classifier = ["SVM", "KNN"];
    accuracy = zeros(size(classifier));
    
    % Train and cross validate machine learning models --> estimate error and accuracy
    % SVM
    svmMdl = fitcsvm(features, labels);
    svmCvMdl = crossval(svmMdl);
    svmError = kfoldLoss(svmCvMdl);
    accuracy(1,1) = 1 - svmError;
    disp(accuracy);
    
    % KNN
    knnMdl = fitcknn(features, labels);
    knnCvMdl = crossval(knnMdl);
    knnError = kfoldLoss(knnCvMdl);
    accuracy(1,2) = 1 - knnError;
    disp(accuracy);
    
    % Print the accuracy to text file
    accuracyFile = sprintf('/Users/seraphinegoh/Documents/MATLAB/EE209AS/ML_Accuracy.txt');
    % Create new file if does not exist
    if ~isfile(accuracyFile)
        afileID = fopen(accuracyFile, 'w');
        % Print title row at top of file
        fprintf(afileID, 'Report of Cross-Validation Accuracy for ML Classifiers\n\n');
        % Print accuracies
        for c = 1:size(classifier,2)
            fprintf(afileID, '%s CV Accuracy = %f\n', classifier(1,c), accuracy(1,c));
        end
        fclose(afileID);
    else
        afileID = fopen(accuracyFile, 'a');
        % Print accuracies
        for c = 1:size(classifier,2)
            fprintf(afileID, '%s CV Accuracy = %f\n', classifier(1,c), accuracy(1,c));
        end
        fclose(afileID);
    end
end

cd /Users/seraphinegoh/Documents/MATLAB/EE209AS/
