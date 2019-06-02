% [3] Generate combined feature/label matrix to be used in ML evaluation (after GenerateMLData)

clear all;
close all;
fclose all;

% Define variables
numFile = 9;
mainDir = pwd;
featuresDir = '/ExtractedFeatures';

cd(fullfile(mainDir,featuresDir))

% Define feature/label matrix for all mic's combined
features_all = [];
changedData = true;

% Check if features_all is unchanged from last run (no new data - num rows are same)
unpruneFile = fullfile(mainDir,featuresDir,'/features_unpruned.csv');
if isfile(unpruneFile)
    % Load data from unpruned file and compute number of data points
    unpruneData = load(unpruneFile);
    unpruneDataRows = size(unpruneData,1);
    
    % Loop through all files with name 'features0_' (sufficient to check only mic 0)
    files = dir(sprintf('features%d_*.csv', 0));
    featureDataRows = 0;
    for featureFile = files'
        % Load data from feature files and compute number of data points
        featureData = load(featureFile.name);
        featureDataRows = featureDataRows + size(featureData,1);
    end
    
    % If now new data, update toggle
    if unpruneDataRows == featureDataRows
        changedData = false;
    end
end

% Only run feature matrix formation if there is new data
if changedData == true
    for num = 1:numFile      
        % Define/reset feature and label matrices
        features = [];
        labels = [];

        % Loop through all files with name 'features%d_' (where %d is the output mic #)
        files = dir(sprintf('features%d_*.csv', num-1));
        for featureFile = files'
            % Load data from feature files
            featureData = load(featureFile.name);

            % Vertically concatenate to form feature/label matrices
            features = vertcat(features, featureData(:,1:size(featureData,2)-1));
            labels = vertcat(labels, featureData(:,size(featureData,2)));
        end

        % Horizontally concatenate to form matrix with all features
        features_all = [features_all, features];

    end

    % Append labels as last column to features_all matrix (labels should all be the same)
    features_all = [features_all, labels];
    
    % Save feature_all matrix to csv file (unpruned)
    unpruneFile = fullfile(mainDir,featuresDir,'/features_unpruned.csv');
    if isfile(unpruneFile)
        delete(unpruneFile); % If file already exists, delete and make new one
    end
    csvwrite(unpruneFile, features_all);
    
    % Perform feature selection on feature_all to get pruned feature matrix -> pick numSelect top features
    cd(mainDir)
    numSelect = 50;
    features_pruned = FeatureSelect(features_all, numSelect);

    % Save feature/label matrix to csv file
    allFeatureFile = fullfile(mainDir,featuresDir,'/features_all.csv');
    if isfile(allFeatureFile)
        delete(allFeatureFile); % If file already exists, delete and make new one
    end
    csvwrite(allFeatureFile, features_pruned);
else
    % Otherwise, features_all matrix is same as previously computed
    % -> pruned matrix is same (don't re-compute feature selection)
    changedData = true; % Reset changedData toggle
    cd(mainDir)
end

% Save workspace variables to mat file
matFile = 'GenerateFeatureMatrix.mat';
save(matFile);
