% [Funct] Function that extracts features for given data and saves to corresponding features file

% void FeatureExtract(str dataFolder, int label)
function FeatureExtract(dataFolder, featuresDir, label)

% Define variables
mainDir = pwd;
numFile = 9; 
numWindows = 8; 

% If Trials directory does not exist, return error message and quit
TrialFolder = fullfile(mainDir,dataFolder);
if ~isfolder(TrialFolder)
    fprintf('Error: The %s directory does not exist.\n', dataFolder);
    return;
end

% If feature file exists for given trial, exit the function (sufficient to only check for mic #0)
fileNameCheck = fullfile(mainDir,featuresDir,sprintf('/features%d_%s.csv', 0, dataFolder));
if isfile(fileNameCheck)
    return;
end

% Compute the number of trials in given data folder (count subfolders in trial directory)
dataDir = dir(TrialFolder);
numTrials = sum([dataDir.isdir]) - 2;

% For each trial, load the .wav files for feature extraction
invalidDetected = false;
for t = 1:numTrials
    trial_dir = fullfile(mainDir,dataFolder,num2str(t));
    
    % Check for any invalid audio files (TotalSamples = 0 or < 65500)
    for i = 1:numFile
        % Create path to audio file for output(i-1).wav
        outputNum = sprintf('output%d.wav', i-1);
        audioFile = fullfile(trial_dir, outputNum);
        
        % Check that audio file is valid (TotalSamples != 0 and > 65500)
        info = audioinfo(audioFile);
        if info.TotalSamples == 0 || info.TotalSamples < 65500
            invalidDetected = true; % Set toggle - go to next trial
        end
    end
    
    % Loop through each audio file (9)
    for i = 1:numFile
        % Go to next trial if any invalid audio files detected
        if invalidDetected == true
            invalidDetected = false;
            break;
        end
        
        % Open csv file for recording extracted features (named according to output mic # and trial name)
        fileName = fullfile(mainDir,featuresDir,sprintf('/features%d_%s.csv', i-1, dataFolder));
        fileID = fopen(fileName, 'a');

        % Create path to audio file for output(i-1).wav
        outputNum = sprintf('output%d.wav', i-1);
        audioFile = fullfile(trial_dir, outputNum);
        
        % Read audio file -> output is data, sampling rate
        [data,rate] = audioread(audioFile);
        
        % Split data into windows (8)
        stepSize = ceil(length(data)/numWindows);
        index = 1;
        for win = 1:numWindows
            % Check that data index not exceeded -> assign to max index if exceeded
            if (index-1)+stepSize > length(data)
                iStart = index;
                iEnd = length(data);
            else
                iStart = index;
                iEnd = (index-1)+stepSize;
            end
            
            % Compute current data segment
            currData = data(iStart:iEnd);
            
            % Exract features and write to text file
            features = [mean(currData),median(currData),std(currData),max(currData),skewness(currData),kurtosis(currData)];
            for feature = features
                fprintf(fileID, '%f,', feature);
            end
            
            % Computation for MFCC feature -> extract and write to text file
            mfccWindows = 5;
            windowLength = ceil(size(currData,1)/mfccWindows);
            overlapLength = rate*0.02; % default
            coeffs = mfcc(currData, rate, windowLength, overlapLength);
            for c_row = 1:size(coeffs,1)
                for c_col = 1:size(coeffs,2)
                    fprintf(fileID, '%f,', coeffs(c_row,c_col));
                end
            end
            
            % Increment data index
            index = index + stepSize;
        end
        
        % Write label value (features for all windows = 1 row per trial)
        fprintf(fileID, '%d', label);
        fprintf(fileID, '\n');
        
        % End recording of extracted feature for given output file
        fclose(fileID);
    end
end
end
