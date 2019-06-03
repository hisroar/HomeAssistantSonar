% [2] Generate data files containing features and corresponding labels (for each mic #)
% Requires manual input of trial folder name and corresponding label to FeatureExtract

clear all;
close all;
fclose all;

% Define variables
numFile = 9;
mainDir = pwd;
featuresDir = '/ExtractedFeatures';

% Run feature extraction for label = 0 data
FeatureExtract(sprintf('trials_nobody_1'), featuresDir, 0); % 100 trials
FeatureExtract(sprintf('trials_nobody_2'), featuresDir, 0); % 100 trials
FeatureExtract(sprintf('trials_furniture_1'), featuresDir, 0); % 50 trials
FeatureExtract(sprintf('trials_furniture_2'), featuresDir, 0); % 100 trials
FeatureExtract(sprintf('trials_furniture_3'), featuresDir, 0); % 105 trials

% Run feature extraction for label = 1 data (binary classification)
% Sublabel 1.1 -> label = 1
FeatureExtract(sprintf('trials_dennis_couch'), featuresDir, 1); % 100 trials
FeatureExtract(sprintf('trials_dennis_couch_sitting'), featuresDir, 1); % 100 trials
FeatureExtract(sprintf('trials_front'), featuresDir, 1); % 200 trials

% Sublabel 1.2 -> label = 2
FeatureExtract(sprintf('trials_behind'), featuresDir, 2); % 100 trials

% Sublabel 1.3 -> label = 3
FeatureExtract(sprintf('trials_right'), featuresDir, 3); % 200 trials

% Sublabel 1.4 -> label = 4
FeatureExtract(sprintf('trials_left'), featuresDir, 4); % 200 trials
