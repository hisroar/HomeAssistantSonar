% Test misclassification cost implementation and compute confusion matrix (binary)

clear all;
close all;
fclose all;

% Define variables
numFile = 9;
mainDir = pwd;
featuresDir = '/ExtractedFeatures';

% Make file for recording data
dataFile = fullfile(mainDir,'/ML_Cost_Testing.txt');
costID = fopen(dataFile, 'w');

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

% Binary labels matrix
labels_binary = zeros(size(labels,1),1);
for i = 1:size(labels,1)
    if labels(i) >= 1
        labels_binary(i) = 1;
    end
end

% Define Binary classifiers and accuracy matrix (2 classes)
classifier_binary = ["SVM: Gaussian", "SVM: Linear", "SVM: Polynomial", "Random Forest", "KNN"];
accuracy_binary = zeros(size(classifier_binary));

% Loop through possible values for mis0 (misclassify 0) and mis1 (misclassify 1)
for mis0 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    for mis1 = 1:1
        cost = [0, mis0; mis1, 0];
        fprintf(costID, 'Cost:\n[%d %d\n %d %d]\n\n', cost(1,1), cost(1,2), cost(2,1), cost(2,2));
        
        % SVM (Kernel: Linear)
        svmCvMdl = fitcsvm(features, labels_binary, 'KernelFunction', 'linear', 'Cost', cost, 'CrossVal', 'on');
        svmError = kfoldLoss(svmCvMdl);
        accuracy_binary(1,2) = 1 - svmError;
        
        % Compute confusion matrix
        yFitCost = kfoldPredict(svmCvMdl);
        confuse = confusionmat(labels_binary,yFitCost);
        fprintf(costID, 'Confusion Matrix (SVM):\n[%d %d\n %d %d]\n', confuse(1,1), confuse(1,2), confuse(2,1), confuse(2,2));
        fprintf(costID, 'SVM Accuracy: %f\n\n', accuracy_binary(1,2));
        
        % Random Forest (Bagging)
        bagCvMdl = fitcensemble(features, labels_binary, 'Method', 'Bag', 'Cost', cost, 'CrossVal', 'on');
        bagError = kfoldLoss(bagCvMdl);
        accuracy_binary(1,4) = 1 - bagError;
        
        % Compute confusion matrix
        yFitCost = kfoldPredict(bagCvMdl);
        confuse = confusionmat(labels_binary,yFitCost);
        fprintf(costID, 'Confusion Matrix (RF):\n[%d %d\n %d %d]\n', confuse(1,1), confuse(1,2), confuse(2,1), confuse(2,2));
        fprintf(costID, 'RF Accuracy: %f\n\n\n', accuracy_binary(1,4));
    end
end

fclose(costID);
