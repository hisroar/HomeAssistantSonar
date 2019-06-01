% Generate data files containing features and corresponding labels

clear all;
close all;
fclose all;

% Define variables
numFile = 9; % To be updated!! (9) *****
mainDir = pwd;
featuresDir = '/ExtractedFeatures';
featuresDirOld = [featuresDir 'Old'];

% Clean up Old instances of ExtractedFeatures -> make ExtractedFeaturesOld folder if does not exist
oldFeatures = fullfile(mainDir,featuresDirOld);
if ~isfolder(oldFeatures)
    mkdir(oldFeatures);
end

% Check if ExtractedFeatures directory already exists -> if so, rename and move to Old folder
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
