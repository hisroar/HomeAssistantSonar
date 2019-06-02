% Setup or clean up ExtractedFeatures folders (only need to do once)

clear all;
close all;
fclose all;

% Define variables
numFile = 9;
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
