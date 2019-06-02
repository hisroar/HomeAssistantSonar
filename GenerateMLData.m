% Generate data files containing features and corresponding labels
% Requires manual input of trial folder name and corresponding label to FeatureExtract

clear all;
close all;
fclose all;

% Define variables
numFile = 9;
mainDir = pwd;
featuresDir = '/ExtractedFeatures';

% Run feature extraction for label = 0 data
FeatureExtract(sprintf('trials_nobody_1'), featuresDir, 0);
FeatureExtract(sprintf('trials_nobody_2'), featuresDir, 0);

% Run feature extraction for label = 1 data
FeatureExtract(sprintf('trials_dennis_couch'), featuresDir, 1);
FeatureExtract(sprintf('trials_dennis_couch_sitting'), featuresDir, 1);
